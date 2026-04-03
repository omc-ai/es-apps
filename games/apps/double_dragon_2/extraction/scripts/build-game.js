#!/usr/bin/env node
/**
 * Double Dragon 2 - Build Script
 * Reads MAME captures from gameflow/ and generates a playable HTML game.
 *
 * Usage: node build-game.js
 * Output: dd2-final/index.html + dd2-final/assets/
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const GAMEFLOW = path.join(__dirname, 'gameflow');
const OUTPUT = path.join(__dirname, 'dd2-final');
const ASSETS = path.join(OUTPUT, 'assets');
const W = 256, H = 240;

// Ensure output dirs
fs.mkdirSync(ASSETS, { recursive: true });

// ─────────────────────────────────────────────
// Utility: read raw RGB frame
// ─────────────────────────────────────────────
function readRGB(name) {
  const buf = fs.readFileSync(path.join(GAMEFLOW, name + '.rgb'));
  if (buf.length !== W * H * 3) throw new Error(`Bad RGB size for ${name}: ${buf.length}`);
  return buf;
}

function readJSON(name) {
  return JSON.parse(fs.readFileSync(path.join(GAMEFLOW, name + '.json'), 'utf8'));
}

function getPixel(rgb, x, y) {
  if (x < 0 || x >= W || y < 0 || y >= H) return [0, 0, 0];
  const i = (y * W + x) * 3;
  return [rgb[i], rgb[i + 1], rgb[i + 2]];
}

// ─────────────────────────────────────────────
// Sprite size decoder
// ─────────────────────────────────────────────
function spriteSize(s) {
  switch (s) {
    case 0: return { w: 16, h: 16 };
    case 1: return { w: 16, h: 32 };
    case 2: return { w: 32, h: 16 };
    case 3: return { w: 32, h: 32 };
    default: return { w: 16, h: 16 };
  }
}

// ─────────────────────────────────────────────
// Get bounding box for a group of sprites
// ─────────────────────────────────────────────
function groupBounds(sprites) {
  let minX = 999, minY = 999, maxX = -999, maxY = -999;
  for (const s of sprites) {
    const sz = spriteSize(s.s);
    const x0 = s.x, y0 = s.y;
    const x1 = x0 + sz.w, y1 = y0 + sz.h;
    if (x0 < minX) minX = x0;
    if (y0 < minY) minY = y0;
    if (x1 > maxX) maxX = x1;
    if (y1 > maxY) maxY = y1;
  }
  return { x: minX, y: minY, w: maxX - minX, h: maxY - minY };
}

// ─────────────────────────────────────────────
// Extract a character sprite from raw RGB data
// Uses a reference background frame to determine transparency
// ─────────────────────────────────────────────
function extractSprite(rgb, sprites, bgRgb) {
  const bounds = groupBounds(sprites);
  // Clamp to screen
  const x0 = Math.max(0, bounds.x);
  const y0 = Math.max(0, bounds.y);
  const x1 = Math.min(W, bounds.x + bounds.w);
  const y1 = Math.min(H, bounds.y + bounds.h);
  const sw = x1 - x0, sh = y1 - y0;
  if (sw <= 0 || sh <= 0) return null;

  const png = new PNG({ width: sw, height: sh });

  // Build a mask of which pixels are covered by sprites
  const mask = new Uint8Array(sw * sh);
  for (const s of sprites) {
    const sz = spriteSize(s.s);
    for (let dy = 0; dy < sz.h; dy++) {
      for (let dx = 0; dx < sz.w; dx++) {
        const px = s.x + dx - x0;
        const py = s.y + dy - y0;
        if (px >= 0 && px < sw && py >= 0 && py < sh) {
          mask[py * sw + px] = 1;
        }
      }
    }
  }

  for (let y = 0; y < sh; y++) {
    for (let x = 0; x < sw; x++) {
      const sx = x0 + x, sy = y0 + y;
      const idx = (y * sw + x) * 4;
      const fg = getPixel(rgb, sx, sy);
      const bg = getPixel(bgRgb, sx, sy);

      if (mask[y * sw + x]) {
        // Pixel is within a sprite tile area
        // Check if it differs from background
        const diff = Math.abs(fg[0] - bg[0]) + Math.abs(fg[1] - bg[1]) + Math.abs(fg[2] - bg[2]);
        if (diff > 15) {
          // This is a sprite pixel
          png.data[idx] = fg[0];
          png.data[idx + 1] = fg[1];
          png.data[idx + 2] = fg[2];
          png.data[idx + 3] = 255;
        } else {
          // Matches background - transparent
          png.data[idx] = 0;
          png.data[idx + 1] = 0;
          png.data[idx + 2] = 0;
          png.data[idx + 3] = 0;
        }
      } else {
        // Not covered by any sprite tile - transparent
        png.data[idx] = 0;
        png.data[idx + 1] = 0;
        png.data[idx + 2] = 0;
        png.data[idx + 3] = 0;
      }
    }
  }

  return { png, x: x0, y: y0, w: sw, h: sh };
}

// ─────────────────────────────────────────────
// Save PNG helper
// ─────────────────────────────────────────────
function savePNG(png, filePath) {
  const buf = PNG.sync.write(png);
  fs.writeFileSync(filePath, buf);
}

// ─────────────────────────────────────────────
// Copy a full frame as PNG (for title screen, etc.)
// ─────────────────────────────────────────────
function frameToPNG(rgb) {
  const png = new PNG({ width: W, height: H });
  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      const si = (y * W + x) * 3;
      const di = (y * W + x) * 4;
      png.data[di] = rgb[si];
      png.data[di + 1] = rgb[si + 1];
      png.data[di + 2] = rgb[si + 2];
      png.data[di + 3] = 255;
    }
  }
  return png;
}

// ─────────────────────────────────────────────
// Group sprites by color and spatial clustering
// ─────────────────────────────────────────────
function clusterByColor(sprites, color) {
  const filtered = sprites.filter(s => s.c === color);
  if (filtered.length === 0) return [];

  // Cluster by proximity (sprites within 48px of each other belong together)
  const clusters = [];
  const used = new Set();
  for (let i = 0; i < filtered.length; i++) {
    if (used.has(i)) continue;
    const cluster = [filtered[i]];
    used.add(i);
    // BFS to find nearby sprites
    let changed = true;
    while (changed) {
      changed = false;
      for (let j = 0; j < filtered.length; j++) {
        if (used.has(j)) continue;
        const sj = filtered[j];
        // Check distance to any sprite in cluster
        for (const sc of cluster) {
          const dx = Math.abs(sj.x - sc.x);
          const dy = Math.abs(sj.y - sc.y);
          if (dx < 48 && dy < 64) {
            cluster.push(sj);
            used.add(j);
            changed = true;
            break;
          }
        }
      }
    }
    clusters.push(cluster);
  }
  return clusters;
}

// ─────────────────────────────────────────────
// MAIN BUILD PROCESS
// ─────────────────────────────────────────────
console.log('=== Double Dragon 2 Build Script ===');
console.log('Reading gameflow captures...');

// List all capture names (without extension)
const allFiles = fs.readdirSync(GAMEFLOW);
const captureNames = [...new Set(allFiles.filter(f => f.endsWith('.json')).map(f => f.replace('.json', '')))];
captureNames.sort();
console.log(`Found ${captureNames.length} captures`);

// ── Step 1: Export title screen and mission screen ──
console.log('\n[1] Exporting title screen...');
const titleRgb = readRGB('0120_title_1');
savePNG(frameToPNG(titleRgb), path.join(ASSETS, 'title.png'));

// Also save title_2 for animation
if (fs.existsSync(path.join(GAMEFLOW, '0240_title_2.rgb'))) {
  savePNG(frameToPNG(readRGB('0240_title_2')), path.join(ASSETS, 'title2.png'));
}

// Boot screen
savePNG(frameToPNG(readRGB('0030_boot')), path.join(ASSETS, 'boot.png'));

// Cutscene frames
const cutsceneFrames = ['0470_start_pressed', '0530_after_start_1', '0600_after_start_2',
  '0700_after_start_3', '0800_after_start_4', '0900_after_start_5', '1000_after_start_6'];
cutsceneFrames.forEach((name, i) => {
  if (fs.existsSync(path.join(GAMEFLOW, name + '.rgb'))) {
    savePNG(frameToPNG(readRGB(name)), path.join(ASSETS, `cutscene_${i}.png`));
  }
});

// Mission screen
console.log('[1b] Exporting mission screen...');
savePNG(frameToPNG(readRGB('1100_pre_gameplay_1')), path.join(ASSETS, 'mission1.png'));
if (fs.existsSync(path.join(GAMEFLOW, '1200_pre_gameplay_2.rgb'))) {
  savePNG(frameToPNG(readRGB('1200_pre_gameplay_2')), path.join(ASSETS, 'mission1b.png'));
}
if (fs.existsSync(path.join(GAMEFLOW, '1300_pre_gameplay_3.rgb'))) {
  savePNG(frameToPNG(readRGB('1300_pre_gameplay_3')), path.join(ASSETS, 'mission1c.png'));
}

// ── Step 2: Extract background ──
console.log('\n[2] Extracting background...');
// Use a gameplay frame. We need a clean background.
// Strategy: use 1300_pre_gameplay_3 which should show the stage with no player sprites yet
// or build BG from multiple frames by taking pixels where no sprite is present

// First, let's try the pre-gameplay frames which show the stage name
// For the actual gameplay BG, we'll composite from multiple gameplay frames
// picking pixels that have no sprites overlapping

// We'll use several gameplay frames and for each pixel, use the value from a frame
// where no sprite covers that pixel
const bgFrameNames = [];
for (const name of captureNames) {
  if (name.includes('gameplay') || name.includes('walk_right') ||
      name.includes('punch') || name.includes('kick') || name.includes('jump') ||
      name.includes('enemy') || name.includes('fight') || name.includes('taking_damage')) {
    bgFrameNames.push(name);
  }
}

console.log(`  Using ${bgFrameNames.length} frames for BG reconstruction`);

// Build sprite coverage maps for each frame
const bgFrames = [];
for (const name of bgFrameNames) {
  const rgb = readRGB(name);
  const json = readJSON(name);

  // Build coverage mask (which pixels are under sprites)
  const mask = new Uint8Array(W * H); // 0 = no sprite, 1 = sprite
  for (const s of json.sprites) {
    const sz = spriteSize(s.s);
    // Expand coverage by 1px to account for edge artifacts
    for (let dy = -1; dy < sz.h + 1; dy++) {
      for (let dx = -1; dx < sz.w + 1; dx++) {
        const px = s.x + dx, py = s.y + dy;
        if (px >= 0 && px < W && py >= 0 && py < H) {
          mask[py * W + px] = 1;
        }
      }
    }
  }
  bgFrames.push({ rgb, mask });
}

// Composite background: for each pixel, find a frame where no sprite covers it
const bgPng = new PNG({ width: W, height: H });
let uncoveredPixels = 0;
for (let y = 0; y < H; y++) {
  for (let x = 0; x < W; x++) {
    const di = (y * W + x) * 4;
    let found = false;
    for (const { rgb, mask } of bgFrames) {
      if (!mask[y * W + x]) {
        const p = getPixel(rgb, x, y);
        bgPng.data[di] = p[0];
        bgPng.data[di + 1] = p[1];
        bgPng.data[di + 2] = p[2];
        bgPng.data[di + 3] = 255;
        found = true;
        break;
      }
    }
    if (!found) {
      // All frames have a sprite here - use the most common value
      const p = getPixel(bgFrames[0].rgb, x, y);
      bgPng.data[di] = p[0];
      bgPng.data[di + 1] = p[1];
      bgPng.data[di + 2] = p[2];
      bgPng.data[di + 3] = 255;
      uncoveredPixels++;
    }
  }
}
console.log(`  Uncovered pixels (sprite always present): ${uncoveredPixels}`);
savePNG(bgPng, path.join(ASSETS, 'bg_stage1.png'));

// Also save the background RGB data for sprite extraction
const bgRgbData = Buffer.alloc(W * H * 3);
for (let y = 0; y < H; y++) {
  for (let x = 0; x < W; x++) {
    const di = (y * W + x) * 4;
    const si = (y * W + x) * 3;
    bgRgbData[si] = bgPng.data[di];
    bgRgbData[si + 1] = bgPng.data[di + 1];
    bgRgbData[si + 2] = bgPng.data[di + 2];
  }
}

// ── Step 2b: Build a wider scrolling background ──
// The walk_right frames show the BG scrolling. We can stitch a wider BG.
// For now, we'll use the single-screen BG and tile/scroll it in-game.
// Let's also extract BGs from different scroll positions
const walkFrameNames = captureNames.filter(n => n.includes('walk_right'));
if (walkFrameNames.length >= 2) {
  console.log('  Building scrolling background from walk frames...');
  // The early walk frames and late walk frames show different scroll positions
  // We'll save a few BG snapshots for variety
  const earlyWalk = readRGB(walkFrameNames[0]);
  const lateWalk = readRGB(walkFrameNames[walkFrameNames.length - 1]);
  savePNG(frameToPNG(earlyWalk), path.join(ASSETS, 'bg_scroll_early.png'));
  savePNG(frameToPNG(lateWalk), path.join(ASSETS, 'bg_scroll_late.png'));
}

// ── Step 3: Extract character sprites ──
console.log('\n[3] Extracting character sprites...');

// Animation categories and their frame captures
const animCategories = {
  idle: captureNames.filter(n => n.match(/^1[4-7]\d\d_gameplay$/)),
  walk: captureNames.filter(n => n.includes('walk_right')),
  punch: captureNames.filter(n => n.includes('punch')),
  kick: captureNames.filter(n => n.includes('kick')),
  jump: captureNames.filter(n => n.includes('jump')),
  fight: captureNames.filter(n => n.includes('fight') && !n.includes('hit')),
  hit: captureNames.filter(n => n.includes('fight_hit')),
  damage: captureNames.filter(n => n.includes('taking_damage')),
  enemy: captureNames.filter(n => n.includes('enemy_encounter')),
};

console.log('  Animation frame counts:');
for (const [cat, frames] of Object.entries(animCategories)) {
  console.log(`    ${cat}: ${frames.length} frames`);
}

// For each animation, extract the player (c=2) and enemy (c=5) sprites
const spriteManifest = {
  player: { idle: [], walk: [], punch: [], kick: [], jump: [], damage: [] },
  enemy: { idle: [], walk: [], attack: [] },
};

// Helper: find the "main" player cluster (highest Y position = closest to ground, most sprites)
function findMainPlayerCluster(clusters) {
  if (clusters.length === 0) return null;
  if (clusters.length === 1) return clusters[0];

  // Pick the cluster with most sprites or the one at higher screen position (larger Y = lower on screen)
  let best = clusters[0];
  let bestScore = 0;
  for (const c of clusters) {
    const bounds = groupBounds(c);
    // Prefer clusters with more sprites and higher Y (player body is taller)
    const score = c.length * 10 + bounds.h;
    if (score > bestScore) {
      bestScore = score;
      best = c;
    }
  }
  return best;
}

// Extract player idle sprites
console.log('  Extracting player idle...');
const idleFrames = animCategories.idle;
const usedIdleHashes = new Set();
let idleCount = 0;
for (const name of idleFrames) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  // Find clusters - in idle, there may be Billy + a shadow/NPC
  // Main Billy typically has tiles in 1792-1840 range or 4876+ range
  // We want the one that looks like a standing character (~32x64)
  for (let ci = 0; ci < clusters.length; ci++) {
    const cluster = clusters[ci];
    const bounds = groupBounds(cluster);

    // Billy standing is roughly 32 wide, 48-64 tall
    if (bounds.w < 16 || bounds.h < 32) continue;
    if (bounds.w > 64 || bounds.h > 80) continue;

    const result = extractSprite(rgb, cluster, bgRgbData);
    if (!result) continue;

    // Create a simple hash to avoid exact duplicates
    let hash = 0;
    for (let i = 0; i < result.png.data.length; i += 37) {
      hash = ((hash << 5) - hash + result.png.data[i]) | 0;
    }
    if (usedIdleHashes.has(hash)) continue;
    usedIdleHashes.add(hash);

    const fname = `player_idle_${idleCount}.png`;
    savePNG(result.png, path.join(ASSETS, fname));
    spriteManifest.player.idle.push({ file: fname, w: result.w, h: result.h, ox: 0, oy: 0 });
    idleCount++;
  }
}
console.log(`    Extracted ${idleCount} unique idle frames`);

// Extract player walk sprites
console.log('  Extracting player walk...');
let walkCount = 0;
const usedWalkHashes = new Set();
for (const name of animCategories.walk) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  const main = findMainPlayerCluster(clusters);
  if (!main) continue;

  const bounds = groupBounds(main);
  if (bounds.w < 16 || bounds.h < 32) continue;

  const result = extractSprite(rgb, main, bgRgbData);
  if (!result) continue;

  let hash = 0;
  for (let i = 0; i < result.png.data.length; i += 37) {
    hash = ((hash << 5) - hash + result.png.data[i]) | 0;
  }
  if (usedWalkHashes.has(hash)) continue;
  usedWalkHashes.add(hash);

  const fname = `player_walk_${walkCount}.png`;
  savePNG(result.png, path.join(ASSETS, fname));
  spriteManifest.player.walk.push({ file: fname, w: result.w, h: result.h });
  walkCount++;
}
console.log(`    Extracted ${walkCount} unique walk frames`);

// Extract player punch sprites
console.log('  Extracting player punch...');
let punchCount = 0;
const usedPunchHashes = new Set();
for (const name of animCategories.punch) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  // For punch, the player cluster may be wider due to arm extension
  // Find the cluster that has the most sprites and is near typical player Y
  let best = null, bestSize = 0;
  for (const c of clusters) {
    const b = groupBounds(c);
    if (b.h >= 30 && c.length >= 3) {
      const size = c.length;
      if (size > bestSize) {
        bestSize = size;
        best = c;
      }
    }
  }
  if (!best) continue;

  const result = extractSprite(rgb, best, bgRgbData);
  if (!result) continue;

  let hash = 0;
  for (let i = 0; i < result.png.data.length; i += 37) {
    hash = ((hash << 5) - hash + result.png.data[i]) | 0;
  }
  if (usedPunchHashes.has(hash)) continue;
  usedPunchHashes.add(hash);

  const fname = `player_punch_${punchCount}.png`;
  savePNG(result.png, path.join(ASSETS, fname));
  spriteManifest.player.punch.push({ file: fname, w: result.w, h: result.h });
  punchCount++;
}
console.log(`    Extracted ${punchCount} unique punch frames`);

// Extract player kick sprites
console.log('  Extracting player kick...');
let kickCount = 0;
const usedKickHashes = new Set();
for (const name of animCategories.kick) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  let best = null, bestSize = 0;
  for (const c of clusters) {
    const b = groupBounds(c);
    if (b.h >= 30 && c.length >= 3) {
      const size = c.length;
      if (size > bestSize) { bestSize = size; best = c; }
    }
  }
  if (!best) continue;

  const result = extractSprite(rgb, best, bgRgbData);
  if (!result) continue;

  let hash = 0;
  for (let i = 0; i < result.png.data.length; i += 37) {
    hash = ((hash << 5) - hash + result.png.data[i]) | 0;
  }
  if (usedKickHashes.has(hash)) continue;
  usedKickHashes.add(hash);

  const fname = `player_kick_${kickCount}.png`;
  savePNG(result.png, path.join(ASSETS, fname));
  spriteManifest.player.kick.push({ file: fname, w: result.w, h: result.h });
  kickCount++;
}
console.log(`    Extracted ${kickCount} unique kick frames`);

// Extract player jump sprites
console.log('  Extracting player jump...');
let jumpCount = 0;
const usedJumpHashes = new Set();
for (const name of animCategories.jump) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  // Jump sprites - player may be at various heights
  // Look for clusters with player-colored sprites
  let best = null, bestY = 999;
  for (const c of clusters) {
    const b = groupBounds(c);
    if (b.h >= 16 && c.length >= 2) {
      // Pick the one at lowest screen Y (highest visual position = jumping)
      if (b.y < bestY) { bestY = b.y; best = c; }
    }
  }
  if (!best) {
    // Fallback: just use the largest cluster
    best = findMainPlayerCluster(clusters);
  }
  if (!best) continue;

  const result = extractSprite(rgb, best, bgRgbData);
  if (!result) continue;

  let hash = 0;
  for (let i = 0; i < result.png.data.length; i += 37) {
    hash = ((hash << 5) - hash + result.png.data[i]) | 0;
  }
  if (usedJumpHashes.has(hash)) continue;
  usedJumpHashes.add(hash);

  const fname = `player_jump_${jumpCount}.png`;
  savePNG(result.png, path.join(ASSETS, fname));
  spriteManifest.player.jump.push({ file: fname, w: result.w, h: result.h });
  jumpCount++;
}
console.log(`    Extracted ${jumpCount} unique jump frames`);

// Extract player damage sprites
console.log('  Extracting player damage...');
let dmgCount = 0;
const usedDmgHashes = new Set();
for (const name of animCategories.damage) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 2);

  // In damage frames, player may be recoiling. Find the cluster that looks like Billy
  // Billy uses tiles in certain ranges. We'll just pick the main cluster.
  for (const c of clusters) {
    const b = groupBounds(c);
    if (b.h < 20 || c.length < 2) continue;

    const result = extractSprite(rgb, c, bgRgbData);
    if (!result) continue;

    let hash = 0;
    for (let i = 0; i < result.png.data.length; i += 37) {
      hash = ((hash << 5) - hash + result.png.data[i]) | 0;
    }
    if (usedDmgHashes.has(hash)) continue;
    usedDmgHashes.add(hash);

    const fname = `player_damage_${dmgCount}.png`;
    savePNG(result.png, path.join(ASSETS, fname));
    spriteManifest.player.damage.push({ file: fname, w: result.w, h: result.h });
    dmgCount++;
    if (dmgCount >= 6) break; // Limit
  }
  if (dmgCount >= 6) break;
}
console.log(`    Extracted ${dmgCount} unique damage frames`);

// Extract enemy sprites
console.log('  Extracting enemy sprites...');
let enemyCount = 0;
const usedEnemyHashes = new Set();

// Enemy frames come from enemy_encounter and fight frames
const enemyFrameNames = [...animCategories.enemy, ...animCategories.fight, ...animCategories.hit, ...animCategories.damage];
for (const name of enemyFrameNames) {
  const rgb = readRGB(name);
  const json = readJSON(name);
  const clusters = clusterByColor(json.sprites, 5);

  for (const c of clusters) {
    const b = groupBounds(c);
    if (b.h < 30 || c.length < 2) continue;

    const result = extractSprite(rgb, c, bgRgbData);
    if (!result) continue;

    let hash = 0;
    for (let i = 0; i < result.png.data.length; i += 37) {
      hash = ((hash << 5) - hash + result.png.data[i]) | 0;
    }
    if (usedEnemyHashes.has(hash)) continue;
    usedEnemyHashes.add(hash);

    const category = enemyCount < 4 ? 'idle' : (enemyCount < 8 ? 'walk' : 'attack');
    const fname = `enemy_${enemyCount}.png`;
    savePNG(result.png, path.join(ASSETS, fname));
    spriteManifest.enemy[category].push({ file: fname, w: result.w, h: result.h });
    enemyCount++;
  }
}
console.log(`    Extracted ${enemyCount} unique enemy frames`);

// ── Step 4: Save the HUD frame for reference ──
console.log('\n[4] Extracting HUD elements...');
// The HUD is in the top portion of gameplay frames (c=0 sprites)
// We'll just note the HUD area and replicate it in-game with canvas text
// Extract a clean HUD bar from a gameplay frame
const hudRgb = readRGB('1400_gameplay');
const hudPng = new PNG({ width: W, height: 32 });
for (let y = 0; y < 32; y++) {
  for (let x = 0; x < W; x++) {
    const si = (y * W + x) * 3;
    const di = (y * W + x) * 4;
    hudPng.data[di] = hudRgb[si];
    hudPng.data[di + 1] = hudRgb[si + 1];
    hudPng.data[di + 2] = hudRgb[si + 2];
    hudPng.data[di + 3] = 255;
  }
}
savePNG(hudPng, path.join(ASSETS, 'hud.png'));

// ── Step 5: Write the sprite manifest ──
console.log('\n[5] Writing sprite manifest...');
fs.writeFileSync(path.join(ASSETS, 'manifest.json'), JSON.stringify(spriteManifest, null, 2));

// ── Step 6: Generate the game HTML ──
console.log('\n[6] Generating game HTML...');

// We need to ensure minimum frames per animation
function ensureMinFrames(arr, min) {
  if (arr.length === 0) return arr;
  while (arr.length < min) {
    arr.push(arr[arr.length % arr.length === 0 ? 0 : arr.length - 1]);
  }
  return arr;
}

// Prepare animation data for the game
const playerAnims = {};
for (const [key, frames] of Object.entries(spriteManifest.player)) {
  playerAnims[key] = ensureMinFrames([...frames], 2).map(f => f.file);
}

const enemyAnims = {};
for (const [key, frames] of Object.entries(spriteManifest.enemy)) {
  enemyAnims[key] = ensureMinFrames([...frames], 1).map(f => f.file);
}

// Get all unique asset files
const allAssets = new Set();
allAssets.add('title.png');
allAssets.add('title2.png');
allAssets.add('boot.png');
allAssets.add('mission1.png');
allAssets.add('mission1b.png');
allAssets.add('mission1c.png');
allAssets.add('bg_stage1.png');
allAssets.add('hud.png');
for (let i = 0; i < cutsceneFrames.length; i++) allAssets.add(`cutscene_${i}.png`);
for (const anims of Object.values(playerAnims)) anims.forEach(f => allAssets.add(f));
for (const anims of Object.values(enemyAnims)) anims.forEach(f => allAssets.add(f));

const gameHTML = `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Double Dragon II - The Revenge</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #000; display: flex; justify-content: center; align-items: center; min-height: 100vh; overflow: hidden; }
canvas { image-rendering: pixelated; image-rendering: crisp-edges; width: ${W * 3}px; height: ${H * 3}px; }
</style>
</head>
<body>
<canvas id="c" width="${W}" height="${H}"></canvas>
<script>
// ═══════════════════════════════════════════════════
// Double Dragon II - The Revenge (HTML Recreation)
// Built from MAME pixel-perfect captures
// ═══════════════════════════════════════════════════

const W = ${W}, H = ${H};
const canvas = document.getElementById('c');
const ctx = canvas.getContext('2d');
ctx.imageSmoothingEnabled = false;

// ── Asset Loading ──
const assets = {};
let assetsLoaded = 0;
const assetList = ${JSON.stringify([...allAssets])};
const totalAssets = assetList.length;

function loadAssets(cb) {
  if (totalAssets === 0) { cb(); return; }
  assetList.forEach(name => {
    const img = new Image();
    img.onload = () => { assets[name] = img; assetsLoaded++; if (assetsLoaded >= totalAssets) cb(); };
    img.onerror = () => { assetsLoaded++; if (assetsLoaded >= totalAssets) cb(); };
    img.src = 'assets/' + name;
  });
}

// ── Input ──
const keys = {};
document.addEventListener('keydown', e => { keys[e.code] = true; e.preventDefault(); });
document.addEventListener('keyup', e => { keys[e.code] = false; });

function isLeft() { return keys['ArrowLeft'] || keys['KeyA']; }
function isRight() { return keys['ArrowRight'] || keys['KeyD']; }
function isUp() { return keys['ArrowUp'] || keys['KeyW']; }
function isDown() { return keys['ArrowDown'] || keys['KeyS']; }
function isPunch() { return keys['KeyZ'] || keys['KeyJ']; }
function isKick() { return keys['KeyX'] || keys['KeyK']; }
function isJump() { return keys['Space'] || keys['KeyC']; }
function isStart() { return keys['Enter'] || keys['Space']; }

// ── Audio (Web Audio procedural) ──
let audioCtx = null;
function initAudio() {
  if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
}

function playSound(type) {
  if (!audioCtx) return;
  const osc = audioCtx.createOscillator();
  const gain = audioCtx.createGain();
  osc.connect(gain);
  gain.connect(audioCtx.destination);
  const now = audioCtx.currentTime;

  switch(type) {
    case 'punch':
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(150, now);
      osc.frequency.exponentialRampToValueAtTime(50, now + 0.1);
      gain.gain.setValueAtTime(0.3, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.15);
      osc.start(now); osc.stop(now + 0.15);
      break;
    case 'kick':
      osc.type = 'square';
      osc.frequency.setValueAtTime(200, now);
      osc.frequency.exponentialRampToValueAtTime(40, now + 0.15);
      gain.gain.setValueAtTime(0.35, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.2);
      osc.start(now); osc.stop(now + 0.2);
      break;
    case 'hit':
      // Noise-like hit sound
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(800, now);
      osc.frequency.exponentialRampToValueAtTime(100, now + 0.08);
      gain.gain.setValueAtTime(0.25, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.1);
      osc.start(now); osc.stop(now + 0.1);
      break;
    case 'grunt':
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(120, now);
      osc.frequency.linearRampToValueAtTime(80, now + 0.2);
      gain.gain.setValueAtTime(0.2, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);
      osc.start(now); osc.stop(now + 0.25);
      break;
    case 'death':
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(300, now);
      osc.frequency.exponentialRampToValueAtTime(30, now + 0.5);
      gain.gain.setValueAtTime(0.3, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.5);
      osc.start(now); osc.stop(now + 0.5);
      break;
    case 'coin':
      osc.type = 'square';
      osc.frequency.setValueAtTime(1200, now);
      osc.frequency.setValueAtTime(1600, now + 0.08);
      gain.gain.setValueAtTime(0.15, now);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.2);
      osc.start(now); osc.stop(now + 0.2);
      break;
  }
}

// ── Animation Data ──
const playerAnims = ${JSON.stringify(playerAnims)};
const enemyAnims = ${JSON.stringify(enemyAnims)};

// ── Game State ──
let gameState = 'loading'; // loading, boot, title, cutscene, mission, gameplay, gameover
let stateTimer = 0;
let cutsceneFrame = 0;
let missionFrame = 0;

// Player
const player = {
  x: 80, y: 180, // screen position
  hp: 100, maxHp: 100,
  score: 0,
  lives: 3,
  facing: 1, // 1=right, -1=left
  state: 'idle', // idle, walk, punch, kick, jump, damage
  animFrame: 0,
  animTimer: 0,
  attackTimer: 0,
  damageTimer: 0,
  jumpVy: 0,
  jumpY: 0,
  isJumping: false,
  speed: 1.5,
  attackCooldown: 0,
  invincible: 0,
};

// Camera/scroll
let scrollX = 0;
const STAGE_WIDTH = 512; // Total stage width in world coords

// Enemies
let enemies = [];
let nextEnemyTimer = 0;
let enemiesDefeated = 0;
const MAX_ENEMIES_ON_SCREEN = 3;
const TOTAL_ENEMIES = 12;
let enemiesSpawned = 0;

function spawnEnemy() {
  if (enemiesSpawned >= TOTAL_ENEMIES) return;
  if (enemies.length >= MAX_ENEMIES_ON_SCREEN) return;

  const side = Math.random() > 0.5 ? 1 : -1;
  const ex = side > 0 ? player.x + W + 20 : player.x - 40;
  enemies.push({
    x: ex,
    y: 170 + Math.random() * 30,
    hp: 30,
    maxHp: 30,
    facing: -side,
    state: 'walk',
    animFrame: 0,
    animTimer: 0,
    attackTimer: 0,
    damageTimer: 0,
    speed: 0.5 + Math.random() * 0.3,
    attackCooldown: 0,
  });
  enemiesSpawned++;
}

function resetGame() {
  player.x = 80; player.y = 180;
  player.hp = player.maxHp;
  player.score = 0;
  player.lives = 3;
  player.state = 'idle';
  player.isJumping = false;
  player.jumpY = 0;
  player.invincible = 0;
  scrollX = 0;
  enemies = [];
  enemiesDefeated = 0;
  enemiesSpawned = 0;
  nextEnemyTimer = 120;
}

// ── Drawing Helpers ──
function drawImg(name, dx, dy, flipX) {
  const img = assets[name];
  if (!img) return;
  ctx.save();
  if (flipX) {
    ctx.translate(dx + img.width, dy);
    ctx.scale(-1, 1);
    ctx.drawImage(img, 0, 0);
  } else {
    ctx.drawImage(img, dx, dy);
  }
  ctx.restore();
}

function drawFullFrame(name) {
  const img = assets[name];
  if (img) ctx.drawImage(img, 0, 0, W, H);
}

function drawText(text, x, y, color, size) {
  ctx.fillStyle = color || '#fff';
  ctx.font = (size || 8) + 'px monospace';
  ctx.fillText(text, x, y);
}

// ── HUD Drawing ──
function drawHUD() {
  // Dark bar at top
  ctx.fillStyle = '#000';
  ctx.fillRect(0, 0, W, 24);

  // Player name and HP bar
  ctx.fillStyle = '#fff';
  ctx.font = '8px monospace';
  ctx.fillText('1P BILLY', 8, 10);

  // HP bar background
  ctx.fillStyle = '#333';
  ctx.fillRect(8, 14, 64, 6);
  // HP bar fill
  const hpRatio = player.hp / player.maxHp;
  ctx.fillStyle = hpRatio > 0.5 ? '#0a0' : (hpRatio > 0.25 ? '#aa0' : '#a00');
  ctx.fillRect(8, 14, Math.floor(64 * hpRatio), 6);
  ctx.strokeStyle = '#fff';
  ctx.strokeRect(8, 14, 64, 6);

  // Score
  ctx.fillStyle = '#ff0';
  ctx.fillText('SCORE', 140, 10);
  ctx.fillStyle = '#fff';
  ctx.fillText(String(player.score).padStart(6, '0'), 180, 10);

  // Stage indicator
  ctx.fillStyle = '#f80';
  ctx.fillText('STAGE 1', 200, 20);

  // Lives
  ctx.fillStyle = '#fff';
  ctx.fillText('x' + player.lives, 90, 20);

  // Enemy HP bars (for active enemies)
  enemies.forEach((e, i) => {
    const sx = Math.floor(e.x - scrollX);
    if (sx > -16 && sx < W + 16) {
      const barX = Math.max(4, Math.min(W - 36, sx - 16));
      const barY = 16;
      ctx.fillStyle = '#300';
      ctx.fillRect(barX, barY, 32, 3);
      ctx.fillStyle = '#f00';
      ctx.fillRect(barX, barY, Math.floor(32 * e.hp / e.maxHp), 3);
    }
  });
}

// ── Get animation frame image name ──
function getAnimFrame(anims, state, frame) {
  const arr = anims[state];
  if (!arr || arr.length === 0) {
    // Fallback to idle
    const idle = anims['idle'];
    if (!idle || idle.length === 0) return null;
    return idle[frame % idle.length];
  }
  return arr[frame % arr.length];
}

// ── Gameplay Update ──
function updateGameplay() {
  // ── Player Input ──
  if (player.damageTimer > 0) {
    player.damageTimer--;
    if (player.damageTimer === 0) {
      player.state = 'idle';
    }
  } else if (player.attackTimer > 0) {
    player.attackTimer--;
    if (player.attackTimer === 0) {
      player.state = 'idle';
    }
  } else {
    let moving = false;

    if (player.attackCooldown > 0) player.attackCooldown--;

    // Movement
    if (isLeft()) {
      player.x -= player.speed;
      player.facing = -1;
      moving = true;
    }
    if (isRight()) {
      player.x += player.speed;
      player.facing = 1;
      moving = true;
    }
    if (isUp()) { player.y -= player.speed * 0.7; moving = true; }
    if (isDown()) { player.y += player.speed * 0.7; moving = true; }

    // Clamp Y to walkable area
    player.y = Math.max(155, Math.min(215, player.y));
    // Clamp X to stage bounds
    player.x = Math.max(8, Math.min(STAGE_WIDTH - 8, player.x));

    // Attacks
    if (isPunch() && player.attackCooldown === 0 && !player.isJumping) {
      player.state = 'punch';
      player.attackTimer = 20;
      player.attackCooldown = 8;
      player.animFrame = 0;
      initAudio();
      playSound('punch');
      checkAttackHit(24, 10);
    } else if (isKick() && player.attackCooldown === 0 && !player.isJumping) {
      player.state = 'kick';
      player.attackTimer = 24;
      player.attackCooldown = 10;
      player.animFrame = 0;
      initAudio();
      playSound('kick');
      checkAttackHit(28, 15);
    } else if (isJump() && !player.isJumping) {
      player.isJumping = true;
      player.jumpVy = -4;
      player.jumpY = 0;
      player.state = 'jump';
      player.animFrame = 0;
    } else if (!player.isJumping && player.attackTimer === 0) {
      player.state = moving ? 'walk' : 'idle';
    }
  }

  // Jump physics
  if (player.isJumping) {
    player.jumpY += player.jumpVy;
    player.jumpVy += 0.25;
    if (player.jumpY >= 0) {
      player.jumpY = 0;
      player.isJumping = false;
      if (player.attackTimer === 0 && player.damageTimer === 0) {
        player.state = 'idle';
      }
    }
  }

  // Invincibility
  if (player.invincible > 0) player.invincible--;

  // ── Camera scroll ──
  const targetScroll = player.x - W / 3;
  scrollX = Math.max(0, Math.min(STAGE_WIDTH - W, targetScroll));

  // ── Enemy spawning ──
  if (nextEnemyTimer > 0) {
    nextEnemyTimer--;
  } else {
    spawnEnemy();
    nextEnemyTimer = 180 + Math.floor(Math.random() * 120);
  }

  // ── Enemy AI ──
  enemies.forEach(e => {
    if (e.damageTimer > 0) {
      e.damageTimer--;
      if (e.damageTimer === 0) e.state = 'walk';
      return;
    }
    if (e.attackTimer > 0) {
      e.attackTimer--;
      if (e.attackTimer === 0) e.state = 'walk';
      return;
    }

    const dx = player.x - e.x;
    const dy = player.y - e.y;
    const dist = Math.sqrt(dx * dx + dy * dy);

    e.facing = dx > 0 ? 1 : -1;

    if (dist < 28) {
      // Close enough to attack
      if (e.attackCooldown <= 0) {
        e.state = 'attack';
        e.attackTimer = 30;
        e.attackCooldown = 60;
        e.animFrame = 0;
        // Damage player
        if (player.invincible === 0 && player.damageTimer === 0) {
          player.hp -= 8;
          player.damageTimer = 20;
          player.state = 'damage';
          player.invincible = 40;
          initAudio();
          playSound('grunt');
          if (player.hp <= 0) {
            player.hp = 0;
            gameState = 'gameover';
            stateTimer = 0;
            playSound('death');
          }
        }
      } else {
        // Wait
        e.state = 'idle';
      }
    } else {
      // Walk toward player
      e.state = 'walk';
      e.x += Math.sign(dx) * e.speed;
      e.y += Math.sign(dy) * e.speed * 0.5;
      e.y = Math.max(155, Math.min(215, e.y));
    }

    if (e.attackCooldown > 0) e.attackCooldown--;
  });

  // Remove dead enemies
  enemies = enemies.filter(e => e.hp > 0);

  // ── Animation ──
  player.animTimer++;
  if (player.animTimer >= 8) {
    player.animTimer = 0;
    player.animFrame++;
  }

  enemies.forEach(e => {
    e.animTimer++;
    if (e.animTimer >= 10) {
      e.animTimer = 0;
      e.animFrame++;
    }
  });
}

function checkAttackHit(range, damage) {
  enemies.forEach(e => {
    const dx = e.x - player.x;
    const dy = Math.abs(e.y - player.y);
    const dist = Math.abs(dx);

    // Check if enemy is in front of player and within range
    if (dist < range && dy < 20 && Math.sign(dx) === player.facing) {
      e.hp -= damage;
      e.damageTimer = 15;
      e.state = 'idle';
      e.x += player.facing * 8;

      initAudio();
      playSound('hit');

      if (e.hp <= 0) {
        player.score += 200;
        enemiesDefeated++;
        playSound('death');
      } else {
        player.score += 50;
      }
    }
  });
}

// ── Draw Gameplay ──
function drawGameplay() {
  // Draw background - tile/scroll the bg image
  const bg = assets['bg_stage1.png'];
  if (bg) {
    // Draw background offset by scroll
    const sx = Math.floor(scrollX);
    // We tile the background
    const bgOffX = -(sx % W);
    ctx.drawImage(bg, bgOffX, 0, W, H);
    if (bgOffX < 0) {
      ctx.drawImage(bg, bgOffX + W, 0, W, H);
    }
  } else {
    // Fallback solid background
    ctx.fillStyle = '#556';
    ctx.fillRect(0, 0, W, H);
  }

  // Draw entities sorted by Y for depth
  const entities = [];
  entities.push({ type: 'player', y: player.y, data: player });
  enemies.forEach(e => entities.push({ type: 'enemy', y: e.y, data: e }));
  entities.sort((a, b) => a.y - b.y);

  entities.forEach(ent => {
    if (ent.type === 'player') {
      const p = ent.data;
      const sx = Math.floor(p.x - scrollX);
      const sy = Math.floor(p.y + p.jumpY);

      // Flash when invincible
      if (p.invincible > 0 && (p.invincible % 4) < 2) return;

      const frameName = getAnimFrame(playerAnims, p.state, p.animFrame);
      if (frameName && assets[frameName]) {
        const img = assets[frameName];
        const drawX = sx - Math.floor(img.width / 2);
        const drawY = sy - img.height + 16;
        drawImg(frameName, drawX, drawY, p.facing === -1);
      } else {
        // Fallback: draw a simple rectangle
        ctx.fillStyle = '#38e';
        ctx.fillRect(sx - 8, sy - 32, 16, 32);
        ctx.fillStyle = '#fb9';
        ctx.fillRect(sx - 6, sy - 40, 12, 10);
      }

      // Draw shadow
      ctx.fillStyle = 'rgba(0,0,0,0.3)';
      ctx.beginPath();
      ctx.ellipse(sx, Math.floor(p.y) + 8, 12, 4, 0, 0, Math.PI * 2);
      ctx.fill();

    } else if (ent.type === 'enemy') {
      const e = ent.data;
      const sx = Math.floor(e.x - scrollX);
      const sy = Math.floor(e.y);

      if (sx < -32 || sx > W + 32) return;

      const frameName = getAnimFrame(enemyAnims, e.state, e.animFrame);
      if (frameName && assets[frameName]) {
        const img = assets[frameName];
        const drawX = sx - Math.floor(img.width / 2);
        const drawY = sy - img.height + 16;
        drawImg(frameName, drawX, drawY, e.facing === -1);
      } else {
        // Fallback
        ctx.fillStyle = '#a33';
        ctx.fillRect(sx - 8, sy - 32, 16, 32);
        ctx.fillStyle = '#fb9';
        ctx.fillRect(sx - 6, sy - 40, 12, 10);
      }

      // Shadow
      ctx.fillStyle = 'rgba(0,0,0,0.3)';
      ctx.beginPath();
      ctx.ellipse(sx, sy + 8, 10, 3, 0, 0, Math.PI * 2);
      ctx.fill();
    }
  });

  // HUD on top
  drawHUD();
}

// ── Main Game Loop ──
function tick() {
  ctx.fillStyle = '#000';
  ctx.fillRect(0, 0, W, H);

  switch (gameState) {
    case 'loading':
      ctx.fillStyle = '#fff';
      ctx.font = '8px monospace';
      ctx.fillText('LOADING...', 100, 120);
      ctx.fillText(assetsLoaded + '/' + totalAssets, 112, 135);
      break;

    case 'boot':
      drawFullFrame('boot.png');
      stateTimer++;
      if (stateTimer > 90) {
        gameState = 'title';
        stateTimer = 0;
      }
      break;

    case 'title':
      // Alternate between title frames for a flicker effect
      if (stateTimer % 120 < 60) {
        drawFullFrame('title.png');
      } else {
        drawFullFrame('title2.png');
      }
      stateTimer++;

      // Draw blinking "PRESS START"
      if (stateTimer % 40 < 25) {
        ctx.fillStyle = '#ff0';
        ctx.font = '10px monospace';
        ctx.fillText('PRESS ENTER TO START', 48, 200);
      }

      if (isStart()) {
        initAudio();
        playSound('coin');
        gameState = 'cutscene';
        stateTimer = 0;
        cutsceneFrame = 0;
        keys['Enter'] = false;
        keys['Space'] = false;
      }
      break;

    case 'cutscene':
      stateTimer++;
      cutsceneFrame = Math.min(6, Math.floor(stateTimer / 90));
      drawFullFrame('cutscene_' + cutsceneFrame + '.png');

      if (stateTimer > 630 || isStart()) {
        gameState = 'mission';
        stateTimer = 0;
        missionFrame = 0;
        keys['Enter'] = false;
        keys['Space'] = false;
      }
      break;

    case 'mission':
      stateTimer++;
      if (stateTimer < 60) {
        drawFullFrame('mission1.png');
      } else if (stateTimer < 120) {
        drawFullFrame('mission1b.png');
      } else {
        drawFullFrame('mission1c.png');
      }

      // "MISSION 1" text overlay
      ctx.fillStyle = '#000';
      ctx.fillRect(60, 100, 136, 40);
      ctx.fillStyle = '#f80';
      ctx.font = 'bold 12px monospace';
      ctx.fillText('MISSION 1', 82, 118);
      ctx.fillStyle = '#fff';
      ctx.font = '8px monospace';
      ctx.fillText('THE REVENGE BEGINS', 70, 132);

      if (stateTimer > 180 || isStart()) {
        gameState = 'gameplay';
        stateTimer = 0;
        resetGame();
        keys['Enter'] = false;
        keys['Space'] = false;
      }
      break;

    case 'gameplay':
      updateGameplay();
      drawGameplay();
      stateTimer++;

      // Win condition
      if (enemiesDefeated >= TOTAL_ENEMIES && enemies.length === 0) {
        ctx.fillStyle = 'rgba(0,0,0,0.5)';
        ctx.fillRect(0, 0, W, H);
        ctx.fillStyle = '#ff0';
        ctx.font = 'bold 12px monospace';
        ctx.fillText('STAGE CLEAR!', 80, 110);
        ctx.fillStyle = '#fff';
        ctx.font = '8px monospace';
        ctx.fillText('SCORE: ' + String(player.score).padStart(6, '0'), 85, 130);
        ctx.fillText('PRESS ENTER TO CONTINUE', 40, 160);
        if (isStart()) {
          gameState = 'title';
          stateTimer = 0;
          keys['Enter'] = false;
          keys['Space'] = false;
        }
      }
      break;

    case 'gameover':
      // Still show the gameplay behind
      drawGameplay();

      // Darken overlay
      ctx.fillStyle = 'rgba(0,0,0,0.6)';
      ctx.fillRect(0, 0, W, H);

      stateTimer++;

      ctx.fillStyle = '#f00';
      ctx.font = 'bold 14px monospace';
      ctx.fillText('GAME OVER', 82, 100);

      ctx.fillStyle = '#fff';
      ctx.font = '8px monospace';
      ctx.fillText('FINAL SCORE: ' + String(player.score).padStart(6, '0'), 68, 125);

      if (stateTimer > 60) {
        if (stateTimer % 40 < 25) {
          ctx.fillText('PRESS ENTER TO CONTINUE', 40, 155);
        }
        if (isStart()) {
          gameState = 'title';
          stateTimer = 0;
          keys['Enter'] = false;
          keys['Space'] = false;
        }
      }
      break;
  }
}

// ── Start ──
loadAssets(() => {
  gameState = 'boot';
  stateTimer = 0;
  setInterval(tick, 16);
});

// Show loading screen while assets load
setInterval(() => {
  if (gameState === 'loading') tick();
}, 100);
</script>
</body>
</html>`;

fs.writeFileSync(path.join(OUTPUT, 'index.html'), gameHTML);
console.log('  Written index.html');

// ── Step 7: Verification ──
console.log('\n[7] Verification...');
const outputFiles = fs.readdirSync(ASSETS);
console.log(`  Assets generated: ${outputFiles.length} files`);
console.log(`  Player animations:`);
for (const [key, frames] of Object.entries(spriteManifest.player)) {
  console.log(`    ${key}: ${frames.length} frames`);
}
console.log(`  Enemy animations:`);
for (const [key, frames] of Object.entries(spriteManifest.enemy)) {
  console.log(`    ${key}: ${frames.length} frames`);
}

// Check that key sprite files exist and have reasonable sizes
const criticalFiles = ['title.png', 'bg_stage1.png', 'mission1.png'];
for (const f of criticalFiles) {
  const fp = path.join(ASSETS, f);
  if (fs.existsSync(fp)) {
    const stat = fs.statSync(fp);
    console.log(`  ✓ ${f}: ${stat.size} bytes`);
  } else {
    console.log(`  ✗ ${f}: MISSING`);
  }
}

// Check a player sprite has proper skin tones
if (spriteManifest.player.idle.length > 0) {
  const testFile = path.join(ASSETS, spriteManifest.player.idle[0].file);
  const testPng = PNG.sync.read(fs.readFileSync(testFile));
  const colors = new Map();
  for (let i = 0; i < testPng.data.length; i += 4) {
    if (testPng.data[i + 3] > 0) {
      const key = testPng.data[i] + ',' + testPng.data[i+1] + ',' + testPng.data[i+2];
      colors.set(key, (colors.get(key) || 0) + 1);
    }
  }
  const sortedColors = [...colors.entries()].sort((a, b) => b[1] - a[1]);
  console.log('  Top colors in player idle sprite:');
  sortedColors.slice(0, 10).forEach(([c, n]) => {
    const [r, g, b] = c.split(',').map(Number);
    const hex = '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');
    console.log('    ' + hex + ': ' + n + ' pixels');
  });
}

console.log('\n=== Build Complete ===');
console.log('Open dd2-final/index.html in a browser to play!');
console.log('Controls: WASD/Arrows=Move, Z/J=Punch, X/K=Kick, Space/C=Jump, Enter=Start');
