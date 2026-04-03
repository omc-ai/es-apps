/**
 * ============================================================================
 * Double Dragon 2 Arcade - Sprite Composition Function Analysis
 * ROM: 26aa-03.bin (banked at $4000-$BFFF)
 * Function entry: $462E (visibility check), $4679 (size/direction calc),
 *                 $46CE (main sprite composer)
 * ============================================================================
 *
 * This file contains:
 *   1. Full 6809 disassembly of $462E-$4810 with detailed comments
 *   2. Explanation of the data table at $46BE
 *   3. JavaScript translation of the entire sprite composition system
 *
 * ARCHITECTURE OVERVIEW:
 *   The sprite composition is split into three cooperating functions:
 *
 *   $462E - Screen bounds check: Determines if an entity is visible on screen.
 *           Compares entity x_pos and y_pos against the current scroll window
 *           ($003C/$003F = camera left/top). Returns with carry SET if offscreen.
 *
 *   $4679 - Direction/size calculator: Called from the main game loop. Calculates
 *           relative direction between two entities (via sub $4562) and uses the
 *           result as an index into the position offset table at $46BF to determine
 *           which 8-directional facing quadrant an entity occupies.
 *
 *   $46CE - Main sprite composer: The critical function that takes entity data,
 *           resolves the tile/attribute/color for a sprite entry, writes it into
 *           sprite RAM at $0281, and handles flip/size/special animation states.
 *
 * ENTITY STRUCTURE (X register points to base, 36+ bytes per entity):
 *   Offset 0:  state
 *   Offset 1:  type (0=none, 1=player1, 2=player2, 3+=enemies)
 *   Offset 2:  tile_select / substate
 *   Offset 3:  flags
 *   Offset 4-5: x_pos (16-bit world X)
 *   Offset 6-7: y_pos (16-bit world Y / depth)
 *   Offset 8-9: z_pos (16-bit height above ground)
 *   Offset 22: sprite_tile (current tile index from animation)
 *   Offset 23: sprite_attr (palette in low nibble, flags in high)
 *   Offset 27: anim_state (animation state, $3F mask used)
 *
 * SPRITE RAM FORMAT (at $0281, 8 bytes per composed sprite entry):
 *   Byte 0: Y-position (or attribute/visible flag with bit7)
 *   Byte 1: color/tile_hi
 *   Byte 2-3: x_pos (from entity)
 *   Byte 4-5: y_pos (from entity)
 *   Byte 6-7: z_pos (from entity)
 *
 * The composed sprite list at $0381 is a pointer table (2 bytes per entry)
 * indexed by the sprite count at $03A1.
 */

// ============================================================================
// SECTION 1: FULL 6809 DISASSEMBLY WITH COMMENTS
// ============================================================================

