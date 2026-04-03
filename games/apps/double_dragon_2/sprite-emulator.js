#!/usr/bin/env node
/**
 * HD6309/6809 CPU Emulator - Double Dragon 2 Sprite Rendering Path
 *
 * Extracts sprite compositions by running the arcade's rendering pipeline:
 *   1. Animation handler (table $8B36) - sets entity tile data per anim state
 *   2. Render setup ($C8B6) - configures sprite type per anim state
 *   3. Sprite renderer ($C80F) - writes to intermediate buffers
 *   4. Flush ($44F1) - copies buffers to sprite hardware
 *
 * The buffer at $0C5C captures 16x16 sprite entries:
 *   [dest_hi, dest_lo, attr_byte, tile_lo] per 4-byte entry
 * Where attr_byte encodes color (bits 7-5) and tile_hi (bits 4-0)
 * after a 4-bit left rotation, and tile_lo is the tile number low byte.
 */

const fs = require('fs');
const path = require('path');

const ROM_DIR = __dirname;
const MAIN_ROM = path.join(ROM_DIR, '26a9-04.bin');
const BANK_ROM = path.join(ROM_DIR, '26aa-03.bin');
const OUTPUT_DIR = path.join(ROM_DIR, 'output');
const MAX_INSTRUCTIONS = 15000;
const ENTITY_BASE = 0x0300;

const mainRom = fs.readFileSync(MAIN_ROM);
const bankRom = fs.readFileSync(BANK_ROM);

// =====================================================================
// Minimal 6809 CPU (all opcodes needed for the rendering path)
// =====================================================================
class CPU6809 {
  constructor() {
    this.A = 0; this.B = 0; this.X = 0; this.Y = 0; this.U = 0; this.S = 0;
    this.PC = 0; this.DP = 0; this.CC = 0;
    this.mem = new Uint8Array(65536);
    this.bankEnabled = false;
    this.bankRomData = null; this.mainRomData = null;
    this.instrCount = 0; this.halted = false;
    this.unmapped = new Set();
  }
  get CC_C(){return this.CC&1} get CC_V(){return(this.CC>>1)&1}
  get CC_Z(){return(this.CC>>2)&1} get CC_N(){return(this.CC>>3)&1}
  sCC(f,v){const b={C:0,V:1,Z:2,N:3,I:4,H:5,F:6,E:7};if(v)this.CC|=(1<<b[f]);else this.CC&=~(1<<b[f])}
  get D(){return(this.A<<8)|this.B} set D(v){v&=0xFFFF;this.A=(v>>8)&0xFF;this.B=v&0xFF}
  read8(a){a&=0xFFFF;if(a>=0x4000&&a<0x8000&&this.bankEnabled&&this.bankRomData)return this.bankRomData[a-0x4000]||0;if(a>=0x8000&&this.mainRomData)return this.mainRomData[a-0x8000]||0;return this.mem[a]}
  read16(a){return(this.read8(a)<<8)|this.read8(a+1)}
  write8(a,v){a&=0xFFFF;v&=0xFF;if(a===0x3808){this.bankEnabled=!!(v&0x20);this.mem[a]=v;return}if(a>=0x8000)return;if(a>=0x4000&&a<0x8000&&this.bankEnabled)return;this.mem[a]=v}
  write16(a,v){this.write8(a,(v>>8)&0xFF);this.write8(a+1,v&0xFF)}
  f8(){const v=this.read8(this.PC);this.PC=(this.PC+1)&0xFFFF;return v}
  f16(){const v=this.read16(this.PC);this.PC=(this.PC+2)&0xFFFF;return v}
  pS8(v){this.S=(this.S-1)&0xFFFF;this.write8(this.S,v)}
  pS16(v){this.pS8(v&0xFF);this.pS8((v>>8)&0xFF)}
  oS8(){const v=this.read8(this.S);this.S=(this.S+1)&0xFFFF;return v}
  oS16(){return(this.oS8()<<8)|this.oS8()}
  pU8(v){this.U=(this.U-1)&0xFFFF;this.write8(this.U,v)}
  pU16(v){this.pU8(v&0xFF);this.pU8((v>>8)&0xFF)}
  oU8(){const v=this.read8(this.U);this.U=(this.U+1)&0xFFFF;return v}
  oU16(){return(this.oU8()<<8)|this.oU8()}
  aD(){return((this.DP<<8)|this.f8())&0xFFFF}
  aE(){return this.f16()}
  se8(v){v&=0xFF;return v>=0x80?v-0x100:v}
  se16(v){v&=0xFFFF;return v>=0x8000?v-0x10000:v}
  gIR(c){return[this.X,this.Y,this.U,this.S][c]}
  sIR(c,v){v&=0xFFFF;switch(c){case 0:this.X=v;break;case 1:this.Y=v;break;case 2:this.U=v;break;case 3:this.S=v;break}}
  aI(){
    const pb=this.f8(),reg=(pb>>5)&3;
    if(!(pb&0x80)){let o=pb&0x1F;if(o&0x10)o|=0xFFF0;return(this.gIR(reg)+((o<<16)>>16))&0xFFFF}
    const ind=!!(pb&0x10),t=pb&0x0F;let a=0;
    switch(t){
      case 0:a=this.gIR(reg);this.sIR(reg,a+1);return a&0xFFFF;
      case 1:a=this.gIR(reg);this.sIR(reg,a+2);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 2:this.sIR(reg,this.gIR(reg)-1);return this.gIR(reg)&0xFFFF;
      case 3:this.sIR(reg,this.gIR(reg)-2);a=this.gIR(reg);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 4:a=this.gIR(reg);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 5:a=this.gIR(reg)+this.se8(this.B);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 6:a=this.gIR(reg)+this.se8(this.A);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 8:{const o=this.se8(this.f8());a=this.gIR(reg)+o;return ind?this.read16(a&0xFFFF):a&0xFFFF}
      case 9:{const o=this.se16(this.f16());a=this.gIR(reg)+o;return ind?this.read16(a&0xFFFF):a&0xFFFF}
      case 0xB:a=this.gIR(reg)+this.se16(this.D);return ind?this.read16(a&0xFFFF):a&0xFFFF;
      case 0xC:{const o=this.se8(this.f8());a=this.PC+o;return ind?this.read16(a&0xFFFF):a&0xFFFF}
      case 0xD:{const o=this.se16(this.f16());a=this.PC+o;return ind?this.read16(a&0xFFFF):a&0xFFFF}
      case 0xF:if(ind){a=this.f16();return this.read16(a)}break;
    }
    return 0;
  }
  nz8(v){v&=0xFF;this.sCC('N',v&0x80);this.sCC('Z',v===0);return v}
  nz16(v){v&=0xFFFF;this.sCC('N',v&0x8000);this.sCC('Z',v===0);return v}
  gR(c){switch(c){case 0:return this.D;case 1:return this.X;case 2:return this.Y;case 3:return this.U;case 4:return this.S;case 5:return this.PC;case 8:return this.A;case 9:return this.B;case 0xA:return this.CC;case 0xB:return this.DP}return 0}
  sR(c,v){switch(c){case 0:this.D=v&0xFFFF;break;case 1:this.X=v&0xFFFF;break;case 2:this.Y=v&0xFFFF;break;case 3:this.U=v&0xFFFF;break;case 4:this.S=v&0xFFFF;break;case 5:this.PC=v&0xFFFF;break;case 8:this.A=v&0xFF;break;case 9:this.B=v&0xFF;break;case 0xA:this.CC=v&0xFF;break;case 0xB:this.DP=v&0xFF;break}}
  r16(c){return c<=5}
  pushR(pb,u){const p=u?this.pU8.bind(this):this.pS8.bind(this),p2=u?this.pU16.bind(this):this.pS16.bind(this);if(pb&0x80)p2(this.PC);if(pb&0x40)p2(u?this.S:this.U);if(pb&0x20)p2(this.Y);if(pb&0x10)p2(this.X);if(pb&8)p(this.DP);if(pb&4)p(this.B);if(pb&2)p(this.A);if(pb&1)p(this.CC)}
  pullR(pb,u){const p=u?this.oU8.bind(this):this.oS8.bind(this),p2=u?this.oU16.bind(this):this.oS16.bind(this);if(pb&1)this.CC=p();if(pb&2)this.A=p();if(pb&4)this.B=p();if(pb&8)this.DP=p();if(pb&0x10)this.X=p2();if(pb&0x20)this.Y=p2();if(pb&0x40){if(u)this.S=p2();else this.U=p2()}if(pb&0x80)this.PC=p2()}
  add8(a,b,c=0){const r=a+b+c,v=r&0xFF;this.sCC('C',r>0xFF);this.sCC('V',((a^b^0x80)&(a^v))&0x80);this.sCC('H',((a^b^v)&0x10)!==0);this.nz8(v);return v}
  sub8(a,b,c=0){const r=a-b-c,v=r&0xFF;this.sCC('C',r<0);this.sCC('V',((a^b)&(a^v))&0x80);this.nz8(v);return v}
  add16(a,b){const r=a+b,v=r&0xFFFF;this.sCC('C',r>0xFFFF);this.sCC('V',((a^b^0x8000)&(a^v))&0x8000);this.nz16(v);return v}
  sub16(a,b){const r=a-b,v=r&0xFFFF;this.sCC('C',r<0);this.sCC('V',((a^b)&(a^v))&0x8000);this.nz16(v);return v}
  _br(c){const o=this.se8(this.f8());if(c)this.PC=(this.PC+o)&0xFFFF}
  _lbr(c){const o=this.se16(this.f16());if(c)this.PC=(this.PC+o)&0xFFFF}
  _neg(v){const r=(-v)&0xFF;this.sCC('C',r!==0);this.sCC('V',r===0x80);return this.nz8(r)}
  _com(v){const r=(~v)&0xFF;this.sCC('C',1);this.sCC('V',0);return this.nz8(r)}
  _lsr(v){this.sCC('C',v&1);const r=(v>>1)&0xFF;this.sCC('N',0);this.sCC('Z',r===0);return r}
  _ror(v){const c=this.CC_C;this.sCC('C',v&1);return this.nz8(((v>>1)|(c<<7))&0xFF)}
  _asr(v){this.sCC('C',v&1);return this.nz8(((v>>1)|(v&0x80))&0xFF)}
  _asl(v){this.sCC('C',(v>>7)&1);const r=(v<<1)&0xFF;this.sCC('V',((v^r)>>7)&1);return this.nz8(r)}
  _rol(v){const c=this.CC_C;this.sCC('C',(v>>7)&1);const r=((v<<1)|c)&0xFF;this.sCC('V',((v^r)>>7)&1);return this.nz8(r)}
  _dec(v){const r=(v-1)&0xFF;this.sCC('V',v===0x80);return this.nz8(r)}
  _inc(v){const r=(v+1)&0xFF;this.sCC('V',v===0x7F);return this.nz8(r)}
  _tst(v){this.nz8(v);this.sCC('V',0)}
  _clr(){this.sCC('N',0);this.sCC('Z',1);this.sCC('V',0);this.sCC('C',0);return 0}

