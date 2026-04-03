#!/usr/bin/env node
/**
 * Render a zoomed portion of sprite tiles for visual verification.
 * Each 16x16 tile rendered at 4x scale = 64x64 pixels.
 */
const fs = require('fs');
const path = require('path');
const { PNG } = require('pngjs');

const OUT = path.join(__dirname, 'output', 'verify');
fs.mkdirSync(OUT, { recursive: true });

// Load the generated sprite sheet PNG and crop sections
const spritePNG = PNG.sync.read(fs.readFileSync(
  path.join(__dirname, 'public', 'assets', 'sprites-player1.png')
));

const TILE = 16;
const COLS = 64; // tiles per row in sheet
const ZOOM = 4;

// Render tiles startIdx..startIdx+count at ZOOM scale
function renderZoomed(startTile, tilesWide, tilesHigh, filename) {
  const w = tilesWide * TILE * ZOOM;
  const h = tilesHigh * TILE * ZOOM;
  const png = new PNG({ width: w, height: h });

  for (let ty = 0; ty < tilesHigh; ty++) {
    for (let tx = 0; tx < tilesWide; tx++) {
      const tileIdx = startTile + ty * COLS + tx;
      const srcX = (tileIdx % COLS) * TILE;
      const srcY = Math.floor(tileIdx / COLS) * TILE;

      for (let y = 0; y < TILE; y++) {
        for (let x = 0; x < TILE; x++) {
          const si = (srcY + y) * spritePNG.width + (srcX + x);
          const r = spritePNG.data[si * 4];
          const g = spritePNG.data[si * 4 + 1];
          const b = spritePNG.data[si * 4 + 2];
          const a = spritePNG.data[si * 4 + 3];

          // Draw zoomed pixel
          for (let zy = 0; zy < ZOOM; zy++) {
            for (let zx = 0; zx < ZOOM; zx++) {
              const dx = tx * TILE * ZOOM + x * ZOOM + zx;
              const dy = ty * TILE * ZOOM + y * ZOOM + zy;
              const di = (dy * w + dx) * 4;
              png.data[di] = r;
              png.data[di + 1] = g;
              png.data[di + 2] = b;
              png.data[di + 3] = a;
            }
          }
        }
      }
    }
  }

  fs.writeFileSync(path.join(OUT, filename), PNG.sync.write(png));
  console.log(`Saved ${filename} (${w}x${h}) - tiles ${startTile} to ${startTile + tilesWide * tilesHigh - 1}`);
}

// Render several sections to find character sprites
renderZoomed(0, 16, 8, 'zoom_tiles_0-127.png');      // First 128 tiles
renderZoomed(128, 16, 8, 'zoom_tiles_128-255.png');   // Next 128
renderZoomed(256, 16, 8, 'zoom_tiles_256-383.png');
renderZoomed(384, 16, 8, 'zoom_tiles_384-511.png');
renderZoomed(512, 16, 8, 'zoom_tiles_512-639.png');
renderZoomed(640, 16, 8, 'zoom_tiles_640-767.png');
renderZoomed(768, 16, 8, 'zoom_tiles_768-895.png');
renderZoomed(896, 16, 8, 'zoom_tiles_896-1023.png');
renderZoomed(1024, 16, 8, 'zoom_tiles_1024-1151.png');

// Also do the BG tiles
const bgPNG = PNG.sync.read(fs.readFileSync(
  path.join(__dirname, 'public', 'assets', 'bg-tiles1.png')
));

function renderZoomedBG(startTile, tilesWide, tilesHigh, filename) {
  const BG_COLS = 32;
  const w = tilesWide * TILE * ZOOM;
  const h = tilesHigh * TILE * ZOOM;
  const png = new PNG({ width: w, height: h });

  for (let ty = 0; ty < tilesHigh; ty++) {
    for (let tx = 0; tx < tilesWide; tx++) {
      const tileIdx = startTile + ty * BG_COLS + tx;
      const srcX = (tileIdx % BG_COLS) * TILE;
      const srcY = Math.floor(tileIdx / BG_COLS) * TILE;

      for (let y = 0; y < TILE; y++) {
        for (let x = 0; x < TILE; x++) {
          const si = (srcY + y) * bgPNG.width + (srcX + x);
          const r = bgPNG.data[si * 4];
          const g = bgPNG.data[si * 4 + 1];
          const b = bgPNG.data[si * 4 + 2];
          const a = bgPNG.data[si * 4 + 3];

          for (let zy = 0; zy < ZOOM; zy++) {
            for (let zx = 0; zx < ZOOM; zx++) {
              const dx = tx * TILE * ZOOM + x * ZOOM + zx;
              const dy = ty * TILE * ZOOM + y * ZOOM + zy;
              const di = (dy * w + dx) * 4;
              png.data[di] = r; png.data[di+1] = g; png.data[di+2] = b; png.data[di+3] = a;
            }
          }
        }
      }
    }
  }

  fs.writeFileSync(path.join(OUT, filename), PNG.sync.write(png));
  console.log(`Saved ${filename} (${w}x${h})`);
}

renderZoomedBG(0, 16, 8, 'zoom_bg_0-127.png');
renderZoomedBG(128, 16, 8, 'zoom_bg_128-255.png');

console.log('Done');