/*
=== FUNCTION: screen_bounds_check ($462E) ===
Called to determine if an entity (pointed to by X) is visible on screen.
Returns: Carry CLEAR = visible, Carry SET = offscreen.
Direct page vars: $3C-$3D = camera X, $3F-$40 = camera Y.

$462E: A6 88 17     LDA     23,X          ; Load sprite_attr from entity
$4631: 81 11        CMPA    #$11          ; Compare with $11 (special state: "hidden")
$4633: 27 04        BEQ     $4639         ; If $11 -> jump to "offscreen" exit
$4635: 81 17        CMPA    #$17          ; Compare with $17 (another hidden state)
$4637: 26 03        BNE     $463C         ; If neither hidden state, continue to bounds check
$4639: 1C FE        ANDCC   #$FE          ; Clear carry (= "visible" but actually means skip)
                                           ; NOTE: This clears carry meaning "don't draw" for
                                           ; these special states -- they are handled differently
$463B: 39           RTS                   ; Return

; --- Actual screen bounds checking ---
$463C: 32 7C        LEAS    -4,S          ; Allocate 4 bytes on stack as local vars
$463E: EC 04        LDD     4,X           ; D = entity.x_pos (16-bit)
$4640: ED E4        STD     ,S            ; Store x_pos at [SP+0]
$4642: EC 06        LDD     6,X           ; D = entity.y_pos (16-bit)
$4644: E3 08        ADDD    8,X           ; D = y_pos + z_pos (screen Y = depth + height)
$4646: ED 62        STD     2,S           ; Store computed screen_y at [SP+2]

; Check X bounds: entity.x_pos must be within [camera_x - 0x40, camera_x + 0x140)
$4648: EC E4        LDD     ,S            ; D = x_pos
$464A: C3 00 40     ADDD    #$0040        ; D = x_pos + 64 (add left margin)
$464D: 81 FF        CMPA    #$FF          ; Check for overflow (high byte = $FF)
$464F: 27 25        BEQ     $4676         ; If overflow, offscreen -> exit
$4651: 10 93 3C     CMPD    <$3C          ; Compare (x_pos+64) with camera_x
$4654: 25 20        BCS     $4676         ; If x_pos+64 < camera_x, offscreen (too far left)
$4656: DC 3C        LDD     <$3C          ; D = camera_x
$4658: C3 01 40     ADDD    #$0140        ; D = camera_x + 320 (screen width + margins)
$465B: 10 A3 E4     CMPD    ,S            ; Compare (camera_x+320) with x_pos
$465E: 25 16        BCS     $4676         ; If camera_x+320 < x_pos, offscreen (too far right)

; Check Y bounds: screen_y must be within [camera_y - 0x40, camera_y + 0x140)
$4660: EC 62        LDD     2,S           ; D = screen_y (y_pos + z_pos)
$4662: C3 00 40     ADDD    #$0040        ; D = screen_y + 64
$4665: 81 FF        CMPA    #$FF          ; Check for overflow
$4667: 27 0D        BEQ     $4676         ; If overflow, offscreen
$4669: 10 93 3F     CMPD    <$3F          ; Compare with camera_y
$466C: 25 08        BCS     $4676         ; If screen_y+64 < camera_y, offscreen (above)
$466E: DC 3F        LDD     <$3F          ; D = camera_y
$4670: C3 01 40     ADDD    #$0140        ; D = camera_y + 320
$4673: 10 A3 62     CMPD    2,S           ; Compare with screen_y
                                           ; Falls through: carry SET = offscreen, CLEAR = visible

$4676: 32 64        LEAS    4,S           ; Deallocate locals
$4678: 39           RTS                   ; Return (carry flag holds result)


=== FUNCTION: direction_size_calculator ($4679) ===
Calculates the directional relationship between the current entity and a
target entity. Returns the facing quadrant index in A register, used as
an index into the tile offset table at $46BF.

Uses subroutine $4562 which computes:
  DP:$00 = direction flags (bit0=X negative, bit1=Y negative)
  DP:$01-$02 = |delta_x|
  DP:$03-$04 = |delta_y|

$4679: 34 34        PSHS    B,X,Y         ; Save registers
$467B: 32 7B        LEAS    -5,S          ; Allocate 5 bytes of locals
$467D: BD 45 62     JSR     $4562         ; Calculate deltas between entities
                                           ; Sets DP:$00 = direction bits
                                           ;       DP:$01-02 = |dx|
                                           ;       DP:$03-04 = |dy|

; Build quadrant index from direction bits and magnitude comparison
$4680: 96 00        LDA     <$00          ; A = direction flags
$4682: 1F 89        TFR     A,B           ; B = copy of direction flags
$4684: 48           ASLA                  ; A <<= 3 (shift direction bits up)
$4685: 48           ASLA
$4686: 48           ASLA
$4687: 84 08        ANDA    #$08          ; Keep only bit3 (Y-direction flag shifted up)
$4689: 97 00        STA     <$00          ; Store back
$468B: 58           ASLB                  ; B <<= 1
$468C: C4 04        ANDB    #$04          ; Keep only bit2 (X-direction flag shifted up)
$468E: DA 00        ORB     <$00          ; Combine: bit3=Y_neg, bit2=X_neg
$4690: D7 00        STB     <$00          ; Store combined direction bits

; Compare magnitudes to determine if primarily X or Y movement
$4692: DC 01        LDD     <$01          ; D = |delta_x|
$4694: 10 93 03     CMPD    <$03          ; Compare |dx| with |dy|
$4697: 25 0F        BCS     $46A8         ; If |dx| < |dy|, branch (more vertical)

; dx >= dy: check if dx > 2*dy (strongly horizontal)
$4699: 0C 00        INC     <$00          ; Set bit0 of quadrant index (horizontal dominant)
$469B: 0C 00        INC     <$00          ; Set bit1 (= +2 to index)
$469D: 44           LSRA                  ; D = |dx| / 2
$469E: 56           RORB
$469F: 10 93 03     CMPD    <$03          ; Compare |dx|/2 with |dy|
$46A2: 24 0F        BCC     $46B3         ; If |dx|/2 >= |dy|, strongly horizontal -> done
$46A4: 0C 00        INC     <$00          ; Add 1 more (diagonal case)
$46A6: 20 0B        BRA     $46B3         ; Done

; dx < dy: check if dy > 2*dx (strongly vertical)
$46A8: DC 03        LDD     <$03          ; D = |delta_y|
$46AA: 44           LSRA                  ; D = |dy| / 2
$46AB: 56           RORB
$46AC: 10 93 01     CMPD    <$01          ; Compare |dy|/2 with |dx|
$46AF: 24 02        BCC     $46B3         ; If |dy|/2 >= |dx|, strongly vertical -> done (index stays 0)
$46B1: 0C 00        INC     <$00          ; Add 1 (diagonal case)

; Look up result from 16-entry table
$46B3: 10 8E 46 BF  LDY     #$46BF        ; Y -> direction lookup table
$46B7: D6 00        LDB     <$00          ; B = computed quadrant index (0-15)
$46B9: A6 A5        LDA     B,Y           ; A = table[index] = tile position offset
$46BB: 32 65        LEAS    5,S           ; Deallocate locals
$46BD: 35 B4        PULS    B,X,Y,PC      ; Restore and return


=== DATA TABLE: Direction/Position Offsets ($46BF) ===
16 entries, each a Y/X offset byte pair for tile positioning.
This table maps the 16 possible direction quadrants to sprite arrangement offsets.

The index is built from:
  bit3: Y delta is negative (target is above)
  bit2: X delta is negative (target is to left)
  bit1-0: magnitude ratio (0=vertical, 1=diagonal, 2=horizontal, 3=strongly horizontal)

$46BF: 00 20 40 20 80 60 40 60  ; Indices 0-7
$46C7: 00 E0 C0 E0 80 A0 C0 A0  ; Indices 8-15

Decoded as signed offsets (multiply by position scale):
  Index 0:  $00  (0)    - facing down, strongly vertical
  Index 1:  $20  (32)   - facing down-right diagonal
  Index 2:  $40  (64)   - facing right, horizontal
  Index 3:  $20  (32)   - facing right, strongly horizontal
  Index 4:  $80  (-128) - facing down, X-negative, vertical
  Index 5:  $60  (96)   - facing down-left diagonal
  Index 6:  $40  (64)   - facing left, horizontal
  Index 7:  $60  (96)   - facing left, strongly horizontal
  Index 8:  $00  (0)    - facing up, Y-negative, vertical
  Index 9:  $E0  (-32)  - facing up-right diagonal
  Index 10: $C0  (-64)  - facing up, horizontal
  Index 11: $E0  (-32)  - facing up, strongly horizontal
  Index 12: $80  (-128) - facing up, X-negative, vertical
  Index 13: $A0  (-96)  - facing up-left diagonal
  Index 14: $C0  (-64)  - facing up-left, horizontal
  Index 15: $A0  (-96)  - facing up-left, strongly horizontal

These values represent angular offsets in the game's 256-unit rotation system
(256 = full circle, so $20 = 45 degrees, $40 = 90 degrees, etc.)


=== FUNCTION: main_sprite_composer ($46CE) ===
This is the core sprite composition function. It reads entity data from the
entity struct (X register), writes composed sprite data to the sprite list
at $0281, and registers the sprite pointer in the table at $0381.

Called with:
  X = pointer to entity struct (e.g., $0300 for entity 0)
  U = pointer to additional data (animation frame data)
  Stack has saved B, X, Y from caller

$46CE: 34 66        PSHS    A,B,Y,U       ; Save registers
$46D0: 32 7F        LEAS    -1,S          ; Allocate 1 byte local (for temp)
$46D2: EE 88 2D     LDU     45,X          ; U = pointer to sprite frame data
                                           ; (offset 45 = animation frame pointer within entity)
                                           ; NOTE: This might be offset from a different base.
                                           ; In the hex dump context, 0x2D = 45 decimal.

$46D5: A6 02        LDA     2,X           ; A = entity.tile_select (offset 2)
$46D7: 84 7F        ANDA    #$7F          ; Mask off high bit (bit7 is a control flag)
$46D9: 81 7F        CMPA    #$7F          ; Check if tile_select == $7F (= "no sprite")
$46DB: 10 27 00 7F  LBEQ    $475F         ; If $7F, skip entirely -> exit

; --- Get sprite RAM slot ---
$46DF: 10 8E 02 81  LDY     #$0281        ; Y -> sprite composition buffer base
                                           ; NOTE: This is not hardware sprite RAM directly;
                                           ; it's a working buffer that gets DMA'd later
$46E3: B6 03 A1     LDA     $03A1         ; A = current sprite count (global counter)
$46E6: 81 10        CMPA    #$10          ; Max 16 sprites?
$46E8: 10 24 00 72  LBCC    $475F         ; If count >= 16, no room -> exit

; --- Calculate sprite buffer offset ---
$46EC: C6 08        LDB     #$08          ; Each sprite entry = 8 bytes
$46EE: 3D           MUL                   ; D = sprite_count * 8
$46EF: 31 AB        LEAY    D,Y           ; Y += offset -> Y now points to this sprite's slot

; --- Determine color/palette source ---
$46F1: A6 88 16     LDA     22,X          ; A = entity.sprite_tile (offset 22)
$46F4: 84 06        ANDA    #$06          ; Isolate bits 1-2 (palette source selector)
$46F6: 27 0C        BEQ     $4705         ; If 0, use entity's own palette (offset 1)

; Use palette from animation frame data (U register)
$46F8: E6 41        LDB     1,U           ; B = frame_data[1] (alternate palette/tile)
$46FA: E7 A4        STB     ,Y            ; Write to sprite buffer byte 0 (Y-pos or attr)
$46FC: 84 02        ANDA    #$02          ; Check bit1 specifically
$46FE: 27 08        BEQ     $4709         ; If not set, use entity's tile_select as color

; bit1 set: use frame data for color byte too
$4700: A6 42        LDA     2,U           ; A = frame_data[2] (color from anim data)
$4702: 20 06        BRA     $470B         ; Jump to store color

; Use entity's own type as the Y-position/attribute byte
$4705: A6 01        LDA     1,X           ; A = entity.type (offset 1)
$4707: A7 A4        STA     ,Y            ; Store as sprite byte 0

; Use entity's own tile_select as color source
$4709: A6 02        LDA     2,X           ; A = entity.tile_select (offset 2)

$470B: A7 21        STA     1,Y           ; Store as sprite byte 1 (color/tile_hi)

; --- Copy position data from entity to sprite buffer ---
$470D: EC 04        LDD     4,X           ; D = entity.x_pos
$470F: ED 22        STD     2,Y           ; Sprite bytes 2-3 = x_pos
$4711: EC 06        LDD     6,X           ; D = entity.y_pos
$4713: ED 24        STD     4,Y           ; Sprite bytes 4-5 = y_pos
$4715: EC 08        LDD     8,X           ; D = entity.z_pos
$4717: ED 26        STD     6,Y           ; Sprite bytes 6-7 = z_pos

; --- Check animation state for special sprite modifications ---
$4719: A6 88 1B     LDA     27,X          ; A = entity.anim_state (offset 27)
$471C: 84 3F        ANDA    #$3F          ; Mask to 6 bits (0-63)
$471E: 81 06        CMPA    #$06          ; Check knockdown state
$4720: 27 16        BEQ     $4738         ; State 6 = knockdown -> special handling
$4722: 81 0A        CMPA    #$0A          ; Check another state
$4724: 27 12        BEQ     $4738         ; State 10 -> special handling
$4726: 81 08        CMPA    #$08          ; Check state 8
$4728: 27 0E        BEQ     $4738         ; State 8 -> special handling

; Not a special state: default behavior
$472A: 86 07        LDA     #$07          ; A = 7 (always non-zero)
$472C: 26 22        BNE     $4750         ; Always branches (skip special handling)

; Dead code? This would only execute if the previous BNE didn't branch:
$472E: A6 01        LDA     1,X           ; A = entity.type
$4730: 81 04        CMPA    #$04          ; enemy type 4?
$4732: 27 04        BEQ     $4738         ; yes -> special
$4734: 81 06        CMPA    #$06          ; enemy type 6?
$4736: 26 18        BNE     $4750         ; no -> skip

; --- Special animation state handling (knockdown, hurt, etc.) ---
; For states 6, 8, 10: check if entity should have "flash" overlay (bit 7 on sprite attr)
$4738: A6 01        LDA     1,X           ; A = entity.type
$473A: 81 02        CMPA    #$02          ; Is it player 2 or higher?
$473C: 25 08        BCS     $4746         ; If type < 2 (player 1 or none), branch

; Type >= 2: check animation frame data
$473E: A6 41        LDA     1,U           ; A = frame_data[1]
$4740: 81 01        CMPA    #$01          ; Check if frame_data == 1
$4742: 26 0C        BNE     $4750         ; If not 1, skip flash
$4744: 27 04        BEQ     $474A         ; If exactly 1, apply flash

; Type < 2 (players)
$4746: 81 00        CMPA    #$00          ; Is type == 0 (inactive)?
$4748: 27 06        BEQ     $4750         ; If inactive, skip flash

; Apply flash/priority bit to sprite
$474A: A6 A4        LDA     ,Y            ; A = sprite byte 0 (written earlier)
$474C: 8A 80        ORA     #$80          ; Set bit 7 (visible/priority/flash flag)
$474E: A7 A4        STA     ,Y            ; Write back

; --- Register this sprite in the pointer table ---
$4750: CE 03 81     LDU     #$0381        ; U -> sprite pointer table base
$4753: B6 03 A1     LDA     $03A1         ; A = sprite count
$4756: C6 02        LDB     #$02          ; Each pointer = 2 bytes
$4758: 3D           MUL                   ; D = count * 2
$4759: 10 AF CB     STY     D,U           ; Store Y (sprite buffer ptr) into pointer table
$475C: 7C 03 A1     INC     $03A1         ; Increment sprite count

; --- Exit ---
$475F: 32 61        LEAS    1,S           ; Deallocate local
$4761: 35 E6        PULS    A,B,Y,U,PC   ; Restore registers and return


=== FUNCTION: store_sprite_index ($4763) ===
Stores a sprite tile index into the active sprite list at $0031.

$4763: 34 36        PSHS    A,B,X,Y       ; Save registers
$4765: D6 35        LDB     <$35          ; B = current sprite index counter
$4767: C1 04        CMPB    #$04          ; Max 4 entries?
$4769: 24 07        BCC     $4772         ; If >= 4, skip
$476B: 8E 00 31     LDX     #$0031        ; X -> sprite index array
$476E: A7 85        STA     B,X           ; Store A at array[B]
$4770: 0C 35        INC     <$35          ; Increment counter
$4772: 35 B6        PULS    A,B,X,Y,PC   ; Restore and return


=== FUNCTION: negate_16bit ($4774) ===
Negates a 16-bit value at entity offset 15 (vel_x).

$4774: CC 00 00     LDD     #$0000        ; D = 0
$4777: A3 0F        SUBD    15,X          ; D = 0 - entity[15] (negate)
$4779: ED 0F        STD     15,X          ; Store back
$477B: 39           RTS


=== FUNCTION: arithmetic_shift_right_16 ($477C) ===
Arithmetic shift right of 16-bit value at entity offset 15-16.

$477C: 67 0F        ASR     15,X          ; Arithmetic shift right high byte
$477E: 66 88 10     ROR     16,X          ; Rotate right low byte (with carry from ASR)
$4781: 39           RTS


=== FUNCTION: clamp_velocity ($4782) ===
Clamps entity velocity (offset 15-16) to range [-1.0, +1.0] in 8.8 fixed point.

$4782: A6 0F        LDA     15,X          ; A = vel_x high byte
$4784: 2B 0A        BMI     $4790         ; If negative, handle negative clamp
$4786: 81 01        CMPA    #$01          ; Is it >= 1?
$4788: 24 12        BCC     $479C         ; If >= 1, already clamped (or just return)
$478A: CC 01 00     LDD     #$0100        ; D = 1.0 in 8.8 fixed point
$478D: ED 0F        STD     15,X          ; Set vel = 1.0
$478F: 39           RTS

$4790: EC 0F        LDD     15,X          ; D = current velocity
$4792: 83 00 00     SUBD    #$0000        ; Compare with 0 (this is effectively a NOP/flag set)
$4795: 25 05        BCS     $479C         ; If already <= -1.0, return as-is
$4797: CC FF 00     LDD     #$FF00        ; D = -1.0 in 8.8 fixed point ($FF00)
$479A: ED 0F        STD     15,X          ; Set vel = -1.0
$479C: 39           RTS


=== FUNCTION: set_animation_params ($479D) ===
Loads animation parameters from a table at $47C7 based on input A.
Writes 6 bytes to entity offsets 13-18 (vel data) and sets state.

$479D: 34 7E        PSHS    A,B,DP,X,Y,U ; Save all
$479F: 97 00        STA     <$00          ; Store A as DP:$00
$47A1: D6 00        LDB     <$00          ; B = A (the index)
$47A3: 58           ASLB                  ; B *= 2
$47A4: 58           ASLB                  ; B *= 2 (total: B *= 4)
$47A5: DB 00        ADDB    <$00          ; B += original (B = index * 5)
$47A7: DB 00        ADDB    <$00          ; B += original (B = index * 6)
$47A9: 4F           CLRA                  ; D = 0:B = index * 6
$47AA: 10 8E 47 C7  LDY     #$47C7        ; Y -> animation parameter table
$47AE: 31 AB        LEAY    D,Y           ; Y += index * 6
$47B0: EC A1        LDD     ,Y++          ; Read bytes 0-1 from table
$47B2: ED 88 11     STD     17,X          ; Store to entity offset 17-18 (vel_y)
$47B5: EC A1        LDD     ,Y++          ; Read bytes 2-3
$47B7: ED 0F        STD     15,X          ; Store to entity offset 15-16 (vel_x)
$47B9: EC A1        LDD     ,Y++          ; Read bytes 4-5
$47BB: ED 0D        STD     13,X          ; Store to entity offset 13-14 (speed_angle/mag)
$47BD: A6 84        LDA     ,X            ; A = entity.state
$47BF: 84 F0        ANDA    #$F0          ; Keep upper nibble
$47C1: 8A 02        ORA     #$02          ; Set state to 2 (attacking)
$47C3: A7 84        STA     ,X            ; Write back
$47C5: 35 FE        PULS    A,B,DP,X,Y,U,PC ; Restore and return


=== DATA TABLE: Animation Parameters ($47C7) ===
6 bytes per entry, loaded by set_animation_params.
Format: [vel_y_hi, vel_y_lo, vel_x_hi, vel_x_lo, speed_angle, speed_mag]

$47C7: 01 00 01 00 00 90   ; Entry 0: vel_y=+1.0, vel_x=+1.0, angle=0, speed=$90
$47CD: 01 00 FF 00 00 90   ; Entry 1: vel_y=+1.0, vel_x=-1.0
$47D3: 01 00 00 00 00 90   ; Entry 2: vel_y=+1.0, vel_x=0
$47D9: 08 00 03 00 00 C0   ; Entry 3: vel_y=+8.0, vel_x=+3.0 (big jump?)
$47DF: 01 00 00 00 00 90   ; Entry 4: vel_y=+1.0, vel_x=0
$47E5: 06 00 02 00 00 90   ; Entry 5: vel_y=+6.0, vel_x=+2.0
$47EB: 01 00 03 00 00 90   ; Entry 6: vel_y=+1.0, vel_x=+3.0
$47F1: 00 00 00 00 00 50   ; Entry 7: vel_y=0, vel_x=0, speed=$50
$47F7: 0A 00 02 00 00 D0   ; Entry 8: vel_y=+10.0, vel_x=+2.0
$47FD: 09 00 02 00 01 00   ; Entry 9: vel_y=+9.0, vel_x=+2.0
$4803: 07 00 00 00 00 E0   ; Entry 10: vel_y=+7.0, vel_x=0
$4809: 09 F0 02 00 01 00   ; Entry 11: vel_y=+9.94, vel_x=+2.0
$480F: 07 ...               ; Entry 12+ (continues)
*/


