; ====================================================================
; BRUCE LEE (C64, 1984 Datasoft)
; Complete Annotated Disassembly - Game Code
; From VICE gameplay memory dump
; ====================================================================


; ====================================================================
; MAIN GAME CODE ($0400-$0CFF)
; ====================================================================

$0400  78           SEI
$0401  D8           CLD
$0402  A2 FF        LDX #$FF
$0404  9A           TXS
$0405  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0408  1E 49 8D     ASL $8D49,X
$040B  11 D0        ORA ($D0),Y
$040D  AD FF 03     LDA $03FF
$0410  F0 03        BEQ $0415
$0412  4C D1 04     JMP $04D1
$0415  A9 00        LDA #$00
$0417  8D 00 EB     STA $EB00
$041A  8D 70 EF     STA $EF70
$041D  8D 70 F0     STA $F070
$0420  8D 1B D4     STA $D41B ; SID_V3_OSC
$0423  A9 FF        LDA #$FF
$0425  8D 0F D4     STA $D40F ; SID_V3_FREQ_HI
$0428  8D 0E D4     STA $D40E ; SID_V3_FREQ_LO
$042B  A9 80        LDA #$80
$042D  8D 12 D4     STA $D412 ; SID_V3_CTRL
$0430  A2 00        LDX #$00
$0432  A0 60        LDY #$60
$0434  88           DEY
$0435  D0 FD        BNE $0434
$0437  AD 1B D4     LDA $D41B ; SID_V3_OSC
$043A  9D 00 02     STA $0200,X
$043D  E8           INX
$043E  D0 F2        BNE $0432
$0440  EA           NOP
$0441  EA           NOP
$0442  EA           NOP
$0443  A9 32        LDA #$32
$0445  85 01        STA $01 ; CPU_PORT
$0447  A2 00        LDX #$00
$0449  BD 00 D0     LDA $D000,X ; VIC_SPR0_X
$044C  9D 00 89     STA $8900,X
$044F  49 FF        EOR #$FF
$0451  9D 00 8B     STA $8B00,X
$0454  BD 00 D1     LDA $D100,X
$0457  9D 00 88     STA $8800,X
$045A  49 FF        EOR #$FF
$045C  9D 00 8A     STA $8A00,X
$045F  E8           INX
$0460  D0 E7        BNE $0449
$0462  A9 36        LDA #$36
$0464  85 01        STA $01 ; CPU_PORT
$0466  A2 07        LDX #$07
$0468  A9 FF        LDA #$FF
$046A  9D 00 89     STA $8900,X
$046D  A9 03        LDA #$03
$046F  9D 10 8A     STA $8A10,X
$0472  A9 C0        LDA #$C0
$0474  9D B0 8A     STA $8AB0,X
$0477  CA           DEX
$0478  10 EE        BPL $0468
$047A  A9 7F        LDA #$7F
$047C  85 F3        STA $F3 ; draw_counter
$047E  A9 00        LDA #$00
$0480  85 04        STA $04 ; screen_ptr_lo
$0482  A9 90        LDA #$90
$0484  85 05        STA $05 ; screen_ptr_hi
$0486  A9 00        LDA #$00
$0488  85 06        STA $06 ; data_ptr_lo
$048A  85 08        STA $08 ; color_ptr_lo
$048C  A9 A0        LDA #$A0
$048E  85 07        STA $07 ; data_ptr_hi
$0490  A9 A4        LDA #$A4
$0492  85 09        STA $09 ; color_ptr_hi
$0494  20 92 48     JSR $4892
$0497  A9 7F        LDA #$7F
$0499  85 F3        STA $F3 ; draw_counter
$049B  A9 00        LDA #$00
$049D  85 04        STA $04 ; screen_ptr_lo
$049F  A9 94        LDA #$94
$04A1  85 05        STA $05 ; screen_ptr_hi
$04A3  A9 00        LDA #$00
$04A5  85 06        STA $06 ; data_ptr_lo
$04A7  85 08        STA $08 ; color_ptr_lo
$04A9  A9 A8        LDA #$A8
$04AB  85 07        STA $07 ; data_ptr_hi
$04AD  A9 AC        LDA #$AC
$04AF  85 09        STA $09 ; color_ptr_hi
$04B1  20 92 48     JSR $4892
$04B4  A9 7F        LDA #$7F
$04B6  85 F3        STA $F3 ; draw_counter
$04B8  A9 00        LDA #$00
$04BA  85 04        STA $04 ; screen_ptr_lo
$04BC  A9 98        LDA #$98
$04BE  85 05        STA $05 ; screen_ptr_hi
$04C0  A9 00        LDA #$00
$04C2  85 06        STA $06 ; data_ptr_lo
$04C4  85 08        STA $08 ; color_ptr_lo
$04C6  A9 B0        LDA #$B0
$04C8  85 07        STA $07 ; data_ptr_hi
$04CA  A9 B4        LDA #$B4
$04CC  85 09        STA $09 ; color_ptr_hi
$04CE  20 92 48     JSR $4892

; --- Subroutine at $04D1 ---
$04D1  A9 7F        LDA #$7F
$04D3  85 F3        STA $F3 ; draw_counter
$04D5  A9 00        LDA #$00
$04D7  85 04        STA $04 ; screen_ptr_lo
$04D9  A9 9C        LDA #$9C
$04DB  85 05        STA $05 ; screen_ptr_hi
$04DD  A9 00        LDA #$00
$04DF  85 06        STA $06 ; data_ptr_lo
$04E1  85 08        STA $08 ; color_ptr_lo
$04E3  A9 B8        LDA #$B8
$04E5  AA           TAX
$04E6  9A           TXS
$04E7  85 07        STA $07 ; data_ptr_hi
$04E9  A9 BC        LDA #$BC
$04EB  85 09        STA $09 ; color_ptr_hi
$04ED  20 92 48     JSR $4892
$04F0  20 2F 51     JSR $512F
$04F3  20 F7 10     JSR $10F7
$04F6  A9 35        LDA #$35
$04F8  85 01        STA $01 ; CPU_PORT
$04FA  A9 F0        LDA #$F0
$04FC  8D 28 D0     STA $D028 ; VIC_SPR1_COL
$04FF  8D 2A D0     STA $D02A ; VIC_SPR3_COL
$0502  8D 2B D0     STA $D02B ; VIC_SPR4_COL
$0505  A9 F7        LDA #$F7
$0507  8D 27 D0     STA $D027 ; VIC_SPR0_COL
$050A  A9 F5        LDA #$F5
$050C  8D 29 D0     STA $D029 ; VIC_SPR2_COL

; --- Subroutine at $050F ---
$050F  78           SEI
$0510  D8           CLD
$0511  A2 FD        LDX #$FD
$0513  9A           TXS
$0514  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0517  29 EF        AND #$EF
$0519  8D 11 D0     STA $D011 ; VIC_CTRL1
$051C  20 00 E0     JSR $E000
$051F  A9 00        LDA #$00
$0521  85 16        STA $16
$0523  A9 02        LDA #$02
$0525  85 17        STA $17
$0527  78           SEI
$0528  20 72 0F     JSR $0F72
$052B  20 63 07     JSR $0763
$052E  4C 84 05     JMP $0584

; --- Subroutine at $0531 ---
$0531  78           SEI
$0532  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0535  29 EF        AND #$EF
$0537  8D 11 D0     STA $D011 ; VIC_CTRL1
$053A  A9 00        LDA #$00
$053C  8D 15 D0     STA $D015 ; VIC_SPR_EN
$053F  8D 00 D0     STA $D000 ; VIC_SPR0_X
$0542  8D 01 D0     STA $D001 ; VIC_SPR0_Y
$0545  A9 01        LDA #$01
$0547  8D 0A E3     STA $E30A
$054A  20 00 E0     JSR $E000
$054D  A2 FD        LDX #$FD
$054F  9A           TXS
$0550  20 72 0F     JSR $0F72
$0553  20 63 07     JSR $0763
$0556  4E 04 01     LSR $0104
$0559  AD C9 42     LDA $42C9
$055C  8D CB 42     STA $42CB
$055F  AD CA 42     LDA $42CA
$0562  8D CC 42     STA $42CC
$0565  A9 00        LDA #$00
$0567  8D CA 42     STA $42CA
$056A  8D C9 42     STA $42C9
$056D  20 BC 09     JSR $09BC
$0570  A9 00        LDA #$00
$0572  85 1D        STA $1D
$0574  A9 F3        LDA #$F3
$0576  85 1E        STA $1E
$0578  20 DB 50     JSR $50DB
$057B  EA           NOP
$057C  EA           NOP
$057D  EA           NOP
$057E  EA           NOP
$057F  EA           NOP
$0580  58           CLI
$0581  4C C2 1B     JMP $1BC2

; --- Subroutine at $0584 ---
$0584  78           SEI
$0585  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0588  29 EF        AND #$EF
$058A  8D 11 D0     STA $D011 ; VIC_CTRL1
$058D  20 5E 25     JSR $255E
$0590  A9 00        LDA #$00
$0592  8D 00 01     STA $0100
$0595  20 56 1A     JSR $1A56
$0598  20 2E 0E     JSR $0E2E
$059B  A2 3F        LDX #$3F
$059D  A9 00        LDA #$00
$059F  9D C0 83     STA $83C0,X
$05A2  CA           DEX
$05A3  10 FA        BPL $059F
$05A5  A9 01        LDA #$01
$05A7  8D 15 D0     STA $D015 ; VIC_SPR_EN
$05AA  8D 1D D0     STA $D01D ; VIC_SPR_XEXP
$05AD  8D 10 D0     STA $D010 ; VIC_SPR_XMSB
$05B0  A9 00        LDA #$00
$05B2  8D 17 D0     STA $D017 ; VIC_SPR_YEXP
$05B5  8D 1B D0     STA $D01B ; VIC_SPR_PRI
$05B8  8D 1C D0     STA $D01C ; VIC_SPR_MC
$05BB  A9 0A        LDA #$0A
$05BD  8D 00 D0     STA $D000 ; VIC_SPR0_X
$05C0  A9 56        LDA #$56
$05C2  8D 01 D0     STA $D001 ; VIC_SPR0_Y
$05C5  A9 FF        LDA #$FF
$05C7  8D 27 D0     STA $D027 ; VIC_SPR0_COL
$05CA  A9 0F        LDA #$0F
$05CC  8D F8 8F     STA $8FF8
$05CF  A2 0B        LDX #$0B
$05D1  BD 40 0E     LDA $0E40,X
$05D4  9D CC 83     STA $83CC,X
$05D7  CA           DEX
$05D8  10 F7        BPL $05D1
$05DA  A9 2C        LDA #$2C
$05DC  8D 08 04     STA $0408
$05DF  A9 15        LDA #$15
$05E1  8D 09 04     STA $0409
$05E4  A9 01        LDA #$01
$05E6  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$05E9  8D 19 D0     STA $D019 ; VIC_IRQ
$05EC  AD 11 D0     LDA $D011 ; VIC_CTRL1
$05EF  29 7F        AND #$7F
$05F1  8D 11 D0     STA $D011 ; VIC_CTRL1
$05F4  A9 FD        LDA #$FD
$05F6  8D 12 D0     STA $D012 ; VIC_RASTER
$05F9  A9 F6        LDA #$F6
$05FB  8D 20 D0     STA $D020 ; VIC_BORDER
$05FE  8D 21 D0     STA $D021 ; VIC_BG0
$0601  A9 FF        LDA #$FF
$0603  8D 22 D0     STA $D022 ; VIC_MC1
$0606  8D 23 D0     STA $D023 ; VIC_MC2
$0609  A2 08        LDX #$08
$060B  8E 16 D0     STX $D016 ; VIC_CTRL2
$060E  20 A9 09     JSR $09A9
$0611  A2 00        LDX #$00
$0613  A9 F1        LDA #$F1
$0615  9D E0 D9     STA $D9E0,X
$0618  9D E0 DA     STA $DAE0,X
$061B  A9 DC        LDA #$DC
$061D  9D 00 8C     STA $8C00,X
$0620  9D 68 8C     STA $8C68,X
$0623  CA           DEX
$0624  D0 ED        BNE $0613
$0626  A2 27        LDX #$27
$0628  BD 0D 4A     LDA $4A0D,X
$062B  09 80        ORA #$80
$062D  9D 50 8C     STA $8C50,X
$0630  BD BD 49     LDA $49BD,X
$0633  09 80        ORA #$80
$0635  9D C8 8C     STA $8CC8,X
$0638  BD E5 49     LDA $49E5,X
$063B  09 80        ORA #$80
$063D  9D F0 8C     STA $8CF0,X
$0640  BD 35 4A     LDA $4A35,X
$0643  09 80        ORA #$80
$0645  9D 68 8D     STA $8D68,X
$0648  CA           DEX
$0649  10 DD        BPL $0628
$064B  A9 FF        LDA #$FF
$064D  8D 00 01     STA $0100
$0650  A9 4F        LDA #$4F
$0652  A2 06        LDX #$06
$0654  A0 31        LDY #$31
$0656  20 E2 17     JSR $17E2
$0659  A9 50        LDA #$50
$065B  A2 07        LDX #$07
$065D  A0 2B        LDY #$2B
$065F  20 E2 17     JSR $17E2
$0662  A9 51        LDA #$51
$0664  A2 08        LDX #$08
$0666  A0 31        LDY #$31
$0668  20 E2 17     JSR $17E2
$066B  A2 09        LDX #$09
$066D  BD F0 8D     LDA $8DF0,X
$0670  18           CLC
$0671  69 40        ADC #$40
$0673  9D F0 8D     STA $8DF0,X
$0676  BD 40 8E     LDA $8E40,X
$0679  18           CLC
$067A  69 40        ADC #$40
$067C  9D 40 8E     STA $8E40,X
$067F  E0 02        CPX #$02
$0681  B0 1B        BCS $069E
$0683  BD EB 8D     LDA $8DEB,X
$0686  18           CLC
$0687  69 40        ADC #$40
$0689  9D EB 8D     STA $8DEB,X
$068C  BD 3B 8E     LDA $8E3B,X
$068F  18           CLC
$0690  69 40        ADC #$40
$0692  9D 3B 8E     STA $8E3B,X
$0695  BD 8B 8E     LDA $8E8B,X
$0698  18           CLC
$0699  69 40        ADC #$40
$069B  9D 8B 8E     STA $8E8B,X
$069E  CA           DEX
$069F  10 CC        BPL $066D
$06A1  AD CB 42     LDA $42CB
$06A4  8D C9 42     STA $42C9
$06A7  AD CC 42     LDA $42CC
$06AA  8D CA 42     STA $42CA
$06AD  AD C9 42     LDA $42C9
$06B0  F0 03        BEQ $06B5
$06B2  20 65 0E     JSR $0E65
$06B5  AD CA 42     LDA $42CA
$06B8  F0 03        BEQ $06BD
$06BA  20 4C 0E     JSR $0E4C
$06BD  AD 85 13     LDA $1385
$06C0  D0 1B        BNE $06DD
$06C2  CE BB 09     DEC $09BB
$06C5  10 16        BPL $06DD
$06C7  A9 04        LDA #$04
$06C9  8D BB 09     STA $09BB
$06CC  A9 03        LDA #$03
$06CE  8D 14 E3     STA $E314
$06D1  A2 00        LDX #$00
$06D3  8E 70 E8     STX $E870
$06D6  CA           DEX
$06D7  8E 71 E8     STX $E871
$06DA  20 03 E0     JSR $E003
$06DD  A2 00        LDX #$00
$06DF  BD 8F CF     LDA $CF8F,X
$06E2  5D B1 CF     EOR $CFB1,X
$06E5  5D 90 CF     EOR $CF90,X
$06E8  5D AF CF     EOR $CFAF,X
$06EB  5D 91 CF     EOR $CF91,X
$06EE  5D B0 CF     EOR $CFB0,X
$06F1  F0 07        BEQ $06FA

; --- Subroutine at $06F3 ---
$06F3  91 1D        STA ($1D),Y
$06F5  E6 1E        INC $1E
$06F7  4C F3 06     JMP $06F3
$06FA  A9 09        LDA #$09
$06FC  85 4A        STA $4A
$06FE  A9 60        LDA #$60
$0700  85 49        STA $49
$0702  20 DB 50     JSR $50DB
$0705  EA           NOP
$0706  EA           NOP
$0707  EA           NOP
$0708  EA           NOP
$0709  EA           NOP
$070A  58           CLI
$070B  20 B1 08     JSR $08B1
$070E  78           SEI
$070F  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0712  29 EF        AND #$EF
$0714  8D 11 D0     STA $D011 ; VIC_CTRL1
$0717  A9 00        LDA #$00
$0719  8D 15 D0     STA $D015 ; VIC_SPR_EN
$071C  8D 00 D0     STA $D000 ; VIC_SPR0_X
$071F  8D 01 D0     STA $D001 ; VIC_SPR0_Y
$0722  85 03        STA $03 ; room_subtype
$0724  A9 01        LDA #$01
$0726  8D 0A E3     STA $E30A
$0729  20 00 E0     JSR $E000
$072C  AD C9 42     LDA $42C9
$072F  8D CB 42     STA $42CB
$0732  AD CA 42     LDA $42CA
$0735  8D CC 42     STA $42CC
$0738  20 A7 0E     JSR $0EA7
$073B  AD 11 D0     LDA $D011 ; VIC_CTRL1
$073E  29 EF        AND #$EF
$0740  8D 11 D0     STA $D011 ; VIC_CTRL1
$0743  A2 FD        LDX #$FD
$0745  9A           TXS
$0746  20 72 0F     JSR $0F72
$0749  20 63 07     JSR $0763
$074C  20 BC 09     JSR $09BC
$074F  A9 00        LDA #$00
$0751  85 1D        STA $1D
$0753  A9 F3        LDA #$F3
$0755  85 1E        STA $1E
$0757  20 DB 50     JSR $50DB
$075A  EA           NOP
$075B  EA           NOP
$075C  EA           NOP
$075D  EA           NOP
$075E  EA           NOP
$075F  58           CLI
$0760  4C C2 1B     JMP $1BC2

; --- Subroutine at $0763 ---
$0763  A9 00        LDA #$00
$0765  85 8B        STA $8B
$0767  85 8C        STA $8C
$0769  20 2D 08     JSR $082D
$076C  20 86 13     JSR $1386
$076F  A9 FF        LDA #$FF
$0771  85 4B        STA $4B
$0773  A0 8B        LDY #$8B
$0775  A9 D8        LDA #$D8
$0777  20 69 08     JSR $0869
$077A  A9 00        LDA #$00
$077C  8D 38 43     STA $4338
$077F  8D 60 43     STA $4360
$0782  8D 61 43     STA $4361
$0785  A9 8C        LDA #$8C
$0787  8D 4C 43     STA $434C
$078A  A9 CE        LDA #$CE
$078C  8D 74 43     STA $4374
$078F  8D 75 43     STA $4375
$0792  20 56 1A     JSR $1A56
$0795  A9 F8        LDA #$F8
$0797  20 A9 09     JSR $09A9
$079A  A2 27        LDX #$27
$079C  A9 00        LDA #$00
$079E  9D 00 D8     STA $D800,X
$07A1  9D 28 D8     STA $D828,X
$07A4  A9 20        LDA #$20
$07A6  9D 00 8C     STA $8C00,X
$07A9  A9 06        LDA #$06
$07AB  9D 50 8C     STA $8C50,X
$07AE  E0 08        CPX #$08
$07B0  B0 0A        BCS $07BC
$07B2  A9 0F        LDA #$0F
$07B4  9D F8 8F     STA $8FF8,X
$07B7  A9 FF        LDA #$FF
$07B9  9D 00 89     STA $8900,X
$07BC  CA           DEX
$07BD  10 DD        BPL $079C
$07BF  A9 00        LDA #$00
$07C1  AA           TAX
$07C2  9D 80 81     STA $8180,X
$07C5  9D 80 82     STA $8280,X
$07C8  9D 00 83     STA $8300,X
$07CB  E8           INX
$07CC  D0 F4        BNE $07C2
$07CE  A2 03        LDX #$03
$07D0  BD 9B 47     LDA $479B,X
$07D3  9D 20 D0     STA $D020,X ; VIC_BORDER
$07D6  CA           DEX
$07D7  10 F7        BPL $07D0
$07D9  A9 01        LDA #$01
$07DB  8D 00 DD     STA $DD00 ; CIA2_PRA
$07DE  A9 38        LDA #$38
$07E0  8D 18 D0     STA $D018 ; VIC_MEM
$07E3  85 F2        STA $F2 ; scroll_state
$07E5  A9 18        LDA #$18
$07E7  8D 16 D0     STA $D016 ; VIC_CTRL2
$07EA  A9 00        LDA #$00
$07EC  8D 15 D0     STA $D015 ; VIC_SPR_EN
$07EF  8D 17 D0     STA $D017 ; VIC_SPR_YEXP
$07F2  8D 1B D0     STA $D01B ; VIC_SPR_PRI
$07F5  8D 1C D0     STA $D01C ; VIC_SPR_MC
$07F8  A9 FF        LDA #$FF
$07FA  8D 1D D0     STA $D01D ; VIC_SPR_XEXP
$07FD  A9 80        LDA #$80
$07FF  20 5A 31     JSR $315A
$0802  20 C2 31     JSR $31C2
$0805  A9 11        LDA #$11
$0807  8D BD 43     STA $43BD
$080A  20 96 1A     JSR $1A96
$080D  20 BB 1A     JSR $1ABB
$0810  20 C7 1A     JSR $1AC7
$0813  20 ED 1A     JSR $1AED
$0816  A9 01        LDA #$01
$0818  85 60        STA $60
$081A  85 66        STA $66
$081C  A2 04        LDX #$04
$081E  A9 FF        LDA #$FF
$0820  9D 40 4F     STA $4F40,X
$0823  CA           DEX
$0824  10 FA        BPL $0820
$0826  A2 00        LDX #$00
$0828  A9 00        LDA #$00
$082A  4C 8E 0B     JMP $0B8E

; --- Subroutine at $082D ---
$082D  A9 7F        LDA #$7F
$082F  8D 0D DD     STA $DD0D
$0832  8D 0D DC     STA $DC0D ; CIA1_ICR
$0835  AD 0D DD     LDA $DD0D
$0838  AD 0D DC     LDA $DC0D ; CIA1_ICR
$083B  D8           CLD
$083C  A9 C1        LDA #$C1
$083E  8D 08 04     STA $0408
$0841  A9 48        LDA #$48
$0843  8D 09 04     STA $0409
$0846  A9 01        LDA #$01
$0848  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$084B  8D 19 D0     STA $D019 ; VIC_IRQ
$084E  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0851  29 7F        AND #$7F
$0853  8D 11 D0     STA $D011 ; VIC_CTRL1
$0856  A9 FB        LDA #$FB
$0858  8D 12 D0     STA $D012 ; VIC_RASTER
$085B  A9 FF        LDA #$FF
$085D  8D 0E D4     STA $D40E ; SID_V3_FREQ_LO
$0860  8D 0F D4     STA $D40F ; SID_V3_FREQ_HI
$0863  A9 80        LDA #$80
$0865  8D 12 D4     STA $D412 ; SID_V3_CTRL
$0868  60           RTS

; --- Subroutine at $0869 ---
$0869  A2 00        LDX #$00
$086B  8D 38 43     STA $4338
$086E  8C 4C 43     STY $434C
$0871  BD 38 43     LDA $4338,X
$0874  18           CLC
$0875  69 50        ADC #$50
$0877  9D 39 43     STA $4339,X
$087A  BD 4C 43     LDA $434C,X
$087D  69 00        ADC #$00
$087F  9D 4D 43     STA $434D,X
$0882  E8           INX
$0883  E0 0D        CPX #$0D
$0885  90 EA        BCC $0871
$0887  AD 38 43     LDA $4338
$088A  18           CLC
$088B  69 28        ADC #$28
$088D  8D 60 43     STA $4360
$0890  AD 4C 43     LDA $434C
$0893  69 00        ADC #$00
$0895  8D 74 43     STA $4374
$0898  A2 00        LDX #$00
$089A  BD 60 43     LDA $4360,X
$089D  18           CLC
$089E  69 50        ADC #$50
$08A0  9D 61 43     STA $4361,X
$08A3  BD 74 43     LDA $4374,X
$08A6  69 00        ADC #$00
$08A8  9D 75 43     STA $4375,X
$08AB  E8           INX
$08AC  E0 0D        CPX #$0D
$08AE  90 EA        BCC $089A
$08B0  60           RTS

; --- Subroutine at $08B1 ---
$08B1  A5 49        LDA $49
$08B3  05 4A        ORA $4A
$08B5  D0 03        BNE $08BA
$08B7  4C 31 05     JMP $0531
$08BA  A9 00        LDA #$00
$08BC  8D 0E 01     STA $010E
$08BF  20 9E 13     JSR $139E
$08C2  AD 0C 01     LDA $010C
$08C5  F0 19        BEQ $08E0
$08C7  A9 00        LDA #$00
$08C9  8D 0C 01     STA $010C
$08CC  AD 09 01     LDA $0109
$08CF  4C 56 09     JMP $0956

