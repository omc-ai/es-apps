#!/usr/bin/env node
'use strict';

/**
 * Motorola 6809 / Hitachi HD6309 Disassembler
 * Comprehensive disassembler for 6809 CPU ROM files.
 *
 * Usage: node disasm6809.js <romfile> <base_address_hex> [output_file]
 */

const fs = require('fs');
const path = require('path');

// ─── Register names ───────────────────────────────────────────────
const REG_PAIR = ['D', 'X', 'Y', 'U', 'S', 'PC', '?', '?',
                  'A', 'B', 'CC', 'DP', '?', '?', '?', '?'];

const IDX_REG = ['X', 'Y', 'U', 'S'];

const TFR_EXG_REG = ['D', 'X', 'Y', 'U', 'S', 'PC', '?', '?',
                      'A', 'B', 'CC', 'DP', '?', '?', '?', '?'];

const PUSH_PULL_REGS_S = ['CC', 'A', 'B', 'DP', 'X', 'Y', 'U', 'PC'];
const PUSH_PULL_REGS_U = ['CC', 'A', 'B', 'DP', 'X', 'Y', 'S', 'PC'];

// ─── Addressing mode types ────────────────────────────────────────
const AM = {
  INH: 'inherent',
  IMM8: 'immediate8',
  IMM16: 'immediate16',
  DIR: 'direct',
  EXT: 'extended',
  IDX: 'indexed',
  REL8: 'relative8',
  REL16: 'relative16',
};

