#!/usr/bin/env node
/**
 * Double Dragon 2 ROM Analyzer
 *
 * Arcade hardware (Technos Japan):
 * - Main CPU: HD6309 (Motorola 6809 compatible)
 * - Sub CPU: HD63701
 * - Sound: YM2151 + OKI MSM6295
 *
 * ROM layout for ddragon2u:
 *   26a10-0.bin  (128K) - Main CPU program
 *   26a8-0.bin   (64K)  - Sub CPU program
 *   26a9-04.bin  (32K)  - Character/text tiles (8x8, 4bpp)
 *   26aa-03.bin  (32K)  - Character/text tiles (8x8, 4bpp) - paired
 *   26ab-0.bin   (32K)  - Foreground tiles (16x16, 4bpp)
 *   26ac-02.bin  (32K)  - Foreground tiles (16x16, 4bpp) - paired
 *   26ad-0.bin   (32K)  - Sprite data bank 0
 *   26ae-0.bin   (64K)  - Sprite data bank 1
 *   26af-0.bin   (128K) - Sprite data bank 2
 *   26j0-0.bin..26j7-0.bin (128K each) - OKI ADPCM sound samples
 *   prom.16      (512B) - Color PROM (priority/palette select)
 */

const fs = require('fs');
const path = require('path');

const ROM_DIR = __dirname;

// Load all ROM files
function loadROM(name) {
  const data = fs.readFileSync(path.join(ROM_DIR, name));
  return new Uint8Array(data);
}

console.log('=== Double Dragon 2 ROM Analysis ===\n');

// 1. Analyze Color PROM
const prom = loadROM('prom.16');
console.log(`Color PROM (prom.16): ${prom.length} bytes`);
console.log('First 64 bytes (hex):');
let hexLine = '';
for (let i = 0; i < Math.min(64, prom.length); i++) {
  hexLine += prom[i].toString(16).padStart(2, '0') + ' ';
  if ((i + 1) % 16 === 0) {
    console.log(`  ${(i-15).toString(16).padStart(4,'0')}: ${hexLine}`);
    hexLine = '';
  }
}
console.log('');

// The PROM is typically a priority/layer-select PROM, not a full palette.
// DD2 arcade generates colors from palette RAM written by the CPU.
// However, there's typically a default palette embedded or the PROM maps colors.

// 2. Analyze character graphics ROMs (26a9-04.bin + 26aa-03.bin)
const charRom1 = loadROM('26a9-04.bin');
const charRom2 = loadROM('26aa-03.bin');
console.log(`Character ROM 1 (26a9-04.bin): ${charRom1.length} bytes`);
console.log(`Character ROM 2 (26aa-03.bin): ${charRom2.length} bytes`);

// DD2 characters are 8x8 pixels, 4 bits per pixel
// The two ROMs provide 2 bitplanes each (interleaved)
// Layout: ROM1 has planes 0,1 and ROM2 has planes 2,3
// Each tile = 8 rows × 1 byte per plane per row = 16 bytes per tile per ROM
// Total chars = 32768 / 16 = 2048 tiles per ROM

const charsPerRom = charRom1.length / 16;
console.log(`Characters per ROM: ${charsPerRom} (total unique 8x8 tiles: ${charsPerRom})`);

// Decode first few character tiles to verify format
console.log('\nDecoding character tile #0 (8x8, 4bpp):');

