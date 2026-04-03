local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-gfx/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local explored = false

function press(n, v)
  for t, p in pairs(manager.machine.ioport.ports) do
    for nm, f in pairs(p.fields) do if nm == n then f:set_value(v) return end end
  end
end

emu.register_frame_done(function()
  frame = frame + 1
  if frame == 60 then press("Coin 1", 1) end
  if frame == 75 then press("Coin 1", 0) end
  if frame == 120 then press("1 Player Start", 1) end
  if frame == 135 then press("1 Player Start", 0) end
  for _, t in ipairs({300,480,660,840}) do
    if frame == t then press("1 Player Start", 1) end
    if frame == t+15 then press("1 Player Start", 0) end
  end

  if frame == 1200 and not explored then
    explored = true
    print("=== EXPLORING MAME GFX API ===")
    
    -- Try to find gfx decode through various paths
    local machine = manager.machine
    
    -- Check all devices
    print("Devices:")
    for name, dev in pairs(machine.devices) do
      local s = tostring(dev)
      if s:find("gfx") or name:find("gfx") then
        print("  " .. name .. " = " .. s)
      end
    end
    
    -- Try direct palette access
    print("\nPalette device:")
    pcall(function()
      local pal = machine.devices[":palette"]
      if pal then print("  Found :palette") end
    end)
    
    -- Try the render API - MAME has manager.machine.render
    print("\nRender targets:")
    pcall(function()
      local render = machine.render
      if render then
        print("  render exists")
        for k,v in pairs(render) do
          print("  render." .. tostring(k) .. " = " .. tostring(v))
        end
      end
    end)
    
    -- Try screens
    print("\nScreens:")
    for name, scr in pairs(machine.screens) do
      print("  " .. name .. " = " .. tostring(scr))
      -- Try to get screen pixels
      pcall(function()
        print("    width=" .. scr:width() .. " height=" .. scr:height())
        -- scr:pixels() might give us the framebuffer
        local px = scr:pixels()
        if px then
          print("    pixels type=" .. type(px))
        end
      end)
    end

    -- The REAL way: use screen:pixels() to capture the rendered frame
    -- Then when F4 tile viewer is active, pixels() gives us the tile sheet
    pcall(function()
      local scr = machine.screens[":screen"]
      if scr then
        local w = scr:width()
        local h = scr:height()
        print("\nCapturing screen pixels: " .. w .. "x" .. h)
        
        -- Capture current game frame as raw pixels
        local f = io.open(outdir .. "screen_pixels.raw", "wb")
        if f then
          for y = 0, h-1 do
            for x = 0, w-1 do
              local pixel = scr:pixel(x, y)
              -- pixel is ARGB32
              local r = (pixel >> 16) & 0xFF
              local g = (pixel >> 8) & 0xFF
              local b = pixel & 0xFF
              f:write(string.char(r, g, b))
            end
          end
          f:close()
          print("Saved " .. (w*h*3) .. " bytes of pixel data")
        end
      end
    end)
    
    -- Take regular screenshot too
    machine.video:snapshot()
    
    print("\n=== DONE ===")
  end
end)
print("GFX explorer loaded")
