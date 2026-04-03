-- Capture screen pixels frame by frame using screen:pixel(x,y)
-- This captures EXACTLY what MAME renders - the ground truth

local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-gfx/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local captures = 0

function press(n, v)
  for t, p in pairs(manager.machine.ioport.ports) do
    for nm, f in pairs(p.fields) do if nm == n then f:set_value(v) return end end
  end
end

function capture_screen(name)
  local scr = manager.machine.screens[":screen"]
  if not scr then print("No screen!"); return end

  local w = scr:width()
  local h = scr:height()

  -- Write raw RGB data (3 bytes per pixel)
  local f = io.open(outdir .. name .. ".raw", "wb")
  if not f then print("Can't open file!"); return end

  for y = 0, h - 1 do
    for x = 0, w - 1 do
      local p = scr:pixel(x, y)
      -- pixel returns ARGB32 packed integer
      local r = (p >> 16) & 0xFF
      local g = (p >> 8) & 0xFF
      local b = p & 0xFF
      f:write(string.char(r, g, b))
    end
  end
  f:close()

  -- Save dimensions
  local df = io.open(outdir .. name .. ".info", "w")
  df:write(w .. " " .. h .. "\n")
  df:close()

  -- Also take regular screenshot for comparison
  manager.machine.video:snapshot()

  captures = captures + 1
  print(string.format("CAPTURE %d: %s (%dx%d = %d bytes)", captures, name, w, h, w*h*3))
end

emu.register_frame_done(function()
  frame = frame + 1

  -- Boot
  if frame == 60 then press("Coin 1", 1) end
  if frame == 75 then press("Coin 1", 0) end
  if frame == 120 then press("1 Player Start", 1) end
  if frame == 135 then press("1 Player Start", 0) end
  for _, t in ipairs({300,480,660,840}) do
    if frame == t then press("1 Player Start", 1) end
    if frame == t+15 then press("1 Player Start", 0) end
  end

  -- Capture gameplay frames (pixel-perfect)
  if frame == 1200 then capture_screen("gameplay_idle") end

  -- Walk right
  if frame >= 1300 and frame <= 1400 then press("P1 Right", 1) end
  if frame == 1401 then press("P1 Right", 0) end
  if frame == 1350 then capture_screen("gameplay_walk") end

  -- Punch
  if frame == 1450 then press("P1 Button 1", 1) end
  if frame == 1455 then press("P1 Button 1", 0) end
  if frame == 1453 then capture_screen("gameplay_punch") end

  -- Kick
  if frame == 1500 then press("P1 Button 2", 1) end
  if frame == 1505 then press("P1 Button 2", 0) end
  if frame == 1503 then capture_screen("gameplay_kick") end

  -- Jump
  if frame == 1550 then press("P1 Button 3", 1) end
  if frame == 1555 then press("P1 Button 3", 0) end
  if frame == 1558 then capture_screen("gameplay_jump") end

  if frame == 1600 then
    print("=== ALL CAPTURES DONE: " .. captures .. " frames ===")
  end
end)
print("Screen capture script - pixel-perfect frame capture")
