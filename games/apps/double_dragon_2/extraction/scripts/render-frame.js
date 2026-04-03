#!/usr/bin/env node
/**
 * Render a COMPLETE DD2 frame exactly as MAME does.
 * Read one dump file, render BG + sprites, compare to MAME screenshot.
 *
 * From MAME ddragon_v.cpp screen_update():
 *   1. Draw BG tilemap (scrolled)
 *   2. Draw sprites
 *   3. Draw FG tilemap (text/HUD)
 *
 * From MAME draw_sprites():
 *   for each 5-byte entry:
 *     if (attr & 0x80) visible
 *     sx = 240 - src[4] + ((attr & 2) << 7)
 *     sy = 232 - src[0] + ((attr & 1) << 8)
 *     size = (attr >> 4) & 3
 *     flipX = attr & 8, flipY = attr & 4
 *     dx = -16, dy = -16
 *     if (flip_screen) { sx=240-sx; sy=240-16-sy; flipX=!flipX; flipY=!flipY; dx=-dx; dy=-dy; }
 *     which &= ~size
 *     DD2: color = src[2] >> 5, which = src[3] | ((src[2] & 0x1F) << 8)
 *
 *     size 0: draw(which, sx, sy)
 *     size 1: draw(which+0, sx, sy+dy); draw(which+1, sx, sy)
 *     size 2: draw(which+0, sx+dx, sy); draw(which+2, sx, sy)
 *     size 3: draw(which+0, sx+dx, sy+dy); draw(which+1, sx+dx, sy);
 *             draw(which+2, sx, sy+dy); draw(which+3, sx, sy)
 */

const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const SCREEN_W = 256;
const SCREEN_H = 240;
const SCALE = 3;

// Load ROM tiles
function loadSpriteRegion() {
  const roms = [
    { name: '26j0-0.bin', offset: 0 }, { name: '26j1-0.bin', offset: 0x20000 },
    { name: '26af-0.bin', offset: 0x40000 }, { name: '26j2-0.bin', offset: 0x60000 },
    { name: '26j3-0.bin', offset: 0x80000 }, { name: '26a10-0.bin', offset: 0xA0000 },
  ];
  const region = new Uint8Array(0xC0000);
  for (const r of roms) {
    const rom = fs.readFileSync(path.join(__dirname, r.name));
    region.set(new Uint8Array(rom.buffer, rom.byteOffset, Math.min(rom.length, 0x20000)), r.offset);
  }
  return region;
}

function loadBGRegion() {
  const region = new Uint8Array(0x40000);
  const j4 = fs.readFileSync(path.join(__dirname, '26j4-0.bin'));
  const j5 = fs.readFileSync(path.join(__dirname, '26j5-0.bin'));
  region.set(new Uint8Array(j4.buffer, j4.byteOffset, Math.min(j4.length, 0x20000)), 0);
  region.set(new Uint8Array(j5.buffer, j5.byteOffset, Math.min(j5.length, 0x20000)), 0x20000);
  return region;
}

function loadCharRegion() {
  const rom = fs.readFileSync(path.join(__dirname, '26a8-0.bin'));
  return new Uint8Array(rom.buffer, rom.byteOffset, rom.length);
}

// Tile decode (MAME tile_layout)
function decodeTile16(region, tileIdx) {
  const HALF = region.length / 2;
  const HB = HALF * 8;
  const pl = [HB, HB + 4, 0, 4];
  const xo = [3, 2, 1, 0, 131, 130, 129, 128, 259, 258, 257, 256, 387, 386, 385, 384];
  const yo = []; for (let i = 0; i < 16; i++) yo.push(i * 8);

  const px = new Uint8Array(256);
  const base = tileIdx * 512;
  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      let pixel = 0;
      for (let p = 0; p < 4; p++) {
        const bp = base + yo[y] + xo[x] + pl[p];
        const bi = bp >> 3;
        if (bi < region.length) pixel |= ((region[bi] >> (bp & 7)) & 1) << p;
      }
      px[y * 16 + x] = pixel;
    }
  }
  return px;
}

