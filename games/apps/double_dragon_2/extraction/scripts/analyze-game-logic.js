#!/usr/bin/env node
/**
 * Double Dragon 2 - Game Logic Analyzer
 * Reads the disassembled output and maps game data structures
 * to modern structured data (JSON/TypeScript).
 *
 * Based on the disassembly of:
 * - 26a9-04.bin (main CPU, $8000-$FFFF)
 * - 26aa-03.bin (banked ROM, mapped to $4000-$7FFF)
 *
 * DD2 Hardware Memory Map:
 * $0000-$0FFF: RAM (work RAM, entity data, variables)
 * $1000-$17FF: Sprite RAM
 * $1800-$1FFF: Palette RAM
 * $2000-$27FF: Background tilemap
 * $2800-$2FFF: Foreground tilemap
 * $3000-$37FF: Character/text tilemap
 * $3800-$3FFF: I/O registers
 * $4000-$7FFF: Banked ROM window
 * $8000-$FFFF: Fixed ROM
 */

const fs = require('fs');
const path = require('path');

const ROM_DIR = __dirname;
const OUT_DIR = path.join(__dirname, 'output');

// Load raw ROM data
const mainRom = new Uint8Array(fs.readFileSync(path.join(ROM_DIR, '26a9-04.bin')));
const bankRom = new Uint8Array(fs.readFileSync(path.join(ROM_DIR, '26aa-03.bin')));

// Helper: read byte from ROM address space
function readByte(addr) {
  if (addr >= 0x8000 && addr <= 0xFFFF) {
    return mainRom[addr - 0x8000];
  }
  if (addr >= 0x4000 && addr <= 0x7FFF) {
    // Banked ROM - offset from start of 26aa-03.bin
    // The bank select mechanism maps different 16K pages
    // For now, use the first bank (offset 0)
    return bankRom[addr - 0x4000];
  }
  return 0;
}

function readWord(addr) {
  return (readByte(addr) << 8) | readByte(addr + 1);
}

function readSignedByte(addr) {
  const v = readByte(addr);
  return v > 127 ? v - 256 : v;
}

// ============================================================
// 1. ENTITY STRUCT ANALYSIS
// From the disassembly, entity fields accessed via X register:
// ============================================================
const entityStruct = {
  description: "DD2 Entity/Character structure (approx 40 bytes per entity)",
  fields: {
    0:  { name: "state", size: 1, desc: "Entity state machine index (lower nibble used as dispatch)" },
    1:  { name: "type", size: 1, desc: "Entity type: 0=inactive, 1=player1, 2=player2, 3+=enemies" },
    2:  { name: "substate", size: 1, desc: "Sub-state or animation phase" },
    3:  { name: "flags", size: 1, desc: "General flags" },
    4:  { name: "x_hi", size: 1, desc: "X position high byte (world coords)" },
    5:  { name: "x_lo", size: 1, desc: "X position low byte" },
    6:  { name: "y_hi", size: 1, desc: "Y position high byte (vertical/depth)" },
    7:  { name: "y_lo", size: 1, desc: "Y position low byte" },
    8:  { name: "z_hi", size: 1, desc: "Z position high byte (jump height)" },
    9:  { name: "z_lo", size: 1, desc: "Z position low byte" },
    10: { name: "x_frac", size: 1, desc: "X sub-pixel fraction" },
    11: { name: "y_frac", size: 1, desc: "Y sub-pixel fraction" },
    12: { name: "z_frac", size: 1, desc: "Z sub-pixel fraction" },
    13: { name: "speed_angle", size: 1, desc: "Movement speed/direction angle" },
    14: { name: "speed_mag", size: 1, desc: "Movement speed magnitude" },
    15: { name: "vel_x", size: 2, desc: "X velocity (16-bit signed, high:low)" },
    17: { name: "vel_y", size: 2, desc: "Y velocity (16-bit signed)" },
    19: { name: "vel_z", size: 1, desc: "Z velocity (for jumps)" },
    20: { name: "anim_flags", size: 1, desc: "Animation flags (bit7=something)" },
    21: { name: "status_flags", size: 1, desc: "Status flags (bit6=movement lock)" },
    22: { name: "sprite_tile", size: 1, desc: "Current sprite tile index" },
    23: { name: "sprite_attr", size: 1, desc: "Sprite attributes (lower nibble=palette, etc)" },
    24: { name: "timer1", size: 1, desc: "General purpose timer 1" },
    25: { name: "timer2", size: 1, desc: "General purpose timer 2" },
    26: { name: "hp", size: 1, desc: "Hit points" },
    27: { name: "invincibility", size: 1, desc: "Invincibility/hit-stun timer (bit7=active)" },
    28: { name: "attack_type", size: 1, desc: "Current attack type" },
    29: { name: "combo_counter", size: 1, desc: "Combo hit counter" },
    30: { name: "ai_state", size: 1, desc: "AI behavior state" },
    31: { name: "ai_timer", size: 1, desc: "AI action timer" },
    32: { name: "facing", size: 1, desc: "Facing direction (0=right, nonzero=left)" },
    33: { name: "gravity", size: 1, desc: "Gravity applied flag" },
    34: { name: "ground_y", size: 1, desc: "Ground Y level for this entity" },
    35: { name: "hitbox_id", size: 1, desc: "Active hitbox ID" },
    36: { name: "target_id", size: 1, desc: "AI target entity index" },
    37: { name: "attack_range", size: 1, desc: "Attack range value (compared at $A7D3)" },
  }
};

