#!/usr/bin/env node
/**
 * Double Dragon 2 Arcade ROM Data Extractor
 * Target: Technos Japan TA-0026 hardware
 * Main CPU: HD6309 (6809-compatible)
 *
 * Analyzes 26a9-04.bin (main CPU ROM, 32KB, loaded at 0x8000)
 * and 26aa-03.bin (banked ROM, 32KB, loaded at 0x10000)
 */

const fs = require('fs');
const path = require('path');

const BASE_DIR = path.dirname(__filename);
const OUTPUT_DIR = path.join(BASE_DIR, 'output');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

// Load ROMs
const mainRom = fs.readFileSync(path.join(BASE_DIR, '26a9-04.bin'));
const bankRom = fs.readFileSync(path.join(BASE_DIR, '26aa-03.bin'));

console.log(`Main ROM: ${mainRom.length} bytes`);
console.log(`Bank ROM: ${bankRom.length} bytes`);

const results = {
  metadata: {
    mainRom: { file: '26a9-04.bin', size: mainRom.length, loadAddress: 0x8000 },
    bankRom: { file: '26aa-03.bin', size: bankRom.length, loadAddress: 0x10000 },
    extractionDate: new Date().toISOString(),
  },
  vectorTable: null,
  pointerTables: [],
  palettes: [],
  spriteAnimations: [],
  tilemapData: [],
  hitboxData: [],
  enemyWaveData: [],
  dataTables: [],
};

let report = '';
function log(msg) {
  console.log(msg);
  report += msg + '\n';
}

// Helper: read 16-bit big-endian (6809 is big-endian)
function read16(rom, offset) {
  return (rom[offset] << 8) | rom[offset + 1];
}

// Helper: convert ROM offset to CPU address
function mainAddr(offset) { return offset + 0x8000; }
function bankAddr(offset) { return offset + 0x10000; }

// Helper: convert CPU address to ROM offset (main ROM)
function mainOffset(addr) { return addr - 0x8000; }

// Helper: hex formatting
function hex(v, digits = 4) { return '0x' + v.toString(16).toUpperCase().padStart(digits, '0'); }
function hexByte(v) { return v.toString(16).toUpperCase().padStart(2, '0'); }
function hexDump(rom, offset, length) {
  let s = '';
  for (let i = 0; i < length && offset + i < rom.length; i++) {
    s += hexByte(rom[offset + i]) + ' ';
  }
  return s.trim();
}

// ============================================================
// 1. VECTOR TABLE (6809/6309 vectors at 0xFFF0-0xFFFF)
// ============================================================
log('=== 6809/6309 VECTOR TABLE ===');
{
  const vectorNames = ['Reserved', 'SWI3', 'SWI2', 'FIRQ', 'IRQ', 'SWI', 'NMI', 'RESET'];
  const vectorBase = 0x7FF0; // ROM offset for 0xFFF0
  const vectors = {};
  for (let i = 0; i < 8; i++) {
    const addr = read16(mainRom, vectorBase + i * 2);
    vectors[vectorNames[i]] = hex(addr);
    log(`  ${vectorNames[i].padEnd(10)}: ${hex(addr)}`);
  }
  results.vectorTable = vectors;
}

// ============================================================
// 2. POINTER TABLES - scan for tables of valid ROM addresses
// ============================================================
log('\n=== POINTER TABLE SCAN ===');
{
  function scanPointerTables(rom, romName, baseAddr, minEntries = 4) {
    const tables = [];
    for (let i = 0; i < rom.length - (minEntries * 2); i++) {
      // Check if this looks like a sequence of valid pointers
      let validCount = 0;
      let pointers = [];
      for (let j = 0; j < 64 && i + j * 2 + 1 < rom.length; j++) {
        const val = read16(rom, i + j * 2);
        // Valid pointer: points into main ROM space (0x8000-0xFFFF)
        // or banked ROM space (0x4000-0x7FFF for bank-switched area)
        if (val >= 0x8000 && val <= 0xFFEF) {
          validCount++;
          pointers.push(val);
        } else {
          break;
        }
      }
      if (validCount >= minEntries) {
        // Check it's not inside existing code (heuristic: look for JMP/JSR patterns before)
        const entry = {
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          count: validCount,
          pointers: pointers.map(p => hex(p)),
          rawHex: hexDump(rom, i, Math.min(validCount * 2, 64)),
        };
        tables.push(entry);
        // Skip past this table
        i += validCount * 2 - 1;
      }
    }
    return tables;
  }

  const mainPtrTables = scanPointerTables(mainRom, 'main', 0x8000, 4);
  const bankPtrTables = scanPointerTables(bankRom, 'bank', 0x10000, 4);

  // Filter: prefer larger tables and avoid overlap with code
  const allPtrTables = [...mainPtrTables, ...bankPtrTables]
    .sort((a, b) => b.count - a.count);

  // Keep top 50 most significant tables
  const topTables = allPtrTables.slice(0, 50);
  results.pointerTables = topTables;

  log(`  Found ${mainPtrTables.length} pointer tables in main ROM`);
  log(`  Found ${bankPtrTables.length} pointer tables in bank ROM`);
  log(`  Top pointer tables:`);
  topTables.slice(0, 20).forEach(t => {
    log(`    ${t.rom} ${t.cpuAddress}: ${t.count} pointers -> [${t.pointers.slice(0, 6).join(', ')}${t.count > 6 ? '...' : ''}]`);
  });
}

