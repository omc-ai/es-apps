#!/usr/bin/env node
/**
 * DD2 EXACT Sprite Extraction
 *
 * Uses the MAME-verified sprite RAM format from ddragon_v.cpp:
 *
 * 5 bytes per sprite:
 *   byte[0] = Y position
 *   byte[1] = attributes: bit7=visible, bit5:4=size, bit3=flipX, bit2=flipY,
 *                          bit1=X_MSB, bit0=Y_MSB
 *   byte[2] = (color << 5) | (tile_hi & 0x1F)  -- DD2 format
 *   byte[3] = tile_lo
 *   byte[4] = X position
 *
 *   tile = byte[3] | ((byte[2] & 0x1F) << 8)  -- 13-bit, range 0-8191
 *   color = byte[2] >> 5                       -- 3-bit, 8 palettes
 *   size: 0=16x16, 1=16x32, 2=32x16, 3=32x32
 *   sx = 240 - byte[4] + ((attr & 2) << 7)
 *   sy = 232 - byte[0] + ((attr & 1) << 8)
 *
 * The CPU writes composition data to sprite RAM for each entity every frame.
 * The data that drives these writes lives in the ROM as tables that the
 * CPU code references indexed by animation state/frame.
 *
 * Since we can't run the CPU, let's instead scan the ROMs for data that
 * matches this 5-byte sprite format - specifically looking for sequences
 * that produce valid tile numbers and reasonable screen positions when
 * decoded as DD2 sprite entries.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(__dirname, name)));
}

const mainRom = loadROM('26a9-04.bin');
const bankRom = loadROM('26aa-03.bin');

// ═══════════════════════════════════════
// APPROACH 1: The CPU writes sprite entries from entity data.
// The composition tables are NOT in sprite RAM format (5 bytes).
// Instead, the CPU code CONSTRUCTS sprite RAM entries from
// separate tile number tables and position offset tables.
//
// From the disassembly trace, the key routine at $4467 (banked):
// - Reads tile data from tables pointed to by U register
// - U is computed from: base_address[group] + set_index*16 + sprite_index
// - The bases at $44EB are: $3C80, $3D00, $3C00, $3476
//
// BUT these are RAM addresses, not ROM addresses!
// The CPU copies tile composition data FROM ROM TO RAM first,
// then the sprite draw routine reads from RAM.
//
// The actual tile composition data is written to RAM by the
// animation update code at $D7FA/$D894 which copies data
// from ROM tables to entity struct fields, which then get
// used by the sprite draw routine.
//
// So the chain is:
// ROM animation table -> entity struct fields -> sprite RAM
//
// The entity struct stores:
//   offset 22: current sprite tile base (from animation table)
//   offset 23: sprite attributes/palette
//   offset 27: animation state byte
//
// The animation tables at $9156 (64 ptrs) contain 12-byte records
// that include the tile base for each animation frame.
// ═══════════════════════════════════════

console.log('=== Extracting DD2 sprite composition data ===\n');

// Let's trace the EXACT path from ROM to sprite RAM.
// The animation frame records pointed to by $9156 table:
console.log('Animation Frame Pointer Table at $9156:');
const framePointers = [];
for (let i = 0; i < 64; i++) {
  const hi = mainRom[0x9156 - 0x8000 + i*2];
  const lo = mainRom[0x9156 - 0x8000 + i*2 + 1];
  const ptr = (hi << 8) | lo;
  framePointers.push(ptr);
}
console.log('Pointers:', framePointers.map(p => '$'+p.toString(16)).join(', '));

// Read the 12-byte animation records
const uniquePtrs = [...new Set(framePointers)];
console.log(`\n${uniquePtrs.length} unique animation records:`);
for (const ptr of uniquePtrs) {
  if (ptr < 0x8000 || ptr > 0xFFFF) continue;
  const record = [];
  for (let b = 0; b < 12; b++) {
    record.push(mainRom[ptr - 0x8000 + b]);
  }
  console.log(`  $${ptr.toString(16)}: [${record.map(b => '0x'+b.toString(16).padStart(2,'0')).join(', ')}]`);
}

// ═══════════════════════════════════════
// The entity struct's sprite tile is at offset 22 (1 byte).
// But DD2 has 6144 tiles, needing more than 8 bits.
// Looking at the sprite draw code, tile = byte3 | ((byte2 & 0x1F) << 8)
// = 13 bits. The entity struct must store at least the high bits somewhere.
//
// From the disassembly at $C8F9 (player idle state handler):
// Let me read what code writes to entity offsets 22-23.
// ═══════════════════════════════════════

// Read the player state handler code to understand tile assignment
console.log('\n=== Player State Handler $C8F9 (State 0: idle/stand) ===');
const stateCode = [];
for (let i = 0; i < 40; i++) {
  stateCode.push(mainRom[0xC8F9 - 0x8000 + i]);
}
console.log('Hex:', stateCode.map(b => b.toString(16).padStart(2,'0')).join(' '));

// Read several state handlers to find the pattern of tile assignment
const stateAddrs = [0xC8F9, 0xC904, 0xC909, 0xC8F8, 0xC90F, 0xC91F, 0xC950, 0xC961];
for (const addr of stateAddrs) {
  const bytes = [];
  for (let i = 0; i < 30; i++) bytes.push(mainRom[addr - 0x8000 + i]);
  console.log(`\n$${addr.toString(16)}: ${bytes.map(b => b.toString(16).padStart(2,'0')).join(' ')}`);
}

// ═══════════════════════════════════════
// Let me look at what $C80F does - it's the main sprite draw
// dispatcher for most character types
// ═══════════════════════════════════════
console.log('\n=== Sprite Draw Dispatcher $C80F ===');
const c80fBytes = [];
for (let i = 0; i < 60; i++) c80fBytes.push(mainRom[0xC80F - 0x8000 + i]);
console.log('Hex:', c80fBytes.map(b => b.toString(16).padStart(2,'0')).join(' '));

// $C80F should:
// 1. Read entity type from offset 23 (or some offset)
// 2. Use it as index into table at $C822
// 3. Call the banked function

// ═══════════════════════════════════════
// Let me now look at the ACTUAL sprite composition by reading
// the banked ROM code at $4467 more carefully
// This is where tiles get written to the sprite buffer
// ═══════════════════════════════════════
console.log('\n=== Banked Sprite Draw $4467 (full code) ===');
const code4467 = [];
for (let i = 0; i < 160; i++) code4467.push(bankRom[0x4467 - 0x4000 + i]);
console.log('Full hex dump:');
for (let line = 0; line < 10; line++) {
  const offset = line * 16;
  const hex = code4467.slice(offset, offset + 16).map(b => b.toString(16).padStart(2,'0')).join(' ');
  console.log(`  $${(0x4467 + offset).toString(16)}: ${hex}`);
}

// ═══════════════════════════════════════
// Let me also look at the entity data that's in RAM.
// The CPU initializes entity structs in RAM at $0300+
// and writes animation data to them.
//
// From the animation state handler at $C8F9:
// It likely does something like:
//   LDA #tile_base_high
//   STA entity_offset_22,X
//   LDA #tile_attributes
//   STA entity_offset_23,X
//
// Let me look for patterns: LDA #xx; STA xx,X where xx is 22 or 23
// ═══════════════════════════════════════
console.log('\n=== Searching for tile base assignments in state handlers ===');

function findTileAssignments(rom, baseAddr) {
  const results = [];
  for (let i = 0; i < rom.length - 4; i++) {
    // Pattern: LDA #imm8; STA offset,X
    // 6809: LDA #nn = 86 nn, STA n,X = A7 8n or A7 nn (indexed)
    // Direct page STA: 97 nn

    // Look for: 86 xx A7 88 16 (LDA #xx; STA 22,X)
    // or 86 xx A7 88 17 (LDA #xx; STA 23,X)
    if (rom[i] === 0x86 && rom[i+2] === 0xA7) {
      const imm = rom[i+1];
      const indexByte = rom[i+3];
      let offset = -1;

      if (rom[i+3] === 0x88) {
        // 8-bit offset indexed: STA offset8,X
        offset = rom[i+4];
        if (offset === 22 || offset === 23 || offset === 27) {
          results.push({
            address: baseAddr + i,
            instruction: `LDA #$${imm.toString(16).padStart(2,'0')}; STA ${offset},X`,
            entityOffset: offset,
            value: imm,
          });
        }
      } else if (indexByte >= 0x00 && indexByte <= 0x1F) {
        // 5-bit offset: STA n,X where n is 0-31
        offset = indexByte;
        if (offset === 22 || offset === 23) {
          results.push({
            address: baseAddr + i,
            instruction: `LDA #$${imm.toString(16).padStart(2,'0')}; STA ${offset},X`,
            entityOffset: offset,
            value: imm,
          });
        }
      }
    }

    // Also look for: LDB #nn; STB offset,X (C6 nn E7 ...)
    if (rom[i] === 0xC6 && rom[i+2] === 0xE7) {
      const imm = rom[i+1];
      if (rom[i+3] === 0x88) {
        const offset = rom[i+4];
        if (offset === 22 || offset === 23 || offset === 27) {
          results.push({
            address: baseAddr + i,
            instruction: `LDB #$${imm.toString(16).padStart(2,'0')}; STB ${offset},X`,
            entityOffset: offset,
            value: imm,
          });
        }
      }
    }
  }
  return results;
}

const mainTileAssign = findTileAssignments(mainRom, 0x8000);
const bankTileAssign = findTileAssignments(bankRom, 0x4000);

console.log(`Main ROM: ${mainTileAssign.length} tile assignments found`);
for (const a of mainTileAssign) {
  console.log(`  ${a.address.toString(16)}: ${a.instruction}`);
}

console.log(`\nBanked ROM: ${bankTileAssign.length} tile assignments found`);
for (const a of bankTileAssign) {
  console.log(`  ${a.address.toString(16)}: ${a.instruction}`);
}

// ═══════════════════════════════════════
// APPROACH 2: Since the CPU generates sprite RAM at runtime,
// let me look at what MAME's sprite drawing does.
// From the video code:
//   tile = src[3] | ((src[2] & 0x1F) << 8)   -- 13-bit number
//   size = (attr >> 4) & 3
//   For size 3 (32x32): draws tiles which, which+1, which+2, which+3
//   For size 1 (16x32): draws tiles which, which+1
//   The tile number has low bits masked by size: which &= ~size
//
// So a 32x32 character uses 4 consecutive tiles: n, n+1, n+2, n+3
// arranged as:
//   size 3: (n+0 at sx+dx,sy+dy) (n+1 at sx+dx,sy) (n+2 at sx,sy+dy) (n+3 at sx,sy)
//
// This means characters in DD2 are composed of MULTIPLE sprite entries
// in sprite RAM, each potentially using size 1, 2, or 3 to draw
// 16x16, 16x32, 32x16, or 32x32 chunks.
//
// A typical DD2 character is ~32x48 pixels = multiple sprite entries.
// ═══════════════════════════════════════

console.log('\n=== DD2 Character Composition Model ===');
console.log('Based on MAME video code:');
console.log('  Size 0: 1 tile  (16x16)');
console.log('  Size 1: 2 tiles (16x32) - which, which+1 stacked vertically');
console.log('  Size 2: 2 tiles (32x16) - which, which+2 side by side');
console.log('  Size 3: 4 tiles (32x32) - which+0/+1/+2/+3 in 2x2 grid');
console.log('');
console.log('A character frame = multiple sprite RAM entries, each with:');
console.log('  - tile base (13-bit)');
console.log('  - size (determines how many tiles)');
console.log('  - X,Y position on screen');
console.log('  - flip flags');
console.log('  - color palette');

// ═══════════════════════════════════════
// Now let me look at the EXACT sprite data that the CPU writes.
// The sub-CPU at $26ae-0.bin copies data from shared RAM to sprite RAM.
// But the main CPU writes to shared RAM at $1000-$17FF.
//
// Let me search for code that writes to the $10xx-$17xx range
// ═══════════════════════════════════════
console.log('\n=== Searching for sprite RAM writes ($1000-$17FF) ===');

function findSpriteWrites(rom, baseAddr) {
  const writes = [];
  for (let i = 0; i < rom.length - 3; i++) {
    // STA extended: B7 hi lo
    if (rom[i] === 0xB7) {
      const addr = (rom[i+1] << 8) | rom[i+2];
      if (addr >= 0x1000 && addr < 0x1800) {
        writes.push({ romAddr: baseAddr + i, targetAddr: addr, instruction: 'STA' });
      }
    }
    // STB extended: F7 hi lo
    if (rom[i] === 0xF7) {
      const addr = (rom[i+1] << 8) | rom[i+2];
      if (addr >= 0x1000 && addr < 0x1800) {
        writes.push({ romAddr: baseAddr + i, targetAddr: addr, instruction: 'STB' });
      }
    }
    // STD extended: FD hi lo
    if (rom[i] === 0xFD) {
      const addr = (rom[i+1] << 8) | rom[i+2];
      if (addr >= 0x1000 && addr < 0x1800) {
        writes.push({ romAddr: baseAddr + i, targetAddr: addr, instruction: 'STD' });
      }
    }
    // STA/STB indexed: A7/E7 with base in X/Y/U pointing to sprite RAM
    // These are harder to detect statically since we don't know register values
  }
  return writes;
}

const mainSprWrites = findSpriteWrites(mainRom, 0x8000);
const bankSprWrites = findSpriteWrites(bankRom, 0x4000);
console.log(`Direct sprite RAM writes: main=${mainSprWrites.length}, banked=${bankSprWrites.length}`);
for (const w of [...mainSprWrites, ...bankSprWrites].slice(0, 20)) {
  console.log(`  $${w.romAddr.toString(16)}: ${w.instruction} -> $${w.targetAddr.toString(16)}`);
}

// ═══════════════════════════════════════
// APPROACH 3: The most reliable way to get exact sprite compositions
// is to look at the banked ROM's multi-sprite buffer write code.
//
// From the agent's findings, the multi-sprite path at $44B3 writes
// to buffer at $0C9D (34 bytes per entry, up to 16 entries).
// Each buffer entry describes one complete character:
//   - Number of sprite tiles
//   - For each tile: position, tile number, attributes
//
// The data that populates these entries comes from tables
// indexed by the entity's animation state.
//
// Let me dump the code around $44B3 and trace the data format.
// ═══════════════════════════════════════
console.log('\n=== Multi-sprite buffer writer $44B3 ===');
for (let line = 0; line < 12; line++) {
  const off = 0x44B3 - 0x4000 + line * 16;
  const addr = 0x44B3 + line * 16;
  const bytes = [];
  for (let i = 0; i < 16; i++) {
    if (off + i < bankRom.length) bytes.push(bankRom[off + i]);
  }
  console.log(`  $${addr.toString(16)}: ${bytes.map(b => b.toString(16).padStart(2,'0')).join(' ')}`);
}

// ═══════════════════════════════════════
// The sprite buffer base at $0C5C contains entries that get
// DMA'd to sprite RAM. Let me look at the DMA code at $44F1
// (end of the sprite draw function) to see the exact transfer format.
// ═══════════════════════════════════════
console.log('\n=== Sprite DMA routine ===');
// Search for code that reads from $0C5C and writes to $1000+
// The DMA likely happens in the NMI or a dedicated routine

// Look at the NMI handler which copies sprite data
// NMI at $8038 copies $2081 -> $2800 (we saw this earlier)
// But sprite RAM at $1000 is separate

// Let's check what $44F1 (from agent's finding) does
const dmaOff = 0x44F1 - 0x4000;
if (dmaOff >= 0 && dmaOff < bankRom.length) {
  const bytes = [];
  for (let i = 0; i < 64; i++) {
    if (dmaOff + i < bankRom.length) bytes.push(bankRom[dmaOff + i]);
  }
  console.log('$44F1 code:', bytes.map(b => b.toString(16).padStart(2,'0')).join(' '));
}

// Save everything we've found
const output = {
  spriteRAMFormat: {
    bytesPerEntry: 5,
    format: {
      byte0: 'Y position',
      byte1: 'Attributes: bit7=visible, bit5:4=size(0=16x16,1=16x32,2=32x16,3=32x32), bit3=flipX, bit2=flipY, bit1=X_MSB, bit0=Y_MSB',
      byte2: '(color<<5) | (tile_high & 0x1F)',
      byte3: 'tile_low',
      byte4: 'X position',
    },
    tileComputation: 'tile = byte3 | ((byte2 & 0x1F) << 8)',
    colorComputation: 'color = byte2 >> 5',
    positionComputation: 'sx = 240 - byte4 + ((attr & 2) << 7); sy = 232 - byte0 + ((attr & 1) << 8)',
    sizeDrawing: {
      '0': '1 tile (16x16)',
      '1': '2 tiles vertical (16x32): tile, tile+1',
      '2': '2 tiles horizontal (32x16): tile, tile+2',
      '3': '4 tiles (32x32): tile, tile+1, tile+2, tile+3',
    },
  },
  tileAssignments: {
    mainRom: mainTileAssign,
    bankedRom: bankTileAssign,
  },
  spriteRAMWrites: {
    mainRom: mainSprWrites.length,
    bankedRom: bankSprWrites.length,
  },
};

fs.writeFileSync(
  path.join(__dirname, 'output', 'exact-sprite-format.json'),
  JSON.stringify(output, null, 2)
);

console.log('\n=== Summary ===');
console.log('DD2 sprite RAM format: 5 bytes per sprite, MAME-verified');
console.log('Tile numbers: 13-bit (0-8191), but only 6144 tiles exist');
console.log('Size modes: 16x16, 16x32, 32x16, 32x32');
console.log('Characters composed of multiple sprite entries');
console.log('Sprite data assembled at runtime by CPU from animation tables');
console.log('');
console.log('To get EXACT sprite compositions, we need to either:');
console.log('1. Run a 6809 emulator on the ROM code to capture sprite RAM state');
console.log('2. Use a MAME save-state to dump sprite RAM during gameplay');
console.log('3. Build a minimal CPU emulator for the sprite rendering path');
