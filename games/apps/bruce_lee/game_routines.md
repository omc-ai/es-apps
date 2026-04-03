# Bruce Lee - Game Routine Analysis

## Room Layout Format (decoded from $0A83+)

The room data at $4AD0+ uses a compressed format:

### Room header: 20 bytes copied to $0153-$0166
Contains per-room configuration (platform heights, positions, etc.)

### Room drawing loop ($0AD5-$0B2D):
```
Y = 0 (byte index into room data)
loop:
  read byte from (data_ptr),Y
  if bit 7 set:
    count = byte & 0x7F     ; repeat count
    if count == 0: done (end of room data)
    JSR $478D               ; advance column position
    read next byte           ; char code to repeat
    if bit 7 set on char: JSR $0B5F (special processing)
    write char to screen RAM via ($04),Y
    write char|0x80 to color RAM via ($08),Y
    JSR column advance routines
    DEX; loop for count times
  else (bit 7 clear):
    count = byte             ; direct count  
    JSR $478D               ; advance column
    read next byte           ; char code
    if bit 7 set: JSR $0B5F
    write to screen + color
    JSR column advance
    DEX; loop for count times
```

### Helper routines:
- $478D: Column position advance
- $4786: Row advance (move to next row on screen)
- $4794: Color RAM advance
- $0B51: Screen pointer update
- $0B58: Color pointer update
- $485B: Multi-row fill

## Screen Memory Layout (VIC Bank 2)
- Screen RAM: $8C00 (offset $0C00 in bank)
- Color RAM: $D800 (always at this address)
- Charset: $8800 (offset $0800 in bank)
- Sprite data: $8000-$83FF (blocks 0-15)

## Sprite System
- 5 sprites used: 0-4
- Sprite pairs overlaid for multi-color:
  - Spr0(fill,yellow) + Spr1(outline,black) = Bruce Lee
  - Spr2(fill,green/white) + Spr3(outline,black) = Yamo
  - Spr4(single,black) = Ninja
- Hires mode ($D01C=0), X-expanded ($D01D=$FF)
- Sprite pointers at $8FF8 (screen + $3F8)

## Player Input ($094B)
- Read $DC00 AND $DC01
- Bit 0: Up, Bit 1: Down, Bit 2: Left, Bit 3: Right, Bit 4: Fire
- Bits are ACTIVE LOW (0 = pressed)

## Room Color System
- $47A0[room]: Color value byte
- Lower nibble: accent color for the room
- Applied to color RAM rows $D878+ during room setup ($09DA)

## Zero Page Variables
- $29: Room number (0-19)
- $04/$05: Screen write pointer
- $06/$07: Data read pointer
- $08/$09: Color write pointer
- $10/$11: Temp pointer
- $28: Lives remaining
- $47: Sprite enable shadow
- $F2: Scroll/animation state
- $F3: Column draw counter

## Character Data Structure (ZP Arrays, indexed by X=0/1/2)
- X=0: Bruce Lee
- X=1: Green Yamo  
- X=2: Ninja

| ZP Base | R/W Count | Char 0 | Char 1 | Char 2 | Purpose |
|---------|-----------|--------|--------|--------|---------|
| $9E,X | 18R/3W | $7A(122) | $53(83) | $5A(90) | X position |
| $A1,X | 15R/3W | $C4(196) | $C1(193) | $C4(196) | Y position |
| $A4,X | 15R/18W | $00 | $01 | $01 | Velocity/movement |
| $95,X | 14R/3W | $01 | $81 | $41 | State flags |
| $98,X | 2R/4W | $0F | $0F | $0F | Animation frame |
| $9B,X | 3R/2W | $01 | $01 | $01 | Direction |
| $B6,X | 43R/1W | $03 | $00 | $01 | Health/timer (most read!) |
| $BF,X | 12R/23W | $00 | $00 | $14 | Attack state |
| $CE,X | 11R/34W | $00 | $0C | $14 | Stun/damage timer |
| $D1,X | 10R/8W | $07 | $14 | $07 | Sprite block number |
| $D0,X | 24R/0W | $14 | $07 | $14 | Sprite-related |
| $CB,X | 7R/1W | $06 | $06 | $06 | Char color? |
| $E0,X | 4R/1W | $14 | $11 | $14 | Jump height? |
| $E9,X | 5R/1W | $0C | $0C | $0C | Speed? |

## Sprite VIC Writes
- $0C84: STA $D000,Y → sprite X position
- $0C8C: STA $D001,Y → sprite Y position
- $0CAF: STA $D000,Y → second sprite X (overlay pair)
- $0CB7: STA $D001,Y → second sprite Y (overlay pair)

## Game Tables
- $4B34[room]: Room screen data pointer lo (20 bytes)
- $4B49[room]: Room screen data pointer hi (20 bytes)
- $4BAE[room]: Bruce X start position
- $4BC2[room]: Bruce Y start position
- $4BD6[room]: Enemy start position
- $4BEA[room]: Enemy Y start position


## Sprite Position Update Routine ($0C60-$0CD4)

### Decoded behavior:
```
For each character (indexed by register):
1. Write sprite block number to $8FF8+n (sprite pointer)
2. x_screen = position[$9E,X] * 2  (ASL for sprite coords)
3. Handle 9th bit of X via MSB register ($D010) using lookup tables at $2773/$2778
4. Write X to VIC $D000+n*2
5. y_screen = position[$A1,X] + $1D (add 29 for VIC offset)
6. Write Y to VIC $D001+n*2
7. Repeat steps 2-6 for overlay sprite (second of the pair)
8. Update $D015 (sprite enable) based on table at $2773
```

### Key constants:
- Y offset: +$1D (29 pixels) added to game Y to get VIC sprite Y
- X scale: *2 (game X position is half the sprite X coordinate)
- Overlay tables at $2763-$2780: map character index to sprite pair indices

## Character Spawn ($0BF0)
```
LDX room_number ($29)
X_pos = table[$4BAE + room]
Y_pos = table[$4BC2 + room]
LDX character_index ($51)
position_x[$9E,X] = X_pos
position_y[$A1,X] = Y_pos
```

## Movement System (to be traced)
The main movement update modifies $9E,X and $A1,X
Velocity stored at $A4,X
Called from the main game loop (raster interrupt handler)

## Tables at $2700 region
- $2763: Sprite pair mapping table
- $2773: Sprite X MSB set masks
- $2778: Sprite X MSB clear masks
- $277D: Sprite enable set masks
