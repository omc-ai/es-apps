# Double Dragon 2 Arcade - Complete Game Architecture

## Extracted from ROM disassembly of ddragon2u ROM set

---

## 1. CPU Architecture

### Main CPU (HD6309 @ $8000-$FFFF)
- **Reset vector**: $8000 - Boot/init, sets up stack at $16FF/$17FF, configures I/O at $38xx
- **NMI handler**: $8038 - VBlank interrupt (display/scroll update, copies sprite data $2081->$2800)
- **FIRQ handler**: $8081 - Raster interrupt (calls $8980 = input scanning)
- **IRQ handler**: $809F - Timer interrupt (sets flag at $0F29)
- **Main loop**: $80A9 - Game state machine

### Sub CPU (Z80 @ $0000-$7FFF from 26ad-0.bin)
- Handles sprite multiplexing and DMA
- Communicates with main CPU via shared RAM

### Sound CPU (6809 @ $0000-$7FFF from 26ac-02.bin)
- Controls YM2151 + OKI MSM6295
- Sound command latch at $380E

---

## 2. Memory Map

| Range | Size | Purpose |
|-------|------|---------|
| $0000-$0FFF | 4KB | Work RAM (entities at $03xx-$04xx, game vars at $00-$3F) |
| $1000-$17FF | 2KB | Sprite attribute RAM (y, tile, attr, x per sprite) |
| $1800-$1FFF | 2KB | Palette RAM (256 colors x 2 bytes, format BBBBGGGGRRRRXXXX) |
| $2000-$27FF | 2KB | Background tilemap (32x32 tiles) |
| $2800-$2FFF | 2KB | Foreground tilemap (32x32 tiles) |
| $3000-$37FF | 2KB | Character/text tilemap (32x32 tiles) |
| $3800-$3FFF | 2KB | I/O registers |
| $4000-$7FFF | 16KB | Banked ROM window (from 26aa-03.bin) |
| $8000-$FFFF | 32KB | Fixed ROM (26a9-04.bin) |

---

## 3. I/O Registers

| Address | R/W | Purpose |
|---------|-----|---------|
| $3800 | R | P1 joystick (bit0=R, bit1=L, bit2=U, bit3=D, bit4=Punch, bit5=Kick, bit6=Jump) |
| $3801 | R | P2 joystick (same bit layout) |
| $3802 | R | System (coin, start buttons) |
| $3803 | R | DIP switch A |
| $3804 | R | DIP switch B |
| $3808 | W | Bank select / scroll control register (45 writes!) |
| $3809 | W | Scroll X low |
| $380A | W | Scroll X high |
| $380B | W | IRQ acknowledge |
| $380C | W | FIRQ acknowledge |
| $380D | W | NMI acknowledge |
| $380E | W | Sound command latch |

### Bank switching protocol
```
$FC82: Enable bank  -> ORA #$A0 into $3A, write to $3808
$FC8F: Disable bank -> ANDA #$1F into $3A, write to $3808
```
Pattern: `JSR $FC82; JSR $4xxx; JSR $FC8F` = call banked function

---

## 4. Entity/Character Structure (40 bytes per entity)

Entities are accessed via X register. The game supports ~10 simultaneous entities (at $03xx with spacing).