; --- Subroutine at $08D2 ---
$08D2  29 7F        AND #$7F
$08D4  C9 03        CMP #$03
$08D6  F0 24        BEQ $08FC
$08D8  C9 06        CMP #$06
$08DA  F0 2C        BEQ $0908
$08DC  C9 05        CMP #$05
$08DE  F0 4C        BEQ $092C
$08E0  A5 4A        LDA $4A
$08E2  C9 08        CMP #$08
$08E4  D0 0F        BNE $08F5
$08E6  A5 49        LDA $49
$08E8  C9 02        CMP #$02
$08EA  B0 09        BCS $08F5
$08EC  A9 0E        LDA #$0E
$08EE  A2 0A        LDX #$0A
$08F0  A0 02        LDY #$02
$08F2  20 E2 17     JSR $17E2
$08F5  AD 01 DC     LDA $DC01 ; CIA1_PRB
$08F8  29 10        AND #$10
$08FA  D0 B5        BNE $08B1
$08FC  20 4B 09     JSR $094B
$08FF  A9 10        LDA #$10
$0901  85 48        STA $48 ; timer
$0903  A5 48        LDA $48 ; timer
$0905  D0 FC        BNE $0903
$0907  60           RTS
$0908  AD CA 42     LDA $42CA
$090B  49 01        EOR #$01
$090D  8D CA 42     STA $42CA
$0910  8D CC 42     STA $42CC
$0913  20 4C 0E     JSR $0E4C

; --- Subroutine at $0916 ---
$0916  20 4B 09     JSR $094B
$0919  A9 09        LDA #$09
$091B  85 4A        STA $4A
$091D  A9 60        LDA #$60
$091F  85 49        STA $49
$0921  A9 04        LDA #$04
$0923  85 48        STA $48 ; timer
$0925  A5 48        LDA $48 ; timer
$0927  D0 FC        BNE $0925
$0929  4C B1 08     JMP $08B1
$092C  AD C9 42     LDA $42C9
$092F  49 01        EOR #$01
$0931  8D C9 42     STA $42C9
$0934  8D CB 42     STA $42CB
$0937  20 65 0E     JSR $0E65
$093A  20 4B 09     JSR $094B
$093D  A9 09        LDA #$09
$093F  85 4A        STA $4A
$0941  A9 60        LDA #$60
$0943  85 49        STA $49
$0945  A9 04        LDA #$04
$0947  85 48        STA $48 ; timer
$0949  D0 DA        BNE $0925

; --- Subroutine at $094B ---
$094B  AD 00 DC     LDA $DC00 ; CIA1_PRA
$094E  2D 01 DC     AND $DC01 ; CIA1_PRB
$0951  29 10        AND #$10
$0953  F0 F6        BEQ $094B
$0955  60           RTS

; --- Subroutine at $0956 ---
$0956  C9 2A        CMP #$2A
$0958  F0 0F        BEQ $0969
$095A  C9 AA        CMP #$AA
$095C  F0 1B        BEQ $0979
$095E  C9 11        CMP #$11
$0960  F0 26        BEQ $0988
$0962  C9 91        CMP #$91
$0964  F0 32        BEQ $0998
$0966  4C D2 08     JMP $08D2
$0969  A9 08        LDA #$08
$096B  A2 0A        LDX #$0A
$096D  A0 02        LDY #$02
$096F  20 E2 17     JSR $17E2
$0972  A9 00        LDA #$00
$0974  8D 83 13     STA $1383
$0977  F0 2D        BEQ $09A6
$0979  A9 0A        LDA #$0A
$097B  AA           TAX
$097C  A0 02        LDY #$02
$097E  20 E2 17     JSR $17E2
$0981  A9 00        LDA #$00
$0983  8D 84 13     STA $1384
$0986  F0 1E        BEQ $09A6
$0988  A9 09        LDA #$09
$098A  A2 0A        LDX #$0A
$098C  A0 02        LDY #$02
$098E  20 E2 17     JSR $17E2
$0991  A9 01        LDA #$01
$0993  8D 83 13     STA $1383
$0996  D0 0E        BNE $09A6
$0998  A9 0D        LDA #$0D
$099A  A2 0A        LDX #$0A
$099C  A0 02        LDY #$02
$099E  20 E2 17     JSR $17E2
$09A1  A9 01        LDA #$01
$09A3  8D 84 13     STA $1384
$09A6  4C 16 09     JMP $0916

; --- Subroutine at $09A9 ---
$09A9  A2 00        LDX #$00
$09AB  9D 00 D8     STA $D800,X
$09AE  9D 00 D9     STA $D900,X
$09B1  9D 00 DA     STA $DA00,X
$09B4  9D 00 DB     STA $DB00,X
$09B7  E8           INX
$09B8  D0 F1        BNE $09AB
$09BA  60           RTS
$09BB  04           .byte $04

; --- Subroutine at $09BC ---
$09BC  AD 11 D0     LDA $D011 ; VIC_CTRL1
$09BF  29 EF        AND #$EF
$09C1  8D 11 D0     STA $D011 ; VIC_CTRL1
$09C4  AD 15 D0     LDA $D015 ; VIC_SPR_EN
$09C7  29 1F        AND #$1F
$09C9  85 47        STA $47 ; spr_enable_shadow
$09CB  A9 00        LDA #$00
$09CD  8D 15 D0     STA $D015 ; VIC_SPR_EN
$09D0  A2 27        LDX #$27
$09D2  A9 20        LDA #$20
$09D4  9D 00 8C     STA $8C00,X
$09D7  CA           DEX
$09D8  10 FA        BPL $09D4
$09DA  A6 29        LDX $29 ; room_number
$09DC  BD A0 47     LDA $47A0,X
$09DF  A2 00        LDX #$00
$09E1  9D 78 D8     STA $D878,X
$09E4  9D 00 D9     STA $D900,X
$09E7  9D 00 DA     STA $DA00,X
$09EA  9D 00 DB     STA $DB00,X
$09ED  E8           INX
$09EE  D0 F1        BNE $09E1
$09F0  20 3F 42     JSR $423F
$09F3  20 5E 25     JSR $255E
$09F6  A5 29        LDA $29 ; room_number
$09F8  C9 0B        CMP #$0B
$09FA  D0 12        BNE $0A0E
$09FC  A5 36        LDA $36
$09FE  05 38        ORA $38
$0A00  05 3A        ORA $3A
$0A02  D0 0A        BNE $0A0E
$0A04  A5 47        LDA $47 ; spr_enable_shadow
$0A06  8D 15 D0     STA $D015 ; VIC_SPR_EN
$0A09  A2 0D        LDX #$0D
$0A0B  4C 17 32     JMP $3217
$0A0E  A5 29        LDA $29 ; room_number
$0A10  0A           ASL
$0A11  65 03        ADC $03 ; room_subtype
$0A13  AA           TAX
$0A14  BD 00 03     LDA $0300,X
$0A17  F0 11        BEQ $0A2A
$0A19  5E 00 03     LSR $0300,X
$0A1C  A9 07        LDA #$07
$0A1E  A2 01        LDX #$01
$0A20  20 75 31     JSR $3175
$0A23  A9 D0        LDA #$D0
$0A25  A2 02        LDX #$02
$0A27  20 75 31     JSR $3175
$0A2A  A9 00        LDA #$00
$0A2C  A0 83        LDY #$83
$0A2E  99 57 4F     STA $4F57,Y
$0A31  88           DEY
$0A32  10 FA        BPL $0A2E
$0A34  85 87        STA $87
$0A36  85 88        STA $88
$0A38  85 65        STA $65
$0A3A  A9 07        LDA #$07
$0A3C  8D 21 43     STA $4321
$0A3F  A6 29        LDX $29 ; room_number
$0A41  BD 9E 4C     LDA $4C9E,X
$0A44  85 7A        STA $7A
$0A46  F0 06        BEQ $0A4E
$0A48  A9 00        LDA #$00
$0A4A  85 8B        STA $8B
$0A4C  85 8C        STA $8C
$0A4E  BD 0B 13     LDA $130B,X
$0A51  85 5D        STA $5D
$0A53  BD 47 13     LDA $1347,X
$0A56  85 5E        STA $5E
$0A58  A5 40        LDA $40
$0A5A  F0 06        BEQ $0A62
$0A5C  A9 03        LDA #$03
$0A5E  85 5D        STA $5D
$0A60  85 5E        STA $5E
$0A62  AD CA 42     LDA $42CA
$0A65  F0 04        BEQ $0A6B
$0A67  A9 08        LDA #$08
$0A69  85 5E        STA $5E
$0A6B  A9 01        LDA #$01
$0A6D  85 B6        STA $B6
$0A6F  A9 04        LDA #$04
$0A71  85 CE        STA $CE
$0A73  A9 00        LDA #$00
$0A75  8D DE 4F     STA $4FDE
$0A78  8D DF 4F     STA $4FDF
$0A7B  8D E0 4F     STA $4FE0
$0A7E  85 BF        STA $BF
$0A80  8D 06 01     STA $0106
$0A83  A5 29        LDA $29 ; room_number
$0A85  0A           ASL
$0A86  AA           TAX
$0A87  BD A8 4A     LDA $4AA8,X
$0A8A  85 06        STA $06 ; data_ptr_lo
$0A8C  BD A9 4A     LDA $4AA9,X
$0A8F  85 07        STA $07 ; data_ptr_hi
$0A91  A0 13        LDY #$13
$0A93  B1 06        LDA ($06),Y
$0A95  99 53 01     STA $0153,Y
$0A98  88           DEY
$0A99  10 F8        BPL $0A93
$0A9B  A9 38        LDA #$38
$0A9D  A6 29        LDX $29 ; room_number
$0A9F  E0 0A        CPX #$0A
$0AA1  90 0A        BCC $0AAD
$0AA3  E0 12        CPX #$12
$0AA5  F0 04        BEQ $0AAB
$0AA7  A9 3A        LDA #$3A
$0AA9  D0 02        BNE $0AAD
$0AAB  A9 3C        LDA #$3C
$0AAD  85 F2        STA $F2 ; scroll_state
$0AAF  BD 34 4B     LDA $4B34,X
$0AB2  85 06        STA $06 ; data_ptr_lo
$0AB4  BD 49 4B     LDA $4B49,X
$0AB7  85 07        STA $07 ; data_ptr_hi
$0AB9  A9 78        LDA #$78
$0ABB  85 04        STA $04 ; screen_ptr_lo
$0ABD  85 10        STA $10 ; temp_ptr_lo
$0ABF  A9 A0        LDA #$A0
$0AC1  85 08        STA $08 ; color_ptr_lo
$0AC3  85 12        STA $12 ; temp2_ptr_lo
$0AC5  A9 8C        LDA #$8C
$0AC7  85 05        STA $05 ; screen_ptr_hi
$0AC9  85 09        STA $09 ; color_ptr_hi
$0ACB  A9 D8        LDA #$D8
$0ACD  85 11        STA $11 ; temp_ptr_hi
$0ACF  85 13        STA $13 ; temp2_ptr_hi
$0AD1  A9 27        LDA #$27
$0AD3  85 F3        STA $F3 ; draw_counter
$0AD5  A0 00        LDY #$00

; --- Subroutine at $0AD7 ---
$0AD7  B1 06        LDA ($06),Y
$0AD9  10 2C        BPL $0B07
$0ADB  29 7F        AND #$7F
$0ADD  F0 51        BEQ $0B30
$0ADF  AA           TAX
$0AE0  20 8D 47     JSR $478D
$0AE3  B1 06        LDA ($06),Y
$0AE5  10 03        BPL $0AEA
$0AE7  20 5F 0B     JSR $0B5F
$0AEA  91 04        STA ($04),Y
$0AEC  09 80        ORA #$80
$0AEE  91 08        STA ($08),Y
$0AF0  20 86 47     JSR $4786
$0AF3  20 8D 47     JSR $478D
$0AF6  20 94 47     JSR $4794
$0AF9  20 51 0B     JSR $0B51
$0AFC  20 58 0B     JSR $0B58
$0AFF  20 5B 48     JSR $485B
$0B02  CA           DEX
$0B03  D0 DE        BNE $0AE3
$0B05  F0 D0        BEQ $0AD7
$0B07  AA           TAX
$0B08  20 8D 47     JSR $478D
$0B0B  B1 06        LDA ($06),Y
$0B0D  10 03        BPL $0B12
$0B0F  20 5F 0B     JSR $0B5F
$0B12  91 04        STA ($04),Y
$0B14  09 80        ORA #$80
$0B16  91 08        STA ($08),Y
$0B18  20 86 47     JSR $4786
$0B1B  20 94 47     JSR $4794
$0B1E  20 51 0B     JSR $0B51
$0B21  20 58 0B     JSR $0B58
$0B24  20 5B 48     JSR $485B
$0B27  CA           DEX
$0B28  D0 E1        BNE $0B0B
$0B2A  20 8D 47     JSR $478D
$0B2D  4C D7 0A     JMP $0AD7
$0B30  20 6E 33     JSR $336E
$0B33  20 DB 50     JSR $50DB
$0B36  EA           NOP
$0B37  EA           NOP
$0B38  EA           NOP
$0B39  EA           NOP
$0B3A  EA           NOP
$0B3B  A5 47        LDA $47 ; spr_enable_shadow
$0B3D  8D 15 D0     STA $D015 ; VIC_SPR_EN
$0B40  4C 6F 3A     JMP $3A6F

; --- Subroutine at $0B43 ---
$0B43  E6 04        INC $04 ; screen_ptr_lo
$0B45  D0 02        BNE $0B49
$0B47  E6 05        INC $05 ; screen_ptr_hi
$0B49  60           RTS
$0B4A  E6 06        INC $06 ; data_ptr_lo
$0B4C  D0 02        BNE $0B50
$0B4E  E6 07        INC $07 ; data_ptr_hi
$0B50  60           RTS

; --- Subroutine at $0B51 ---
$0B51  E6 10        INC $10 ; temp_ptr_lo
$0B53  D0 02        BNE $0B57
$0B55  E6 11        INC $11 ; temp_ptr_hi
$0B57  60           RTS

; --- Subroutine at $0B58 ---
$0B58  E6 12        INC $12 ; temp2_ptr_lo
$0B5A  D0 02        BNE $0B5E
$0B5C  E6 13        INC $13 ; temp2_ptr_hi
$0B5E  60           RTS

; --- Subroutine at $0B5F ---
$0B5F  48           PHA
$0B60  A9 F8        LDA #$F8
$0B62  91 10        STA ($10),Y
$0B64  91 12        STA ($12),Y
$0B66  68           PLA
$0B67  29 7F        AND #$7F
$0B69  60           RTS
$0B6A  20 80 0B     JSR $0B80
$0B6D  A2 03        LDX #$03
$0B6F  A9 86        LDA #$86
$0B71  91 04        STA ($04),Y
$0B73  20 43 0B     JSR $0B43
$0B76  CA           DEX
$0B77  10 F8        BPL $0B71
$0B79  A9 27        LDA #$27
$0B7B  85 4C        STA $4C ; column_counter
$0B7D  4C 87 0B     JMP $0B87

; --- Subroutine at $0B80 ---
$0B80  85 54        STA $54
$0B82  86 55        STX $55
$0B84  84 56        STY $56
$0B86  60           RTS

; --- Subroutine at $0B87 ---
$0B87  A4 56        LDY $56
$0B89  A6 55        LDX $55
$0B8B  A5 54        LDA $54
$0B8D  60           RTS

; --- Subroutine at $0B8E ---
$0B8E  09 01        ORA #$01
$0B90  95 95        STA $95,X
$0B92  2A           ROL
$0B93  2A           ROL
$0B94  2A           ROL
$0B95  29 03        AND #$03
$0B97  A8           TAY
$0B98  84 52        STY $52
$0B9A  B9 A8 59     LDA $59A8,Y
$0B9D  95 EC        STA $EC,X
$0B9F  20 21 0E     JSR $0E21
$0BA2  A4 52        LDY $52
$0BA4  B9 AB 59     LDA $59AB,Y
$0BA7  95 EF        STA $EF,X
$0BA9  F0 03        BEQ $0BAE
$0BAB  20 21 0E     JSR $0E21
$0BAE  A4 52        LDY $52
$0BB0  A9 00        LDA #$00
$0BB2  95 BF        STA $BF,X
$0BB4  95 CE        STA $CE,X
$0BB6  9D 06 01     STA $0106,X
$0BB9  A9 0F        LDA #$0F
$0BBB  95 98        STA $98,X
$0BBD  A9 01        LDA #$01
$0BBF  95 9B        STA $9B,X
$0BC1  A9 01        LDA #$01
$0BC3  95 B6        STA $B6,X
$0BC5  A9 01        LDA #$01
$0BC7  95 A4        STA $A4,X
$0BC9  A9 02        LDA #$02
$0BCB  9D 48 4F     STA $4F48,X
$0BCE  9D 4E 4F     STA $4F4E,X
$0BD1  A9 03        LDA #$03
$0BD3  9D 4B 4F     STA $4F4B,X
$0BD6  9D 51 4F     STA $4F51,X
$0BD9  A9 24        LDA #$24
$0BDB  95 D1        STA $D1,X
$0BDD  86 51        STX $51
$0BDF  AD 04 01     LDA $0104
$0BE2  F0 03        BEQ $0BE7
$0BE4  8A           TXA
$0BE5  D0 13        BNE $0BFA
$0BE7  A6 29        LDX $29 ; room_number
$0BE9  BD C2 4B     LDA $4BC2,X
$0BEC  A8           TAY
$0BED  BD AE 4B     LDA $4BAE,X

; --- Subroutine at $0BF0 ---
$0BF0  A6 51        LDX $51
$0BF2  95 9E        STA $9E,X
$0BF4  98           TYA
$0BF5  95 A1        STA $A1,X
$0BF7  4C 4D 0C     JMP $0C4D
$0BFA  B5 8A        LDA $8A,X
$0BFC  D0 41        BNE $0C3F
$0BFE  E0 01        CPX #$01
$0C00  D0 28        BNE $0C2A
$0C02  A6 29        LDX $29 ; room_number
$0C04  BD 6F 13     LDA $136F,X
$0C07  F0 0E        BEQ $0C17
$0C09  20 59 11     JSR $1159
$0C0C  C9 C0        CMP #$C0
$0C0E  B0 07        BCS $0C17
$0C10  BD 6F 13     LDA $136F,X
$0C13  10 D2        BPL $0BE7
$0C15  30 07        BMI $0C1E
$0C17  20 59 11     JSR $1159
$0C1A  29 01        AND #$01
$0C1C  F0 C9        BEQ $0BE7
$0C1E  A6 29        LDX $29 ; room_number
$0C20  BD EA 4B     LDA $4BEA,X
$0C23  A8           TAY
$0C24  BD D6 4B     LDA $4BD6,X
$0C27  4C F0 0B     JMP $0BF0
$0C2A  A6 29        LDX $29 ; room_number
$0C2C  BD 33 13     LDA $1333,X
$0C2F  F0 E6        BEQ $0C17
$0C31  20 59 11     JSR $1159
$0C34  C9 C0        CMP #$C0
$0C36  B0 DF        BCS $0C17
$0C38  BD 6F 13     LDA $136F,X
$0C3B  10 AA        BPL $0BE7
$0C3D  30 DF        BMI $0C1E
$0C3F  95 9E        STA $9E,X
$0C41  B5 8C        LDA $8C,X
$0C43  95 A1        STA $A1,X
$0C45  B5 8E        LDA $8E,X
$0C47  95 D1        STA $D1,X
$0C49  A9 00        LDA #$00
$0C4B  95 8A        STA $8A,X

; --- Subroutine at $0C4D ---
$0C4D  BD 6D 27     LDA $276D,X
$0C50  AC 7D 27     LDY $277D
$0C53  F0 03        BEQ $0C58
$0C55  18           CLC
$0C56  69 05        ADC #$05
$0C58  A8           TAY
$0C59  B9 63 27     LDA $2763,Y
$0C5C  BC 6D 27     LDY $276D,X
$0C5F  99 F8 8F     STA $8FF8,Y
$0C62  C8           INY
$0C63  18           CLC
$0C64  69 01        ADC #$01
$0C66  99 F8 8F     STA $8FF8,Y
$0C69  B5 9E        LDA $9E,X
$0C6B  0A           ASL
$0C6C  48           PHA
$0C6D  BC 6D 27     LDY $276D,X
$0C70  AD 10 D0     LDA $D010 ; VIC_SPR_XMSB
$0C73  90 05        BCC $0C7A
$0C75  19 73 27     ORA $2773,Y
$0C78  D0 03        BNE $0C7D
$0C7A  39 78 27     AND $2778,Y
$0C7D  8D 10 D0     STA $D010 ; VIC_SPR_XMSB
$0C80  98           TYA
$0C81  0A           ASL
$0C82  A8           TAY
$0C83  68           PLA
$0C84  99 00 D0     STA $D000,Y ; VIC_SPR0_X
$0C87  B5 A1        LDA $A1,X
$0C89  18           CLC
$0C8A  69 1D        ADC #$1D
$0C8C  99 01 D0     STA $D001,Y ; VIC_SPR0_Y
$0C8F  BD 70 27     LDA $2770,X
$0C92  30 26        BMI $0CBA
$0C94  B5 9E        LDA $9E,X
$0C96  0A           ASL
$0C97  48           PHA
$0C98  BC 70 27     LDY $2770,X
$0C9B  AD 10 D0     LDA $D010 ; VIC_SPR_XMSB
$0C9E  90 05        BCC $0CA5
$0CA0  19 73 27     ORA $2773,Y
$0CA3  D0 03        BNE $0CA8
$0CA5  39 78 27     AND $2778,Y
$0CA8  8D 10 D0     STA $D010 ; VIC_SPR_XMSB
$0CAB  98           TYA
$0CAC  0A           ASL
$0CAD  A8           TAY
$0CAE  68           PLA
$0CAF  99 00 D0     STA $D000,Y ; VIC_SPR0_X
$0CB2  B5 A1        LDA $A1,X
$0CB4  18           CLC
$0CB5  69 1D        ADC #$1D
$0CB7  99 01 D0     STA $D001,Y ; VIC_SPR0_Y
$0CBA  BC 6D 27     LDY $276D,X
$0CBD  AD 15 D0     LDA $D015 ; VIC_SPR_EN
$0CC0  19 73 27     ORA $2773,Y
$0CC3  8D 15 D0     STA $D015 ; VIC_SPR_EN
$0CC6  BC 70 27     LDY $2770,X
$0CC9  30 09        BMI $0CD4
$0CCB  AD 15 D0     LDA $D015 ; VIC_SPR_EN
$0CCE  19 73 27     ORA $2773,Y
$0CD1  8D 15 D0     STA $D015 ; VIC_SPR_EN
$0CD4  60           RTS
$0CD5  20 B5 10     JSR $10B5
$0CD8  AD 79 CF     LDA $CF79
$0CDB  4D 99 CF     EOR $CF99
$0CDE  8D 66 11     STA $1166
$0CE1  A2 01        LDX #$01
$0CE3  A9 80        LDA #$80
$0CE5  20 8E 0B     JSR $0B8E
$0CE8  A9 10        LDA #$10
$0CEA  95 BF        STA $BF,X
$0CEC  A9 2A        LDA #$2A
$0CEE  9D 48 4F     STA $4F48,X
$0CF1  A9 2B        LDA #$2B
$0CF3  9D 4B 4F     STA $4F4B,X
$0CF6  A9 6C        LDA #$6C
$0CF8  9D 4E 4F     STA $4F4E,X
$0CFB  A9 6D        LDA #$6D
$0CFD  9D 51 4F     STA $4F51,X

; ====================================================================
; UTILITY ROUTINES 1 ($0E00-$0FFF)
; ====================================================================

$0E00  A9 82        LDA #$82
$0E02  9D 4E 4F     STA $4F4E,X
$0E05  A9 00        LDA #$00
$0E07  9D 4B 4F     STA $4F4B,X
$0E0A  9D 51 4F     STA $4F51,X
$0E0D  B5 D1        LDA $D1,X
$0E0F  C9 07        CMP #$07
$0E11  90 04        BCC $0E17
$0E13  A9 07        LDA #$07
$0E15  95 D1        STA $D1,X
$0E17  A9 10        LDA #$10
$0E19  95 CE        STA $CE,X
$0E1B  20 DD 2D     JSR $2DDD
$0E1E  4C 1C 2E     JMP $2E1C

; --- Subroutine at $0E21 ---
$0E21  38           SEC
$0E22  E9 03        SBC #$03
$0E24  A8           TAY
$0E25  B9 AE 59     LDA $59AE,Y
$0E28  A8           TAY
$0E29  8A           TXA
$0E2A  99 40 4F     STA $4F40,Y
$0E2D  60           RTS

; --- Subroutine at $0E2E ---
$0E2E  8A           TXA
$0E2F  48           PHA
$0E30  A2 04        LDX #$04
$0E32  BD 3B 0E     LDA $0E3B,X
$0E35  CA           DEX
$0E36  10 FA        BPL $0E32
$0E38  68           PLA
$0E39  AA           TAX
$0E3A  60           RTS
$0E3B  08           PHP
$0E3C  0E 80 00     ASL $0080
$0E3F  80           .byte $80
$0E40  EA           NOP
$0E41  00           BRK
$0E42  00           BRK
$0E43  4E 00 00     LSR $0000
$0E46  4A           LSR
$0E47  00           BRK
$0E48  00           BRK
$0E49  4A           LSR
$0E4A  00           BRK
$0E4B  00           BRK

