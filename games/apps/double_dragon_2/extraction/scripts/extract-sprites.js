#!/usr/bin/env node
/**
 * Extract character sprites by cropping from MAME screenshots.
 * Crops ONLY around Billy, using head position to anchor.
 * Billy is always near his head sprites. Jimmy is excluded by tight cropping.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const MAME_DIR = path.join(__dirname, 'mame-extract');
const SNAP_DIR = path.join(process.env.HOME, '.mame/snap/ddragon2u');
const ASSETS_DIR = path.join(__dirname, 'game/public/assets');
const OUT_DIR = path.join(__dirname, 'game-final/assets');

const TILES_PER_ROW = 64;
const TILE_SIZE = 16;

function loadPNG(fp) { return PNG.sync.read(fs.readFileSync(fp)); }
function savePNG(png, fp) { fs.writeFileSync(fp, PNG.sync.write(png)); }

function getTilePixel(sheet, tileNum, px, py) {
  const col = tileNum % TILES_PER_ROW;
  const row = Math.floor(tileNum / TILES_PER_ROW);
  const sx = col * TILE_SIZE + px;
  const sy = row * TILE_SIZE + py;
  if (sx < 0 || sx >= sheet.width || sy < 0 || sy >= sheet.height) return [0,0,0,0];
  const idx = (sy * sheet.width + sx) * 4;
  return [sheet.data[idx], sheet.data[idx+1], sheet.data[idx+2], sheet.data[idx+3]];
}

function drawTile(target, sheet, tileNum, dx, dy, flipX, flipY) {
  for (let py = 0; py < TILE_SIZE; py++) {
    for (let px = 0; px < TILE_SIZE; px++) {
      const srcPx = flipX ? (TILE_SIZE - 1 - px) : px;
      const srcPy = flipY ? (TILE_SIZE - 1 - py) : py;
      const [r, g, b, a] = getTilePixel(sheet, tileNum, srcPx, srcPy);
      if (a === 0) continue;
      const tx = dx + px;
      const ty = dy + py;
      if (tx < 0 || tx >= target.width || ty < 0 || ty >= target.height) continue;
      const idx = (ty * target.width + tx) * 4;
      target.data[idx] = r; target.data[idx+1] = g; target.data[idx+2] = b; target.data[idx+3] = 255;
    }
  }
}

function drawSprite(target, sheet, sprite, offsetX, offsetY) {
  const { tile, size, sx, sy, flipX, flipY } = sprite;
  if (size === 1) {
    if (flipY) {
      drawTile(target, sheet, tile + 1, sx - offsetX, sy - 16 - offsetY, flipX, flipY);
      drawTile(target, sheet, tile, sx - offsetX, sy - offsetY, flipX, flipY);
    } else {
      drawTile(target, sheet, tile, sx - offsetX, sy - 16 - offsetY, flipX, flipY);
      drawTile(target, sheet, tile + 1, sx - offsetX, sy - offsetY, flipX, flipY);
    }
  } else {
    drawTile(target, sheet, tile, sx - offsetX, sy - offsetY, flipX, flipY);
  }
}

/**
 * Identify which sprites belong to Billy.
 * In MAME's sprite array, Billy's sprites come first (body + head),
 * followed by Jimmy's sprites. The last head sprite (color=0) marks the boundary.
 */
function findBillySprites(allSprites) {
  // Find the last head sprite index (color 0, tile < 300)
  let lastHeadIdx = -1;
  for (let i = 0; i < allSprites.length; i++) {
    if (allSprites[i].color === 0 && allSprites[i].tile < 300) {
      lastHeadIdx = i;
    }
  }
  if (lastHeadIdx < 0) return [];

  // Billy = all sprites from 0 to lastHeadIdx (inclusive)
  // Filter to only color 0 and 2 (exclude any stray color 5 enemies)
  return allSprites.slice(0, lastHeadIdx + 1).filter(s => s.color === 0 || s.color === 2);
}

