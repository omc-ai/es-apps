#!/usr/bin/env node
/**
 * DD2 Sprite Rendering Emulator
 *
 * Instead of guessing tile compositions, we emulate the actual
 * 6809 CPU code that writes sprite attributes to sprite RAM.
 *
 * From the disassembly, the sprite rendering chain is:
 *
 * 1. Main loop calls $FEB6 -> JMP $4458 (banked) for each entity
 * 2. $4458 dispatches through character type table at $C7D4/$C822
 * 3. For player type: calls $C80F which reads entity type (offset 23 bits 0-4)
 *    and dispatches through $C822 table to banked ROM functions
 * 4. Banked function at $4467 writes sprite entries to sprite buffer
 *
 * The sprite composition data is stored as tables in the banked ROM.
 * Each character frame references a list of [tile, x_offset, y_offset, attributes]
 * that compose the full character sprite.
 *
 * We'll parse the banked ROM data tables directly using the format
 * discovered in the disassembly.
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'output');

function loadROM(name) {
  return new Uint8Array(fs.readFileSync(path.join(ROM_DIR, name)));
}

// Load ROMs
const mainRom = loadROM('26a9-04.bin');  // $8000-$FFFF
const bankRom = loadROM('26aa-03.bin');  // maps to $4000-$7FFF

function mainByte(addr) {
  if (addr >= 0x8000 && addr <= 0xFFFF) return mainRom[addr - 0x8000];
  return 0;
}
function mainWord(addr) {
  return (mainByte(addr) << 8) | mainByte(addr + 1);
}
function bankByte(addr) {
  // Bank ROM is 32KB. When mapped at $4000:
  // addr $4000 = bankRom[0], etc.
  if (addr >= 0x4000 && addr <= 0xBFFF) return bankRom[addr - 0x4000];
  return 0;
}
function bankWord(addr) {
  return (bankByte(addr) << 8) | bankByte(addr + 1);
}

// ═══════════════════════════════════════
// 1. Extract character type dispatch table at $C7D4
//    This tells us which rendering function each character type uses
// ═══════════════════════════════════════
console.log('=== Character Type Rendering Table ($C7D4) ===');
const charTypeTable = [];
for (let i = 0; i < 29; i++) {
  const ptr = mainWord(0xC7D4 + i * 2);
  charTypeTable.push(ptr);
}
console.log('  Entries:', charTypeTable.map(p => '$' + p.toString(16).toUpperCase()).join(', '));

// ═══════════════════════════════════════
// 2. Extract the sprite draw dispatch table at $C822
//    Maps entity types to banked sprite-drawing functions
// ═══════════════════════════════════════
console.log('\n=== Sprite Draw Table ($C822) ===');
const spriteDrawTable = [];
for (let i = 0; i < 20; i++) {
  const ptr = mainWord(0xC822 + i * 2);
  spriteDrawTable.push(ptr);
  console.log(`  Type ${i}: $${ptr.toString(16).toUpperCase()}`);
}

// ═══════════════════════════════════════
// 3. Extract animation state tables
//    $C8D0 = 20 player state init handlers
//    $C9EC, $CBEE, $CCFE = enemy state handlers
// ═══════════════════════════════════════
console.log('\n=== Player Animation State Handlers ($C8D0) ===');
const playerStateHandlers = [];
for (let i = 0; i < 20; i++) {
  const ptr = mainWord(0xC8D0 + i * 2);
  playerStateHandlers.push(ptr);
  console.log(`  State ${i}: $${ptr.toString(16).toUpperCase()}`);
}

// ═══════════════════════════════════════
// 4. Extract the animation frame pointer table at $9156
//    64 entries, each pointing to a 12-byte animation parameter record
// ═══════════════════════════════════════
console.log('\n=== Animation Frame Table ($9156) ===');
const animFrameTable = [];
for (let i = 0; i < 64; i++) {
  const ptr = mainWord(0x9156 + i * 2);
  animFrameTable.push(ptr);
}
// Show unique targets
const uniqueTargets = [...new Set(animFrameTable)];
console.log(`  64 entries, ${uniqueTargets.length} unique targets`);
for (const t of uniqueTargets.slice(0, 10)) {
  // Read 12-byte record at target
  const record = [];
  for (let b = 0; b < 12; b++) record.push(mainByte(t + b));
  console.log(`  $${t.toString(16).toUpperCase()}: [${record.map(b => b.toString(16).padStart(2,'0')).join(' ')}]`);
}

// ═══════════════════════════════════════
// 5. Extract the SECOND animation frame table at $91D6
// ═══════════════════════════════════════
console.log('\n=== Animation Frame Table 2 ($91D6) ===');
const animFrameTable2 = [];
for (let i = 0; i < 64; i++) {
  const ptr = mainWord(0x91D6 + i * 2);
  animFrameTable2.push(ptr);
}
const uniqueTargets2 = [...new Set(animFrameTable2)];
console.log(`  64 entries, ${uniqueTargets2.length} unique targets`);

// ═══════════════════════════════════════
// 6. The key: Extract sprite composition data from the banked ROM
//
// The code at $4467 uses tables starting from addresses in $44EB.
// $44EB contains 4 word pointers:
// ═══════════════════════════════════════
console.log('\n=== Sprite Base Addresses ($44EB) ===');
const spriteBases = [];
for (let i = 0; i < 4; i++) {
  const ptr = bankWord(0x44EB + i * 2);
  spriteBases.push(ptr);
  console.log(`  Group ${i}: $${ptr.toString(16).toUpperCase()}`);
}

// ═══════════════════════════════════════
// 7. Now scan the banked ROM for sprite composition data
//
// The rendering code at $4467 works like this:
//   - <$02> bits 0-1 selects group (index into $44EB)
//   - <$03> = set index (multiplied by 16 to get offset)
//   - <$04> = sprite index within set
//   - Base + set*16 + spriteIndex = pointer to tile data
//
// But for multi-sprite mode (bit 7 of <$02> set):
//   - Uses sprite buffer at $0C9D
//   - Reads a sequence of tile entries until terminator
//
// Let me scan the banked ROM for the actual sprite data layout.
// The data region in the banked ROM (after the code section) contains
// the tile composition tables.
// ═══════════════════════════════════════

// Let's find where code ends and data begins in the banked ROM
// by looking for long runs of structured data (not random code)
console.log('\n=== Scanning banked ROM for sprite data regions ===');

// The banked ROM is loaded at offset $4000-$7FFF in address space
// but it's actually $4000-$BFFF (32KB)
// Let me scan for patterns that look like sprite composition tables

// In DD2, multi-sprite characters are composed of entries like:
// [y_offset, tile_hi, tile_lo, x_offset] repeated, terminated by $80 or $00
// OR the format found by the agent: [H, L] pairs where tile = (H<<4)|(L>>4)

// Let me search for the actual sprite table format by looking at what
// the $4467 code reads from the entity structure
//
// From $44A1: LDD ,X++ reads 2 bytes from entity offset
// This gives tile_hi, tile_lo -> shifted to hardware format
//
// But the MULTI-sprite path at $44B3 is different:
// It reads from U (which points to sprite base + set*16 + sprite_idx)
// Let me trace $44B3 in the disassembly

// Let me read the code at bankRom offset for $44B3
console.log('\n=== Multi-sprite code at $44B3 ===');
const multiSpriteStart = 0x44B3 - 0x4000;
const codeBytes = [];
for (let i = 0; i < 80; i++) {
  codeBytes.push(bankRom[multiSpriteStart + i]);
}
console.log('  Hex:', codeBytes.map(b => b.toString(16).padStart(2, '0')).join(' '));

// ═══════════════════════════════════════
// 8. Let me try a different approach: scan the banked ROM for
//    sprite attribute data patterns.
//
// DD2 sprite RAM format (from MAME video/ddragon.cpp):
//   offset 0: attribute byte (flip, color)
//   offset 1: tile number low
//   offset 2: Y position
//   offset 3: tile number high + X position high bit
//   offset 4: X position low
//
// The CPU writes this data. The source data in ROM will contain
// the tile numbers and relative offsets that get transformed
// into these sprite RAM entries.
//
// Let me search for sequences of valid tile numbers (0-6143)
// that are arranged in grid patterns suggesting character frames.
// ═══════════════════════════════════════

console.log('\n=== Scanning for sprite tile data in banked ROM ===');

// Look for sequences of bytes where pairs encode tile numbers in 0-6143 range
// Using the encoding: tile = (byte1 << 4) | (byte0 >> 4) where byte0 also has flags

function scanForTileSequences(rom, baseAddr) {
  const sequences = [];

  for (let offset = 0; offset < rom.length - 20; offset++) {
    // Try interpreting as a list of 5-byte sprite entries:
    // [y_off, x_off, tile_lo, tile_hi, attr]
    // Common in Technos games

    let validEntries = 0;
    const entries = [];

    for (let e = 0; e < 16; e++) {
      const o = offset + e * 5;
      if (o + 4 >= rom.length) break;

      const yOff = rom[o];     // could be signed
      const xOff = rom[o + 1]; // could be signed
      const tileLo = rom[o + 2];
      const tileHi = rom[o + 3];
      const attr = rom[o + 4];

      const tile = (tileHi << 8) | tileLo;

      // Valid sprite: tile in range, offsets reasonable, attr has valid bits
      if (tile < 6144 && tile > 0 &&
          yOff !== 0xFF && xOff !== 0xFF &&
          (attr & 0xF0) !== 0xF0) {
        const yS = yOff > 127 ? yOff - 256 : yOff;
        const xS = xOff > 127 ? xOff - 256 : xOff;
        if (Math.abs(yS) < 64 && Math.abs(xS) < 48) {
          validEntries++;
          entries.push({ tile, x: xS, y: yS, attr, flipX: !!(attr & 0x40), flipY: !!(attr & 0x80), palette: attr & 0x0F });
        } else break;
      } else break;
    }

    if (validEntries >= 4) {
      sequences.push({
        address: baseAddr + offset,
        count: validEntries,
        entries: entries,
      });
      offset += validEntries * 5 - 1; // skip past this sequence
    }
  }

  return sequences;
}

// Also try 4-byte entries: [tile_lo, tile_hi, y_off, x_off]
function scanFormat2(rom, baseAddr) {
  const sequences = [];

  for (let offset = 0; offset < rom.length - 16; offset++) {
    let validEntries = 0;
    const entries = [];

    for (let e = 0; e < 20; e++) {
      const o = offset + e * 4;
      if (o + 3 >= rom.length) break;

      const b0 = rom[o], b1 = rom[o+1], b2 = rom[o+2], b3 = rom[o+3];

      // Try: [y_off, attr|tile_hi, tile_lo, x_off]
      const yOff = b0 > 127 ? b0 - 256 : b0;
      const xOff = b3 > 127 ? b3 - 256 : b3;
      const tile = ((b1 & 0x0F) << 8) | b2;
      const attr = (b1 >> 4) & 0x0F;

      if (tile > 0 && tile < 6144 && Math.abs(yOff) < 64 && Math.abs(xOff) < 48) {
        validEntries++;
        entries.push({ tile, x: xOff, y: yOff, attr, flipX: !!(attr & 4), palette: attr & 3 });
      } else break;
    }

    if (validEntries >= 4) {
      sequences.push({ address: baseAddr + offset, count: validEntries, entries });
      offset += validEntries * 4 - 1;
    }
  }
  return sequences;
}

// Also try the format from the DD video hardware (from MAME ddragon video code):
// Sprite RAM entry is:
//   word 0: attr (flip, size, color)
//   word 1: tile code
//   word 2: y position
//   word 3: x position
// = 8 bytes per sprite
// The composition tables in ROM would list relative entries

function scanFormat3(rom, baseAddr) {
  const sequences = [];

  for (let offset = 0; offset < rom.length - 24; offset++) {
    let validEntries = 0;
    const entries = [];

    for (let e = 0; e < 16; e++) {
      const o = offset + e * 4;
      if (o + 3 >= rom.length) break;

      // Try: [tile_lo, tile_hi_and_attr, y_rel, x_rel]
      const tileLo = rom[o];
      const tileHiAttr = rom[o + 1];
      const yRel = rom[o + 2] > 127 ? rom[o + 2] - 256 : rom[o + 2];
      const xRel = rom[o + 3] > 127 ? rom[o + 3] - 256 : rom[o + 3];

      const tile = ((tileHiAttr & 0x1F) << 8) | tileLo;

      if (tile > 0 && tile < 6144 && Math.abs(yRel) < 64 && Math.abs(xRel) < 64) {
        validEntries++;
        entries.push({
          tile, x: xRel, y: yRel,
          flipX: !!(tileHiAttr & 0x40),
          flipY: !!(tileHiAttr & 0x80),
          palette: (tileHiAttr >> 5) & 0x03,
        });
      } else break;
    }

    if (validEntries >= 4) {
      sequences.push({ address: baseAddr + offset, count: validEntries, entries });
      offset += validEntries * 4 - 1;
    }
  }
  return sequences;
}

const seq5byte = scanForTileSequences(bankRom, 0x4000);
console.log(`  5-byte format: ${seq5byte.length} sequences found`);
for (const s of seq5byte.slice(0, 5)) {
  console.log(`    $${s.address.toString(16)}: ${s.count} sprites - tiles: ${s.entries.map(e => e.tile).join(',')}`);
}

const seq4byteA = scanFormat2(bankRom, 0x4000);
console.log(`  4-byte format A: ${seq4byteA.length} sequences found`);
for (const s of seq4byteA.slice(0, 5)) {
  console.log(`    $${s.address.toString(16)}: ${s.count} sprites - tiles: ${s.entries.map(e => e.tile).join(',')}`);
  if (s.entries.length > 0) {
    console.log(`      positions: ${s.entries.map(e => `(${e.x},${e.y})`).join(' ')}`);
  }
}

const seq4byteB = scanFormat3(bankRom, 0x4000);
console.log(`  4-byte format B: ${seq4byteB.length} sequences found`);
for (const s of seq4byteB.slice(0, 5)) {
  console.log(`    $${s.address.toString(16)}: ${s.count} sprites - tiles: ${s.entries.map(e => e.tile).join(',')}`);
  if (s.entries.length > 0) {
    console.log(`      positions: ${s.entries.map(e => `(${e.x},${e.y})`).join(' ')}`);
  }
}

// Also scan main ROM
const mSeq5 = scanForTileSequences(mainRom, 0x8000);
console.log(`\nMain ROM 5-byte: ${mSeq5.length} sequences`);
const mSeq4A = scanFormat2(mainRom, 0x8000);
console.log(`Main ROM 4-byte A: ${mSeq4A.length} sequences`);
const mSeq4B = scanFormat3(mainRom, 0x8000);
console.log(`Main ROM 4-byte B: ${mSeq4B.length} sequences`);
for (const s of mSeq4B.slice(0, 10)) {
  console.log(`  $${s.address.toString(16)}: ${s.count} sprites - tiles: ${s.entries.map(e => e.tile).join(',')}`);
  console.log(`    positions: ${s.entries.map(e => `(${e.x},${e.y})`).join(' ')}`);
}

// Save all found sequences
const output = {
  characterTypeTable: charTypeTable.map(p => '$' + p.toString(16)),
  spriteDrawTable: spriteDrawTable.map(p => '$' + p.toString(16)),
  playerStateHandlers: playerStateHandlers.map(p => '$' + p.toString(16)),
  spriteBases: spriteBases.map(p => '$' + p.toString(16)),
  spriteSequences: {
    bankRom_5byte: seq5byte,
    bankRom_4byteA: seq4byteA,
    bankRom_4byteB: seq4byteB,
    mainRom_5byte: mSeq5,
    mainRom_4byteA: mSeq4A,
    mainRom_4byteB: mSeq4B,
  },
};

fs.writeFileSync(path.join(OUT_DIR, 'sprite-tables.json'), JSON.stringify(output, null, 2));
console.log('\nSaved sprite-tables.json');
