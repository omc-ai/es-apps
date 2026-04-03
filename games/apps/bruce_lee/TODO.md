# Bruce Lee C64 → JavaScript Port - Status & TODO

## What We Have (Extracted & Verified)
- `vice_gameplay2.bin` - 64KB VICE memory dump during actual gameplay (authoritative)
- `vice_screenshot.png` - VICE screenshot of real game running
- `disassembly.asm` - 5,916 lines of 6502 disassembly
- `stage1_ram.bin`, `stage2_ram.bin` - Memory at different decompression stages
- `build_data.json` - All charsets, sprites, room tables, color RAM
- `room_tables.json` - Room pointer tables, color tables, position tables
- `sprite_analysis.json` - Sprite overlay pair analysis
- `complete_assets.json` - Full sprite catalog with metadata

## VIC Bank 2 ($8000-$BFFF) Layout
- $8000-$83FF: Sprite blocks 0-15 (characters: Bruce, Yamo, Ninja, lantern)
- $8400-$87FF: Sprite blocks 16-31 (background patterns, scenery)
- $8800-$8FFF: Game charset (multicolor, 256 chars)
- $8C00-$8FF7: Screen RAM (40x25)
- $8FF8-$8FFF: Sprite pointers (8 bytes)

## Sprite Overlay System
- Even blocks = fill sprite (colored body)
- Odd blocks = outline sprite (black detail)  
- Sprite pairs overlaid at same position for multi-color characters
- Bruce Lee: Spr0(fill,yellow=7) + Spr1(outline,black=0) 
- Green Yamo: Spr2(fill,green/white) + Spr3(outline,black=0)
- Ninja: Spr4(single,black=0)
- Active blocks at capture: [6,7,8,9,10,11,15,15]

## Room Data Tables (in game memory)
- $47A0: Room color byte (20 entries)
- $4AA8: Room layout pointers (20 x 2-byte entries)
- $4BC2: Bruce starting position (20 entries)
- $4BEA: Enemy starting position (20 entries)  
- $4C9E: Room exit flags (20 entries, $00 or $FF)
- $1333/$136F: Enemy behavior flags

## Game Code Entry Points (from disassembly)
- Room variable: ZP $29
- Room setup uses: LDX $29; LDA $47A0,X (color)
- Room layout: LDA $29; ASL; TAX; LDA $4AA8,X (pointer to screen data)
- Room drawing routine: $0927+ (needs full trace)
- Player movement/physics: needs identification
- Enemy AI: needs identification
- Combat: needs identification
- Lantern collection: needs identification

## TODO - The Right Way

### Phase 1: Trace the 6502 game code
1. Map ALL subroutines in the game code ($0400-$0CFF)
2. Identify the main game loop
3. Trace player input handling
4. Trace movement physics (gravity, jump arc, speeds)
5. Trace platform/ladder collision
6. Trace combat system
7. Trace enemy AI pathfinding
8. Trace room drawing routine (decode the compressed format)
9. Trace room transition logic
10. Trace score/lives system

### Phase 2: Translate each routine to JavaScript
- Match EXACT speeds, timings, distances
- Use the same collision detection approach
- Use the same AI logic
- Use the same room data format

### Phase 3: Rendering
- Render charset tiles with correct per-cell colors from color RAM
- Render sprite overlays correctly
- Match the raster split (status bar vs game area)

### Phase 4: Polish
- Title screen with original portrait
- Sound effects matching SID
- All 20 rooms working
- Mobile touch controls