// DD2 char format: each tile is 16 bytes in each ROM
// ROM1 byte layout: row0_plane0, row0_plane1, row1_plane0, row1_plane1, ...
// ROM2 byte layout: row0_plane2, row0_plane3, row1_plane2, row1_plane3, ...
function decodeCharTile(tileIndex) {
  const offset = tileIndex * 16;
  const pixels = [];

  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    const b0 = charRom1[offset + row * 2];     // plane 0
    const b1 = charRom1[offset + row * 2 + 1]; // plane 1
    const b2 = charRom2[offset + row * 2];     // plane 2
    const b3 = charRom2[offset + row * 2 + 1]; // plane 3

    for (let col = 7; col >= 0; col--) {
      const bit0 = (b0 >> col) & 1;
      const bit1 = (b1 >> col) & 1;
      const bit2 = (b2 >> col) & 1;
      const bit3 = (b3 >> col) & 1;
      const pixel = bit0 | (bit1 << 1) | (bit2 << 2) | (bit3 << 3);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

// Print first several tiles to find recognizable patterns
for (let t = 0; t < 8; t++) {
  const tile = decodeCharTile(t);
  console.log(`\nTile #${t}:`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p.toString(16)).join(''));
  }
}

// 3. Look for text characters (ASCII mapping)
// In DD2, character tiles often contain the font starting around tile 0x20-0x7F
console.log('\n\nSearching for font tiles (looking for non-empty tiles with letter shapes)...');
let nonEmptyTiles = 0;
let firstNonEmpty = -1;
for (let t = 0; t < charsPerRom; t++) {
  const tile = decodeCharTile(t);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  if (hasContent) {
    nonEmptyTiles++;
    if (firstNonEmpty === -1) firstNonEmpty = t;
  }
}
console.log(`Non-empty character tiles: ${nonEmptyTiles} out of ${charsPerRom}`);
console.log(`First non-empty tile index: ${firstNonEmpty}`);

// Show tiles around the likely font area
console.log('\nTiles around index 0x30-0x39 (likely digits 0-9):');
for (let t = 0x30; t <= 0x39; t++) {
  const tile = decodeCharTile(t);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  if (hasContent) {
    console.log(`\nTile #${t} (0x${t.toString(16)}): ${String.fromCharCode(t)}`);
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? '#' : '.').join(''));
    }
  }
}

// 4. Analyze sprite ROMs
const sprRom0 = loadROM('26ad-0.bin');
const sprRom1 = loadROM('26ae-0.bin');
const sprRom2 = loadROM('26af-0.bin');
console.log(`\n\nSprite ROM 0 (26ad-0.bin): ${sprRom0.length} bytes`);
console.log(`Sprite ROM 1 (26ae-0.bin): ${sprRom1.length} bytes`);
console.log(`Sprite ROM 2 (26af-0.bin): ${sprRom2.length} bytes`);

// DD2 sprites are 16x16, 4bpp
// The sprite ROMs need to be decoded differently - they're interleaved across ROMs
// Total sprite data = 32K + 64K + 128K = 224K
// Each 16x16 sprite at 4bpp = 16*16/2 = 128 bytes
// Possible sprites = 224K / 128 = 1792
console.log(`Total sprite data: ${(sprRom0.length + sprRom1.length + sprRom2.length) / 1024}K`);
console.log(`Potential 16x16 sprites (128 bytes each): ${(sprRom0.length + sprRom1.length + sprRom2.length) / 128}`);

// 5. Analyze background ROMs
const bgRom1 = loadROM('26ab-0.bin');
const bgRom2 = loadROM('26ac-02.bin');
console.log(`\nBackground ROM 1 (26ab-0.bin): ${bgRom1.length} bytes`);
console.log(`Background ROM 2 (26ac-02.bin): ${bgRom2.length} bytes`);

// BG tiles are 16x16 at 4bpp, same pairing as characters
const bgTilesPerRom = bgRom1.length / 64; // 16x16 tile at 2bpp per ROM = 64 bytes
console.log(`Background tiles (16x16): ${bgTilesPerRom}`);

// 6. Look at the main CPU ROM for palette data
const mainCpu = loadROM('26a10-0.bin');
console.log(`\nMain CPU ROM (26a10-0.bin): ${mainCpu.length} bytes`);

// Search for palette data patterns in main CPU ROM
// DD2 typically uses 256 colors with 16 palettes of 16 colors
// Colors are usually stored as xBBBBBGGGGGRRRRR (16-bit)
// or as separate R,G,B bytes