// ============================================================
// 3. PALETTE DATA - search for color tables
// ============================================================
log('\n=== PALETTE DATA SCAN ===');
{
  /**
   * DD2 arcade uses palette RAM. Colors written by CPU.
   * Format likely: xBBBBBGGGGGRRRRR (15-bit, 1 unused bit) in big-endian 16-bit words
   * Or could be separate writes of R, G, B bytes.
   *
   * We look for:
   * a) Blocks of 32 bytes (16 colors x 2 bytes) where values look like 15-bit colors
   * b) Consecutive data with values in 0x0000-0x7FFF range (15-bit)
   * c) Blocks where first entry is often 0x0000 (black/transparent)
   */

  function scanPalettes(rom, romName, baseAddr) {
    const palettes = [];

    for (let i = 0; i < rom.length - 32; i++) {
      // Check if this could be a 16-color palette (32 bytes)
      let valid = true;
      let hasVariation = false;
      let allZero = true;
      let values = [];

      for (let j = 0; j < 16; j++) {
        const val = read16(rom, i + j * 2);
        values.push(val);
        // 15-bit color: max 0x7FFF
        if (val > 0x7FFF) {
          valid = false;
          break;
        }
        if (val !== 0) allZero = false;
        if (j > 0 && val !== values[0]) hasVariation = true;
      }

      if (!valid || allZero || !hasVariation) continue;

      // Additional heuristics:
      // - First color is often 0 (transparent/black)
      // - Should have at least 4 different values
      const uniqueVals = new Set(values);
      if (uniqueVals.size < 4) continue;

      // Check it's not in the middle of code (look for 6809 opcodes)
      // Simple heuristic: if the previous byte is a JSR/JMP target setup, skip
      const prevByte = i > 0 ? rom[i - 1] : 0;
      // 0x7E = JMP, 0xBD = JSR - if just before, this is likely a target, not data
      // We'll accept this anyway and rank by quality

      // Decode colors
      const colors = values.map(v => ({
        raw: hex(v),
        r: (v & 0x1F) << 3,
        g: ((v >> 5) & 0x1F) << 3,
        b: ((v >> 10) & 0x1F) << 3,
      }));

      // Score: prefer palettes starting with 0, with good color distribution
      let score = uniqueVals.size;
      if (values[0] === 0) score += 5;

      palettes.push({
        romOffset: hex(i),
        cpuAddress: hex(baseAddr + i),
        rom: romName,
        score,
        rawHex: hexDump(rom, i, 32),
        colors,
      });

      // Don't skip - overlapping palettes are common in tables
      // but skip a little to avoid re-detecting same block shifted by 1
      i += 1;
    }

    // Sort by score descending, take top results
    palettes.sort((a, b) => b.score - a.score);
    return palettes.slice(0, 40);
  }

  const mainPalettes = scanPalettes(mainRom, 'main', 0x8000);
  const bankPalettes = scanPalettes(bankRom, 'bank', 0x10000);
  const allPalettes = [...mainPalettes, ...bankPalettes].sort((a, b) => b.score - a.score).slice(0, 40);
  results.palettes = allPalettes;

  log(`  Found ${mainPalettes.length} candidate palettes in main ROM`);
  log(`  Found ${bankPalettes.length} candidate palettes in bank ROM`);
  allPalettes.slice(0, 10).forEach(p => {
    log(`    ${p.rom} ${p.cpuAddress} (score ${p.score}): ${p.rawHex.substring(0, 60)}...`);
    log(`      Colors: ${p.colors.slice(0, 4).map(c => `RGB(${c.r},${c.g},${c.b})`).join(', ')}...`);
  });
}

