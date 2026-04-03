#!/usr/bin/env node
/**
 * Identify which ROMs contain graphics vs code vs audio
 * by analyzing byte patterns and entropy
 */
const fs = require('fs');
const path = require('path');

const ROM_DIR = __dirname;

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

function analyzeROM(name) {
  const data = loadROM(name);

  // Check for 6809 code patterns
  let jmpCount = 0, jsrCount = 0, branchCount = 0;
  for (let i = 0; i < data.length - 2; i++) {
    if (data[i] === 0x7E) jmpCount++;  // JMP extended
    if (data[i] === 0xBD) jsrCount++;  // JSR extended
    if (data[i] === 0x20 || data[i] === 0x26 || data[i] === 0x27) branchCount++; // BRA/BNE/BEQ
  }

  // Entropy calculation
  const freq = new Array(256).fill(0);
  for (let i = 0; i < data.length; i++) freq[data[i]]++;
  let entropy = 0;
  for (let i = 0; i < 256; i++) {
    if (freq[i] > 0) {
      const p = freq[i] / data.length;
      entropy -= p * Math.log2(p);
    }
  }

  // Zero density (graphics often have many zeros for empty tiles)
  const zeroCount = freq[0];
  const zeroPct = (zeroCount / data.length * 100).toFixed(1);

  // Repeating pattern detection (common in tile graphics)
  let repeatScore = 0;
  for (let i = 0; i < data.length - 1; i++) {
    if (data[i] === data[i+1]) repeatScore++;
  }
  const repeatPct = (repeatScore / data.length * 100).toFixed(1);

  // Check for ADPCM patterns (tends to have values clustered around 0x77-0x88)
  let midRange = 0;
  for (let i = 0; i < data.length; i++) {
    if (data[i] >= 0x70 && data[i] <= 0x90) midRange++;
  }
  const midPct = (midRange / data.length * 100).toFixed(1);

  // Check if it looks like interleaved bitplane data
  // Graphics ROMs often have patterns where every Nth byte has similar properties

  const codeScore = (jmpCount + jsrCount) / (data.length / 1000);

  let type = 'UNKNOWN';
  if (codeScore > 2) type = 'CPU CODE';
  else if (entropy < 5.0 && parseFloat(zeroPct) > 20) type = 'GRAPHICS (sparse)';
  else if (entropy > 7.5) type = 'AUDIO/COMPRESSED';
  else if (midPct > 15 && entropy > 6.5) type = 'LIKELY AUDIO';
  else type = 'GRAPHICS/DATA';

  console.log(`${name.padEnd(16)} ${(data.length/1024+'K').padEnd(6)} entropy=${entropy.toFixed(2)} zeros=${zeroPct}% repeat=${repeatPct}% JMP=${jmpCount} JSR=${jsrCount} mid=${midPct}% => ${type}`);

  // Print first 32 bytes hex
  const hex = Array.from(data.slice(0, 32)).map(b => b.toString(16).padStart(2, '0')).join(' ');
  console.log(`  first 32: ${hex}`);

  return { name, type, entropy, data };
}

console.log('=== ROM Identification ===\n');

const roms = [
  '26a8-0.bin', '26a9-04.bin', '26aa-03.bin', '26ab-0.bin', '26ac-02.bin',
  '26ad-0.bin', '26ae-0.bin', '26af-0.bin', '26a10-0.bin',
  '26j0-0.bin', '26j1-0.bin', '26j2-0.bin', '26j3-0.bin',
  '26j4-0.bin', '26j5-0.bin', '26j6-0.bin', '26j7-0.bin',
  'prom.16'
];

const results = {};
for (const name of roms) {
  results[name] = analyzeROM(name);
}

// Now try to decode 26a8-0.bin as character tiles (8x8, 2bpp per half)
console.log('\n=== Attempting to decode 26a8-0.bin as character graphics ===');
const gfxRom = loadROM('26a8-0.bin');