  step(){
    if(this.halted)return false;
    const op=this.f8();
    switch(op){
      case 0x12:break;case 0x13:this.halted=true;break;
      case 0x17:{const o=this.se16(this.f16());this.pS16(this.PC);this.PC=(this.PC+o)&0xFFFF;break} // LBSR
      case 0x3C:this.f8();this.halted=true;break;
      case 0x20:this._br(true);break;case 0x21:this._br(false);break;
      case 0x22:this._br(!this.CC_C&&!this.CC_Z);break;case 0x23:this._br(this.CC_C||this.CC_Z);break;
      case 0x24:this._br(!this.CC_C);break;case 0x25:this._br(!!this.CC_C);break;
      case 0x26:this._br(!this.CC_Z);break;case 0x27:this._br(!!this.CC_Z);break;
      case 0x28:this._br(!this.CC_V);break;case 0x29:this._br(!!this.CC_V);break;
      case 0x2A:this._br(!this.CC_N);break;case 0x2B:this._br(!!this.CC_N);break;
      case 0x2C:this._br(this.CC_N===this.CC_V);break;case 0x2D:this._br(this.CC_N!==this.CC_V);break;
      case 0x2E:this._br(!this.CC_Z&&(this.CC_N===this.CC_V));break;
      case 0x2F:this._br(this.CC_Z||(this.CC_N!==this.CC_V));break;
      case 0x30:this.X=this.aI();this.sCC('Z',this.X===0);break;
      case 0x31:this.Y=this.aI();this.sCC('Z',this.Y===0);break;
      case 0x32:this.S=this.aI();break;case 0x33:this.U=this.aI();break;
      case 0x34:this.pushR(this.f8(),false);break;case 0x35:this.pullR(this.f8(),false);break;
      case 0x36:this.pushR(this.f8(),true);break;case 0x37:this.pullR(this.f8(),true);break;
      case 0x39:this.PC=this.oS16();break;
      case 0x3A:this.X=(this.X+this.B)&0xFFFF;break;
      case 0x3B:{this.CC=this.oS8();if(this.CC&0x80){this.A=this.oS8();this.B=this.oS8();this.DP=this.oS8();this.X=this.oS16();this.Y=this.oS16();this.U=this.oS16()}this.PC=this.oS16();break}
      case 0x3D:{const r=this.A*this.B;this.D=r&0xFFFF;this.sCC('Z',this.D===0);this.sCC('C',this.B&0x80);break}
      case 0x3F:this.halted=true;break;
      case 0x40:this.A=this._neg(this.A);break;case 0x43:this.A=this._com(this.A);break;
      case 0x44:this.A=this._lsr(this.A);break;case 0x46:this.A=this._ror(this.A);break;
      case 0x47:this.A=this._asr(this.A);break;case 0x48:this.A=this._asl(this.A);break;
      case 0x49:this.A=this._rol(this.A);break;case 0x4A:this.A=this._dec(this.A);break;
      case 0x4C:this.A=this._inc(this.A);break;case 0x4D:this._tst(this.A);break;
      case 0x4F:this.A=this._clr();break;
      case 0x50:this.B=this._neg(this.B);break;case 0x53:this.B=this._com(this.B);break;
      case 0x54:this.B=this._lsr(this.B);break;case 0x56:this.B=this._ror(this.B);break;
      case 0x57:this.B=this._asr(this.B);break;case 0x58:this.B=this._asl(this.B);break;
      case 0x59:this.B=this._rol(this.B);break;case 0x5A:this.B=this._dec(this.B);break;
      case 0x5C:this.B=this._inc(this.B);break;case 0x5D:this._tst(this.B);break;
      case 0x5F:this.B=this._clr();break;
      case 0x60:{const a=this.aI();this.write8(a,this._neg(this.read8(a)));break}
      case 0x63:{const a=this.aI();this.write8(a,this._com(this.read8(a)));break}
      case 0x64:{const a=this.aI();this.write8(a,this._lsr(this.read8(a)));break}
      case 0x66:{const a=this.aI();this.write8(a,this._ror(this.read8(a)));break}
      case 0x67:{const a=this.aI();this.write8(a,this._asr(this.read8(a)));break}
      case 0x68:{const a=this.aI();this.write8(a,this._asl(this.read8(a)));break}
      case 0x69:{const a=this.aI();this.write8(a,this._rol(this.read8(a)));break}
      case 0x6A:{const a=this.aI();this.write8(a,this._dec(this.read8(a)));break}
      case 0x6C:{const a=this.aI();this.write8(a,this._inc(this.read8(a)));break}
      case 0x6D:{const a=this.aI();this._tst(this.read8(a));break}
      case 0x6E:this.PC=this.aI();break;
      case 0x6F:{const a=this.aI();this.write8(a,this._clr());break}
      case 0x70:{const a=this.aE();this.write8(a,this._neg(this.read8(a)));break}
      case 0x73:{const a=this.aE();this.write8(a,this._com(this.read8(a)));break}
      case 0x74:{const a=this.aE();this.write8(a,this._lsr(this.read8(a)));break}
      case 0x76:{const a=this.aE();this.write8(a,this._ror(this.read8(a)));break}
      case 0x77:{const a=this.aE();this.write8(a,this._asr(this.read8(a)));break}
      case 0x78:{const a=this.aE();this.write8(a,this._asl(this.read8(a)));break}
      case 0x79:{const a=this.aE();this.write8(a,this._rol(this.read8(a)));break}
      case 0x7A:{const a=this.aE();this.write8(a,this._dec(this.read8(a)));break}
      case 0x7C:{const a=this.aE();this.write8(a,this._inc(this.read8(a)));break}
      case 0x7D:{const a=this.aE();this._tst(this.read8(a));break}
      case 0x7E:this.PC=this.aE();break;
      case 0x7F:{const a=this.aE();this.write8(a,this._clr());break}
      case 0x00:{const a=this.aD();this.write8(a,this._neg(this.read8(a)));break}
      case 0x03:{const a=this.aD();this.write8(a,this._com(this.read8(a)));break}
      case 0x04:{const a=this.aD();this.write8(a,this._lsr(this.read8(a)));break}
      case 0x06:{const a=this.aD();this.write8(a,this._ror(this.read8(a)));break}
      case 0x07:{const a=this.aD();this.write8(a,this._asr(this.read8(a)));break}
      case 0x08:{const a=this.aD();this.write8(a,this._asl(this.read8(a)));break}
      case 0x09:{const a=this.aD();this.write8(a,this._rol(this.read8(a)));break}
      case 0x0A:{const a=this.aD();this.write8(a,this._dec(this.read8(a)));break}
      case 0x0C:{const a=this.aD();this.write8(a,this._inc(this.read8(a)));break}
      case 0x0D:{const a=this.aD();this._tst(this.read8(a));break}
      case 0x0E:this.PC=this.aD();break;
      case 0x0F:{const a=this.aD();this.write8(a,this._clr());break}
      // ALU A: SUB,CMP,SBC,SUBD,AND,BIT,LDA,STA,EOR,ADC,ORA,ADD
      case 0x80:this.A=this.sub8(this.A,this.f8());break;case 0x90:this.A=this.sub8(this.A,this.read8(this.aD()));break;
      case 0xA0:this.A=this.sub8(this.A,this.read8(this.aI()));break;case 0xB0:this.A=this.sub8(this.A,this.read8(this.aE()));break;
      case 0x81:this.sub8(this.A,this.f8());break;case 0x91:this.sub8(this.A,this.read8(this.aD()));break;
      case 0xA1:this.sub8(this.A,this.read8(this.aI()));break;case 0xB1:this.sub8(this.A,this.read8(this.aE()));break;
      case 0x82:this.A=this.sub8(this.A,this.f8(),this.CC_C);break;case 0x92:this.A=this.sub8(this.A,this.read8(this.aD()),this.CC_C);break;
      case 0xA2:this.A=this.sub8(this.A,this.read8(this.aI()),this.CC_C);break;case 0xB2:this.A=this.sub8(this.A,this.read8(this.aE()),this.CC_C);break;
      case 0x83:{const v=this.f16();this.D=this.sub16(this.D,v);break}case 0x93:{const v=this.read16(this.aD());this.D=this.sub16(this.D,v);break}
      case 0xA3:{const v=this.read16(this.aI());this.D=this.sub16(this.D,v);break}case 0xB3:{const v=this.read16(this.aE());this.D=this.sub16(this.D,v);break}
      case 0x84:this.A=this.nz8(this.A&this.f8());this.sCC('V',0);break;case 0x94:this.A=this.nz8(this.A&this.read8(this.aD()));this.sCC('V',0);break;
      case 0xA4:this.A=this.nz8(this.A&this.read8(this.aI()));this.sCC('V',0);break;case 0xB4:this.A=this.nz8(this.A&this.read8(this.aE()));this.sCC('V',0);break;
      case 0x85:this.nz8(this.A&this.f8());this.sCC('V',0);break;case 0x95:this.nz8(this.A&this.read8(this.aD()));this.sCC('V',0);break;
      case 0xA5:this.nz8(this.A&this.read8(this.aI()));this.sCC('V',0);break;case 0xB5:this.nz8(this.A&this.read8(this.aE()));this.sCC('V',0);break;
      case 0x86:this.A=this.nz8(this.f8());this.sCC('V',0);break;case 0x96:this.A=this.nz8(this.read8(this.aD()));this.sCC('V',0);break;
      case 0xA6:this.A=this.nz8(this.read8(this.aI()));this.sCC('V',0);break;case 0xB6:this.A=this.nz8(this.read8(this.aE()));this.sCC('V',0);break;
      case 0x97:{const a=this.aD();this.write8(a,this.A);this.nz8(this.A);this.sCC('V',0);break}
      case 0xA7:{const a=this.aI();this.write8(a,this.A);this.nz8(this.A);this.sCC('V',0);break}
      case 0xB7:{const a=this.aE();this.write8(a,this.A);this.nz8(this.A);this.sCC('V',0);break}
      case 0x88:this.A=this.nz8(this.A^this.f8());this.sCC('V',0);break;case 0x98:this.A=this.nz8(this.A^this.read8(this.aD()));this.sCC('V',0);break;
      case 0xA8:this.A=this.nz8(this.A^this.read8(this.aI()));this.sCC('V',0);break;case 0xB8:this.A=this.nz8(this.A^this.read8(this.aE()));this.sCC('V',0);break;
      case 0x89:this.A=this.add8(this.A,this.f8(),this.CC_C);break;case 0x99:this.A=this.add8(this.A,this.read8(this.aD()),this.CC_C);break;
      case 0xA9:this.A=this.add8(this.A,this.read8(this.aI()),this.CC_C);break;case 0xB9:this.A=this.add8(this.A,this.read8(this.aE()),this.CC_C);break;
      case 0x8A:this.A=this.nz8(this.A|this.f8());this.sCC('V',0);break;case 0x9A:this.A=this.nz8(this.A|this.read8(this.aD()));this.sCC('V',0);break;
      case 0xAA:this.A=this.nz8(this.A|this.read8(this.aI()));this.sCC('V',0);break;case 0xBA:this.A=this.nz8(this.A|this.read8(this.aE()));this.sCC('V',0);break;
      case 0x8B:this.A=this.add8(this.A,this.f8());break;case 0x9B:this.A=this.add8(this.A,this.read8(this.aD()));break;
      case 0xAB:this.A=this.add8(this.A,this.read8(this.aI()));break;case 0xBB:this.A=this.add8(this.A,this.read8(this.aE()));break;
      case 0x8C:this.sub16(this.X,this.f16());break;case 0x9C:this.sub16(this.X,this.read16(this.aD()));break;
      case 0xAC:this.sub16(this.X,this.read16(this.aI()));break;case 0xBC:this.sub16(this.X,this.read16(this.aE()));break;
      case 0x8D:{const o=this.se8(this.f8());this.pS16(this.PC);this.PC=(this.PC+o)&0xFFFF;break}
      case 0x9D:{const a=this.aD();this.pS16(this.PC);this.PC=a;break}
      case 0xAD:{const a=this.aI();this.pS16(this.PC);this.PC=a;break}
      case 0xBD:{const a=this.aE();this.pS16(this.PC);this.PC=a;break}
      case 0x8E:this.X=this.nz16(this.f16());this.sCC('V',0);break;case 0x9E:this.X=this.nz16(this.read16(this.aD()));this.sCC('V',0);break;
      case 0xAE:this.X=this.nz16(this.read16(this.aI()));this.sCC('V',0);break;case 0xBE:this.X=this.nz16(this.read16(this.aE()));this.sCC('V',0);break;
      case 0x9F:{const a=this.aD();this.write16(a,this.X);this.nz16(this.X);this.sCC('V',0);break}
      case 0xAF:{const a=this.aI();this.write16(a,this.X);this.nz16(this.X);this.sCC('V',0);break}
      case 0xBF:{const a=this.aE();this.write16(a,this.X);this.nz16(this.X);this.sCC('V',0);break}
      // ALU B
      case 0xC0:this.B=this.sub8(this.B,this.f8());break;case 0xD0:this.B=this.sub8(this.B,this.read8(this.aD()));break;
      case 0xE0:this.B=this.sub8(this.B,this.read8(this.aI()));break;case 0xF0:this.B=this.sub8(this.B,this.read8(this.aE()));break;
      case 0xC1:this.sub8(this.B,this.f8());break;case 0xD1:this.sub8(this.B,this.read8(this.aD()));break;
      case 0xE1:this.sub8(this.B,this.read8(this.aI()));break;case 0xF1:this.sub8(this.B,this.read8(this.aE()));break;
      case 0xC2:this.B=this.sub8(this.B,this.f8(),this.CC_C);break;case 0xD2:this.B=this.sub8(this.B,this.read8(this.aD()),this.CC_C);break;
      case 0xE2:this.B=this.sub8(this.B,this.read8(this.aI()),this.CC_C);break;case 0xF2:this.B=this.sub8(this.B,this.read8(this.aE()),this.CC_C);break;
      case 0xC3:{const v=this.f16();this.D=this.add16(this.D,v);break}case 0xD3:{const v=this.read16(this.aD());this.D=this.add16(this.D,v);break}
      case 0xE3:{const v=this.read16(this.aI());this.D=this.add16(this.D,v);break}case 0xF3:{const v=this.read16(this.aE());this.D=this.add16(this.D,v);break}
      case 0xC4:this.B=this.nz8(this.B&this.f8());this.sCC('V',0);break;case 0xD4:this.B=this.nz8(this.B&this.read8(this.aD()));this.sCC('V',0);break;
      case 0xE4:this.B=this.nz8(this.B&this.read8(this.aI()));this.sCC('V',0);break;case 0xF4:this.B=this.nz8(this.B&this.read8(this.aE()));this.sCC('V',0);break;
      case 0xC5:this.nz8(this.B&this.f8());this.sCC('V',0);break;case 0xD5:this.nz8(this.B&this.read8(this.aD()));this.sCC('V',0);break;
      case 0xE5:this.nz8(this.B&this.read8(this.aI()));this.sCC('V',0);break;case 0xF5:this.nz8(this.B&this.read8(this.aE()));this.sCC('V',0);break;
      case 0xC6:this.B=this.nz8(this.f8());this.sCC('V',0);break;case 0xD6:this.B=this.nz8(this.read8(this.aD()));this.sCC('V',0);break;
      case 0xE6:this.B=this.nz8(this.read8(this.aI()));this.sCC('V',0);break;case 0xF6:this.B=this.nz8(this.read8(this.aE()));this.sCC('V',0);break;
      case 0xD7:{const a=this.aD();this.write8(a,this.B);this.nz8(this.B);this.sCC('V',0);break}
      case 0xE7:{const a=this.aI();this.write8(a,this.B);this.nz8(this.B);this.sCC('V',0);break}
      case 0xF7:{const a=this.aE();this.write8(a,this.B);this.nz8(this.B);this.sCC('V',0);break}
      case 0xC8:this.B=this.nz8(this.B^this.f8());this.sCC('V',0);break;case 0xD8:this.B=this.nz8(this.B^this.read8(this.aD()));this.sCC('V',0);break;
      case 0xE8:this.B=this.nz8(this.B^this.read8(this.aI()));this.sCC('V',0);break;case 0xF8:this.B=this.nz8(this.B^this.read8(this.aE()));this.sCC('V',0);break;
      case 0xC9:this.B=this.add8(this.B,this.f8(),this.CC_C);break;case 0xD9:this.B=this.add8(this.B,this.read8(this.aD()),this.CC_C);break;
      case 0xE9:this.B=this.add8(this.B,this.read8(this.aI()),this.CC_C);break;case 0xF9:this.B=this.add8(this.B,this.read8(this.aE()),this.CC_C);break;
      case 0xCA:this.B=this.nz8(this.B|this.f8());this.sCC('V',0);break;case 0xDA:this.B=this.nz8(this.B|this.read8(this.aD()));this.sCC('V',0);break;
      case 0xEA:this.B=this.nz8(this.B|this.read8(this.aI()));this.sCC('V',0);break;case 0xFA:this.B=this.nz8(this.B|this.read8(this.aE()));this.sCC('V',0);break;
      case 0xCB:this.B=this.add8(this.B,this.f8());break;case 0xDB:this.B=this.add8(this.B,this.read8(this.aD()));break;
      case 0xEB:this.B=this.add8(this.B,this.read8(this.aI()));break;case 0xFB:this.B=this.add8(this.B,this.read8(this.aE()));break;
      case 0xCC:this.D=this.nz16(this.f16());this.sCC('V',0);break;case 0xDC:this.D=this.nz16(this.read16(this.aD()));this.sCC('V',0);break;
      case 0xEC:this.D=this.nz16(this.read16(this.aI()));this.sCC('V',0);break;case 0xFC:this.D=this.nz16(this.read16(this.aE()));this.sCC('V',0);break;
      case 0xDD:{const a=this.aD();this.write16(a,this.D);this.nz16(this.D);this.sCC('V',0);break}
      case 0xED:{const a=this.aI();this.write16(a,this.D);this.nz16(this.D);this.sCC('V',0);break}
      case 0xFD:{const a=this.aE();this.write16(a,this.D);this.nz16(this.D);this.sCC('V',0);break}
      case 0xCE:this.U=this.nz16(this.f16());this.sCC('V',0);break;case 0xDE:this.U=this.nz16(this.read16(this.aD()));this.sCC('V',0);break;
      case 0xEE:this.U=this.nz16(this.read16(this.aI()));this.sCC('V',0);break;case 0xFE:this.U=this.nz16(this.read16(this.aE()));this.sCC('V',0);break;
      case 0xDF:{const a=this.aD();this.write16(a,this.U);this.nz16(this.U);this.sCC('V',0);break}
      case 0xEF:{const a=this.aI();this.write16(a,this.U);this.nz16(this.U);this.sCC('V',0);break}
      case 0xFF:{const a=this.aE();this.write16(a,this.U);this.nz16(this.U);this.sCC('V',0);break}
      case 0x1F:{const pb=this.f8(),s=(pb>>4)&0xF,d=pb&0xF;let v=this.gR(s);if(this.r16(s)&&!this.r16(d))v=v&0xFF;else if(!this.r16(s)&&this.r16(d))v=0xFF00|(v&0xFF);this.sR(d,v);break}
      case 0x1E:{const pb=this.f8(),s=(pb>>4)&0xF,d=pb&0xF;const a=this.gR(s),b=this.gR(d);this.sR(s,b);this.sR(d,a);break}
      case 0x1C:this.CC&=this.f8();break;case 0x1A:this.CC|=this.f8();break;
      case 0x1D:{this.A=(this.B&0x80)?0xFF:0x00;this.nz16(this.D);this.sCC('V',0);break}
      case 0x10:this._p2();break;case 0x11:this._p3();break;
      default:if(!this.unmapped.has(op))this.unmapped.add(op);break;
    }
    this.instrCount++;return!this.halted;
  }
  _p2(){
    const op=this.f8();
    switch(op){
      case 0x20:this._lbr(true);break;case 0x21:this._lbr(false);break;
      case 0x22:this._lbr(!this.CC_C&&!this.CC_Z);break;case 0x23:this._lbr(this.CC_C||this.CC_Z);break;
      case 0x24:this._lbr(!this.CC_C);break;case 0x25:this._lbr(!!this.CC_C);break;
      case 0x26:this._lbr(!this.CC_Z);break;case 0x27:this._lbr(!!this.CC_Z);break;
      case 0x28:this._lbr(!this.CC_V);break;case 0x29:this._lbr(!!this.CC_V);break;
      case 0x2A:this._lbr(!this.CC_N);break;case 0x2B:this._lbr(!!this.CC_N);break;
      case 0x2C:this._lbr(this.CC_N===this.CC_V);break;case 0x2D:this._lbr(this.CC_N!==this.CC_V);break;
      case 0x2E:this._lbr(!this.CC_Z&&(this.CC_N===this.CC_V));break;
      case 0x2F:this._lbr(this.CC_Z||(this.CC_N!==this.CC_V));break;
      case 0x83:this.sub16(this.D,this.f16());break;case 0x93:this.sub16(this.D,this.read16(this.aD()));break;
      case 0xA3:this.sub16(this.D,this.read16(this.aI()));break;case 0xB3:this.sub16(this.D,this.read16(this.aE()));break;
      case 0x8C:this.sub16(this.Y,this.f16());break;case 0x9C:this.sub16(this.Y,this.read16(this.aD()));break;
      case 0xAC:this.sub16(this.Y,this.read16(this.aI()));break;case 0xBC:this.sub16(this.Y,this.read16(this.aE()));break;
      case 0x8E:this.Y=this.nz16(this.f16());this.sCC('V',0);break;case 0x9E:this.Y=this.nz16(this.read16(this.aD()));this.sCC('V',0);break;
      case 0xAE:this.Y=this.nz16(this.read16(this.aI()));this.sCC('V',0);break;case 0xBE:this.Y=this.nz16(this.read16(this.aE()));this.sCC('V',0);break;
      case 0x9F:{const a=this.aD();this.write16(a,this.Y);this.nz16(this.Y);this.sCC('V',0);break}
      case 0xAF:{const a=this.aI();this.write16(a,this.Y);this.nz16(this.Y);this.sCC('V',0);break}
      case 0xBF:{const a=this.aE();this.write16(a,this.Y);this.nz16(this.Y);this.sCC('V',0);break}
      case 0xCE:this.S=this.nz16(this.f16());this.sCC('V',0);break;case 0xDE:this.S=this.nz16(this.read16(this.aD()));this.sCC('V',0);break;
      case 0xEE:this.S=this.nz16(this.read16(this.aI()));this.sCC('V',0);break;case 0xFE:this.S=this.nz16(this.read16(this.aE()));this.sCC('V',0);break;
      case 0xDF:{const a=this.aD();this.write16(a,this.S);this.nz16(this.S);this.sCC('V',0);break}
      case 0xEF:{const a=this.aI();this.write16(a,this.S);this.nz16(this.S);this.sCC('V',0);break}
      case 0xFF:{const a=this.aE();this.write16(a,this.S);this.nz16(this.S);this.sCC('V',0);break}
      case 0x3F:this.halted=true;break;
      default:if(!this.unmapped.has(0x1000|op))this.unmapped.add(0x1000|op);break;
    }
  }
  _p3(){
    const op=this.f8();
    switch(op){
      case 0x83:this.sub16(this.U,this.f16());break;case 0x93:this.sub16(this.U,this.read16(this.aD()));break;
      case 0xA3:this.sub16(this.U,this.read16(this.aI()));break;case 0xB3:this.sub16(this.U,this.read16(this.aE()));break;
      case 0x8C:this.sub16(this.S,this.f16());break;case 0x9C:this.sub16(this.S,this.read16(this.aD()));break;
      case 0xAC:this.sub16(this.S,this.read16(this.aI()));break;case 0xBC:this.sub16(this.S,this.read16(this.aE()));break;
      case 0x3F:this.halted=true;break;
      default:if(!this.unmapped.has(0x1100|op))this.unmapped.add(0x1100|op);break;
    }
  }
  run(max){while(this.instrCount<max&&!this.halted)this.step();return this.instrCount}
}

