#!/usr/bin/env node
/**
 * Z80 Disassembler for Double Dragon 2 arcade ROM files
 * Handles all Z80 opcodes including CB, DD, ED, FD prefixed instructions
 */

const fs = require('fs');
const path = require('path');

// ─── Opcode Tables ───────────────────────────────────────────────────────────

const R8 = ['B','C','D','E','H','L','(HL)','A'];
const R16 = ['BC','DE','HL','SP'];
const R16AF = ['BC','DE','HL','AF'];
const CC = ['NZ','Z','NC','C','PO','PE','P','M'];
const ALU = ['ADD A,','ADC A,','SUB ','SBC A,','AND ','XOR ','OR ','CP '];
const ROT = ['RLC','RRC','RL','RR','SLA','SRA','SLL','SRL']; // SLL is undocumented

function hex8(v) { return v.toString(16).toUpperCase().padStart(2, '0'); }
function hex16(v) { return v.toString(16).toUpperCase().padStart(4, '0'); }
function hexAddr(v) { return hex16(v) + 'h'; }
function signedByte(b) { return b < 128 ? b : b - 256; }

class Z80Disassembler {
  constructor(rom, baseAddr = 0x0000) {
    this.rom = rom;
    this.baseAddr = baseAddr;
    this.pc = 0;
    this.labels = new Map();      // addr -> label name
    this.references = new Set();  // addresses that are referenced as targets
    this.instructions = [];       // {addr, bytes, mnemonic, size, isData}
    this.codeRegions = new Set(); // addresses known to be code
    this.dataRegions = new Set(); // addresses known to be data
    this.visited = new Set();     // addresses already disassembled
  }

  read8() {
    if (this.pc >= this.rom.length) return 0;
    return this.rom[this.pc++];
  }

  peek8(offset) {
    const addr = this.pc + (offset || 0);
    if (addr >= this.rom.length) return 0;
    return this.rom[addr];
  }

  read16() {
    const lo = this.read8();
    const hi = this.read8();
    return (hi << 8) | lo;
  }

  readDisp() {
    const b = this.read8();
    return signedByte(b);
  }

  addReference(addr, type) {
    if (addr >= this.baseAddr && addr < this.baseAddr + this.rom.length) {
      this.references.add(addr);
      if (!this.labels.has(addr)) {
        const prefix = type === 'call' ? 'sub_' : 'loc_';
        this.labels.set(addr, prefix + hex16(addr));
      }
    }
  }

  formatDisp(d) {
    if (d >= 0) return '+' + hex8(d) + 'h';
    return '-' + hex8(-d) + 'h';
  }

  labelOrHex(addr) {
    if (this.labels.has(addr)) return this.labels.get(addr);
    return hexAddr(addr);
  }

  // ─── CB prefix (bit operations) ──────────────────────────────────────────
  disasmCB() {
    const op = this.read8();
    const y = (op >> 3) & 7;
    const z = op & 7;

    if (op < 0x40) {
      return ROT[y] + ' ' + R8[z];
    } else if (op < 0x80) {
      return 'BIT ' + y + ',' + R8[z];
    } else if (op < 0xC0) {
      return 'RES ' + y + ',' + R8[z];
    } else {
      return 'SET ' + y + ',' + R8[z];
    }
  }

  // ─── DDCB / FDCB prefix (bit ops with IX/IY+d) ──────────────────────────
  disasmXXCB(reg) {
    const d = this.readDisp();
    const op = this.read8();
    const y = (op >> 3) & 7;
    const z = op & 7;
    const mem = '(' + reg + this.formatDisp(d) + ')';

    // For z!=6, there's an undocumented store to register
    const store = (z !== 6) ? ',' + R8[z] : '';

    if (op < 0x40) {
      if (z === 6) return ROT[y] + ' ' + mem;
      return ROT[y] + ' ' + mem + store; // undocumented
    } else if (op < 0x80) {
      return 'BIT ' + y + ',' + mem; // BIT always uses (IX+d)
    } else if (op < 0xC0) {
      if (z === 6) return 'RES ' + y + ',' + mem;
      return 'RES ' + y + ',' + mem + store; // undocumented
    } else {
      if (z === 6) return 'SET ' + y + ',' + mem;
      return 'SET ' + y + ',' + mem + store; // undocumented
    }
  }