; --- Subroutine at $0E4C ---
$0E4C  A2 13        LDX #$13
$0E4E  BD 40 8E     LDA $8E40,X
$0E51  C9 4D        CMP #$4D
$0E53  F0 05        BEQ $0E5A
$0E55  49 40        EOR #$40
$0E57  9D 40 8E     STA $8E40,X
$0E5A  CA           DEX
$0E5B  10 F1        BPL $0E4E
$0E5D  A2 50        LDX #$50
$0E5F  AD CA 42     LDA $42CA
$0E62  4C 7B 0E     JMP $0E7B

; --- Subroutine at $0E65 ---
$0E65  A2 13        LDX #$13
$0E67  BD F0 8D     LDA $8DF0,X
$0E6A  C9 4D        CMP #$4D
$0E6C  F0 05        BEQ $0E73
$0E6E  49 40        EOR #$40
$0E70  9D F0 8D     STA $8DF0,X
$0E73  CA           DEX
$0E74  10 F1        BPL $0E67
$0E76  A2 00        LDX #$00
$0E78  AD C9 42     LDA $42C9

; --- Subroutine at $0E7B ---
$0E7B  D0 15        BNE $0E92
$0E7D  A9 42        LDA #$42
$0E7F  9D EF 8D     STA $8DEF,X
$0E82  A9 40        LDA #$40
$0E84  9D F8 8D     STA $8DF8,X
$0E87  A9 56        LDA #$56
$0E89  9D FA 8D     STA $8DFA,X
$0E8C  A9 00        LDA #$00
$0E8E  9D 04 8E     STA $8E04,X
$0E91  60           RTS
$0E92  A9 00        LDA #$00
$0E94  9D EF 8D     STA $8DEF,X
$0E97  A9 42        LDA #$42
$0E99  9D F8 8D     STA $8DF8,X
$0E9C  A9 40        LDA #$40
$0E9E  9D FA 8D     STA $8DFA,X
$0EA1  A9 56        LDA #$56
$0EA3  9D 04 8E     STA $8E04,X
$0EA6  60           RTS

; --- Subroutine at $0EA7 ---
$0EA7  78           SEI
$0EA8  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0EAB  29 EF        AND #$EF
$0EAD  8D 11 D0     STA $D011 ; VIC_CTRL1
$0EB0  A9 00        LDA #$00
$0EB2  8D 15 D0     STA $D015 ; VIC_SPR_EN
$0EB5  A9 06        LDA #$06
$0EB7  8D 20 D0     STA $D020 ; VIC_BORDER
$0EBA  8D 21 D0     STA $D021 ; VIC_BG0
$0EBD  A2 00        LDX #$00
$0EBF  A9 DC        LDA #$DC
$0EC1  9D 00 8C     STA $8C00,X
$0EC4  9D 00 8D     STA $8D00,X
$0EC7  9D 00 8E     STA $8E00,X
$0ECA  9D 00 8F     STA $8F00,X
$0ECD  E8           INX
$0ECE  D0 F1        BNE $0EC1
$0ED0  20 5E 25     JSR $255E
$0ED3  A5 03        LDA $03 ; room_subtype
$0ED5  0A           ASL
$0ED6  AA           TAX
$0ED7  A0 00        LDY #$00
$0ED9  BD 7D 4A     LDA $4A7D,X
$0EDC  99 6B 4A     STA $4A6B,Y
$0EDF  BD 81 4A     LDA $4A81,X
$0EE2  99 7B 4A     STA $4A7B,Y
$0EE5  E8           INX
$0EE6  C8           INY
$0EE7  C0 02        CPY #$02
$0EE9  90 EE        BCC $0ED9
$0EEB  A2 0F        LDX #$0F
$0EED  BD 5D 4A     LDA $4A5D,X
$0EF0  09 80        ORA #$80
$0EF2  9D 24 8D     STA $8D24,X
$0EF5  BD 6D 4A     LDA $4A6D,X
$0EF8  09 80        ORA #$80
$0EFA  9D 4C 8D     STA $8D4C,X
$0EFD  CA           DEX
$0EFE  10 ED        BPL $0EED
$0F00  A9 A4        LDA #$A4
$0F02  8D 08 04     STA $0408
$0F05  A9 14        LDA #$14
$0F07  8D 09 04     STA $0409
$0F0A  A9 01        LDA #$01
$0F0C  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$0F0F  8D 19 D0     STA $D019 ; VIC_IRQ
$0F12  AD 11 D0     LDA $D011 ; VIC_CTRL1
$0F15  29 7F        AND #$7F
$0F17  8D 11 D0     STA $D011 ; VIC_CTRL1
$0F1A  A9 63        LDA #$63
$0F1C  8D 12 D0     STA $D012 ; VIC_RASTER
$0F1F  A9 30        LDA #$30
$0F21  8D 18 D0     STA $D018 ; VIC_MEM
$0F24  A9 18        LDA #$18
$0F26  8D 16 D0     STA $D016 ; VIC_CTRL2
$0F29  20 DB 50     JSR $50DB
$0F2C  EA           NOP
$0F2D  EA           NOP
$0F2E  EA           NOP
$0F2F  EA           NOP
$0F30  EA           NOP
$0F31  58           CLI
$0F32  A9 80        LDA #$80
$0F34  85 18        STA $18
$0F36  85 19        STA $19
$0F38  A9 03        LDA #$03
$0F3A  85 1A        STA $1A
$0F3C  A9 40        LDA #$40
$0F3E  85 48        STA $48 ; timer
$0F40  AD C9 42     LDA $42C9
$0F43  F0 02        BEQ $0F47
$0F45  06 48        ASL $48 ; timer
$0F47  A5 48        LDA $48 ; timer
$0F49  F0 26        BEQ $0F71
$0F4B  A5 18        LDA $18
$0F4D  F0 05        BEQ $0F54
$0F4F  C6 18        DEC $18
$0F51  4C 69 0F     JMP $0F69
$0F54  A5 19        LDA $19
$0F56  F0 07        BEQ $0F5F
$0F58  C6 18        DEC $18
$0F5A  C6 19        DEC $19
$0F5C  4C 69 0F     JMP $0F69
$0F5F  A5 1A        LDA $1A
$0F61  F0 06        BEQ $0F69
$0F63  C6 18        DEC $18
$0F65  C6 19        DEC $19
$0F67  C6 1A        DEC $1A

; --- Subroutine at $0F69 ---
$0F69  A5 18        LDA $18
$0F6B  05 19        ORA $19
$0F6D  05 1A        ORA $1A
$0F6F  D0 D6        BNE $0F47
$0F71  60           RTS

; --- Subroutine at $0F72 ---
$0F72  A9 00        LDA #$00
$0F74  AA           TAX
$0F75  E0 F3        CPX #$F3
$0F77  B0 02        BCS $0F7B
$0F79  95 03        STA $03,X ; room_subtype
$0F7B  E0 FB        CPX #$FB
$0F7D  B0 03        BCS $0F82
$0F7F  9D ED 4E     STA $4EED,X
$0F82  E8           INX
$0F83  D0 F0        BNE $0F75
$0F85  85 89        STA $89
$0F87  85 8A        STA $8A
$0F89  A2 07        LDX #$07
$0F8B  A9 01        LDA #$01
$0F8D  9D 4B 01     STA $014B,X
$0F90  9D 00 01     STA $0100,X
$0F93  CA           DEX
$0F94  10 F7        BPL $0F8D
$0F96  20 5E 25     JSR $255E
$0F99  A9 05        LDA #$05
$0F9B  8D 95 4E     STA $4E95
$0F9E  8D 96 4E     STA $4E96
$0FA1  20 C5 10     JSR $10C5
$0FA4  A2 27        LDX #$27
$0FA6  A9 01        LDA #$01
$0FA8  9D 00 03     STA $0300,X
$0FAB  CA           DEX
$0FAC  10 FA        BPL $0FA8
$0FAE  A9 00        LDA #$00
$0FB0  8D 00 03     STA $0300
$0FB3  8D 01 03     STA $0301
$0FB6  20 CA 33     JSR $33CA
$0FB9  20 E2 0F     JSR $0FE2
$0FBC  A9 04        LDA #$04
$0FBE  85 28        STA $28 ; lives
$0FC0  AD CA 42     LDA $42CA
$0FC3  F0 04        BEQ $0FC9
$0FC5  A9 09        LDA #$09
$0FC7  85 28        STA $28 ; lives
$0FC9  A2 02        LDX #$02
$0FCB  BD 8B 43     LDA $438B,X
$0FCE  9D 92 43     STA $4392,X
$0FD1  9D 95 43     STA $4395,X
$0FD4  CA           DEX
$0FD5  10 F4        BPL $0FCB
$0FD7  A2 1B        LDX #$1B
$0FD9  B5 28        LDA $28,X ; lives
$0FDB  9D 9F 43     STA $439F,X
$0FDE  CA           DEX
$0FDF  10 F8        BPL $0FD9
$0FE1  60           RTS

; --- Subroutine at $0FE2 ---
$0FE2  A9 01        LDA #$01
$0FE4  A2 60        LDX #$60
$0FE6  9D 40 03     STA $0340,X
$0FE9  CA           DEX
$0FEA  10 FA        BPL $0FE6
$0FEC  60           RTS

; --- Subroutine at $0FED ---
$0FED  A9 40        LDA #$40
$0FEF  85 04        STA $04 ; screen_ptr_lo
$0FF1  A9 03        LDA #$03
$0FF3  85 05        STA $05 ; screen_ptr_hi
$0FF5  A9 00        LDA #$00
$0FF7  85 4E        STA $4E
$0FF9  0A           ASL
$0FFA  AA           TAX
$0FFB  20 07 10     JSR $1007
$0FFE  E6 4E        INC $4E

; ====================================================================
; UTILITY ROUTINES 2 ($1000-$13FF)
; ====================================================================

$1000  A5 4E        LDA $4E
$1002  C9 14        CMP #$14
$1004  90 F3        BCC $0FF9
$1006  60           RTS

; --- Subroutine at $1007 ---
$1007  BD E2 4C     LDA $4CE2,X
$100A  85 0A        STA $0A
$100C  BD E3 4C     LDA $4CE3,X
$100F  85 0B        STA $0B
$1011  A0 00        LDY #$00

; --- Subroutine at $1013 ---
$1013  B1 0A        LDA ($0A),Y
$1015  30 13        BMI $102A
$1017  48           PHA
$1018  B1 04        LDA ($04),Y
$101A  AA           TAX
$101B  68           PLA
$101C  91 04        STA ($04),Y
$101E  8A           TXA
$101F  91 0A        STA ($0A),Y
$1021  20 7C 3A     JSR $3A7C
$1024  20 43 0B     JSR $0B43
$1027  4C 13 10     JMP $1013
$102A  60           RTS
$102B  A2 13        LDX #$13
$102D  BD 53 01     LDA $0153,X
$1030  9D B4 47     STA $47B4,X
$1033  CA           DEX
$1034  10 F7        BPL $102D
$1036  A9 FE        LDA #$FE
$1038  85 82        STA $82
$103A  60           RTS

; --- Subroutine at $103B ---
$103B  A2 13        LDX #$13
$103D  BD B4 47     LDA $47B4,X
$1040  9D 53 01     STA $0153,X
$1043  CA           DEX
$1044  10 F7        BPL $103D
$1046  A9 00        LDA #$00
$1048  85 82        STA $82
$104A  60           RTS
$104B  A2 08        LDX #$08
$104D  BD 0F 01     LDA $010F,X
$1050  F0 5F        BEQ $10B1
$1052  8A           TXA
$1053  48           PHA
$1054  BD 19 01     LDA $0119,X
$1057  9D 2D 01     STA $012D,X
$105A  85 70        STA $70
$105C  BD 23 01     LDA $0123,X
$105F  85 6F        STA $6F
$1061  BD 0F 01     LDA $010F,X
$1064  30 29        BMI $108F
$1066  DE 19 01     DEC $0119,X
$1069  BD 19 01     LDA $0119,X
$106C  DD 37 01     CMP $0137,X
$106F  B0 06        BCS $1077
$1071  BD 41 01     LDA $0141,X
$1074  9D 19 01     STA $0119,X
$1077  85 6E        STA $6E
$1079  A5 6F        LDA $6F
$107B  C9 05        CMP #$05
$107D  F0 0A        BEQ $1089
$107F  C9 0A        CMP #$0A
$1081  F0 06        BEQ $1089
$1083  20 4E 40     JSR $404E
$1086  4C AF 10     JMP $10AF
$1089  20 63 40     JSR $4063
$108C  4C AF 10     JMP $10AF
$108F  FE 19 01     INC $0119,X
$1092  BD 19 01     LDA $0119,X
$1095  DD 41 01     CMP $0141,X
$1098  90 06        BCC $10A0
$109A  BD 37 01     LDA $0137,X
$109D  9D 19 01     STA $0119,X
$10A0  85 6E        STA $6E
$10A2  A5 6F        LDA $6F
$10A4  C9 05        CMP #$05
$10A6  F0 E1        BEQ $1089
$10A8  C9 0A        CMP #$0A
$10AA  F0 DD        BEQ $1089
$10AC  20 4E 40     JSR $404E

; --- Subroutine at $10AF ---
$10AF  68           PLA
$10B0  AA           TAX
$10B1  CA           DEX
$10B2  10 99        BPL $104D
$10B4  60           RTS

; --- Subroutine at $10B5 ---
$10B5  48           PHA
$10B6  8A           TXA
$10B7  48           PHA
$10B8  98           TYA
$10B9  48           PHA
$10BA  A0 82        LDY #$82
$10BC  20 09 25     JSR $2509
$10BF  68           PLA
$10C0  A8           TAY
$10C1  68           PLA
$10C2  AA           TAX
$10C3  68           PLA
$10C4  60           RTS

; --- Subroutine at $10C5 ---
$10C5  A2 13        LDX #$13
$10C7  BD CE 4C     LDA $4CCE,X
$10CA  95 2A        STA $2A,X
$10CC  CA           DEX
$10CD  10 F8        BPL $10C7
$10CF  60           RTS
$10D0  A5 88        LDA $88
$10D2  C9 20        CMP #$20
$10D4  B0 04        BCS $10DA
$10D6  C9 19        CMP #$19
$10D8  B8           CLV
$10D9  60           RTS
$10DA  A9 FF        LDA #$FF
$10DC  2C DF 10     BIT $10DF
$10DF  60           RTS

; --- Subroutine at $10E0 ---
$10E0  A5 03        LDA $03 ; room_subtype
$10E2  18           CLC
$10E3  69 26        ADC #$26
$10E5  AA           TAX
$10E6  A9 01        LDA #$01
$10E8  9D 00 03     STA $0300,X
$10EB  CA           DEX
$10EC  CA           DEX
$10ED  10 F9        BPL $10E8
$10EF  A6 03        LDX $03 ; room_subtype
$10F1  A9 00        LDA #$00
$10F3  9D 00 03     STA $0300,X
$10F6  60           RTS

; --- Subroutine at $10F7 ---
$10F7  60           RTS
$10F8  F7           .byte $F7
$10F9  10 CA        BPL $10C5
$10FB  FF           .byte $FF
$10FC  FA           .byte $FA
$10FD  9D 11 17     STA $1711,X
$1100  BD 05 A2     LDA $A205,X
$1103  48           PHA
$1104  8A           TXA
$1105  48           PHA
$1106  98           TYA
$1107  48           PHA
$1108  BA           TSX
$1109  BD 04 01     LDA $0104,X
$110C  29 00        AND #$00
$110E  F0 03        BEQ $1113
$1110  6C 08 04     JMP ($0408)
$1113  6C 08 04     JMP ($0408)
$1116  40           RTI
$1117  6C FC FF     JMP ($FFFC)
$111A  6C 00 00     JMP ($0000)
$111D  48           PHA
$111E  8A           TXA
$111F  48           PHA
$1120  A9 00        LDA #$00
$1122  A2 7F        LDX #$7F
$1124  9D 80 81     STA $8180,X
$1127  9D C0 82     STA $82C0,X
$112A  CA           DEX
$112B  10 F7        BPL $1124
$112D  68           PLA
$112E  AA           TAX
$112F  68           PLA
$1130  60           RTS
$1131  48           PHA
$1132  8A           TXA
$1133  48           PHA
$1134  A9 00        LDA #$00
$1136  A2 7F        LDX #$7F
$1138  9D 00 82     STA $8200,X
$113B  9D 40 83     STA $8340,X
$113E  CA           DEX
$113F  10 F7        BPL $1138
$1141  68           PLA
$1142  AA           TAX
$1143  68           PLA
$1144  60           RTS
$1145  48           PHA
$1146  8A           TXA
$1147  48           PHA
$1148  A9 00        LDA #$00
$114A  A2 3F        LDX #$3F
$114C  9D 80 82     STA $8280,X
$114F  9D C0 83     STA $83C0,X
$1152  CA           DEX
$1153  10 F7        BPL $114C
$1155  68           PLA
$1156  AA           TAX
$1157  68           PLA
$1158  60           RTS

; --- Subroutine at $1159 ---
$1159  AD 04 01     LDA $0104
$115C  D0 03        BNE $1161
$115E  A9 01        LDA #$01
$1160  60           RTS
$1161  E6 16        INC $16
$1163  B1 16        LDA ($16),Y
$1165  60           RTS
$1166  89           .byte $89
$1167  00           BRK
$1168  E0 60        CPX #$60
$116A  E0 C0        CPX #$C0
$116C  E0 20        CPX #$20
$116E  E0 80        CPX #$80
$1170  E0 E0        CPX #$E0
$1172  E0 40        CPX #$40
$1174  E0 A0        CPX #$A0
$1176  E0 00        CPX #$00
$1178  E0 60        CPX #$60
$117A  E0 C0        CPX #$C0
$117C  E0 20        CPX #$20
$117E  E0 80        CPX #$80
$1180  E0 E0        CPX #$E0
$1182  E0 40        CPX #$40
$1184  E0 A0        CPX #$A0
$1186  E0 00        CPX #$00
$1188  E0 60        CPX #$60
$118A  E0 C0        CPX #$C0
$118C  E0 20        CPX #$20
$118E  E0 80        CPX #$80
$1190  E0 00        CPX #$00
$1192  E0 00        CPX #$00
$1194  E0 00        CPX #$00
$1196  E0 00        CPX #$00
$1198  E0 00        CPX #$00
$119A  E0 00        CPX #$00
$119C  E0 00        CPX #$00
$119E  E0 E0        CPX #$E0
$11A0  E0 40        CPX #$40
$11A2  E0 A0        CPX #$A0
$11A4  E0 00        CPX #$00
$11A6  E0 60        CPX #$60
$11A8  E0 C0        CPX #$C0
$11AA  E0 00        CPX #$00
$11AC  E0 20        CPX #$20
$11AE  E0 80        CPX #$80
$11B0  E0 E0        CPX #$E0
$11B2  E0 40        CPX #$40
$11B4  E0 A0        CPX #$A0
$11B6  E0 00        CPX #$00
$11B8  E0 60        CPX #$60
$11BA  E0 C0        CPX #$C0
$11BC  E0 20        CPX #$20
$11BE  E0 80        CPX #$80
$11C0  E0 E0        CPX #$E0
$11C2  E0 40        CPX #$40
$11C4  E0 A0        CPX #$A0
$11C6  E0 00        CPX #$00
$11C8  E0 60        CPX #$60
$11CA  E0 00        CPX #$00
$11CC  E0 60        CPX #$60
$11CE  E0 C0        CPX #$C0
$11D0  E0 20        CPX #$20
$11D2  E0 80        CPX #$80
$11D4  E0 E0        CPX #$E0
$11D6  E0 A0        CPX #$A0
$11D8  E0 40        CPX #$40
$11DA  E0 A0        CPX #$A0
$11DC  E0 A0        CPX #$A0
$11DE  E0 A0        CPX #$A0
$11E0  E0 A0        CPX #$A0
$11E2  E0 A0        CPX #$A0
$11E4  E0 00        CPX #$00
$11E6  E0 60        CPX #$60
$11E8  E0 C0        CPX #$C0
$11EA  E0 20        CPX #$20
$11EC  E0 A0        CPX #$A0
$11EE  E0 A0        CPX #$A0
$11F0  E0 A0        CPX #$A0
$11F2  E0 80        CPX #$80
$11F4  E0 E0        CPX #$E0
$11F6  E0 80        CPX #$80
$11F8  E0 80        CPX #$80
$11FA  E0 80        CPX #$80
$11FC  E0 40        CPX #$40
$11FE  E0 40        CPX #$40
$1200  E0 A0        CPX #$A0
$1202  E0 A0        CPX #$A0
$1204  E0 00        CPX #$00
$1206  E0 00        CPX #$00
$1208  E0 80        CPX #$80
$120A  E0 80        CPX #$80
$120C  E0 80        CPX #$80
$120E  E0 80        CPX #$80
$1210  E0 80        CPX #$80
$1212  E0 80        CPX #$80
$1214  E0 80        CPX #$80
$1216  E0 80        CPX #$80
$1218  E0 80        CPX #$80
$121A  E0 80        CPX #$80
$121C  E0 80        CPX #$80
$121E  E0 80        CPX #$80
$1220  E0 80        CPX #$80
$1222  E0 60        CPX #$60
$1224  E0 60        CPX #$60
$1226  E0 C0        CPX #$C0
$1228  E0 C0        CPX #$C0
$122A  E0 20        CPX #$20
$122C  E0 20        CPX #$20
$122E  E0 80        CPX #$80
$1230  E0 80        CPX #$80
$1232  E0 80        CPX #$80
$1234  E0 80        CPX #$80
$1236  E0 E0        CPX #$E0
$1238  E0 90        CPX #$90
$123A  CA           DEX
$123B  90 CA        BCC $1207
$123D  90 CA        BCC $1209
$123F  91 CA        STA ($CA),Y
$1241  91 CA        STA ($CA),Y
$1243  91 CA        STA ($CA),Y
$1245  92           .byte $92
$1246  CA           DEX
$1247  92           .byte $92
$1248  CA           DEX
$1249  93           .byte $93
$124A  CA           DEX
$124B  93           .byte $93
$124C  CA           DEX
$124D  93           .byte $93
$124E  CA           DEX
$124F  94 CA        STY $CA,X
$1251  94 CA        STY $CA,X
$1253  94 CA        STY $CA,X
$1255  95 CA        STA $CA,X
$1257  95 CA        STA $CA,X
$1259  96 CA        STX $CA,Y
$125B  96 CA        STX $CA,Y
$125D  96 CA        STX $CA,Y
$125F  97           .byte $97
$1260  CA           DEX
$1261  97           .byte $97
$1262  CA           DEX
$1263  90 CA        BCC $122F
$1265  90 CA        BCC $1231
$1267  90 CA        BCC $1233
$1269  90 CA        BCC $1235
$126B  90 CA        BCC $1237
$126D  90 CA        BCC $1239
$126F  90 CA        BCC $123B
$1271  97           .byte $97
$1272  CA           DEX
$1273  98           TYA
$1274  CA           DEX
$1275  98           TYA
$1276  CA           DEX
$1277  99 CA 99     STA $99CA,Y
$127A  CA           DEX
$127B  99 CA 96     STA $96CA,Y
$127E  CA           DEX
$127F  9A           TXS
$1280  CA           DEX
$1281  9A           TXS
$1282  CA           DEX
$1283  9A           TXS
$1284  CA           DEX
$1285  9B           .byte $9B
$1286  CA           DEX
$1287  9B           .byte $9B
$1288  CA           DEX
$1289  9C           .byte $9C
$128A  CA           DEX
$128B  9C           .byte $9C
$128C  CA           DEX
$128D  9C           .byte $9C
$128E  CA           DEX
$128F  9D CA 9D     STA $9DCA,X
$1292  CA           DEX
$1293  9D CA 9E     STA $9ECA,X
$1296  CA           DEX
$1297  9E           .byte $9E
$1298  CA           DEX
$1299  9F           .byte $9F
$129A  CA           DEX
$129B  9F           .byte $9F
$129C  CA           DEX
$129D  C0 CA        CPY #$CA
$129F  C0 CA        CPY #$CA
$12A1  C0 CA        CPY #$CA
$12A3  C1 CA        CMP ($CA,X)
$12A5  C1 CA        CMP ($CA,X)
$12A7  C1 CA        CMP ($CA,X)
$12A9  9B           .byte $9B
$12AA  CA           DEX
$12AB  C2           .byte $C2
$12AC  CA           DEX
$12AD  C2           .byte $C2
$12AE  CA           DEX
$12AF  9B           .byte $9B
$12B0  CA           DEX
$12B1  9B           .byte $9B
$12B2  CA           DEX
$12B3  9B           .byte $9B
$12B4  CA           DEX
$12B5  9B           .byte $9B
$12B6  CA           DEX
$12B7  C3           .byte $C3
$12B8  CA           DEX
$12B9  C3           .byte $C3
$12BA  CA           DEX
$12BB  C3           .byte $C3
$12BC  CA           DEX
$12BD  C4 CA        CPY $CA
$12BF  9B           .byte $9B
$12C0  CA           DEX
$12C1  9B           .byte $9B
$12C2  CA           DEX
$12C3  9B           .byte $9B
$12C4  CA           DEX
$12C5  C4 00        CPY $00
$12C7  C4 00        CPY $00
$12C9  C4 00        CPY $00
$12CB  C4 00        CPY $00
$12CD  C4 00        CPY $00
$12CF  C5 00        CMP $00
$12D1  C8           INY
$12D2  00           BRK
$12D3  C5 00        CMP $00
$12D5  C8           INY
$12D6  00           BRK
$12D7  C6 00        DEC $00
$12D9  C9 00        CMP #$00
$12DB  C4 00        CPY $00
$12DD  C4 00        CPY $00
$12DF  C4 00        CPY $00
$12E1  C4 00        CPY $00
$12E3  C4 00        CPY $00
$12E5  C4 00        CPY $00
$12E7  C4 00        CPY $00
$12E9  C4 00        CPY $00
$12EB  C4 00        CPY $00
$12ED  C4 00        CPY $00
$12EF  C4 00        CPY $00
$12F1  C4 00        CPY $00
$12F3  C4 00        CPY $00
$12F5  C6 00        DEC $00
$12F7  C9 00        CMP #$00
$12F9  C6 00        DEC $00
$12FB  C9 00        CMP #$00
$12FD  C7           .byte $C7
$12FE  00           BRK
$12FF  CA           DEX
$1300  00           BRK
$1301  C7           .byte $C7
$1302  00           BRK
$1303  CA           DEX
$1304  00           BRK
$1305  C4 00        CPY $00
$1307  C4 00        CPY $00
$1309  C7           .byte $C7
$130A  00           BRK
$130B  68           PLA
$130C  78           SEI
$130D  78           SEI
$130E  00           BRK
$130F  70 18        BVS $1329
$1311  30 50        BMI $1363
$1313  00           BRK
$1314  00           BRK
$1315  08           PHP
$1316  00           BRK
$1317  04           .byte $04
$1318  12           .byte $12
$1319  08           PHP
$131A  08           PHP
$131B  08           PHP
$131C  12           .byte $12
$131D  00           BRK
$131E  00           BRK
$131F  A0 A0        LDY #$A0
$1321  A0 00        LDY #$00
$1323  70 0C        BVS $1331
$1325  30 18        BMI $133F
$1327  00           BRK
$1328  00           BRK
$1329  0C           .byte $0C
$132A  00           BRK
$132B  04           .byte $04
$132C  08           PHP
$132D  08           PHP
$132E  08           PHP
$132F  08           PHP
$1330  08           PHP
$1331  00           BRK
$1332  00           BRK
$1333  02           .byte $02
$1334  02           .byte $02
$1335  00           BRK
$1336  00           BRK
$1337  80           .byte $80
$1338  80           .byte $80
$1339  02           .byte $02
$133A  02           .byte $02
$133B  00           BRK
$133C  00           BRK
$133D  02           .byte $02
$133E  00           BRK
$133F  80           .byte $80
$1340  00           BRK
$1341  02           .byte $02
$1342  00           BRK
$1343  80           .byte $80
$1344  00           BRK
$1345  00           BRK
$1346  00           BRK
$1347  F0 EE        BEQ $1337
$1349  EE 00 C0     INC $C000
$134C  C0 A0        CPY #$A0
$134E  B0 00        BCS $1350
$1350  00           BRK
$1351  30 00        BMI $1353
$1353  20 C0 20     JSR $20C0
$1356  30 20        BMI $1378
$1358  C0 00        CPY #$00
$135A  00           BRK
$135B  EE EE EE     INC $EEEE
$135E  00           BRK
$135F  EE 60 EE     INC $EE60
$1362  C0 00        CPY #$00
$1364  00           BRK
$1365  30 00        BMI $1367
$1367  20 EE 30     JSR $30EE
$136A  50 30        BVC $139C
$136C  EE 00 00     INC $0000
$136F  80           .byte $80
$1370  80           .byte $80
$1371  00           BRK
$1372  00           BRK
$1373  80           .byte $80
$1374  02           .byte $02
$1375  00           BRK
$1376  80           .byte $80
$1377  00           BRK
$1378  00           BRK
$1379  80           .byte $80
$137A  00           BRK
$137B  80           .byte $80
$137C  00           BRK
$137D  00           BRK
$137E  00           BRK
$137F  02           .byte $02
$1380  00           BRK
$1381  00           BRK
$1382  00           BRK
$1383  01 01        ORA ($01,X)
$1385  00           BRK