// ─── Page 1 opcodes (no prefix) ──────────────────────────────────
const PAGE1 = {
  0x00: ['NEG', AM.DIR],
  0x03: ['COM', AM.DIR],
  0x04: ['LSR', AM.DIR],
  0x06: ['ROR', AM.DIR],
  0x07: ['ASR', AM.DIR],
  0x08: ['ASL', AM.DIR],
  0x09: ['ROL', AM.DIR],
  0x0A: ['DEC', AM.DIR],
  0x0C: ['INC', AM.DIR],
  0x0D: ['TST', AM.DIR],
  0x0E: ['JMP', AM.DIR],
  0x0F: ['CLR', AM.DIR],

  0x12: ['NOP', AM.INH],
  0x13: ['SYNC', AM.INH],
  0x16: ['LBRA', AM.REL16],
  0x17: ['LBSR', AM.REL16],
  0x19: ['DAA', AM.INH],
  0x1A: ['ORCC', AM.IMM8],
  0x1C: ['ANDCC', AM.IMM8],
  0x1D: ['SEX', AM.INH],
  0x1E: ['EXG', AM.IMM8],
  0x1F: ['TFR', AM.IMM8],

  0x20: ['BRA', AM.REL8],
  0x21: ['BRN', AM.REL8],
  0x22: ['BHI', AM.REL8],
  0x23: ['BLS', AM.REL8],
  0x24: ['BCC', AM.REL8],
  0x25: ['BCS', AM.REL8],
  0x26: ['BNE', AM.REL8],
  0x27: ['BEQ', AM.REL8],
  0x28: ['BVC', AM.REL8],
  0x29: ['BVS', AM.REL8],
  0x2A: ['BPL', AM.REL8],
  0x2B: ['BMI', AM.REL8],
  0x2C: ['BGE', AM.REL8],
  0x2D: ['BLT', AM.REL8],
  0x2E: ['BGT', AM.REL8],
  0x2F: ['BLE', AM.REL8],

  0x30: ['LEAX', AM.IDX],
  0x31: ['LEAY', AM.IDX],
  0x32: ['LEAS', AM.IDX],
  0x33: ['LEAU', AM.IDX],
  0x34: ['PSHS', AM.IMM8],
  0x35: ['PULS', AM.IMM8],
  0x36: ['PSHU', AM.IMM8],
  0x37: ['PULU', AM.IMM8],
  0x39: ['RTS', AM.INH],
  0x3A: ['ABX', AM.INH],
  0x3B: ['RTI', AM.INH],
  0x3C: ['CWAI', AM.IMM8],
  0x3D: ['MUL', AM.INH],
  0x3F: ['SWI', AM.INH],

  0x40: ['NEGA', AM.INH],
  0x43: ['COMA', AM.INH],
  0x44: ['LSRA', AM.INH],
  0x46: ['RORA', AM.INH],
  0x47: ['ASRA', AM.INH],
  0x48: ['ASLA', AM.INH],
  0x49: ['ROLA', AM.INH],
  0x4A: ['DECA', AM.INH],
  0x4C: ['INCA', AM.INH],
  0x4D: ['TSTA', AM.INH],
  0x4F: ['CLRA', AM.INH],

  0x50: ['NEGB', AM.INH],
  0x53: ['COMB', AM.INH],
  0x54: ['LSRB', AM.INH],
  0x56: ['RORB', AM.INH],
  0x57: ['ASRB', AM.INH],
  0x58: ['ASLB', AM.INH],
  0x59: ['ROLB', AM.INH],
  0x5A: ['DECB', AM.INH],
  0x5C: ['INCB', AM.INH],
  0x5D: ['TSTB', AM.INH],
  0x5F: ['CLRB', AM.INH],

  0x60: ['NEG', AM.IDX],
  0x63: ['COM', AM.IDX],
  0x64: ['LSR', AM.IDX],
  0x66: ['ROR', AM.IDX],
  0x67: ['ASR', AM.IDX],
  0x68: ['ASL', AM.IDX],
  0x69: ['ROL', AM.IDX],
  0x6A: ['DEC', AM.IDX],
  0x6C: ['INC', AM.IDX],
  0x6D: ['TST', AM.IDX],
  0x6E: ['JMP', AM.IDX],
  0x6F: ['CLR', AM.IDX],

  0x70: ['NEG', AM.EXT],
  0x73: ['COM', AM.EXT],
  0x74: ['LSR', AM.EXT],
  0x76: ['ROR', AM.EXT],
  0x77: ['ASR', AM.EXT],
  0x78: ['ASL', AM.EXT],
  0x79: ['ROL', AM.EXT],
  0x7A: ['DEC', AM.EXT],
  0x7C: ['INC', AM.EXT],
  0x7D: ['TST', AM.EXT],
  0x7E: ['JMP', AM.EXT],
  0x7F: ['CLR', AM.EXT],

  0x80: ['SUBA', AM.IMM8],
  0x81: ['CMPA', AM.IMM8],
  0x82: ['SBCA', AM.IMM8],
  0x83: ['SUBD', AM.IMM16],
  0x84: ['ANDA', AM.IMM8],
  0x85: ['BITA', AM.IMM8],
  0x86: ['LDA', AM.IMM8],
  0x88: ['EORA', AM.IMM8],
  0x89: ['ADCA', AM.IMM8],
  0x8A: ['ORA', AM.IMM8],
  0x8B: ['ADDA', AM.IMM8],
  0x8C: ['CMPX', AM.IMM16],
  0x8D: ['BSR', AM.REL8],
  0x8E: ['LDX', AM.IMM16],

  0x90: ['SUBA', AM.DIR],
  0x91: ['CMPA', AM.DIR],
  0x92: ['SBCA', AM.DIR],
  0x93: ['SUBD', AM.DIR],
  0x94: ['ANDA', AM.DIR],
  0x95: ['BITA', AM.DIR],
  0x96: ['LDA', AM.DIR],
  0x97: ['STA', AM.DIR],
  0x98: ['EORA', AM.DIR],
  0x99: ['ADCA', AM.DIR],
  0x9A: ['ORA', AM.DIR],
  0x9B: ['ADDA', AM.DIR],
  0x9C: ['CMPX', AM.DIR],
  0x9D: ['JSR', AM.DIR],
  0x9E: ['LDX', AM.DIR],
  0x9F: ['STX', AM.DIR],

  0xA0: ['SUBA', AM.IDX],
  0xA1: ['CMPA', AM.IDX],
  0xA2: ['SBCA', AM.IDX],
  0xA3: ['SUBD', AM.IDX],
  0xA4: ['ANDA', AM.IDX],
  0xA5: ['BITA', AM.IDX],
  0xA6: ['LDA', AM.IDX],
  0xA7: ['STA', AM.IDX],
  0xA8: ['EORA', AM.IDX],
  0xA9: ['ADCA', AM.IDX],
  0xAA: ['ORA', AM.IDX],
  0xAB: ['ADDA', AM.IDX],
  0xAC: ['CMPX', AM.IDX],
  0xAD: ['JSR', AM.IDX],
  0xAE: ['LDX', AM.IDX],
  0xAF: ['STX', AM.IDX],

  0xB0: ['SUBA', AM.EXT],
  0xB1: ['CMPA', AM.EXT],
  0xB2: ['SBCA', AM.EXT],
  0xB3: ['SUBD', AM.EXT],
  0xB4: ['ANDA', AM.EXT],
  0xB5: ['BITA', AM.EXT],
  0xB6: ['LDA', AM.EXT],
  0xB7: ['STA', AM.EXT],
  0xB8: ['EORA', AM.EXT],
  0xB9: ['ADCA', AM.EXT],
  0xBA: ['ORA', AM.EXT],
  0xBB: ['ADDA', AM.EXT],
  0xBC: ['CMPX', AM.EXT],
  0xBD: ['JSR', AM.EXT],
  0xBE: ['LDX', AM.EXT],
  0xBF: ['STX', AM.EXT],

  0xC0: ['SUBB', AM.IMM8],
  0xC1: ['CMPB', AM.IMM8],
  0xC2: ['SBCB', AM.IMM8],
  0xC3: ['ADDD', AM.IMM16],
  0xC4: ['ANDB', AM.IMM8],
  0xC5: ['BITB', AM.IMM8],
  0xC6: ['LDB', AM.IMM8],
  0xC8: ['EORB', AM.IMM8],
  0xC9: ['ADCB', AM.IMM8],
  0xCA: ['ORB', AM.IMM8],
  0xCB: ['ADDB', AM.IMM8],
  0xCC: ['LDD', AM.IMM16],
  0xCE: ['LDU', AM.IMM16],

  0xD0: ['SUBB', AM.DIR],
  0xD1: ['CMPB', AM.DIR],
  0xD2: ['SBCB', AM.DIR],
  0xD3: ['ADDD', AM.DIR],
  0xD4: ['ANDB', AM.DIR],
  0xD5: ['BITB', AM.DIR],
  0xD6: ['LDB', AM.DIR],
  0xD7: ['STB', AM.DIR],
  0xD8: ['EORB', AM.DIR],
  0xD9: ['ADCB', AM.DIR],
  0xDA: ['ORB', AM.DIR],
  0xDB: ['ADDB', AM.DIR],
  0xDC: ['LDD', AM.DIR],
  0xDD: ['STD', AM.DIR],
  0xDE: ['LDU', AM.DIR],
  0xDF: ['STU', AM.DIR],

  0xE0: ['SUBB', AM.IDX],
  0xE1: ['CMPB', AM.IDX],
  0xE2: ['SBCB', AM.IDX],
  0xE3: ['ADDD', AM.IDX],
  0xE4: ['ANDB', AM.IDX],
  0xE5: ['BITB', AM.IDX],
  0xE6: ['LDB', AM.IDX],
  0xE7: ['STB', AM.IDX],
  0xE8: ['EORB', AM.IDX],
  0xE9: ['ADCB', AM.IDX],
  0xEA: ['ORB', AM.IDX],
  0xEB: ['ADDB', AM.IDX],
  0xEC: ['LDD', AM.IDX],
  0xED: ['STD', AM.IDX],
  0xEE: ['LDU', AM.IDX],
  0xEF: ['STU', AM.IDX],

  0xF0: ['SUBB', AM.EXT],
  0xF1: ['CMPB', AM.EXT],
  0xF2: ['SBCB', AM.EXT],
  0xF3: ['ADDD', AM.EXT],
  0xF4: ['ANDB', AM.EXT],
  0xF5: ['BITB', AM.EXT],
  0xF6: ['LDB', AM.EXT],
  0xF7: ['STB', AM.EXT],
  0xF8: ['EORB', AM.EXT],
  0xF9: ['ADCB', AM.EXT],
  0xFA: ['ORB', AM.EXT],
  0xFB: ['ADDB', AM.EXT],
  0xFC: ['LDD', AM.EXT],
  0xFD: ['STD', AM.EXT],
  0xFE: ['LDU', AM.EXT],
  0xFF: ['STU', AM.EXT],
};