  // ─── ED prefix ───────────────────────────────────────────────────────────
  disasmED() {
    const op = this.read8();

    // Block operations and other ED instructions
    const edTable = {
      0x40: 'IN B,(C)', 0x41: 'OUT (C),B', 0x42: 'SBC HL,BC', 0x43: null, // LD (nn),BC
      0x44: 'NEG', 0x45: 'RETN', 0x46: 'IM 0', 0x47: 'LD I,A',
      0x48: 'IN C,(C)', 0x49: 'OUT (C),C', 0x4A: 'ADC HL,BC', 0x4B: null, // LD BC,(nn)
      0x4C: 'NEG', 0x4D: 'RETI', 0x4E: 'IM 0', 0x4F: 'LD R,A',
      0x50: 'IN D,(C)', 0x51: 'OUT (C),D', 0x52: 'SBC HL,DE', 0x53: null, // LD (nn),DE
      0x54: 'NEG', 0x55: 'RETN', 0x56: 'IM 1', 0x57: 'LD A,I',
      0x58: 'IN E,(C)', 0x59: 'OUT (C),E', 0x5A: 'ADC HL,DE', 0x5B: null, // LD DE,(nn)
      0x5C: 'NEG', 0x5D: 'RETN', 0x5E: 'IM 2', 0x5F: 'LD A,R',
      0x60: 'IN H,(C)', 0x61: 'OUT (C),H', 0x62: 'SBC HL,HL', 0x63: null, // LD (nn),HL
      0x64: 'NEG', 0x65: 'RETN', 0x66: 'IM 0', 0x67: 'RRD',
      0x68: 'IN L,(C)', 0x69: 'OUT (C),L', 0x6A: 'ADC HL,HL', 0x6B: null, // LD HL,(nn)
      0x6C: 'NEG', 0x6D: 'RETN', 0x6E: 'IM 0', 0x6F: 'RLD',
      0x70: 'IN (C)', 0x71: 'OUT (C),0', 0x72: 'SBC HL,SP', 0x73: null, // LD (nn),SP
      0x74: 'NEG', 0x75: 'RETN', 0x76: 'IM 1', 0x77: 'NOP',
      0x78: 'IN A,(C)', 0x79: 'OUT (C),A', 0x7A: 'ADC HL,SP', 0x7B: null, // LD SP,(nn)
      0x7C: 'NEG', 0x7D: 'RETN', 0x7E: 'IM 2', 0x7F: 'NOP',
      0xA0: 'LDI', 0xA1: 'CPI', 0xA2: 'INI', 0xA3: 'OUTI',
      0xA8: 'LDD', 0xA9: 'CPD', 0xAA: 'IND', 0xAB: 'OUTD',
      0xB0: 'LDIR', 0xB1: 'CPIR', 0xB2: 'INIR', 0xB3: 'OTIR',
      0xB8: 'LDDR', 0xB9: 'CPDR', 0xBA: 'INDR', 0xBB: 'OTDR',
    };

    // Instructions that load/store 16-bit register from/to (nn)
    if (op === 0x43) { const nn = this.read16(); return 'LD (' + hexAddr(nn) + '),BC'; }
    if (op === 0x4B) { const nn = this.read16(); return 'LD BC,(' + hexAddr(nn) + ')'; }
    if (op === 0x53) { const nn = this.read16(); return 'LD (' + hexAddr(nn) + '),DE'; }
    if (op === 0x5B) { const nn = this.read16(); return 'LD DE,(' + hexAddr(nn) + ')'; }
    if (op === 0x63) { const nn = this.read16(); return 'LD (' + hexAddr(nn) + '),HL'; }
    if (op === 0x6B) { const nn = this.read16(); return 'LD HL,(' + hexAddr(nn) + ')'; }
    if (op === 0x73) { const nn = this.read16(); return 'LD (' + hexAddr(nn) + '),SP'; }
    if (op === 0x7B) { const nn = this.read16(); return 'LD SP,(' + hexAddr(nn) + ')'; }

    if (edTable[op] !== undefined) return edTable[op];

    return 'DB EDh,' + hex8(op) + 'h'; // Unknown ED instruction
  }