// =====================================================================
// Helper: call a subroutine, return on RTS to our sentinel
// =====================================================================
function callSub(cpu, addr, max = MAX_INSTRUCTIONS) {
  const HALT = 0x0F00;
  cpu.write8(HALT, 0x3F); // SWI = halt
  cpu.pS16(HALT);
  cpu.PC = addr;
  cpu.halted = false;
  cpu.instrCount = 0;
  cpu.run(max);
  return cpu.instrCount;
}

// =====================================================================
// Set up a fresh CPU with entity and ROM
// =====================================================================
function makeCPU() {
  const cpu = new CPU6809();
  cpu.mainRomData = mainRom;
  cpu.bankRomData = bankRom;
  cpu.S = 0x17F0; // Stack in high work RAM (per reset vector: S=$17FF)
  cpu.DP = 0;
  return cpu;
}

function setupEntity(cpu, entityType, animState, opts = {}) {
  const e = ENTITY_BASE;
  for (let i = 0; i < 0x60; i++) cpu.write8(e + i, 0);

  // Entity byte 0: high nibble = tile bank, low nibble = sub-type
  // For player character, tile bank is set by animation handler
  cpu.write8(e + 0x00, opts.byte0 || 0x01);
  cpu.write8(e + 0x01, opts.byte1 || 0x00);
  cpu.write8(e + 0x02, opts.byte2 || 0x07);
  cpu.write8(e + 0x03, opts.byte3 || 0x00);

  // Position
  cpu.write8(e + 0x05, opts.posY || 0xA0);
  cpu.write8(e + 0x09, opts.posX || 0x80);
  cpu.write8(e + 0x0F, opts.direction || 0x00);

  // Entity type
  cpu.write8(e + 0x17, entityType & 0x1F);

  // Anim state (bit 7 clear = first-time flag for $C8B6)
  cpu.write8(e + 0x1B, animState & 0x7F);

  // Sub-index and other animation state
  cpu.write8(e + 0x21, opts.subIndex || 0x00);
  cpu.write8(e + 0x2C, opts.frameDuration || 0x04);

  // Character type (offset 0x45) - affects tile bank selection
  cpu.write8(e + 0x45, opts.charType || 0x00);

  // DP variables
  cpu.write16(0x0000, e); // pointer to entity
  cpu.write8(0x0002, 0);
  cpu.write8(0x003A, 0x00);

  // Game state needed for animation timing gate
  cpu.write8(0x0051, 0x01); // game timer
  cpu.write8(0x002A, 0x00); // must differ from ($51 & 1) to not skip

  // Clear sprite buffers
  cpu.write8(0x0C9C, 0);
  cpu.write8(0x0EBD, 0);
  for (let i = 0x0C00; i < 0x0F00; i++) cpu.write8(i, 0);

  cpu.X = e;
}

