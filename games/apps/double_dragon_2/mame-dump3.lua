local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local gameplay_started = false

function dump_all(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local space = cpu.spaces["program"]
  -- Dump everything from 0x0000 to 0x3FFF (full addressable RAM + IO)
  local f = io.open(outdir .. "full_" .. suffix .. ".bin", "wb")
  if f then
    for addr = 0x0000, 0x3FFF do
      f:write(string.char(space:read_u8(addr)))
    end
    f:close()
  end
  -- Also save screenshot
  manager.machine.video:snapshot()
  print("DUMP " .. suffix .. " at frame " .. frame)
end

emu.register_frame_done(function()
  frame = frame + 1
  
  -- At frame 10, use ioport directly to insert coin
  if frame == 10 then
    print("=== INSERTING COIN ===")
    local p2 = manager.machine.ioport.ports[":P2"]
    if p2 then
      local coin = p2.fields["Coin 1"]
      if coin then
        print("Found Coin 1, pressing...")
        coin:set_value(1)
      else
        print("Coin 1 field not found! Fields:")
        for n, f in pairs(p2.fields) do print("  " .. n) end
      end
    else
      print("Port :P2 not found!")
    end
  end
  if frame == 20 then
    local p2 = manager.machine.ioport.ports[":P2"]
    if p2 and p2.fields["Coin 1"] then p2.fields["Coin 1"]:set_value(0) end
    print("Coin released")
  end
  
  -- Start at frame 40
  if frame == 40 then
    print("=== PRESSING START ===")
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 then
      local start = p1.fields["1 Player Start"]
      if start then
        print("Found 1P Start, pressing...")
        start:set_value(1)
      else
        print("Start field not found! Fields:")
        for n, f in pairs(p1.fields) do print("  " .. n) end
      end
    end
  end
  if frame == 50 then
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 and p1.fields["1 Player Start"] then p1.fields["1 Player Start"]:set_value(0) end
    print("Start released")
  end
  
  -- Press start again at 200, 400, 600, 800 to skip any screens
  for _, t in ipairs({200,400,600,800}) do
    if frame == t then
      local p1 = manager.machine.ioport.ports[":P1"]
      if p1 and p1.fields["1 Player Start"] then 
        p1.fields["1 Player Start"]:set_value(1)
        print("Start pressed at frame " .. frame)
      end
    end
    if frame == t + 10 then
      local p1 = manager.machine.ioport.ports[":P1"]
      if p1 and p1.fields["1 Player Start"] then p1.fields["1 Player Start"]:set_value(0) end
    end
  end
  
  -- Walk right from frame 1000-1200
  if frame == 1000 then
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 and p1.fields["P1 Right"] then p1.fields["P1 Right"]:set_value(1) end
  end
  if frame == 1200 then
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 and p1.fields["P1 Right"] then p1.fields["P1 Right"]:set_value(0) end
  end
  
  -- Punch at 1300
  if frame == 1300 then
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 and p1.fields["P1 Button 1"] then p1.fields["P1 Button 1"]:set_value(1) end
  end
  if frame == 1310 then
    local p1 = manager.machine.ioport.ports[":P1"]
    if p1 and p1.fields["P1 Button 1"] then p1.fields["P1 Button 1"]:set_value(0) end
  end
  
  -- Dumps at various points
  if frame == 120 then dump_all("f0120") end
  if frame == 500 then dump_all("f0500") end
  if frame == 900 then dump_all("f0900") end
  if frame == 1100 then dump_all("f1100") end
  if frame == 1250 then dump_all("f1250") end
  if frame == 1350 then dump_all("f1350_punch") end
  if frame == 1800 then dump_all("f1800") end
  if frame == 2400 then dump_all("f2400") end
  
  if frame == 2400 then print("=== ALL DONE ===") end
end)
print("DD2 dump v3 - direct port access")