// ============================================================
// 2. JUMP TABLE / DISPATCH TABLE ANALYSIS
// The banked ROM starts with a jump table at $4000
// Main entry points for banked code
// ============================================================
console.log('=== Jump Table at $4000 (banked ROM) ===');
const jumpTable = [];
for (let i = 0; i < 10; i++) {
  const addr = 0x4000 + i * 3;
  // Each entry is JMP $xxxx (7E xx xx)
  const opcode = bankRom[i * 3];
  const target = (bankRom[i * 3 + 1] << 8) | bankRom[i * 3 + 2];
  if (opcode === 0x7E) {
    jumpTable.push({ index: i, address: addr, target: target });
    console.log(`  Entry ${i}: JMP $${target.toString(16).toUpperCase()}`);
  }
}

// ============================================================
// 3. STATE DISPATCH TABLE at $4034
// Used by the code at $10022 (JSR [A,Y] with Y=$4034)
// This is the main entity state machine dispatcher
// ============================================================
console.log('\n=== Entity State Dispatch Table at $4034 ===');
const stateDispatch = [];
const dispatchBase = 0x4034 - 0x4000; // offset in bankRom
for (let i = 0; i < 8; i++) {
  const ptr = (bankRom[dispatchBase + i*2] << 8) | bankRom[dispatchBase + i*2 + 1];
  stateDispatch.push({ state: i, handler: ptr });
  console.log(`  State ${i}: -> $${ptr.toString(16).toUpperCase()}`);
}

// ============================================================
// 4. SCAN FOR POINTER TABLES in main ROM
// These reveal the locations of all major data structures
// ============================================================
console.log('\n=== Pointer Table Scan (main ROM $8000-$FFFF) ===');

function scanForPointerTables(rom, baseAddr, minLen = 4) {
  const tables = [];
  for (let i = 0; i < rom.length - minLen * 2; i++) {
    let isTable = true;
    let entries = [];
    for (let j = 0; j < 16; j++) { // try up to 16 entries
      const ptr = (rom[i + j*2] << 8) | rom[i + j*2 + 1];
      // Valid pointer range for DD2: $8000-$FFFF (main ROM) or $4000-$7FFF (banked)
      if ((ptr >= 0x8000 && ptr <= 0xFFF0) || (ptr >= 0x4000 && ptr <= 0x7FFF)) {
        entries.push(ptr);
      } else {
        break;
      }
    }
    if (entries.length >= minLen) {
      // Check it's not overlapping with a previous table
      const addr = baseAddr + i;
      if (tables.length === 0 || addr >= tables[tables.length-1].address + tables[tables.length-1].entries.length * 2) {
        tables.push({ address: addr, entries: entries });
      }
    }
  }
  return tables;
}

const ptrTables = scanForPointerTables(mainRom, 0x8000, 4);
console.log(`Found ${ptrTables.length} potential pointer tables:`);
for (const t of ptrTables.slice(0, 30)) {
  const entriesStr = t.entries.map(e => '$' + e.toString(16).toUpperCase()).join(', ');
  console.log(`  $${t.address.toString(16).toUpperCase()} (${t.entries.length} entries): ${entriesStr}`);
}

// ============================================================
// 5. SCAN FOR DATA TABLES (repeating patterns)
// Animation data, level data, hitbox data
// ============================================================
console.log('\n=== Scanning for Animation/Sprite Data Tables ===');

// Animation tables typically look like: [tile_index, duration, flags] repeated
// Or pointer-to-frame-list tables
// Look for sequences of bytes where every Nth byte has similar range