| Offset | Size | Name | Description |
|--------|------|------|-------------|
| 0 | 1 | state | State machine index (lower nibble dispatched via table at $4034) |
| 1 | 1 | type | 0=inactive, 1=player1, 2=player2, 3+=enemy types |
| 2 | 1 | substate | Animation phase / sub-state |
| 3 | 1 | flags | General flags |
| 4-5 | 2 | x_pos | World X position (16-bit, high:low) |
| 6-7 | 2 | y_pos | World Y position (depth on play field) |
| 8-9 | 2 | z_pos | Z position (jump height above ground) |
| 10 | 1 | x_frac | X sub-pixel accumulator |
| 11 | 1 | y_frac | Y sub-pixel accumulator |
| 12 | 1 | z_frac | Z sub-pixel accumulator |
| 13 | 1 | speed_angle | Movement direction/angle |
| 14 | 1 | speed_mag | Movement speed magnitude |
| 15-16 | 2 | vel_x | X velocity (16-bit signed) |
| 17-18 | 2 | vel_y | Y velocity (16-bit signed) |
| 19 | 1 | vel_z | Z velocity (jump/gravity) |
| 20 | 1 | anim_flags | bit7 = animation control flag |
| 21 | 1 | status_flags | bit6 = movement locked |
| 22 | 1 | sprite_tile | Current sprite tile index |
| 23 | 1 | sprite_attr | Palette (low nibble) + flip/priority |
| 24-25 | 2 | timers | General purpose timers (cleared by $A779) |
| 26 | 1 | hp | Hit points |
| 27 | 1 | invincibility | Invincibility timer (bit7=active, set by $A779) |
| 28 | 1 | attack_type | Current attack ID |
| 29 | 1 | combo_counter | Hit combo counter (incremented by $A779) |
| 30 | 1 | ai_state | Enemy AI behavior state |
| 31 | 1 | ai_timer | AI action timer |
| 32 | 1 | facing | Direction: 0=right, nonzero=left |
| 33 | 1 | gravity_flag | Whether gravity applies |
| 34 | 1 | ground_y | Ground level Y for this entity |
| 35 | 1 | hitbox_id | Active hitbox index |
| 36 | 1 | target_id | AI target entity index |
| 37 | 1 | attack_range | Attack range value (compared at $A7D3 via table at $A7DC) |

---

## 5. Entity State Machine

Dispatched at $10022 via indirect jump table at $4034:

| State | Handler | Purpose |
|-------|---------|---------|
| 0 | $403E | Idle / Standing |
| 1 | $4077 | Walking / Moving |
| 2 | $40B6 | Attacking (punch/kick) |
| 3 | $40B6 | Attacking (shared handler with state 2) |
| 4 | $411E | Jumping |
| 5 | $347E | Hit reaction / Hurt |
| 6 | $A605 | Knockdown / Falling |
| 7 | $E60A | Dead / Dying |

### Movement Update ($1003E)
```
position.x += velocity.x (with sub-pixel accumulation)
position.y += velocity.y (with sub-pixel accumulation)
if velocity negative: position high byte decremented (handles borrow)
```

### Movement with Direction ($10077)
```
Uses speed_angle (offset 13) and speed_mag (offset 14)
to compute velocity vector, then applies to position
```

---

## 6. Game State Machine (Main Loop)

The main game loop at $80A9 dispatches through a **game mode** variable. Key modes (from jump table at $FE40):

| Index | Handler | Purpose |
|-------|---------|---------|
| 0 | $A944 | Title screen / Attract mode |
| 1 | $9F12 | Game start / Player select |
| 2 | $9F91 | Stage intro sequence |
| 3 | $9FE6 | Main gameplay (fighting) |
| 4 | $9286 | Stage clear sequence |
| 5 | $A1AE | Continue screen |
| 6 | $A608 | Game over |
| 7 | $A6B5 | High score entry |
| 8 | $A111 | Bonus stage |
| 9 | $AB9D | Cutscene / Story |
| 10 | $AB9D | Cutscene (same handler) |
| 11 | $A717 | Stage transition |
| 12 | $A779 | Entity reset (death/respawn) |
| 13 | $A775 | Entity cleanup |

### Banked Function Dispatch (at $FE7F+)

| Vector | Target | Purpose |
|--------|--------|---------|
| $FE80 | $4022 | Entity state dispatch |
| $FE82 | $453C (bank) | Collision detection |
| $FE85 | $45DD (bank) | Hitbox processing |
| $FE88 | $4467 (bank) | Animation update |
| $FE8B | $4850 (bank) | Sprite DMA |
| $FE8E | $4679 (bank) | Level scroll update |
| $FE91 | $488A (bank) | Background tile update |
| $FE95 | $41CD (bank) | Frame sync / timing |
| $FE98 | $41E7 (bank) | Palette update |

---

## 7. Attack Range Table ($A7DC)

Used by subroutine at $A7A6 to determine if an attack connects. Each byte is the maximum range for that attack type:

```
Index 0-12: range = 5 (standard melee attacks)
Index 13: range = 50 (extended reach - flying kick?)
```

---

## 8. Animation Data

### Format
Animation tables consist of frame entries, each containing:
- **Tile index** (sprite sheet reference)
- **Duration** (frames to display)
- **X offset** (signed pixel offset from entity origin)
- **Y offset** (signed pixel offset from entity origin)

### Key Animation Tables Found

