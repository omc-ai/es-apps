#!/usr/bin/env node
/**
 * DD2 Final Asset Generator
 * Uses REAL arcade palettes from MAME memory dump + MAME gfx_layout tile decoding.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'game', 'public', 'assets');
fs.mkdirSync(OUT_DIR, { recursive: true });

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// ═══════════════════════════════════════
// PALETTE EXTRACTION FROM MAME DUMP
// ═══════════════════════════════════════

function extractPalettes() {
  const dump = new Uint8Array(fs.readFileSync(path.join(ROM_DIR, 'mame-dumps', 'full_f2400.bin')));
  // Dump covers addresses $0000-$3FFF (16KB)
  // Palette LOW  bytes at $3C00-$3DFF -> dump offset 0x3C00
  // Palette HIGH bytes at $3E00-$3FFF -> dump offset 0x3E00

  const colors = []; // 512 colors as {r, g, b}
  for (let i = 0; i < 512; i++) {
    const lo = dump[0x3C00 + i];
    const hi = dump[0x3E00 + i];
    const word = (hi << 8) | lo;
    const r = (word & 0xF) * 17;
    const g = ((word >> 4) & 0xF) * 17;
    const b = ((word >> 8) & 0xF) * 17;
    colors.push({ r, g, b });
  }

  // Organize into palette groups
  const palettes = {
    chars: [],    // 0-127: 8 palettes x 16 colors
    sprites: [],  // 128-255: 8 palettes x 16 colors
    bg: [],       // 256-383: 8 palettes x 16 colors
    extra: [],    // 384-511: 8 palettes x 16 colors
  };

  for (let p = 0; p < 8; p++) {
    palettes.chars.push(colors.slice(p * 16, p * 16 + 16));
    palettes.sprites.push(colors.slice(128 + p * 16, 128 + p * 16 + 16));
    palettes.bg.push(colors.slice(256 + p * 16, 256 + p * 16 + 16));
    palettes.extra.push(colors.slice(384 + p * 16, 384 + p * 16 + 16));
  }

  return { colors, palettes };
}

// ═══════════════════════════════════════
// ROM LOADING
// ═══════════════════════════════════════

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
    console.log(`  Loaded ${r.name} (${data.length} bytes) at 0x${r.offset.toString(16)}`);
  }
  return region;
}

function buildTileRegion() {
  const region = new Uint8Array(0x40000);
  const roms = [
    { name: '26j4-0.bin', offset: 0x00000 },
    { name: '26j5-0.bin', offset: 0x20000 },
  ];
  for (const r of roms) {
    const data = loadROM(r.name);
    region.set(data.subarray(0, 0x20000), r.offset);
    console.log(`  Loaded ${r.name} at 0x${r.offset.toString(16)}`);
  }
  return region;
}

// ═══════════════════════════════════════
// MAME GFX_LAYOUT DECODERS
// ═══════════════════════════════════════

function decodeTileLayout(region) {
  const regionSize = region.length;
  const HALF = regionSize / 2;
  const HALF_BITS = HALF * 8;

  const planes = [HALF_BITS + 0, HALF_BITS + 4, 0, 4];

  const xoff = [
    3, 2, 1, 0,
    16*8+3, 16*8+2, 16*8+1, 16*8+0,
    32*8+3, 32*8+2, 32*8+1, 32*8+0,
    48*8+3, 48*8+2, 48*8+1, 48*8+0,
  ];

  const yoff = [];
  for (let i = 0; i < 16; i++) yoff.push(i * 8);

  const TILE_INC = 64 * 8; // 512 bits per tile
  const numTiles = Math.floor(HALF / 64);
  console.log(`  Region: ${regionSize} bytes, HALF=${HALF}, tiles=${numTiles}`);

  const tiles = [];
  for (let t = 0; t < numTiles; t++) {
    const px = new Uint8Array(256); // 16x16
    const base = t * TILE_INC;

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

function decodeCharLayout(region) {
  const regionSize = region.length;

  const planes = [0, 2, 4, 6];
  const xoff = [1, 0, 8*8+1, 8*8+0, 16*8+1, 16*8+0, 24*8+1, 24*8+0];
  const yoff = [];
  for (let i = 0; i < 8; i++) yoff.push(i * 8);

  const TILE_INC = 32 * 8; // 256 bits per char
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

// ═══════════════════════════════════════
// PNG GENERATION
// ═══════════════════════════════════════

/**
 * Convert palette group (array of {r,g,b}) to RGBA array for PNG rendering.
 * Color index 0 = transparent.
 */