// ============================================================================
// SECTION 2: DATA TABLE AT $46BF EXPLAINED
// ============================================================================

/**
 * Direction Offset Table ($46BF)
 *
 * This 16-byte table maps computed quadrant indices to angular offsets.
 * The index is built by the direction_size_calculator ($4679) as follows:
 *
 *   bit 3: set if Y-delta is negative (target above current entity)
 *   bit 2: set if X-delta is negative (target left of current entity)
 *   bit 1-0: magnitude category:
 *     00 = strongly vertical (|dy| >> |dx|)
 *     01 = diagonal (|dx| roughly equals |dy|)
 *     10 = horizontal (|dx| > |dy|)
 *     11 = strongly horizontal (|dx| >> |dy|)
 *
 * The output value is a direction byte in the 256-unit angular system:
 *   $00 = facing "south" (down)
 *   $40 = facing "east" (right)
 *   $80 = facing "north" (up)
 *   $C0 = facing "west" (left)
 *
 * Table contents and their directional meanings:
 *
 *   Index | Bits 3210 | DY  | DX  | Mag      | Value | Direction
 *   ------+-----------+-----+-----+----------+-------+----------
 *     0   |  0000     | +   | +   | vertical | $00   | South (down)
 *     1   |  0001     | +   | +   | diagonal | $20   | South-East
 *     2   |  0010     | +   | +   | horiz    | $40   | East (right)
 *     3   |  0011     | +   | +   | str.horz | $20   | South-East (close to E)
 *     4   |  0100     | +   | -   | vertical | $80   | North (up) [mirrored]
 *     5   |  0101     | +   | -   | diagonal | $60   | North-East
 *     6   |  0110     | +   | -   | horiz    | $40   | East
 *     7   |  0111     | +   | -   | str.horz | $60   | North-East
 *     8   |  1000     | -   | +   | vertical | $00   | South
 *     9   |  1001     | -   | +   | diagonal | $E0   | South-West
 *    10   |  1010     | -   | +   | horiz    | $C0   | West
 *    11   |  1011     | -   | +   | str.horz | $E0   | South-West
 *    12   |  1100     | -   | -   | vertical | $80   | North
 *    13   |  1101     | -   | -   | diagonal | $A0   | North-West
 *    14   |  1110     | -   | -   | horiz    | $C0   | West
 *    15   |  1111     | -   | -   | str.horz | $A0   | North-West
 */