// ============================================================
// 4. SPRITE ANIMATION TABLES
// ============================================================
log('\n=== SPRITE ANIMATION TABLE SCAN ===');
{
  /**
   * Sprite animation tables typically contain:
   * - Tile indices (16-bit, range 0-~0x1800 for DD2 sprites)
   * - X/Y offsets (signed 8-bit)
   * - Attribute flags
   *
   * Common format per frame entry: [tile_lo, tile_hi, xoff, yoff, flags]
   * or structured as pointer table -> frame list -> tile entries
   *
   * Also look for animation frame count + pointer to frame data patterns
   */

  function scanSpriteAnimations(rom, romName, baseAddr) {
    const animations = [];

    // Strategy 1: Look for sequences of [tile_index(16), xoff(8), yoff(8)]
    // where tile_index is in sprite range and offsets are small signed values
    for (let i = 0; i < rom.length - 16; i++) {
      let frames = [];
      let pos = i;

      while (pos + 3 < rom.length) {
        const tile = read16(rom, pos);
        const xoff = rom[pos + 2] > 127 ? rom[pos + 2] - 256 : rom[pos + 2];
        const yoff = rom[pos + 3] > 127 ? rom[pos + 3] - 256 : rom[pos + 3];

        // Tile index in valid sprite range, offsets are small
        if (tile >= 0 && tile <= 0x1800 &&
            Math.abs(xoff) <= 64 && Math.abs(yoff) <= 64 &&
            tile !== 0) { // skip all-zero
          frames.push({ tile: hex(tile), xoff, yoff, rawPos: hex(pos) });
          pos += 4;
        } else {
          break;
        }
        if (frames.length >= 32) break; // cap
      }

      if (frames.length >= 3) {
        animations.push({
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          frameCount: frames.length,
          frames,
          rawHex: hexDump(rom, i, Math.min(frames.length * 4, 64)),
        });
        i = pos - 1; // skip past
      }
    }

    return animations;
  }

  // Strategy 2: Look for tables with frame-count headers
  function scanFrameCountTables(rom, romName, baseAddr) {
    const tables = [];

    for (let i = 0; i < rom.length - 8; i++) {
      const count = rom[i];
      // Reasonable frame count (2-32)
      if (count < 2 || count > 32) continue;

      // Check if followed by that many 2-byte values in tile range
      let valid = true;
      let entries = [];
      for (let j = 0; j < count; j++) {
        const offset = i + 1 + j * 2;
        if (offset + 1 >= rom.length) { valid = false; break; }
        const val = read16(rom, offset);
        if (val > 0x1800) { valid = false; break; }
        entries.push(hex(val));
      }

      if (valid && entries.length === count) {
        // Verify: entries should have some variation
        const unique = new Set(entries);
        if (unique.size >= 2) {
          tables.push({
            romOffset: hex(i),
            cpuAddress: hex(baseAddr + i),
            rom: romName,
            frameCount: count,
            tileIndices: entries,
            rawHex: hexDump(rom, i, 1 + count * 2),
          });
          i += count * 2;
        }
      }
    }

    return tables;
  }

  const mainAnims = scanSpriteAnimations(mainRom, 'main', 0x8000);
  const bankAnims = scanSpriteAnimations(bankRom, 'bank', 0x10000);

  const mainFrameTables = scanFrameCountTables(mainRom, 'main', 0x8000);
  const bankFrameTables = scanFrameCountTables(bankRom, 'bank', 0x10000);

  // Sort by frame count
  const allAnims = [...mainAnims, ...bankAnims].sort((a, b) => b.frameCount - a.frameCount).slice(0, 40);
  const allFrameTables = [...mainFrameTables, ...bankFrameTables].sort((a, b) => b.frameCount - a.frameCount).slice(0, 30);

  results.spriteAnimations = { tileSequences: allAnims, frameCountTables: allFrameTables };

  log(`  Tile sequences: ${mainAnims.length} in main ROM, ${bankAnims.length} in bank ROM`);
  log(`  Frame count tables: ${mainFrameTables.length} in main, ${bankFrameTables.length} in bank`);
  allAnims.slice(0, 10).forEach(a => {
    log(`    ${a.rom} ${a.cpuAddress}: ${a.frameCount} frames - tiles: ${a.frames.slice(0, 5).map(f => f.tile).join(', ')}${a.frameCount > 5 ? '...' : ''}`);
  });
}

