-- DD2 Complete Data Capture
-- Plays through the game capturing ALL data needed for recreation:
-- 1. Every unique palette state
-- 2. Every sprite composition (all character animation frames)
-- 3. Every stage tilemap
-- 4. Entity behavior data

local outdir = "/Users/asi/Documents/double-dragon-2-modern/mame-dumps/full-capture/"
os.execute("mkdir -p " .. outdir)

local frame = 0
local dumpIdx = 0
local lastPalHash = ""
local lastSprHash = ""
local capturedFrames = {}

function quickHash(sp, start, len)
  local h = 0
  for i = start, start + math.min(len, 64) - 1 do
    h = h + sp:read_u8(i) * (i - start + 1)
  end
  return h
end

function fullDump(suffix)
  local cpu = manager.machine.devices[":maincpu"]
  local sp = cpu.spaces["program"]
  local f = io.open(outdir .. string.format("%04d", dumpIdx) .. "_" .. suffix .. ".bin", "wb")
  if f then
    for addr = 0x0000, 0x3FFF do f:write(string.char(sp:read_u8(addr))) end
    f:close()
  end
  manager.machine.video:snapshot()
  dumpIdx = dumpIdx + 1
  print(string.format("DUMP %d: %s (frame %d)", dumpIdx, suffix, frame))
end

function smartDump(label)
  local cpu = manager.machine.devices[":maincpu"]
  local sp = cpu.spaces["program"]
  -- Only dump if sprite RAM changed significantly
  local sprHash = quickHash(sp, 0x2800, 128)
  local palHash = quickHash(sp, 0x3C00, 64)
  if sprHash ~= lastSprHash or palHash ~= lastPalHash then
    fullDump(label)
    lastSprHash = sprHash
    lastPalHash = palHash
    return true
  end
  return false
end

function press(field_name, val)
  for tag, port in pairs(manager.machine.ioport.ports) do
    for name, field in pairs(port.fields) do
      if name == field_name then field:set_value(val) return end
    end
  end
end

function tap(field_name, hold)
  press(field_name, 1)
  -- Will be released after 'hold' frames
  return { field = field_name, release_at = frame + (hold or 10) }
end

local pending_releases = {}
local action_queue = {}

-- Schedule an action at a specific frame
function at(f, fn)
  action_queue[f] = fn
end

-- Boot: coin + start
at(60, function() tap("Coin 1", 15) end)
at(120, function() tap("1 Player Start", 15) end)

-- Skip intro screens by pressing start repeatedly
for _, t in ipairs({300, 480, 660, 840, 1020}) do
  at(t, function() tap("1 Player Start", 15) end)
end

-- === STAGE 1 GAMEPLAY CAPTURE ===
-- Stand idle and capture idle frames
at(1200, function() print("=== CAPTURING IDLE ===") end)
for i = 0, 15 do
  at(1200 + i * 4, function() smartDump("idle") end)
end

-- Walk right
at(1280, function() print("=== CAPTURING WALK RIGHT ==="); press("P1 Right", 1) end)
for i = 0, 20 do
  at(1280 + i * 4, function() smartDump("walkR") end)
end
at(1380, function() press("P1 Right", 0) end)

-- Walk left
at(1400, function() print("=== CAPTURING WALK LEFT ==="); press("P1 Left", 1) end)
for i = 0, 15 do
  at(1400 + i * 4, function() smartDump("walkL") end)
end
at(1470, function() press("P1 Left", 0) end)

-- Walk up
at(1500, function() print("=== CAPTURING WALK UP ==="); press("P1 Up", 1) end)
for i = 0, 10 do
  at(1500 + i * 4, function() smartDump("walkU") end)
end
at(1550, function() press("P1 Up", 0) end)

-- Walk down
at(1560, function() press("P1 Down", 1) end)
for i = 0, 10 do
  at(1560 + i * 4, function() smartDump("walkD") end)
end
at(1610, function() press("P1 Down", 0) end)

-- Punch combo
at(1650, function() print("=== CAPTURING PUNCH ===") end)
for p = 0, 4 do
  at(1650 + p * 30, function() tap("P1 Button 1", 5) end)
  for i = 0, 6 do
    at(1650 + p * 30 + i * 3, function() smartDump("punch") end)
  end
end

-- Kick combo
at(1850, function() print("=== CAPTURING KICK ===") end)
for p = 0, 3 do
  at(1850 + p * 30, function() tap("P1 Button 2", 5) end)
  for i = 0, 6 do
    at(1850 + p * 30 + i * 3, function() smartDump("kick") end)
  end
end

-- Jump
at(2050, function() print("=== CAPTURING JUMP ==="); tap("P1 Button 3", 5) end)
for i = 0, 15 do
  at(2050 + i * 3, function() smartDump("jump") end)
end

-- Jump kick (jump then kick in air)
at(2150, function() print("=== CAPTURING JUMP KICK ==="); tap("P1 Button 3", 5) end)
at(2165, function() tap("P1 Button 2", 5) end)
for i = 0, 15 do
  at(2150 + i * 3, function() smartDump("jkick") end)
end

-- Walk into enemies to trigger combat
at(2250, function() print("=== WALKING INTO ENEMIES ==="); press("P1 Right", 1) end)
at(2500, function() press("P1 Right", 0) end)
-- Capture enemy sprites
for i = 0, 30 do
  at(2300 + i * 6, function() smartDump("combat") end)
end

-- Get hit (walk into enemies without attacking)
at(2550, function() print("=== GETTING HIT ==="); press("P1 Right", 1) end)
at(2700, function() press("P1 Right", 0) end)
for i = 0, 20 do
  at(2600 + i * 5, function() smartDump("hurt") end)
end

-- More combat with punching
at(2750, function() print("=== FIGHTING ===") end)
for p = 0, 10 do
  at(2750 + p * 20, function() tap("P1 Button 1", 5) end)
  at(2750 + p * 20 + 3, function() smartDump("fight") end)
  at(2750 + p * 20 + 8, function() smartDump("fight") end)
end

-- Continue fighting and capture different enemy types
at(3000, function() press("P1 Right", 1) end)
at(3200, function() press("P1 Right", 0) end)
for i = 0, 40 do
  at(3000 + i * 5, function() smartDump("stage1") end)
end

-- Keep playing to see more enemy types
at(3300, function()
  for p = 0, 20 do
    at(3300 + p * 15, function()
      tap("P1 Button 1", 5)
      tap("P1 Right", 3)
    end)
  end
end)
for i = 0, 40 do
  at(3300 + i * 8, function() smartDump("stage1b") end)
end

-- Final stage 1 dumps
at(3700, function() fullDump("stage1_final") end)

at(3700, function()
  print("=== CAPTURE COMPLETE ===")
  print("Total dumps: " .. dumpIdx)
end)

emu.register_frame_done(function()
  frame = frame + 1

  -- Execute scheduled actions
  if action_queue[frame] then
    action_queue[frame]()
  end

  -- Handle pending key releases
  for i = #pending_releases, 1, -1 do
    if frame >= pending_releases[i].release_at then
      press(pending_releases[i].field, 0)
      table.remove(pending_releases, i)
    end
  end
end)

-- Override tap to track releases
local orig_tap = tap
tap = function(field_name, hold)
  press(field_name, 1)
  table.insert(pending_releases, { field = field_name, release_at = frame + (hold or 10) })
end

print("DD2 Full Capture Script loaded - will capture all animation states")