  // ─── DD/FD prefix (IX/IY instructions) ───────────────────────────────────
  disasmDD_FD(prefix) {
    const reg = prefix === 0xDD ? 'IX' : 'IY';
    const regH = reg + 'H';
    const regL = reg + 'L';
    const op = this.read8();

    // DD CB / FD CB -> bit operations with displacement
    if (op === 0xCB) return this.disasmXXCB(reg);

    // Replace HL with IX/IY, H with IXH/IYH, L with IXL/IYL, (HL) with (IX+d)/(IY+d)
    // But only for instructions that actually use these

    // Helper to get register name with IX/IY substitution
    const r8ix = (idx) => {
      if (idx === 4) return regH;  // H -> IXH/IYH (undocumented)
      if (idx === 5) return regL;  // L -> IXL/IYL (undocumented)
      if (idx === 6) { // (HL) -> (IX+d)/(IY+d)
        const d = this.readDisp();
        return '(' + reg + this.formatDisp(d) + ')';
      }
      return R8[idx];
    };

    switch (op) {
      // LD rr,nn
      case 0x21: { const nn = this.read16(); return 'LD ' + reg + ',' + hexAddr(nn); }
      // LD (nn),IX/IY
      case 0x22: { const nn = this.read16(); return 'LD (' + hexAddr(nn) + '),' + reg; }
      // INC IX/IY
      case 0x23: return 'INC ' + reg;
      // INC IXH/IYH (undocumented)
      case 0x24: return 'INC ' + regH;
      // DEC IXH/IYH (undocumented)
      case 0x25: return 'DEC ' + regH;
      // LD IXH/IYH,n (undocumented)
      case 0x26: { const n = this.read8(); return 'LD ' + regH + ',' + hex8(n) + 'h'; }
      // ADD IX/IY,BC
      case 0x09: return 'ADD ' + reg + ',BC';
      // ADD IX/IY,DE
      case 0x19: return 'ADD ' + reg + ',DE';
      // ADD IX/IY,IX/IY
      case 0x29: return 'ADD ' + reg + ',' + reg;
      // LD IX/IY,(nn)
      case 0x2A: { const nn = this.read16(); return 'LD ' + reg + ',(' + hexAddr(nn) + ')'; }
      // DEC IX/IY
      case 0x2B: return 'DEC ' + reg;
      // INC IXL/IYL (undocumented)
      case 0x2C: return 'INC ' + regL;
      // DEC IXL/IYL (undocumented)
      case 0x2D: return 'DEC ' + regL;
      // LD IXL/IYL,n (undocumented)
      case 0x2E: { const n = this.read8(); return 'LD ' + regL + ',' + hex8(n) + 'h'; }
      // INC (IX+d)/(IY+d)
      case 0x34: { const d = this.readDisp(); return 'INC (' + reg + this.formatDisp(d) + ')'; }
      // DEC (IX+d)/(IY+d)
      case 0x35: { const d = this.readDisp(); return 'DEC (' + reg + this.formatDisp(d) + ')'; }
      // LD (IX+d),n
      case 0x36: { const d = this.readDisp(); const n = this.read8(); return 'LD (' + reg + this.formatDisp(d) + '),' + hex8(n) + 'h'; }
      // ADD IX/IY,SP
      case 0x39: return 'ADD ' + reg + ',SP';
      // EX (SP),IX/IY
      case 0xE3: return 'EX (SP),' + reg;
      // PUSH IX/IY
      case 0xE5: return 'PUSH ' + reg;
      // JP (IX)/(IY)
      case 0xE9: return 'JP (' + reg + ')';
      // LD SP,IX/IY
      case 0xF9: return 'LD SP,' + reg;
      // POP IX/IY
      case 0xE1: return 'POP ' + reg;
    }

    // LD r,(IX+d) -- 0x46, 0x4E, 0x56, 0x5E, 0x66, 0x6E, 0x7E
    if ((op & 0xC0) === 0x40) {
      const y = (op >> 3) & 7;
      const z = op & 7;

      if (z === 6 && y !== 6) {
        // LD r,(IX+d)
        const d = this.readDisp();
        return 'LD ' + R8[y] + ',(' + reg + this.formatDisp(d) + ')';
      }
      if (y === 6 && z !== 6) {
        // LD (IX+d),r
        const d = this.readDisp();
        return 'LD (' + reg + this.formatDisp(d) + '),' + R8[z];
      }
      if (y === 6 && z === 6) {
        return 'HALT'; // Not replaced
      }
      // Undocumented: LD IXH,IXL etc.
      const src = (z === 4) ? regH : (z === 5) ? regL : R8[z];
      const dst = (y === 4) ? regH : (y === 5) ? regL : R8[y];
      if (src === R8[z] && dst === R8[y]) {
        // No IX/IY involvement, treat as normal LD
        return 'LD ' + dst + ',' + src;
      }
      return 'LD ' + dst + ',' + src;
    }

    // ALU A,(IX+d) or ALU A,IXH/IXL
    if ((op & 0xC0) === 0x80) {
      const y = (op >> 3) & 7;
      const z = op & 7;
      return ALU[y] + r8ix(z);
    }

    // Anything else with DD/FD prefix that doesn't use IX/IY
    // These are effectively NOPs of the prefix, just execute the base opcode
    // We need to "un-read" the opcode and disassemble it normally
    // But for simplicity, let's show it as DB DD/FD + the instruction
    this.pc--; // back up
    return 'DB ' + hex8(prefix) + 'h ; prefix (nop)';
  }