// Look at the PROM more carefully - it's 512 bytes
// This could be 256 entries × 2 bytes or other configs
console.log('\n=== PROM Analysis ===');
console.log(`PROM size: ${prom.length} bytes`);

// Check unique values
const promValues = new Set(prom);
console.log(`Unique PROM values: ${promValues.size}`);
console.log(`PROM value range: ${Math.min(...prom)} - ${Math.max(...prom)}`);

// Full PROM dump
console.log('\nFull PROM dump:');
for (let i = 0; i < prom.length; i += 16) {
  const slice = Array.from(prom.slice(i, i + 16));
  const hex = slice.map(b => b.toString(16).padStart(2, '0')).join(' ');
  console.log(`  ${i.toString(16).padStart(4, '0')}: ${hex}`);
}

// 7. Try alternate character decode - maybe planes are different
console.log('\n=== Trying alternate character decode formats ===');

// Format B: non-interleaved planes
function decodeCharTileFormatB(tileIndex) {
  const offset = tileIndex * 16;
  const pixels = [];

  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    // Try: first 8 bytes = plane 0 rows, next 8 bytes = plane 1 rows
    const b0 = charRom1[offset + row];       // plane 0
    const b1 = charRom1[offset + row + 8];   // plane 1
    const b2 = charRom2[offset + row];       // plane 2
    const b3 = charRom2[offset + row + 8];   // plane 3

    for (let col = 7; col >= 0; col--) {
      const pixel = ((b0 >> col) & 1) | (((b1 >> col) & 1) << 1) |
                    (((b2 >> col) & 1) << 2) | (((b3 >> col) & 1) << 3);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\nFormat B - Tiles around 0x30-0x39:');
for (let t = 0x30; t <= 0x39; t++) {
  const tile = decodeCharTileFormatB(t);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  if (hasContent) {
    console.log(`\nTile #${t} (0x${t.toString(16)}):` );
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? '#' : '.').join(''));
    }
  }
}

// Format C: All 4 planes in one ROM (char ROM is 32K, maybe each ROM has full tiles?)
function decodeCharTileFormatC(tileIndex) {
  // 32 bytes per tile: 8 rows × 4 planes
  const offset = tileIndex * 32;
  if (offset + 32 > charRom1.length) return null;
  const pixels = [];

  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    const b0 = charRom1[offset + row * 4];
    const b1 = charRom1[offset + row * 4 + 1];
    const b2 = charRom1[offset + row * 4 + 2];
    const b3 = charRom1[offset + row * 4 + 3];

    for (let col = 7; col >= 0; col--) {
      const pixel = ((b0 >> col) & 1) | (((b1 >> col) & 1) << 1) |
                    (((b2 >> col) & 1) << 2) | (((b3 >> col) & 1) << 3);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\nFormat C (single ROM, 32 bytes/tile) - Tiles 0x20-0x30:');
for (let t = 0x20; t <= 0x39; t++) {
  const tile = decodeCharTileFormatC(t);
  if (!tile) continue;
  const hasContent = tile.some(row => row.some(p => p !== 0));
  if (hasContent) {
    console.log(`\nTile #${t} (0x${t.toString(16)}):` );
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? '#' : '.').join(''));
    }
  }
}

// 8. Statistical analysis of character ROM to find tile boundaries
console.log('\n=== Statistical ROM Analysis ===');
console.log('\nCharacter ROM 1 - byte frequency at offsets mod 16:');
for (let mod = 0; mod < 16; mod++) {
  let zeros = 0, total = 0;
  for (let i = mod; i < charRom1.length; i += 16) {
    if (charRom1[i] === 0) zeros++;
    total++;
  }
  console.log(`  offset %16 == ${mod}: ${((zeros/total)*100).toFixed(1)}% zeros`);
}