; --- Subroutine at $1386 ---
$1386  A2 FF        LDX #$FF
$1388  8E 09 01     STX $0109
$138B  E8           INX
$138C  8E 0C 01     STX $010C
$138F  8E 02 DC     STX $DC02
$1392  8E 03 DC     STX $DC03
$1395  A9 7F        LDA #$7F
$1397  8D 0D DC     STA $DC0D ; CIA1_ICR
$139A  8D 0D DD     STA $DD0D
$139D  60           RTS

; --- Subroutine at $139E ---
$139E  AD 0C 01     LDA $010C
$13A1  D0 0A        BNE $13AD
$13A3  AD 00 DC     LDA $DC00 ; CIA1_PRA
$13A6  2D 01 DC     AND $DC01 ; CIA1_PRB
$13A9  49 FF        EOR #$FF
$13AB  F0 01        BEQ $13AE
$13AD  60           RTS
$13AE  A2 FF        LDX #$FF
$13B0  8E 03 DC     STX $DC03
$13B3  8E 0A 01     STX $010A
$13B6  E8           INX
$13B7  8E 0B 01     STX $010B
$13BA  8E 01 DC     STX $DC01 ; CIA1_PRB
$13BD  AD 00 DC     LDA $DC00 ; CIA1_PRA
$13C0  C9 FF        CMP #$FF
$13C2  F0 31        BEQ $13F5
$13C4  8D 0D 01     STA $010D
$13C7  8E 03 DC     STX $DC03
$13CA  CA           DEX
$13CB  8E 02 DC     STX $DC02
$13CE  A9 FD        LDA #$FD
$13D0  8D 00 DC     STA $DC00 ; CIA1_PRA
$13D3  AD 01 DC     LDA $DC01 ; CIA1_PRB
$13D6  10 0C        BPL $13E4
$13D8  A9 BF        LDA #$BF
$13DA  8D 00 DC     STA $DC00 ; CIA1_PRA
$13DD  AD 01 DC     LDA $DC01 ; CIA1_PRB
$13E0  29 10        AND #$10
$13E2  D0 03        BNE $13E7
$13E4  EE 0B 01     INC $010B
$13E7  AD 0E 01     LDA $010E
$13EA  D0 06        BNE $13F2
$13EC  20 2C 14     JSR $142C
$13EF  4C F5 13     JMP $13F5
$13F2  20 62 14     JSR $1462

; --- Subroutine at $13F5 ---
$13F5  A9 00        LDA #$00
$13F7  8D 02 DC     STA $DC02
$13FA  8D 03 DC     STA $DC03
$13FD  AD 00 DC     LDA $DC00 ; CIA1_PRA

; ====================================================================
; DISPLAY/SPRITE ROUTINES ($1700-$1BFF)
; ====================================================================

$1700  01 85        ORA ($85,X)
$1702  9C           .byte $9C
$1703  A5 02        LDA $02
$1705  C9 32        CMP #$32
$1707  F0 0E        BEQ $1717
$1709  85 05        STA $05 ; screen_ptr_hi
$170B  91 04        STA ($04),Y
$170D  88           DEY
$170E  D0 FB        BNE $170B
$1710  C6 05        DEC $05 ; screen_ptr_hi
$1712  CE 39 05     DEC $0539
$1715  D0 F4        BNE $170B
$1717  AD 05 20     LDA $2005
$171A  8D 02 DC     STA $DC02
$171D  AD 06 20     LDA $2006
$1720  8D 03 DC     STA $DC03
$1723  AD 04 01     LDA $0104
$1726  F0 13        BEQ $173B
$1728  AD 05 01     LDA $0105
$172B  30 12        BMI $173F
$172D  A5 98        LDA $98
$172F  05 99        ORA $99
$1731  C9 0F        CMP #$0F
$1733  D0 06        BNE $173B
$1735  A5 9B        LDA $9B
$1737  25 9C        AND $9C
$1739  D0 04        BNE $173F
$173B  A9 00        LDA #$00
$173D  85 82        STA $82
$173F  A5 7A        LDA $7A
$1741  D0 5A        BNE $179D
$1743  AD 05 01     LDA $0105
$1746  30 55        BMI $179D
$1748  AD 04 01     LDA $0104
$174B  F0 50        BEQ $179D
$174D  AD CA 42     LDA $42CA
$1750  F0 4B        BEQ $179D
$1752  A5 99        LDA $99
$1754  C9 0F        CMP #$0F
$1756  D0 3F        BNE $1797
$1758  A5 9C        LDA $9C
$175A  F0 3B        BEQ $1797
$175C  E6 89        INC $89
$175E  D0 3D        BNE $179D
$1760  E6 8A        INC $8A
$1762  A5 8A        LDA $8A
$1764  C9 07        CMP #$07
$1766  90 35        BCC $179D
$1768  A9 00        LDA #$00
$176A  8D CA 42     STA $42CA
$176D  A9 20        LDA #$20
$176F  85 88        STA $88
$1771  20 4F 42     JSR $424F
$1774  A5 28        LDA $28 ; lives
$1776  C9 05        CMP #$05
$1778  90 05        BCC $177F
$177A  E9 05        SBC #$05
$177C  4C 81 17     JMP $1781
$177F  A9 00        LDA #$00

; --- Subroutine at $1781 ---
$1781  85 28        STA $28 ; lives
$1783  AD 9F 43     LDA $439F
$1786  C9 05        CMP #$05
$1788  90 05        BCC $178F
$178A  E9 05        SBC #$05
$178C  4C 91 17     JMP $1791
$178F  A9 00        LDA #$00

; --- Subroutine at $1791 ---
$1791  8D 9F 43     STA $439F
$1794  20 ED 1A     JSR $1AED
$1797  A9 00        LDA #$00
$1799  85 89        STA $89
$179B  85 8A        STA $8A
$179D  60           RTS
$179E  20 7C 2D     JSR $2D7C
$17A1  AD 04 01     LDA $0104
$17A4  D0 16        BNE $17BC
$17A6  A0 00        LDY #$00
$17A8  B1 1D        LDA ($1D),Y
$17AA  29 0F        AND #$0F
$17AC  85 98        STA $98
$17AE  B1 1D        LDA ($1D),Y
$17B0  4A           LSR
$17B1  4A           LSR
$17B2  4A           LSR
$17B3  4A           LSR
$17B4  85 9B        STA $9B
$17B6  E6 1D        INC $1D
$17B8  D0 02        BNE $17BC
$17BA  E6 1E        INC $1E
$17BC  A2 02        LDX #$02
$17BE  B5 95        LDA $95,X
$17C0  29 01        AND #$01
$17C2  F0 1A        BEQ $17DE
$17C4  A5 29        LDA $29 ; room_number
$17C6  C9 13        CMP #$13
$17C8  D0 0E        BNE $17D8
$17CA  A5 88        LDA $88
$17CC  C9 02        CMP #$02
$17CE  B0 04        BCS $17D4
$17D0  A9 0E        LDA #$0E
$17D2  D0 02        BNE $17D6
$17D4  A9 0F        LDA #$0F
$17D6  85 98        STA $98
$17D8  20 5B 1C     JSR $1C5B
$17DB  20 80 27     JSR $2780
$17DE  CA           DEX
$17DF  10 DD        BPL $17BE
$17E1  60           RTS

; --- Subroutine at $17E2 ---
$17E2  48           PHA
$17E3  20 67 1A     JSR $1A67
$17E6  68           PLA
$17E7  0A           ASL
$17E8  AA           TAX
$17E9  84 06        STY $06 ; data_ptr_lo
$17EB  BD BE 43     LDA $43BE,X
$17EE  38           SEC
$17EF  E5 06        SBC $06 ; data_ptr_lo
$17F1  85 06        STA $06 ; data_ptr_lo
$17F3  BD BF 43     LDA $43BF,X
$17F6  E9 00        SBC #$00
$17F8  85 07        STA $07 ; data_ptr_hi

; --- Subroutine at $17FA ---
$17FA  B1 06        LDA ($06),Y
$17FC  38           SEC
$17FD  E9 20        SBC #$20
$17FF  C9 80        CMP #$80
$1801  F0 14        BEQ $1817
$1803  29 7F        AND #$7F
$1805  91 04        STA ($04),Y
$1807  09 80        ORA #$80
$1809  91 08        STA ($08),Y
$180B  C8           INY
$180C  D0 EC        BNE $17FA
$180E  E6 05        INC $05 ; screen_ptr_hi
$1810  E6 07        INC $07 ; data_ptr_hi
$1812  E6 09        INC $09 ; color_ptr_hi
$1814  4C FA 17     JMP $17FA
$1817  60           RTS
$1818  20 5E 25     JSR $255E
$181B  AD 04 01     LDA $0104
$181E  D0 06        BNE $1826
$1820  8D BB 09     STA $09BB
$1823  4C 84 05     JMP $0584
$1826  A5 28        LDA $28 ; lives
$1828  30 64        BMI $188E

; --- Subroutine at $182A ---
$182A  A9 24        LDA #$24
$182C  85 D1        STA $D1
$182E  85 D2        STA $D2
$1830  85 D3        STA $D3
$1832  A9 00        LDA #$00
$1834  85 8B        STA $8B
$1836  85 8C        STA $8C
$1838  20 3F 42     JSR $423F
$183B  AD C9 42     LDA $42C9
$183E  F0 0B        BEQ $184B
$1840  AD 9F 43     LDA $439F
$1843  30 06        BMI $184B
$1845  A5 03        LDA $03 ; room_subtype
$1847  49 01        EOR #$01
$1849  85 03        STA $03 ; room_subtype
$184B  20 A7 0E     JSR $0EA7
$184E  AD 11 D0     LDA $D011 ; VIC_CTRL1
$1851  29 EF        AND #$EF
$1853  8D 11 D0     STA $D011 ; VIC_CTRL1
$1856  AD C9 42     LDA $42C9
$1859  F0 2B        BEQ $1886
$185B  AD 9F 43     LDA $439F
$185E  30 26        BMI $1886
$1860  A2 1B        LDX #$1B
$1862  B5 28        LDA $28,X ; lives
$1864  BC 9F 43     LDY $439F,X
$1867  9D 9F 43     STA $439F,X
$186A  98           TYA
$186B  95 28        STA $28,X ; lives
$186D  CA           DEX
$186E  10 F2        BPL $1862
$1870  20 ED 0F     JSR $0FED
$1873  A2 02        LDX #$02
$1875  BD 92 43     LDA $4392,X
$1878  48           PHA
$1879  BD 95 43     LDA $4395,X
$187C  9D 92 43     STA $4392,X
$187F  68           PLA
$1880  9D 95 43     STA $4395,X
$1883  CA           DEX
$1884  10 EF        BPL $1875
$1886  20 63 07     JSR $0763
$1889  A6 29        LDX $29 ; room_number
$188B  4C 17 32     JMP $3217
$188E  20 3F 42     JSR $423F
$1891  20 56 1A     JSR $1A56
$1894  78           SEI
$1895  AD 11 D0     LDA $D011 ; VIC_CTRL1
$1898  29 EF        AND #$EF
$189A  8D 11 D0     STA $D011 ; VIC_CTRL1
$189D  A9 00        LDA #$00
$189F  8D 15 D0     STA $D015 ; VIC_SPR_EN
$18A2  A9 2C        LDA #$2C
$18A4  8D 08 04     STA $0408
$18A7  A9 15        LDA #$15
$18A9  8D 09 04     STA $0409
$18AC  A9 01        LDA #$01
$18AE  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$18B1  8D 19 D0     STA $D019 ; VIC_IRQ
$18B4  AD 11 D0     LDA $D011 ; VIC_CTRL1
$18B7  29 7F        AND #$7F
$18B9  8D 11 D0     STA $D011 ; VIC_CTRL1
$18BC  A9 FB        LDA #$FB
$18BE  8D 12 D0     STA $D012 ; VIC_RASTER
$18C1  A9 06        LDA #$06
$18C3  8D 20 D0     STA $D020 ; VIC_BORDER
$18C6  8D 21 D0     STA $D021 ; VIC_BG0
$18C9  A9 0F        LDA #$0F
$18CB  8D 22 D0     STA $D022 ; VIC_MC1
$18CE  8D 23 D0     STA $D023 ; VIC_MC2
$18D1  A2 08        LDX #$08
$18D3  8E 16 D0     STX $D016 ; VIC_CTRL2
$18D6  20 A9 09     JSR $09A9
$18D9  A2 00        LDX #$00
$18DB  A9 F1        LDA #$F1
$18DD  9D E0 D9     STA $D9E0,X
$18E0  9D E0 DA     STA $DAE0,X
$18E3  A9 DC        LDA #$DC
$18E5  9D 00 8C     STA $8C00,X
$18E8  9D 90 8C     STA $8C90,X
$18EB  E8           INX
$18EC  D0 ED        BNE $18DB
$18EE  A2 11        LDX #$11
$18F0  BD CD 42     LDA $42CD,X
$18F3  09 80        ORA #$80
$18F5  9D 33 8C     STA $8C33,X
$18F8  BD DF 42     LDA $42DF,X
$18FB  09 80        ORA #$80
$18FD  9D 5B 8C     STA $8C5B,X
$1900  CA           DEX
$1901  10 ED        BPL $18F0
$1903  A5 03        LDA $03 ; room_subtype
$1905  0A           ASL
$1906  AA           TAX
$1907  A0 00        LDY #$00
$1909  BD 7D 4A     LDA $4A7D,X
$190C  99 6B 4A     STA $4A6B,Y
$190F  BD 81 4A     LDA $4A81,X
$1912  99 7B 4A     STA $4A7B,Y
$1915  88           DEY
$1916  10 F1        BPL $1909
$1918  A2 0F        LDX #$0F
$191A  BD 5D 4A     LDA $4A5D,X
$191D  09 80        ORA #$80
$191F  9D D4 8C     STA $8CD4,X
$1922  BD 6D 4A     LDA $4A6D,X
$1925  09 80        ORA #$80
$1927  9D FC 8C     STA $8CFC,X
$192A  CA           DEX
$192B  10 ED        BPL $191A
$192D  20 DC 32     JSR $32DC
$1930  A9 4E        LDA #$4E
$1932  85 04        STA $04 ; screen_ptr_lo
$1934  A9 76        LDA #$76
$1936  85 06        STA $06 ; data_ptr_lo
$1938  A9 8D        LDA #$8D
$193A  85 05        STA $05 ; screen_ptr_hi
$193C  85 07        STA $07 ; data_ptr_hi
$193E  A0 00        LDY #$00
$1940  A2 01        LDX #$01
$1942  BD 9B 43     LDA $439B,X
$1945  4A           LSR
$1946  4A           LSR
$1947  4A           LSR
$1948  4A           LSR
$1949  20 84 19     JSR $1984
$194C  C8           INY
$194D  BD 9B 43     LDA $439B,X
$1950  29 0F        AND #$0F
$1952  20 84 19     JSR $1984
$1955  C8           INY
$1956  E8           INX
$1957  E0 04        CPX #$04
$1959  90 E7        BCC $1942
$195B  20 DB 50     JSR $50DB
$195E  EA           NOP
$195F  EA           NOP
$1960  EA           NOP
$1961  EA           NOP
$1962  EA           NOP
$1963  58           CLI
$1964  A9 FE        LDA #$FE
$1966  85 48        STA $48 ; timer
$1968  A5 48        LDA $48 ; timer
$196A  D0 FC        BNE $1968
$196C  AD C9 42     LDA $42C9
$196F  F0 08        BEQ $1979
$1971  AD 9F 43     LDA $439F
$1974  30 03        BMI $1979
$1976  4C 2A 18     JMP $182A
$1979  A9 40        LDA #$40
$197B  85 48        STA $48 ; timer
$197D  A5 48        LDA $48 ; timer
$197F  D0 FC        BNE $197D
$1981  4C 84 05     JMP $0584

; --- Subroutine at $1984 ---
$1984  29 0F        AND #$0F
$1986  0A           ASL
$1987  0A           ASL
$1988  69 34        ADC #$34
$198A  09 80        ORA #$80
$198C  91 04        STA ($04),Y
$198E  18           CLC
$198F  69 01        ADC #$01
$1991  91 06        STA ($06),Y
$1993  18           CLC
$1994  69 01        ADC #$01
$1996  C8           INY
$1997  91 04        STA ($04),Y
$1999  18           CLC
$199A  69 01        ADC #$01
$199C  91 06        STA ($06),Y
$199E  60           RTS
$199F  A9 00        LDA #$00
$19A1  8D BB 43     STA $43BB
$19A4  18           CLC
$19A5  2E BC 43     ROL $43BC
$19A8  2E BB 43     ROL $43BB
$19AB  2E BC 43     ROL $43BC
$19AE  2E BB 43     ROL $43BB
$19B1  2E BC 43     ROL $43BC
$19B4  2E BB 43     ROL $43BB
$19B7  60           RTS

; --- Subroutine at $19B8 ---
$19B8  AD 04 01     LDA $0104
$19BB  D0 2E        BNE $19EB
$19BD  AD 01 DC     LDA $DC01 ; CIA1_PRB
$19C0  29 10        AND #$10
$19C2  F0 19        BEQ $19DD
$19C4  A9 01        LDA #$01
$19C6  8D 0E 01     STA $010E
$19C9  20 9E 13     JSR $139E
$19CC  AD 0C 01     LDA $010C
$19CF  F0 1A        BEQ $19EB
$19D1  A9 00        LDA #$00
$19D3  8D 0C 01     STA $010C
$19D6  AD 09 01     LDA $0109
$19D9  C9 04        CMP #$04
$19DB  D0 0E        BNE $19EB
$19DD  20 4B 09     JSR $094B
$19E0  A9 06        LDA #$06
$19E2  85 48        STA $48 ; timer
$19E4  A5 48        LDA $48 ; timer
$19E6  D0 FC        BNE $19E4
$19E8  4C 0F 05     JMP $050F
$19EB  60           RTS

; --- Subroutine at $19EC ---
$19EC  AD 05 01     LDA $0105
$19EF  48           PHA
$19F0  29 80        AND #$80
$19F2  8D 05 01     STA $0105
$19F5  68           PLA
$19F6  29 06        AND #$06
$19F8  F0 0D        BEQ $1A07
$19FA  38           SEC
$19FB  E9 01        SBC #$01
$19FD  0D 05 01     ORA $0105
$1A00  8D 05 01     STA $0105
$1A03  A9 FF        LDA #$FF
$1A05  85 4B        STA $4B
$1A07  60           RTS

; --- Subroutine at $1A08 ---
$1A08  AD 05 01     LDA $0105
$1A0B  29 06        AND #$06
$1A0D  D0 42        BNE $1A51
$1A0F  AD 05 01     LDA $0105
$1A12  10 3D        BPL $1A51
$1A14  A5 03        LDA $03 ; room_subtype
$1A16  49 01        EOR #$01
$1A18  29 01        AND #$01
$1A1A  AA           TAX
$1A1B  BD 00 DC     LDA $DC00,X ; CIA1_PRA
$1A1E  29 10        AND #$10
$1A20  D0 2F        BNE $1A51

; --- Subroutine at $1A22 ---
$1A22  AD 05 01     LDA $0105
$1A25  49 80        EOR #$80
$1A27  09 06        ORA #$06
$1A29  8D 05 01     STA $0105
$1A2C  30 14        BMI $1A42
$1A2E  20 B6 1B     JSR $1BB6
$1A31  A5 82        LDA $82
$1A33  10 03        BPL $1A38
$1A35  20 3B 10     JSR $103B
$1A38  A9 00        LDA #$00
$1A3A  85 82        STA $82
$1A3C  20 BB 1A     JSR $1ABB
$1A3F  4C C2 31     JMP $31C2
$1A42  A9 11        LDA #$11
$1A44  8D BD 43     STA $43BD
$1A47  20 96 1A     JSR $1A96
$1A4A  A9 51        LDA #$51
$1A4C  85 82        STA $82
$1A4E  4C A4 1B     JMP $1BA4
$1A51  60           RTS
$1A52  A2 02        LDX #$02
$1A54  D0 05        BNE $1A5B

; --- Subroutine at $1A56 ---
$1A56  A2 00        LDX #$00
$1A58  8E 00 01     STX $0100
$1A5B  20 67 1A     JSR $1A67
$1A5E  20 8A 1A     JSR $1A8A
$1A61  E8           INX
$1A62  E0 0D        CPX #$0D
$1A64  90 F5        BCC $1A5B
$1A66  60           RTS

; --- Subroutine at $1A67 ---
$1A67  BD 38 43     LDA $4338,X
$1A6A  85 04        STA $04 ; screen_ptr_lo
$1A6C  BD 4C 43     LDA $434C,X
$1A6F  85 05        STA $05 ; screen_ptr_hi
$1A71  BD 60 43     LDA $4360,X
$1A74  85 08        STA $08 ; color_ptr_lo
$1A76  BD 74 43     LDA $4374,X
$1A79  85 09        STA $09 ; color_ptr_hi
$1A7B  AD 00 01     LDA $0100
$1A7E  D0 01        BNE $1A81
$1A80  60           RTS
$1A81  A9 00        LDA #$00
$1A83  85 08        STA $08 ; color_ptr_lo
$1A85  A9 CE        LDA #$CE
$1A87  85 09        STA $09 ; color_ptr_hi
$1A89  60           RTS