// ============================================================
// 5. LEVEL / TILEMAP DATA
// ============================================================
log('\n=== LEVEL / TILEMAP DATA SCAN ===');
{
  /**
   * Background tiles are 16x16, tile indices 0-2048.
   * Tilemaps may be:
   * - Raw tile index arrays (sequences of bytes or words in 0-0x800 range)
   * - RLE compressed (byte count + tile value)
   * - Column-based (vertical strips for scrolling)
   *
   * Screen = 256x240 pixels = 16x15 tiles
   * Levels scroll horizontally, so maps are wider.
   */

  function scanTilemapData(rom, romName, baseAddr) {
    const tilemaps = [];

    // Look for long sequences of bytes in 0x00-0xFF range that could be tile indices
    // (single-byte tile index, up to 256 tiles)
    // Look for consistent patterns of data that's NOT code

    // Heuristic: Look for runs of bytes where most values < 0x80 and there's repetition
    // typical of map data
    for (let i = 0; i < rom.length - 32; i++) {
      let run = 0;
      let histogram = new Array(256).fill(0);

      for (let j = 0; j < 512 && i + j < rom.length; j++) {
        const b = rom[i + j];
        histogram[b]++;
        // Map tile data tends to use a limited set of tile values
        if (b < 0x80) {
          run++;
        } else {
          if (run < 16) { run = 0; break; }
          break;
        }
      }

      if (run >= 32) {
        // Count unique values
        const usedTiles = histogram.filter(v => v > 0).length;
        // Map data typically uses fewer unique values than code
        const avgRepetition = run / usedTiles;

        if (usedTiles >= 3 && usedTiles <= 64 && avgRepetition >= 2) {
          const data = [];
          for (let j = 0; j < run; j++) data.push(rom[i + j]);

          tilemaps.push({
            romOffset: hex(i),
            cpuAddress: hex(baseAddr + i),
            rom: romName,
            length: run,
            uniqueTiles: usedTiles,
            avgRepetition: Math.round(avgRepetition * 10) / 10,
            rawHex: hexDump(rom, i, Math.min(run, 64)),
            tileValues: data.slice(0, 64),
          });
          i += run - 1;
        }
      }
    }

    return tilemaps;
  }

  // Also scan for RLE-compressed data: [count, value] pairs
  function scanRLEData(rom, romName, baseAddr) {
    const rleBlocks = [];

    for (let i = 0; i < rom.length - 8; i++) {
      let pos = i;
      let decodedLen = 0;
      let pairs = 0;

      while (pos + 1 < rom.length && pairs < 128) {
        const count = rom[pos];
        const value = rom[pos + 1];
        // RLE: count should be 1-64, value should be a tile index
        if (count >= 1 && count <= 64 && value < 0x80) {
          decodedLen += count;
          pairs++;
          pos += 2;
        } else {
          break;
        }
      }

      // A valid RLE block should decode to something reasonable (at least a row of tiles)
      if (pairs >= 4 && decodedLen >= 16 && decodedLen <= 4096) {
        rleBlocks.push({
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          compressedSize: pairs * 2,
          decodedSize: decodedLen,
          pairCount: pairs,
          rawHex: hexDump(rom, i, Math.min(pairs * 2, 64)),
        });
        i = pos - 1;
      }
    }

    return rleBlocks;
  }

  // Word-sized tile indices (for 16-bit tile refs)
  function scanWordTilemaps(rom, romName, baseAddr) {
    const tilemaps = [];

    for (let i = 0; i < rom.length - 16; i += 2) {
      let count = 0;
      let values = [];

      for (let j = 0; j < 256 && i + j * 2 + 1 < rom.length; j++) {
        const val = read16(rom, i + j * 2);
        if (val <= 0x0800) { // BG tile range
          count++;
          values.push(val);
        } else {
          break;
        }
      }

      if (count >= 8) {
        const unique = new Set(values);
        if (unique.size >= 3 && unique.size <= count / 2) { // Some repetition expected
          tilemaps.push({
            romOffset: hex(i),
            cpuAddress: hex(baseAddr + i),
            rom: romName,
            tileCount: count,
            uniqueTiles: unique.size,
            rawHex: hexDump(rom, i, Math.min(count * 2, 64)),
            tileValues: values.slice(0, 32),
          });
          i += count * 2 - 2;
        }
      }
    }

    return tilemaps;
  }

  const mainTilemaps = scanTilemapData(mainRom, 'main', 0x8000);
  const bankTilemaps = scanTilemapData(bankRom, 'bank', 0x10000);
  const mainRLE = scanRLEData(mainRom, 'main', 0x8000);
  const bankRLE = scanRLEData(bankRom, 'bank', 0x10000);
  const mainWordTM = scanWordTilemaps(mainRom, 'main', 0x8000);
  const bankWordTM = scanWordTilemaps(bankRom, 'bank', 0x10000);

  results.tilemapData = {
    byteTilemaps: [...mainTilemaps, ...bankTilemaps].sort((a, b) => b.length - a.length).slice(0, 30),
    rleBlocks: [...mainRLE, ...bankRLE].sort((a, b) => b.decodedSize - a.decodedSize).slice(0, 30),
    wordTilemaps: [...mainWordTM, ...bankWordTM].sort((a, b) => b.tileCount - a.tileCount).slice(0, 30),
  };

  log(`  Byte tilemaps: ${mainTilemaps.length} in main, ${bankTilemaps.length} in bank`);
  log(`  RLE blocks: ${mainRLE.length} in main, ${bankRLE.length} in bank`);
  log(`  Word tilemaps: ${mainWordTM.length} in main, ${bankWordTM.length} in bank`);

  [...mainTilemaps, ...bankTilemaps].sort((a, b) => b.length - a.length).slice(0, 5).forEach(t => {
    log(`    ${t.rom} ${t.cpuAddress}: ${t.length} bytes, ${t.uniqueTiles} unique tiles, avgRep ${t.avgRepetition}`);
  });
  [...mainRLE, ...bankRLE].sort((a, b) => b.decodedSize - a.decodedSize).slice(0, 5).forEach(r => {
    log(`    RLE ${r.rom} ${r.cpuAddress}: ${r.pairCount} pairs -> ${r.decodedSize} decoded bytes`);
  });
}

