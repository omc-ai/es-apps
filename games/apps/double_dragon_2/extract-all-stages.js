#!/usr/bin/env node
/**
 * Extract ALL stage data from DD2 ROMs:
 * - BG tilemaps for each stage
 * - Palette data for each stage
 * - Enemy spawn tables
 * - Animation sequences
 * - Stage flow/transitions
 *
 * Output: JSON files that the Phaser game engine can use directly.
 */

const fs = require('fs');
const path = require('path');

const mainRom = fs.readFileSync('26a9-04.bin');
const bankRom = fs.readFileSync('26aa-03.bin');  // Bank 0
const bank2 = fs.readFileSync('26ab-0.bin');     // Bank 1
const bank3 = fs.readFileSync('26ac-02.bin');    // Bank 2

function mb(a) { return a >= 0x8000 ? mainRom[a - 0x8000] : 0; }
function mw(a) { return (mb(a) << 8) | mb(a + 1); }

const OUT = 'dd2-phaser/data';
fs.mkdirSync(OUT, { recursive: true });

// ═══════════════════════════════════════
// 1. EXTRACT ALL PALETTES FROM ROM
// Palette data is in the banked ROMs
// xBGR_444 format, 16 colors per palette, 32 bytes per palette
// ═══════════════════════════════════════

function extractPalettes(rom, romName) {
  const palettes = [];
  // Search for blocks of 32 bytes that look like valid xBGR_444 palette data
  for (let i = 0; i < rom.length - 32; i += 2) {
    const colors = [];
    let valid = true;
    let nonZero = 0;
    for (let c = 0; c < 16; c++) {
      const lo = rom[i + c * 2];
      const hi = rom[i + c * 2 + 1];
      const w = (hi << 8) | lo;
      const r = (w & 0xF) * 17;
      const g = ((w >> 4) & 0xF) * 17;
      const b = ((w >> 8) & 0xF) * 17;
      colors.push([r, g, b]);
      if (w !== 0) nonZero++;
    }
    // First entry should be 0 (transparent) or close
    // Must have some non-zero colors
    const firstWord = (rom[i + 1] << 8) | rom[i];
    if (firstWord === 0 && nonZero >= 4 && nonZero <= 15) {
      // Additional check: colors should have reasonable spread
      const uniqueColors = new Set(colors.map(c => c.join(',')));
      if (uniqueColors.size >= 4) {
        palettes.push({
          offset: i,
          romName,
          colors,
        });
        i += 30; // skip past this palette
      }
    }
  }
  return palettes;
}

console.log('Extracting palettes...');
const allPalettes = [
  ...extractPalettes(bankRom, 'bank0'),
  ...extractPalettes(bank2, 'bank1'),
  ...extractPalettes(bank3, 'bank2'),
  ...extractPalettes(mainRom, 'main'),
];
console.log(`Found ${allPalettes.length} palettes total`);

// ═══════════════════════════════════════
// 2. EXTRACT BG TILEMAPS FROM BANKS
// Each stage loads a 32x32 tilemap (2048 bytes) into BG RAM ($3000-$37FF)
// The tilemap data is stored in the banked ROMs
// ═══════════════════════════════════════

function extractTilemaps(rom, romName) {
  const tilemaps = [];
  // Look for 2048-byte blocks of valid BG tile entries
  // Each entry = 2 bytes: [attr, tile_lo]
  // attr: bits0-2=tile_hi, bits3-5=color, bit6=flipX, bit7=flipY

  for (let start = 0; start < rom.length - 2048; start += 2) {
    let validEntries = 0;
    let nonEmpty = 0;
    const uniqueTiles = new Set();

    for (let j = 0; j < 512; j++) { // 512 entries = 32x32 / 2 (checking half)
      const off = start + j * 2;
      const attr = rom[off];
      const tileLo = rom[off + 1];
      const tile = tileLo | ((attr & 7) << 8);
      const color = (attr >> 3) & 7;

      if (tile < 2048 && color < 8) {
        validEntries++;
        if (tile > 0) { nonEmpty++; uniqueTiles.add(tile); }
      }
    }

    // A real tilemap has mostly valid entries with some variety
    if (validEntries >= 400 && nonEmpty >= 50 && uniqueTiles.size >= 10) {
      // Read the full 1024-entry tilemap
      const entries = [];
      for (let j = 0; j < 1024; j++) {
        const off = start + j * 2;
        if (off + 1 >= rom.length) break;
        const attr = rom[off];
        const tileLo = rom[off + 1];
        entries.push({
          tile: tileLo | ((attr & 7) << 8),
          color: (attr >> 3) & 7,
          flipX: !!(attr & 0x40),
          flipY: !!(attr & 0x80),
        });
      }

      tilemaps.push({
        offset: start,
        romName,
        nonEmpty,
        uniqueTiles: uniqueTiles.size,
        entries,
      });

      start += 2046; // skip past this tilemap
    }
  }
  return tilemaps;
}

console.log('\nExtracting tilemaps...');
const allTilemaps = [
  ...extractTilemaps(bank2, 'bank1'),   // Bank 1 had clean tilemaps
  ...extractTilemaps(bankRom, 'bank0'),
  ...extractTilemaps(bank3, 'bank2'),
];
console.log(`Found ${allTilemaps.length} tilemaps total`);
for (const tm of allTilemaps.slice(0, 10)) {
  console.log(`  ${tm.romName} offset $${tm.offset.toString(16)}: ${tm.nonEmpty} tiles, ${tm.uniqueTiles} unique`);
}