; --- Subroutine at $1A8A ---
$1A8A  A0 27        LDY #$27
$1A8C  A9 00        LDA #$00
$1A8E  91 04        STA ($04),Y
$1A90  91 08        STA ($08),Y
$1A92  88           DEY
$1A93  10 F9        BPL $1A8E
$1A95  60           RTS

; --- Subroutine at $1A96 ---
$1A96  CE BD 43     DEC $43BD
$1A99  D0 0D        BNE $1AA8
$1A9B  A9 20        LDA #$20
$1A9D  8D BD 43     STA $43BD
$1AA0  A9 00        LDA #$00
$1AA2  AA           TAX
$1AA3  A0 2C        LDY #$2C
$1AA5  4C E2 17     JMP $17E2
$1AA8  AD BD 43     LDA $43BD
$1AAB  C9 10        CMP #$10
$1AAD  D0 0B        BNE $1ABA
$1AAF  A6 03        LDX $03 ; room_subtype
$1AB1  E8           INX
$1AB2  8A           TXA
$1AB3  A2 00        LDX #$00
$1AB5  A0 2C        LDY #$2C
$1AB7  4C E2 17     JMP $17E2
$1ABA  60           RTS

; --- Subroutine at $1ABB ---
$1ABB  A9 03        LDA #$03
$1ABD  8D 00 01     STA $0100
$1AC0  A2 00        LDX #$00
$1AC2  A0 38        LDY #$38
$1AC4  4C AD 1B     JMP $1BAD

; --- Subroutine at $1AC7 ---
$1AC7  A9 05        LDA #$05
$1AC9  A2 00        LDX #$00
$1ACB  A0 44        LDY #$44
$1ACD  4C E2 17     JMP $17E2
$1AD0  60           RTS
$1AD1  A5 E6        LDA $E6
$1AD3  A0 43        LDY #$43
$1AD5  20 84 1B     JSR $1B84
$1AD8  A5 E9        LDA $E9
$1ADA  A0 45        LDY #$45
$1ADC  20 84 1B     JSR $1B84
$1ADF  A5 5A        LDA $5A
$1AE1  A0 47        LDY #$47
$1AE3  20 84 1B     JSR $1B84
$1AE6  A5 5B        LDA $5B
$1AE8  A0 4E        LDY #$4E
$1AEA  4C 84 1B     JMP $1B84

; --- Subroutine at $1AED ---
$1AED  A9 00        LDA #$00
$1AEF  8D 9B 43     STA $439B
$1AF2  A5 28        LDA $28 ; lives
$1AF4  8D 98 43     STA $4398

; --- Subroutine at $1AF7 ---
$1AF7  38           SEC
$1AF8  E9 0A        SBC #$0A
$1AFA  90 06        BCC $1B02
$1AFC  EE 9B 43     INC $439B
$1AFF  4C F7 1A     JMP $1AF7
$1B02  18           CLC
$1B03  69 0A        ADC #$0A
$1B05  8D 98 43     STA $4398
$1B08  AD 9B 43     LDA $439B
$1B0B  0A           ASL
$1B0C  0A           ASL
$1B0D  0A           ASL
$1B0E  0A           ASL
$1B0F  0D 98 43     ORA $4398
$1B12  A0 4A        LDY #$4A
$1B14  4C 84 1B     JMP $1B84

; --- Subroutine at $1B17 ---
$1B17  48           PHA
$1B18  20 0E 32     JSR $320E
$1B1B  09 10        ORA #$10
$1B1D  99 00 8C     STA $8C00,Y
$1B20  68           PLA
$1B21  29 0F        AND #$0F
$1B23  09 10        ORA #$10
$1B25  99 01 8C     STA $8C01,Y
$1B28  60           RTS

; --- Subroutine at $1B29 ---
$1B29  A9 01        LDA #$01
$1B2B  8D 0E 01     STA $010E
$1B2E  20 9E 13     JSR $139E
$1B31  AD 0C 01     LDA $010C
$1B34  D0 01        BNE $1B37
$1B36  60           RTS
$1B37  A9 00        LDA #$00
$1B39  8D 0C 01     STA $010C
$1B3C  AD 09 01     LDA $0109
$1B3F  29 7F        AND #$7F
$1B41  85 4B        STA $4B
$1B43  C9 04        CMP #$04
$1B45  D0 03        BNE $1B4A
$1B47  4C 0F 05     JMP $050F
$1B4A  C9 0D        CMP #$0D
$1B4C  D0 0E        BNE $1B5C
$1B4E  AD 85 13     LDA $1385
$1B51  49 01        EOR #$01
$1B53  8D 85 13     STA $1385
$1B56  A9 00        LDA #$00
$1B58  8D BB 09     STA $09BB
$1B5B  60           RTS
$1B5C  C9 3C        CMP #$3C
$1B5E  F0 05        BEQ $1B65
$1B60  C9 1F        CMP #$1F
$1B62  F0 04        BEQ $1B68
$1B64  60           RTS
$1B65  4C 22 1A     JMP $1A22
$1B68  A9 20        LDA #$20
$1B6A  CD 00 8C     CMP $8C00
$1B6D  D0 0C        BNE $1B7B
$1B6F  A2 27        LDX #$27
$1B71  BD 07 47     LDA $4707,X
$1B74  9D 00 8C     STA $8C00,X
$1B77  CA           DEX
$1B78  10 F7        BPL $1B71
$1B7A  60           RTS
$1B7B  A2 27        LDX #$27
$1B7D  9D 00 8C     STA $8C00,X
$1B80  CA           DEX
$1B81  10 FA        BPL $1B7D
$1B83  60           RTS

; --- Subroutine at $1B84 ---
$1B84  48           PHA
$1B85  20 0E 32     JSR $320E
$1B88  09 10        ORA #$10
$1B8A  C9 1A        CMP #$1A
$1B8C  90 03        BCC $1B91
$1B8E  18           CLC
$1B8F  69 07        ADC #$07
$1B91  99 00 8C     STA $8C00,Y
$1B94  68           PLA
$1B95  29 0F        AND #$0F
$1B97  09 10        ORA #$10
$1B99  C9 1A        CMP #$1A
$1B9B  90 03        BCC $1BA0
$1B9D  18           CLC
$1B9E  69 07        ADC #$07
$1BA0  99 01 8C     STA $8C01,Y
$1BA3  60           RTS

; --- Subroutine at $1BA4 ---
$1BA4  A9 0B        LDA #$0B
$1BA6  8D 00 01     STA $0100
$1BA9  A2 01        LDX #$01
$1BAB  A0 0F        LDY #$0F

; --- Subroutine at $1BAD ---
$1BAD  20 E2 17     JSR $17E2
$1BB0  A9 00        LDA #$00
$1BB2  8D 00 01     STA $0100
$1BB5  60           RTS

; --- Subroutine at $1BB6 ---
$1BB6  A9 0C        LDA #$0C
$1BB8  8D 00 01     STA $0100
$1BBB  A2 01        LDX #$01
$1BBD  A0 0F        LDY #$0F
$1BBF  4C AD 1B     JMP $1BAD

; --- Subroutine at $1BC2 ---
$1BC2  A9 03        LDA #$03
$1BC4  85 48        STA $48 ; timer
$1BC6  20 B8 19     JSR $19B8
$1BC9  AD 04 01     LDA $0104
$1BCC  F0 11        BEQ $1BDF
$1BCE  20 29 1B     JSR $1B29
$1BD1  20 EC 19     JSR $19EC
$1BD4  20 08 1A     JSR $1A08
$1BD7  AD 05 01     LDA $0105
$1BDA  10 03        BPL $1BDF
$1BDC  4C 32 1C     JMP $1C32
$1BDF  A5 D2        LDA $D2
$1BE1  29 BF        AND #$BF
$1BE3  85 D2        STA $D2
$1BE5  A5 D3        LDA $D3
$1BE7  29 87        AND #$87
$1BE9  85 D3        STA $D3
$1BEB  20 96 1A     JSR $1A96
$1BEE  20 BC 40     JSR $40BC
$1BF1  A5 7A        LDA $7A
$1BF3  D0 09        BNE $1BFE
$1BF5  20 A4 0D     JSR $0DA4
$1BF8  20 0F 0D     JSR $0D0F
$1BFB  20 B1 0D     JSR $0DB1
$1BFE  A5 7B        LDA $7B

; ====================================================================
; SCREEN DRAWING ($2500-$25FF)
; ====================================================================

$2500  52           .byte $52
$2501  95 CE        STA $CE,X
$2503  60           RTS
$2504  A9 00        LDA #$00
$2506  4C 92 1F     JMP $1F92

; --- Subroutine at $2509 ---
$2509  A9 15        LDA #$15
$250B  8D 18 D4     STA $D418 ; SID_VOL_FILT
$250E  AD 00 EB     LDA $EB00
$2511  D0 0E        BNE $2521
$2513  8C 00 EB     STY $EB00
$2516  98           TYA
$2517  29 0F        AND #$0F
$2519  AA           TAX
$251A  BD 72 25     LDA $2572,X
$251D  8D 81 25     STA $2581
$2520  60           RTS
$2521  AD 70 EF     LDA $EF70
$2524  D0 0E        BNE $2534
$2526  8C 70 EF     STY $EF70
$2529  98           TYA
$252A  29 0F        AND #$0F
$252C  AA           TAX
$252D  BD 72 25     LDA $2572,X
$2530  8D 82 25     STA $2582
$2533  60           RTS
$2534  AD 70 F0     LDA $F070
$2537  D0 0E        BNE $2547
$2539  8C 70 F0     STY $F070
$253C  98           TYA
$253D  29 0F        AND #$0F
$253F  AA           TAX
$2540  BD 72 25     LDA $2572,X
$2543  8D 83 25     STA $2583
$2546  60           RTS
$2547  98           TYA
$2548  29 0F        AND #$0F
$254A  AA           TAX
$254B  BD 72 25     LDA $2572,X
$254E  CD 81 25     CMP $2581
$2551  B0 C0        BCS $2513
$2553  CD 82 25     CMP $2582
$2556  B0 CE        BCS $2526
$2558  CD 83 25     CMP $2583
$255B  B0 DC        BCS $2539
$255D  60           RTS

; --- Subroutine at $255E ---
$255E  A9 00        LDA #$00
$2560  8D 00 EB     STA $EB00
$2563  8D 70 EF     STA $EF70
$2566  8D 70 F0     STA $F070
$2569  A2 20        LDX #$20
$256B  9D 00 D4     STA $D400,X ; SID_V1_FREQ_LO
$256E  CA           DEX
$256F  10 FA        BPL $256B
$2571  60           RTS
$2572  0B           .byte $0B
$2573  0C           .byte $0C
$2574  0A           ASL
$2575  00           BRK
$2576  08           PHP
$2577  07           .byte $07
$2578  09 06        ORA #$06
$257A  00           BRK
$257B  00           BRK
$257C  01 02        ORA ($02,X)
$257E  03           .byte $03
$257F  04           .byte $04
$2580  05 09        ORA $09 ; color_ptr_hi
$2582  08           PHP
$2583  09 A2        ORA #$A2
$2585  02           .byte $02
$2586  86 51        STX $51
$2588  B5 95        LDA $95,X
$258A  29 01        AND #$01
$258C  F0 49        BEQ $25D7
$258E  BD 6D 27     LDA $276D,X
$2591  20 04 27     JSR $2704
$2594  BD 4E 4F     LDA $4F4E,X
$2597  AA           TAX
$2598  20 19 27     JSR $2719
$259B  48           PHA
$259C  8A           TXA
$259D  A6 51        LDX $51
$259F  95 D4        STA $D4,X
$25A1  68           PLA
$25A2  95 DA        STA $DA,X
$25A4  98           TYA
$25A5  0A           ASL
$25A6  75 E0        ADC $E0,X
$25A8  A8           TAY
$25A9  B5 D4        LDA $D4,X
$25AB  20 A0 26     JSR $26A0
$25AE  A6 51        LDX $51
$25B0  E0 02        CPX #$02
$25B2  F0 23        BEQ $25D7
$25B4  BD 70 27     LDA $2770,X
$25B7  30 1E        BMI $25D7
$25B9  20 04 27     JSR $2704
$25BC  BD 4E 4F     LDA $4F4E,X
$25BF  AA           TAX
$25C0  E8           INX
$25C1  20 19 27     JSR $2719
$25C4  48           PHA
$25C5  8A           TXA
$25C6  A6 51        LDX $51
$25C8  95 D7        STA $D7,X
$25CA  68           PLA
$25CB  95 DD        STA $DD,X
$25CD  98           TYA
$25CE  0A           ASL
$25CF  75 E0        ADC $E0,X
$25D1  A8           TAY
$25D2  B5 D7        LDA $D7,X
$25D4  20 A0 26     JSR $26A0
$25D7  A6 51        LDX $51
$25D9  CA           DEX
$25DA  10 AA        BPL $2586
$25DC  A9 00        LDA #$00
$25DE  8D 7E 27     STA $277E
$25E1  60           RTS
$25E2  AD 7E 27     LDA $277E
$25E5  F0 01        BEQ $25E8
$25E7  60           RTS
$25E8  EE 7E 27     INC $277E
$25EB  A2 02        LDX #$02
$25ED  86 51        STX $51
$25EF  B5 95        LDA $95,X
$25F1  29 01        AND #$01
$25F3  F0 3F        BEQ $2634
$25F5  B5 9E        LDA $9E,X
$25F7  95 B9        STA $B9,X
$25F9  B4 D4        LDY $D4,X
$25FB  F0 09        BEQ $2606
$25FD  B4 A4        LDY $A4,X
$25FF  C0 01        CPY #$01

; ====================================================================
; GAME LOGIC 1 ($3100-$31FF)
; ====================================================================

$3100  31 B0        AND ($B0),Y
$3102  05 BD        ORA $BD
$3104  57           .byte $57
$3105  4F           .byte $4F
$3106  D0 02        BNE $310A
$3108  38           SEC
$3109  60           RTS
$310A  18           CLC
$310B  60           RTS
$310C  B5 BF        LDA $BF,X
$310E  C9 19        CMP #$19
$3110  F0 15        BEQ $3127
$3112  B5 B6        LDA $B6,X
$3114  29 04        AND #$04
$3116  F0 0F        BEQ $3127
$3118  A9 17        LDA #$17
$311A  95 BF        STA $BF,X
$311C  A9 10        LDA #$10
$311E  95 CE        STA $CE,X
$3120  A9 00        LDA #$00
$3122  9D 06 01     STA $0106,X
$3125  95 AA        STA $AA,X
$3127  B1 04        LDA ($04),Y
$3129  4C A9 2E     JMP $2EA9

; --- Subroutine at $312C ---
$312C  A2 02        LDX #$02
$312E  18           CLC
$312F  B5 41        LDA $41,X
$3131  75 25        ADC $25,X
$3133  95 41        STA $41,X
$3135  CA           DEX
$3136  10 F7        BPL $312F
$3138  A2 00        LDX #$00
$313A  B5 41        LDA $41,X
$313C  DD 92 43     CMP $4392,X
$313F  90 19        BCC $315A
$3141  E8           INX
$3142  E0 03        CPX #$03
$3144  90 F4        BCC $313A
$3146  A2 02        LDX #$02
$3148  18           CLC
$3149  BD 92 43     LDA $4392,X
$314C  7D 8E 43     ADC $438E,X
$314F  9D 92 43     STA $4392,X
$3152  CA           DEX
$3153  10 F4        BPL $3149
$3155  A5 28        LDA $28 ; lives
$3157  20 ED 1A     JSR $1AED

; --- Subroutine at $315A ---
$315A  20 DC 32     JSR $32DC
$315D  A0 30        LDY #$30
$315F  AD 9C 43     LDA $439C
$3162  20 17 1B     JSR $1B17
$3165  A0 32        LDY #$32
$3167  AD 9D 43     LDA $439D
$316A  20 17 1B     JSR $1B17
$316D  A0 34        LDY #$34
$316F  AD 9E 43     LDA $439E
$3172  4C 17 1B     JMP $1B17

; --- Subroutine at $3175 ---
$3175  48           PHA
$3176  A9 00        LDA #$00
$3178  85 25        STA $25
$317A  85 26        STA $26
$317C  85 27        STA $27
$317E  68           PLA
$317F  95 25        STA $25,X
$3181  4C 2C 31     JMP $312C
$3184  AD 04 01     LDA $0104
$3187  F0 D1        BEQ $315A
$3189  AD 7B CF     LDA $CF7B
$318C  4D 9B CF     EOR $CF9B
$318F  D0 13        BNE $31A4
$3191  AD 7E CF     LDA $CF7E
$3194  4D 9E CF     EOR $CF9E
$3197  D0 0B        BNE $31A4
$3199  AD 81 CF     LDA $CF81
$319C  4D A1 CF     EOR $CFA1
$319F  D0 03        BNE $31A4
$31A1  EA           NOP
$31A2  EA           NOP
$31A3  EA           NOP
$31A4  A2 00        LDX #$00
$31A6  BD 88 43     LDA $4388,X
$31A9  D5 41        CMP $41,X
$31AB  90 0B        BCC $31B8
$31AD  F0 02        BEQ $31B1
$31AF  B0 A9        BCS $315A
$31B1  E8           INX
$31B2  E0 03        CPX #$03
$31B4  90 F0        BCC $31A6
$31B6  B0 A2        BCS $315A
$31B8  A2 03        LDX #$03
$31BA  B5 41        LDA $41,X
$31BC  9D 88 43     STA $4388,X
$31BF  CA           DEX
$31C0  10 F8        BPL $31BA

; --- Subroutine at $31C2 ---
$31C2  A2 03        LDX #$03
$31C4  BD 88 43     LDA $4388,X
$31C7  9D 98 43     STA $4398,X
$31CA  A9 00        LDA #$00
$31CC  9D 9B 43     STA $439B,X
$31CF  CA           DEX
$31D0  10 F2        BPL $31C4
$31D2  8D 9E 43     STA $439E
$31D5  08           PHP
$31D6  F8           SED
$31D7  A2 17        LDX #$17
$31D9  0E 9A 43     ASL $439A
$31DC  2E 99 43     ROL $4399
$31DF  2E 98 43     ROL $4398
$31E2  A0 03        LDY #$03
$31E4  B9 9B 43     LDA $439B,Y
$31E7  79 9B 43     ADC $439B,Y
$31EA  99 9B 43     STA $439B,Y
$31ED  88           DEY
$31EE  10 F4        BPL $31E4
$31F0  CA           DEX
$31F1  10 E6        BPL $31D9
$31F3  28           PLP
$31F4  A0 3C        LDY #$3C
$31F6  AD 9C 43     LDA $439C
$31F9  20 17 1B     JSR $1B17
$31FC  A0 3E        LDY #$3E
$31FE  AD 9D 43     LDA $439D

; ====================================================================
; GAME LOGIC 2 ($4200-$43FF)
; ====================================================================

$4200  60           RTS
$4201  A9 0D        LDA #$0D
$4203  8D FE 8F     STA $8FFE
$4206  AD 15 D0     LDA $D015 ; VIC_SPR_EN
$4209  09 40        ORA #$40
$420B  8D 15 D0     STA $D015 ; VIC_SPR_EN
$420E  A9 01        LDA #$01
$4210  8D 2E 43     STA $432E
$4213  A9 50        LDA #$50
$4215  8D 32 43     STA $4332
$4218  A9 37        LDA #$37
$421A  8D 34 43     STA $4334
$421D  4C 29 2E     JMP $2E29
$4220  A9 0E        LDA #$0E
$4222  8D FF 8F     STA $8FFF
$4225  AD 15 D0     LDA $D015 ; VIC_SPR_EN
$4228  09 80        ORA #$80
$422A  8D 15 D0     STA $D015 ; VIC_SPR_EN
$422D  A9 01        LDA #$01
$422F  8D 2F 43     STA $432F
$4232  A9 5E        LDA #$5E
$4234  8D 33 43     STA $4333
$4237  A9 37        LDA #$37
$4239  8D 35 43     STA $4335
$423C  4C 29 2E     JMP $2E29

; --- Subroutine at $423F ---
$423F  A2 09        LDX #$09
$4241  A9 00        LDA #$00
$4243  9D 40 83     STA $8340,X
$4246  9D 80 83     STA $8380,X
$4249  CA           DEX
$424A  CA           DEX
$424B  CA           DEX
$424C  10 F5        BPL $4243
$424E  60           RTS

