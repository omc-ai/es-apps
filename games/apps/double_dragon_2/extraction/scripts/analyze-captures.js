#!/usr/bin/env node
/**
 * Analyze ALL MAME captures to extract complete game data:
 * - Every unique sprite composition (character animation frames)
 * - Every palette state
 * - Entity behavior across frames
 * - Stage tilemap data
 */

const fs = require('fs');
const path = require('path');

const CAPTURE_DIR = path.join(__dirname, 'mame-dumps/full-capture');
const OUT_DIR = path.join(__dirname, 'output');

// Parse a dump file (16KB: $0000-$3FFF)
function parseDump(filepath) {
  const data = fs.readFileSync(filepath);

  // Parse sprites from $2800-$2FFF
  const sprites = [];
  for (let i = 0x2800; i < 0x3000; i += 5) {
    const attr = data[i + 1];
    if (!(attr & 0x80)) continue;
    const y = data[i], b2 = data[i+2], b3 = data[i+3], x = data[i+4];
    const tile = b3 | ((b2 & 0x1F) << 8);
    const color = b2 >> 5;
    const size = (attr >> 4) & 3;
    const flipX = !!(attr & 8);
    const flipY = !!(attr & 4);
    const sx = 240 - x + ((attr & 2) << 7);
    const sy = 232 - y + ((attr & 1) << 8);
    sprites.push({ tile, color, size, sx, sy, flipX, flipY });
  }

  // Parse entities from $0300 (16 entities, 36 bytes each)
  const entities = [];
  for (let e = 0; e < 16; e++) {
    const base = 0x0300 + e * 0x24;
    const type = data[base + 1];
    if (type === 0) continue;
    entities.push({
      idx: e, type,
      state: data[base],
      tileSelect: data[base + 2],
      flags: data[base + 3],
      x: (data[base+4] << 8) | data[base+5],
      y: (data[base+6] << 8) | data[base+7],
      z: (data[base+8] << 8) | data[base+9],
      animState: data[base + 27],
      hp: data[base + 26],
    });
  }

  // Parse palette
  const palette = [];
  for (let i = 0; i < 512; i++) {
    const lo = data[0x3C00 + i], hi = data[0x3E00 + i];
    const w = (hi << 8) | lo;
    palette.push(w);
  }

  return { sprites, entities, palette, raw: data };
}

// Process all captures
const files = fs.readdirSync(CAPTURE_DIR)
  .filter(f => f.endsWith('.bin'))
  .sort();

console.log(`Processing ${files.length} capture files...`);

// Track unique sprite compositions per color (character)
const spriteComps = new Map(); // key = sorted tile list, value = {color, count, labels, sprites}
const entityStates = new Map(); // key = "type_state_tileSelect", value = count
const paletteStates = []; // track palette changes
let lastPalStr = '';

// All unique tile numbers seen per color group
const tilesPerColor = {};

for (const file of files) {
  const label = file.replace(/^\d+_/, '').replace('.bin', '');
  const { sprites, entities, palette } = parseDump(path.join(CAPTURE_DIR, file));

  // Group sprites by color
  const byColor = {};
  for (const s of sprites) {
    if (!byColor[s.color]) byColor[s.color] = [];
    byColor[s.color].push(s);
  }

  // Track unique compositions per color
  for (const [color, group] of Object.entries(byColor)) {
    group.sort((a, b) => a.sx - b.sx || a.sy - b.sy);
    const key = group.map(s => `${s.tile}:${s.size}:${s.sx}:${s.sy}`).join('|');
    const tileKey = group.map(s => s.tile).sort((a,b) => a-b).join(',');

    if (!tilesPerColor[color]) tilesPerColor[color] = new Set();
    group.forEach(s => tilesPerColor[color].add(s.tile));

    if (!spriteComps.has(tileKey)) {
      spriteComps.set(tileKey, {
        color: parseInt(color),
        count: 0,
        labels: new Set(),
        sprites: group.map(s => ({
          tile: s.tile, size: s.size, sx: s.sx, sy: s.sy,
          flipX: s.flipX, flipY: s.flipY,
        })),
      });
    }
    spriteComps.get(tileKey).count++;
    spriteComps.get(tileKey).labels.add(label);
  }

  // Track entity states
  for (const e of entities) {
    const key = `type${e.type}_state${e.state.toString(16)}_tile${e.tileSelect.toString(16)}`;
    entityStates.set(key, (entityStates.get(key) || 0) + 1);
  }

  // Track palette changes
  const palStr = palette.slice(128, 256).join(','); // sprite palettes only
  if (palStr !== lastPalStr) {
    paletteStates.push({ file, palHash: palStr.substring(0, 50) });
    lastPalStr = palStr;
  }
}

