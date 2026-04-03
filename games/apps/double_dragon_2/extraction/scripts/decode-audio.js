#!/usr/bin/env node
/**
 * Decode OKI MSM6295 ADPCM audio samples from DD2 ROMs
 *
 * OKI MSM6295 format:
 * - ROM starts with a phrase table (8 entries x 8 bytes)
 * - Each phrase entry: [start_addr(3 bytes), end_addr(3 bytes), unused(2 bytes)]
 * - Audio data is 4-bit ADPCM at ~7.6kHz
 * - Each byte contains 2 samples (high nibble first)
 *
 * DD2 has 2 ADPCM ROMs:
 * - 26j6-0.bin: primary samples (punches, kicks, grunts)
 * - 26j7-0.bin: secondary samples (more effects)
 */

const fs = require('fs');
const path = require('path');

const outDir = path.join(__dirname, 'game-final', 'assets', 'audio');
fs.mkdirSync(outDir, { recursive: true });

// OKI ADPCM decode tables
const STEP_TABLE = [
  16, 17, 19, 21, 23, 25, 28, 31, 34, 37, 41, 45, 50, 55, 60, 66,
  73, 80, 88, 97, 107, 118, 130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
  337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876, 963, 1060, 1166, 1282, 1411, 1552
];

const INDEX_TABLE = [-1, -1, -1, -1, 2, 4, 6, 8];

function decodeADPCM(data, startAddr, endAddr) {
  const samples = [];
  let signal = 0;
  let step = 0;

  for (let addr = startAddr; addr <= endAddr; addr++) {
    const byte = data[addr];

    // High nibble first, then low nibble
    for (let nibbleIdx = 0; nibbleIdx < 2; nibbleIdx++) {
      const nibble = nibbleIdx === 0 ? (byte >> 4) & 0xF : byte & 0xF;

      const stepSize = STEP_TABLE[step];
      let diff = stepSize >> 3;
      if (nibble & 4) diff += stepSize;
      if (nibble & 2) diff += stepSize >> 1;
      if (nibble & 1) diff += stepSize >> 2;
      if (nibble & 8) diff = -diff;

      signal = Math.max(-2048, Math.min(2047, signal + diff));
      step = Math.max(0, Math.min(48, step + INDEX_TABLE[nibble & 7]));

      samples.push(signal);
    }
  }

  return samples;
}

// Generate WAV file from samples
function samplesToWav(samples, sampleRate) {
  const numSamples = samples.length;
  const byteRate = sampleRate * 2; // 16-bit mono
  const dataSize = numSamples * 2;
  const fileSize = 44 + dataSize;

  const buffer = Buffer.alloc(fileSize);

  // WAV header
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(fileSize - 8, 4);
  buffer.write('WAVE', 8);
  buffer.write('fmt ', 12);
  buffer.writeUInt32LE(16, 16);        // chunk size
  buffer.writeUInt16LE(1, 20);         // PCM format
  buffer.writeUInt16LE(1, 22);         // mono
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(byteRate, 28);
  buffer.writeUInt16LE(2, 32);         // block align
  buffer.writeUInt16LE(16, 34);        // bits per sample
  buffer.write('data', 36);
  buffer.writeUInt32LE(dataSize, 40);

  // Sample data (16-bit signed, scale from 12-bit to 16-bit)
  for (let i = 0; i < numSamples; i++) {
    const sample = Math.max(-32768, Math.min(32767, samples[i] * 16));
    buffer.writeInt16LE(sample, 44 + i * 2);
  }

  return buffer;
}

// Process each ADPCM ROM
for (const [romName, label] of [['26j6-0.bin', 'bank0'], ['26j7-0.bin', 'bank1']]) {
  const rom = fs.readFileSync(path.join(__dirname, romName));
  console.log(`\n=== ${romName} (${label}) ===`);
  console.log(`Size: ${rom.length} bytes`);
  console.log(`Header: '${rom.slice(0, 8).toString('ascii')}'`);

  // OKI MSM6295 phrase table: 8 entries at the start
  // Each entry: start_hi, start_mid, start_lo, end_hi, end_mid, end_lo, unused, unused
  const phrases = [];
  for (let i = 0; i < 128; i++) { // Try up to 128 phrases
    const off = i * 8;
    if (off + 7 >= rom.length) break;

    const startAddr = (rom[off] << 16) | (rom[off + 1] << 8) | rom[off + 2];
    const endAddr = (rom[off + 3] << 16) | (rom[off + 4] << 8) | rom[off + 5];

    // Valid phrase: start < end, both within ROM, reasonable size
    if (startAddr > 0 && endAddr > startAddr && endAddr < rom.length && (endAddr - startAddr) > 10) {
      phrases.push({ index: i, startAddr, endAddr, size: endAddr - startAddr });
    }
  }

  console.log(`Found ${phrases.length} valid phrases`);

  // Decode and save each phrase as WAV
  const SAMPLE_RATE = 7575; // OKI MSM6295 typical rate for DD2

  for (const phrase of phrases) {
    const samples = decodeADPCM(rom, phrase.startAddr, phrase.endAddr);
    if (samples.length < 100) continue; // skip tiny/empty phrases

    const wav = samplesToWav(samples, SAMPLE_RATE);
    const filename = `${label}_${phrase.index.toString().padStart(3, '0')}.wav`;
    fs.writeFileSync(path.join(outDir, filename), wav);

    const durationMs = Math.round(samples.length / SAMPLE_RATE * 1000);
    console.log(`  Phrase ${phrase.index}: ${phrase.startAddr.toString(16)}-${phrase.endAddr.toString(16)} = ${samples.length} samples (${durationMs}ms) -> ${filename}`);
  }
}

console.log('\nAudio extraction complete!');
console.log('Output: ' + outDir);
