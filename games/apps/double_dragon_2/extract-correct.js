#!/usr/bin/env node
/**
 * CORRECT DD2 graphics extraction based on actual MAME ddragon.cpp source.
 *
 * tile_layout = {
 *   16, 16,                          // width, height
 *   RGN_FRAC(1,2),                   // number of tiles = region_size / 2
 *   4,                               // 4bpp
 *   { RGN_FRAC(1,2)+0, RGN_FRAC(1,2)+4, 0, 4 },  // plane offsets
 *   { 3,2,1,0, 16*8+3,16*8+2,16*8+1,16*8+0,       // x offsets
 *     32*8+3,32*8+2,32*8+1,32*8+0, 48*8+3,48*8+2,48*8+1,48*8+0 },
 *   { STEP16(0,8) },                 // y offsets = {0,8,16,24,...,120}
 *   64*8                             // char increment = 512 bits = 64 bytes
 * };
 *
 * char_layout = {
 *   8, 8,
 *   RGN_FRAC(1,1),
 *   4,
 *   { STEP4(0,2) },                  // planes = {0, 2, 4, 6}
 *   { 1, 0, 8*8+1, 8*8+0, 16*8+1, 16*8+0, 24*8+1, 24*8+0 },
 *   { STEP8(0,8) },                  // y offsets = {0,8,16,24,32,40,48,56}
 *   32*8                             // 256 bits = 32 bytes
 * };
 *
 * SPRITE ROMS (region "sprites", total 0xC0000 = 786432 bytes):
 *   26j0-0.bin  @ 0x00000 (0x20000 = 128KB)
 *   26j1-0.bin  @ 0x20000
 *   26af-0.bin  @ 0x40000
 *   26j2-0.bin  @ 0x60000
 *   26j3-0.bin  @ 0x80000
 *   26a10-0.bin @ 0xA0000
 *
 * TILE ROMS (region "tiles", total 0x40000 = 262144 bytes):
 *   26j4-0.bin  @ 0x00000 (0x20000 = 128KB)
 *   26j5-0.bin  @ 0x20000
 *
 * CHAR ROM (region "chars", total 0x10000 = 65536 bytes):
 *   26a8-0.bin  @ 0x00000 (Note: ddragon2u uses 26a8-0.bin, ddragon2 uses 26a8-0e.19)
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'public', 'assets');
fs.mkdirSync(OUT_DIR, { recursive: true });

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// ─── Build sprite region (786432 bytes) ───
function buildSpriteRegion() {
  const region = new Uint8Array(0xC0000);
  const roms = [
    { name: '26j0-0.bin',  offset: 0x00000 },
    { name: '26j1-0.bin',  offset: 0x20000 },
    { name: '26af-0.bin',  offset: 0x40000 },
    { name: '26j2-0.bin',  offset: 0x60000 },
    { name: '26j3-0.bin',  offset: 0x80000 },
    { name: '26a10-0.bin', offset: 0xA0000 },
  ];
  for (const r of roms) {
    const data = loadROM(r.name);
    region.set(data.subarray(0, 0x20000), r.offset);
    console.log(`  Loaded ${r.name} (${data.length} bytes) at offset 0x${r.offset.toString(16)}`);
  }
  return region;
}

// ─── Build tile region (262144 bytes) ───
function buildTileRegion() {
  const region = new Uint8Array(0x40000);
  const roms = [
    { name: '26j4-0.bin', offset: 0x00000 },
    { name: '26j5-0.bin', offset: 0x20000 },
  ];
  for (const r of roms) {
    const data = loadROM(r.name);
    region.set(data.subarray(0, 0x20000), r.offset);
    console.log(`  Loaded ${r.name} at offset 0x${r.offset.toString(16)}`);
  }
  return region;
}

// ─── MAME tile_layout decoder ───
function decodeTileLayout(region) {
  const regionSize = region.length;
  const HALF = regionSize / 2; // RGN_FRAC(1,2) in bytes
  const HALF_BITS = HALF * 8;

  // planes (bit offsets)
  const planes = [HALF_BITS + 0, HALF_BITS + 4, 0, 4];

  // x offsets (bit offsets within a tile)
  const xoff = [
    3, 2, 1, 0,
    16*8+3, 16*8+2, 16*8+1, 16*8+0,
    32*8+3, 32*8+2, 32*8+1, 32*8+0,
    48*8+3, 48*8+2, 48*8+1, 48*8+0,
  ];

  // y offsets = STEP16(0,8) = {0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120}
  const yoff = [];
  for (let i = 0; i < 16; i++) yoff.push(i * 8);

  const TILE_INC = 64 * 8; // 512 bits = 64 bytes per tile in each half
  const numTiles = Math.floor(HALF / 64); // tiles per half
  console.log(`  Region: ${regionSize} bytes, HALF=${HALF}, tiles=${numTiles}`);

  const tiles = [];
  for (let t = 0; t < numTiles; t++) {
    const px = new Uint8Array(256); // 16x16
    const base = t * TILE_INC; // bit offset of this tile

    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bitPos = base + yoff[y] + xoff[x] + planes[p];
          const byteIdx = Math.floor(bitPos / 8);
          const bitIdx = bitPos % 8;
          if (byteIdx < regionSize) {
            pixel |= (((region[byteIdx] >> bitIdx) & 1) << p);
          }
        }
        px[y * 16 + x] = pixel;
      }
    }
    tiles.push(px);
  }
  return tiles;
}

// ─── MAME char_layout decoder ───
function decodeCharLayout(region) {
  const regionSize = region.length;

  // planes = STEP4(0,2) = {0, 2, 4, 6}
  const planes = [0, 2, 4, 6];

  // x offsets
  const xoff = [1, 0, 8*8+1, 8*8+0, 16*8+1, 16*8+0, 24*8+1, 24*8+0];

  // y offsets = STEP8(0,8)
  const yoff = [];
  for (let i = 0; i < 8; i++) yoff.push(i * 8);

  const TILE_INC = 32 * 8; // 256 bits = 32 bytes
  const numTiles = Math.floor(regionSize * 8 / TILE_INC);
  console.log(`  Chars: ${regionSize} bytes, tiles=${numTiles}`);

  const tiles = [];
  for (let t = 0; t < numTiles; t++) {
    const px = new Uint8Array(64); // 8x8
    const base = t * TILE_INC;

    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 8; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bitPos = base + yoff[y] + xoff[x] + planes[p];
          const byteIdx = Math.floor(bitPos / 8);
          const bitIdx = bitPos % 8;
          if (byteIdx < regionSize) {
            pixel |= (((region[byteIdx] >> bitIdx) & 1) << p);
          }
        }
        px[y * 8 + x] = pixel;
      }
    }
    tiles.push(px);
  }
  return tiles;
}

// ─── Palette (approximation - actual colors from palette RAM) ───
const SPRITE_PAL = [
  [0,0,0,0],
  [255,255,255,255],
  [200,210,230,255],
  [160,170,200,255],
  [100,120,180,255],
  [60,80,150,255],
  [30,40,100,255],
  [230,190,150,255],
  [190,150,110,255],
  [150,110,70,255],
  [110,70,40,255],
  [70,40,20,255],
  [255,220,0,255],
  [220,60,60,255],
  [160,40,40,255],
  [20,20,20,255],
];

const BG_PAL = [
  [0,0,0,0],
  [30,30,60,255],
  [50,50,80,255],
  [70,70,100,255],
  [90,90,120,255],
  [110,110,140,255],
  [130,130,160,255],
  [150,150,180,255],
  [80,60,40,255],
  [110,85,60,255],
  [140,110,80,255],
  [170,135,100,255],
  [90,120,70,255],
  [120,150,90,255],
  [160,180,120,255],
  [200,200,180,255],
];

const TEXT_PAL = [
  [0,0,0,0],
  [255,255,255,255],
  [255,220,0,255],
  [255,160,0,255],
  [255,80,0,255],
  [220,0,0,255],
  [0,200,255,255],
  [230,190,150,255],
  [190,150,110,255],
  [150,110,70,255],
  [100,200,100,255],
  [60,160,60,255],
  [200,200,200,255],
  [160,160,160,255],
  [100,100,100,255],
  [20,20,20,255],
];

// ─── PNG generation ───
function tilesToPNG(tiles, tw, th, palette, cols, filename) {
  const rows = Math.ceil(tiles.length / cols);
  const png = new PNG({ width: cols * tw, height: rows * th });
  for (let i = 0; i < png.data.length; i += 4) {
    png.data[i] = png.data[i+1] = png.data[i+2] = 0;
    png.data[i+3] = 0;
  }
  for (let t = 0; t < tiles.length; t++) {
    const tx = (t % cols) * tw;
    const ty = Math.floor(t / cols) * th;
    for (let y = 0; y < th; y++) {
      for (let x = 0; x < tw; x++) {
        const ci = tiles[t][y * tw + x];
        const c = palette[ci] || [255,0,255,255];
        const di = ((ty + y) * png.width + (tx + x)) * 4;
        png.data[di] = c[0]; png.data[di+1] = c[1];
        png.data[di+2] = c[2]; png.data[di+3] = c[3];
      }
    }
  }
  const outPath = path.join(OUT_DIR, filename);
  fs.writeFileSync(outPath, PNG.sync.write(png));
  console.log(`  -> ${filename} (${png.width}x${png.height}, ${tiles.length} tiles)`);
}

// ═══════════════════════════════════════
// EXTRACT
// ═══════════════════════════════════════
console.log('Building sprite region...');
const spriteRegion = buildSpriteRegion();

console.log('\nDecoding sprites (tile_layout)...');
const spriteTiles = decodeTileLayout(spriteRegion);

console.log('\nBuilding tile region...');
const tileRegion = buildTileRegion();

console.log('\nDecoding BG tiles (tile_layout)...');
const bgTiles = decodeTileLayout(tileRegion);

console.log('\nDecoding chars...');
const charRom = loadROM('26a8-0.bin');
const charTiles = decodeCharLayout(charRom);

console.log('\nGenerating PNGs...');
tilesToPNG(spriteTiles, 16, 16, SPRITE_PAL, 64, 'sprites-player1.png');
tilesToPNG(bgTiles, 16, 16, BG_PAL, 32, 'bg-tiles1.png');
tilesToPNG(charTiles, 8, 8, TEXT_PAL, 64, 'chars-text.png');

// Also generate a grayscale version for easier visual inspection
const GRAY = Array.from({length: 16}, (_, i) => {
  const v = Math.round(i * 255 / 15);
  return [v, v, v, i === 0 ? 0 : 255];
});
tilesToPNG(spriteTiles.slice(0, 512), 16, 16, GRAY, 32, 'sprites-gray-512.png');
tilesToPNG(bgTiles.slice(0, 256), 16, 16, GRAY, 16, 'bg-gray-256.png');

// Copy to game assets too
const gameAssets = path.join(__dirname, 'game', 'public', 'assets');
fs.mkdirSync(gameAssets, { recursive: true });
for (const f of ['sprites-player1.png', 'bg-tiles1.png', 'chars-text.png']) {
  fs.copyFileSync(path.join(OUT_DIR, f), path.join(gameAssets, f));
}

console.log('\n=== Done ===');
console.log(`Sprites: ${spriteTiles.length} tiles (16x16)`);
console.log(`BG tiles: ${bgTiles.length} tiles (16x16)`);
console.log(`Char tiles: ${charTiles.length} tiles (8x8)`);