// Output results
console.log(`\nUnique sprite compositions: ${spriteComps.size}`);
console.log(`Entity state combinations: ${entityStates.size}`);
console.log(`Palette state changes: ${paletteStates.length}`);

// Show tiles per color group
console.log('\nTiles per color group:');
for (const [color, tiles] of Object.entries(tilesPerColor)) {
  console.log(`  Color ${color}: ${tiles.size} unique tiles (${Math.min(...tiles)}-${Math.max(...tiles)})`);
}

// Group compositions by label (animation type)
const compsByLabel = {};
for (const [key, comp] of spriteComps) {
  for (const label of comp.labels) {
    const animType = label.replace(/[0-9]/g, '').replace(/_+$/, '');
    if (!compsByLabel[animType]) compsByLabel[animType] = [];
    compsByLabel[animType].push({
      tiles: comp.sprites.map(s => s.tile),
      color: comp.color,
      spriteCount: comp.sprites.length,
      count: comp.count,
    });
  }
}

console.log('\nCompositions by animation type:');
for (const [anim, comps] of Object.entries(compsByLabel).sort((a,b) => b[1].length - a[1].length)) {
  const unique = new Set(comps.map(c => c.tiles.join(','))).size;
  console.log(`  ${anim}: ${unique} unique frames (${comps.length} total)`);
}

// Build the complete animation data structure
const animData = {
  metadata: {
    captureCount: files.length,
    uniqueCompositions: spriteComps.size,
    paletteChanges: paletteStates.length,
  },
  tileRanges: {},
  animations: {},
  entityStates: Object.fromEntries(
    [...entityStates.entries()].sort((a,b) => b[1] - a[1])
  ),
};

// Build per-color tile ranges
for (const [color, tiles] of Object.entries(tilesPerColor)) {
  animData.tileRanges[color] = {
    count: tiles.size,
    min: Math.min(...tiles),
    max: Math.max(...tiles),
    tiles: [...tiles].sort((a,b) => a - b),
  };
}

// Build per-animation-type frame list
for (const [anim, comps] of Object.entries(compsByLabel)) {
  const uniqueFrames = new Map();
  for (const c of comps) {
    const key = c.tiles.join(',');
    if (!uniqueFrames.has(key)) {
      uniqueFrames.set(key, c);
    }
  }
  animData.animations[anim] = [...uniqueFrames.values()].map(c => ({
    tiles: c.tiles,
    color: c.color,
    spriteCount: c.spriteCount,
  }));
}

// Save full sprite composition data
const fullComps = [];
for (const [key, comp] of spriteComps) {
  fullComps.push({
    color: comp.color,
    count: comp.count,
    labels: [...comp.labels],
    sprites: comp.sprites,
  });
}
fullComps.sort((a, b) => b.count - a.count);

animData.compositions = fullComps;

fs.writeFileSync(
  path.join(OUT_DIR, 'full-animation-data.json'),
  JSON.stringify(animData, null, 2)
);

console.log(`\nSaved full-animation-data.json`);
console.log(`Top 20 most common sprite compositions:`);
for (const c of fullComps.slice(0, 20)) {
  const tiles = c.sprites.map(s => s.tile).join(',');
  console.log(`  [${c.labels[0]}] color=${c.color} x${c.count}: tiles=${tiles}`);
}

// Also extract the BEST palette (most complete one)
const bestPalFile = files[Math.floor(files.length * 0.7)]; // 70% through gameplay
const bestDump = parseDump(path.join(CAPTURE_DIR, bestPalFile));
const palData = {
  source: bestPalFile,
  chars: [],
  sprites: [],
  tiles: [],
};
for (let p = 0; p < 8; p++) {
  const charPal = [], sprPal = [], tilePal = [];
  for (let c = 0; c < 16; c++) {
    const cw = bestDump.palette[p * 16 + c];
    const sw = bestDump.palette[128 + p * 16 + c];
    const tw = bestDump.palette[256 + p * 16 + c];
    charPal.push({ r: (cw&0xF)*17, g: ((cw>>4)&0xF)*17, b: ((cw>>8)&0xF)*17 });
    sprPal.push({ r: (sw&0xF)*17, g: ((sw>>4)&0xF)*17, b: ((sw>>8)&0xF)*17 });
    tilePal.push({ r: (tw&0xF)*17, g: ((tw>>4)&0xF)*17, b: ((tw>>8)&0xF)*17 });
  }
  palData.chars.push(charPal);
  palData.sprites.push(sprPal);
  palData.tiles.push(tilePal);
}

fs.writeFileSync(
  path.join(OUT_DIR, 'gameplay-palettes.json'),
  JSON.stringify(palData, null, 2)
);
console.log('Saved gameplay-palettes.json');
