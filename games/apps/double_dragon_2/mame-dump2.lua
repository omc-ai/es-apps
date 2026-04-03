local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/"
os.execute("mkdir -p " .. outdir)
local frame = 0

function dump_memory(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local space = cpu.spaces["program"]
  local regions = {
    { name = "ram",     start = 0x0000, size = 0x1000 },
    { name = "sprites", start = 0x1000, size = 0x0800 },
    { name = "palette", start = 0x1800, size = 0x0800 },
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
  print("Dump saved: " .. suffix .. " at frame " .. frame)
end

function press(name_match, val)
  for tag, port in pairs(manager.machine.ioport.ports) do
    for name, field in pairs(port.fields) do
      if string.find(string.lower(name), name_match) then
        field:set_value(val)
      end
    end
  end
end

emu.register_frame_done(function()
  frame = frame + 1
  -- Coin at frame 30
  if frame == 30 then press("coin 1", 1) end
  if frame == 40 then press("coin 1", 0) end
  -- Start at frame 60
  if frame == 60 then press("1 player start", 1) end
  if frame == 70 then press("1 player start", 0) end
  -- Another start at 300 to skip intro
  if frame == 300 then press("1 player start", 1) end
  if frame == 310 then press("1 player start", 0) end
  -- Skip more at 600
  if frame == 600 then press("1 player start", 1) end
  if frame == 610 then press("1 player start", 0) end
  -- Walk right at 900-1000
  if frame >= 900 and frame <= 1000 then press("p1 right", 1) end
  if frame == 1001 then press("p1 right", 0) end
  -- Punch at 1050
  if frame == 1050 then press("p1 button 1", 1) end
  if frame == 1060 then press("p1 button 1", 0) end
  -- Dump at various late points
  if frame == 800 then dump_memory("late1") end
  if frame == 1000 then dump_memory("late2") end
  if frame == 1100 then dump_memory("late3") end
  if frame == 1500 then dump_memory("late4") end
  if frame == 2000 then dump_memory("late5") end
  if frame == 2400 then dump_memory("late6") end
  if frame == 2400 then print("All dumps complete") end
end)
print("DD2 dump v2 loaded")