const DIRECTION_OFFSET_TABLE = [
  0x00, 0x20, 0x40, 0x20, 0x80, 0x60, 0x40, 0x60,
  0x00, 0xE0, 0xC0, 0xE0, 0x80, 0xA0, 0xC0, 0xA0
];


// ============================================================================
// SECTION 3: JAVASCRIPT TRANSLATION
// ============================================================================

/**
 * Entity structure offsets (matching the 6809 code's X-register-relative access).
 * Every entity in the game occupies 36+ bytes at a base address (e.g., $0300).
 */
const ENTITY = {
  STATE:        0,
  TYPE:         1,
  TILE_SELECT:  2,
  FLAGS:        3,
  X_POS:        4,  // 16-bit, big-endian
  Y_POS:        6,  // 16-bit, big-endian (depth on playfield)
  Z_POS:        8,  // 16-bit, big-endian (height above ground)
  SPRITE_TILE:  22, // Current tile index from animation system
  SPRITE_ATTR:  23, // Palette (low nibble) + flip/priority
  ANIM_STATE:   27, // Animation state (6 bits used, 0-63)
  FRAME_PTR:    45, // Pointer to current animation frame data (16-bit)
};

/**
 * Reads a 16-bit big-endian value from a byte array at a given offset.
 */
function read16(data, offset) {
  return (data[offset] << 8) | data[offset + 1];
}