// Check if the char ROMs might use a different tile size
console.log('\nFirst 128 bytes of char ROM 1 (hex):');
for (let i = 0; i < 128; i += 16) {
  const slice = Array.from(charRom1.slice(i, i + 16));
  const hex = slice.map(b => b.toString(16).padStart(2, '0')).join(' ');
  const ascii = slice.map(b => b >= 32 && b < 127 ? String.fromCharCode(b) : '.').join('');
  console.log(`  ${i.toString(16).padStart(4, '0')}: ${hex}  |${ascii}|`);
}

console.log('\nFirst 128 bytes of char ROM 2 (hex):');
for (let i = 0; i < 128; i += 16) {
  const slice = Array.from(charRom2.slice(i, i + 16));
  const hex = slice.map(b => b.toString(16).padStart(2, '0')).join(' ');
  console.log(`  ${i.toString(16).padStart(4, '0')}: ${hex}`);
}

// Try MAME-style decode for DD2
// Based on MAME source, DD2 characters use this layout:
// RGN_FRAC(1,2) for each ROM
// 4 planes:
//   plane 0: RGN_FRAC(1,2)+0
//   plane 1: RGN_FRAC(1,2)+4
//   plane 2: 0
//   plane 3: 4
// xoffset: 0,1,2,3, 8,9,10,11
// yoffset: 0*16, 1*16, 2*16, ... 7*16
// charincrement: 128 bits = 16 bytes

console.log('\n=== MAME-style Character Decode ===');
// Combined ROM: charRom1 || charRom2
// Total = 64K
// plane assignments reference halves of the combined ROM
const charRomCombined = new Uint8Array(charRom1.length + charRom2.length);
charRomCombined.set(charRom1, 0);
charRomCombined.set(charRom2, charRom1.length);

const HALF = charRom1.length; // RGN_FRAC(1,2)

function decodeCharMAME(tileIndex) {
  // charincrement = 128 bits = 16 bytes
  const baseOffset = tileIndex * 16;
  const pixels = [];

  // yoffsets: 0,16,32,48,64,80,96,112 (in bits) = 0,2,4,6,8,10,12,14 (in bytes)
  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    const byteOff = baseOffset + row * 2; // each row is 16 bits = 2 bytes

    // xoffsets: 0,1,2,3, 8,9,10,11 (bit positions within the 16-bit row)
    // So first 4 pixels from bits 0-3 of first byte, next 4 from bits 0-3 of second byte
    for (let col = 0; col < 8; col++) {
      let byteIdx, bitIdx;
      if (col < 4) {
        byteIdx = byteOff;
        bitIdx = col;
      } else {
        byteIdx = byteOff + 1;
        bitIdx = col - 4;
      }

      // 4 planes:
      // plane 0: HALF + byteIdx, bit bitIdx
      // plane 1: HALF + byteIdx, bit (bitIdx + 4)
      // plane 2: byteIdx, bit bitIdx
      // plane 3: byteIdx, bit (bitIdx + 4)
      const p0 = (charRomCombined[HALF + byteIdx] >> bitIdx) & 1;
      const p1 = (charRomCombined[HALF + byteIdx] >> (bitIdx + 4)) & 1;
      const p2 = (charRomCombined[byteIdx] >> bitIdx) & 1;
      const p3 = (charRomCombined[byteIdx] >> (bitIdx + 4)) & 1;

      const pixel = p0 | (p1 << 1) | (p2 << 2) | (p3 << 3);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('MAME-style decoded tiles 0-16:');
for (let t = 0; t < 16; t++) {
  const tile = decodeCharMAME(t);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  console.log(`\nTile #${t} (0x${t.toString(16)}) ${hasContent ? '[HAS CONTENT]' : '[EMPTY]'}:`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
  }
}

console.log('\nMAME-style tiles 0x20-0x50:');
for (let t = 0x20; t <= 0x50; t++) {
  const tile = decodeCharMAME(t);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  if (hasContent) {
    console.log(`\nTile #${t} (0x${t.toString(16)}):`);
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? '#' : '.').join(''));
    }
  }
}

console.log('\n=== Analysis Complete ===');
