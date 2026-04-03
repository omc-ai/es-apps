local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/stage1/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local dumped = false

function dump(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local sp = cpu.spaces["program"]
  local f = io.open(outdir .. suffix .. ".bin", "wb")
  if f then
    for addr = 0x0000, 0x3FFF do f:write(string.char(sp:read_u8(addr))) end
    f:close()
  end
  manager.machine.video:snapshot()
  print("DUMP: " .. suffix .. " frame=" .. frame)
end

emu.register_frame_done(function()
  frame = frame + 1
  
  local p1 = manager.machine.ioport.ports[":P1"]
  local p2 = manager.machine.ioport.ports[":P2"]
  
  -- Coin at frame 60 (1 sec)
  if frame == 60 then
    p2.fields["Coin 1"]:set_value(1)
    print("COIN inserted frame " .. frame)
  end
  if frame == 75 then p2.fields["Coin 1"]:set_value(0) end
  
  -- Start at frame 120 (2 sec)
  if frame == 120 then
    p1.fields["1 Player Start"]:set_value(1)
    print("START pressed frame " .. frame)
  end
  if frame == 135 then p1.fields["1 Player Start"]:set_value(0) end
  
  -- Keep pressing start/button to skip intro screens every 2 seconds
  for _, t in ipairs({300, 480, 660, 840, 1020, 1200, 1380, 1560}) do
    if frame == t then p1.fields["1 Player Start"]:set_value(1) end
    if frame == t + 15 then p1.fields["1 Player Start"]:set_value(0) end
  end
  
  -- Dump periodically to find when gameplay starts
  -- Check sprite count as indicator
  if frame % 120 == 0 and frame >= 300 then
    local sp = manager.machine.devices[":maincpu"].spaces["program"]
    local spriteCount = 0
    for i = 0x2800, 0x2FFF, 5 do
      if (sp:read_u8(i + 1) & 0x80) ~= 0 then spriteCount = spriteCount + 1 end
    end
    -- Check palette for non-zero sprite colors
    local palColors = 0
    for i = 128, 255 do
      local lo = sp:read_u8(0x3C00 + i)
      local hi = sp:read_u8(0x3E00 + i)
      if (lo ~= 0 or hi ~= 0) then palColors = palColors + 1 end
    end
    print("Frame " .. frame .. ": sprites=" .. spriteCount .. " sprPalColors=" .. palColors)
    
    -- If we have sprite palette colors, we're in gameplay
    if palColors > 20 and not dumped then
      dump("gameplay_" .. frame)
      dumped = true
    end
  end
  
  -- Walk right once we think game started
  if frame >= 1800 and frame <= 2100 then
    p1.fields["P1 Right"]:set_value(1)
  end
  if frame == 2101 then p1.fields["P1 Right"]:set_value(0) end
  
  -- Punch
  if frame == 2200 then p1.fields["P1 Button 1"]:set_value(1) end
  if frame == 2210 then p1.fields["P1 Button 1"]:set_value(0) end
  
  -- Late dumps
  if frame == 1800 then dump("f1800") end
  if frame == 2100 then dump("f2100") end
  if frame == 2220 then dump("f2220_punch") end
  if frame == 2400 then dump("f2400") end
  if frame == 3000 then dump("f3000") end
  if frame == 3600 then dump("f3600") end
  
  if frame == 3600 then print("=== DONE ===") end
end)
print("Stage 1 capture script - will run 60 seconds")