/**
 * Reads an 8-bit value as signed (-128 to +127).
 */
function signed8(v) {
  return v > 127 ? v - 256 : v;
}

/**
 * Reads a 16-bit value as signed (-32768 to +32767).
 */
function signed16(v) {
  return v > 32767 ? v - 65536 : v;
}

/**
 * Screen bounds check - equivalent to $462E.
 *
 * Determines if an entity is visible within the current camera viewport.
 *
 * @param {Uint8Array} entity - Entity data (byte array starting at entity base)
 * @param {number} cameraX - Current camera X position (16-bit, from DP:$3C)
 * @param {number} cameraY - Current camera Y position (16-bit, from DP:$3F)
 * @returns {boolean} true if visible, false if offscreen
 */
function isEntityVisible(entity, cameraX, cameraY) {
  const spriteAttr = entity[ENTITY.SPRITE_ATTR];

  // Special states $11 and $17 are handled differently (not drawn by this path)
  if (spriteAttr === 0x11 || spriteAttr === 0x17) {
    return false;
  }

  const xPos = read16(entity, ENTITY.X_POS);
  const yPos = read16(entity, ENTITY.Y_POS);
  const zPos = read16(entity, ENTITY.Z_POS);
  const screenY = (yPos + zPos) & 0xFFFF;

  // Check X bounds: entity must be within [cameraX - 64, cameraX + 320)
  const xAdjusted = (xPos + 0x40) & 0xFFFF;
  if ((xAdjusted >> 8) === 0xFF) return false;  // Overflow check
  if (xAdjusted < cameraX) return false;         // Too far left
  if (((cameraX + 0x140) & 0xFFFF) < xPos) return false; // Too far right

  // Check Y bounds: screenY must be within [cameraY - 64, cameraY + 320)
  const yAdjusted = (screenY + 0x40) & 0xFFFF;
  if ((yAdjusted >> 8) === 0xFF) return false;   // Overflow check
  if (yAdjusted < cameraY) return false;          // Too far above
  if (((cameraY + 0x140) & 0xFFFF) < screenY) return false; // Too far below

  return true;
}