; --- Subroutine at $424F ---
$424F  48           PHA
$4250  8A           TXA
$4251  48           PHA
$4252  98           TYA
$4253  48           PHA
$4254  A0 8A        LDY #$8A
$4256  20 09 25     JSR $2509
$4259  68           PLA
$425A  A8           TAY
$425B  68           PLA
$425C  AA           TAX
$425D  68           PLA
$425E  60           RTS
$425F  A9 58        LDA #$58
$4261  85 49        STA $49
$4263  A9 04        LDA #$04
$4265  85 4A        STA $4A
$4267  A2 27        LDX #$27
$4269  A9 00        LDA #$00
$426B  9D 00 8C     STA $8C00,X
$426E  CA           DEX
$426F  10 FA        BPL $426B
$4271  60           RTS
$4272  A5 49        LDA $49
$4274  05 4A        ORA $4A
$4276  D0 20        BNE $4298
$4278  E6 40        INC $40
$427A  A5 03        LDA $03 ; room_subtype
$427C  0A           ASL
$427D  0A           ASL
$427E  AA           TAX
$427F  A0 03        LDY #$03
$4281  A9 01        LDA #$01
$4283  9D 4B 01     STA $014B,X
$4286  E8           INX
$4287  88           DEY
$4288  10 F9        BPL $4283
$428A  20 C5 10     JSR $10C5
$428D  20 CA 33     JSR $33CA
$4290  20 E0 10     JSR $10E0
$4293  A2 00        LDX #$00
$4295  4C 17 32     JMP $3217
$4298  20 59 11     JSR $1159
$429B  29 07        AND #$07
$429D  09 F8        ORA #$F8
$429F  A2 1C        LDX #$1C
$42A1  9D AC DA     STA $DAAC,X
$42A4  9D D4 DA     STA $DAD4,X
$42A7  9D FC DA     STA $DAFC,X
$42AA  9D 24 DB     STA $DB24,X
$42AD  9D 4C DB     STA $DB4C,X
$42B0  9D 74 DB     STA $DB74,X
$42B3  9D 9C DB     STA $DB9C,X
$42B6  9D C4 DB     STA $DBC4,X
$42B9  CA           DEX
$42BA  10 E5        BPL $42A1
$42BC  A9 04        LDA #$04
$42BE  A2 00        LDX #$00
$42C0  A0 0A        LDY #$0A
$42C2  4C E2 17     JMP $17E2
$42C5  40           RTI
$42C6  80           .byte $80
$42C7  BF           .byte $BF
$42C8  7F           .byte $7F
$42C9  00           BRK
$42CA  00           BRK
$42CB  00           BRK
$42CC  00           BRK
$42CD  10 12        BPL $42E1
$42CF  00           BRK
$42D0  02           .byte $02
$42D1  18           CLC
$42D2  1A           .byte $1A
$42D3  0C           .byte $0C
$42D4  0E 5C 5C     ASL $5C5C
$42D7  1C           .byte $1C
$42D8  1E 2C 2E     ASL $2E2C,X
$42DB  0C           .byte $0C
$42DC  0E 24 26     ASL $2624
$42DF  11 13        ORA ($13),Y
$42E1  01 03        ORA ($03,X)
$42E3  19 1B 0D     ORA $0D1B,Y
$42E6  0F           .byte $0F
$42E7  5C           .byte $5C
$42E8  5C           .byte $5C
$42E9  1D 1F 2D     ORA $2D1F,X
$42EC  2F           .byte $2F
$42ED  0D 0F 25     ORA $250F
$42F0  27           .byte $27
$42F1  0C           .byte $0C
$42F2  33           .byte $33
$42F3  03           .byte $03
$42F4  CC 03 33     CPY $3303
$42F7  0C           .byte $0C
$42F8  C3           .byte $C3
$42F9  CC FF 33     CPY $33FF
$42FC  FF           .byte $FF
$42FD  3C           .byte $3C
$42FE  FF           .byte $FF
$42FF  F3           .byte $F3
$4300  3F           .byte $3F
$4301  30 CC        BMI $42CF
$4303  C0 33        CPY #$33
$4305  C0 CC        CPY #$CC
$4307  30 C3        BMI $42CC
$4309  C3           .byte $C3
$430A  30 3F        BMI $434B
$430C  30 C3        BMI $42D1
$430E  00           BRK
$430F  FF           .byte $FF
$4310  00           BRK
$4311  C3           .byte $C3
$4312  FF           .byte $FF
$4313  3C           .byte $3C
$4314  FF           .byte $FF
$4315  C3           .byte $C3
$4316  FF           .byte $FF
$4317  3C           .byte $3C
$4318  FF           .byte $FF
$4319  C3           .byte $C3
$431A  0C           .byte $0C
$431B  FC           .byte $FC
$431C  0C           .byte $0C
$431D  C3           .byte $C3
$431E  00           BRK
$431F  FF           .byte $FF
$4320  00           BRK
$4321  07           .byte $07
$4322  18           CLC
$4323  3C           .byte $3C
$4324  3C           .byte $3C
$4325  18           CLC
$4326  00           BRK
$4327  00           BRK
$4328  00           BRK
$4329  00           BRK
$432A  00           BRK
$432B  00           BRK
$432C  00           BRK
$432D  00           BRK
$432E  00           BRK
$432F  00           BRK
$4330  00           BRK
$4331  00           BRK
$4332  00           BRK
$4333  00           BRK
$4334  00           BRK
$4335  00           BRK
$4336  00           BRK
$4337  00           BRK
$4338  00           BRK
$4339  28           PLP
$433A  78           SEI
$433B  C8           INY
$433C  18           CLC
$433D  68           PLA
$433E  B8           CLV
$433F  08           PHP
$4340  58           CLI
$4341  A8           TAY
$4342  F8           SED
$4343  48           PHA
$4344  98           TYA
$4345  E8           INX
$4346  4D 0D FC     EOR $FC0D
$4349  4D D0 1D     EOR $1DD0
$434C  8C 8C 8C     STY $8C8C
$434F  8C 8D 8D     STY $8D8D
$4352  8D 8E 8E     STA $8E8E
$4355  8E 8E 8F     STX $8F8E
$4358  8F           .byte $8F
$4359  8F           .byte $8F
$435A  01 85        ORA ($85,X)
$435C  65 A9        ADC $A9
$435E  07           .byte $07
$435F  8D 00 00     STA $0000
$4362  A0 F0        LDY #$F0
$4364  40           RTI
$4365  90 E0        BCC $4347
$4367  30 80        BMI $42E9
$4369  D0 20        BNE $438B
$436B  70 C0        BVS $432D
$436D  10 0D        BPL $437C
$436F  15 4E        ORA $4E,X
$4371  D0 0F        BNE $4382
$4373  AD CE CE     LDA $CECE
$4376  8C 8C 8D     STY $8D8C
$4379  8D 8D 8E     STA $8E8D
$437C  8E 8E 8F     STX $8F8E
$437F  8F           .byte $8F
$4380  8F           .byte $8F
$4381  90 AD        BCC $4330
$4383  00           BRK
$4384  4E D0 0F     LSR $0FD0
$4387  AD 00 00     LDA $0000
$438A  00           BRK
$438B  00           BRK
$438C  9C           .byte $9C
$438D  40           RTI
$438E  00           BRK
$438F  75 30        ADC $30,X
$4391  01 00        ORA ($00,X)
$4393  9C           .byte $9C
$4394  40           RTI
$4395  00           BRK
$4396  9C           .byte $9C
$4397  40           RTI
$4398  00           BRK
$4399  00           BRK
$439A  00           BRK
$439B  00           BRK
$439C  00           BRK
$439D  00           BRK
$439E  00           BRK
$439F  04           .byte $04
$43A0  00           BRK
$43A1  06 06        ASL $06 ; data_ptr_lo
$43A3  0A           ASL
$43A4  02           .byte $02
$43A5  02           .byte $02
$43A6  0A           ASL
$43A7  08           PHP
$43A8  0D 04 05     ORA $0504
$43AB  03           .byte $03
$43AC  03           .byte $03
$43AD  03           .byte $03
$43AE  00           BRK
$43AF  04           .byte $04
$43B0  06 02        ASL $02
$43B2  02           .byte $02
$43B3  01 00        ORA ($00,X)
$43B5  00           BRK
$43B6  00           BRK
$43B7  00           BRK
$43B8  00           BRK
$43B9  00           BRK
$43BA  00           BRK
$43BB  04           .byte $04
$43BC  88           DEY
$43BD  11 88        ORA ($88),Y
$43BF  44           .byte $44
$43C0  8C 44 90     STY $9044
$43C3  44           .byte $44
$43C4  94 44        STY $44,X
$43C6  50 47        BVC $440F
$43C8  98           TYA
$43C9  44           .byte $44
$43CA  9E           .byte $9E
$43CB  44           .byte $44
$43CC  A6 44        LDX $44
$43CE  CF           .byte $CF
$43CF  44           .byte $44
$43D0  F4           .byte $F4
$43D1  44           .byte $44
$43D2  19 45 7E     ORA $7E45,Y
$43D5  45 8B        EOR $8B
$43D7  45 3E        EOR $3E
$43D9  45 AA        EOR $AA
$43DB  44           .byte $44
$43DC  BC 45 B6     LDY $B645,X
$43DF  45 B0        EOR $B0
$43E1  45 AA        EOR $AA
$43E3  45 C2        EOR $C2
$43E5  45 C4        EOR $C4
$43E7  45 C6        EOR $C6
$43E9  45 C8        EOR $C8
$43EB  45 CD        EOR $CD
$43ED  45 CF        EOR $CF
$43EF  45 D4        EOR $D4
$43F1  45 D8        EOR $D8
$43F3  45 DC        EOR $DC
$43F5  45 DE        EOR $DE
$43F7  45 E4        EOR $E4
$43F9  45 E6        EOR $E6
$43FB  45 E8        EOR $E8
$43FD  45 EA        EOR $EA
$43FF  45 EC        EOR $EC

; ====================================================================
; ROOM DATA AND TABLES ($4700-$51FF)
; ====================================================================

$4700  41 59        EOR ($59,X)
$4702  45 52        EOR $52
$4704  20 32 A0     JSR $A032
$4707  22           .byte $22
$4708  32           .byte $32
$4709  35 23        AND $23,X
$470B  25 00        AND $00
$470D  2C 25 25     BIT $2525
$4710  00           BRK
$4711  08           PHP
$4712  23           .byte $23
$4713  09 00        ORA #$00
$4715  11 19        ORA ($19),Y
$4717  18           CLC
$4718  14           .byte $14
$4719  00           BRK
$471A  24 21        BIT $21
$471C  34           .byte $34
$471D  21 33        AND ($33,X)
$471F  2F           .byte $2F
$4720  26 34        ROL $34
$4722  00           BRK
$4723  32           .byte $32
$4724  25 36        AND $36
$4726  0E 12 00     ASL $0012
$4729  22           .byte $22
$472A  39 00 32     AND $3200,Y
$472D  2A           ROL
$472E  26 20        ROL $20
$4730  20 A0 20     JSR $20A0
$4733  A0 4F        LDY #$4F
$4735  A0 CF        LDY #$CF
$4737  CF           .byte $CF
$4738  CF           .byte $CF
$4739  A0 20        LDY #$20
$473B  20 A3 A0     JSR $A0A3
$473E  20 20 A3     JSR $A320
$4741  A0 69        LDY #$69
$4743  69 69        ADC #$69
$4745  A0 64        LDY #$64
$4747  64           .byte $64
$4748  A0 20        LDY #$20
$474A  20 A3 A0     JSR $A0A3
$474D  7A           .byte $7A
$474E  7A           .byte $7A
$474F  A0 2A        LDY #$2A
$4751  2A           ROL
$4752  20 43 4F     JSR $4F43
$4755  4E 47 52     LSR $5247
$4758  41 54        EOR ($54,X)
$475A  55 4C        EOR $4C,X ; column_counter
$475C  41 54        EOR ($54,X)
$475E  49 4F        EOR #$4F
$4760  4E 53 20     LSR $2053
$4763  2A           ROL
$4764  2A           ROL
$4765  A0 29        LDY #$29
$4767  29 29        AND #$29
$4769  29 29        AND #$29
$476B  29 29        AND #$29
$476D  A0 A6        LDY #$A6
$476F  A0 44        LDY #$44
$4771  41 54        EOR ($54,X)
$4773  41 53        EOR ($53,X)
$4775  4F           .byte $4F
$4776  46 54        LSR $54
$4778  20 50 52     JSR $5250
$477B  45 53        EOR $53
$477D  45 4E        EOR $4E
$477F  54           .byte $54
$4780  53           .byte $53
$4781  A0 27        LDY #$27
$4783  A0 AE        LDY #$AE
$4785  A0 E6        LDY #$E6
$4787  04           .byte $04
$4788  D0 02        BNE $478C
$478A  E6 05        INC $05 ; screen_ptr_hi
$478C  60           RTS

; --- Subroutine at $478D ---
$478D  E6 06        INC $06 ; data_ptr_lo
$478F  D0 02        BNE $4793
$4791  E6 07        INC $07 ; data_ptr_hi
$4793  60           RTS

; --- Subroutine at $4794 ---
$4794  E6 08        INC $08 ; color_ptr_lo
$4796  D0 02        BNE $479A
$4798  E6 09        INC $09 ; color_ptr_hi
$479A  60           RTS
$479B  F0 FB        BEQ $4798
$479D  F1 FE        SBC ($FE),Y
$479F  F7           .byte $F7
$47A0  FE FE FE     INC $FEFE,X
$47A3  FE FC FC     INC $FCFC,X
$47A6  FC           .byte $FC
$47A7  FF           .byte $FF
$47A8  FA           .byte $FA
$47A9  FA           .byte $FA
$47AA  F9 FB F9     SBC $F9FB,Y
$47AD  FA           .byte $FA
$47AE  F9 FC F9     SBC $F9FC,Y
$47B1  FF           .byte $FF
$47B2  FE FF FB     INC $FBFF,X
$47B5  F1 FE        SBC ($FE),Y
$47B7  FB           .byte $FB
$47B8  F2           .byte $F2
$47B9  F1 FC        SBC ($FC),Y
$47BB  F2           .byte $F2
$47BC  F1 F6        SBC ($F6),Y
$47BE  FE F1 0A     INC $0AF1,X
$47C1  0E 34 04     ASL $0434
$47C4  00           BRK
$47C5  0A           ASL
$47C6  0E 34 FB     ASL $FB34
$47C9  F1 FE        SBC ($FE),Y
$47CB  FB           .byte $FB
$47CC  F2           .byte $F2
$47CD  F1 FC        SBC ($FC),Y
$47CF  F2           .byte $F2
$47D0  F1 F6        SBC ($F6),Y
$47D2  FE F1 F8     INC $F8F1,X
$47D5  F9 F1 F6     SBC $F6F1,Y
$47D8  FE FB FC     INC $FCFB,X
$47DB  FE FB F4     INC $F4FB,X
$47DE  FE FB FE     INC $FEFB,X
$47E1  F6 F1        INC $F1,X
$47E3  FE F6 FB     INC $FBF6,X
$47E6  FC           .byte $FC
$47E7  FE F1 FF     INC $FFF1,X
$47EA  F8           SED
$47EB  FC           .byte $FC
$47EC  FC           .byte $FC
$47ED  F8           SED
$47EE  FB           .byte $FB
$47EF  F0 FE        BEQ $47EF
$47F1  F4           .byte $F4
$47F2  F6 F2        INC $F2,X ; scroll_state
$47F4  F1 78        SBC ($78),Y
$47F6  97           .byte $97
$47F7  FD 78 78     SBC $7878,X
$47FA  97           .byte $97
$47FB  FD 78 97     SBC $9778,X
$47FE  FD 78 97     SBC $9778,X
$4801  FD 62 97     SBC $9762,X
$4804  FD FD 56     SBC $56FD,X
$4807  FD B6 C7     SBC $C7B6,X
$480A  FD C8 47     SBC $47C8,X
$480D  C8           INY
$480E  47           .byte $47
$480F  C8           INY
$4810  47           .byte $47
$4811  C8           INY
$4812  47           .byte $47
$4813  D1 47        CMP ($47),Y
$4815  D1 47        CMP ($47),Y
$4817  D1 47        CMP ($47),Y
$4819  D4           .byte $D4
$481A  47           .byte $47
$481B  D4           .byte $D4
$481C  47           .byte $47
$481D  D4           .byte $D4
$481E  47           .byte $47
$481F  D7           .byte $D7
$4820  47           .byte $47
$4821  DD 47 D7     CMP $D747,X
$4824  47           .byte $47
$4825  E0 47        CPX #$47
$4827  D7           .byte $D7
$4828  47           .byte $47
$4829  E3           .byte $E3
$482A  47           .byte $47
$482B  D7           .byte $D7
$482C  47           .byte $47
$482D  EC 47 EF     CPX $EF47
$4830  47           .byte $47
$4831  F2           .byte $F2
$4832  47           .byte $47
$4833  F9 47 FC     SBC $FC47,Y
$4836  47           .byte $47
$4837  FF           .byte $FF
$4838  47           .byte $47
$4839  02           .byte $02
$483A  48           PHA
$483B  05 48        ORA $48 ; timer
$483D  05 48        ORA $48 ; timer
$483F  05 48        ORA $48 ; timer
$4841  05 48        ORA $48 ; timer
$4843  05 48        ORA $48 ; timer
$4845  05 48        ORA $48 ; timer
$4847  06 48        ASL $48 ; timer
$4849  05 48        ORA $48 ; timer
$484B  06 48        ASL $48 ; timer
$484D  05 48        ORA $48 ; timer
$484F  06 48        ASL $48 ; timer
$4851  08           PHP
$4852  48           PHA
$4853  06 48        ASL $48 ; timer
$4855  05 48        ORA $48 ; timer
$4857  05 48        ORA $48 ; timer
$4859  05 48        ORA $48 ; timer

; --- Subroutine at $485B ---
$485B  48           PHA
$485C  C6 F3        DEC $F3 ; draw_counter
$485E  10 30        BPL $4890
$4860  A9 27        LDA #$27
$4862  85 F3        STA $F3 ; draw_counter
$4864  A5 04        LDA $04 ; screen_ptr_lo
$4866  18           CLC
$4867  69 28        ADC #$28
$4869  85 04        STA $04 ; screen_ptr_lo
$486B  90 02        BCC $486F
$486D  E6 05        INC $05 ; screen_ptr_hi
$486F  A5 08        LDA $08 ; color_ptr_lo
$4871  18           CLC
$4872  69 28        ADC #$28
$4874  85 08        STA $08 ; color_ptr_lo
$4876  90 02        BCC $487A
$4878  E6 09        INC $09 ; color_ptr_hi
$487A  A5 10        LDA $10 ; temp_ptr_lo
$487C  18           CLC
$487D  69 28        ADC #$28
$487F  85 10        STA $10 ; temp_ptr_lo
$4881  90 02        BCC $4885
$4883  E6 11        INC $11 ; temp_ptr_hi
$4885  A5 12        LDA $12 ; temp2_ptr_lo
$4887  18           CLC
$4888  69 28        ADC #$28
$488A  85 12        STA $12 ; temp2_ptr_lo
$488C  90 02        BCC $4890
$488E  E6 13        INC $13 ; temp2_ptr_hi
$4890  68           PLA
$4891  60           RTS

; --- Subroutine at $4892 ---
$4892  A0 00        LDY #$00
$4894  A2 03        LDX #$03
$4896  B1 04        LDA ($04),Y
$4898  91 06        STA ($06),Y
$489A  20 8D 47     JSR $478D
$489D  91 06        STA ($06),Y
$489F  20 8D 47     JSR $478D
$48A2  20 86 47     JSR $4786
$48A5  CA           DEX
$48A6  10 EE        BPL $4896
$48A8  A2 03        LDX #$03
$48AA  B1 04        LDA ($04),Y
$48AC  91 08        STA ($08),Y
$48AE  20 94 47     JSR $4794
$48B1  91 08        STA ($08),Y
$48B3  20 94 47     JSR $4794
$48B6  20 86 47     JSR $4786
$48B9  CA           DEX
$48BA  10 EE        BPL $48AA
$48BC  C6 F3        DEC $F3 ; draw_counter
$48BE  10 D2        BPL $4892
$48C0  60           RTS
$48C1  A9 32        LDA #$32
$48C3  8D 18 D0     STA $D018 ; VIC_MEM
$48C6  A9 FC        LDA #$FC
$48C8  8D 21 D0     STA $D021 ; VIC_BG0
$48CB  A9 1E        LDA #$1E
$48CD  8D 08 04     STA $0408
$48D0  A9 49        LDA #$49
$48D2  8D 09 04     STA $0409
$48D5  A9 01        LDA #$01
$48D7  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$48DA  8D 19 D0     STA $D019 ; VIC_IRQ
$48DD  AD 11 D0     LDA $D011 ; VIC_CTRL1
$48E0  29 7F        AND #$7F
$48E2  8D 11 D0     STA $D011 ; VIC_CTRL1
$48E5  A9 40        LDA #$40
$48E7  8D 12 D0     STA $D012 ; VIC_RASTER
$48EA  A5 29        LDA $29 ; room_number
$48EC  0A           ASL
$48ED  AA           TAX
$48EE  BD 0B 48     LDA $480B,X
$48F1  85 0A        STA $0A
$48F3  BD 0C 48     LDA $480C,X
$48F6  85 0B        STA $0B
$48F8  BD 33 48     LDA $4833,X
$48FB  85 0C        STA $0C
$48FD  BD 34 48     LDA $4834,X
$4900  85 0D        STA $0D
$4902  A0 0B        LDY #$0B
$4904  B1 0A        LDA ($0A),Y
$4906  99 53 01     STA $0153,Y
$4909  C0 04        CPY #$04
$490B  B0 05        BCS $4912
$490D  B1 0C        LDA ($0C),Y
$490F  99 F5 47     STA $47F5,Y
$4912  88           DEY
$4913  10 EF        BPL $4904
$4915  20 A8 15     JSR $15A8
$4918  68           PLA
$4919  A8           TAY
$491A  68           PLA
$491B  AA           TAX
$491C  68           PLA
$491D  40           RTI
$491E  A9 41        LDA #$41
$4920  CD 12 D0     CMP $D012 ; VIC_RASTER
$4923  B0 FB        BCS $4920
$4925  A2 0A        LDX #$0A
$4927  CA           DEX
$4928  D0 FD        BNE $4927
$492A  A5 F2        LDA $F2 ; scroll_state
$492C  8D 18 D0     STA $D018 ; VIC_MEM
$492F  AD 53 01     LDA $0153
$4932  8D 21 D0     STA $D021 ; VIC_BG0
$4935  AD 54 01     LDA $0154
$4938  8D 22 D0     STA $D022 ; VIC_MC1
$493B  AD 55 01     LDA $0155
$493E  8D 23 D0     STA $D023 ; VIC_MC2
$4941  A9 00        LDA #$00
$4943  85 44        STA $44
$4945  A9 03        LDA #$03
$4947  85 F4        STA $F4
$4949  A9 82        LDA #$82
$494B  8D 08 04     STA $0408
$494E  A9 49        LDA #$49
$4950  8D 09 04     STA $0409

; --- Subroutine at $4953 ---
$4953  A9 01        LDA #$01
$4955  8D 1A D0     STA $D01A ; VIC_IRQ_EN
$4958  8D 19 D0     STA $D019 ; VIC_IRQ
$495B  AD 11 D0     LDA $D011 ; VIC_CTRL1
$495E  29 7F        AND #$7F
$4960  8D 11 D0     STA $D011 ; VIC_CTRL1
$4963  A6 44        LDX $44
$4965  BD F5 47     LDA $47F5,X
$4968  8D 12 D0     STA $D012 ; VIC_RASTER
$496B  C9 FD        CMP #$FD
$496D  F0 06        BEQ $4975