// ═══════════════════════════════════════
// 3. EXTRACT ENEMY SPAWN TABLES
// Format: 2-byte entries [scroll_trigger(hi), enemy_config(lo)]
// Located at $F7AA and nearby in main ROM
// ═══════════════════════════════════════

console.log('\nExtracting enemy spawn tables...');

// The main spawn table at $F7AA has 32 entries
const spawnTable = [];
for (let i = 0; i < 64; i++) {
  const val = mw(0xF7AA + i * 2);
  if (val === 0xFFFF || val === 0) break;
  spawnTable.push({
    scrollTrigger: (val >> 8) & 0xFF,
    enemyConfig: val & 0xFF,
    raw: val,
  });
}
console.log(`  Main spawn table: ${spawnTable.length} entries`);

// Also extract from other known locations
const spawnLocations = [0xD909, 0xA94C, 0xAABD, 0x8FDC];
const additionalSpawns = {};
for (const loc of spawnLocations) {
  const entries = [];
  for (let i = 0; i < 20; i++) {
    const val = mw(loc + i * 2);
    if (val === 0 || val === 0xFFFF) break;
    entries.push(val);
  }
  if (entries.length >= 3) {
    additionalSpawns['$' + loc.toString(16)] = entries;
    console.log(`  Spawn table at $${loc.toString(16)}: ${entries.length} entries`);
  }
}

// ═══════════════════════════════════════
// 4. EXTRACT ANIMATION DATA
// 3-byte entries at $DC3A: [tile_select, vel_x, vel_y]
// Multiple sequences for different animation states
// ═══════════════════════════════════════

console.log('\nExtracting animation data...');
const animations = [];
let animAddr = 0xDC3A;
while (animAddr < 0xDE00) {
  const sequence = [];
  for (let f = 0; f < 30; f++) {
    const ctrl = mb(animAddr + f * 3);
    const vx = mb(animAddr + f * 3 + 1);
    const vy = mb(animAddr + f * 3 + 2);
    sequence.push({
      tileSelect: ctrl,
      velX: vx > 127 ? vx - 256 : vx,
      velY: vy > 127 ? vy - 256 : vy,
      isBlank: ctrl === 0x7F,
    });
    // Detect sequence boundaries (pattern of blanks followed by non-blanks)
  }
  animations.push({
    address: animAddr,
    frames: sequence.slice(0, 10), // first 10 frames
  });
  animAddr += 30; // rough advancement
}
console.log(`  ${animations.length} animation sequences extracted`);

// ═══════════════════════════════════════
// 5. EXTRACT CHARACTER TYPE DATA
// 22 character types from table at $9640
// Each entry = pointer to behavior code
// ═══════════════════════════════════════

console.log('\nExtracting character types...');
const charTypes = [];
for (let i = 0; i < 22; i++) {
  const ptr = mw(0x9640 + i * 2);
  charTypes.push({
    index: i,
    handler: '$' + ptr.toString(16),
    name: i === 0 ? 'player_idle' : i === 1 ? 'player_walk' : i === 2 ? 'player_attack' :
          i <= 5 ? 'enemy_type_' + (i - 3) : 'enemy_type_' + (i - 3),
  });
}

// ═══════════════════════════════════════
// 6. STAGE HANDLER TABLE
// 4 stages at $8B40
// ═══════════════════════════════════════

const stages = [];
for (let i = 0; i < 4; i++) {
  stages.push({
    stage: i + 1,
    handler: '$' + mw(0x8B40 + i * 2).toString(16),
    subHandler: '$' + mw(0x8BFE + i * 2).toString(16),
    name: ['Helipad', 'Factory', 'Forest', 'Final Lair'][i],
  });
}

// ═══════════════════════════════════════
// SAVE ALL DATA
// ═══════════════════════════════════════

const gameData = {
  stages,
  charTypes,
  spawnTable,
  additionalSpawns,
  animations: animations.slice(0, 20),
  paletteCount: allPalettes.length,
  palettes: allPalettes.slice(0, 80), // first 80 palettes
  tilemapCount: allTilemaps.length,
  tilemaps: allTilemaps.map(tm => ({
    romName: tm.romName,
    offset: '$' + tm.offset.toString(16),
    nonEmpty: tm.nonEmpty,
    uniqueTiles: tm.uniqueTiles,
    // Include first 100 entries as sample
    sampleEntries: tm.entries.filter(e => e.tile > 0).slice(0, 100),
  })),
};

fs.writeFileSync(path.join(OUT, 'rom-game-data.json'), JSON.stringify(gameData, null, 2));
console.log('\nSaved rom-game-data.json');

// Also save full tilemaps separately (they're large)
for (let i = 0; i < Math.min(allTilemaps.length, 10); i++) {
  const tm = allTilemaps[i];
  fs.writeFileSync(
    path.join(OUT, `tilemap_${tm.romName}_${tm.offset.toString(16)}.json`),
    JSON.stringify(tm.entries)
  );
}
console.log(`Saved ${Math.min(allTilemaps.length, 10)} full tilemap files`);

// Save all palettes
fs.writeFileSync(path.join(OUT, 'all-palettes.json'), JSON.stringify(allPalettes, null, 2));
console.log(`Saved all-palettes.json (${allPalettes.length} palettes)`);

console.log('\n=== EXTRACTION COMPLETE ===');
console.log('Output directory: ' + OUT);