/**
 * Direction/size calculator - equivalent to $4679.
 *
 * Calculates the directional relationship between two entities and returns
 * a facing offset from the 16-entry direction table.
 *
 * The subroutine at $4562 computes:
 *   - Absolute deltas: |target.x - self.x|, |target.y - self.y|
 *   - Direction flags: bit0 = X is negative, bit1 = Y is negative
 *
 * @param {Uint8Array} selfEntity - The entity we're computing direction for
 * @param {Uint8Array} targetEntity - The entity we're facing toward
 * @returns {number} Direction offset byte (0x00-0xE0 in steps of 0x20)
 */
function calculateDirectionOffset(selfEntity, targetEntity) {
  const selfX = read16(selfEntity, ENTITY.X_POS);
  const selfY = read16(selfEntity, ENTITY.Y_POS);
  const targetX = read16(targetEntity, ENTITY.X_POS);
  const targetY = read16(targetEntity, ENTITY.Y_POS);

  // Compute signed deltas
  let deltaX = signed16((targetX - selfX) & 0xFFFF);
  let deltaY = signed16((targetY - selfY) & 0xFFFF);

  // Build direction flags (bit0 = X negative, bit1 = Y negative)
  let dirFlags = 0;
  if (deltaX < 0) { dirFlags |= 0x01; deltaX = -deltaX; }
  if (deltaY < 0) { dirFlags |= 0x02; deltaY = -deltaY; }

  // Build quadrant index:
  // bit3 = Y-direction (from bit1 of dirFlags, shifted left by 2)
  // bit2 = X-direction (from bit0 of dirFlags, shifted left by 2)
  let quadrant = ((dirFlags & 0x02) << 2) | ((dirFlags & 0x01) << 2);
  // Note: the 6809 code does: bit3 = (flags << 3) & 0x08, bit2 = (flags << 1) & 0x04
  // So: bit3 = Y_neg, bit2 = X_neg
  quadrant = ((dirFlags << 2) & 0x08) | ((dirFlags << 1) & 0x04);

  // Magnitude comparison to determine sub-quadrant (bits 1-0)
  if (deltaX >= deltaY) {
    // Primarily horizontal movement
    quadrant += 2; // Start with "horizontal"
    const halfDX = deltaX >>> 1;
    if (halfDX < deltaY) {
      // dx/2 < dy -> not strongly horizontal, more diagonal
      quadrant += 1; // = 3 (strongly horizontal in the table sense)
    }
    // else stays at 2 (horizontal)
  } else {
    // Primarily vertical movement (quadrant bits 1-0 stay 0)
    const halfDY = deltaY >>> 1;
    if (halfDY < deltaX) {
      // dy/2 < dx -> diagonal region
      quadrant += 1;
    }
    // else stays at 0 (strongly vertical)
  }

  return DIRECTION_OFFSET_TABLE[quadrant & 0x0F];
}

/**
 * Main sprite composition function - equivalent to $46CE.
 *
 * This is the most critical rendering function in Double Dragon 2.
 * It takes an entity's data and produces the sprite entries that the
 * hardware will render on screen.
 *
 * In the original game, this writes to a composition buffer at $0281
 * (8 bytes per sprite) and registers a pointer in the table at $0381.
 * The sub-CPU later DMA's this to actual hardware sprite RAM.
 *
 * @param {Uint8Array} entityData - Full entity byte array (at least 46 bytes)
 * @param {number} entityBase - Base address of entity in memory (e.g., 0x0300)
 * @param {Uint8Array|null} frameData - Animation frame data (pointed to by entity offset 45)
 *                                       If null, reads from entityData at offset 45.
 * @param {object} gameState - Global game state:
 *   {
 *     spriteCount: current number of composed sprites (from $03A1),
 *     maxSprites: maximum sprites allowed (16),
 *     cameraX: camera X (from DP:$3C),
 *     cameraY: camera Y (from DP:$3F)
 *   }
 * @returns {object|null} Composed sprite entry, or null if not rendered:
 *   {
 *     type: entity type byte,
 *     tileSelect: tile selection byte,
 *     colorSource: resolved color/palette byte,
 *     xPos: 16-bit world X,
 *     yPos: 16-bit world Y,
 *     zPos: 16-bit world Z,
 *     visible: boolean (bit7 flag for priority/flash),
 *     spriteIndex: index in the sprite list
 *   }
 */