; --- Subroutine at $496F ---
$496F  68           PLA
$4970  A8           TAY
$4971  68           PLA
$4972  AA           TAX
$4973  68           PLA
$4974  40           RTI
$4975  A9 C1        LDA #$C1
$4977  8D 08 04     STA $0408
$497A  A9 48        LDA #$48
$497C  8D 09 04     STA $0409
$497F  4C 6F 49     JMP $496F
$4982  A6 F4        LDX $F4
$4984  BC 53 01     LDY $0153,X
$4987  A6 44        LDX $44
$4989  BD F5 47     LDA $47F5,X
$498C  AA           TAX
$498D  E8           INX
$498E  E8           INX
$498F  8A           TXA
$4990  E8           INX
$4991  EC 12 D0     CPX $D012 ; VIC_RASTER
$4994  F0 0A        BEQ $49A0
$4996  CD 12 D0     CMP $D012 ; VIC_RASTER
$4999  D0 F6        BNE $4991
$499B  A2 0A        LDX #$0A
$499D  CA           DEX
$499E  D0 FD        BNE $499D
$49A0  8C 21 D0     STY $D021 ; VIC_BG0
$49A3  A6 F4        LDX $F4
$49A5  BD 54 01     LDA $0154,X
$49A8  8D 22 D0     STA $D022 ; VIC_MC1
$49AB  BD 55 01     LDA $0155,X
$49AE  8D 23 D0     STA $D023 ; VIC_MC2
$49B1  A5 F4        LDA $F4
$49B3  18           CLC
$49B4  69 03        ADC #$03
$49B6  85 F4        STA $F4
$49B8  E6 44        INC $44
$49BA  4C 53 49     JMP $4953
$49BD  5C           .byte $5C
$49BE  5C           .byte $5C
$49BF  5C           .byte $5C
$49C0  5C           .byte $5C
$49C1  5C           .byte $5C
$49C2  5C           .byte $5C
$49C3  5C           .byte $5C
$49C4  5C           .byte $5C
$49C5  5C           .byte $5C
$49C6  5C           .byte $5C
$49C7  5C           .byte $5C
$49C8  5C           .byte $5C
$49C9  04           .byte $04
$49CA  06 24        ASL $24
$49CC  26 28        ROL $28 ; lives
$49CE  2A           ROL
$49CF  08           PHP
$49D0  0A           ASL
$49D1  0C           .byte $0C
$49D2  0E 5C 5C     ASL $5C5C
$49D5  14           .byte $14
$49D6  16 0C        ASL $0C,X
$49D8  0E 0C 0E     ASL $0E0C
$49DB  5C           .byte $5C
$49DC  5C           .byte $5C
$49DD  5C           .byte $5C
$49DE  5C           .byte $5C
$49DF  5C           .byte $5C
$49E0  5C           .byte $5C
$49E1  5C           .byte $5C
$49E2  5C           .byte $5C
$49E3  5C           .byte $5C
$49E4  5C           .byte $5C
$49E5  5C           .byte $5C
$49E6  5C           .byte $5C
$49E7  5C           .byte $5C
$49E8  5C           .byte $5C
$49E9  5C           .byte $5C
$49EA  5C           .byte $5C
$49EB  5C           .byte $5C
$49EC  5C           .byte $5C
$49ED  5C           .byte $5C
$49EE  5C           .byte $5C
$49EF  5C           .byte $5C
$49F0  5C           .byte $5C
$49F1  05 07        ORA $07 ; data_ptr_hi
$49F3  25 27        AND $27
$49F5  29 2B        AND #$2B
$49F7  09 0B        ORA #$0B
$49F9  0D 0F 5C     ORA $5C0F
$49FC  5C           .byte $5C
$49FD  15 17        ORA $17,X
$49FF  0D 0F 0D     ORA $0D0F
$4A02  0F           .byte $0F
$4A03  5C           .byte $5C
$4A04  5C           .byte $5C
$4A05  5C           .byte $5C
$4A06  5C           .byte $5C
$4A07  5C           .byte $5C
$4A08  5C           .byte $5C
$4A09  5C           .byte $5C
$4A0A  5C           .byte $5C
$4A0B  5C           .byte $5C
$4A0C  5C           .byte $5C
$4A0D  5C           .byte $5C
$4A0E  5C           .byte $5C
$4A0F  5C           .byte $5C
$4A10  5C           .byte $5C
$4A11  61 62        ADC ($62,X)
$4A13  5D 5E 75     EOR $755E,X
$4A16  76 5D        ROR $5D,X
$4A18  5E 73 74     LSR $7473,X
$4A1B  6D 6E 65     ADC $656E
$4A1E  66 75        ROR $75
$4A20  76 5C        ROR $5C,X
$4A22  5C           .byte $5C
$4A23  6F           .byte $6F
$4A24  70 71        BVS $4A97
$4A26  72           .byte $72
$4A27  63           .byte $63
$4A28  64           .byte $64
$4A29  73           .byte $73
$4A2A  74           .byte $74
$4A2B  63           .byte $63
$4A2C  64           .byte $64
$4A2D  6B           .byte $6B
$4A2E  6C 75 76     JMP ($7675)
$4A31  73           .byte $73
$4A32  74           .byte $74
$4A33  5C           .byte $5C
$4A34  5C           .byte $5C
$4A35  5C           .byte $5C
$4A36  5C           .byte $5C
$4A37  5C           .byte $5C
$4A38  5C           .byte $5C
$4A39  5F           .byte $5F
$4A3A  60           RTS
$4A3B  77           .byte $77
$4A3C  78           SEI
$4A3D  5C           .byte $5C
$4A3E  5C           .byte $5C
$4A3F  5C           .byte $5C
$4A40  5C           .byte $5C
$4A41  71 72        ADC ($72),Y
$4A43  6D 6E 6B     ADC $6B6E
$4A46  6C 5C 5C     JMP ($5C5C)
$4A49  69 6A        ADC #$6A
$4A4B  5C           .byte $5C
$4A4C  5C           .byte $5C
$4A4D  65 66        ADC $66
$4A4F  6D 6E 71     ADC $716E
$4A52  72           .byte $72
$4A53  75 76        ADC $76,X
$4A55  67           .byte $67
$4A56  68           PLA
$4A57  63           .byte $63
$4A58  64           .byte $64
$4A59  71 72        ADC ($72),Y
$4A5B  5C           .byte $5C
$4A5C  5C           .byte $5C
$4A5D  20 22 14     JSR $1422
$4A60  16 00        ASL $00,X
$4A62  02           .byte $02
$4A63  30 32        BMI $4A97
$4A65  0C           .byte $0C
$4A66  0E 24 26     ASL $2624
$4A69  5C           .byte $5C
$4A6A  5C           .byte $5C
$4A6B  38           SEC
$4A6C  3A           .byte $3A
$4A6D  21 23        AND ($23,X)
$4A6F  15 17        ORA $17,X
$4A71  01 03        ORA ($03,X)
$4A73  31 33        AND ($33),Y
$4A75  0D 0F 25     ORA $250F
$4A78  27           .byte $27
$4A79  5C           .byte $5C
$4A7A  5C           .byte $5C
$4A7B  39 3B 38     AND $383B,Y
$4A7E  3A           .byte $3A
$4A7F  3C           .byte $3C
$4A80  3E           .byte $3E
$4A81  39 3B 3D     AND $3D3B,Y
$4A84  3F           .byte $3F
$4A85  00           BRK
$4A86  08           PHP
$4A87  04           .byte $04
$4A88  0C           .byte $0C
$4A89  00           BRK
$4A8A  3A           .byte $3A
$4A8B  76 00        ROR $00,X
$4A8D  03           .byte $03
$4A8E  03           .byte $03
$4A8F  00           BRK
$4A90  00           BRK
$4A91  00           BRK
$4A92  00           BRK
$4A93  00           BRK
$4A94  03           .byte $03
$4A95  03           .byte $03
$4A96  03           .byte $03
$4A97  03           .byte $03
$4A98  00           BRK
$4A99  00           BRK
$4A9A  00           BRK
$4A9B  00           BRK
$4A9C  00           BRK
$4A9D  00           BRK
$4A9E  00           BRK
$4A9F  00           BRK
$4AA0  00           BRK
$4AA1  00           BRK
$4AA2  00           BRK
$4AA3  00           BRK
$4AA4  00           BRK
$4AA5  00           BRK
$4AA6  01 00        ORA ($00,X)
$4AA8  D0 4A        BNE $4AF4
$4AAA  D0 4A        BNE $4AF6
$4AAC  D0 4A        BNE $4AF8
$4AAE  D0 4A        BNE $4AFA
$4AB0  E4 4A        CPX $4A
$4AB2  E4 4A        CPX $4A
$4AB4  E4 4A        CPX $4A
$4AB6  E9 4A        SBC #$4A
$4AB8  E9 4A        SBC #$4A
$4ABA  E9 4A        SBC #$4A
$4ABC  EE 4A FD     INC $FD4A
$4ABF  4A           LSR
$4AC0  EE 4A 02     INC $024A
$4AC3  4B           .byte $4B
$4AC4  EE 4A 0C     INC $0C4A
$4AC7  4B           .byte $4B
$4AC8  EE 4A 1B     INC $1B4A
$4ACB  4B           .byte $4B
$4ACC  25 4B        AND $4B
$4ACE  2A           ROL
$4ACF  4B           .byte $4B
$4AD0  04           .byte $04
$4AD1  00           BRK
$4AD2  06 88        ASL $88
$4AD4  0E 04 00     ASL $0004
$4AD7  0A           ASL
$4AD8  0E 34 06     ASL $0634
$4ADB  00           BRK
$4ADC  0A           ASL
$4ADD  0E 34 04     ASL $0434
$4AE0  00           BRK
$4AE1  0A           ASL
$4AE2  0E 34 84     ASL $8434
$4AE5  00           BRK
$4AE6  70 0E        BVS $4AF6
$4AE8  60           RTS
$4AE9  34           .byte $34
$4AEA  00           BRK
$4AEB  32           .byte $32
$4AEC  0E 40 74     ASL $7440
$4AEF  00           BRK
$4AF0  0E 04 88     ASL $8804
$4AF3  08           PHP
$4AF4  00           BRK
$4AF5  0E 04 88     ASL $8804
$4AF8  08           PHP
$4AF9  00           BRK
$4AFA  2C 04 88     BIT $8804
$4AFD  66 00        ROR $00
$4AFF  8E 02 88     STX $8802
$4B02  96 00        STX $00,Y
$4B04  00           BRK
$4B05  0E 7C 96     ASL $967C
$4B08  00           BRK
$4B09  0E 00 7C     ASL $7C00
$4B0C  86 00        STX $00
$4B0E  60           RTS
$4B0F  02           .byte $02
$4B10  7A           .byte $7A
$4B11  02           .byte $02
$4B12  00           BRK
$4B13  60           RTS
$4B14  0E 7A 04     ASL $047A
$4B17  00           BRK
$4B18  60           RTS
$4B19  06 7E        ASL $7E
$4B1B  08           PHP
$4B1C  00           BRK
$4B1D  2C 04 38     BIT $3804
$4B20  08           PHP
$4B21  00           BRK
$4B22  2C 04 38     BIT $3804
$4B25  00           BRK
$4B26  82           .byte $82
$4B27  82           .byte $82
$4B28  68           PLA
$4B29  8C 84 00     STY $0084
$4B2C  70 0F        BVS $4B3D
$4B2E  30 84        BMI $4AB4
$4B30  00           BRK
$4B31  70 0F        BVS $4B42
$4B33  30 F9        BMI $4B2E
$4B35  09 3E        ORA #$3E
$4B37  9D 1B 82     STA $821B,X
$4B3A  DD 27 11     CMP $1127,X
$4B3D  91 D8        STA ($D8),Y
$4B3F  4C 43 C6     JMP $C643
$4B42  46 B4        LSR $B4
$4B44  5C           .byte $5C
$4B45  8D 90 E0     STA $E090
$4B48  E0 68        CPX #$68
$4B4A  6A           ROR
$4B4B  6B           .byte $6B
$4B4C  6C 6E 6F     JMP ($6F6E)
$4B4F  70 72        BVS $4BC3
$4B51  73           .byte $73
$4B52  74           .byte $74
$4B53  75 77        ADC $77,X
$4B55  78           SEI
$4B56  79 7A 7B     ADC $7B7A,Y
$4B59  7C           .byte $7C
$4B5A  7D 7E 7F     ADC $7F7E,X
$4B5D  7F           .byte $7F
$4B5E  01 00        ORA ($00,X)
$4B60  00           BRK
$4B61  00           BRK
$4B62  05 04        ORA $04 ; screen_ptr_lo
$4B64  05 00        ORA $00
$4B66  07           .byte $07
$4B67  08           PHP
$4B68  03           .byte $03
$4B69  0A           ASL
$4B6A  00           BRK
$4B6B  0F           .byte $0F
$4B6C  00           BRK
$4B6D  0D 00 0F     ORA $0F00
$4B70  11 00        ORA ($00),Y
$4B72  00           BRK
$4B73  05 00        ORA $00
$4B75  0A           ASL
$4B76  07           .byte $07
$4B77  06 05        ASL $05 ; screen_ptr_hi
$4B79  08           PHP
$4B7A  09 08        ORA #$08
$4B7C  0B           .byte $0B
$4B7D  0C           .byte $0C
$4B7E  0B           .byte $0B
$4B7F  00           BRK
$4B80  0B           .byte $0B
$4B81  11 0B        ORA ($0B),Y
$4B83  12           .byte $12
$4B84  13           .byte $13
$4B85  00           BRK
$4B86  00           BRK
$4B87  00           BRK
$4B88  01 02        ORA ($02,X)
$4B8A  00           BRK
$4B8B  06 02        ASL $02
$4B8D  08           PHP
$4B8E  07           .byte $07
$4B8F  06 00        ASL $00
$4B91  0E 0E 00     ASL $000E
$4B94  0C           .byte $0C
$4B95  00           BRK
$4B96  0E 00 00     ASL $0000
$4B99  00           BRK
$4B9A  01 02        ORA ($02,X)
$4B9C  03           .byte $03
$4B9D  00           BRK
$4B9E  00           BRK
$4B9F  01 00        ORA ($00,X)
$4BA1  00           BRK
$4BA2  09 00        ORA #$00
$4BA4  00           BRK
$4BA5  10 00        BPL $4BA7
$4BA7  00           BRK
$4BA8  10 00        BPL $4BAA
$4BAA  00           BRK
$4BAB  00           BRK
$4BAC  00           BRK
$4BAD  00           BRK
$4BAE  1A           .byte $1A
$4BAF  18           CLC
$4BB0  30 20        BMI $4BD2
$4BB2  94 22        STY $22,X
$4BB4  86 1C        STX $1C
$4BB6  14           .byte $14
$4BB7  12           .byte $12
$4BB8  34           .byte $34
$4BB9  40           RTI
$4BBA  18           CLC
$4BBB  98           TYA
$4BBC  18           CLC
$4BBD  1C           .byte $1C
$4BBE  18           CLC
$4BBF  18           CLC
$4BC0  18           CLC
$4BC1  12           .byte $12
$4BC2  C4 62        CPY $62
$4BC4  C4 C0        CPY $C0
$4BC6  B4 51        LDY $51,X
$4BC8  B3           .byte $B3
$4BC9  44           .byte $44
$4BCA  46 C6        LSR $C6
$4BCC  8C 4C 5C     STY $5C4C
$4BCF  32           .byte $32
$4BD0  5C           .byte $5C
$4BD1  C3           .byte $C3
$4BD2  5C           .byte $5C
$4BD3  B4 C6        LDY $C6,X
$4BD5  95 9F        STA $9F,X
$4BD7  95 96        STA $96,X
$4BD9  38           SEC
$4BDA  96 28        STX $28,Y ; lives
$4BDC  81 1F        STA ($1F,X)
$4BDE  00           BRK
$4BDF  00           BRK
$4BE0  96 00        STX $00,Y
$4BE2  70 00        BVS $4BE4
$4BE4  92           .byte $92
$4BE5  7A           .byte $7A
$4BE6  81 00        STA ($00,X)
$4BE8  00           BRK
$4BE9  00           BRK
$4BEA  62           .byte $62
$4BEB  92           .byte $92
$4BEC  C4 C4        CPY $C4
$4BEE  B4 C2        LDY $C2,X
$4BF0  72           .byte $72
$4BF1  74           .byte $74
$4BF2  00           BRK
$4BF3  00           BRK
$4BF4  5C           .byte $5C
$4BF5  00           BRK
$4BF6  5C           .byte $5C
$4BF7  00           BRK
$4BF8  BE C4 8E     LDX $8EC4,Y
$4BFB  00           BRK
$4BFC  00           BRK
$4BFD  00           BRK
$4BFE  10 A0        BPL $4BA0
$4C00  00           BRK
$4C01  00           BRK
$4C02  10 9C        BPL $4BA0
$4C04  A0 30        LDY #$30
$4C06  A0 A0        LDY #$A0
$4C08  A0 A0        LDY #$A0
$4C0A  00           BRK
$4C0B  10 00        BPL $4C0D
$4C0D  A0 00        LDY #$00
$4C0F  A0 A0        LDY #$A0
$4C11  00           BRK
$4C12  92           .byte $92
$4C13  92           .byte $92
$4C14  00           BRK
$4C15  00           BRK
$4C16  C2           .byte $C2
$4C17  51 80        EOR ($80),Y
$4C19  51 74        EOR ($74),Y
$4C1B  47           .byte $47
$4C1C  C4 5A        CPY $5A
$4C1E  00           BRK
$4C1F  C3           .byte $C3
$4C20  00           BRK
$4C21  C4 00        CPY $00
$4C23  93           .byte $93
$4C24  44           .byte $44
$4C25  00           BRK
$4C26  00           BRK
$4C27  2C 00 10     BIT $1000
$4C2A  1F           .byte $1F
$4C2B  10 A0        BPL $4BCD
$4C2D  0F           .byte $0F
$4C2E  10 A0        BPL $4BD0
$4C30  10 10        BPL $4C42
$4C32  34           .byte $34
$4C33  00           BRK
$4C34  50 10        BVC $4C46
$4C36  80           .byte $80
$4C37  10 10        BPL $4C49
$4C39  00           BRK
$4C3A  00           BRK
$4C3B  32           .byte $32
$4C3C  00           BRK
$4C3D  B0 32        BCS $4C71
$4C3F  40           RTI
$4C40  66 46        ROR $46
$4C42  53           .byte $53
$4C43  C0 C4        CPY #$C4
$4C45  5C           .byte $5C
$4C46  BE 00 BE     LDX $BE00,Y
$4C49  B3           .byte $B3
$4C4A  BE C6 96     LDX $96C6,Y
$4C4D  00           BRK
$4C4E  00           BRK
$4C4F  A1 A1        LDA ($A1,X)
$4C51  A1 00        LDA ($00,X)
$4C53  10 16        BPL $4C6B
$4C55  10 A1        BPL $4BF8
$4C57  9D 00 10     STA $1000,X
$4C5A  10 00        BPL $4C5C
$4C5C  A0 00        LDY #$00
$4C5E  A0 00        LDY #$00
$4C60  00           BRK
$4C61  00           BRK
$4C62  00           BRK
$4C63  62           .byte $62
$4C64  62           .byte $62
$4C65  C5 00        CMP $00
$4C67  74           .byte $74
$4C68  51 C0        EOR ($C0),Y
$4C6A  B5 C7        LDA $C7,X
$4C6C  00           BRK
$4C6D  5E BE 00     LSR $00BE,X
$4C70  BE 00 BE     LDX $BE00,Y
$4C73  00           BRK
$4C74  00           BRK
$4C75  00           BRK
$4C76  0F           .byte $0F
$4C77  10 10        BPL $4C89
$4C79  10 00        BPL $4C7B
$4C7B  58           CLI
$4C7C  20 20 0F     JSR $0F20
$4C7F  00           BRK
$4C80  00           BRK
$4C81  10 00        BPL $4C83
$4C83  00           BRK
$4C84  10 00        BPL $4C86
$4C86  00           BRK
$4C87  00           BRK
$4C88  00           BRK
$4C89  00           BRK
$4C8A  62           .byte $62
$4C8B  62           .byte $62
$4C8C  C4 62        CPY $62
$4C8E  00           BRK
$4C8F  66 51        ROR $51
$4C91  51 C6        EOR ($C6),Y
$4C93  00           BRK
$4C94  00           BRK
$4C95  5C           .byte $5C
$4C96  00           BRK
$4C97  00           BRK
$4C98  BE 00 00     LDX $0000,Y
$4C9B  00           BRK
$4C9C  00           BRK
$4C9D  00           BRK
$4C9E  00           BRK
$4C9F  00           BRK
$4CA0  00           BRK
$4CA1  FF           .byte $FF
$4CA2  00           BRK
$4CA3  00           BRK
$4CA4  00           BRK
$4CA5  00           BRK
$4CA6  FF           .byte $FF
$4CA7  FF           .byte $FF
$4CA8  00           BRK
$4CA9  FF           .byte $FF
$4CAA  00           BRK
$4CAB  FF           .byte $FF
$4CAC  00           BRK
$4CAD  00           BRK
$4CAE  00           BRK
$4CAF  FF           .byte $FF
$4CB0  FF           .byte $FF
$4CB1  FF           .byte $FF
$4CB2  84 08        STY $08 ; color_ptr_lo
$4CB4  06 04        ASL $04 ; screen_ptr_lo
$4CB6  02           .byte $02
$4CB7  04           .byte $04
$4CB8  06 08        ASL $08 ; color_ptr_lo
$4CBA  32           .byte $32
$4CBB  1F           .byte $1F
$4CBC  1E 1A 18     ASL $181A,X
$4CBF  1D 1B 33     ORA $331B,X
$4CC2  35 30        AND $30,X
$4CC4  72           .byte $72
$4CC5  5F           .byte $5F
$4CC6  5E 5A 58     LSR $585A,X
$4CC9  5D 5B 73     EOR $735B,X
$4CCC  75 70        ADC $70,X
$4CCE  06 06        ASL $06 ; data_ptr_lo
$4CD0  0A           ASL
$4CD1  02           .byte $02
$4CD2  02           .byte $02
$4CD3  0A           ASL
$4CD4  08           PHP
$4CD5  0D 04 05     ORA $0504
$4CD8  03           .byte $03
$4CD9  03           .byte $03
$4CDA  03           .byte $03
$4CDB  00           BRK
$4CDC  04           .byte $04
$4CDD  06 02        ASL $02
$4CDF  02           .byte $02
$4CE0  01 00        ORA ($00,X)
$4CE2  0C           .byte $0C
$4CE3  4D 25 4D     EOR $4D25
$4CE6  3E           .byte $3E
$4CE7  4D 67 4D     EOR $4D67
$4CEA  70 4D        BVS $4D39
$4CEC  79 4D A2     ADC $A24D,Y
$4CEF  4D C3 4D     EOR $4DC3
$4CF2  F8           SED
$4CF3  4D 09 4E     EOR $4E09
$4CF6  1E 4E 2B     ASL $2B4E,X
$4CF9  4E 38 4E     LSR $4E38
$4CFC  45 4E        EOR $4E
$4CFE  4A           LSR
$4CFF  4E 5B 4E     LSR $4E5B
$4D02  74           .byte $74
$4D03  4E 7D 4E     LSR $4E7D
$4D06  86 4E        STX $4E
$4D08  8B           .byte $8B
$4D09  4E 90 4E     LSR $4E90
$4D0C  01 9F        ORA ($9F,X)
$4D0E  1F           .byte $1F
$4D0F  07           .byte $07
$4D10  01 92        ORA ($92,X)
$4D12  26 07        ROL $07 ; data_ptr_hi
$4D14  01 9F        ORA ($9F,X)
$4D16  02           .byte $02
$4D17  0A           ASL
$4D18  01 9F        ORA ($9F,X)
$4D1A  19 0A 01     ORA $010A,Y
$4D1D  92           .byte $92
$4D1E  1D 0A 01     ORA $010A,X
$4D21  92           .byte $92
$4D22  26 0A        ROL $0A
$4D24  FF           .byte $FF
$4D25  01 9E        ORA ($9E,X)
$4D27  09 07        ORA #$07
$4D29  01 9F        ORA ($9F,X)
$4D2B  1E 07 01     ASL $0107,X
$4D2E  92           .byte $92
$4D2F  06 0A        ASL $0A
$4D31  01 9E        ORA ($9E,X)
$4D33  0F           .byte $0F
$4D34  0A           ASL
$4D35  01 9F        ORA ($9F,X)
$4D37  18           CLC
$4D38  0A           ASL
$4D39  01 92        ORA ($92,X)
$4D3B  20 0A FF     JSR $FF0A
$4D3E  01 92        ORA ($92,X)
$4D40  05 07        ORA $07 ; data_ptr_hi
$4D42  01 9E        ORA ($9E,X)
$4D44  09 07        ORA #$07
$4D46  01 9F        ORA ($9F,X)
$4D48  16 07        ASL $07,X ; data_ptr_hi
$4D4A  01 9E        ORA ($9E,X)
$4D4C  1A           .byte $1A
$4D4D  07           .byte $07
$4D4E  01 9F        ORA ($9F,X)
$4D50  1E 07 01     ASL $0107,X
$4D53  9E           .byte $9E
$4D54  05 0A        ORA $0A
$4D56  01 9F        ORA ($9F,X)
$4D58  09 0A        ORA #$0A
$4D5A  01 9E        ORA ($9E,X)
$4D5C  0F           .byte $0F
$4D5D  0A           ASL
$4D5E  01 9F        ORA ($9F,X)
$4D60  15 0A        ORA $0A,X
$4D62  01 9E        ORA ($9E,X)
$4D64  1B           .byte $1B
$4D65  0A           ASL
$4D66  FF           .byte $FF
$4D67  01 9E        ORA ($9E,X)
$4D69  1D 0A 01     ORA $010A,X
$4D6C  9F           .byte $9F
$4D6D  26 0A        ROL $0A
$4D6F  FF           .byte $FF
$4D70  01 9E        ORA ($9E,X)
$4D72  0B           .byte $0B
$4D73  04           .byte $04
$4D74  01 9F        ORA ($9F,X)
$4D76  1C           .byte $1C
$4D77  04           .byte $04
$4D78  FF           .byte $FF
$4D79  01 9E        ORA ($9E,X)
$4D7B  02           .byte $02
$4D7C  03           .byte $03
$4D7D  01 9E        ORA ($9E,X)
$4D7F  06 03        ASL $03 ; room_subtype
$4D81  01 9F        ORA ($9F,X)
$4D83  1C           .byte $1C
$4D84  03           .byte $03
$4D85  01 9E        ORA ($9E,X)
$4D87  20 03 01     JSR $0103
$4D8A  9F           .byte $9F
$4D8B  26 03        ROL $03 ; room_subtype
$4D8D  01 9F        ORA ($9F,X)
$4D8F  1E 06 01     ASL $0106,X
$4D92  9E           .byte $9E
$4D93  02           .byte $02
$4D94  0A           ASL
$4D95  01 9F        ORA ($9F,X)
$4D97  17           .byte $17
$4D98  0A           ASL
$4D99  01 9F        ORA ($9F,X)
$4D9B  1A           .byte $1A
$4D9C  0A           ASL
$4D9D  01 9E        ORA ($9E,X)
$4D9F  1E 0A FF     ASL $FF0A,X
$4DA2  01 9F        ORA ($9F,X)
$4DA4  08           PHP
$4DA5  05 01        ORA $01 ; CPU_PORT
$4DA7  9E           .byte $9E
$4DA8  0A           ASL
$4DA9  05 01        ORA $01 ; CPU_PORT
$4DAB  9F           .byte $9F
$4DAC  0E 05 01     ASL $0105
$4DAF  9F           .byte $9F
$4DB0  16 05        ASL $05,X ; screen_ptr_hi
$4DB2  01 9F        ORA ($9F,X)
$4DB4  1A           .byte $1A
$4DB5  05 01        ORA $01 ; CPU_PORT
$4DB7  9E           .byte $9E
$4DB8  1C           .byte $1C
$4DB9  05 01        ORA $01 ; CPU_PORT
$4DBB  9F           .byte $9F
$4DBC  06 09        ASL $09 ; color_ptr_hi
$4DBE  01 9E        ORA ($9E,X)
$4DC0  1E 09 FF     ASL $FF09,X
$4DC3  01 9E        ORA ($9E,X)
$4DC5  03           .byte $03
$4DC6  02           .byte $02
$4DC7  01 9F        ORA ($9F,X)
$4DC9  0C           .byte $0C
$4DCA  02           .byte $02
$4DCB  01 9E        ORA ($9E,X)
$4DCD  0D 02 01     ORA $0102
$4DD0  9F           .byte $9F
$4DD1  19 02 01     ORA $0102,Y
$4DD4  9E           .byte $9E
$4DD5  1A           .byte $1A
$4DD6  02           .byte $02
$4DD7  01 9F        ORA ($9F,X)
$4DD9  05 05        ORA $05 ; screen_ptr_hi
$4DDB  01 9E        ORA ($9E,X)
$4DDD  06 05        ASL $05 ; screen_ptr_hi
$4DDF  01 9F        ORA ($9F,X)
$4DE1  0C           .byte $0C
$4DE2  05 01        ORA $01 ; CPU_PORT
$4DE4  9E           .byte $9E
$4DE5  0D 05 01     ORA $0105
$4DE8  9F           .byte $9F
$4DE9  19 05 01     ORA $0105,Y
$4DEC  9E           .byte $9E
$4DED  1A           .byte $1A
$4DEE  05 01        ORA $01 ; CPU_PORT
$4DF0  9F           .byte $9F
$4DF1  02           .byte $02
$4DF2  09 01        ORA #$01
$4DF4  9E           .byte $9E
$4DF5  03           .byte $03
$4DF6  09 FF        ORA #$FF
$4DF8  01 9F        ORA ($9F,X)
$4DFA  0F           .byte $0F
$4DFB  03           .byte $03
$4DFC  01 9F        ORA ($9F,X)
$4DFE  18           CLC
$4DFF  03           .byte $03
$4E00  01 9E        ORA ($9E,X)
$4E02  06 07        ASL $07 ; data_ptr_hi
$4E04  01 9F        ORA ($9F,X)
$4E06  21 07        AND ($07,X)
$4E08  FF           .byte $FF
$4E09  01 9F        ORA ($9F,X)
$4E0B  20 02 01     JSR $0102
$4E0E  9E           .byte $9E
$4E0F  0F           .byte $0F
$4E10  07           .byte $07
$4E11  01 9E        ORA ($9E,X)
$4E13  1B           .byte $1B
$4E14  0A           ASL
$4E15  01 9F        ORA ($9F,X)
$4E17  1C           .byte $1C
$4E18  0A           ASL
$4E19  01 9E        ORA ($9E,X)
$4E1B  20 0A FF     JSR $FF0A
$4E1E  01 9F        ORA ($9F,X)
$4E20  01 04        ORA ($04,X)
$4E22  01 9F        ORA ($9F,X)
$4E24  1E 07 01     ASL $0107,X
$4E27  9F           .byte $9F
$4E28  1E 0A FF     ASL $FF0A,X
$4E2B  01 9E        ORA ($9E,X)
$4E2D  12           .byte $12
$4E2E  03           .byte $03
$4E2F  01 9F        ORA ($9F,X)
$4E31  15 03        ORA $03,X ; room_subtype
$4E33  01 9F        ORA ($9F,X)
$4E35  07           .byte $07
$4E36  0A           ASL
$4E37  FF           .byte $FF
$4E38  01 9E        ORA ($9E,X)
$4E3A  24 04        BIT $04 ; screen_ptr_lo
$4E3C  01 9E        ORA ($9E,X)
$4E3E  24 07        BIT $07 ; data_ptr_hi
$4E40  01 9E        ORA ($9E,X)
$4E42  24 0A        BIT $0A
$4E44  FF           .byte $FF
$4E45  01 00        ORA ($00,X)
$4E47  00           BRK
$4E48  00           BRK
$4E49  FF           .byte $FF
$4E4A  01 9F        ORA ($9F,X)
$4E4C  09 07        ORA #$07
$4E4E  01 9E        ORA ($9E,X)
$4E50  1E 07 01     ASL $0107,X
$4E53  9F           .byte $9F
$4E54  09 0A        ORA #$0A
$4E56  01 9E        ORA ($9E,X)
$4E58  1E 0A FF     ASL $FF0A,X
$4E5B  01 9F        ORA ($9F,X)
$4E5D  13           .byte $13
$4E5E  03           .byte $03
$4E5F  01 9E        ORA ($9E,X)
$4E61  15 03        ORA $03,X ; room_subtype
$4E63  01 9E        ORA ($9E,X)
$4E65  0E 04 01     ASL $0104
$4E68  9F           .byte $9F
$4E69  1A           .byte $1A
$4E6A  04           .byte $04
$4E6B  01 9E        ORA ($9E,X)
$4E6D  0D 06 01     ORA $0106
$4E70  9F           .byte $9F
$4E71  1B           .byte $1B
$4E72  06 FF        ASL $FF
$4E74  01 9E        ORA ($9E,X)
$4E76  20 04 01     JSR $0104
$4E79  9F           .byte $9F
$4E7A  05 07        ORA $07 ; data_ptr_hi
$4E7C  FF           .byte $FF
$4E7D  01 9E        ORA ($9E,X)
$4E7F  26 0A        ROL $0A
$4E81  01 9E        ORA ($9E,X)
$4E83  1F           .byte $1F
$4E84  0B           .byte $0B
$4E85  FF           .byte $FF
$4E86  01 9E        ORA ($9E,X)
$4E88  25 0B        AND $0B
$4E8A  FF           .byte $FF
$4E8B  01 00        ORA ($00,X)
$4E8D  00           BRK
$4E8E  00           BRK
$4E8F  FF           .byte $FF
$4E90  01 00        ORA ($00,X)
$4E92  00           BRK
$4E93  00           BRK
$4E94  FF           .byte $FF
$4E95  05 05        ORA $05 ; screen_ptr_hi
$4E97  00           BRK
$4E98  00           BRK
$4E99  00           BRK
$4E9A  00           BRK
$4E9B  00           BRK
$4E9C  F4           .byte $F4
$4E9D  33           .byte $33
$4E9E  F5 33        SBC $33,X
$4EA0  F4           .byte $F4
$4EA1  33           .byte $33
$4EA2  FB           .byte $FB
$4EA3  33           .byte $33
$4EA4  01 34        ORA ($34,X)
$4EA6  27           .byte $27
$4EA7  34           .byte $34
$4EA8  F4           .byte $F4
$4EA9  33           .byte $33
$4EAA  60           RTS
$4EAB  34           .byte $34
$4EAC  77           .byte $77
$4EAD  34           .byte $34
$4EAE  8E 34 F4     STX $F434
$4EB1  33           .byte $33
$4EB2  F4           .byte $F4
$4EB3  33           .byte $33
$4EB4  BC 34 C2     LDY $C234,X
$4EB7  34           .byte $34
$4EB8  8C 35 92     STY $9235
$4EBB  35 9E        AND $9E,X
$4EBD  35 C3        AND $C3,X
$4EBF  35 F9        AND $F9,X
$4EC1  35 5E        AND $5E,X
$4EC3  42           .byte $42
$4EC4  41 36        EOR ($36,X)
$4EC6  78           SEI
$4EC7  36 A5        ROL $A5,X
$4EC9  36 01        ROL $01,X ; CPU_PORT
$4ECB  37           .byte $37
$4ECC  5F           .byte $5F
$4ECD  37           .byte $37
$4ECE  AA           TAX
$4ECF  38           SEC
$4ED0  A9 39        LDA #$39
$4ED2  C2           .byte $C2
$4ED3  39 D3 3A     AND $3AD3,Y
$4ED6  B1 3B        LDA ($3B),Y
$4ED8  8F           .byte $8F
$4ED9  3C           .byte $3C
$4EDA  BF           .byte $BF
$4EDB  3C           .byte $3C
$4EDC  4B           .byte $4B
$4EDD  3E           .byte $3E
$4EDE  7B           .byte $7B
$4EDF  3E           .byte $3E
$4EE0  CB           .byte $CB
$4EE1  3E           .byte $3E
$4EE2  E5 3E        SBC $3E
$4EE4  5A           .byte $5A
$4EE5  3F           .byte $3F
$4EE6  70 3F        BVS $4F27
$4EE8  DB           .byte $DB
$4EE9  3C           .byte $3C
$4EEA  71 42        ADC ($42),Y
$4EEC  4C 00 01     JMP $0100
$4EEF  00           BRK
$4EF0  00           BRK
$4EF1  00           BRK
$4EF2  05 00        ORA $00
$4EF4  00           BRK
$4EF5  08           PHP
$4EF6  00           BRK
$4EF7  0A           ASL
$4EF8  00           BRK
$4EF9  00           BRK
$4EFA  00           BRK
$4EFB  00           BRK
$4EFC  00           BRK
$4EFD  00           BRK
$4EFE  00           BRK
$4EFF  00           BRK
$4F00  00           BRK
$4F01  00           BRK
$4F02  00           BRK
$4F03  00           BRK
$4F04  00           BRK
$4F05  01 00        ORA ($00,X)
$4F07  00           BRK
$4F08  04           .byte $04
$4F09  00           BRK
$4F0A  00           BRK
$4F0B  00           BRK
$4F0C  00           BRK
$4F0D  00           BRK
$4F0E  00           BRK
$4F0F  00           BRK
$4F10  00           BRK
$4F11  00           BRK
$4F12  00           BRK
$4F13  00           BRK
$4F14  00           BRK
$4F15  00           BRK
$4F16  00           BRK
$4F17  00           BRK
$4F18  00           BRK
$4F19  00           BRK
$4F1A  00           BRK
$4F1B  00           BRK
$4F1C  00           BRK
$4F1D  00           BRK
$4F1E  00           BRK
$4F1F  04           .byte $04
$4F20  05 00        ORA $00
$4F22  00           BRK
$4F23  00           BRK
$4F24  00           BRK
$4F25  00           BRK
$4F26  00           BRK
$4F27  00           BRK
$4F28  00           BRK
$4F29  00           BRK
$4F2A  00           BRK
$4F2B  00           BRK
$4F2C  00           BRK
$4F2D  00           BRK
$4F2E  00           BRK
$4F2F  00           BRK
$4F30  00           BRK
$4F31  00           BRK
$4F32  00           BRK
$4F33  00           BRK
$4F34  00           BRK
$4F35  00           BRK
$4F36  00           BRK
$4F37  00           BRK
$4F38  16 1C        ASL $1C,X
$4F3A  20 00 00     JSR $0000
$4F3D  00           BRK
$4F3E  00           BRK
$4F3F  00           BRK
$4F40  00           BRK
$4F41  00           BRK
$4F42  01 01        ORA ($01,X)
$4F44  02           .byte $02
$4F45  02           .byte $02
$4F46  02           .byte $02
$4F47  02           .byte $02
$4F48  00           BRK
$4F49  02           .byte $02
$4F4A  12           .byte $12
$4F4B  01 03        ORA ($03,X)
$4F4D  13           .byte $13
$4F4E  00           BRK
$4F4F  48           PHA
$4F50  9E           .byte $9E
$4F51  01 49        ORA ($49,X)
$4F53  9F           .byte $9F
$4F54  3E           .byte $3E
$4F55  02           .byte $02
$4F56  02           .byte $02
$4F57  00           BRK
$4F58  00           BRK
$4F59  00           BRK
$4F5A  00           BRK
$4F5B  00           BRK
$4F5C  00           BRK
$4F5D  00           BRK
$4F5E  00           BRK
$4F5F  00           BRK
$4F60  00           BRK
$4F61  00           BRK
$4F62  02           .byte $02
$4F63  00           BRK
$4F64  01 00        ORA ($00,X)
$4F66  00           BRK
$4F67  00           BRK
$4F68  00           BRK
$4F69  00           BRK
$4F6A  00           BRK
$4F6B  00           BRK
$4F6C  02           .byte $02
$4F6D  01 01        ORA ($01,X)
$4F6F  00           BRK
$4F70  01 00        ORA ($00,X)
$4F72  00           BRK
$4F73  00           BRK
$4F74  00           BRK
$4F75  00           BRK
$4F76  00           BRK
$4F77  00           BRK
$4F78  02           .byte $02
$4F79  01 01        ORA ($01,X)
$4F7B  00           BRK
$4F7C  01 00        ORA ($00,X)
$4F7E  00           BRK
$4F7F  00           BRK
$4F80  00           BRK
$4F81  00           BRK
$4F82  00           BRK
$4F83  00           BRK
$4F84  02           .byte $02
$4F85  01 01        ORA ($01,X)
$4F87  00           BRK
$4F88  00           BRK
$4F89  00           BRK
$4F8A  00           BRK
$4F8B  00           BRK
$4F8C  00           BRK
$4F8D  00           BRK
$4F8E  00           BRK
$4F8F  00           BRK
$4F90  02           .byte $02
$4F91  02           .byte $02
$4F92  01 00        ORA ($00,X)
$4F94  00           BRK
$4F95  00           BRK
$4F96  00           BRK
$4F97  00           BRK
$4F98  00           BRK
$4F99  00           BRK
$4F9A  00           BRK
$4F9B  00           BRK
$4F9C  02           .byte $02
$4F9D  02           .byte $02
$4F9E  01 00        ORA ($00,X)
$4FA0  00           BRK
$4FA1  00           BRK
$4FA2  00           BRK
$4FA3  00           BRK
$4FA4  00           BRK
$4FA5  00           BRK
$4FA6  00           BRK
$4FA7  00           BRK
$4FA8  02           .byte $02
$4FA9  02           .byte $02
$4FAA  01 00        ORA ($00,X)
$4FAC  00           BRK
$4FAD  00           BRK
$4FAE  00           BRK
$4FAF  00           BRK
$4FB0  00           BRK
$4FB1  00           BRK
$4FB2  00           BRK
$4FB3  00           BRK
$4FB4  02           .byte $02
$4FB5  02           .byte $02
$4FB6  01 00        ORA ($00,X)
$4FB8  00           BRK
$4FB9  00           BRK
$4FBA  00           BRK
$4FBB  00           BRK
$4FBC  00           BRK
$4FBD  00           BRK
$4FBE  00           BRK
$4FBF  00           BRK
$4FC0  02           .byte $02
$4FC1  02           .byte $02
$4FC2  01 00        ORA ($00,X)
$4FC4  00           BRK
$4FC5  00           BRK
$4FC6  00           BRK
$4FC7  00           BRK
$4FC8  00           BRK
$4FC9  00           BRK
$4FCA  00           BRK
$4FCB  00           BRK
$4FCC  02           .byte $02
$4FCD  02           .byte $02
$4FCE  01 00        ORA ($00,X)
$4FD0  00           BRK
$4FD1  00           BRK
$4FD2  00           BRK
$4FD3  00           BRK
$4FD4  00           BRK
$4FD5  00           BRK
$4FD6  00           BRK
$4FD7  00           BRK
$4FD8  02           .byte $02
$4FD9  02           .byte $02
$4FDA  01 01        ORA ($01,X)
$4FDC  01 01        ORA ($01,X)
$4FDE  00           BRK
$4FDF  00           BRK
$4FE0  00           BRK
$4FE1  00           BRK
$4FE2  00           BRK
$4FE3  00           BRK
$4FE4  00           BRK
$4FE5  00           BRK
$4FE6  00           BRK
$4FE7  00           BRK
$4FE8  00           BRK
$4FE9  00           BRK
$4FEA  00           BRK
$4FEB  00           BRK
$4FEC  00           BRK
$4FED  00           BRK
$4FEE  00           BRK
$4FEF  00           BRK
$4FF0  00           BRK
$4FF1  00           BRK
$4FF2  00           BRK
$4FF3  00           BRK
$4FF4  00           BRK
$4FF5  00           BRK
$4FF6  00           BRK
$4FF7  00           BRK
$4FF8  00           BRK
$4FF9  00           BRK
$4FFA  00           BRK
$4FFB  00           BRK
$4FFC  00           BRK
$4FFD  00           BRK
$4FFE  00           BRK
$4FFF  00           BRK
$5000  00           BRK
$5001  00           BRK
$5002  00           BRK
$5003  00           BRK
$5004  00           BRK
$5005  00           BRK
$5006  00           BRK
$5007  00           BRK
$5008  00           BRK
$5009  00           BRK
$500A  00           BRK
$500B  00           BRK
$500C  00           BRK
$500D  00           BRK
$500E  00           BRK
$500F  00           BRK
$5010  00           BRK
$5011  00           BRK
$5012  00           BRK
$5013  00           BRK
$5014  00           BRK
$5015  00           BRK
$5016  00           BRK
$5017  00           BRK
$5018  00           BRK
$5019  00           BRK
$501A  00           BRK
$501B  00           BRK
$501C  00           BRK
$501D  00           BRK
$501E  00           BRK
$501F  00           BRK
$5020  00           BRK
$5021  00           BRK
$5022  00           BRK
$5023  00           BRK
$5024  00           BRK
$5025  00           BRK
$5026  00           BRK
$5027  00           BRK
$5028  00           BRK
$5029  00           BRK
$502A  00           BRK
$502B  00           BRK
$502C  00           BRK
$502D  00           BRK
$502E  00           BRK
$502F  00           BRK
$5030  00           BRK
$5031  00           BRK
$5032  00           BRK
$5033  00           BRK
$5034  00           BRK
$5035  00           BRK
$5036  00           BRK
$5037  00           BRK
$5038  00           BRK
$5039  00           BRK
$503A  00           BRK
$503B  00           BRK
$503C  00           BRK
$503D  00           BRK
$503E  00           BRK
$503F  00           BRK
$5040  00           BRK
$5041  00           BRK
$5042  00           BRK
$5043  00           BRK
$5044  00           BRK
$5045  00           BRK
$5046  00           BRK
$5047  00           BRK
$5048  00           BRK
$5049  00           BRK
$504A  00           BRK
$504B  00           BRK
$504C  00           BRK
$504D  00           BRK
$504E  00           BRK
$504F  00           BRK
$5050  00           BRK
$5051  00           BRK
$5052  00           BRK
$5053  00           BRK
$5054  00           BRK
$5055  00           BRK
$5056  00           BRK
$5057  00           BRK
$5058  00           BRK
$5059  00           BRK
$505A  00           BRK
$505B  00           BRK
$505C  00           BRK
$505D  00           BRK
$505E  00           BRK
$505F  00           BRK
$5060  00           BRK
$5061  00           BRK
$5062  00           BRK
$5063  00           BRK
$5064  00           BRK
$5065  00           BRK
$5066  00           BRK
$5067  00           BRK
$5068  00           BRK
$5069  00           BRK
$506A  00           BRK
$506B  00           BRK
$506C  00           BRK
$506D  00           BRK
$506E  00           BRK
$506F  00           BRK
$5070  00           BRK
$5071  00           BRK
$5072  00           BRK
$5073  00           BRK
$5074  00           BRK
$5075  00           BRK
$5076  00           BRK
$5077  00           BRK
$5078  00           BRK
$5079  00           BRK
$507A  00           BRK
$507B  00           BRK
$507C  00           BRK
$507D  00           BRK
$507E  00           BRK
$507F  00           BRK
$5080  00           BRK
$5081  00           BRK
$5082  00           BRK
$5083  00           BRK
$5084  00           BRK
$5085  00           BRK
$5086  00           BRK
$5087  00           BRK
$5088  00           BRK
$5089  00           BRK
$508A  00           BRK
$508B  00           BRK
$508C  00           BRK
$508D  00           BRK
$508E  00           BRK
$508F  00           BRK
$5090  00           BRK
$5091  00           BRK
$5092  00           BRK
$5093  00           BRK
$5094  00           BRK
$5095  00           BRK
$5096  00           BRK
$5097  00           BRK
$5098  00           BRK
$5099  00           BRK
$509A  00           BRK
$509B  00           BRK
$509C  00           BRK
$509D  00           BRK
$509E  00           BRK
$509F  00           BRK
$50A0  00           BRK
$50A1  00           BRK
$50A2  00           BRK
$50A3  00           BRK
$50A4  00           BRK
$50A5  00           BRK
$50A6  00           BRK
$50A7  00           BRK
$50A8  00           BRK
$50A9  00           BRK
$50AA  00           BRK
$50AB  00           BRK
$50AC  00           BRK
$50AD  00           BRK
$50AE  00           BRK
$50AF  00           BRK
$50B0  00           BRK
$50B1  00           BRK
$50B2  00           BRK
$50B3  00           BRK
$50B4  00           BRK
$50B5  00           BRK
$50B6  00           BRK
$50B7  00           BRK
$50B8  00           BRK
$50B9  00           BRK
$50BA  00           BRK
$50BB  00           BRK
$50BC  00           BRK
$50BD  00           BRK
$50BE  00           BRK
$50BF  00           BRK
$50C0  00           BRK
$50C1  00           BRK
$50C2  00           BRK
$50C3  00           BRK
$50C4  00           BRK
$50C5  00           BRK
$50C6  00           BRK
$50C7  00           BRK
$50C8  00           BRK
$50C9  00           BRK
$50CA  00           BRK
$50CB  00           BRK
$50CC  00           BRK
$50CD  00           BRK
$50CE  00           BRK
$50CF  00           BRK
$50D0  00           BRK
$50D1  00           BRK
$50D2  00           BRK
$50D3  00           BRK
$50D4  00           BRK
$50D5  00           BRK
$50D6  00           BRK
$50D7  00           BRK
$50D8  00           BRK
$50D9  00           BRK
$50DA  00           BRK