// =====================================================================
// Decode buffer data into sprite entries
// =====================================================================
function decodeBuffer(cpu) {
  const sprites = [];
  const count16 = cpu.read8(0x0C9C);

  for (let i = 0; i < count16 && i < 16; i++) {
    const base = 0x0C5C + i * 4;
    const destHi = cpu.read8(base);
    const destLo = cpu.read8(base + 1);
    const shiftedAttr = cpu.read8(base + 2);
    const tileLo = cpu.read8(base + 3);

    // The shiftedAttr byte results from 4x (ASLB; ROLA) on original entity data.
    // If original A=entityByte0, B=entityByte1:
    //   shiftedAttr = (A << 4) | (B >> 4) (with carry chain through ROLA)
    // To get original values:
    //   origA = shiftedAttr >> 4 (BUT only lower 4 bits of origA survive)
    //   Actually this loses the upper 4 bits of A...
    //
    // The shiftedAttr IS the final color|tile_hi byte written to sprite hardware:
    //   color = shiftedAttr >> 5 (bits 7-5)
    //   tile_hi = shiftedAttr & 0x1F (bits 4-0)
    // And tileLo is restored from stack (original entity byte 1)

    const tile = tileLo | ((shiftedAttr & 0x1F) << 8);
    const color = (shiftedAttr >> 5) & 7;
    const destAddr = (destHi << 8) | destLo;

    sprites.push({ tile, color, destAddr, shiftedAttr, tileLo, type: '16x16' });
  }

  // 32x32 buffer at $0C9D
  const count32 = cpu.read8(0x0EBD);
  // (32x32 entries have a different format - size flag byte + tile data)

  return { sprites, count16, count32 };
}

