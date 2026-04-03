#!/usr/bin/env node
/**
 * Compose character sprites by scanning for groups of tiles
 * that visually connect to form full character frames.
 *
 * DD2 characters are composed of multiple 16x16 tiles.
 * The hardware draws them individually, but groups of tiles
 * at specific offsets in the ROM form complete characters.
 *
 * Strategy: For each possible starting tile, try composing a
 * 2-column x N-row grid and score how well the tiles connect
 * (matching edge pixels, consistent color usage, reasonable content).
 * Then render the best compositions.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const OUT = path.join(__dirname, 'output', 'composed');
fs.mkdirSync(OUT, { recursive: true });

// Load the correctly decoded sprite tiles from the PNG
const spritePNG = PNG.sync.read(fs.readFileSync(
  path.join(__dirname, 'public', 'assets', 'sprites-player1.png')
));
const TILE = 16;
const SHEET_COLS = 64;

// Read a tile from the sprite sheet as a 16x16 array of [r,g,b,a]
function readTile(idx) {
  const px = [];
  const srcX = (idx % SHEET_COLS) * TILE;
  const srcY = Math.floor(idx / SHEET_COLS) * TILE;
  for (let y = 0; y < TILE; y++) {
    for (let x = 0; x < TILE; x++) {
      const si = ((srcY + y) * spritePNG.width + (srcX + x)) * 4;
      px.push([
        spritePNG.data[si], spritePNG.data[si+1],
        spritePNG.data[si+2], spritePNG.data[si+3]
      ]);
    }
  }
  return px;
}

// Check if a tile has content (non-transparent pixels)
function tileContent(px) {
  let count = 0;
  for (let i = 0; i < px.length; i++) {
    if (px[i][3] > 0) count++;
  }
  return count;
}

// Score edge connectivity between bottom of top tile and top of bottom tile
function verticalEdgeScore(topPx, bottomPx) {
  let score = 0;
  for (let x = 0; x < TILE; x++) {
    const topPixel = topPx[(TILE-1) * TILE + x];
    const botPixel = bottomPx[x];
    // Both have content near the edge -> likely connected
    if (topPixel[3] > 0 && botPixel[3] > 0) score += 2;
    // One has content -> partial connection
    else if (topPixel[3] > 0 || botPixel[3] > 0) score += 0.5;
  }
  return score;
}

// Score edge connectivity between right of left tile and left of right tile
function horizontalEdgeScore(leftPx, rightPx) {
  let score = 0;
  for (let y = 0; y < TILE; y++) {
    const leftPixel = leftPx[y * TILE + (TILE-1)];
    const rightPixel = rightPx[y * TILE];
    if (leftPixel[3] > 0 && rightPixel[3] > 0) score += 2;
    else if (leftPixel[3] > 0 || rightPixel[3] > 0) score += 0.5;
  }
  return score;
}

const TOTAL_TILES = Math.floor(spritePNG.width / TILE) * Math.floor(spritePNG.height / TILE);
console.log(`Total tiles in sheet: ${TOTAL_TILES}`);

// Pre-read all tiles
console.log('Reading all tiles...');
const allTiles = [];
const contentCounts = [];
for (let i = 0; i < TOTAL_TILES; i++) {
  const px = readTile(i);
  allTiles.push(px);
  contentCounts.push(tileContent(px));
}

// Find groups of 6 consecutive tiles (2x3) that form character sprites
// DD2 stores character tiles in sequential groups
console.log('Scanning for 2x3 character compositions (sequential tiles)...');

const compositions = [];

for (let start = 0; start < TOTAL_TILES - 5; start++) {
  // Check if 6 consecutive tiles form a good 2x3 character
  const tiles = [start, start+1, start+2, start+3, start+4, start+5];

  // Layout: col0  col1
  //         [0]   [1]    row 0 (head)
  //         [2]   [3]    row 1 (torso)
  //         [4]   [5]    row 2 (legs)

  const content = tiles.map(t => contentCounts[t]);
  const totalContent = content.reduce((s, c) => s + c, 0);

  // Need reasonable content - not empty, not all full
  if (totalContent < 60 || totalContent > 1400) continue;
  // At least 4 tiles must have content
  if (content.filter(c => c > 5).length < 4) continue;

  // Score vertical connectivity
  let edgeScore = 0;
  edgeScore += verticalEdgeScore(allTiles[start], allTiles[start+2]); // col0 row0->row1
  edgeScore += verticalEdgeScore(allTiles[start+2], allTiles[start+4]); // col0 row1->row2
  edgeScore += verticalEdgeScore(allTiles[start+1], allTiles[start+3]); // col1 row0->row1
  edgeScore += verticalEdgeScore(allTiles[start+3], allTiles[start+5]); // col1 row1->row2
  edgeScore += horizontalEdgeScore(allTiles[start], allTiles[start+1]); // row0 col0->col1
  edgeScore += horizontalEdgeScore(allTiles[start+2], allTiles[start+3]); // row1
  edgeScore += horizontalEdgeScore(allTiles[start+4], allTiles[start+5]); // row2

  // Head should have content mainly in lower portion
  // Legs should have content mainly in upper portion
  // (feet don't go to the very bottom usually)

  const score = edgeScore + totalContent / 20;

  if (score > 15) {
    compositions.push({ start, tiles, score, totalContent });
  }
}

// Sort by score
compositions.sort((a, b) => b.score - a.score);

// Remove overlapping (keep best)
const used = new Set();
const selected = [];
for (const comp of compositions) {
  if (comp.tiles.some(t => used.has(t))) continue;
  selected.push(comp);
  comp.tiles.forEach(t => used.add(t));
}

console.log(`Found ${selected.length} character compositions`);

// Re-sort by tile index for organized output
selected.sort((a, b) => a.start - b.start);

// Render all compositions into a sprite sheet
// Each composition is 32x48 pixels, render at 3x scale
const ZOOM = 3;
const COMP_W = 32 * ZOOM;
const COMP_H = 48 * ZOOM;
const COLS = 16;
const rows = Math.ceil(selected.length / COLS);
const sheetW = COLS * COMP_W;
const sheetH = rows * COMP_H;

const sheet = new PNG({ width: sheetW, height: sheetH });
// Fill with dark bg
for (let i = 0; i < sheet.data.length; i += 4) {
  sheet.data[i] = 20; sheet.data[i+1] = 20; sheet.data[i+2] = 30; sheet.data[i+3] = 255;
}

for (let ci = 0; ci < selected.length; ci++) {
  const comp = selected[ci];
  const cx = (ci % COLS) * COMP_W;
  const cy = Math.floor(ci / COLS) * COMP_H;

  // Draw 2x3 grid
  for (let row = 0; row < 3; row++) {
    for (let col = 0; col < 2; col++) {
      const tileIdx = comp.tiles[row * 2 + col];
      const tilePx = allTiles[tileIdx];

      for (let y = 0; y < TILE; y++) {
        for (let x = 0; x < TILE; x++) {
          const pixel = tilePx[y * TILE + x];
          if (pixel[3] === 0) continue; // skip transparent

          for (let zy = 0; zy < ZOOM; zy++) {
            for (let zx = 0; zx < ZOOM; zx++) {
              const dx = cx + (col * TILE + x) * ZOOM + zx;
              const dy = cy + (row * TILE + y) * ZOOM + zy;
              if (dx < sheetW && dy < sheetH) {
                const di = (dy * sheetW + dx) * 4;
                sheet.data[di] = pixel[0];
                sheet.data[di+1] = pixel[1];
                sheet.data[di+2] = pixel[2];
                sheet.data[di+3] = pixel[3];
              }
            }
          }
        }
      }
    }
  }
}

fs.writeFileSync(path.join(OUT, 'characters_2x3.png'), PNG.sync.write(sheet));
console.log(`Saved characters_2x3.png (${sheetW}x${sheetH}, ${selected.length} compositions)`);

// Also try 2x2 compositions (smaller characters/enemies)
console.log('\nScanning for 2x2 character compositions...');
const comp2x2 = [];
const used2 = new Set();

for (let start = 0; start < TOTAL_TILES - 3; start++) {
  const tiles = [start, start+1, start+2, start+3];
  const content = tiles.map(t => contentCounts[t]);
  const total = content.reduce((s,c) => s + c, 0);
  if (total < 40 || total > 900) continue;
  if (content.filter(c => c > 5).length < 3) continue;

  let edge = 0;
  edge += verticalEdgeScore(allTiles[start], allTiles[start+2]);
  edge += verticalEdgeScore(allTiles[start+1], allTiles[start+3]);
  edge += horizontalEdgeScore(allTiles[start], allTiles[start+1]);
  edge += horizontalEdgeScore(allTiles[start+2], allTiles[start+3]);

  const score = edge + total / 15;
  if (score > 12) comp2x2.push({ start, tiles, score });
}

comp2x2.sort((a, b) => b.score - a.score);
const sel2x2 = [];
for (const c of comp2x2) {
  if (c.tiles.some(t => used2.has(t))) continue;
  sel2x2.push(c);
  c.tiles.forEach(t => used2.add(t));
}
sel2x2.sort((a, b) => a.start - b.start);
console.log(`Found ${sel2x2.length} 2x2 compositions`);

// Save composition data as JSON for the game
const compositionData = {
  chars2x3: selected.map(c => ({
    startTile: c.start,
    tiles: c.tiles,
    score: Math.round(c.score),
  })),
  chars2x2: sel2x2.map(c => ({
    startTile: c.start,
    tiles: c.tiles,
    score: Math.round(c.score),
  })),
};

fs.writeFileSync(
  path.join(__dirname, 'output', 'character-compositions.json'),
  JSON.stringify(compositionData, null, 2)
);

console.log('\nSaved character-compositions.json');
console.log('Top 2x3 compositions by tile index:');
for (const c of selected.slice(0, 20)) {
  console.log(`  tiles ${c.start}-${c.start+5}, score=${c.score.toFixed(0)}, content=${c.totalContent}`);
}