function composeSpriteEntry(entityData, entityBase, frameData, gameState) {
  // --- Check tile_select validity ---
  const tileSelect = entityData[ENTITY.TILE_SELECT] & 0x7F;
  if (tileSelect === 0x7F) {
    return null; // No sprite to render ($7F = invisible marker)
  }

  // --- Check sprite count limit ---
  if (gameState.spriteCount >= gameState.maxSprites) {
    return null; // Sprite list full
  }

  const spriteIndex = gameState.spriteCount;

  // --- Determine palette/attribute source ---
  const spriteTile = entityData[ENTITY.SPRITE_TILE]; // offset 22
  const paletteSelector = spriteTile & 0x06; // bits 1-2

  let spriteByte0; // Y-position / attribute byte
  let colorByte;   // Color / tile_hi byte

  if (paletteSelector !== 0) {
    // Use animation frame data for palette
    spriteByte0 = frameData ? frameData[1] : 0;

    if (paletteSelector & 0x02) {
      // bit1 set: use frame data byte 2 as color
      colorByte = frameData ? frameData[2] : 0;
    } else {
      // bit1 clear: use entity's tile_select as color
      colorByte = entityData[ENTITY.TILE_SELECT];
    }
  } else {
    // Use entity's own type as attribute byte
    spriteByte0 = entityData[ENTITY.TYPE]; // offset 1
    colorByte = entityData[ENTITY.TILE_SELECT]; // offset 2
  }

  // --- Read position data ---
  const xPos = read16(entityData, ENTITY.X_POS);
  const yPos = read16(entityData, ENTITY.Y_POS);
  const zPos = read16(entityData, ENTITY.Z_POS);

  // --- Check animation state for special handling ---
  const animState = entityData[ENTITY.ANIM_STATE] & 0x3F;
  let visible = false; // bit7 flag (priority / flash overlay)

  const isSpecialState = (animState === 0x06 || animState === 0x08 || animState === 0x0A);

  if (isSpecialState) {
    // For knockdown/hurt states: determine if flash overlay applies
    const entityType = entityData[ENTITY.TYPE];

    if (entityType >= 2) {
      // Enemy or player 2+: check frame data for flash trigger
      const frameVal = frameData ? frameData[1] : 0;
      if (frameVal === 0x01) {
        visible = true; // Apply flash/priority bit
      }
    } else if (entityType !== 0) {
      // Player 1 (type 1): always apply flash during special states
      visible = true;
    }
    // Type 0 (inactive): no flash
  }
  // For non-special states: visible stays false (bit7 not set)

  // Apply visible/priority bit to byte 0
  if (visible) {
    spriteByte0 |= 0x80;
  }

  // --- Register sprite in the pointer table ---
  gameState.spriteCount++;

  return {
    index: spriteIndex,
    byte0: spriteByte0,      // Y-attr / type / visible flag
    colorTileHi: colorByte,  // Color palette + tile high bits
    xPos: xPos,
    yPos: yPos,
    zPos: zPos,
    screenY: (yPos + zPos) & 0xFFFF, // Computed screen Y
    tileSelect: tileSelect,
    animState: animState,
    visible: visible,
    entityType: entityData[ENTITY.TYPE],
  };
}


/**
 * Complete character sprite composition - high-level equivalent.
 *
 * This wraps the three key functions ($462E, $4679, $46CE) into a single
 * call that mirrors what the game does during its rendering loop.
 *
 * The actual game calls this via the chain:
 *   $45DD (outer wrapper) -> $4562 (delta calc) -> $462E (bounds check)
 *                         -> $46CE (compose) -> writes to sprite buffer
 *
 * The composed sprites are later transformed by the sub-CPU into the final
 * hardware sprite RAM format (5 bytes per sprite):
 *   [Y_pos, attributes, color|tile_hi, tile_lo, X_pos]
 *
 * @param {Uint8Array} entityData - Raw entity bytes (40+ bytes)
 * @param {number} entityBase - Memory address of entity (e.g., 0x0300)
 * @param {Uint8Array|null} frameData - Current animation frame data
 * @param {object} gameState - Camera and sprite state
 * @returns {Array<object>} Array of sprite entries: { tile, x, y, color, size, flipX, flipY }
 */