// =====================================================================
// Main
// =====================================================================
console.log('=== Double Dragon 2 Sprite Emulator ===\n');

// Read dispatch tables
const animTable = []; // $8B36 - animation handlers per anim state (0-0x18)
for (let i = 0; i < 25; i++) {
  const hi = mainRom[0x8B36 - 0x8000 + i * 2];
  const lo = mainRom[0x8B36 - 0x8000 + i * 2 + 1];
  animTable.push((hi << 8) | lo);
}

const renderTable = []; // $C8D0 - render setup per anim state (0-0x13)
for (let i = 0; i < 20; i++) {
  const hi = mainRom[0xC8D0 - 0x8000 + i * 2];
  const lo = mainRom[0xC8D0 - 0x8000 + i * 2 + 1];
  renderTable.push((hi << 8) | lo);
}

const typeTable = []; // $C822 - entity type dispatch
for (let i = 0; i < 20; i++) {
  const hi = mainRom[0xC822 - 0x8000 + i * 2];
  const lo = mainRom[0xC822 - 0x8000 + i * 2 + 1];
  typeTable.push((hi << 8) | lo);
}

console.log('Animation table ($8B36):');
for (let i = 0; i < 25; i++)
  console.log(`  Anim ${i.toString().padStart(2)}: $${animTable[i].toString(16).padStart(4,'0')}`);