// ─── Page 2 opcodes (0x10 prefix) ────────────────────────────────
const PAGE2 = {
  0x21: ['LBRN', AM.REL16],
  0x22: ['LBHI', AM.REL16],
  0x23: ['LBLS', AM.REL16],
  0x24: ['LBCC', AM.REL16],
  0x25: ['LBCS', AM.REL16],
  0x26: ['LBNE', AM.REL16],
  0x27: ['LBEQ', AM.REL16],
  0x28: ['LBVC', AM.REL16],
  0x29: ['LBVS', AM.REL16],
  0x2A: ['LBPL', AM.REL16],
  0x2B: ['LBMI', AM.REL16],
  0x2C: ['LBGE', AM.REL16],
  0x2D: ['LBLT', AM.REL16],
  0x2E: ['LBGT', AM.REL16],
  0x2F: ['LBLE', AM.REL16],
  0x3F: ['SWI2', AM.INH],
  0x83: ['CMPD', AM.IMM16],
  0x8C: ['CMPY', AM.IMM16],
  0x8E: ['LDY', AM.IMM16],
  0x93: ['CMPD', AM.DIR],
  0x9C: ['CMPY', AM.DIR],
  0x9E: ['LDY', AM.DIR],
  0x9F: ['STY', AM.DIR],
  0xA3: ['CMPD', AM.IDX],
  0xAC: ['CMPY', AM.IDX],
  0xAE: ['LDY', AM.IDX],
  0xAF: ['STY', AM.IDX],
  0xB3: ['CMPD', AM.EXT],
  0xBC: ['CMPY', AM.EXT],
  0xBE: ['LDY', AM.EXT],
  0xBF: ['STY', AM.EXT],
  0xCE: ['LDS', AM.IMM16],
  0xDE: ['LDS', AM.DIR],
  0xDF: ['STS', AM.DIR],
  0xEE: ['LDS', AM.IDX],
  0xEF: ['STS', AM.IDX],
  0xFE: ['LDS', AM.EXT],
  0xFF: ['STS', AM.EXT],
};

