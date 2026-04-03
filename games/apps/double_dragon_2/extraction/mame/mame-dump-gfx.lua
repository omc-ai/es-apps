-- Dump ALL decoded GFX tiles from MAME's internal gfx_element objects
-- This gives us the tiles EXACTLY as MAME decodes them - no ROM decode needed

local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-gfx/"
os.execute("mkdir -p " .. outdir)

local frame = 0
local dumped = false

-- Boot the game first
function press(name, val)
  for tag, port in pairs(manager.machine.ioport.ports) do
    for n, field in pairs(port.fields) do
      if n == name then field:set_value(val) return end
    end
  end
end

emu.register_frame_done(function()
  frame = frame + 1

  -- Coin + Start
  if frame == 60 then press("Coin 1", 1) end
  if frame == 75 then press("Coin 1", 0) end
  if frame == 120 then press("1 Player Start", 1) end
  if frame == 135 then press("1 Player Start", 0) end
  for _, t in ipairs({300,480,660,840}) do
    if frame == t then press("1 Player Start", 1) end
    if frame == t + 15 then press("1 Player Start", 0) end
  end

  -- After game starts, dump the GFX
  if frame == 1200 and not dumped then
    dumped = true
    print("=== DUMPING GFX ===")

    local gfx = manager.machine.gfxdecode
    if not gfx then
      print("No gfxdecode found!")
      -- Try alternate access
      local dev = manager.machine.devices[":gfxdecode"]
      if dev then
        print("Found via devices")
      end
      return
    end

    -- List available GFX sets
    print("GFX sets available:")
    -- MAME Lua gfxdecode has .gfx[] array
    -- gfx[0] = chars (8x8)
    -- gfx[1] = sprites (16x16)
    -- gfx[2] = tiles (16x16)

    -- Actually, let's just dump via the palette and screen
    -- The easiest way: use MAME's save_snapshot with the GFX viewer active
    -- But we can't press F4 from Lua

    -- Alternative: dump the palette RAM and use our tile decode
    -- But we already have that...

    -- Let's try to access the GFX elements
    local cpu = manager.machine.devices[":maincpu"]
    local sp = cpu.spaces["program"]

    -- Dump complete palette as before
    local f = io.open(outdir .. "palette.bin", "wb")
    for i = 0x3C00, 0x3FFF do
      f:write(string.char(sp:read_u8(i)))
    end
    f:close()

    -- Dump sprite RAM
    f = io.open(outdir .. "sprites.bin", "wb")
    for i = 0x2800, 0x2FFF do
      f:write(string.char(sp:read_u8(i)))
    end
    f:close()

    -- Dump ALL RAM for complete state
    f = io.open(outdir .. "full_state.bin", "wb")
    for i = 0x0000, 0x3FFF do
      f:write(string.char(sp:read_u8(i)))
    end
    f:close()

    -- Take a screenshot of the normal game
    manager.machine.video:snapshot()

    -- Now try to access the decoded gfx
    -- In MAME Lua: manager.machine.devices[":gfxdecode"].gfx[n]
    -- Each gfx element has: width, height, elements (count), etc.
    pcall(function()
      local gfxdev = manager.machine.devices[":gfxdecode"]
      if gfxdev then
        print("GFX decode device found!")
        -- Try to enumerate
        for i = 0, 2 do
          local g = gfxdev:gfx(i)
          if g then
            print(string.format("  GFX[%d]: %dx%d, %d elements, %d colors",
              i, g:width(), g:height(), g:elements(), g:colorbase()))
          end
        end
      end
    end)

    -- The real approach: just take screenshots with the tile viewer
    -- We need to press F4 interactively
    -- OR: use MAME's -snapview option to capture different views

    print("Dumps saved to " .. outdir)
    print("For tile viewer: press F4 in MAME window, then F12 for screenshot")
  end
end)

print("GFX dump script loaded - will dump at frame 1200")
print("After game starts, press F4 in MAME window to see tile viewer!")
print("Then press F12 to take tile viewer screenshots")