  // ─── Main opcode decode ──────────────────────────────────────────────────
  disasmOne() {
    const startPC = this.pc;
    const op = this.read8();

    let mnemonic;
    let isTerminal = false; // true if this instruction ends a basic block
    let isConditional = false;

    const x = (op >> 6) & 3;
    const y = (op >> 3) & 7;
    const z = op & 7;
    const p = (y >> 1) & 3;
    const q = y & 1;

    switch (op) {
      // ── Prefixes ──
      case 0xCB: mnemonic = this.disasmCB(); break;
      case 0xDD: mnemonic = this.disasmDD_FD(0xDD); break;
      case 0xED: mnemonic = this.disasmED(); break;
      case 0xFD: mnemonic = this.disasmDD_FD(0xFD); break;

      // ── Special single-byte ──
      case 0x00: mnemonic = 'NOP'; break;
      case 0x02: mnemonic = 'LD (BC),A'; break;
      case 0x07: mnemonic = 'RLCA'; break;
      case 0x08: mnemonic = "EX AF,AF'"; break;
      case 0x0A: mnemonic = 'LD A,(BC)'; break;
      case 0x0F: mnemonic = 'RRCA'; break;
      case 0x12: mnemonic = 'LD (DE),A'; break;
      case 0x17: mnemonic = 'RLA'; break;
      case 0x1A: mnemonic = 'LD A,(DE)'; break;
      case 0x1F: mnemonic = 'RRA'; break;
      case 0x27: mnemonic = 'DAA'; break;
      case 0x2F: mnemonic = 'CPL'; break;
      case 0x37: mnemonic = 'SCF'; break;
      case 0x3F: mnemonic = 'CCF'; break;
      case 0x76: mnemonic = 'HALT'; isTerminal = true; break;
      case 0xC9: mnemonic = 'RET'; isTerminal = true; break;
      case 0xD9: mnemonic = 'EXX'; break;
      case 0xE3: mnemonic = 'EX (SP),HL'; break;
      case 0xE9: mnemonic = 'JP (HL)'; isTerminal = true; break;
      case 0xEB: mnemonic = 'EX DE,HL'; break;
      case 0xF3: mnemonic = 'DI'; break;
      case 0xF9: mnemonic = 'LD SP,HL'; break;
      case 0xFB: mnemonic = 'EI'; break;

      default:
        // ── Systematic decode ──
        if (x === 0) {
          switch (z) {
            case 0:
              if (y === 0) { mnemonic = 'NOP'; }
              else if (y === 1) { mnemonic = "EX AF,AF'"; }
              else if (y === 2) {
                const d = this.readDisp();
                const target = this.baseAddr + this.pc + d;
                this.addReference(target, 'jump');
                mnemonic = 'DJNZ ' + this.labelOrHex(target);
              }
              else if (y === 3) {
                const d = this.readDisp();
                const target = this.baseAddr + this.pc + d;
                this.addReference(target, 'jump');
                mnemonic = 'JR ' + this.labelOrHex(target);
                isTerminal = true;
              }
              else {
                // JR cc,d (y=4..7 -> NZ,Z,NC,C)
                const d = this.readDisp();
                const target = this.baseAddr + this.pc + d;
                this.addReference(target, 'jump');
                mnemonic = 'JR ' + CC[y - 4] + ',' + this.labelOrHex(target);
                isConditional = true;
              }
              break;
            case 1:
              if (q === 0) {
                const nn = this.read16();
                mnemonic = 'LD ' + R16[p] + ',' + hexAddr(nn);
              } else {
                mnemonic = 'ADD HL,' + R16[p];
              }
              break;
            case 2:
              if (q === 0) {
                if (p === 0) mnemonic = 'LD (BC),A';
                else if (p === 1) mnemonic = 'LD (DE),A';
                else if (p === 2) { const nn = this.read16(); mnemonic = 'LD (' + hexAddr(nn) + '),HL'; }
                else { const nn = this.read16(); mnemonic = 'LD (' + hexAddr(nn) + '),A'; }
              } else {
                if (p === 0) mnemonic = 'LD A,(BC)';
                else if (p === 1) mnemonic = 'LD A,(DE)';
                else if (p === 2) { const nn = this.read16(); mnemonic = 'LD HL,(' + hexAddr(nn) + ')'; }
                else { const nn = this.read16(); mnemonic = 'LD A,(' + hexAddr(nn) + ')'; }
              }
              break;
            case 3:
              mnemonic = (q === 0 ? 'INC ' : 'DEC ') + R16[p];
              break;
            case 4:
              mnemonic = 'INC ' + R8[y];
              break;
            case 5:
              mnemonic = 'DEC ' + R8[y];
              break;
            case 6: {
              const n = this.read8();
              mnemonic = 'LD ' + R8[y] + ',' + hex8(n) + 'h';
              break;
            }
            case 7:
              // Already handled RLCA, RRCA, RLA, RRA, DAA, CPL, SCF, CCF above
              break;
          }
        }
        else if (x === 1) {
          // LD r,r' (0x76 = HALT already handled)
          mnemonic = 'LD ' + R8[y] + ',' + R8[z];
        }
        else if (x === 2) {
          // ALU A,r
          mnemonic = ALU[y] + R8[z];
        }
        else if (x === 3) {
          switch (z) {
            case 0:
              // RET cc
              mnemonic = 'RET ' + CC[y];
              isConditional = true;
              break;
            case 1:
              if (q === 0) {
                mnemonic = 'POP ' + R16AF[p];
              } else {
                if (p === 0) { mnemonic = 'RET'; isTerminal = true; }
                else if (p === 1) { mnemonic = 'EXX'; }
                else if (p === 2) { mnemonic = 'JP (HL)'; isTerminal = true; }
                else { mnemonic = 'LD SP,HL'; }
              }
              break;
            case 2: {
              // JP cc,nn
              const nn = this.read16();
              this.addReference(nn, 'jump');
              mnemonic = 'JP ' + CC[y] + ',' + this.labelOrHex(nn);
              isConditional = true;
              break;
            }
            case 3:
              if (y === 0) {
                const nn = this.read16();
                this.addReference(nn, 'jump');
                mnemonic = 'JP ' + this.labelOrHex(nn);
                isTerminal = true;
              }
              else if (y === 1) { /* CB prefix - handled above */ }
              else if (y === 2) {
                const n = this.read8();
                mnemonic = 'OUT (' + hex8(n) + 'h),A';
              }
              else if (y === 3) {
                const n = this.read8();
                mnemonic = 'IN A,(' + hex8(n) + 'h)';
              }
              else if (y === 4) { mnemonic = 'EX (SP),HL'; }
              else if (y === 5) { mnemonic = 'EX DE,HL'; }
              else if (y === 6) { mnemonic = 'DI'; }
              else if (y === 7) { mnemonic = 'EI'; }
              break;
            case 4: {
              // CALL cc,nn
              const nn = this.read16();
              this.addReference(nn, 'call');
              mnemonic = 'CALL ' + CC[y] + ',' + this.labelOrHex(nn);
              isConditional = true;
              break;
            }
            case 5:
              if (q === 0) {
                mnemonic = 'PUSH ' + R16AF[p];
              } else {
                if (p === 0) {
                  const nn = this.read16();
                  this.addReference(nn, 'call');
                  mnemonic = 'CALL ' + this.labelOrHex(nn);
                } else if (p === 1) { /* DD prefix */ }
                else if (p === 2) { /* ED prefix */ }
                else { /* FD prefix */ }
              }
              break;
            case 6: {
              // ALU A,n
              const n = this.read8();
              mnemonic = ALU[y] + hex8(n) + 'h';
              break;
            }
            case 7:
              // RST
              mnemonic = 'RST ' + hex8(y * 8) + 'h';
              this.addReference(y * 8, 'call');
              break;
          }
        }
        break;
    }

    if (!mnemonic) mnemonic = 'DB ' + hex8(op) + 'h';

    const endPC = this.pc;
    const bytes = [];
    for (let i = startPC; i < endPC; i++) {
      bytes.push(this.rom[i]);
    }

    return {
      addr: this.baseAddr + startPC,
      bytes,
      mnemonic,
      size: endPC - startPC,
      isTerminal,
      isConditional,
    };
  }