// ============================================================
// 6. HITBOX / COLLISION DATA
// ============================================================
log('\n=== HITBOX / COLLISION DATA SCAN ===');
{
  /**
   * Hitboxes: typically 4 signed bytes [x1, y1, x2, y2]
   * Where x1 < x2 and y1 < y2 (or y1 > y2 depending on screen coords)
   * Values typically small: -48 to +48 pixel range
   *
   * May also appear as [xoff, yoff, width, height]
   */

  function scanHitboxes(rom, romName, baseAddr) {
    const hitboxTables = [];

    for (let i = 0; i < rom.length - 16; i++) {
      let boxes = [];
      let pos = i;

      while (pos + 3 < rom.length && boxes.length < 64) {
        const b0 = rom[pos] > 127 ? rom[pos] - 256 : rom[pos];
        const b1 = rom[pos + 1] > 127 ? rom[pos + 1] - 256 : rom[pos + 1];
        const b2 = rom[pos + 2] > 127 ? rom[pos + 2] - 256 : rom[pos + 2];
        const b3 = rom[pos + 3] > 127 ? rom[pos + 3] - 256 : rom[pos + 3];

        // Hitbox heuristic: values in reasonable range, some ordering
        const allSmall = Math.abs(b0) <= 48 && Math.abs(b1) <= 48 &&
                         Math.abs(b2) <= 48 && Math.abs(b3) <= 48;
        // At least one non-zero dimension
        const hasSize = (b0 !== b2 || b1 !== b3) && (b2 !== 0 || b3 !== 0);

        if (allSmall && hasSize) {
          boxes.push({
            x1: b0, y1: b1, x2: b2, y2: b3,
            raw: hexDump(rom, pos, 4),
          });
          pos += 4;
        } else {
          break;
        }
      }

      if (boxes.length >= 3) {
        hitboxTables.push({
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          count: boxes.length,
          boxes,
          rawHex: hexDump(rom, i, Math.min(boxes.length * 4, 64)),
        });
        i = pos - 1;
      }
    }

    return hitboxTables;
  }

  const mainHitboxes = scanHitboxes(mainRom, 'main', 0x8000);
  const bankHitboxes = scanHitboxes(bankRom, 'bank', 0x10000);
  const allHitboxes = [...mainHitboxes, ...bankHitboxes].sort((a, b) => b.count - a.count).slice(0, 40);
  results.hitboxData = allHitboxes;

  log(`  Found ${mainHitboxes.length} candidate hitbox tables in main ROM`);
  log(`  Found ${bankHitboxes.length} candidate hitbox tables in bank ROM`);
  allHitboxes.slice(0, 10).forEach(h => {
    log(`    ${h.rom} ${h.cpuAddress}: ${h.count} boxes`);
    h.boxes.slice(0, 3).forEach(b => {
      log(`      [${b.x1}, ${b.y1}, ${b.x2}, ${b.y2}] (raw: ${b.raw})`);
    });
  });
}