// ─── Page 3 opcodes (0x11 prefix) ────────────────────────────────
const PAGE3 = {
  0x3F: ['SWI3', AM.INH],
  0x83: ['CMPU', AM.IMM16],
  0x8C: ['CMPS', AM.IMM16],
  0x93: ['CMPU', AM.DIR],
  0x9C: ['CMPS', AM.DIR],
  0xA3: ['CMPU', AM.IDX],
  0xAC: ['CMPS', AM.IDX],
  0xB3: ['CMPU', AM.EXT],
  0xBC: ['CMPS', AM.EXT],
};

// ─── Helpers ──────────────────────────────────────────────────────

function hex8(v) {
  return ('00' + (v & 0xFF).toString(16).toUpperCase()).slice(-2);
}

function hex16(v) {
  if (v > 0xFFFF) {
    return v.toString(16).toUpperCase();
  }
  return ('0000' + (v & 0xFFFF).toString(16).toUpperCase()).slice(-4);
}

function signed8(v) {
  return v > 127 ? v - 256 : v;
}

function signed16(v) {
  return v > 32767 ? v - 65536 : v;
}

function signed5(v) {
  return v > 15 ? v - 32 : v;
}

function formatPushPullRegs(postbyte, isU) {
  const regs = isU ? PUSH_PULL_REGS_U : PUSH_PULL_REGS_S;
  const list = [];
  for (let i = 0; i < 8; i++) {
    if (postbyte & (1 << i)) {
      list.push(regs[i]);
    }
  }
  return list.join(',');
}