  // ─── Code tracing (recursive descent) ───────────────────────────────────
  traceCode(entryPoints) {
    const queue = [...entryPoints];

    // Add RST vectors and common entry points
    for (let i = 0; i < 0x40; i += 8) {
      if (i < this.rom.length) queue.push(i);
    }
    // NMI vector at 0x66
    if (0x66 < this.rom.length) queue.push(0x66);

    while (queue.length > 0) {
      const addr = queue.shift();
      const offset = addr - this.baseAddr;

      if (offset < 0 || offset >= this.rom.length) continue;
      if (this.visited.has(addr)) continue;

      this.pc = offset;
      this.visited.add(addr);

      while (this.pc < this.rom.length) {
        const currentAddr = this.baseAddr + this.pc;
        if (this.visited.has(currentAddr) && currentAddr !== addr) break;
        this.visited.add(currentAddr);
        this.codeRegions.add(currentAddr);

        const inst = this.disasmOne();

        if (inst.isTerminal) break;
        if (inst.isConditional) {
          // Continue to next instruction, but also add the branch target
          // Branch targets are already added via addReference
        }
      }
    }

    // Add all referenced addresses to the queue for another pass
    for (const ref of this.references) {
      if (!this.visited.has(ref)) {
        queue.push(ref);
      }
    }

    // Second pass for newly discovered targets
    while (queue.length > 0) {
      const addr = queue.shift();
      const offset = addr - this.baseAddr;
      if (offset < 0 || offset >= this.rom.length) continue;
      if (this.codeRegions.has(addr)) continue;

      this.pc = offset;

      while (this.pc < this.rom.length) {
        const currentAddr = this.baseAddr + this.pc;
        if (this.codeRegions.has(currentAddr) && currentAddr !== addr) break;
        this.codeRegions.add(currentAddr);

        const inst = this.disasmOne();
        if (inst.isTerminal) break;
      }
    }
  }