// ============================================================
// 7. ENEMY WAVE / SPAWN DATA
// ============================================================
log('\n=== ENEMY WAVE / SPAWN DATA SCAN ===');
{
  /**
   * Enemy spawn data often has format:
   * [x_trigger(16), enemy_type(8), y_position(8), count_or_flags(8)]
   * or
   * [scroll_trigger(16), enemy_id(8), x_spawn(8), y_spawn(8)]
   *
   * X triggers are scroll positions (0-~4096 for level length)
   * Enemy types are small numbers (0-~32)
   * Y positions are screen coordinates (0-240)
   */

  function scanEnemyWaves(rom, romName, baseAddr) {
    const waveTables = [];

    // Pattern: [scroll_x(16), enemy_type(8), y_pos(8), flags(8)]  = 5 bytes per entry
    for (let entrySize = 4; entrySize <= 6; entrySize++) {
      for (let i = 0; i < rom.length - entrySize * 3; i++) {
        let entries = [];
        let pos = i;

        while (pos + entrySize <= rom.length && entries.length < 64) {
          const scrollX = read16(rom, pos);
          const enemyType = rom[pos + 2];
          const yPos = rom[pos + 3];

          // Scroll trigger should be ascending or equal (enemies spawn as you progress)
          const prevScrollX = entries.length > 0 ? entries[entries.length - 1].scrollX : 0;

          if (scrollX >= 0x0010 && scrollX <= 0x2000 &&  // reasonable scroll range
              enemyType < 32 &&                            // small enemy type ID
              yPos >= 0x20 && yPos <= 0xF0 &&             // reasonable Y range
              scrollX >= prevScrollX) {                    // ascending order
            entries.push({
              scrollX: hex(scrollX),
              scrollXVal: scrollX,
              enemyType,
              yPos,
              extra: entrySize > 4 ? hexDump(rom, pos + 4, entrySize - 4) : undefined,
              raw: hexDump(rom, pos, entrySize),
            });
            pos += entrySize;
          } else {
            break;
          }
        }

        if (entries.length >= 3) {
          // Verify ascending scroll values with some variation in enemy types
          const uniqueEnemies = new Set(entries.map(e => e.enemyType));
          const uniqueY = new Set(entries.map(e => e.yPos));

          if (uniqueEnemies.size >= 2 || uniqueY.size >= 2) {
            waveTables.push({
              romOffset: hex(i),
              cpuAddress: hex(baseAddr + i),
              rom: romName,
              entrySize,
              count: entries.length,
              entries,
              rawHex: hexDump(rom, i, Math.min(entries.length * entrySize, 64)),
            });
            i = pos - 1;
          }
        }
      }
    }

    return waveTables;
  }

  const mainWaves = scanEnemyWaves(mainRom, 'main', 0x8000);
  const bankWaves = scanEnemyWaves(bankRom, 'bank', 0x10000);
  const allWaves = [...mainWaves, ...bankWaves].sort((a, b) => b.count - a.count).slice(0, 30);
  results.enemyWaveData = allWaves;

  log(`  Found ${mainWaves.length} candidate wave tables in main ROM`);
  log(`  Found ${bankWaves.length} candidate wave tables in bank ROM`);
  allWaves.slice(0, 10).forEach(w => {
    log(`    ${w.rom} ${w.cpuAddress}: ${w.count} entries (${w.entrySize} bytes/entry)`);
    w.entries.slice(0, 4).forEach(e => {
      log(`      scroll=${e.scrollX} enemy=${e.enemyType} y=${e.yPos} [${e.raw}]`);
    });
  });
}