**Main ROM ($8000-$FFFF):**
- 81 animation sequences
- Notable: $8FC3 (11 frames), $9027-$9087 (walk cycles), $98D5 (attack)

**Banked ROM ($4000-$7FFF):**
- 165 animation sequences
- Notable: $471A (9 frames), $5696 (8 frames - walk cycle pattern)

### Tile Sequence Tables (sprite composition)
At $9022 (32 frames) and $BF6D (21 frames) - these define which sprite tiles compose each animation frame.

---

## 9. Palette Data

### Color Format
DD2 uses 12-bit color: `BBBBGGGGRRRR____` or `RRRRGGGGBBBB____`

### Extracted Palettes (from banked ROM)

| Address | Description | Sample Colors |
|---------|-------------|---------------|
| $7248 | Player palette | Black, skin tones, blue outfit |
| $7B3C | Enemy palette | Dark tones, green accents |
| $7C8A | Stage 1 BG | Earth tones, brown/green |
| $7CAA | Stage 2 BG | Warmer palette |
| $7D6A | UI/Text | White, yellow, red |

### Palette Count
- 40 valid palettes in main ROM
- 40 valid palettes in banked ROM
- 80 total palette sets

---

## 10. Level/Stage Data

### Tilemap Format
- Background tilemaps use RLE compression
- Largest RLE block: $F79F (main ROM) - 37 pairs decoding to 2248 bytes
- Word tilemaps at $F5B5 (185 bytes, 52 unique tiles)

### Enemy Spawn/Wave Data

Found at multiple locations. Format: `[scroll_trigger, enemy_type, y_position]`

Key spawn tables:
- **$F7AA** (16 entries): Regular wave spawns at scroll positions 0x40-0x840+
- **$D909** (5 entries): Boss-area spawns
- **$A94C** (4 entries): Mid-level ambush
- **$7806** (banked, 5 entries): Stage 2+ spawns

---

## 11. Hitbox Data

### Found Tables
- 53 hitbox tables in main ROM
- 86 hitbox tables in banked ROM

### Format: `[x1, y1, x2, y2]` or `[cx, cy, width, height]`

Key hitbox sets:
- **$1350E** (9 boxes): Player character hitboxes
  - Standing: [16, 48, 16, 8]
  - Ducking: [8, 16, 12, 12]
  - Attack: [8, 48, 14, 14]

---

## 12. Input System ($8988)

```
$8988: LDA $3801    ; Read P2 input
$898C: LDB $3802    ; Read system buttons
$89CA: LDA $3801    ; P2 again
$89CE: LDB $3802    ; System again
$89E4: LDB $3803    ; DIP switches
$8A5F: LDA $3801    ; P2 input
$8A63: LDB $3802    ; System
```

Input bits for P1/P2:
| Bit | Action |
|-----|--------|
| 0 | Right |
| 1 | Left |
| 2 | Up |
| 3 | Down |
| 4 | Button A (Punch) |
| 5 | Button B (Kick) |
| 6 | Button C (Jump) |
| 7 | Start |

---

## 13. Sound System

Sound commands written to latch at $380E. The sound CPU reads commands and plays corresponding effects/music via YM2151 (FM synthesis) and OKI6295 (ADPCM samples from 26j6-0.bin + 26j7-0.bin).

```
$80A9: LDA #$FE; STA $380E  ; Send sound command $FE (silence)
$8135: LDA #$FE; STA $380E  ; Same at stage transitions
```

---

## 14. Key Subroutine Reference

| Address | Calls | Purpose |
|---------|-------|---------|
| $A779 | 56 | Entity state reset / death handler |
| $FC8F | 53 | Bank disable (restore ROM page) |
| $FC82 | 38 | Bank enable (switch to banked ROM) |
| $FEB6 | 36 | Banked call to $4458 (sprite/display update) |
| $FEB0 | 28 | Banked call to $FC50 (scroll/BG update) |
| $C73B | 26 | Collision check between entities |
| $C72E | 26 | Hitbox overlap test |
| $FDB2 | 23 | Palette fade effect |
| $FDA0 | 21 | Screen transition effect |
| $9C7E | 18 | Player control handler |
| $A27C | 14 | Enemy AI main update |
| $BF92 | 12 | Wait for VBlank sync |
| $BC47 | 12 | Draw text/HUD element |
| $BC54 | 11 | Draw score display |
| $BC26 | 11 | Clear text area |
