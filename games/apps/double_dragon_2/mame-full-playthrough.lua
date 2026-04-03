-- DD2 COMPLETE PLAYTHROUGH CAPTURE
-- Plays through ALL stages with god mode to capture everything:
-- - Every screen transition
-- - Every enemy type
-- - Every boss
-- - Every stage background at multiple scroll positions
-- - All cutscenes

local outdir = "/Users/asi/Documents/double-dragon-2-modern/full-playthrough/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local caps = 0

function press(n,v) for t,p in pairs(manager.machine.ioport.ports) do for nm,f in pairs(p.fields) do if nm==n then f:set_value(v) return end end end end
function tap(n,h) press(n,1); table.insert(pend,{n=n,r=frame+(h or 10)}) end
local pend = {}

function cap(name)
  local scr = manager.machine.screens[":screen"]
  local sp = manager.machine.devices[":maincpu"].spaces["program"]
  local w = scr.width
  local h = scr.height

  -- Save raw pixels
  local f = io.open(outdir .. string.format("%06d_%s.rgb", frame, name), "wb")
  for y = 0, h-1 do for x = 0, w-1 do
    local px = scr:pixel(x, y)
    f:write(string.char((px>>16)&0xFF, (px>>8)&0xFF, px&0xFF))
  end end
  f:close()

  -- Save sprite+tilemap+palette state
  local sf = io.open(outdir .. string.format("%06d_%s.json", frame, name), "w")
  sf:write('{"frame":' .. frame .. ',"name":"' .. name .. '",')

  -- Sprites
  sf:write('"sprites":[')
  local sc = 0
  for i = 0x2800, 0x2FFF, 5 do
    local attr = sp:read_u8(i+1)
    if (attr & 0x80) ~= 0 then
      if sc > 0 then sf:write(',') end
      sf:write(string.format('{"t":%d,"c":%d,"s":%d,"x":%d,"y":%d,"fx":%s,"fy":%s}',
        sp:read_u8(i+3) | ((sp:read_u8(i+2) & 0x1F) << 8),
        sp:read_u8(i+2) >> 5, (attr >> 4) & 3,
        240 - sp:read_u8(i+4) + ((attr & 2) << 7),
        232 - sp:read_u8(i) + ((attr & 1) << 8),
        (attr & 8) ~= 0 and "true" or "false",
        (attr & 4) ~= 0 and "true" or "false"))
      sc = sc + 1
    end
  end
  sf:write('],')

  -- BG tilemap (compact)
  sf:write('"bg":[')
  local bc = 0
  for i = 0x3000, 0x37FF, 2 do
    local attr = sp:read_u8(i)
    local tileLo = sp:read_u8(i+1)
    local tile = tileLo | ((attr & 7) << 8)
    if tile ~= 0 then
      if bc > 0 then sf:write(',') end
      sf:write(string.format('[%d,%d,%d,%s,%s]',
        (i-0x3000)/2, tile, (attr>>3)&7,
        (attr & 0x40) ~= 0 and "true" or "false",
        (attr & 0x80) ~= 0 and "true" or "false"))
      bc = bc + 1
    end
  end
  sf:write('],')

  -- FG tilemap (compact)
  sf:write('"fg":[')
  local fc = 0
  for i = 0x1800, 0x1FFF, 2 do
    local attr = sp:read_u8(i)
    local tileLo = sp:read_u8(i+1)
    local tile = tileLo | ((attr & 0x0F) << 8)
    if tile ~= 0 then
      if fc > 0 then sf:write(',') end
      sf:write(string.format('[%d,%d,%d]', (i-0x1800)/2, tile, attr >> 5))
      fc = fc + 1
    end
  end
  sf:write('],')

  -- Palette (all 512 colors, compact)
  sf:write('"pal":[')
  for i = 0, 511 do
    if i > 0 then sf:write(',') end
    local lo = sp:read_u8(0x3C00 + i)
    local hi = sp:read_u8(0x3E00 + i)
    sf:write(tostring((hi << 8) | lo))
  end
  sf:write('],')

  -- Entity data
  sf:write('"ent":[')
  local ec = 0
  for e = 0, 15 do
    local base = 0x0300 + e * 0x24
    local etype = sp:read_u8(base + 1)
    if etype ~= 0 then
      if ec > 0 then sf:write(',') end
      sf:write(string.format('{"i":%d,"t":%d,"s":%d,"x":%d,"y":%d,"hp":%d,"a":%d}',
        e, etype, sp:read_u8(base),
        (sp:read_u8(base+4)<<8)|sp:read_u8(base+5),
        (sp:read_u8(base+6)<<8)|sp:read_u8(base+7),
        sp:read_u8(base+26), sp:read_u8(base+27)))
      ec = ec + 1
    end
  end
  sf:write(']')

  sf:write('}\n')
  sf:close()

  manager.machine.video:snapshot()
  caps = caps + 1
  print(string.format("CAP %d: f%d = %s (%d spr, %d bg, %d fg)", caps, frame, name, sc, bc, fc))
