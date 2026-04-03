-- Dump ALL decoded GFX tiles from MAME as raw pixel data
-- Uses MAME's gfxdecode device to get tiles exactly as the hardware decodes them

local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-gfx/"
os.execute("mkdir -p " .. outdir)
local frame = 0
local done = false

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

  if frame == 1200 and not done then
    done = true
    print("=== DUMPING DECODED TILES ===")

    -- Access gfxdecode device
    local gfxdev = manager.machine.devices[":gfxdecode"]
    print("gfxdecode: " .. tostring(gfxdev))

    -- Explore the gfxdecode API
    print("\ngfxdecode methods/fields:")
    pcall(function()
      for k, v in pairs(getmetatable(gfxdev)) do
        print("  " .. tostring(k) .. " = " .. tostring(v))
      end
    end)

    -- Try to get gfx elements
    -- In MAME Lua, gfxdecode has a .gfx property that is an array
    pcall(function()
      local gfx = gfxdev.gfx
      if gfx then
        print("\ngfx array found: " .. tostring(gfx))
        for k, v in pairs(getmetatable(gfx) or {}) do
          print("  gfx." .. tostring(k))
        end
      end
    end)

    -- Try direct index access
    pcall(function()
      for i = 0, 2 do
        local g = gfxdev.gfx[i]
        if g then
          print("\nGFX[" .. i .. "]: " .. tostring(g))
          -- Get properties
          pcall(function()
            print("  width: " .. g:width())
            print("  height: " .. g:height())
            print("  elements: " .. g:elements())
          end)
        end
      end
    end)

    -- Capture screen pixels directly
    print("\n=== SCREEN CAPTURE ===")
    local scr = manager.machine.screens[":screen"]
    if scr then
      -- Try different pixel access methods
      pcall(function()
        local w = scr:width()
        local h = scr:height()
        print("Screen: " .. w .. "x" .. h)

        -- screen:snapshot() saves to snap folder
        -- screen:pixels() returns width, height, pixels (as binary string)
        local pw, ph, pdata = scr:pixels()
        if pdata then
          print("Got pixel data: " .. pw .. "x" .. ph .. " (" .. #pdata .. " bytes)")
          -- Save raw BGRA32 pixel data
          local f = io.open(outdir .. "screen_rgba.raw", "wb")
          if f then
            f:write(pdata)
            f:close()
            print("Saved screen pixels")

            -- Also save dimensions
            local df = io.open(outdir .. "screen_info.txt", "w")
            df:write(pw .. "x" .. ph .. "\n")
            df:close()
          end
        else
          print("pixels() returned nil")
          -- Try alternative: pixel(x,y) one at a time for a small area
          local f = io.open(outdir .. "screen_sample.txt", "w")
          if f then
            for y = 0, math.min(15, h-1) do
              for x = 0, math.min(15, w-1) do
                local p = scr:pixel(x, y)
                f:write(string.format("%08x ", p))
              end
              f:write("\n")
            end
            f:close()
            print("Saved 16x16 pixel sample")
          end
        end
      end)
    end

    -- Save a MAME screenshot for reference
    manager.machine.video:snapshot()
    print("\n=== DONE ===")
  end
end)
print("Tile dump script loaded")