function findAnimationTables(rom, baseAddr) {
  const tables = [];

  for (let i = 0; i < rom.length - 32; i++) {
    // Pattern: groups of 4 bytes where byte 0 is a sprite tile (0-255)
    // byte 1 could be duration (1-60), byte 2-3 could be offsets
    let validFrames = 0;
    for (let f = 0; f < 16; f++) {
      const off = i + f * 4;
      if (off + 3 >= rom.length) break;
      const tile = rom[off];
      const dur = rom[off + 1];
      // Reasonable: tile 0-255, duration 1-30, offsets small signed
      if (tile > 0 && tile < 200 && dur >= 1 && dur <= 30) {
        validFrames++;
      } else {
        break;
      }
    }
    if (validFrames >= 4) {
      const addr = baseAddr + i;
      if (tables.length === 0 || addr >= tables[tables.length-1].address + tables[tables.length-1].frameCount * 4) {
        const frames = [];
        for (let f = 0; f < validFrames; f++) {
          const off = i + f * 4;
          frames.push({
            tile: rom[off],
            duration: rom[off+1],
            offsetX: rom[off+2] > 127 ? rom[off+2] - 256 : rom[off+2],
            offsetY: rom[off+3] > 127 ? rom[off+3] - 256 : rom[off+3],
          });
        }
        tables.push({ address: addr, frameCount: validFrames, frames: frames });
      }
    }
  }
  return tables;
}

const animTables = findAnimationTables(mainRom, 0x8000);
console.log(`Found ${animTables.length} potential animation tables:`);
for (const t of animTables.slice(0, 20)) {
  console.log(`  $${t.address.toString(16).toUpperCase()} (${t.frameCount} frames):`);
  for (const f of t.frames.slice(0, 6)) {
    console.log(`    tile=${f.tile}, dur=${f.duration}, offset=(${f.offsetX},${f.offsetY})`);
  }
  if (t.frames.length > 6) console.log(`    ... and ${t.frames.length - 6} more`);
}

// Same for banked ROM
const bankAnimTables = findAnimationTables(bankRom, 0x4000);
console.log(`\nBanked ROM: Found ${bankAnimTables.length} potential animation tables:`);
for (const t of bankAnimTables.slice(0, 20)) {
  console.log(`  $${t.address.toString(16).toUpperCase()} (${t.frameCount} frames):`);
  for (const f of t.frames.slice(0, 4)) {
    console.log(`    tile=${f.tile}, dur=${f.duration}, offset=(${f.offsetX},${f.offsetY})`);
  }
}

// ============================================================
// 6. PALETTE DATA EXTRACTION
// DD2 arcade uses palette RAM at $1800-$1FFF (2KB)
// Palettes are written by the CPU, so the data is in the ROM
// Format: each color is 2 bytes, xxxxBBBBGGGGRRRR (4 bits per component)
// Or it could be BBBBxxxxGGGGRRRR or other arrangement
// ============================================================
console.log('\n=== Palette Data Scan ===');

function findPaletteData(rom, baseAddr) {
  const palettes = [];

  for (let i = 0; i < rom.length - 32; i++) {
    // A palette is 16 colors × 2 bytes = 32 bytes
    // Check if 32 bytes look like color data:
    // - First color (index 0) is often $0000 (transparent/black)
    // - Values should have reasonable 4-bit component ranges
    let valid = true;
    const colors = [];

    for (let c = 0; c < 16; c++) {
      const hi = rom[i + c * 2];
      const lo = rom[i + c * 2 + 1];
      const word = (hi << 8) | lo;
      colors.push(word);
    }

    // Heuristic: first color is $0000 (common for transparent)
    // and at least 3 other colors are non-zero
    // and no byte exceeds reasonable range
    if (colors[0] === 0) {
      const nonZero = colors.filter(c => c !== 0).length;
      if (nonZero >= 3 && nonZero <= 15) {
        // Additional check: spread of values suggests color data
        const uniqueColors = new Set(colors).size;
        if (uniqueColors >= 4) {
          palettes.push({
            address: baseAddr + i,
            colors: colors,
          });
          i += 31; // skip past this palette
        }
      }
    }
  }
  return palettes;
}

const mainPalettes = findPaletteData(mainRom, 0x8000);
console.log(`Found ${mainPalettes.length} potential palettes in main ROM:`);
for (const p of mainPalettes.slice(0, 10)) {
  const colorStr = p.colors.map(c => '$' + c.toString(16).padStart(4, '0')).join(' ');
  console.log(`  $${p.address.toString(16).toUpperCase()}: ${colorStr}`);
  // Decode as 4-4-4 RGB
  const decoded = p.colors.map(c => {
    // Try xxxxRRRRGGGGBBBB
    const r = ((c >> 8) & 0xF) * 17;
    const g = ((c >> 4) & 0xF) * 17;
    const b = (c & 0xF) * 17;
    return `rgb(${r},${g},${b})`;
  });
  console.log(`    decoded: ${decoded.join(' ')}`);
}

