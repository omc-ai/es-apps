-- DD2 MAME Memory Dump Script
-- Launches the game, inserts coin, starts, then dumps:
-- 1. Full RAM ($0000-$0FFF) - entity data, game state
-- 2. Sprite RAM ($1000-$17FF) - hardware sprite entries
-- 3. Palette RAM ($1800-$1FFF) - color data
-- 4. Tilemap RAM ($2000-$37FF)
-- 5. Screenshots at key moments

local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/"
os.execute("mkdir -p " .. outdir)

local frame = 0
local state = "boot"
local dump_count = 0

function dump_memory(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local space = cpu.spaces["program"]

  -- Dump RAM regions
  local regions = {
    { name = "ram",     start = 0x0000, size = 0x1000 },
    { name = "sprites", start = 0x1000, size = 0x0800 },
    { name = "palette", start = 0x1800, size = 0x0800 },
    { name = "bgmap",   start = 0x2000, size = 0x0800 },
    { name = "fgmap",   start = 0x2800, size = 0x0800 },
    { name = "charmap", start = 0x3000, size = 0x0800 },
  }

  for _, r in ipairs(regions) do
    local f = io.open(outdir .. r.name .. "_" .. suffix .. ".bin", "wb")
    if f then
      for addr = r.start, r.start + r.size - 1 do
        f:write(string.char(space:read_u8(addr)))
      end
      f:close()
    end
  end

  -- Also save a screenshot
  emu.wait(0.01)
  manager.machine.video:snapshot()

  dump_count = dump_count + 1
  print("Dump " .. dump_count .. " saved: " .. suffix)
end

-- Port access for inserting coin and pressing start
function press_key(port_tag, mask, duration)
  local port = manager.machine.ioport.ports[port_tag]
  if port then
    for name, field in pairs(port.fields) do
      if field.mask == mask then
        field:set_value(1)
        emu.wait(duration or 0.1)
        field:set_value(0)
        return true
      end
    end
  end
  return false
end

-- List all input ports for debugging
function list_ports()
  print("=== Input Ports ===")
  for tag, port in pairs(manager.machine.ioport.ports) do
    print("Port: " .. tag)
    for name, field in pairs(port.fields) do
      print("  " .. name .. " mask=" .. string.format("0x%x", field.mask))
    end
  end
end

-- Main update callback
emu.register_frame_done(function()
  frame = frame + 1

  if frame == 60 then
    -- After 1 second: list ports for debugging
    list_ports()
  end

  if frame == 120 then
    -- After 2 seconds: dump title screen
    dump_memory("title")
    print("Title screen dump done")
  end

  if frame == 60 then
    -- Insert coin early
    print("Inserting coin...")
    -- Try common coin input
    local ports = manager.machine.ioport.ports
    for tag, port in pairs(ports) do
      for name, field in pairs(port.fields) do
        local lname = string.lower(name)
        if string.find(lname, "coin") and string.find(lname, "1") then
          print("  Found coin: " .. tag .. " / " .. name)
          field:set_value(1)
        end
      end
    end
  end

  if frame == 70 then
    -- Release coin
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if string.find(string.lower(name), "coin") then
          field:set_value(0)
        end
      end
    end
  end

  if frame == 90 then
    -- Press start
    print("Pressing start...")
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        local lname = string.lower(name)
        if string.find(lname, "start") and string.find(lname, "1") then
          print("  Found start: " .. tag .. " / " .. name)
          field:set_value(1)
        end
      end
    end
  end

  if frame == 100 then
    -- Release start
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if string.find(string.lower(name), "start") then
          field:set_value(0)
        end
      end
    end
  end

  -- Press start again at frame 300 (in case first didn't register during attract)
  if frame == 300 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        local lname = string.lower(name)
        if string.find(lname, "coin") and string.find(lname, "1") then field:set_value(1) end
      end
    end
  end
  if frame == 310 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if string.find(string.lower(name), "coin") then field:set_value(0) end
      end
    end
  end
  if frame == 330 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        local lname = string.lower(name)
        if string.find(lname, "start") and string.find(lname, "1") then field:set_value(1) end
      end
    end
  end
  if frame == 340 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if string.find(string.lower(name), "start") then field:set_value(0) end
      end
    end
  end

  -- Move player right to trigger enemy spawns
  if frame >= 600 and frame <= 660 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if name == "P1 Right" then field:set_value(1) end
      end
    end
  end
  if frame == 661 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if name == "P1 Right" then field:set_value(0) end
      end
    end
  end

  -- Do a punch at frame 700
  if frame == 700 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if name == "P1 Button 1" then field:set_value(1) end
      end
    end
  end
  if frame == 710 then
    for tag, port in pairs(manager.machine.ioport.ports) do
      for name, field in pairs(port.fields) do
        if name == "P1 Button 1" then field:set_value(0) end
      end
    end
  end

  -- Dump during actual gameplay (after enough time for game to start)
  if frame == 500 then dump_memory("gameplay_1") end
  if frame == 600 then dump_memory("gameplay_2") end
  if frame == 680 then dump_memory("gameplay_3") end
  if frame == 720 then dump_memory("gameplay_4_punch") end
  if frame == 780 then dump_memory("gameplay_5") end

  -- After all dumps
  if frame == 840 then
    print("=== All dumps complete ===")
    print("Dumps saved to: " .. outdir)
    print("Total dumps: " .. dump_count)
    -- Don't auto-exit, let user see the game
  end
end)

print("DD2 Memory Dump Script loaded. Will dump at frames 120, 420-660.")