end

-- GOD MODE: keep player HP at max every frame
function godMode()
  local sp = manager.machine.devices[":maincpu"].spaces["program"]
  -- Entity 0 at $0300, HP at offset 26
  -- Actually the player entity location varies. Let me set HP high for all player-type entities
  for e = 0, 15 do
    local base = 0x0300 + e * 0x24
    local etype = sp:read_u8(base + 1)
    if etype == 1 or etype == 2 then -- player types
      sp:write_u8(base + 26, 255) -- max HP
    end
  end
end

emu.register_frame_done(function()
  frame = frame + 1
  for i = #pend, 1, -1 do if frame >= pend[i].r then press(pend[i].n, 0); table.remove(pend, i) end end

  -- God mode every frame
  if frame > 500 then godMode() end

  -- === BOOT/TITLE ===
  if frame == 30 then cap("boot") end
  if frame == 120 then cap("title1") end
  if frame == 240 then cap("title2") end

  -- === COIN + START ===
  if frame == 300 then tap("Coin 1", 15) end
  if frame == 350 then tap("1 Player Start", 15) end

  -- === INTRO CUTSCENE ===
  if frame == 400 then cap("cutscene_start") end
  for i = 1, 10 do
    if frame == 400 + i * 60 then cap("cutscene_" .. i) end
  end

  -- Skip intro
  for _, t in ipairs({500, 650, 800, 950, 1100}) do
    if frame == t then tap("1 Player Start", 15) end
  end

  -- === MISSION 1 ===
  if frame == 1200 then cap("mission1_title") end
  if frame == 1300 then cap("stage1_start") end

  -- Walk right through stage 1, capturing every 60 frames
  if frame >= 1400 and frame <= 6000 then
    -- Walk right continuously
    press("P1 Right", 1)
    -- Punch periodically to fight enemies
    if frame % 90 == 0 then tap("P1 Button 1", 5) end
    if frame % 150 == 0 then tap("P1 Button 2", 5) end
    -- Capture every 60 frames (1 second)
    if frame % 60 == 0 then cap("stage1") end
  end
  if frame == 6001 then press("P1 Right", 0) end

  -- Stage 1 should end around here, transition to stage 2
  for i = 6000, 7000, 60 do
    if frame == i then cap("stage1_end") end
  end

  -- === MISSION 2 ===
  if frame >= 7000 and frame <= 12000 then
    press("P1 Right", 1)
    if frame % 90 == 0 then tap("P1 Button 1", 5) end
    if frame % 150 == 0 then tap("P1 Button 2", 5) end
    if frame % 60 == 0 then cap("stage2") end
    -- Skip any transition screens
    if frame % 300 == 0 then tap("1 Player Start", 15) end
  end
  if frame == 12001 then press("P1 Right", 0) end

  -- === MISSION 3 ===
  if frame >= 12000 and frame <= 17000 then
    press("P1 Right", 1)
    if frame % 90 == 0 then tap("P1 Button 1", 5) end
    if frame % 150 == 0 then tap("P1 Button 2", 5) end
    if frame % 60 == 0 then cap("stage3") end
    if frame % 300 == 0 then tap("1 Player Start", 15) end
  end
  if frame == 17001 then press("P1 Right", 0) end

  -- === MISSION 4 (FINAL) ===
  if frame >= 17000 and frame <= 22000 then
    press("P1 Right", 1)
    if frame % 90 == 0 then tap("P1 Button 1", 5) end
    if frame % 150 == 0 then tap("P1 Button 2", 5) end
    if frame % 60 == 0 then cap("stage4") end
    if frame % 300 == 0 then tap("1 Player Start", 15) end
  end
  if frame == 22001 then press("P1 Right", 0) end

  -- Ending
  if frame >= 22000 and frame <= 24000 and frame % 120 == 0 then
    cap("ending")
  end

  if frame == 24000 then
    print("=== COMPLETE PLAYTHROUGH: " .. caps .. " captures ===")
  end
end)

print("Full playthrough capture with god mode - will run ~7 minutes")
