#!/usr/bin/env node
/**
 * Scan the decoded sprite tiles to find character frames.
 *
 * Strategy: DD2 characters are composed of multiple 16x16 tiles arranged
 * in a grid. Adjacent tiles in the ROM that form a character will have:
 * 1. Similar color usage (same palette)
 * 2. Content that "connects" at edges
 * 3. Sequential or near-sequential tile indices
 *
 * We analyze the sprite tile data to find groups of tiles that form characters.
 */

const fs = require('fs');
const path = require('path');

const ROM_DIR = __dirname;

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// Decode sprites using the same MAME layout as extract-assets.js
const spriteRoms = ['26j0-0.bin','26j1-0.bin','26j2-0.bin','26j3-0.bin','26j4-0.bin','26j5-0.bin'];
const spriteChunks = spriteRoms.map(n => loadROM(n));
const spriteTotalLen = spriteChunks.reduce((s, r) => s + r.length, 0);
const spriteCombined = new Uint8Array(spriteTotalLen);
let offset = 0;
for (const chunk of spriteChunks) {
  spriteCombined.set(chunk, offset);
  offset += chunk.length;
}

const SPRITE_HALF = spriteCombined.length * 8 / 2;
const TILE_FULL = 1024; // bits per tile in one half
const numTiles = Math.floor(spriteCombined.length / 2 / 128);

console.log(`Total sprite tiles: ${numTiles}`);

// Decode all tiles to pixel arrays (4bpp, values 0-15)
function decodeTile(tileIndex) {
  const planes = [SPRITE_HALF + 0, SPRITE_HALF + 4, 0, 4];
  const xoff = [3, 2, 1, 0, 19, 18, 17, 16, 259, 258, 257, 256, 275, 274, 273, 272];
  const yoff16 = [];
  for (let i = 0; i < 8; i++) yoff16.push(i * 32);
  for (let i = 0; i < 8; i++) yoff16.push(512 + i * 32);

  const tileBase = tileIndex * TILE_FULL;
  const pixels = new Uint8Array(256); // 16x16

  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      let pixel = 0;
      for (let p = 0; p < 4; p++) {
        const bitPos = tileBase + yoff16[y] + xoff[x] + planes[p];
        const byteIdx = Math.floor(bitPos / 8);
        const bitIdx = bitPos % 8;
        if (byteIdx < spriteCombined.length) {
          pixel |= (((spriteCombined[byteIdx] >> bitIdx) & 1) << p);
        }
      }
      pixels[y * 16 + x] = pixel;
    }
  }
  return pixels;
}

// Analyze each tile
const tileStats = [];
for (let t = 0; t < numTiles; t++) {
  const px = decodeTile(t);
  const nonZero = px.filter(p => p !== 0).length;
  const colors = new Set(px);
  const colorCount = colors.size;

  // Check if tile has content in specific regions (top/bottom/left/right)
  let topContent = 0, botContent = 0, leftContent = 0, rightContent = 0;
  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      if (px[y * 16 + x] !== 0) {
        if (y < 8) topContent++; else botContent++;
        if (x < 8) leftContent++; else rightContent++;
      }
    }
  }

  tileStats.push({
    index: t,
    nonZero,
    colorCount,
    topContent, botContent, leftContent, rightContent,
  });
}

// Find groups of consecutive tiles that look like character parts
// A character frame in DD2 is typically 2-wide x 3-tall (6 tiles)
// or 2x2 (4 tiles) for smaller characters

console.log('\n=== Looking for character frame groups ===');

// Score how well a group of tiles "fits" as a character frame
function scoreGroup(startIdx, width, height) {
  const tiles = [];
  for (let r = 0; r < height; r++) {
    for (let c = 0; c < width; c++) {
      const idx = startIdx + r * width + c;
      if (idx >= numTiles) return -1;
      tiles.push(tileStats[idx]);
    }
  }

  // Character frame criteria:
  // 1. Most tiles have some content
  const withContent = tiles.filter(t => t.nonZero > 5).length;
  if (withContent < tiles.length * 0.4) return -1;

  // 2. Color counts are similar (same palette)
  const avgColors = tiles.reduce((s, t) => s + t.colorCount, 0) / tiles.length;

  // 3. Top row has head content, bottom has feet
  // For 2x3: row0=head, row1=torso, row2=legs

  // 4. Content should be centered (not just edge noise)
  const totalContent = tiles.reduce((s, t) => s + t.nonZero, 0);

  return withContent * 10 + totalContent / 10 + avgColors;
}

// Scan for 2x3 character frames
const frames2x3 = [];
for (let t = 0; t < numTiles - 5; t++) {
  const score = scoreGroup(t, 2, 3);
  if (score > 40) {
    frames2x3.push({ start: t, score, tiles: [t, t+1, t+2, t+3, t+4, t+5] });
  }
}

