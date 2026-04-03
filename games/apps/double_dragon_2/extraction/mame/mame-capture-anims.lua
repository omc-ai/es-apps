local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/anims/"
os.execute("mkdir -p " .. outdir)
local frame = 0

function dump(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local sp = cpu.spaces["program"]
  -- Dump sprite RAM and entity RAM only (fast)
  local f = io.open(outdir .. suffix .. ".bin", "wb")
  if f then
    -- $0000-$05FF (entities) + $2800-$2FFF (sprites) + $3C00-$3FFF (palette)
    for addr = 0x0000, 0x05FF do f:write(string.char(sp:read_u8(addr))) end
    for addr = 0x2800, 0x2FFF do f:write(string.char(sp:read_u8(addr))) end
    for addr = 0x3C00, 0x3FFF do f:write(string.char(sp:read_u8(addr))) end
    f:close()
  end
  manager.machine.video:snapshot()
end

function press(field_name, val)
  for tag, port in pairs(manager.machine.ioport.ports) do
    for name, field in pairs(port.fields) do
      if name == field_name then field:set_value(val) return end
    end
  end
end

emu.register_frame_done(function()
  frame = frame + 1
  
  -- Boot sequence: coin + start
  if frame == 30 then press("Coin 1", 1) end
  if frame == 40 then press("Coin 1", 0) end
  if frame == 60 then press("1 Player Start", 1) end
  if frame == 70 then press("1 Player Start", 0) end
  -- Skip intro screens
  for _, t in ipairs({200,400,600,800}) do
    if frame == t then press("1 Player Start", 1) end
    if frame == t+10 then press("1 Player Start", 0) end
  end
  
  -- IDLE poses (standing still)
  if frame == 1000 then dump("idle_1") end
  if frame == 1010 then dump("idle_2") end
  if frame == 1020 then dump("idle_3") end
  if frame == 1030 then dump("idle_4") end
  
  -- WALK RIGHT
  if frame >= 1100 and frame <= 1300 then press("P1 Right", 1) end
  if frame == 1301 then press("P1 Right", 0) end
  if frame == 1120 then dump("walk_1") end
  if frame == 1140 then dump("walk_2") end
  if frame == 1160 then dump("walk_3") end
  if frame == 1180 then dump("walk_4") end
  if frame == 1200 then dump("walk_5") end
  if frame == 1220 then dump("walk_6") end
  if frame == 1240 then dump("walk_7") end
  if frame == 1260 then dump("walk_8") end
  
  -- PUNCH
  if frame == 1400 then press("P1 Button 1", 1) end
  if frame == 1405 then press("P1 Button 1", 0) end
  if frame == 1402 then dump("punch_1") end
  if frame == 1406 then dump("punch_2") end
  if frame == 1410 then dump("punch_3") end
  if frame == 1415 then dump("punch_4") end
  if frame == 1420 then dump("punch_5") end
  if frame == 1425 then dump("punch_6") end
  
  -- KICK
  if frame == 1500 then press("P1 Button 2", 1) end
  if frame == 1505 then press("P1 Button 2", 0) end
  if frame == 1502 then dump("kick_1") end
  if frame == 1506 then dump("kick_2") end
  if frame == 1510 then dump("kick_3") end
  if frame == 1515 then dump("kick_4") end
  if frame == 1520 then dump("kick_5") end
  
  -- JUMP
  if frame == 1600 then press("P1 Button 3", 1) end
  if frame == 1605 then press("P1 Button 3", 0) end
  for i = 0, 10 do
    if frame == 1600 + i * 3 then dump("jump_" .. (i+1)) end
  end
  
  -- WALK LEFT
  if frame >= 1700 and frame <= 1800 then press("P1 Left", 1) end
  if frame == 1801 then press("P1 Left", 0) end
  if frame == 1720 then dump("walkleft_1") end
  if frame == 1740 then dump("walkleft_2") end
  if frame == 1760 then dump("walkleft_3") end
  
  -- More idles after returning
  if frame == 1900 then dump("idle_late_1") end
  if frame == 1910 then dump("idle_late_2") end
  if frame == 1920 then dump("idle_late_3") end
  if frame == 1930 then dump("idle_late_4") end
  
  if frame == 2000 then print("All animation captures done") end
end)
print("Animation capture script loaded")