// Try simple 2bpp decode (NES-style): 8 bytes plane0, 8 bytes plane1
function decode8x8_2bpp(data, offset) {
  const pixels = [];
  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    const b0 = data[offset + row];
    const b1 = data[offset + row + 8];
    for (let col = 7; col >= 0; col--) {
      const pixel = ((b0 >> col) & 1) | (((b1 >> col) & 1) << 1);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

// Try interleaved 2bpp: alternating plane0/plane1 bytes
function decode8x8_2bpp_interleaved(data, offset) {
  const pixels = [];
  for (let row = 0; row < 8; row++) {
    const rowPixels = [];
    const b0 = data[offset + row * 2];
    const b1 = data[offset + row * 2 + 1];
    for (let col = 7; col >= 0; col--) {
      const pixel = ((b0 >> col) & 1) | (((b1 >> col) & 1) << 1);
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\n2bpp planar decode of 26a8-0.bin, tiles 0-8:');
for (let t = 0; t < 8; t++) {
  const tile = decode8x8_2bpp(gfxRom, t * 16);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  console.log(`Tile #${t} ${hasContent ? '' : '[EMPTY]'}:`);
  for (const row of tile) {
    console.log('  ' + row.map(p => '.123'[p]).join(''));
  }
}

console.log('\n2bpp interleaved decode of 26a8-0.bin, tiles 0-8:');
for (let t = 0; t < 8; t++) {
  const tile = decode8x8_2bpp_interleaved(gfxRom, t * 16);
  const hasContent = tile.some(row => row.some(p => p !== 0));
  console.log(`Tile #${t} ${hasContent ? '' : '[EMPTY]'}:`);
  for (const row of tile) {
    console.log('  ' + row.map(p => '.123'[p]).join(''));
  }
}

// Try the j-series ROMs as graphics
console.log('\n=== Attempting to decode 26j0-0.bin as sprite graphics ===');
const sprRom = loadROM('26j0-0.bin');

// DD2 sprites: 16x16, 4bpp
// MAME layout for DD2 sprites:
// The j ROMs are loaded in pairs, interleaved
// Let's try several common arcade sprite formats

// Format 1: column-major 4bpp
function decode16x16_4bpp_cols(data, offset) {
  const pixels = [];
  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    for (let col = 0; col < 16; col += 8) {
      const byteOff = offset + row + col * 2;
      const b0 = data[byteOff];
      const b1 = data[byteOff + 16];
      for (let bit = 7; bit >= 0; bit--) {
        const p0 = (b0 >> bit) & 1;
        const p1 = (b1 >> bit) & 1;
        rowPixels.push(p0 | (p1 << 1));
      }
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

// Format 2: row-major planar
function decode16x16_planar(data, offset) {
  const pixels = [];
  // 16 rows, each row = 2 bytes per plane, 4 planes = 8 bytes per row
  // Total = 128 bytes per tile
  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    for (let col = 15; col >= 0; col--) {
      const byteIdx = Math.floor((15 - col) / 8);
      const bitIdx = col % 8;
      const rowOff = offset + row * 8;
      const p0 = (data[rowOff + byteIdx] >> bitIdx) & 1;
      const p1 = (data[rowOff + byteIdx + 2] >> bitIdx) & 1;
      const p2 = (data[rowOff + byteIdx + 4] >> bitIdx) & 1;
      const p3 = (data[rowOff + byteIdx + 6] >> bitIdx) & 1;
      rowPixels.push(p0 | (p1 << 1) | (p2 << 2) | (p3 << 3));
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\nPlanar decode of 26j0-0.bin, tiles 0-4 (128 bytes/tile):');
for (let t = 0; t < 4; t++) {
  const tile = decode16x16_planar(sprRom, t * 128);
  const nonZero = tile.flat().filter(p => p !== 0).length;
  console.log(`\nTile #${t} (non-zero pixels: ${nonZero}/256):`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
  }
}

// Also try: each j ROM has different bitplanes
// j0 + j1 = planes 0,1 and j2 + j3 = planes 2,3 etc.
console.log('\n=== Cross-ROM decode: j0(planes 0,1) + j2(planes 2,3) ===');
const j0 = loadROM('26j0-0.bin');
const j1 = loadROM('26j1-0.bin');
const j2 = loadROM('26j2-0.bin');
const j3 = loadROM('26j3-0.bin');

// Try: each ROM provides one bitplane, simple 16x16 tiles, 32 bytes per plane
// 16 rows × 2 bytes/row = 32 bytes per plane per tile
function decodeCrossROM_16x16(roms, tileIndex) {
  const bytesPerPlane = 32; // 16 rows × 2 bytes
  const offset = tileIndex * bytesPerPlane;
  const pixels = [];

  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    for (let byteInRow = 0; byteInRow < 2; byteInRow++) {
      const byteOff = offset + row * 2 + byteInRow;
      for (let bit = 7; bit >= 0; bit--) {
        let pixel = 0;
        for (let plane = 0; plane < roms.length && plane < 4; plane++) {
          if (byteOff < roms[plane].length) {
            pixel |= ((roms[plane][byteOff] >> bit) & 1) << plane;
          }
        }
        rowPixels.push(pixel);
      }
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\nCross-ROM tiles (j0,j1,j2,j3), tiles 0-4:');
for (let t = 0; t < 4; t++) {
  const tile = decodeCrossROM_16x16([j0, j1, j2, j3], t);
  const nonZero = tile.flat().filter(p => p !== 0).length;
  console.log(`\nTile #${t} (non-zero: ${nonZero}/256):`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
  }
}

// Try another common format: interleaved byte pairs from consecutive ROMs
console.log('\n=== Interleaved pairs: (j0[even]+j1[odd]) for low, (j2[even]+j3[odd]) for high ===');
function decodeInterleavedPairs(rom0, rom1, tileIndex) {
  // Each tile = 64 bytes (16x16 at 2bpp)
  // rom0 provides even bytes, rom1 provides odd bytes -> combined = full bitplane data
  const tileSize = 64;
  const offset = tileIndex * tileSize;
  const pixels = [];

  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    // 2 bytes per row in each plane pair
    const b0 = rom0[offset + row * 2];
    const b1 = rom0[offset + row * 2 + 1];
    const b2 = rom1[offset + row * 2];
    const b3 = rom1[offset + row * 2 + 1];

    for (let bit = 7; bit >= 0; bit--) {
      const p0 = (b0 >> bit) & 1;
      const p1 = (b1 >> bit) & 1;
      const p2 = (b2 >> bit) & 1;
      const p3 = (b3 >> bit) & 1;
      rowPixels.push(p0 | (p1 << 1) | (p2 << 2) | (p3 << 3));
    }
    // Second byte of the row
    // Actually for 16 pixels wide we need more bits...
    // Skip for now, just show 8 pixels wide
    pixels.push(rowPixels);
  }
  return pixels;
}

// Actually let me look at this from MAME's perspective
// In MAME ddragon2 driver, the sprite gfx layout is:
//
// static const gfx_layout sprite_layout = {
//   16,16,  /* 16*16 sprites */
//   RGN_FRAC(1,4),  /* number of sprites = total_size / 4 */
//   4,      /* 4 bits per pixel */
//   { RGN_FRAC(0,4), RGN_FRAC(1,4), RGN_FRAC(2,4), RGN_FRAC(3,4) },
//   { 0,1,2,3,4,5,6,7, 8,9,10,11,12,13,14,15 },
//   { 0*16, 1*16, 2*16, ... 15*16 },
//   256  /* 256 bits = 32 bytes per tile per plane */
// };
//
// This means: 4 ROMs interleaved, each providing one bitplane
// Each tile per plane = 32 bytes (16 rows × 16 bits/row = 256 bits)

console.log('\n=== MAME sprite layout: 4 ROMs, each = 1 bitplane, 32 bytes/tile/plane ===');

function decodeMAMESprite(roms, tileIndex) {
  const bytesPerTilePerPlane = 32; // 16 rows × 2 bytes/row
  const offset = tileIndex * bytesPerTilePerPlane;
  const pixels = [];

  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    const byte0_hi = offset + row * 2;
    const byte0_lo = offset + row * 2 + 1;

    // 16 pixels per row, MSB first
    for (let col = 0; col < 16; col++) {
      const byteIdx = col < 8 ? byte0_hi : byte0_lo;
      const bitIdx = 7 - (col % 8);

      let pixel = 0;
      for (let plane = 0; plane < 4; plane++) {
        if (byteIdx < roms[plane].length) {
          pixel |= ((roms[plane][byteIdx] >> bitIdx) & 1) << plane;
        }
      }
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

// Try j0,j1,j2,j3 as the 4 planes
console.log('\nSprites from [j0,j1,j2,j3], tiles 0-4:');
for (let t = 0; t < 4; t++) {
  const tile = decodeMAMESprite([j0, j1, j2, j3], t);
  const nonZero = tile.flat().filter(p => p !== 0).length;
  console.log(`\nTile #${t} (non-zero: ${nonZero}/256):`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
  }
}

// Also try scanning forward to find recognizable sprite shapes
console.log('\n=== Scanning for non-trivial sprite tiles ===');
let foundTiles = 0;
for (let t = 0; t < 200 && foundTiles < 5; t++) {
  const tile = decodeMAMESprite([j0, j1, j2, j3], t);
  const flat = tile.flat();
  const nonZero = flat.filter(p => p !== 0).length;
  const uniqueVals = new Set(flat).size;

  // Look for tiles with moderate content (not empty, not full noise)
  if (nonZero > 30 && nonZero < 220 && uniqueVals > 3) {
    foundTiles++;
    console.log(`\nTile #${t} (non-zero: ${nonZero}, unique colors: ${uniqueVals}):`);
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
    }
  }
}

// Try with different ROM ordering
console.log('\n=== Try [j0,j2,j4,j6] as 4 planes (even ROMs) ===');
const j4 = loadROM('26j4-0.bin');
const j5 = loadROM('26j5-0.bin');
const j6 = loadROM('26j6-0.bin');
const j7 = loadROM('26j7-0.bin');

foundTiles = 0;
for (let t = 0; t < 200 && foundTiles < 5; t++) {
  const tile = decodeMAMESprite([j0, j2, j4, j6], t);
  const flat = tile.flat();
  const nonZero = flat.filter(p => p !== 0).length;
  const uniqueVals = new Set(flat).size;

  if (nonZero > 30 && nonZero < 220 && uniqueVals > 3) {
    foundTiles++;
    console.log(`\nTile #${t} (non-zero: ${nonZero}, unique: ${uniqueVals}):`);
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
    }
  }
}

// Actually, let me reconsider. For DD2, the MAME source shows:
// The gfx2 region (sprites) loads ROMs like this:
//   ROM_LOAD( "26j0-0.bin", 0x000000, 0x20000, ... )
//   ROM_LOAD( "26j1-0.bin", 0x020000, 0x20000, ... )
//   etc.
// This means they're loaded SEQUENTIALLY, not interleaved!
// The gfx_layout then references fractions of the total region.

console.log('\n=== Sequential ROM layout (all j ROMs concatenated) ===');
// Concatenate all 8 j ROMs
const allJ = new Uint8Array(j0.length * 8);
[j0,j1,j2,j3,j4,j5,j6,j7].forEach((rom, i) => allJ.set(rom, i * rom.length));

const totalSize = allJ.length;
const quarter = totalSize / 4;

console.log(`Total sprite data: ${totalSize} bytes (${totalSize/1024}K)`);
console.log(`Quarter size: ${quarter} bytes`);
console.log(`Tiles per quarter at 32 bytes/tile: ${quarter / 32}`);

function decodeFromConcatenated(data, totalLen, tileIndex) {
  const q = totalLen / 4;
  const bytesPerTile = 32;
  const offset = tileIndex * bytesPerTile;
  const pixels = [];

  for (let row = 0; row < 16; row++) {
    const rowPixels = [];
    for (let col = 0; col < 16; col++) {
      const byteInRow = col < 8 ? (row * 2) : (row * 2 + 1);
      const bitIdx = 7 - (col % 8);
      const byteOff = offset + byteInRow;

      let pixel = 0;
      // 4 planes from 4 quarters
      for (let plane = 0; plane < 4; plane++) {
        const romOff = plane * q + byteOff;
        if (romOff < totalLen) {
          pixel |= ((data[romOff] >> bitIdx) & 1) << plane;
        }
      }
      rowPixels.push(pixel);
    }
    pixels.push(rowPixels);
  }
  return pixels;
}

console.log('\nConcatenated decode, tiles 0-8:');
for (let t = 0; t < 8; t++) {
  const tile = decodeFromConcatenated(allJ, totalSize, t);
  const flat = tile.flat();
  const nonZero = flat.filter(p => p !== 0).length;
  const uniqueVals = new Set(flat).size;
  console.log(`\nTile #${t} (non-zero: ${nonZero}, unique: ${uniqueVals}):`);
  for (const row of tile) {
    console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
  }
}

// Scan for good tiles
console.log('\nScanning concatenated for recognizable tiles...');
foundTiles = 0;
for (let t = 0; t < 2000 && foundTiles < 8; t++) {
  const tile = decodeFromConcatenated(allJ, totalSize, t);
  const flat = tile.flat();
  const nonZero = flat.filter(p => p !== 0).length;
  const uniqueVals = new Set(flat).size;

  if (nonZero > 40 && nonZero < 200 && uniqueVals >= 4) {
    foundTiles++;
    console.log(`\nTile #${t} (non-zero: ${nonZero}, unique: ${uniqueVals}):`);
    for (const row of tile) {
      console.log('  ' + row.map(p => p > 0 ? p.toString(16) : '.').join(''));
    }
  }
}