// ============================================================
// 8. ADDITIONAL DATA TABLE SCAN
// ============================================================
log('\n=== ADDITIONAL DATA TABLE SCAN ===');
{
  /**
   * Look for other structured data:
   * - Jump tables (tables of JMP addresses used by indexed jump)
   * - Byte lookup tables (256-byte or power-of-2 sized)
   * - Music/sound pointers
   */

  // Scan for 6809 jump/branch tables: sequences of 0x7E (JMP extended)
  function scanJumpTables(rom, romName, baseAddr) {
    const tables = [];

    for (let i = 0; i < rom.length - 9; i++) {
      if (rom[i] === 0x7E) { // JMP opcode
        let count = 0;
        let entries = [];
        let pos = i;

        while (pos + 2 < rom.length && rom[pos] === 0x7E) {
          const target = read16(rom, pos + 1);
          if (target >= 0x8000 && target <= 0xFFFF) {
            entries.push(hex(target));
            count++;
            pos += 3;
          } else {
            break;
          }
        }

        if (count >= 3) {
          tables.push({
            romOffset: hex(i),
            cpuAddress: hex(baseAddr + i),
            rom: romName,
            type: 'JMP_table',
            count,
            targets: entries,
            rawHex: hexDump(rom, i, Math.min(count * 3, 64)),
          });
          i = pos - 1;
        }
      }
    }

    return tables;
  }

  // Scan for byte lookup tables (power-of-2 sized blocks of non-code data)
  function scanByteTables(rom, romName, baseAddr) {
    const tables = [];

    // Look for blocks bounded by code that have limited byte range
    for (let i = 0; i < rom.length - 16; i++) {
      // Check for blocks of data that look like lookup tables
      // Heuristic: all values < some threshold, with regularity
      let len = 0;
      let maxVal = 0;
      let sum = 0;

      for (let j = 0; j < 256 && i + j < rom.length; j++) {
        const b = rom[i + j];
        if (b <= 0x20 || (b >= 0x80 && b <= 0xA0)) {
          // Could be small constants or signed small values
          len++;
          maxVal = Math.max(maxVal, b);
          sum += b;
        } else {
          break;
        }
      }

      // Only interested in power-of-2 or structured sizes
      if (len >= 16 && (len === 16 || len === 32 || len === 64 || len >= 48)) {
        const avg = sum / len;
        tables.push({
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          type: 'byte_lookup',
          length: len,
          maxValue: hex(maxVal, 2),
          avgValue: Math.round(avg * 10) / 10,
          rawHex: hexDump(rom, i, Math.min(len, 64)),
        });
        i += len - 1;
      }
    }

    return tables;
  }

  const mainJmp = scanJumpTables(mainRom, 'main', 0x8000);
  const bankJmp = scanJumpTables(bankRom, 'bank', 0x10000);
  const mainByte = scanByteTables(mainRom, 'main', 0x8000);
  const bankByte = scanByteTables(bankRom, 'bank', 0x10000);

  results.dataTables = {
    jumpTables: [...mainJmp, ...bankJmp].sort((a, b) => b.count - a.count),
    byteLookups: [...mainByte, ...bankByte].sort((a, b) => b.length - a.length).slice(0, 30),
  };

  log(`  JMP tables: ${mainJmp.length} in main, ${bankJmp.length} in bank`);
  log(`  Byte lookups: ${mainByte.length} in main, ${bankByte.length} in bank`);

  [...mainJmp, ...bankJmp].sort((a, b) => b.count - a.count).slice(0, 10).forEach(j => {
    log(`    JMP table ${j.rom} ${j.cpuAddress}: ${j.count} entries -> [${j.targets.slice(0, 5).join(', ')}${j.count > 5 ? '...' : ''}]`);
  });
}

// ============================================================
// 9. KNOWN MEMORY-MAPPED I/O ANALYSIS
// ============================================================
log('\n=== MEMORY-MAPPED I/O REFERENCES ===');
{
  /**
   * DD2 hardware registers (from MAME driver):
   * 0x3808 - bank switch register
   * 0x3809 - ?
   * 0x380A - ?
   * 0x380B-380E - scroll/control registers
   * 0x0F00-0x0FFF - likely sprite/object RAM area
   */

  // Scan main ROM for writes to known I/O ports
  const ioRefs = [];

  for (let i = 0; i < mainRom.length - 2; i++) {
    // B7 xx xx = STA extended (write A to address)
    // F7 xx xx = STB extended (write B to address)
    // BF xx xx = STX extended
    if (mainRom[i] === 0xB7 || mainRom[i] === 0xF7 || mainRom[i] === 0xBF) {
      const addr = read16(mainRom, i + 1);
      if (addr >= 0x3800 && addr <= 0x3FFF) {
        ioRefs.push({
          romOffset: hex(i),
          cpuAddress: hex(i + 0x8000),
          opcode: hexByte(mainRom[i]),
          targetAddr: hex(addr),
          context: hexDump(mainRom, Math.max(0, i - 2), 8),
        });
      }
    }
  }

  results.ioReferences = ioRefs.slice(0, 50);
  log(`  Found ${ioRefs.length} I/O register writes (0x3800-0x3FFF range)`);

  // Group by target address
  const byAddr = {};
  ioRefs.forEach(r => {
    if (!byAddr[r.targetAddr]) byAddr[r.targetAddr] = 0;
    byAddr[r.targetAddr]++;
  });
  Object.entries(byAddr).sort((a, b) => b[1] - a[1]).forEach(([addr, count]) => {
    log(`    ${addr}: ${count} writes`);
  });
}