const bankPalettes = findPaletteData(bankRom, 0x4000);
console.log(`\nFound ${bankPalettes.length} potential palettes in banked ROM:`);
for (const p of bankPalettes.slice(0, 10)) {
  const colorStr = p.colors.map(c => '$' + c.toString(16).padStart(4, '0')).join(' ');
  console.log(`  $${p.address.toString(16).toUpperCase()}: ${colorStr}`);
}

// ============================================================
// 7. SCAN FOR LEVEL/TILEMAP DATA
// Background tilemap writes go to $2000-$27FF and $2800-$2FFF
// Look for code that writes to these ranges
// ============================================================
console.log('\n=== Level/Tilemap Data References ===');

// Search for STA/STB/STD to tilemap RAM ($2000-$2FFF) in the main ROM disassembly
const asmLines = fs.readFileSync(path.join(OUT_DIR, 'main-cpu.asm'), 'utf8').split('\n');
const tilemapRefs = asmLines.filter(l =>
  (l.includes('$20') || l.includes('$28') || l.includes('$30')) &&
  (l.includes('STA') || l.includes('STB') || l.includes('STD'))
).slice(0, 20);
console.log('Tilemap write references:');
tilemapRefs.forEach(l => console.log('  ' + l.trim()));

// ============================================================
// 8. INPUT HANDLING
// DD2 reads joystick/buttons from I/O at $3800-$3807
// $3800 = P1 input, $3801 = P2 input, $3802 = system (coin/start)
// ============================================================
console.log('\n=== Input/IO Register References ===');
const ioRefs = asmLines.filter(l =>
  l.includes('$38') && (l.includes('LDA') || l.includes('LDB') || l.includes('BITA'))
).slice(0, 30);
console.log('I/O read references:');
ioRefs.forEach(l => console.log('  ' + l.trim()));

// ============================================================
// 9. ENEMY SPAWN DATA
// Look for tables of entity definitions near level data
// Typically: [x_position, y_position, enemy_type, flags]
// ============================================================
console.log('\n=== Enemy Spawn Data Scan ===');

function findSpawnTables(rom, baseAddr) {
  const tables = [];

  for (let i = 0; i < rom.length - 16; i++) {
    // Spawn format guess: [x_pos(2), y_pos(1), type(1)] repeated
    let validEntries = 0;
    for (let e = 0; e < 16; e++) {
      const off = i + e * 4;
      if (off + 3 >= rom.length) break;
      const xPos = (rom[off] << 8) | rom[off + 1];
      const yPos = rom[off + 2];
      const type = rom[off + 3];
      // X position: 0-2048 (level width), Y: 80-200, type: 1-20
      if (xPos >= 0x0020 && xPos <= 0x0800 && yPos >= 0x40 && yPos <= 0xD0 && type >= 1 && type <= 20) {
        validEntries++;
      } else {
        break;
      }
    }
    if (validEntries >= 3) {
      const addr = baseAddr + i;
      if (tables.length === 0 || addr > tables[tables.length-1].address + 8) {
        const entries = [];
        for (let e = 0; e < validEntries; e++) {
          const off = i + e * 4;
          entries.push({
            x: (rom[off] << 8) | rom[off+1],
            y: rom[off+2],
            type: rom[off+3],
          });
        }
        tables.push({ address: addr, count: validEntries, entries });
      }
    }
  }
  return tables;
}

const spawnTables = findSpawnTables(mainRom, 0x8000);
console.log(`Found ${spawnTables.length} potential spawn tables in main ROM:`);
for (const t of spawnTables.slice(0, 10)) {
  console.log(`  $${t.address.toString(16).toUpperCase()} (${t.count} entries):`);
  for (const e of t.entries) {
    console.log(`    x=${e.x}, y=${e.y}, type=${e.type}`);
  }
}

const bankSpawnTables = findSpawnTables(bankRom, 0x4000);
console.log(`\nFound ${bankSpawnTables.length} potential spawn tables in banked ROM:`);
for (const t of bankSpawnTables.slice(0, 10)) {
  console.log(`  $${t.address.toString(16).toUpperCase()} (${t.count} entries):`);
  for (const e of t.entries) {
    console.log(`    x=${e.x}, y=${e.y}, type=${e.type}`);
  }
}