function palToRGBA(palColors) {
  return palColors.map((c, i) => {
    if (i === 0) return [0, 0, 0, 0]; // transparent
    return [c.r, c.g, c.b, 255];
  });
}

function tilesToPNG(tiles, tw, th, rgbaPal, cols, filename) {
  const rows = Math.ceil(tiles.length / cols);
  const png = new PNG({ width: cols * tw, height: rows * th });

  // Clear to transparent
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
        const c = rgbaPal[ci] || [255, 0, 255, 255];
        const di = ((ty + y) * png.width + (tx + x)) * 4;
        png.data[di]   = c[0];
        png.data[di+1] = c[1];
        png.data[di+2] = c[2];
        png.data[di+3] = c[3];
      }
    }
  }

  const outPath = path.join(OUT_DIR, filename);
  fs.writeFileSync(outPath, PNG.sync.write(png));
  console.log(`  -> ${filename} (${png.width}x${png.height}, ${tiles.length} tiles)`);
}

// ═══════════════════════════════════════
// MAIN
// ═══════════════════════════════════════

console.log('=== DD2 Final Asset Generator ===\n');

// 1. Extract palettes
console.log('Extracting palettes from MAME dump...');
const { colors, palettes } = extractPalettes();

// Print first few palette entries for verification
console.log('\n  Sprite palette 0:');
for (let i = 0; i < 16; i++) {
  const c = palettes.sprites[0][i];
  console.log(`    [${i}] R=${c.r} G=${c.g} B=${c.b}`);
}
console.log('\n  BG palette 0:');
for (let i = 0; i < 16; i++) {
  const c = palettes.bg[0][i];
  console.log(`    [${i}] R=${c.r} G=${c.g} B=${c.b}`);
}
console.log('\n  Char palette 0:');
for (let i = 0; i < 16; i++) {
  const c = palettes.chars[0][i];
  console.log(`    [${i}] R=${c.r} G=${c.g} B=${c.b}`);
}

// 2. Save palette JSON
const palJson = {
  total_colors: 512,
  format: 'xBGR_444 from MAME dump',
  source: 'full_f2400.bin ($3C00/$3E00)',
  groups: {
    chars:   { offset: 0,   count: 128, palettes: palettes.chars },
    sprites: { offset: 128, count: 128, palettes: palettes.sprites },
    bg:      { offset: 256, count: 128, palettes: palettes.bg },
    extra:   { offset: 384, count: 128, palettes: palettes.extra },
  }
};
const palPath = path.join(OUT_DIR, 'palettes.json');
fs.writeFileSync(palPath, JSON.stringify(palJson, null, 2));
console.log(`\nSaved palettes.json`);

// 3. Decode tiles
console.log('\nBuilding sprite region...');
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

// 4. Generate PNGs for each palette
console.log('\n--- Generating Sprite sheets (8 palettes) ---');
for (let p = 0; p < 8; p++) {
  const rgba = palToRGBA(palettes.sprites[p]);
  tilesToPNG(spriteTiles, 16, 16, rgba, 64, `sprites-pal${p}.png`);
}

console.log('\n--- Generating BG tile sheets (8 palettes) ---');
for (let p = 0; p < 8; p++) {
  const rgba = palToRGBA(palettes.bg[p]);
  tilesToPNG(bgTiles, 16, 16, rgba, 32, `bg-pal${p}.png`);
}

console.log('\n--- Generating Char sheets (8 palettes) ---');
for (let p = 0; p < 8; p++) {
  const rgba = palToRGBA(palettes.chars[p]);
  tilesToPNG(charTiles, 8, 8, rgba, 64, `chars-pal${p}.png`);
}

console.log('\n=== Done ===');
console.log(`Sprites: ${spriteTiles.length} tiles (16x16), 8 palette variants`);
console.log(`BG tiles: ${bgTiles.length} tiles (16x16), 8 palette variants`);
console.log(`Char tiles: ${charTiles.length} tiles (8x8), 8 palette variants`);
console.log(`Output: ${OUT_DIR}`);