console.log('\nRender setup table ($C8D0):');
for (let i = 0; i < 20; i++)
  console.log(`  Anim ${i.toString().padStart(2)}: $${renderTable[i].toString(16).padStart(4,'0')}`);

// Run for all animation states and multiple entity configurations
const results = {};
const allUnmapped = new Set();

// The per-entity renderer at $C8A7 calls 4 functions:
//   1. $C8B6 - render setup (sets byte 0 low nibble, position offsets)
//   2. $D7FA - position/animation update
//   3. $C9D5 - sprite tile selection (dispatches per anim state via $C9EC)
//   4. $D894 - additional rendering
//   Then $C80F - entity type dispatch (writes to sprite buffers)
//
// For entity type 0 (items/simple), $C80F calls $4467 directly
// For entity type 2-7 (characters), $C80F calls $4021 (RTS - no-op)
//   because character sprite output is handled by $C9D5 + $C80F(type 0)
//
// Entity byte 2 = tile selection (set by $C9D5 functions)
// Entity byte 0 high nibble = tile bank
// Entity byte 0 low nibble = sprite configuration (1=standard, 2=flipped, etc.)

// Tile banks to test
const tileBanks = [0x00, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80, 0x90, 0xA0];

console.log('\n=== Running sprite extraction ===\n');
console.log('Pipeline: $C8A7 (full character render) then $C80F (sprite draw)\n');