// ============================================================
// 10. HITBOX DATA
// Look for tables of small signed values that define collision rectangles
// Format: [x1, y1, x2, y2] or [cx, cy, w, h]
// ============================================================
console.log('\n=== Hitbox Data Scan ===');

// Look at the data byte at $A7DC referenced by the attack range comparison
console.log('Attack range table at $A7DC:');
const rangeTableOff = 0xA7DC - 0x8000;
for (let i = 0; i < 20; i++) {
  console.log(`  [$A7${(0xDC + i).toString(16)}] = ${mainRom[rangeTableOff + i]}`);
}

// ============================================================
// 11. MAIN GAME LOOP ANALYSIS
// The main loop starts at $80A9
// ============================================================
console.log('\n=== Main Game Loop ($80A9) Flow ===');
// Read the game loop structure from disassembly
const loopStart = asmLines.findIndex(l => l.includes('L80A9:'));
if (loopStart >= 0) {
  console.log('Main loop code:');
  for (let i = loopStart; i < Math.min(loopStart + 80, asmLines.length); i++) {
    if (asmLines[i].trim()) console.log('  ' + asmLines[i].trim());
  }
}

// ============================================================
// 12. OUTPUT STRUCTURED DATA
// ============================================================
const gameData = {
  entityStruct,
  jumpTable,
  stateDispatch,
  pointerTables: ptrTables.map(t => ({
    address: '$' + t.address.toString(16).toUpperCase(),
    count: t.entries.length,
    entries: t.entries.map(e => '$' + e.toString(16).toUpperCase())
  })),
  animationTables: {
    mainRom: animTables.map(t => ({
      address: '$' + t.address.toString(16).toUpperCase(),
      frameCount: t.frameCount,
      frames: t.frames
    })),
    bankedRom: bankAnimTables.map(t => ({
      address: '$' + t.address.toString(16).toUpperCase(),
      frameCount: t.frameCount,
      frames: t.frames
    })),
  },
  palettes: {
    mainRom: mainPalettes.map(p => ({
      address: '$' + p.address.toString(16).toUpperCase(),
      colors: p.colors.map(c => '$' + c.toString(16).padStart(4, '0'))
    })),
    bankedRom: bankPalettes.map(p => ({
      address: '$' + p.address.toString(16).toUpperCase(),
      colors: p.colors.map(c => '$' + c.toString(16).padStart(4, '0'))
    })),
  },
  spawnTables: {
    mainRom: spawnTables,
    bankedRom: bankSpawnTables,
  },
  hardwareMap: {
    "$0000-$0FFF": "Work RAM (entity data, game variables)",
    "$1000-$17FF": "Sprite attribute RAM (256 sprites × 4 bytes: y, tile, attr, x)",
    "$1800-$1FFF": "Palette RAM (256 colors × 2 bytes)",
    "$2000-$27FF": "Background tilemap (32×32 tiles)",
    "$2800-$2FFF": "Foreground tilemap (32×32 tiles)",
    "$3000-$37FF": "Character/text tilemap (32×32 tiles)",
    "$3800": "P1 joystick input",
    "$3801": "P2 joystick input",
    "$3802": "System input (coin, start)",
    "$3803": "DIP switch A",
    "$3804": "DIP switch B",
    "$3808": "Bank select / scroll control",
    "$380B": "IRQ acknowledge",
    "$380C": "FIRQ acknowledge",
    "$380D": "NMI acknowledge",
    "$380E": "Sound latch write",
  },
  interruptVectors: {
    RESET: "$8000",
    NMI: "$8038",
    FIRQ: "$8081",
    IRQ: "$809F",
    SWI: "$80A8",
    SWI2: "$80A8",
    SWI3: "$80A8",
  },
  inputBits: {
    P1: {
      right: "bit 0",
      left: "bit 1",
      up: "bit 2",
      down: "bit 3",
      punch: "bit 4",
      kick: "bit 5",
      jump: "bit 6",
      start: "bit 7",
    }
  },
};

fs.writeFileSync(
  path.join(OUT_DIR, 'game-logic.json'),
  JSON.stringify(gameData, null, 2)
);

console.log('\n=== Output saved to output/game-logic.json ===');
console.log('Entity struct:', Object.keys(entityStruct.fields).length, 'fields');
console.log('Pointer tables:', ptrTables.length);
console.log('Animation tables (main):', animTables.length);
console.log('Animation tables (banked):', bankAnimTables.length);
console.log('Palettes (main):', mainPalettes.length);
console.log('Palettes (banked):', bankPalettes.length);
console.log('Spawn tables (main):', spawnTables.length);
console.log('Spawn tables (banked):', bankSpawnTables.length);