// ============================================================
// 10. STRING DATA (text in ROM)
// ============================================================
log('\n=== TEXT / STRING DATA ===');
{
  function scanStrings(rom, romName, baseAddr) {
    const strings = [];

    for (let i = 0; i < rom.length - 3; i++) {
      let len = 0;
      while (i + len < rom.length) {
        const b = rom[i + len];
        // Printable ASCII range (space to ~)
        if (b >= 0x20 && b <= 0x7E) {
          len++;
        } else {
          break;
        }
      }
      if (len >= 4) {
        const text = rom.slice(i, i + len).toString('ascii');
        strings.push({
          romOffset: hex(i),
          cpuAddress: hex(baseAddr + i),
          rom: romName,
          length: len,
          text,
        });
        i += len;
      }
    }
    return strings;
  }

  const mainStrings = scanStrings(mainRom, 'main', 0x8000);
  const bankStrings = scanStrings(bankRom, 'bank', 0x10000);
  results.strings = [...mainStrings, ...bankStrings];

  log(`  Found ${mainStrings.length} strings in main ROM, ${bankStrings.length} in bank ROM`);
  [...mainStrings, ...bankStrings].filter(s => s.length >= 4).forEach(s => {
    log(`    ${s.rom} ${s.cpuAddress}: "${s.text}"`);
  });
}

// ============================================================
// 11. ROM COVERAGE MAP
// ============================================================
log('\n=== ROM COVERAGE SUMMARY ===');
{
  // Identify FF-filled regions (unused space)
  function findUnusedRegions(rom, romName) {
    const regions = [];
    let start = -1;

    for (let i = 0; i < rom.length; i++) {
      if (rom[i] === 0xFF) {
        if (start === -1) start = i;
      } else {
        if (start !== -1 && i - start >= 8) {
          regions.push({ start: hex(start), end: hex(i - 1), size: i - start });
        }
        start = -1;
      }
    }
    if (start !== -1 && rom.length - start >= 8) {
      regions.push({ start: hex(start), end: hex(rom.length - 1), size: rom.length - start });
    }

    const totalUnused = regions.reduce((s, r) => s + r.size, 0);
    log(`  ${romName}: ${totalUnused} bytes unused (${(totalUnused / rom.length * 100).toFixed(1)}%)`);
    regions.filter(r => r.size >= 32).forEach(r => {
      log(`    ${r.start}-${r.end}: ${r.size} bytes`);
    });

    return { regions, totalUnused, romSize: rom.length };
  }

  results.coverage = {
    main: findUnusedRegions(mainRom, 'Main ROM'),
    bank: findUnusedRegions(bankRom, 'Bank ROM'),
  };
}

// ============================================================
// WRITE OUTPUT FILES
// ============================================================

// Write JSON
const jsonPath = path.join(OUTPUT_DIR, 'game-data.json');
fs.writeFileSync(jsonPath, JSON.stringify(results, null, 2));
log(`\nWrote JSON data to: ${jsonPath}`);

// Write report
const reportPath = path.join(OUTPUT_DIR, 'data-report.txt');
const reportHeader = `Double Dragon 2 Arcade ROM Data Extraction Report
==================================================
Generated: ${new Date().toISOString()}
Main ROM: 26a9-04.bin (${mainRom.length} bytes, loaded at 0x8000)
Bank ROM: 26aa-03.bin (${bankRom.length} bytes, loaded at 0x10000)

`;
fs.writeFileSync(reportPath, reportHeader + report);
console.log(`Wrote report to: ${reportPath}`);

// Summary
console.log('\n=== EXTRACTION COMPLETE ===');
console.log(`Vector table: ${Object.keys(results.vectorTable).length} vectors`);
console.log(`Pointer tables: ${results.pointerTables.length} found`);
console.log(`Palettes: ${results.palettes.length} candidates`);
console.log(`Sprite animations: ${results.spriteAnimations.tileSequences?.length || 0} tile sequences, ${results.spriteAnimations.frameCountTables?.length || 0} frame tables`);
console.log(`Tilemap data: ${results.tilemapData.byteTilemaps?.length || 0} byte, ${results.tilemapData.rleBlocks?.length || 0} RLE, ${results.tilemapData.wordTilemaps?.length || 0} word`);
console.log(`Hitbox data: ${results.hitboxData.length} tables`);
console.log(`Enemy waves: ${results.enemyWaveData.length} tables`);
console.log(`JMP tables: ${results.dataTables.jumpTables?.length || 0}`);
console.log(`Strings: ${results.strings?.length || 0}`);
console.log(`I/O refs: ${results.ioReferences?.length || 0}`);