for (let animState = 0; animState <= 0x22; animState++) {
  results[animState] = { bestSprites: [], allVariants: [] };

  for (const tileBank of tileBanks) {
    for (let frameIdx = 0; frameIdx < 8; frameIdx++) {
      const cpu = makeCPU();

      // Entity type in offset 23 bits 0-4:
      // Type 0 = $C8A7 (full character pipeline)
      // Set offset 23 = 0x00 (character type 0 = player)
      setupEntity(cpu, 0, animState, {
        byte0: tileBank | 0x01,
        byte1: 0x00,
        byte2: 0x07,
        subIndex: 0,
        charType: 0,
      });

      // Set frame counter
      cpu.write8(ENTITY_BASE + 0x18, frameIdx);
      cpu.write8(ENTITY_BASE + 0x19, 0);

      // Set entity offset 31-32 = pointer to animation data
      // From DBB3 table, index 0 -> $DC3A (default idle animation data)
      cpu.write16(ENTITY_BASE + 0x1F, 0xDC3A);
      // Also set offset 33-34 for sub-animation pointer
      cpu.write16(ENTITY_BASE + 0x21, 0xDC3A);

      // Set position to reasonable screen coords
      cpu.write8(ENTITY_BASE + 4, 0x00); // X hi
      cpu.write8(ENTITY_BASE + 5, 0xA0); // X lo = 160
      cpu.write8(ENTITY_BASE + 8, 0x00); // Y hi
      cpu.write8(ENTITY_BASE + 9, 0x80); // Y lo = 128

      // Run the FULL character render pipeline $C8A7
      // This calls: $C8B6 (setup), $D7FA (position), $C9D5 (tile select), $D894 (extra)
      callSub(cpu, 0xC8A7, 20000);
      cpu.X = ENTITY_BASE;

      // Now run $C80F (sprite draw dispatcher)
      // This reads entity type from offset 23 and dispatches
      callSub(cpu, 0xC80F, 10000);

      // Also try calling the banked dispatch at $4022 directly
      // (this is the multi-sprite path)
      cpu.X = ENTITY_BASE;
      cpu.bankEnabled = true;
      callSub(cpu, 0x4022, 15000);

      const { sprites, count16, count32 } = decodeBuffer(cpu);
      for (const u of cpu.unmapped) allUnmapped.add(u);

      if (sprites.length > 0) {
        results[animState].allVariants.push({
          tileBank, frameIdx, sprites, count16, count32,
          byte0After: cpu.read8(ENTITY_BASE),
          byte1After: cpu.read8(ENTITY_BASE + 1),
          byte2After: cpu.read8(ENTITY_BASE + 2),
        });
      }
    }
  }

  // Pick the variant with most sprites (or first if tied)
  if (results[animState].allVariants.length > 0) {
    const best = results[animState].allVariants.reduce((a, b) =>
      b.sprites.length > a.sprites.length ? b : a
    );
    results[animState].bestSprites = best.sprites;
    results[animState].bestConfig = best;

    console.log(`Anim 0x${animState.toString(16).padStart(2,'0')}: ${best.sprites.length} sprites (bank=0x${best.tileBank.toString(16)}, frame=${best.frameIdx}, byte0=$${best.byte0After.toString(16)}, byte1=$${best.byte1After.toString(16)}, byte2=$${best.byte2After.toString(16)})`);
    for (const s of best.sprites.slice(0, 4)) {
      console.log(`  tile=0x${s.tile.toString(16).padStart(4,'0')} color=${s.color} dest=$${s.destAddr.toString(16)}`);
    }
  } else {
    console.log(`Anim 0x${animState.toString(16).padStart(2,'0')}: no sprites`);
  }
}