// Remove overlapping groups (keep highest scoring)
frames2x3.sort((a, b) => b.score - a.score);
const selected2x3 = [];
const used = new Set();
for (const f of frames2x3) {
  if (f.tiles.some(t => used.has(t))) continue;
  selected2x3.push(f);
  f.tiles.forEach(t => used.add(t));
}

console.log(`Found ${selected2x3.length} potential 2x3 character frames`);
selected2x3.sort((a, b) => a.start - b.start);

// Print first 30
for (const f of selected2x3.slice(0, 50)) {
  const details = f.tiles.map(t => {
    const s = tileStats[t];
    return `${t}(${s.nonZero}px,${s.colorCount}c)`;
  }).join(' ');
  console.log(`  tiles[${f.start}-${f.start+5}] score=${f.score.toFixed(0)}: ${details}`);
}

// Also look for 2x2 frames (smaller enemies/projectiles)
console.log('\n=== 2x2 frames (32x32 sprites) ===');
const frames2x2 = [];
used.clear();
for (let t = 0; t < numTiles - 3; t++) {
  const score = scoreGroup(t, 2, 2);
  if (score > 30) {
    frames2x2.push({ start: t, score, tiles: [t, t+1, t+2, t+3] });
  }
}
frames2x2.sort((a, b) => b.score - a.score);
const selected2x2 = [];
for (const f of frames2x2) {
  if (f.tiles.some(t => used.has(t))) continue;
  selected2x2.push(f);
  f.tiles.forEach(t => used.add(t));
}
console.log(`Found ${selected2x2.length} potential 2x2 frames`);
selected2x2.sort((a, b) => a.start - b.start);
for (const f of selected2x2.slice(0, 30)) {
  console.log(`  tiles[${f.start}-${f.start+3}] score=${f.score.toFixed(0)}`);
}

// ── Now look at how the ROM CPU code references tiles ──
// The sprite attribute table format: [Y, tile, attr, X]
// Tile number in DD2 is 8 bits (0-255) but with bank bits in attributes
// attr bits: bit7=flipY, bit6=flipX, bit5=size?, bit4=bank, bit3-0=palette
// So effective tile = (attr.bit4 << 8) | tile_byte = 0-511 range
// But we have 6144 tiles... so there must be more bank bits or tile number is wider

// Actually DD2 hardware uses sprite entries differently.
// Let me check the actual hardware: DD2 uses the same Technos hardware as DD1
// Sprite format is actually:
//   word 0: code (tile number, full 16-bit?)
//   word 1: attributes
//   word 2: Y position
//   word 3: X position
// = 8 bytes per sprite, not 4

// With 2KB sprite RAM ($1000-$17FF) / 8 bytes = 256 sprites max
// Tile code can be up to 16 bits = 0-65535, but limited by actual tile count

// Let's look at what tile ranges have the most content
console.log('\n=== Tile content density by range ===');
for (let base = 0; base < numTiles; base += 64) {
  const end = Math.min(base + 64, numTiles);
  let totalContent = 0;
  let tilesWithContent = 0;
  for (let t = base; t < end; t++) {
    if (tileStats[t].nonZero > 10) {
      totalContent += tileStats[t].nonZero;
      tilesWithContent++;
    }
  }
  if (tilesWithContent > 20) {
    console.log(`  tiles ${base}-${end-1}: ${tilesWithContent} active tiles, avg ${(totalContent/tilesWithContent).toFixed(0)} pixels`);
  }
}

// Output the findings
const output = {
  totalTiles: numTiles,
  frames2x3: selected2x3.slice(0, 100).map(f => ({
    startTile: f.start,
    tiles: f.tiles,
    score: Math.round(f.score),
  })),
  frames2x2: selected2x2.slice(0, 100).map(f => ({
    startTile: f.start,
    tiles: f.tiles,
    score: Math.round(f.score),
  })),
  tileRanges: [],
};

// Build ranges of dense tile content
let rangeStart = -1;
for (let t = 0; t < numTiles; t++) {
  if (tileStats[t].nonZero > 10) {
    if (rangeStart === -1) rangeStart = t;
  } else {
    if (rangeStart !== -1 && t - rangeStart >= 4) {
      output.tileRanges.push({ start: rangeStart, end: t - 1, count: t - rangeStart });
    }
    rangeStart = -1;
  }
}

console.log(`\nDense tile ranges: ${output.tileRanges.length}`);
for (const r of output.tileRanges.slice(0, 20)) {
  console.log(`  tiles ${r.start}-${r.end} (${r.count} tiles)`);
}

fs.writeFileSync(
  path.join(__dirname, 'output', 'tile-analysis.json'),
  JSON.stringify(output, null, 2)
);
console.log('\nSaved to output/tile-analysis.json');