  // ─── Linear disassembly pass ─────────────────────────────────────────────
  disassembleLinear() {
    // First pass: trace from entry point to discover code regions and collect labels
    this.traceCode([this.baseAddr]);

    // Second pass: linear disassembly of entire ROM
    this.pc = 0;
    this.instructions = [];
    const processed = new Set();

    while (this.pc < this.rom.length) {
      const currentAddr = this.baseAddr + this.pc;

      if (processed.has(currentAddr)) {
        this.pc++;
        continue;
      }

      // Check for long runs of 0x00 or 0xFF (likely data/padding)
      const isLikelyPadding = () => {
        if (this.pc + 8 > this.rom.length) return false;
        const b = this.rom[this.pc];
        if (b !== 0x00 && b !== 0xFF) return false;
        let count = 0;
        for (let i = this.pc; i < Math.min(this.pc + 16, this.rom.length); i++) {
          if (this.rom[i] === b) count++;
          else break;
        }
        return count >= 8 && !this.references.has(currentAddr);
      };

      if (isLikelyPadding() && !this.codeRegions.has(currentAddr)) {
        // Emit as data bytes
        const b = this.rom[this.pc];
        let count = 0;
        const startAddr = currentAddr;
        while (this.pc < this.rom.length && this.rom[this.pc] === b &&
               !this.references.has(this.baseAddr + this.pc) && count < 16) {
          count++;
          this.pc++;
        }
        // Continue collecting same bytes if they're not referenced
        while (this.pc < this.rom.length && this.rom[this.pc] === b &&
               !this.references.has(this.baseAddr + this.pc)) {
          count++;
          this.pc++;
        }

        const bytes = new Array(Math.min(count, 4)).fill(b);
        this.instructions.push({
          addr: startAddr,
          bytes,
          mnemonic: 'DB ' + hex8(b) + 'h' + (count > 1 ? ' ; x' + count : ''),
          size: count,
          isData: true,
        });
        continue;
      }

      const inst = this.disasmOne();
      // Update label references in the mnemonic with final label names
      for (let i = inst.addr; i < inst.addr + inst.size; i++) {
        processed.add(i);
      }
      this.instructions.push(inst);
    }
  }