function formatTfrExg(postbyte) {
  const src = (postbyte >> 4) & 0x0F;
  const dst = postbyte & 0x0F;
  return TFR_EXG_REG[src] + ',' + TFR_EXG_REG[dst];
}

// ─── Disassembler ─────────────────────────────────────────────────

class Disassembler {
  constructor(data, baseAddr) {
    this.data = data;
    this.base = baseAddr;
    this.pc = 0;
    this.labels = new Set();       // addresses that are branch/jump targets
    this.instructions = [];        // pass 1 results
  }

  read8() {
    if (this.pc >= this.data.length) return 0;
    return this.data[this.pc++];
  }

  read16() {
    const hi = this.read8();
    const lo = this.read8();
    return (hi << 8) | lo;
  }

  addr() {
    return this.base + this.pc;
  }

  decodeIndexed() {
    const postbyte = this.read8();
    const bytes = [postbyte];
    let operand = '';

    if (!(postbyte & 0x80)) {
      // 5-bit offset, ,R
      const reg = IDX_REG[(postbyte >> 5) & 0x03];
      const offset = signed5(postbyte & 0x1F);
      if (offset === 0) {
        operand = `,${reg}`;
      } else {
        operand = `${offset},${reg}`;
      }
      return { operand, bytes, target: null };
    }

    const reg = IDX_REG[(postbyte >> 5) & 0x03];
    const indirect = !!(postbyte & 0x10);
    const mode = postbyte & 0x0F;

    switch (mode) {
      case 0x00: // ,R+
        operand = `,${reg}+`;
        break;
      case 0x01: // ,R++
        operand = `,${reg}++`;
        break;
      case 0x02: // ,-R
        operand = `,-${reg}`;
        break;
      case 0x03: // ,--R
        operand = `,--${reg}`;
        break;
      case 0x04: // ,R (no offset)
        operand = `,${reg}`;
        break;
      case 0x05: // B,R
        operand = `B,${reg}`;
        break;
      case 0x06: // A,R
        operand = `A,${reg}`;
        break;
      case 0x08: { // n8,R
        const off = this.read8();
        bytes.push(off);
        const s = signed8(off);
        operand = `${s},${reg}`;
        break;
      }
      case 0x09: { // n16,R
        const hi = this.read8();
        const lo = this.read8();
        bytes.push(hi, lo);
        const off16 = signed16((hi << 8) | lo);
        operand = `${off16},${reg}`;
        break;
      }
      case 0x0B: // D,R
        operand = `D,${reg}`;
        break;
      case 0x0C: { // n8,PCR
        const off = this.read8();
        bytes.push(off);
        const s = signed8(off);
        const target = this.addr() + s;
        this.labels.add(target);
        operand = `$${hex16(target)},PCR`;
        return { operand: indirect ? `[${operand}]` : operand, bytes, target };
      }
      case 0x0D: { // n16,PCR
        const hi = this.read8();
        const lo = this.read8();
        bytes.push(hi, lo);
        const off16 = signed16((hi << 8) | lo);
        const target = this.addr() + off16;
        this.labels.add(target);
        operand = `$${hex16(target)},PCR`;
        return { operand: indirect ? `[${operand}]` : operand, bytes, target };
      }
      case 0x0F: { // [n16] (extended indirect, only valid with indirect bit)
        const hi = this.read8();
        const lo = this.read8();
        bytes.push(hi, lo);
        const addr16 = (hi << 8) | lo;
        operand = `$${hex16(addr16)}`;
        return { operand: `[${operand}]`, bytes, target: null };
      }
      default:
        operand = `???`;
        break;
    }

    if (indirect && mode !== 0x00 && mode !== 0x02) {
      operand = `[${operand}]`;
    }

    return { operand, bytes, target: null };
  }