// Char decode (MAME char_layout) - 8x8
function decodeChar(region, tileIdx) {
  const pl = [0, 2, 4, 6];
  const xo = [1, 0, 65, 64, 129, 128, 193, 192];
  const yo = []; for (let i = 0; i < 8; i++) yo.push(i * 8);

  const px = new Uint8Array(64);
  const base = tileIdx * 256;
  for (let y = 0; y < 8; y++) {
    for (let x = 0; x < 8; x++) {
      let pixel = 0;
      for (let p = 0; p < 4; p++) {
        const bp = base + yo[y] + xo[x] + pl[p];
        const bi = bp >> 3;
        if (bi < region.length) pixel |= ((region[bi] >> (bp & 7)) & 1) << p;
      }
      px[y * 8 + x] = pixel;
    }
  }
  return px;
}

// Read palette from dump
function readPalette(dump) {
  const colors = [];
  for (let i = 0; i < 512; i++) {
    const lo = dump[0x3C00 + i], hi = dump[0x3E00 + i];
    const w = (hi << 8) | lo;
    const r = (w & 0xF) * 17, g = ((w >> 4) & 0xF) * 17, b = ((w >> 8) & 0xF) * 17;
    colors.push([r, g, b, i % 16 === 0 ? 0 : 255]);
  }
  return colors;
}

// Main rendering
const spriteRegion = loadSpriteRegion();
const bgRegion = loadBGRegion();
const charRegion = loadCharRegion();

// Pick a dump file
const dumpFile = process.argv[2] || 'mame-dumps/full-capture/0184_combat.bin';
const dump = fs.readFileSync(path.join(__dirname, dumpFile));
const palette = readPalette(dump);

const W = SCREEN_W * SCALE, H = SCREEN_H * SCALE;
const png = new PNG({ width: W, height: H });

// Fill black
for (let i = 0; i < png.data.length; i += 4) {
  png.data[i] = 0; png.data[i + 1] = 0; png.data[i + 2] = 0; png.data[i + 3] = 255;
}

function setPixel(x, y, r, g, b, a) {
  if (x < 0 || x >= SCREEN_W || y < 0 || y >= SCREEN_H) return;
  for (let sy = 0; sy < SCALE; sy++) {
    for (let sx = 0; sx < SCALE; sx++) {
      const di = ((y * SCALE + sy) * W + (x * SCALE + sx)) * 4;
      if (a > 0) {
        png.data[di] = r; png.data[di + 1] = g; png.data[di + 2] = b; png.data[di + 3] = 255;
      }
    }
  }
}

function drawTile16(tileIdx, palBase, px, py, flipX, flipY) {
  const pixels = decodeTile16(spriteRegion, tileIdx);
  for (let y = 0; y < 16; y++) {
    for (let x = 0; x < 16; x++) {
      const srcX = flipX ? 15 - x : x;
      const srcY = flipY ? 15 - y : y;
      const ci = pixels[srcY * 16 + srcX];
      if (ci === 0) continue;
      const c = palette[palBase + ci];
      setPixel(px + x, py + y, c[0], c[1], c[2], c[3]);
    }
  }
}

// === 1. DRAW BG TILEMAP ===
// BG tilemap at $3000-$37FF, 32x32 tiles
// Palette base for tiles = 256
// Scroll from dump... simplified: read scroll registers
// scrollx at dump bytes that correspond to $3809/$380A
// Scroll registers are write-only, can't read from dump.
// DD2 BG is 32x32 tiles = 512x512 pixels. Content is in rows 16-31.
// The scroll positions the visible 256x240 window.
// From MAME gameplay, scroll Y puts the ground at screen bottom.
// Estimate: scrollY ~ 256 (shows bottom half), scrollX from gameplay context
const scrollX = 64; // approximate from gameplay
const scrollY = 248; // show the bottom portion where content is

function bgScan(col, row) {
  return (col & 0x0f) | ((row & 0x0f) << 4) | ((col & 0x10) << 4) | ((row & 0x10) << 5);
}

