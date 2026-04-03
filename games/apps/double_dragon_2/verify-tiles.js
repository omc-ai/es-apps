#!/usr/bin/env node
/**
 * Verify tile decoding by rendering individual tiles at larger scale
 * and also trying ALTERNATE decode formats to find the correct one.
 *
 * DD2 arcade uses Technos TA-0026 hardware.
 * The sprite graphics ROMs (26j0-26j5) need to be decoded correctly.
 *
 * MAME ddragon.cpp defines this for sprites:
 *
 * static const gfx_layout tile_layout = {
 *   16,16,
 *   RGN_FRAC(1,2),
 *   4,
 *   { RGN_FRAC(1,2)+0, RGN_FRAC(1,2)+4, 0, 4 },
 *   { 3,2,1,0, 16+3,16+2,16+1,16+0,
 *     32*8+3,32*8+2,32*8+1,32*8+0, 33*8+3,33*8+2,33*8+1,33*8+0 },
 *   { 0*32, 1*32, 2*32, 3*32, 4*32, 5*32, 6*32, 7*32 },
 *   512
 * };
 *
 * IMPORTANT: This layout has 16 x-entries but only 8 y-entries!
 * With charincrement=512 bits=64 bytes.
 * This means each "tile" in this layout is 16x8 pixels, NOT 16x16.
 * A 16x16 sprite is composed of TWO consecutive tiles stacked vertically.
 *
 * Let me also try the ACTUAL MAME approach:
 * RGN_FRAC(1,2) means the ROM region is split into 2 halves.
 * If we have 6 ROMs of 128K each = 768KB total:
 *   Half 0 = first 384KB (j0,j1,j2 = 3 ROMs)
 *   Half 1 = last 384KB (j3,j4,j5 = 3 ROMs)
 *
 * OR the ROMs might be interleaved differently.
 * Let me try multiple approaches and see which produces recognizable sprites.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(__dirname, name)));
}

const OUT = path.join(__dirname, 'output', 'verify');
fs.mkdirSync(OUT, { recursive: true });

// Load sprite ROMs
const j = [0,1,2,3,4,5].map(i => loadROM(`26j${i}-0.bin`));
const totalLen = j.reduce((s, r) => s + r.length, 0);

// A simple grayscale palette for testing
const GRAY_PAL = Array.from({length: 16}, (_, i) => {
  const v = Math.round(i * 255 / 15);
  return [v, v, v, i === 0 ? 0 : 255];
});

// DD2-like palette
const DD2_PAL = [
  [0,0,0,0],         // 0: transparent
  [40,40,60,255],     // 1: dark
  [80,80,120,255],    // 2:
  [120,120,160,255],  // 3:
  [160,160,200,255],  // 4:
  [200,200,240,255],  // 5:
  [240,240,255,255],  // 6:
  [255,200,150,255],  // 7: skin
  [200,150,100,255],  // 8: skin shadow
  [150,100,60,255],   // 9:
  [100,60,30,255],    // 10:
  [60,100,200,255],   // 11: blue
  [40,60,160,255],    // 12:
  [200,60,60,255],    // 13: red
  [255,220,0,255],    // 14: yellow
  [255,255,255,255],  // 15: white
];

function saveTileSheet(tiles, tileW, tileH, cols, palette, filename) {
  const rows = Math.ceil(tiles.length / cols);
  const png = new PNG({ width: cols * tileW, height: rows * tileH });
  // Fill transparent
  for (let i = 0; i < png.data.length; i += 4) {
    png.data[i] = png.data[i+1] = png.data[i+2] = 0; png.data[i+3] = 0;
  }
  for (let t = 0; t < tiles.length; t++) {
    const tx = (t % cols) * tileW;
    const ty = Math.floor(t / cols) * tileH;
    for (let y = 0; y < tileH; y++) {
      for (let x = 0; x < tileW; x++) {
        const ci = tiles[t][y * tileW + x];
        const c = palette[ci] || [255,0,255,255];
        const di = ((ty + y) * png.width + (tx + x)) * 4;
        png.data[di] = c[0]; png.data[di+1] = c[1]; png.data[di+2] = c[2]; png.data[di+3] = c[3];
      }
    }
  }
  fs.writeFileSync(path.join(OUT, filename), PNG.sync.write(png));
  console.log(`  Saved ${filename} (${tiles.length} tiles, ${png.width}x${png.height})`);
}

// ═══════════════════════════════════════════════
// METHOD A: Our current decode (sequential concat, HALF = total/2)
// ═══════════════════════════════════════════════
console.log('=== Method A: Sequential concat, full 16x16, 128 bytes/tile ===');
{
  const combined = new Uint8Array(totalLen);
  let off = 0;
  for (const rom of j) { combined.set(rom, off); off += rom.length; }
  const HALF = totalLen * 8 / 2; // in bits
  const planes = [HALF + 0, HALF + 4, 0, 4];
  const xoff = [3,2,1,0, 19,18,17,16, 259,258,257,256, 275,274,273,272];
  const yoff = [];
  for (let i = 0; i < 8; i++) yoff.push(i * 32);
  for (let i = 0; i < 8; i++) yoff.push(512 + i * 32);

  const tiles = [];
  const NT = Math.min(256, Math.floor(totalLen / 2 / 128)); // first 256 tiles
  for (let t = 0; t < NT; t++) {
    const px = new Uint8Array(256);
    const base = t * 1024; // 128 bytes * 8 bits
    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bp = base + yoff[y] + xoff[x] + planes[p];
          const bi = Math.floor(bp / 8), bit = bp % 8;
          if (bi < combined.length) pixel |= (((combined[bi] >> bit) & 1) << p);
        }
        px[y * 16 + x] = pixel;
      }
    }
    tiles.push(px);
  }
  saveTileSheet(tiles, 16, 16, 16, DD2_PAL, 'methodA_first256.png');
}

// ═══════════════════════════════════════════════
// METHOD B: MAME-accurate 16x8 tiles, charincrement=512
// Two consecutive tiles = one 16x16 sprite
// HALF = 3 ROMs each side
// ═══════════════════════════════════════════════
console.log('=== Method B: MAME 16x8 tiles, HALF=3 ROMs ===');
{
  // Concatenate: first half = j0+j1+j2, second half = j3+j4+j5
  const halfSize = j[0].length + j[1].length + j[2].length;
  const combined = new Uint8Array(halfSize * 2);
  let off = 0;
  combined.set(j[0], off); off += j[0].length;
  combined.set(j[1], off); off += j[1].length;
  combined.set(j[2], off); off += j[2].length;
  combined.set(j[3], off); off += j[3].length;
  combined.set(j[4], off); off += j[4].length;
  combined.set(j[5], off);

  const HALF = halfSize * 8;
  const planes = [HALF + 0, HALF + 4, 0, 4];
  const xoff = [3,2,1,0, 19,18,17,16, 259,258,257,256, 275,274,273,272];
  const yoff8 = [0, 32, 64, 96, 128, 160, 192, 224]; // only 8 rows
  const TILE_INC = 512; // 64 bytes per 16x8 tile

  // Decode as 16x8 tiles, then pair them into 16x16
  const numHalfTiles = Math.floor(halfSize / 64);
  console.log(`  16x8 tiles: ${numHalfTiles}`);

  const tiles16x16 = [];
  for (let t = 0; t < Math.min(512, numHalfTiles / 2); t++) {
    const px = new Uint8Array(256);
    for (let half = 0; half < 2; half++) {
      const tileIdx = t * 2 + half;
      const base = tileIdx * TILE_INC;
      for (let y = 0; y < 8; y++) {
        for (let x = 0; x < 16; x++) {
          let pixel = 0;
          for (let p = 0; p < 4; p++) {
            const bp = base + yoff8[y] + xoff[x] + planes[p];
            const bi = Math.floor(bp / 8), bit = bp % 8;
            if (bi < combined.length) pixel |= (((combined[bi] >> bit) & 1) << p);
          }
          px[(half * 8 + y) * 16 + x] = pixel;
        }
      }
    }
    tiles16x16.push(px);
  }
  saveTileSheet(tiles16x16, 16, 16, 16, DD2_PAL, 'methodB_first512.png');
}

// ═══════════════════════════════════════════════
// METHOD C: Interleaved ROMs (j0 || j1 byte-interleaved, etc.)
// Some Technos hardware interleaves ROM bytes
// ═══════════════════════════════════════════════
console.log('=== Method C: Byte-interleaved pairs ===');
{
  // Interleave j0 with j1 (byte by byte), j2 with j3, j4 with j5
  const pairSize = j[0].length * 2;
  const combined = new Uint8Array(pairSize * 3);
  for (let pair = 0; pair < 3; pair++) {
    const romA = j[pair * 2];
    const romB = j[pair * 2 + 1];
    for (let i = 0; i < romA.length; i++) {
      combined[pair * pairSize + i * 2] = romA[i];
      combined[pair * pairSize + i * 2 + 1] = romB[i];
    }
  }

  const HALF = combined.length * 8 / 2;
  const planes = [HALF + 0, HALF + 4, 0, 4];
  const xoff = [3,2,1,0, 19,18,17,16, 259,258,257,256, 275,274,273,272];
  const yoff = [];
  for (let i = 0; i < 8; i++) yoff.push(i * 32);
  for (let i = 0; i < 8; i++) yoff.push(512 + i * 32);

  const tiles = [];
  for (let t = 0; t < 256; t++) {
    const px = new Uint8Array(256);
    const base = t * 1024;
    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bp = base + yoff[y] + xoff[x] + planes[p];
          const bi = Math.floor(bp / 8), bit = bp % 8;
          if (bi < combined.length) pixel |= (((combined[bi] >> bit) & 1) << p);
        }
        px[y * 16 + x] = pixel;
      }
    }
    tiles.push(px);
  }
  saveTileSheet(tiles, 16, 16, 16, DD2_PAL, 'methodC_interleaved.png');
}

// ═══════════════════════════════════════════════
// METHOD D: Each ROM = one bitplane (simple planar)
// j0=plane0, j1=plane1, j2=plane2, j3=plane3
// 32 bytes per tile per plane (16 rows x 2 bytes)
// ═══════════════════════════════════════════════
console.log('=== Method D: Each ROM = one bitplane, 32 bytes/tile ===');
{
  const bytesPerPlane = 32;
  const numT = Math.min(512, Math.floor(j[0].length / bytesPerPlane));
  const tiles = [];
  for (let t = 0; t < numT; t++) {
    const px = new Uint8Array(256);
    const off = t * bytesPerPlane;
    for (let y = 0; y < 16; y++) {
      for (let x = 0; x < 16; x++) {
        const byteInRow = Math.floor(x / 8);
        const bitInByte = 7 - (x % 8);
        const byteOff = off + y * 2 + byteInRow;
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          if (byteOff < j[p].length) {
            pixel |= (((j[p][byteOff] >> bitInByte) & 1) << p);
          }
        }
        px[y * 16 + x] = pixel;
      }
    }
    tiles.push(px);
  }
  saveTileSheet(tiles, 16, 16, 16, DD2_PAL, 'methodD_planar.png');
}

// ═══════════════════════════════════════════════
// METHOD E: MAME exact - look at actual MAME ddragon.cpp gfx decode
// The gfx2 region for DD2 loads ROMs sequentially.
// The tile_layout uses RGN_FRAC(1,2) meaning:
//   plane 0 = bit 0 in second half of region
//   plane 1 = bit 4 in second half of region
//   plane 2 = bit 0 in first half of region
//   plane 3 = bit 4 in first half of region
// charincrement = 512 bits = 64 bytes
// This means each tile is 64 bytes of data in each half = 128 bytes total
// ═══════════════════════════════════════════════
console.log('=== Method E: MAME exact with sequential load, 64 bytes/tile ===');
{
  // Sequential load: all ROMs concatenated
  const all = new Uint8Array(totalLen);
  let o = 0;
  for (const rom of j) { all.set(rom, o); o += rom.length; }

  const halfBytes = totalLen / 2;
  const tilesPerHalf = Math.floor(halfBytes / 64);
  console.log(`  Tiles per half: ${tilesPerHalf}, halfBytes: ${halfBytes}`);

  // MAME layout details:
  // planes[4] = { HALF*8+0, HALF*8+4, 0, 4 }  (bit offsets)
  // xoffset[16] = { 3,2,1,0, 19,18,17,16, 32*8+3,..., 33*8+3,... }
  // yoffset[8] = { 0*32, 1*32, ..., 7*32 }
  // charincrement = 512 bits
  //
  // Since height is declared as 16 but only 8 yoffsets, MAME actually
  // uses the tile layout as 16x8. Hardware composes 16x16 from pairs.
  //
  // But the Technos hardware draws sprites differently - the sprite code
  // in the CPU organizes the tiles. Let me try treating this as 16x8 tiles
  // paired into 16x16.

  const HALF_BITS = halfBytes * 8;
  const planes = [HALF_BITS + 0, HALF_BITS + 4, 0, 4];
  const xoff = [3,2,1,0, 19,18,17,16, 259,258,257,256, 275,274,273,272];
  const yoff = [0, 32, 64, 96, 128, 160, 192, 224];

  // Decode 16x8 half-tiles
  function decodeHalfTile(tileIdx) {
    const px = new Uint8Array(128); // 16x8
    const base = tileIdx * 512;
    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 16; x++) {
        let pixel = 0;
        for (let p = 0; p < 4; p++) {
          const bp = base + yoff[y] + xoff[x] + planes[p];
          const bi = Math.floor(bp / 8), bit = bp % 8;
          if (bi < all.length) pixel |= (((all[bi] >> bit) & 1) << p);
        }
        px[y * 16 + x] = pixel;
      }
    }
    return px;
  }

  // Pair into 16x16
  const tiles = [];
  for (let t = 0; t < Math.min(512, tilesPerHalf); t++) {
    // Each 16x16 sprite = tile t*2 (top) + tile t*2+1 (bottom)
    const top = decodeHalfTile(t * 2);
    const bot = decodeHalfTile(t * 2 + 1);
    const px = new Uint8Array(256);
    px.set(top, 0);
    px.set(bot, 128);
    tiles.push(px);
  }
  saveTileSheet(tiles, 16, 16, 16, DD2_PAL, 'methodE_mame_paired.png');

  // Also try without pairing - just raw 16x8 tiles
  const rawTiles = [];
  for (let t = 0; t < Math.min(256, tilesPerHalf); t++) {
    const ht = decodeHalfTile(t);
    // Stretch to 16x16 canvas for visibility
    const px = new Uint8Array(256);
    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 16; x++) {
        px[y * 2 * 16 + x] = ht[y * 16 + x];
        px[(y * 2 + 1) * 16 + x] = ht[y * 16 + x];
      }
    }
    rawTiles.push(px);
  }
  saveTileSheet(rawTiles, 16, 16, 16, GRAY_PAL, 'methodE_raw16x8.png');
}

console.log('\n=== All verification tiles saved to output/verify/ ===');
console.log('Compare the PNGs to find which decode method produces recognizable DD2 sprites.');