  // Pass 1: decode all instructions, collect labels
  pass1() {
    this.pc = 0;
    this.instructions = [];

    while (this.pc < this.data.length) {
      const startPC = this.pc;
      const startAddr = this.base + startPC;
      let opcode = this.read8();
      const rawBytes = [opcode];
      let table = PAGE1;
      let prefix = null;

      // Check for page prefixes
      if (opcode === 0x10) {
        prefix = 0x10;
        opcode = this.read8();
        rawBytes.push(opcode);
        table = PAGE2;
      } else if (opcode === 0x11) {
        prefix = 0x11;
        opcode = this.read8();
        rawBytes.push(opcode);
        table = PAGE3;
      }

      const entry = table[opcode];

      if (!entry) {
        // Unknown opcode - emit as data byte
        this.instructions.push({
          addr: startAddr,
          bytes: prefix !== null ? rawBytes : [rawBytes[0]],
          mnemonic: 'FCB',
          operandStr: prefix !== null
            ? rawBytes.map(b => '$' + hex8(b)).join(',')
            : '$' + hex8(rawBytes[0]),
          target: null,
          isData: true,
        });
        // If we consumed a prefix byte for an invalid opcode, we already read 2 bytes.
        // Back up the second byte if the prefix+opcode was invalid, so the second byte
        // gets its own chance. Actually, both bytes are already consumed. For prefixed
        // unknown opcodes, emit all consumed bytes as data.
        continue;
      }

      const [mnemonic, mode] = entry;
      let operandStr = '';
      let target = null;
      let extraBytes = [];

      switch (mode) {
        case AM.INH:
          break;

        case AM.IMM8: {
          const val = this.read8();
          extraBytes.push(val);
          if (mnemonic === 'EXG' || mnemonic === 'TFR') {
            operandStr = formatTfrExg(val);
          } else if (mnemonic === 'PSHS' || mnemonic === 'PULS') {
            operandStr = formatPushPullRegs(val, false);
          } else if (mnemonic === 'PSHU' || mnemonic === 'PULU') {
            operandStr = formatPushPullRegs(val, true);
          } else {
            operandStr = '#$' + hex8(val);
          }
          break;
        }

        case AM.IMM16: {
          const val = this.read16();
          extraBytes.push((val >> 8) & 0xFF, val & 0xFF);
          operandStr = '#$' + hex16(val);
          break;
        }

        case AM.DIR: {
          const val = this.read8();
          extraBytes.push(val);
          operandStr = '<$' + hex8(val);
          break;
        }

        case AM.EXT: {
          const val = this.read16();
          extraBytes.push((val >> 8) & 0xFF, val & 0xFF);
          operandStr = '$' + hex16(val);
          if (mnemonic === 'JMP' || mnemonic === 'JSR') {
            target = val;
            this.labels.add(target);
          }
          break;
        }

        case AM.IDX: {
          const result = this.decodeIndexed();
          operandStr = result.operand;
          extraBytes = result.bytes;
          target = result.target;
          break;
        }

        case AM.REL8: {
          const off = this.read8();
          extraBytes.push(off);
          target = this.addr() + signed8(off);
          if (this.base <= 0xFFFF) target = target & 0xFFFF;
          this.labels.add(target);
          operandStr = '$' + hex16(target);
          break;
        }

        case AM.REL16: {
          const off = this.read16();
          extraBytes.push((off >> 8) & 0xFF, off & 0xFF);
          target = this.addr() + signed16(off);
          if (this.base <= 0xFFFF) target = target & 0xFFFF;
          this.labels.add(target);
          operandStr = '$' + hex16(target);
          break;
        }
      }

      const allBytes = [...rawBytes, ...extraBytes];

      this.instructions.push({
        addr: startAddr,
        bytes: allBytes,
        mnemonic,
        operandStr,
        target,
        isData: false,
      });
    }
  }

