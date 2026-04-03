#!/usr/bin/env node
/**
 * Double Dragon 2 - Proper Graphics Decoder
 * Based on MAME ddragon.cpp gfx_layout definitions
 *
 * Character layout (8x8, 4bpp):
 *   planes: { 0, 2, 4, 6 }
 *   xoffset: { 1, 0, 9, 8, 17, 16, 25, 24 }
 *   yoffset: { 0*32, 1*32, 2*32, 3*32, 4*32, 5*32, 6*32, 7*32 }
 *   charincrement: 256 bits (32 bytes)
 *
 * Tile/BG layout (16x16, 4bpp):
 *   planes: { RGN_FRAC(1,2)+0, RGN_FRAC(1,2)+4, 0, 4 }
 *   xoffset: { 3, 2, 1, 0, 16+3, 16+2, 16+1, 16+0,
 *              32*8+3, 32*8+2, 32*8+1, 32*8+0, 33*8+3, 33*8+2, 33*8+1, 33*8+0 }
 *   yoffset: { 0*32, 1*32, 2*32, 3*32, 4*32, 5*32, 6*32, 7*32 }
 *   charincrement: 512 bits (64 bytes)
 */

const fs = require('fs');
const path = require('path');
const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'decoded');

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// Get bit at position from byte array (bit 0 = LSB of byte 0)
function getBit(data, bitPos) {
  const byteIdx = Math.floor(bitPos / 8);
  const bitIdx = bitPos % 8;
  if (byteIdx >= data.length) return 0;
  return (data[byteIdx] >> bitIdx) & 1;
}

// ============================================================
// CHARACTER TILES (8x8, 4bpp) from 26a8-0.bin
// ============================================================
function decodeChars() {
  const rom = loadROM('26a8-0.bin');
  const TILE_BITS = 256; // 32 bytes
  const TILE_BYTES = 32;
  const numTiles = Math.floor(rom.length / TILE_BYTES);

  const planes = [0, 2, 4, 6];
  const xoff = [1, 0, 9, 8, 17, 16, 25, 24];
  const yoff = [0, 32, 64, 96, 128, 160, 192, 224];

  console.log(`Decoding ${numTiles} character tiles (8x8, 4bpp)...`);

  const tiles = [];
  for (let t = 0; t < numTiles; t++) {
    const tileBase = t * TILE_BITS; // in bits
    const pixels = [];
    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 8; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bitPos = tileBase + yoff[y] + xoff[x] + planes[p];
          const byteIdx = Math.floor(bitPos / 8);
          const bitIdx = bitPos % 8;
          pixel |= (((rom[byteIdx] >> bitIdx) & 1) << p);
        }
        pixels.push(pixel);
      }
    }
    tiles.push(pixels);
  }

  // Print first recognizable tiles
  console.log('\nDecoded character tiles:');
  for (let t = 0; t < 80; t++) {
    const px = tiles[t];
    const hasContent = px.some(p => p !== 0);
    if (hasContent || t < 10) {
      console.log(`\nTile #${t} (0x${t.toString(16)}):`);
      for (let y = 0; y < 8; y++) {
        const row = px.slice(y * 8, y * 8 + 8);
        console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
      }
    }
  }

  return tiles;
}