if (allUnmapped.size > 0) {
  console.log(`\nUnmapped opcodes encountered: ${[...allUnmapped].map(o => '0x'+o.toString(16)).join(', ')}`);
}

// Also test entity type 0 (single tile mode) for comparison
console.log('\n=== Entity type 0 (single tile, $4467 direct) ===\n');
for (let animState = 0; animState <= 5; animState++) {
  const cpu = makeCPU();
  setupEntity(cpu, 0, animState, { byte0: 0x01, byte2: 0x07 });
  callSub(cpu, 0xC8B6, 5000);
  cpu.X = ENTITY_BASE;
  callSub(cpu, 0xC80F, 10000);
  const { sprites, count16 } = decodeBuffer(cpu);
  console.log(`  Type 0, Anim 0x${animState.toString(16)}: ${sprites.length} sprites, byte0=$${cpu.read8(ENTITY_BASE).toString(16)}`);
}

// =====================================================================
// Write output
// =====================================================================
fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const output = {
  metadata: {
    game: 'Double Dragon 2 (Arcade)',
    description: 'Sprite compositions extracted by 6809 CPU emulation',
    pipeline: [
      '$C8B6: Render setup - per anim state dispatch via $C8D0',
      '$C80F: Sprite renderer - per entity type dispatch via $C822',
      '$4467: Sprite writer - outputs to buffer at $0C5C',
      'Buffer format: [dest_hi, dest_lo, shifted_attr, tile_lo] x 4 bytes',
      'tile = tile_lo | ((shifted_attr & 0x1F) << 8)',
      'color = shifted_attr >> 5',
    ],
    tables: {
      animationHandlers: '$8B36',
      renderSetup: '$C8D0',
      entityTypeDispatch: '$C822',
    },
  },
  animationStates: {},
};

for (const [animStr, data] of Object.entries(results)) {
  const anim = parseInt(animStr);
  const key = '0x' + anim.toString(16).padStart(2, '0');

  output.animationStates[key] = {
    animState: anim,
    spriteCount: data.bestSprites.length,
    sprites: data.bestSprites.map(s => ({
      tile: s.tile,
      tileHex: '0x' + s.tile.toString(16).padStart(4, '0'),
      color: s.color,
      size: s.type,
      destAddr: '$' + s.destAddr.toString(16).padStart(4, '0'),
    })),
    variantCount: data.allVariants.length,
    allVariants: data.allVariants.map(v => ({
      tileBank: '0x' + v.tileBank.toString(16),
      subIndex: v.subIdx,
      sprites: v.sprites.map(s => ({
        tile: s.tile,
        tileHex: '0x' + s.tile.toString(16).padStart(4, '0'),
        color: s.color,
        destAddr: '$' + s.destAddr.toString(16).padStart(4, '0'),
      })),
    })),
  };
}

const jsonPath = path.join(OUTPUT_DIR, 'exact-sprites.json');
fs.writeFileSync(jsonPath, JSON.stringify(output, null, 2));
console.log(`\nWritten: ${jsonPath}`);

// Summary
let totalSprites = 0, framesWithSprites = 0;
for (const data of Object.values(results)) {
  if (data.bestSprites.length > 0) {
    framesWithSprites++;
    totalSprites += data.bestSprites.length;
  }
}
console.log(`\nSummary:`);
console.log(`  Animation states tested: ${Object.keys(results).length}`);
console.log(`  States with sprite data: ${framesWithSprites}`);
console.log(`  Total sprite entries: ${totalSprites}`);
console.log(`  Unique tile banks found: ${new Set(Object.values(results).flatMap(r => r.allVariants.map(v => v.tileBank))).size}`);

// Dump entity state for debugging
console.log('\n=== Entity state after render (type 2, anim 0x00, bank 0x00) ===');
{
  const cpu = makeCPU();
  setupEntity(cpu, 2, 0, { byte0: 0x01, byte2: 0x07 });
  callSub(cpu, 0xC8B6, 5000);
  cpu.X = ENTITY_BASE;
  callSub(cpu, 0xC80F, 10000);
  console.log('Entity bytes after render:');
  for (let i = 0; i < 0x20; i += 16) {
    let line = `  $${(ENTITY_BASE + i).toString(16)}: `;
    for (let j = 0; j < 16; j++) line += cpu.read8(ENTITY_BASE + i + j).toString(16).padStart(2, '0') + ' ';
    console.log(line);
  }
  console.log(`  Buffer count16: ${cpu.read8(0x0C9C)}`);
  console.log(`  Buffer count32: ${cpu.read8(0x0EBD)}`);
  console.log(`  Buffer data at $0C5C:`);
  let line = '  ';
  for (let i = 0; i < 16; i++) line += cpu.read8(0x0C5C + i).toString(16).padStart(2, '0') + ' ';
  console.log(line);
}

console.log('\nDone.');