function composeCharacterSprites(entityData, entityBase, frameData, gameState) {
  if (!gameState) {
    gameState = {
      spriteCount: 0,
      maxSprites: 16,
      cameraX: 0,
      cameraY: 0,
    };
  }

  const results = [];

  // Step 1: Screen bounds check ($462E)
  if (!isEntityVisible(entityData, gameState.cameraX, gameState.cameraY)) {
    return results; // Entity is offscreen, no sprites to compose
  }

  // Step 2: Compose the sprite entry ($46CE)
  const sprite = composeSpriteEntry(entityData, entityBase, frameData, gameState);
  if (!sprite) {
    return results;
  }

  // Step 3: Convert composed sprite to final hardware format
  // The sub-CPU performs this transformation during DMA.
  //
  // Hardware sprite RAM format (5 bytes per entry at $1000-$17FF):
  //   Byte 0: Y position (screen Y, inverted: 232 - y)
  //   Byte 1: Attributes
  //     bit7 = visible/enable
  //     bit5-4 = size (0=16x16, 1=16x32, 2=32x16, 3=32x32)
  //     bit3 = flipX
  //     bit2 = flipY
  //     bit1 = X MSB (bit 8 of X position)
  //     bit0 = Y MSB (bit 8 of Y position)
  //   Byte 2: (color << 5) | (tile >> 8)
  //   Byte 3: tile & 0xFF
  //   Byte 4: X position (low 8 bits)

  const tileSelect = sprite.tileSelect;
  const colorPalette = (sprite.colorTileHi >> 5) & 0x07;
  const tileHi = sprite.colorTileHi & 0x1F;
  const tileIndex = (tileHi << 8) | tileSelect;

  // Compute screen position relative to camera
  const screenX = (sprite.xPos - gameState.cameraX) & 0xFFFF;
  const screenY = (sprite.screenY - gameState.cameraY) & 0xFFFF;

  // Determine size from sprite_tile bits
  // Bits 4-5 of sprite attribute control size:
  const spriteTile = entityData[ENTITY.SPRITE_TILE];
  const sizeCode = (spriteTile >> 4) & 0x03;
  const sizeNames = ['16x16', '16x32', '32x16', '32x32'];
  const widths = [16, 16, 32, 32];
  const heights = [16, 32, 16, 32];

  // Determine flip from sprite_attr
  const spriteAttr = entityData[ENTITY.SPRITE_ATTR];
  const flipX = !!(spriteAttr & 0x08);
  const flipY = !!(spriteAttr & 0x04);

  // For 32x32 sprites, we compose 4 tiles; for 16x32 or 32x16, 2 tiles.
  // The tile indices are sequential: tile, tile+1, tile+2, tile+3.
  const tileCount = (widths[sizeCode] / 16) * (heights[sizeCode] / 16);
  const tilesWide = widths[sizeCode] / 16;
  const tilesHigh = heights[sizeCode] / 16;

  for (let ty = 0; ty < tilesHigh; ty++) {
    for (let tx = 0; tx < tilesWide; tx++) {
      // Tile index within the sprite block
      // Layout: tile+0 = top-left, tile+1 = bottom-left,
      //         tile+2 = top-right, tile+3 = bottom-right
      let tileOff = ty + tx * 2;
      if (tilesWide === 1 && tilesHigh === 2) tileOff = ty; // 16x32: just tile, tile+1

      // Apply flip to tile arrangement
      let drawX, drawY;
      if (flipX) {
        drawX = screenX + (tilesWide - 1 - tx) * 16;
      } else {
        drawX = screenX + tx * 16;
      }
      if (flipY) {
        drawY = screenY + (tilesHigh - 1 - ty) * 16;
      } else {
        drawY = screenY + ty * 16;
      }

      results.push({
        tile: (tileIndex + tileOff) & 0x1FFF,
        x: drawX & 0x1FF,
        y: drawY & 0x1FF,
        color: colorPalette,
        size: sizeNames[sizeCode],
        width: widths[sizeCode],
        height: heights[sizeCode],
        flipX: flipX,
        flipY: flipY,
        visible: sprite.visible,
        entityType: sprite.entityType,
        animState: sprite.animState,
      });
    }
  }

  return results;
}


/**
 * Simplified convenience function matching the requested signature.
 *
 * @param {Uint8Array} entityData - Raw entity byte array
 * @param {number} entityBase - Base address (e.g., 0x0300)
 * @param {object} [options] - Optional overrides
 * @param {Uint8Array} [options.frameData] - Animation frame data
 * @param {number} [options.cameraX=0] - Camera X scroll
 * @param {number} [options.cameraY=0] - Camera Y scroll
 * @returns {Array<{tile: number, x: number, y: number, color: number,
 *           size: string, flipX: boolean, flipY: boolean}>}
 */
function composeCharacterSpritesSimple(entityData, entityBase, options) {
  const opts = options || {};
  const gameState = {
    spriteCount: 0,
    maxSprites: 16,
    cameraX: opts.cameraX || 0,
    cameraY: opts.cameraY || 0,
  };

  return composeCharacterSprites(
    entityData,
    entityBase,
    opts.frameData || null,
    gameState
  );
}


// ============================================================================
// SECTION 4: SPRITE COMPOSITION LOOP IDENTIFICATION
// ============================================================================

/**
 * THE SPRITE COMPOSITION LOOP
 *
 * The sprite composition loop is NOT contained entirely within $462E-$4810.
 * Instead, the loop lives in the main CPU ROM (at $8000+) and calls into
 * the banked ROM for each entity. The structure is:
 *
 *   Main loop (main ROM):
 *     for each entity in entity table ($0300, $0324, $0348, ...):
 *       JSR $FC82          ; Enable bank
 *       JSR $45DD          ; Call outer sprite compositor (banked)
 *       JSR $FC8F          ; Disable bank
 *
 *   $45DD (banked ROM) - Outer wrapper:
 *     - Calls $4562 to compute deltas between entities
 *     - Calls $462E to check screen bounds
 *     - If visible, computes screen-relative position
 *     - Calls $46CE to compose the sprite entry
 *
 *   $46CE (banked ROM) - Inner composer (THE KEY FUNCTION):
 *     - Reads entity tile_select (offset 2) as the sprite identifier
 *     - Gets a slot in the sprite buffer at $0281 (8 bytes per slot)
 *     - Resolves palette: either from entity type or animation frame data
 *     - Copies entity x/y/z positions into the sprite buffer
 *     - Checks animation state for special visual effects (flash on hurt)
 *     - Registers the sprite pointer in the table at $0381
 *     - Increments the global sprite count at $03A1
 *
 * The composed buffer at $0281 is NOT the final hardware sprite RAM.
 * The sub-CPU (Z80) performs the final transformation:
 *   1. Reads the pointer table at $0381
 *   2. For each pointer, reads the 8-byte composed entry
 *   3. Converts world coordinates to screen coordinates using camera offset
 *   4. Writes the 5-byte hardware sprite entry to $1000-$17FF
 *   5. Handles tile arrangement for multi-tile sprites (16x32, 32x16, 32x32)
 */


// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    DIRECTION_OFFSET_TABLE,
    ENTITY,
    isEntityVisible,
    calculateDirectionOffset,
    composeSpriteEntry,
    composeCharacterSprites,
    composeCharacterSpritesSimple,
    read16,
    signed8,
    signed16,
  };
}