; --- Subroutine at $50DB ---
$50DB  AD 11 D0     LDA $D011 ; VIC_CTRL1
$50DE  29 7F        AND #$7F
$50E0  09 10        ORA #$10
$50E2  8D 11 D0     STA $D011 ; VIC_CTRL1
$50E5  60           RTS
$50E6  00           BRK
$50E7  28           PLP
$50E8  50 78        BVC $5162
$50EA  A0 C8        LDY #$C8
$50EC  F0 18        BEQ $5106
$50EE  40           RTI
$50EF  68           PLA
$50F0  90 B8        BCC $50AA
$50F2  E0 08        CPX #$08
$50F4  30 58        BMI $514E
$50F6  80           .byte $80
$50F7  A8           TAY
$50F8  D0 F8        BNE $50F2
$50FA  20 48 70     JSR $7048
$50FD  98           TYA
$50FE  C0 8C        CPY #$8C
$5100  8C 8C 8C     STY $8C8C
$5103  8C 8C 8D     STY $8D8C
$5106  8D 8D 8D     STA $8D8D
$5109  8D 8D 8E     STA $8E8D
$510C  8E 8E 8E     STX $8E8E
$510F  8E 8E 8E     STX $8E8E
$5112  8F           .byte $8F
$5113  8F           .byte $8F
$5114  8F           .byte $8F
$5115  8F           .byte $8F
$5116  8F           .byte $8F
$5117  D8           CLD
$5118  D8           CLD
$5119  D8           CLD
$511A  D8           CLD
$511B  D8           CLD
$511C  D8           CLD
$511D  D9 D9 D9     CMP $D9D9,Y
$5120  D9 D9 D9     CMP $D9D9,Y
$5123  DA           .byte $DA
$5124  DA           .byte $DA
$5125  DA           .byte $DA
$5126  DA           .byte $DA
$5127  DA           .byte $DA
$5128  DA           .byte $DA
$5129  DA           .byte $DA
$512A  DB           .byte $DB
$512B  DB           .byte $DB
$512C  DB           .byte $DB
$512D  DB           .byte $DB
$512E  DB           .byte $DB

; --- Subroutine at $512F ---
$512F  AD 8F CF     LDA $CF8F
$5132  C9 B9        CMP #$B9
$5134  D0 F9        BNE $512F
$5136  4D AF CF     EOR $CFAF
$5139  D0 F4        BNE $512F
$513B  A2 D1        LDX #$D1

; --- Subroutine at $513D ---
$513D  86 51        STX $51
$513F  BD 39 12     LDA $1239,X
$5142  F0 06        BEQ $514A
$5144  20 7E 51     JSR $517E
$5147  4C 54 51     JMP $5154
$514A  A0 5F        LDY #$5F
$514C  A9 00        LDA #$00
$514E  99 E0 CA     STA $CAE0,Y
$5151  88           DEY
$5152  10 FA        BPL $514E

; --- Subroutine at $5154 ---
$5154  C6 51        DEC $51
$5156  A6 51        LDX $51
$5158  20 7E 51     JSR $517E
$515B  A6 51        LDX $51
$515D  BD 67 11     LDA $1167,X
$5160  85 06        STA $06 ; data_ptr_lo
$5162  BD 39 12     LDA $1239,X
$5165  85 07        STA $07 ; data_ptr_hi
$5167  A0 5F        LDY #$5F
$5169  B1 06        LDA ($06),Y
$516B  19 E0 CA     ORA $CAE0,Y
$516E  91 06        STA ($06),Y
$5170  88           DEY
$5171  10 F6        BPL $5169
$5173  CA           DEX
$5174  E0 FF        CPX #$FF
$5176  F0 03        BEQ $517B
$5178  4C 3D 51     JMP $513D
$517B  60           RTS
$517C  60           RTS
$517D  60           RTS

; --- Subroutine at $517E ---
$517E  BD BD 59     LDA $59BD,X
$5181  85 04        STA $04 ; screen_ptr_lo
$5183  BD 8F 5A     LDA $5A8F,X
$5186  85 05        STA $05 ; screen_ptr_hi
$5188  BC 61 5B     LDY $5B61,X
$518B  C8           INY
$518C  84 1D        STY $1D
$518E  BD 39 12     LDA $1239,X
$5191  85 07        STA $07 ; data_ptr_hi
$5193  BD 67 11     LDA $1167,X
$5196  85 06        STA $06 ; data_ptr_lo
$5198  18           CLC
$5199  69 20        ADC #$20
$519B  85 08        STA $08 ; color_ptr_lo
$519D  A5 07        LDA $07 ; data_ptr_hi
$519F  69 00        ADC #$00
$51A1  85 09        STA $09 ; color_ptr_hi
$51A3  A5 06        LDA $06 ; data_ptr_lo
$51A5  18           CLC
$51A6  69 40        ADC #$40
$51A8  85 0A        STA $0A
$51AA  A5 07        LDA $07 ; data_ptr_hi
$51AC  69 00        ADC #$00
$51AE  85 0B        STA $0B
$51B0  A0 00        LDY #$00
$51B2  BD BF 5C     LDA $5CBF,X
$51B5  D0 23        BNE $51DA
$51B7  B1 04        LDA ($04),Y
$51B9  85 1F        STA $1F
$51BB  20 FF 51     JSR $51FF
$51BE  91 08        STA ($08),Y
$51C0  20 FF 51     JSR $51FF
$51C3  91 06        STA ($06),Y
$51C5  A9 00        LDA #$00
$51C7  91 0A        STA ($0A),Y
$51C9  C8           INY
$51CA  C4 1D        CPY $1D
$51CC  90 E9        BCC $51B7
$51CE  91 06        STA ($06),Y
$51D0  91 08        STA ($08),Y
$51D2  91 0A        STA ($0A),Y
$51D4  C8           INY
$51D5  C0 20        CPY #$20
$51D7  90 F5        BCC $51CE
$51D9  60           RTS
$51DA  B1 04        LDA ($04),Y
$51DC  85 1F        STA $1F
$51DE  20 FF 51     JSR $51FF
$51E1  91 08        STA ($08),Y
$51E3  20 FF 51     JSR $51FF
$51E6  91 06        STA ($06),Y
$51E8  20 86 47     JSR $4786
$51EB  B1 04        LDA ($04),Y
$51ED  4A           LSR
$51EE  4A           LSR
$51EF  4A           LSR
$51F0  4A           LSR
$51F1  20 FF 51     JSR $51FF
$51F4  91 0A        STA ($0A),Y
$51F6  C8           INY
$51F7  C4 1D        CPY $1D
$51F9  90 DF        BCC $51DA
$51FB  A9 00        LDA #$00
$51FD  F0 CF        BEQ $51CE

; --- Subroutine at $51FF ---
$51FF  A2 03        LDX #$03