// ============================================================
// SPRITE TILES (16x16, 4bpp) from 26j0-26j5
// ============================================================
function decodeSprites() {
  // Load and concatenate sprite ROMs
  const romNames = ['26j0-0.bin', '26j1-0.bin', '26j2-0.bin', '26j3-0.bin', '26j4-0.bin', '26j5-0.bin'];
  const roms = romNames.map(n => loadROM(n));
  const totalLen = roms.reduce((s, r) => s + r.length, 0);
  const combined = new Uint8Array(totalLen);
  let offset = 0;
  for (const rom of roms) {
    combined.set(rom, offset);
    offset += rom.length;
  }

  // Sprite layout from MAME ddragon.cpp:
  // 16x16, 4bpp
  // planes: { RGN_FRAC(1,2)+0, RGN_FRAC(1,2)+4, 0, 4 }
  // xoffset: { 3,2,1,0, 16+3,16+2,16+1,16+0, 32*8+3,32*8+2,32*8+1,32*8+0, 33*8+3,33*8+2,33*8+1,33*8+0 }
  // yoffset: { 0*32,1*32,...,7*32 }
  // charincrement: 512 bits = 64 bytes

  const HALF = totalLen * 8 / 2; // RGN_FRAC(1,2) in bits
  const TILE_BITS = 512; // 64 bytes per tile per half
  const numTiles = Math.floor(totalLen / 2 / 64); // tiles in one half

  const planes = [HALF + 0, HALF + 4, 0, 4];
  const xoff = [3, 2, 1, 0, 19, 18, 17, 16, 259, 258, 257, 256, 275, 274, 273, 272];
  const yoff = [0, 32, 64, 96, 128, 160, 192, 224];

  console.log(`\nDecoding sprites: ${totalLen} bytes, HALF=${HALF/8} bytes, ~${numTiles} tiles`);

  // Wait - yoff only has 8 entries for 16 rows. The sprite is composed of two 16x8 halves.
  // The second half is at +32*8 = +256 bits offset, which is handled by xoffsets 8-15
  // Actually no, looking at xoffsets: first 8 pixels use bits 0-31, second 8 pixels use bits 256-287
  // And the yoffsets are for 8 rows only.
  // So the tile is actually: top 8x16 from main offset, bottom 8x16 from +256 bits

  // Actually I think the MAME layout for 16x16 uses 8 yoffsets because:
  // The first 8 rows use the first 8 yoffsets
  // xoffsets 0-7 give pixels 0-7 of left half
  // xoffsets 8-15 give pixels 8-15 which are offset by 32*8=256 bits
  // So a "row" in the tile data covers all 16 pixels
  // But we only have 8 yoffsets, suggesting the tile is 16 wide × 8 tall?

  // No, the standard MAME sprite layout for 16x16 tiles typically uses:
  // 16 y entries. Let me reconsider.
  // Actually in MAME source, the yoffset has 16 entries for 16x16:
  // yoffset: 0*32, 1*32, ..., 7*32, 512+0*32, 512+1*32, ..., 512+7*32
  // But the charincrement might be larger (1024 bits = 128 bytes)

  // Let me try the standard DD sprite format:
  // 16x16, 4bpp, 128 bytes per tile
  // planes: { HALF+0, HALF+4, 0, 4 }
  // xoff: { 3,2,1,0, 16+3,16+2,16+1,16+0, 32*8+3,32*8+2,32*8+1,32*8+0, 33*8+3,33*8+2,33*8+1,33*8+0 }
  // yoff: { 0*32,1*32,...,7*32, 512+0*32, 512+1*32,..., 512+7*32 }
  // charincrement: 1024 bits = 128 bytes

  const TILE_FULL = 1024; // 128 bytes
  const numFullTiles = Math.floor(totalLen / 2 / 128);
  const yoff16 = [];
  for (let i = 0; i < 8; i++) yoff16.push(i * 32);
  for (let i = 0; i < 8; i++) yoff16.push(512 + i * 32);

  console.log(`Full 16x16 tiles (128 bytes each, per half): ${numFullTiles}`);

  const tiles = [];
  for (let t = 0; t < Math.min(numFullTiles, 100); t++) { // decode first 100
    const tileBase = t * TILE_FULL; // in bits
    const pixels = [];

    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bitPos = tileBase + yoff16[y] + xoff[x] + planes[p];
          const byteIdx = Math.floor(bitPos / 8);
          const bitIdx = bitPos % 8;
          if (byteIdx < combined.length) {
            pixel |= (((combined[byteIdx] >> bitIdx) & 1) << p);
          }
        }
        pixels.push(pixel);
      }
    }
    tiles.push(pixels);
  }

  // Show some tiles
  console.log('\nDecoded sprite tiles:');
  let shown = 0;
  for (let t = 0; t < tiles.length && shown < 10; t++) {
    const px = tiles[t];
    const nonZero = px.filter(p => p !== 0).length;
    if (nonZero > 20 && nonZero < 240) {
      shown++;
      console.log(`\nSprite #${t} (non-zero: ${nonZero}):`);
      for (let y = 0; y < 16; y++) {
        const row = px.slice(y * 16, y * 16 + 16);
        console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
      }
    }
  }

  return tiles;
}

// ============================================================
// BACKGROUND TILES (16x16, 4bpp) from 26a10-0.bin + 26af-0.bin
// ============================================================
function decodeBGTiles() {
  // These two ROMs likely pair for the 4 bitplanes
  const rom1 = loadROM('26af-0.bin');  // 128K
  const rom2 = loadROM('26a10-0.bin'); // 128K

  // Combine as halves
  const combined = new Uint8Array(rom1.length + rom2.length);
  combined.set(rom1, 0);
  combined.set(rom2, rom1.length);

  const HALF = rom1.length * 8; // in bits
  const TILE_FULL = 1024;

  const planes = [HALF + 0, HALF + 4, 0, 4];
  const xoff = [3, 2, 1, 0, 19, 18, 17, 16, 259, 258, 257, 256, 275, 274, 273, 272];
  const yoff16 = [];
  for (let i = 0; i < 8; i++) yoff16.push(i * 32);
  for (let i = 0; i < 8; i++) yoff16.push(512 + i * 32);

  const numTiles = Math.floor(combined.length / 2 / 128);
  console.log(`\nDecoding ${numTiles} background tiles...`);

  const tiles = [];
  let shown = 0;
  for (let t = 0; t < Math.min(numTiles, 100); t++) {
    const tileBase = t * TILE_FULL;
    const pixels = [];

    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bitPos = tileBase + yoff16[y] + xoff[x] + planes[p];
          const byteIdx = Math.floor(bitPos / 8);
          const bitIdx = bitPos % 8;
          if (byteIdx < combined.length) {
            pixel |= (((combined[byteIdx] >> bitIdx) & 1) << p);
          }
        }
        pixels.push(pixel);
      }
    }

    tiles.push(pixels);
    const nonZero = pixels.filter(p => p !== 0).length;
    if (nonZero > 20 && nonZero < 240 && shown < 8) {
      shown++;
      console.log(`\nBG Tile #${t} (non-zero: ${nonZero}):`);
      for (let y = 0; y < 16; y++) {
        const row = pixels.slice(y * 16, y * 16 + 16);
        console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
      }
    }
  }

  return tiles;
}

// Run decoders
const charTiles = decodeChars();
const spriteTiles = decodeSprites();
const bgTiles = decodeBGTiles();

console.log('\n=== Summary ===');
console.log(`Characters: ${charTiles.length} tiles (8x8)`);
console.log(`Sprites: ${spriteTiles.length} tiles (16x16) [first batch]`);
console.log(`BG Tiles: ${bgTiles.length} tiles (16x16) [first batch]`);