  // ─── Format output ──────────────────────────────────────────────────────
  format() {
    // Re-resolve all label references in mnemonics
    // We need a final pass because labels may have been added after first disassembly
    const lines = [];

    lines.push('; Z80 Disassembly');
    lines.push('; Generated by disasmZ80.js');
    lines.push('; ROM size: ' + this.rom.length + ' bytes');
    lines.push(';');
    lines.push('');

    for (const inst of this.instructions) {
      // Add label if this address is referenced
      if (this.labels.has(inst.addr)) {
        lines.push('');
        lines.push(this.labels.get(inst.addr) + ':');
      }

      const addrStr = hex16(inst.addr);
      let bytesStr;
      if (inst.isData && inst.size > 4) {
        bytesStr = inst.bytes.map(hex8).join(' ') + '...';
      } else {
        bytesStr = inst.bytes.map(hex8).join(' ');
      }
      // Pad bytes column to align mnemonics
      const padBytes = bytesStr.padEnd(14);

      lines.push(addrStr + ': ' + padBytes + inst.mnemonic);
    }

    return lines.join('\n') + '\n';
  }

  // ─── Main entry ──────────────────────────────────────────────────────────
  disassemble() {
    // Pass 1: trace code and collect labels
    this.traceCode([this.baseAddr]);

    // Reset for final pass
    this.pc = 0;
    this.instructions = [];
    this.visited.clear();

    // Pass 2: final linear disassembly with all labels known
    // Reset references tracking but keep labels
    const savedLabels = new Map(this.labels);
    const savedRefs = new Set(this.references);

    this.disassembleLinear();

    // Merge labels
    for (const [k, v] of savedLabels) {
      if (!this.labels.has(k)) this.labels.set(k, v);
    }
    for (const r of savedRefs) this.references.add(r);

    // Final pass: re-disassemble with all labels
    this.pc = 0;
    this.instructions = [];
    const finalLabels = new Map(this.labels);
    const finalRefs = new Set(this.references);

    // Reset and redo
    this.labels = finalLabels;
    this.references = finalRefs;

    this.pc = 0;
    this.instructions = [];
    const processed = new Set();

    while (this.pc < this.rom.length) {
      const currentAddr = this.baseAddr + this.pc;
      if (processed.has(currentAddr)) { this.pc++; continue; }

      // Padding detection
      const b = this.rom[this.pc];
      if ((b === 0x00 || b === 0xFF) && !this.references.has(currentAddr) && !this.codeRegions.has(currentAddr)) {
        let count = 0;
        const startPC = this.pc;
        while (this.pc < this.rom.length && this.rom[this.pc] === b &&
               !this.references.has(this.baseAddr + this.pc + (count > 0 ? 0 : -1)) &&
               !(count > 0 && this.references.has(this.baseAddr + this.pc))) {
          if (count > 0 && this.references.has(this.baseAddr + this.pc)) break;
          count++;
          this.pc++;
        }
        if (count >= 8) {
          const bytes = [];
          for (let i = 0; i < Math.min(count, 4); i++) bytes.push(b);
          this.instructions.push({
            addr: this.baseAddr + startPC,
            bytes,
            mnemonic: 'DB ' + hex8(b) + 'h' + (count > 1 ? ' ; x' + count : ''),
            size: count,
            isData: true,
          });
          for (let i = startPC; i < startPC + count; i++) processed.add(this.baseAddr + i);
          continue;
        } else {
          this.pc = startPC; // revert, disassemble normally
        }
      }

      const inst = this.disasmOne();
      for (let i = 0; i < inst.size; i++) processed.add(inst.addr + i);
      this.instructions.push(inst);
    }

    return this.format();
  }
}

// ─── CLI ───────────────────────────────────────────────────────────────────

function main() {
  const args = process.argv.slice(2);

  if (args.length < 1) {
    console.log('Usage: node disasmZ80.js <romfile> [output] [baseaddr]');
    console.log('  baseaddr is in hex, default 0000');
    process.exit(1);
  }

  const romFile = args[0];
  const outFile = args[1] || romFile.replace(/\.bin$/, '.asm');
  const baseAddr = parseInt(args[2] || '0', 16);

  console.log('Loading ROM: ' + romFile);
  const rom = fs.readFileSync(romFile);
  console.log('ROM size: ' + rom.length + ' bytes');
  console.log('Base address: ' + hex16(baseAddr) + 'h');

  const disasm = new Z80Disassembler(rom, baseAddr);
  const output = disasm.disassemble();

  const outDir = path.dirname(outFile);
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  fs.writeFileSync(outFile, output);
  console.log('Output written to: ' + outFile);
  console.log('Labels found: ' + disasm.labels.size);
  console.log('Code regions: ' + disasm.codeRegions.size + ' bytes');
}

main();
