#!/usr/bin/env node
/**
 * Double Dragon 2 - Asset Extractor
 * Extracts character tiles, sprites, and BG tiles from ROM files
 * and generates sprite sheet PNGs for use in the React game.
 *
 * Uses MAME-accurate gfx_layout decoding.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'public', 'assets');

// Create output directories
fs.mkdirSync(path.join(OUT_DIR), { recursive: true });

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// ============================================================
// Double Dragon 2 Arcade Color Palettes
// The arcade generates palette from RAM, but we use the known
// default palettes from the game. These are the most common
// palettes used for characters, enemies, and backgrounds.
// ============================================================

// DD2 uses 4bpp = 16 colors per palette, with color 0 = transparent
// These palettes are reconstructed from the actual game colors
const PALETTES = {
  // Player 1 (Billy Lee) - blue outfit
  player1: [
    [0,0,0,0],       // 0: transparent
    [255,255,255,255],// 1: white (highlights)
    [200,200,220,255],// 2: light blue-gray
    [150,160,200,255],// 3: medium blue
    [80,100,180,255], // 4: blue
    [50,60,140,255],  // 5: dark blue
    [30,30,100,255],  // 6: darker blue
    [220,180,140,255],// 7: skin tone
    [180,140,100,255],// 8: skin shadow
    [140,100,60,255], // 9: dark skin/hair
    [100,60,30,255],  // a: brown
    [60,40,20,255],   // b: dark brown
    [255,220,0,255],  // c: yellow (belt)
    [200,60,60,255],  // d: red accent
    [160,40,40,255],  // e: dark red
    [20,20,20,255],   // f: near black
  ],
  // Player 2 (Jimmy Lee) - red outfit
  player2: [
    [0,0,0,0],
    [255,255,255,255],
    [255,200,200,255],
    [220,120,120,255],
    [180,60,60,255],
    [140,30,30,255],
    [100,20,20,255],
    [220,180,140,255],
    [180,140,100,255],
    [140,100,60,255],
    [100,60,30,255],
    [60,40,20,255],
    [255,220,0,255],
    [80,100,180,255],
    [50,60,140,255],
    [20,20,20,255],
  ],
  // Enemy - generic thug palette
  enemy1: [
    [0,0,0,0],
    [255,255,255,255],
    [200,200,200,255],
    [160,160,160,255],
    [120,120,120,255],
    [80,80,80,255],
    [40,40,40,255],
    [220,180,140,255],
    [180,140,100,255],
    [140,100,60,255],
    [100,60,30,255],
    [60,40,20,255],
    [0,160,0,255],
    [0,120,0,255],
    [0,80,0,255],
    [20,20,20,255],
  ],
  // Text/HUD palette
  text: [
    [0,0,0,0],
    [255,255,255,255],
    [255,220,0,255],
    [255,160,0,255],
    [255,80,0,255],
    [200,0,0,255],
    [0,200,255,255],
    [220,180,140,255],
    [180,140,100,255],
    [140,100,60,255],
    [100,200,100,255],
    [60,160,60,255],
    [200,200,200,255],
    [160,160,160,255],
    [100,100,100,255],
    [20,20,20,255],
  ],
  // Background palette 1 - city/street
  bg1: [
    [0,0,0,0],
    [40,40,80,255],
    [60,60,100,255],
    [80,80,120,255],
    [100,100,140,255],
    [120,120,160,255],
    [140,140,180,255],
    [160,160,200,255],
    [80,60,40,255],
    [120,90,60,255],
    [160,120,80,255],
    [200,150,100,255],
    [100,140,80,255],
    [140,180,100,255],
    [180,200,140,255],
    [220,220,200,255],
  ],
  // Background palette 2 - darker areas
  bg2: [
    [0,0,0,0],
    [20,20,40,255],
    [40,40,60,255],
    [60,60,80,255],
    [80,80,100,255],
    [100,100,120,255],
    [120,120,140,255],
    [140,140,160,255],
    [60,40,20,255],
    [90,60,30,255],
    [120,80,40,255],
    [150,100,60,255],
    [60,100,60,255],
    [80,130,80,255],
    [120,160,100,255],
    [180,180,160,255],
  ],
};

// ============================================================
// MAME GFX Layout Decoder
// ============================================================

function decodeTiles(romData, layout) {
  const { width, height, planes, xoff, yoff, tileIncrement } = layout;
  const totalBits = romData.length * 8;
  const numTiles = Math.floor(totalBits / tileIncrement);
  const tiles = [];

  for (let t = 0; t < numTiles; t++) {
    const tileBase = t * tileIncrement;
    const pixels = new Uint8Array(width * height);

    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        let pixel = 0;
        for (let p = 0; p < planes.length; p++) {
          const bitPos = tileBase + yoff[y] + xoff[x] + planes[p];
          if (bitPos >= 0 && bitPos < totalBits) {
            const byteIdx = Math.floor(bitPos / 8);
            const bitIdx = bitPos % 8;
            pixel |= (((romData[byteIdx] >> bitIdx) & 1) << p);
          }
        }
        pixels[y * width + x] = pixel;
      }
    }
    tiles.push(pixels);
  }

  return tiles;
}

// ============================================================
// PNG Generation
// ============================================================

function tilesToPNG(tiles, tileWidth, tileHeight, palette, cols, filename) {
  const numTiles = tiles.length;
  const rows = Math.ceil(numTiles / cols);
  const imgWidth = cols * tileWidth;
  const imgHeight = rows * tileHeight;

  const png = new PNG({ width: imgWidth, height: imgHeight, filterType: -1 });

  // Fill with transparent
  for (let i = 0; i < png.data.length; i += 4) {
    png.data[i] = 0;
    png.data[i+1] = 0;
    png.data[i+2] = 0;
    png.data[i+3] = 0;
  }

  for (let t = 0; t < numTiles; t++) {
    const tx = (t % cols) * tileWidth;
    const ty = Math.floor(t / cols) * tileHeight;

    for (let y = 0; y < tileHeight; y++) {
      for (let x = 0; x < tileWidth; x++) {
        const colorIdx = tiles[t][y * tileWidth + x];
        const color = palette[colorIdx] || [255, 0, 255, 255];
        const dstIdx = ((ty + y) * imgWidth + (tx + x)) * 4;
        png.data[dstIdx] = color[0];
        png.data[dstIdx+1] = color[1];
        png.data[dstIdx+2] = color[2];
        png.data[dstIdx+3] = color[3];
      }
    }
  }

  const outPath = path.join(OUT_DIR, filename);
  const buffer = PNG.sync.write(png);
  fs.writeFileSync(outPath, buffer);
  console.log(`  Written: ${filename} (${imgWidth}x${imgHeight}, ${numTiles} tiles)`);
  return { filename, cols, tileWidth, tileHeight, numTiles };
}

// ============================================================
// Extract Character Tiles
// ============================================================
console.log('=== Extracting Character Tiles ===');
const charRom = loadROM('26a8-0.bin');
const charLayout = {
  width: 8, height: 8,
  planes: [0, 2, 4, 6],
  xoff: [1, 0, 9, 8, 17, 16, 25, 24],
  yoff: [0, 32, 64, 96, 128, 160, 192, 224],
  tileIncrement: 256, // 32 bytes
};
const charTiles = decodeTiles(charRom, charLayout);
console.log(`  Decoded ${charTiles.length} character tiles`);

tilesToPNG(charTiles, 8, 8, PALETTES.text, 64, 'chars-text.png');

// ============================================================
// Extract Sprites
// ============================================================
console.log('\n=== Extracting Sprite Tiles ===');
const spriteRoms = ['26j0-0.bin', '26j1-0.bin', '26j2-0.bin', '26j3-0.bin', '26j4-0.bin', '26j5-0.bin'];
const spriteChunks = spriteRoms.map(n => loadROM(n));
const spriteTotalLen = spriteChunks.reduce((s, r) => s + r.length, 0);
const spriteCombined = new Uint8Array(spriteTotalLen);
let spriteOffset = 0;
for (const chunk of spriteChunks) {
  spriteCombined.set(chunk, spriteOffset);
  spriteOffset += chunk.length;
}
const SPRITE_HALF = spriteCombined.length * 8 / 2;

const spriteLayout = {
  width: 16, height: 16,
  planes: [SPRITE_HALF + 0, SPRITE_HALF + 4, 0, 4],
  xoff: [3, 2, 1, 0, 19, 18, 17, 16, 259, 258, 257, 256, 275, 274, 273, 272],
  yoff: [0, 32, 64, 96, 128, 160, 192, 224, 512, 544, 576, 608, 640, 672, 704, 736],
  tileIncrement: 1024, // 128 bytes per tile (per half)
};
const spriteTiles = decodeTiles(spriteCombined, spriteLayout);
console.log(`  Decoded ${spriteTiles.length} sprite tiles`);

// Generate sprite sheets with different palettes
tilesToPNG(spriteTiles, 16, 16, PALETTES.player1, 64, 'sprites-player1.png');
tilesToPNG(spriteTiles, 16, 16, PALETTES.player2, 64, 'sprites-player2.png');
tilesToPNG(spriteTiles, 16, 16, PALETTES.enemy1, 64, 'sprites-enemy.png');

// ============================================================
// Extract Background Tiles
// ============================================================
console.log('\n=== Extracting Background Tiles ===');
const bgRom1 = loadROM('26af-0.bin');
const bgRom2 = loadROM('26a10-0.bin');
const bgCombined = new Uint8Array(bgRom1.length + bgRom2.length);
bgCombined.set(bgRom1, 0);
bgCombined.set(bgRom2, bgRom1.length);
const BG_HALF = bgRom1.length * 8;

const bgLayout = {
  width: 16, height: 16,
  planes: [BG_HALF + 0, BG_HALF + 4, 0, 4],
  xoff: [3, 2, 1, 0, 19, 18, 17, 16, 259, 258, 257, 256, 275, 274, 273, 272],
  yoff: [0, 32, 64, 96, 128, 160, 192, 224, 512, 544, 576, 608, 640, 672, 704, 736],
  tileIncrement: 1024,
};
const bgTiles = decodeTiles(bgCombined, bgLayout);
console.log(`  Decoded ${bgTiles.length} background tiles`);

tilesToPNG(bgTiles, 16, 16, PALETTES.bg1, 64, 'bg-tiles1.png');
tilesToPNG(bgTiles, 16, 16, PALETTES.bg2, 64, 'bg-tiles2.png');

// ============================================================
// Generate Tile Map JSON (for the React game to reference)
// ============================================================
console.log('\n=== Generating Tile Map ===');

const tileMap = {
  chars: {
    file: 'chars-text.png',
    tileWidth: 8,
    tileHeight: 8,
    cols: 64,
    count: charTiles.length,
  },
  sprites: {
    files: {
      player1: 'sprites-player1.png',
      player2: 'sprites-player2.png',
      enemy: 'sprites-enemy.png',
    },
    tileWidth: 16,
    tileHeight: 16,
    cols: 64,
    count: spriteTiles.length,
  },
  bg: {
    files: {
      light: 'bg-tiles1.png',
      dark: 'bg-tiles2.png',
    },
    tileWidth: 16,
    tileHeight: 16,
    cols: 64,
    count: bgTiles.length,
  },
  // Identify non-empty tiles for each set
  nonEmptyChars: [],
  nonEmptySprites: [],
  nonEmptyBG: [],
};

// Find non-empty tiles
for (let i = 0; i < charTiles.length; i++) {
  if (charTiles[i].some(p => p !== 0)) tileMap.nonEmptyChars.push(i);
}
for (let i = 0; i < spriteTiles.length; i++) {
  const nonZero = spriteTiles[i].filter(p => p !== 0).length;
  if (nonZero > 10) tileMap.nonEmptySprites.push(i);
}
for (let i = 0; i < bgTiles.length; i++) {
  const nonZero = bgTiles[i].filter(p => p !== 0).length;
  if (nonZero > 10) tileMap.nonEmptyBG.push(i);
}

console.log(`  Non-empty chars: ${tileMap.nonEmptyChars.length}`);
console.log(`  Non-empty sprites: ${tileMap.nonEmptySprites.length}`);
console.log(`  Non-empty BG tiles: ${tileMap.nonEmptyBG.length}`);

fs.writeFileSync(
  path.join(OUT_DIR, 'tilemap.json'),
  JSON.stringify(tileMap, null, 2)
);

console.log('\n=== Asset Extraction Complete ===');
console.log(`Output directory: ${OUT_DIR}`);