  // Pass 2: generate output with labels
  pass2() {
    const lines = [];
    const addrEnd = this.base + this.data.length;

    lines.push(`; Disassembly of ROM file`);
    lines.push(`; Base address: $${hex16(this.base)}`);
    lines.push(`; Size: ${this.data.length} bytes (${(this.data.length / 1024).toFixed(0)}KB)`);
    lines.push(`; Generated by disasm6809.js`);
    lines.push(`;`);
    lines.push(`        ORG     $${hex16(this.base)}`);
    lines.push('');

    for (const inst of this.instructions) {
      // Check if this address is a label target
      if (this.labels.has(inst.addr)) {
        lines.push(`L${hex16(inst.addr)}:`);
      }

      const hexStr = inst.bytes.map(b => hex8(b)).join(' ');
      const addrStr = hex16(inst.addr);

      // Format: ADDR: HEXBYTES    MNEMONIC OPERAND
      const hexPad = hexStr.padEnd(14);
      let asmStr;
      if (inst.operandStr) {
        asmStr = `${inst.mnemonic.padEnd(8)}${inst.operandStr}`;
      } else {
        asmStr = inst.mnemonic;
      }

      lines.push(`${addrStr}: ${hexPad} ${asmStr}`);
    }

    // Add vectors comment at the end for the main ROM
    if (this.base === 0x8000 && this.data.length === 0x8000) {
      lines.push('');
      lines.push('; ─── Interrupt Vectors ───');
      const vectors = [
        [0xFFF2, 'SWI3'],
        [0xFFF4, 'SWI2'],
        [0xFFF6, 'FIRQ'],
        [0xFFF8, 'IRQ'],
        [0xFFFA, 'SWI'],
        [0xFFFC, 'NMI'],
        [0xFFFE, 'RESET'],
      ];
      for (const [vecAddr, vecName] of vectors) {
        const offset = vecAddr - this.base;
        if (offset >= 0 && offset + 1 < this.data.length) {
          const hi = this.data[offset];
          const lo = this.data[offset + 1];
          const target = (hi << 8) | lo;
          lines.push(`; ${hex16(vecAddr)}: ${vecName} vector -> $${hex16(target)}`);
        }
      }
    }

    return lines.join('\n') + '\n';
  }

  disassemble() {
    this.pass1();
    return this.pass2();
  }
}

// ─── Main ─────────────────────────────────────────────────────────

function main() {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error('Usage: node disasm6809.js <romfile> <base_address_hex> [output_file]');
    console.error('Example: node disasm6809.js 26a9-04.bin 8000 output/main-cpu.asm');
    process.exit(1);
  }

  const romFile = args[0];
  const baseAddr = parseInt(args[1], 16);
  const outputFile = args[2] || null;

  if (isNaN(baseAddr)) {
    console.error(`Invalid base address: ${args[1]}`);
    process.exit(1);
  }

  let data;
  try {
    data = fs.readFileSync(romFile);
  } catch (err) {
    console.error(`Error reading ${romFile}: ${err.message}`);
    process.exit(1);
  }

  console.error(`Disassembling ${romFile} (${data.length} bytes, base $${hex16(baseAddr)})...`);

  const disasm = new Disassembler(data, baseAddr);
  const output = disasm.disassemble();

  console.error(`Found ${disasm.instructions.length} instructions/data bytes`);
  console.error(`Found ${disasm.labels.size} labels`);

  if (outputFile) {
    const dir = path.dirname(outputFile);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(outputFile, output);
    console.error(`Output written to ${outputFile}`);
  } else {
    process.stdout.write(output);
  }
}

main();