for (let screenY = 0; screenY < SCREEN_H; screenY++) {
  for (let screenX = 0; screenX < SCREEN_W; screenX++) {
    const worldX = screenX + scrollX;
    const worldY = screenY + scrollY + 8; // scrolldy = -8

    const col = (worldX >> 4) & 31;
    const row = (worldY >> 4) & 31;
    const tileX = worldX & 15;
    const tileY = worldY & 15;

    const memOff = bgScan(col, row) * 2;
    const attr = dump[0x3000 + memOff];
    const tileLo = dump[0x3000 + memOff + 1];
    const tile = tileLo | ((attr & 7) << 8);
    const color = (attr >> 3) & 7;
    const flipX = !!(attr & 0x40);
    const flipY = !!(attr & 0x80);

    const srcX = flipX ? 15 - tileX : tileX;
    const srcY = flipY ? 15 - tileY : tileY;

    const pixels = decodeTile16(bgRegion, tile);
    const ci = pixels[srcY * 16 + srcX];
    if (ci !== 0) {
      const c = palette[256 + color * 16 + ci];
      setPixel(screenX, screenY, c[0], c[1], c[2], c[3]);
    }
  }
}

// === 2. DRAW SPRITES ===
// Exact MAME draw_sprites() logic
for (let i = 0x2800; i < 0x3000; i += 5) {
  const attr = dump[i + 1];
  if (!(attr & 0x80)) continue;

  let sx = 240 - dump[i + 4] + ((attr & 2) << 7);
  let sy = 232 - dump[i] + ((attr & 1) << 8);
  const size = (attr >> 4) & 3;
  let flipX = !!(attr & 8);
  let flipY = !!(attr & 4);
  let dx = -16, dy = -16;

  const color = dump[i + 2] >> 5;
  let which = dump[i + 3] | ((dump[i + 2] & 0x1F) << 8);
  const palBase = 128 + color * 16;

  which &= ~size;

  switch (size) {
    case 0:
      drawTile16(which, palBase, sx, sy, flipX, flipY);
      break;
    case 1:
      drawTile16(which, palBase, sx, sy + dy, flipX, flipY);
      drawTile16(which + 1, palBase, sx, sy, flipX, flipY);
      break;
    case 2:
      drawTile16(which, palBase, sx + dx, sy, flipX, flipY);
      drawTile16(which + 2, palBase, sx, sy, flipX, flipY);
      break;
    case 3:
      drawTile16(which, palBase, sx + dx, sy + dy, flipX, flipY);
      drawTile16(which + 1, palBase, sx + dx, sy, flipX, flipY);
      drawTile16(which + 2, palBase, sx, sy + dy, flipX, flipY);
      drawTile16(which + 3, palBase, sx, sy, flipX, flipY);
      break;
  }
}

// === 3. DRAW FG (TEXT/HUD) ===
// FG tilemap at $1800-$1FFF, 32x32 chars (8x8)
// Palette base for chars = 0
// DD2 FG: tile = byte1 | ((byte0 & 0x07) << 8), color = byte0 >> 5
for (let row = 0; row < 32; row++) {
  for (let col = 0; col < 32; col++) {
    const memOff = (row * 32 + col) * 2;
    const attr = dump[0x1800 + memOff];
    const tileLo = dump[0x1800 + memOff + 1];
    const tile = tileLo | ((attr & 0x0F) << 8);
    const color = attr >> 5;

    if (tile === 0) continue;

    const pixels = decodeChar(charRegion, tile);
    const palBase = color * 16;

    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 8; x++) {
        const ci = pixels[y * 8 + x];
        if (ci === 0) continue;
        const c = palette[palBase + ci];
        setPixel(col * 8 + x, row * 8 + y - 8, c[0], c[1], c[2], c[3]);
      }
    }
  }
}

const outFile = path.join(__dirname, 'output/rendered_frame.png');
fs.writeFileSync(outFile, PNG.sync.write(png));
console.log('Rendered: ' + outFile + ' (' + W + 'x' + H + ')');
console.log('Compare to MAME screenshot to verify accuracy');