function main() {
  console.log('Loading sprite sheets...');
  // Use palette-specific sheets: pal0 for head (color=0), pal2 for body (color=2), pal5 for enemy
  const palSheets = {};
  for (const i of [0, 2, 5]) {
    const p = path.join(ASSETS_DIR, `sprites-pal${i}.png`);
    palSheets[i] = loadPNG(p);
    console.log(`  Loaded sprites-pal${i}.png`);
  }

  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.copyFileSync(path.join(ASSETS_DIR, 'stage1-bg.png'), path.join(OUT_DIR, 'stage1-bg.png'));

  const frameFiles = fs.readdirSync(MAME_DIR).filter(f => f.endsWith('.json')).sort();
  console.log(`\nProcessing ${frameFiles.length} frames...`);

  const seenPoses = {};
  const animFrameCounts = {};

  for (const file of frameFiles) {
    const frameData = JSON.parse(fs.readFileSync(path.join(MAME_DIR, file), 'utf8'));
    const label = file.split('_').slice(1).join('_').replace('.json', '');

    const charSprites = frameData.sprites.filter(s => s.color === 0 || s.color === 2);
    const billySprites = findBillySprites(frameData.sprites);

    if (billySprites.length < 3) continue;

    // Get bounds
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    for (const s of billySprites) {
      const topY = s.size === 1 ? s.sy - 16 : s.sy;
      minX = Math.min(minX, s.sx);
      minY = Math.min(minY, topY);
      maxX = Math.max(maxX, s.sx + 16);
      maxY = Math.max(maxY, s.sy + 16);
    }

    const pad = 2;
    const w = (maxX - minX) + pad * 2;
    const h = (maxY - minY) + pad * 2;

    if (w > 150 || h > 130) {
      console.log(`  Skip ${file}: too large ${w}x${h} (${billySprites.length} sprites)`);
      continue;
    }

    // Deduplicate
    const poseKey = billySprites.map(s => `${s.tile},${s.color}`).sort().join('|');
    if (!seenPoses[label]) seenPoses[label] = new Set();
    if (seenPoses[label].has(poseKey)) continue;
    seenPoses[label].add(poseKey);

    if (!animFrameCounts[label]) animFrameCounts[label] = 0;
    const idx = animFrameCounts[label]++;

    // Render
    const png = new PNG({ width: w, height: h, filterType: -1 });
    png.data.fill(0);

    // Draw order: body (c2 high tiles) -> legs (c2 low tiles) -> head (c0)
    const sorted = [...billySprites].sort((a, b) => {
      const la = a.color === 0 ? 2 : (a.tile >= 2500 ? 0 : 1);
      const lb = b.color === 0 ? 2 : (b.tile >= 2500 ? 0 : 1);
      return la - lb;
    });

    for (const sprite of sorted) {
      const sheet = palSheets[sprite.color];
      if (!sheet) continue;
      drawSprite(png, sheet, sprite, minX - pad, minY - pad);
    }

    const name = `billy_${label}_${idx}.png`;
    savePNG(png, path.join(OUT_DIR, name));
    console.log(`  ${name} (${w}x${h}) [${billySprites.length} sprites]`);
  }

  // Enemy sprites from approach frames
  for (const file of frameFiles) {
    const frameData = JSON.parse(fs.readFileSync(path.join(MAME_DIR, file), 'utf8'));
    const enemySprites = frameData.sprites.filter(s => s.color === 5 && s.sx >= 10 && s.sx < 240);
    if (enemySprites.length === 0) continue;

    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    for (const s of enemySprites) {
      const topY = s.size === 1 ? s.sy - 16 : s.sy;
      minX = Math.min(minX, s.sx);
      minY = Math.min(minY, topY);
      maxX = Math.max(maxX, s.sx + 16);
      maxY = Math.max(maxY, s.sy + 16);
    }

    const pad = 2;
    const w = (maxX - minX) + pad * 2;
    const h = (maxY - minY) + pad * 2;
    if (w < 10 || h < 20) continue;

    const eKey = 'enemy';
    const ePoseKey = enemySprites.map(s => `${s.tile}`).sort().join(',');
    if (!seenPoses[eKey]) seenPoses[eKey] = new Set();
    if (seenPoses[eKey].has(ePoseKey)) continue;
    seenPoses[eKey].add(ePoseKey);
    if (!animFrameCounts[eKey]) animFrameCounts[eKey] = 0;
    const idx = animFrameCounts[eKey]++;

    const png = new PNG({ width: w, height: h, filterType: -1 });
    png.data.fill(0);
    for (const sprite of enemySprites) {
      const sheet = palSheets[sprite.color];
      if (!sheet) continue;
      drawSprite(png, sheet, sprite, minX - pad, minY - pad);
    }

    const name = `enemy_walk_${idx}.png`;
    savePNG(png, path.join(OUT_DIR, name));
    console.log(`  ${name} (${w}x${h})`);
  }

  console.log('\nFrame counts:');
  for (const [a, c] of Object.entries(animFrameCounts).sort()) {
    console.log(`  ${a}: ${c}`);
  }
  console.log('\nDone!');
}

main();
