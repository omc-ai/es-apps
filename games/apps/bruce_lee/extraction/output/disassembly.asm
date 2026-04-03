; Bruce Lee (C64) - Full Disassembly (correctly decompressed)
; From: Bruce Lee.d64 (cracktro +2 version)
; Stage 1 entry: $2800, Stage 2 entry: $0802
; Charset at $2000 (multicolor), sprites throughout memory


; ============================================================
; GAME CODE $0800-$0FFF
; ============================================================

$0800  5C           .byte $5C ; illegal
$0801  AD AD AD     LDA $ADAD
$0804  00           BRK
$0805  00           BRK
$0806  D0 AD        BNE $07B5
$0808  AD D0 AD     LDA $ADD0
$080B  00           BRK
$080C  00           BRK
$080D  78           SEI
$080E  A2 FF        LDX #$FF
$0810  9A           TXS
$0811  A2 49        LDX #$49
$0813  BD 1E 08     LDA $081E,X
$0816  95 00        STA $00,X
$0818  65 A9        ADC $A9
$081A  F8           SED
$081B  A0 F5        LDY #$F5
$081D  4C 35 00     JMP
$0820  E8           INX
$0821  65 0F        ADC $0F
$0823  C9 D6        CMP #$D6
$0825  65 0F        ADC $0F
$0827  65 65        ADC $65
$0829  65 65        ADC $65
$082B  30 BE        BMI $07EB
$082D  00           BRK
$082E  53           .byte $53 ; illegal
$082F  65 BE        ADC $BE
$0831  02           .byte $02 ; illegal
$0832  65 30        ADC $30
$0834  B1 0F        LDA ($0F),Y
$0836  8D 00 08     STA $0800
$0839  E6 19        INC $19
$083B  A9 04        LDA #$04
$083D  E6 1A        INC $1A
$083F  F0 00        BEQ $0841
$0841  0F           .byte $0F ; illegal
$0842  A9 F2        LDA #$F2
$0844  C8           INY
$0845  BE D9 30     LDX $30D9,Y
$0848  30 BE        BMI $0808
$084A  D5 38        CMP $38,X
$084C  00           BRK
$084D  38           SEC
$084E  00           BRK
$084F  58           CLI
$0850  4C 40 C5     JMP
$0853  BD 73 B3     LDA $B373,X
$0856  4D 40 FF     EOR $FF40
$0859  4D 00 F7     EOR $F700
$085C  C6 3A        DEC $3A
$085E  C6 37        DEC $37
$0860  A5 37        LDA $37
$0862  D0 3A        BNE $089E
$0864  D0 ED        BNE $0853
$0866  F0 B8        BEQ $0820
$0868  D6 21        DEC $21,X
$086A  21 10        AND ($10,X)
$086C  91 65        STA ($65),Y
$086E  65 65        ADC $65
$0870  65 90        ADC $90
$0872  60           RTS
$0873  4D 4D 30     EOR $304D
$0876  2E 65 FA     ROL $FA65
$0879  B0 1B        BCS $0896
$087B  BD 38 38     LDA $3838,X
$087E  20 4C 70     JSR
$0881  70           .byte $70 ; illegal
$0882  70           .byte $70 ; illegal
$0883  5B           .byte $5B ; illegal
$0884  5B           .byte $5B ; illegal
$0885  5B           .byte $5B ; illegal
$0886  5B           .byte $5B ; illegal
$0887  91 91        STA ($91),Y
$0889  91 91        STA ($91),Y
$088B  65 65        ADC $65
$088D  65 65        ADC $65
$088F  48           PHA
$0890  90 90        BCC $0822
$0892  90 90        BCC $0824
$0894  4C B1 08     JMP
$0897  04           .byte $04 ; illegal
$0898  04           .byte $04 ; illegal
$0899  02           .byte $02 ; illegal
$089A  7D 7D FA     ADC $FA7D,X
$089D  58           CLI
$089E  90 58        BCC $08F8
$08A0  90 38        BCC $08DA
$08A2  00           BRK
$08A3  65 7D        ADC $7D
$08A5  00           BRK
$08A6  7D 00 A9     ADC $A900,X
$08A9  B0 B0        BCS $085B
$08AB  38           SEC
$08AC  38           SEC
$08AD  38           SEC
$08AE  38           SEC
$08AF  49 EF        EOR #$EF
$08B1  4D 05 48     EOR $4805
$08B4  D0 DA        BNE $0890
$08B6  AD 00 00     LDA $0000
$08B9  1F           .byte $1F ; illegal
$08BA  AD 38 00     LDA $0038
$08BD  10 F0        BPL $08AF
$08BF  F6 60        INC $60,X
$08C1  C9 2A        CMP #$2A
$08C3  F0 0F        BEQ $08D4
$08C5  C9 AA        CMP #$AA
$08C7  F0 1B        BEQ $08E4
$08C9  C9 11        CMP #$11
$08CB  F0 26        BEQ $08F3
$08CD  C9 91        CMP #$91
$08CF  F0 32        BEQ $0903
$08D1  4C D2 30     JMP
$08D4  4D 30 00     EOR $0030
$08D7  2E 65 CA     ROL $CA65
$08DA  00           BRK
$08DB  2E 65 EF     ROL $EF65
$08DE  65 AD        ADC $AD
$08E0  4D 4D F0     EOR $F04D
$08E3  2D EF 01     AND $01EF
$08E6  AD 90 CA     LDA $CA90
$08E9  00           BRK
$08EA  2E 65 EF     ROL $EF65
$08ED  4D AD 4D     EOR $4DAD
$08F0  13           .byte $13 ; illegal
$08F1  F0 1E        BEQ $0911
$08F3  58           CLI
$08F4  90 38        BCC $092E
$08F6  EF           .byte $EF ; illegal
$08F7  4D EF 4D     EOR $4DEF
$08FA  EF           .byte $EF ; illegal
$08FB  4D EF 4D     EOR $4DEF
$08FE  EF           .byte $EF ; illegal
$08FF  4D 4D 95     EOR $954D
$0902  0E A9 0D     ASL $0DA9
$0905  00           BRK
$0906  00           BRK
$0907  38           SEC
$0908  00           BRK
$0909  38           SEC
$090A  00           BRK
$090B  17           .byte $17 ; illegal
$090C  AD AD EF     LDA $EFAD
$090F  84 13        STY $13
$0911  4C 16 90     JMP
$0914  90 BD        BCC $08D3
$0916  40           RTI
$0917  40           RTI
$0918  C5 C5        CMP $C5
$091A  40           RTI
$091B  40           RTI
$091C  01 01        ORA ($01,X)
$091E  00           BRK
$091F  00           BRK
$0920  01 01        ORA ($01,X)
$0922  00           BRK
$0923  00           BRK
$0924  F1 60        SBC ($60),Y
$0926  D3           .byte $D3 ; illegal
$0927  D3           .byte $D3 ; illegal
$0928  D3           .byte $D3 ; illegal
$0929  D3           .byte $D3 ; illegal
$092A  38           SEC
$092B  0A           ASL A
$092C  0A           ASL A
$092D  0A           ASL A
$092E  0A           ASL A
$092F  90 68        BCC $0999
$0931  90 29        BCC $095C
$0933  1F           .byte $1F ; illegal
$0934  85 47        STA $47
$0936  AD AD AD     LDA $ADAD
$0939  AD 90 0E     LDA $0E90
$093C  0E 8D 38     ASL $388D
$093F  38           SEC
$0940  38           SEC
$0941  8C D0 04     STY $04D0
$0944  7D 98 68     ADC $6898,X
$0947  8C A0 47     STY $47A0
$094A  A2 00        LDX #$00
$094C  40           RTI
$094D  0D 00 A9     ORA $A900
$0950  22           .byte $22 ; illegal
$0951  00           BRK
$0952  46 00        LSR $00
$0954  00           BRK
$0955  47           .byte $47 ; illegal
$0956  00           BRK
$0957  00           BRK
$0958  49 00        EOR #$00
$095A  F1 0A        SBC ($0A),Y
$095C  8A           TXA
$095D  0A           ASL A
$095E  20 01 AD     JSR
$0961  90 29        BCC $098C
$0963  2B           .byte $2B ; illegal
$0964  2B           .byte $2B ; illegal
$0965  D0 12        BNE $0979
$0967  A0 36        LDY #$36
$0969  05 38        ORA $38
$096B  05 30        ORA $30
$096D  02           .byte $02 ; illegal
$096E  0A           ASL A
$096F  A0 13        LDY #$13
$0971  30 30        BMI $09A3
$0973  B0 A2        BCS $0917
$0975  0D 8A 0A     ORA $0A8A
$0978  17           .byte $17 ; illegal
$0979  98           TYA
$097A  68           PLA
$097B  38           SEC
$097C  65 30        ADC $30
$097E  4D 4D 4D     EOR $4D4D
$0981  30 F0        BMI $0973
$0983  11 5E        ORA ($5E),Y
$0985  00           BRK
$0986  30 A9        BMI $0931
$0988  07           .byte $07 ; illegal
$0989  40           RTI
$098A  40           RTI
$098B  8D 8D 31     STA $318D
$098E  A9 D0        LDA #$D0
$0990  00           BRK
$0991  8D 8D 8D     STA $8D8D
$0994  8D A9 00     STA $00A9
$0997  A0 83        LDY #$83
$0999  D0 D0        BNE $096B
$099B  D0 30        BNE $09CD
$099D  D2           .byte $D2 ; illegal
$099E  FA           .byte $FA ; illegal
$099F  E0 87        CPX #$87
$09A1  E0 88        CPX #$88
$09A3  E0 10        CPX #$10
$09A5  4C 17 4C     JMP
$09A8  17           .byte $17 ; illegal
$09A9  00           BRK
$09AA  99 99 8C     STA $8C99,Y
$09AD  8C 4C 0A     STY $0A4C
$09B0  7A           .byte $7A ; illegal
$09B1  68           PLA
$09B2  68           PLA
$09B3  04           .byte $04 ; illegal
$09B4  89           .byte $89 ; illegal
$09B5  85 8A        STA $8A
$09B7  0A           ASL A
$09B8  38           SEC
$09B9  BD 0B 68     LDA $680B,X
$09BC  B5 5D        LDA $5D,X
$09BE  BD 47 B5     LDA $B547,X
$09C1  B5 9B        LDA $9B,X
$09C3  A5 40        LDA $40
$09C5  F0 06        BEQ $09CD
$09C7  04           .byte $04 ; illegal
$09C8  04           .byte $04 ; illegal
$09C9  04           .byte $04 ; illegal
$09CA  3A           .byte $3A ; illegal
$09CB  30 B5        BMI $0982
$09CD  B5 30        LDA $30,X
$09CF  30 B5        BMI $0986
$09D1  B5 19        LDA $19,X
$09D3  30 05        BMI $09DA
$09D5  5E 8C 8C     LSR $8C8C,X
$09D8  44           .byte $44 ; illegal
$09D9  00           BRK
$09DA  07           .byte $07 ; illegal
$09DB  30 05        BMI $09E2
$09DD  CE AD AD     DEC $ADAD
$09E0  90 DE        BCC $09C0
$09E2  68           PLA
$09E3  8D DF 4F     STA $4FDF
$09E6  8D E0 4F     STA $4FE0
$09E9  85 BF        STA $BF
$09EB  8D 00 00     STA $0000
$09EE  38           SEC
$09EF  A9 38        LDA #$38
$09F1  A9 00        LDA #$00
$09F3  A8           TAY
$09F4  68           PLA
$09F5  30 30        BMI $0A27
$09F7  BD A9 4A     LDA $4AA9,X
$09FA  30 07        BMI $0A03
$09FC  A0 13        LDY #$13
$09FE  30 30        BMI $0A30
$0A00  38           SEC
$0A01  A9 01        LDA #$01
$0A03  88           DEY
$0A04  D2           .byte $D2 ; illegal
$0A05  30 8C        BMI $0993
$0A07  38           SEC
$0A08  00           BRK
$0A09  B8           CLV
$0A0A  E0 0A        CPX #$0A
$0A0C  90 0A        BCC $0A18
$0A0E  E0 12        CPX #$12
$0A10  B5 B5        LDA $B5,X
$0A12  19 3A 02     ORA $023A,Y
$0A15  02           .byte $02 ; illegal
$0A16  90 3C        BCC $0A54
$0A18  05 F2        ORA $F2
$0A1A  BD 34 30     LDA $3034,X
$0A1D  05 06        ORA $06
$0A1F  BD 49 4B     LDA $4B49,X
$0A22  05 07        ORA $07
$0A24  8C 78 05     STY $0578
$0A27  04           .byte $04 ; illegal
$0A28  05 10        ORA $10
$0A2A  8C A0 05     STY $05A0
$0A2D  08           PHP
$0A2E  05 12        ORA $12
$0A30  8C 8C 90     STY $908C
$0A33  90 05        BCC $0A3A
$0A35  09 8C        ORA #$8C
$0A37  D8           CLD
$0A38  85 11        STA $11
$0A3A  7D 7D 8C     ADC $8C7D,X
$0A3D  30 85        BMI $09C4
$0A3F  F3           .byte $F3 ; illegal
$0A40  41 0E        EOR ($0E,X)
$0A42  0A           ASL A
$0A43  30 71        BMI $0AB6
$0A45  2C 30 7F     BIT $7F30
$0A48  F0 51        BEQ $0A9B
$0A4A  8A           TXA
$0A4B  1C           .byte $1C ; illegal
$0A4C  8A           TXA
$0A4D  1C           .byte $1C ; illegal
$0A4E  71           .byte $71 ; illegal
$0A4F  F0 71        BEQ $0AC2
$0A51  F0 71        BEQ $0AC4
$0A53  F0 71        BEQ $0AC6
$0A55  F0 D2        BEQ $0A29
$0A57  30 D2        BMI $0A2B
$0A59  30 D2        BMI $0A2D
$0A5B  30 D2        BMI $0A2F
$0A5D  30 FE        BMI $0A5D
$0A5F  30 00        BMI $0A61
$0A61  42           .byte $42 ; illegal
$0A62  F0 F0        BEQ $0A54
$0A64  F0 F0        BEQ $0A56
$0A66  BA           TSX
$0A67  BA           TSX
$0A68  BA           TSX
$0A69  BA           TSX
$0A6A  30 30        BMI $0A9C
$0A6C  30 30        BMI $0A9E
$0A6E  D0 DE        BNE $0A4E
$0A70  F0 D0        BEQ $0A42
$0A72  AA           TAX
$0A73  30 30        BMI $0AA5
$0A75  00           BRK
$0A76  B1 06        LDA ($06),Y
$0A78  00           BRK
$0A79  00           BRK
$0A7A  20 5F 0B     JSR
$0A7D  90 0A        BCC $0A89
$0A7F  0A           ASL A
$0A80  0A           ASL A
$0A81  0A           ASL A
$0A82  08           PHP
$0A83  F6 FB        INC $FB,X
$0A85  1E FE F6     ASL $F6FE,X
$0A88  FB           .byte $FB ; illegal
$0A89  DB           .byte $DB ; illegal
$0A8A  51 30        EOR ($30),Y
$0A8C  F6 58        INC $58,X
$0A8E  0B           .byte $0B ; illegal
$0A8F  F6 5B        INC $5B,X
$0A91  48           PHA
$0A92  CA           DEX
$0A93  D0 E1        BNE $0A76
$0A95  F6 FB        INC $FB,X
$0A97  00           BRK
$0A98  4C D7 0A     JMP
$0A9B  AD 6E 33     LDA $336E
$0A9E  AD 01 01     LDA $0101
$0AA1  AD AD 58     LDA $58AD
$0AA4  A5 47        LDA $47
$0AA6  26 B5        ROL $B5
$0AA8  B0 4C        BCS $0AF6
$0AAA  6F           .byte $6F ; illegal
$0AAB  3A           .byte $3A ; illegal
$0AAC  0F           .byte $0F ; illegal
$0AAD  0F           .byte $0F ; illegal
$0AAE  0F           .byte $0F ; illegal
$0AAF  0F           .byte $0F ; illegal
$0AB0  0F           .byte $0F ; illegal
$0AB1  0F           .byte $0F ; illegal
$0AB2  0F           .byte $0F ; illegal
$0AB3  0F           .byte $0F ; illegal
$0AB4  0F           .byte $0F ; illegal
$0AB5  0F           .byte $0F ; illegal
$0AB6  0F           .byte $0F ; illegal
$0AB7  0F           .byte $0F ; illegal
$0AB8  0F           .byte $0F ; illegal
$0AB9  0F           .byte $0F ; illegal
$0ABA  FB           .byte $FB ; illegal
$0ABB  00           BRK
$0ABC  BE 30 E6     LDX $E630,Y
$0ABF  11 60        ORA ($60),Y
$0AC1  E6 12        INC $12
$0AC3  E0 02        CPX #$02
$0AC5  E6 13        INC $13
$0AC7  60           RTS
$0AC8  48           PHA
$0AC9  A9 F8        LDA #$F8
$0ACB  91 10        STA ($10),Y
$0ACD  91 12        STA ($12),Y
$0ACF  68           PLA
$0AD0  29 7F        AND #$7F
$0AD2  B5 04        LDA $04,X
$0AD4  80           .byte $80 ; illegal
$0AD5  0B           .byte $0B ; illegal
$0AD6  A2 03        LDX #$03
$0AD8  A9 86        LDA #$86
$0ADA  91 04        STA ($04),Y
$0ADC  0E 0E 0B     ASL $0B0E
$0ADF  0E 0E 01     ASL $010E
$0AE2  8C 8C 85     STY $858C
$0AE5  4C 4C 87     JMP
$0AE8  0B           .byte $0B ; illegal
$0AE9  85 54        STA $54
$0AEB  86 55        STX $55
$0AED  84 56        STY $56
$0AEF  60           RTS
$0AF0  A4 56        LDY $56
$0AF2  A6 55        LDX $55
$0AF4  A5 54        LDA $54
$0AF6  60           RTS
$0AF7  09 00        ORA #$00
$0AF9  09 18        ORA #$18
$0AFB  00           BRK
$0AFC  AA           TAX
$0AFD  00           BRK
$0AFE  18           CLC
$0AFF  00           BRK
$0B00  00           BRK
$0B01  84 B8        STY $B8
$0B03  B9 A8 B8     LDA $B8A8,Y
$0B06  95 EC        STA $EC,X
$0B08  96 82        STX $82,Y
$0B0A  8D B8 70     STA $70B8
$0B0D  B9 AB 59     LDA $59AB,Y
$0B10  95 EF        STA $EF,X
$0B12  B8           CLV
$0B13  03           .byte $03 ; illegal
$0B14  20 21 0E     JSR
$0B17  70           .byte $70 ; illegal
$0B18  70           .byte $70 ; illegal
$0B19  70           .byte $70 ; illegal
$0B1A  0D 10 D1     ORA $D110
$0B1D  10 30        BPL $0B4F
$0B1F  F8           SED
$0B20  00           BRK
$0B21  00           BRK
$0B22  F8           SED
$0B23  F8           SED
$0B24  80           .byte $80 ; illegal
$0B25  19 58 11     ORA $1158,Y
$0B28  09 9B        ORA #$9B
$0B2A  8D B8 3A     STA $3AB8
$0B2D  B6 07        LDX $07,Y
$0B2F  07           .byte $07 ; illegal
$0B30  3A           .byte $3A ; illegal
$0B31  3A           .byte $3A ; illegal
$0B32  00           BRK
$0B33  02           .byte $02 ; illegal
$0B34  B5 B5        LDA $B5,X
$0B36  1B           .byte $1B ; illegal
$0B37  B5 26        LDA $26,X
$0B39  B5 09        LDA $09,X
$0B3B  03           .byte $03 ; illegal
$0B3C  04           .byte $04 ; illegal
$0B3D  04           .byte $04 ; illegal
$0B3E  04           .byte $04 ; illegal
$0B3F  04           .byte $04 ; illegal
$0B40  04           .byte $04 ; illegal
$0B41  4F           .byte $4F ; illegal
$0B42  A9 24        LDA #$24
$0B44  B8           CLV
$0B45  04           .byte $04 ; illegal
$0B46  86 51        STX $51
$0B48  38           SEC
$0B49  E0 02        CPX #$02
$0B4B  F0 03        BEQ $0B50
$0B4D  B8           CLV
$0B4E  D0 13        BNE $0B63
$0B50  B8           CLV
$0B51  B8           CLV
$0B52  BD 00 00     LDA $0000,X
$0B55  00           BRK
$0B56  00           BRK
$0B57  00           BRK
$0B58  00           BRK
$0B59  A6 51        LDX $51
$0B5B  D4           .byte $D4 ; illegal
$0B5C  00           BRK
$0B5D  D4           .byte $D4 ; illegal
$0B5E  00           BRK
$0B5F  A1 4C        LDA ($4C,X)
$0B61  4D 0C B5     EOR $B50C
$0B64  8A           TXA
$0B65  D0 41        BNE $0BA8
$0B67  B5 B5        LDA $B5,X
$0B69  D0 28        BNE $0B93
$0B6B  B8           CLV
$0B6C  B8           CLV
$0B6D  BD B8 B8     LDA $B8B8,X
$0B70  F0 0E        BEQ $0B80
$0B72  E0 82        CPX #$82
$0B74  82           .byte $82 ; illegal
$0B75  B8           CLV
$0B76  B8           CLV
$0B77  B0 07        BCS $0B80
$0B79  B8           CLV
$0B7A  8D B8 10     STA $10B8
$0B7D  D2           .byte $D2 ; illegal
$0B7E  30 07        BMI $0B87
$0B80  8D B8 04     STA $04B8
$0B83  D0 04        BNE $0B89
$0B85  3A           .byte $3A ; illegal
$0B86  C9 B8        CMP #$B8
$0B88  B8           CLV
$0B89  BD EA 4B     LDA $4BEA,X
$0B8C  A8           TAY
$0B8D  05 8D        ORA $8D
$0B8F  05 D6        ORA $D6
$0B91  4B           .byte $4B ; illegal
$0B92  4C F0 0B     JMP
$0B95  B5 B5        LDA $B5,X
$0B97  BD 33 13     LDA $1333,X
$0B9A  F0 E6        BEQ $0B82
$0B9C  04           .byte $04 ; illegal
$0B9D  04           .byte $04 ; illegal
$0B9E  04           .byte $04 ; illegal
$0B9F  C9 C0        CMP #$C0
$0BA1  B0 DF        BCS $0B82
$0BA3  BD 6F 13     LDA $136F,X
$0BA6  10 AA        BPL $0B52
$0BA8  30 DF        BMI $0B89
$0BAA  D0 9E        BNE $0B4A
$0BAC  B5 8C        LDA $8C,X
$0BAE  95 A1        STA $A1,X
$0BB0  B5 8E        LDA $8E,X
$0BB2  D0 04        BNE $0BB8
$0BB4  AE 00 95     LDX $9500
$0BB7  8A           TXA
$0BB8  BD B8 A2     LDA $A2B8,X
$0BBB  69 69        ADC #$69
$0BBD  A1 A1        LDA ($A1,X)
$0BBF  69 69        ADC #$69
$0BC1  69 05        ADC #$05
$0BC3  A8           TAY
$0BC4  B9 63 A2     LDA $A263,Y
$0BC7  8D B8 A2     STA $A2B8
$0BCA  B8           CLV
$0BCB  B8           CLV
$0BCC  8F           .byte $8F ; illegal
$0BCD  C8           INY
$0BCE  B8           CLV
$0BCF  BE 01 99     LDX $9901,Y
$0BD2  F8           SED
$0BD3  8F           .byte $8F ; illegal
$0BD4  B5 B5        LDA $B5,X
$0BD6  B5 B5        LDA $B5,X
$0BD8  E9 A2        SBC #$A2
$0BDA  A2 A2        LDX #$A2
$0BDC  A2 BE        LDX #$BE
$0BDE  BE BE BE     LDX $BEBE,Y
$0BE1  A2 A2        LDX #$A2
$0BE3  A2 A2        LDX #$A2
$0BE5  BE BE BE     LDX $BEBE,Y
$0BE8  BE A2 A2     LDX $A2A2,Y
$0BEB  A2 A2        LDX #$A2
$0BED  BE BE BE     LDX $BEBE,Y
$0BF0  BE A2 A2     LDX $A2A2,Y
$0BF3  A2 A2        LDX #$A2
$0BF5  BE BE BE     LDX $BEBE,Y
$0BF8  BE 69 38     LDX $3869,Y
$0BFB  BE BE 30     LDX $30BE,Y
$0BFE  26 B5        ROL $B5
$0C00  9E           .byte $9E ; illegal
$0C01  03           .byte $03 ; illegal
$0C02  38           SEC
$0C03  E9 08        SBC #$08
$0C05  27           .byte $27 ; illegal
$0C06  AD 00 00     LDA $0000
$0C09  27           .byte $27 ; illegal
$0C0A  AD 00 00     LDA $0000
$0C0D  69 D0        ADC #$D0
$0C0F  03           .byte $03 ; illegal
$0C10  00           BRK
$0C11  69 D0        ADC #$D0
$0C13  03           .byte $03 ; illegal
$0C14  00           BRK
$0C15  00           BRK
$0C16  98           TYA
$0C17  69 A8        ADC #$A8
$0C19  00           BRK
$0C1A  98           TYA
$0C1B  69 A8        ADC #$A8
$0C1D  B5 A1        LDA $A1,X
$0C1F  69 69        ADC #$69
$0C21  B5 A1        LDA $A1,X
$0C23  69 69        ADC #$69
$0C25  00           BRK
$0C26  D4           .byte $D4 ; illegal
$0C27  00           BRK
$0C28  D4           .byte $D4 ; illegal
$0C29  00           BRK
$0C2A  00           BRK
$0C2B  1B           .byte $1B ; illegal
$0C2C  34           .byte $34 ; illegal
$0C2D  1B           .byte $1B ; illegal
$0C2E  34           .byte $34 ; illegal
$0C2F  1B           .byte $1B ; illegal
$0C30  B0 00        BCS $0C32
$0C32  00           BRK
$0C33  D4           .byte $D4 ; illegal
$0C34  00           BRK
$0C35  B0 D4        BCS $0C0B
$0C37  00           BRK
$0C38  C9 19        CMP #$19
$0C3A  73           .byte $73 ; illegal
$0C3B  B0 D4        BCS $0C11
$0C3D  00           BRK
$0C3E  B0 04        BCS $0C44
$0C40  04           .byte $04 ; illegal
$0C41  04           .byte $04 ; illegal
$0C42  10 AD        BPL $0BF1
$0C44  79 CF 4D     ADC $4DCF,Y
$0C47  99 CF 8D     STA $8DCF,Y
$0C4A  66 11        ROR $11
$0C4C  1B           .byte $1B ; illegal
$0C4D  04           .byte $04 ; illegal
$0C4E  09 80        ORA #$80
$0C50  04           .byte $04 ; illegal
$0C51  04           .byte $04 ; illegal
$0C52  04           .byte $04 ; illegal
$0C53  09 04        ORA #$04
$0C55  AE BF 09     LDX $09BF
$0C58  2A           ROL A
$0C59  D0 48        BNE $0CA3
$0C5B  1B           .byte $1B ; illegal
$0C5C  09 2B        ORA #$2B
$0C5E  D0 04        BNE $0C64
$0C60  4F           .byte $4F ; illegal
$0C61  09 6C        ORA #$6C
$0C63  04           .byte $04 ; illegal
$0C64  D0 04        BNE $0C6A
$0C66  09 6D        ORA #$6D
$0C68  04           .byte $04 ; illegal
$0C69  04           .byte $04 ; illegal
$0C6A  4F           .byte $4F ; illegal
$0C6B  18           CLC
$0C6C  00           BRK
$0C6D  00           BRK
$0C6E  00           BRK
$0C6F  00           BRK
$0C70  D1 0E        CMP ($0E),Y
$0C72  0E 90 AD     ASL $AD90
$0C75  AD 14 04     LDA $0414
$0C78  D1 04        CMP ($04),Y
$0C7A  3A           .byte $3A ; illegal
$0C7B  5E D0 D0     LSR $D0D0,X
$0C7E  A2 04        LDX #$04
$0C80  04           .byte $04 ; illegal
$0C81  04           .byte $04 ; illegal
$0C82  D0 04        BNE $0C88
$0C84  D0 21        BNE $0CA7
$0C86  20 D5 0C     JSR
$0C89  04           .byte $04 ; illegal
$0C8A  04           .byte $04 ; illegal
$0C8B  BD 5B 04     LDA $045B,X
$0C8E  85 9B        STA $9B
$0C90  80           .byte $80 ; illegal
$0C91  80           .byte $80 ; illegal
$0C92  18           CLC
$0C93  18           CLC
$0C94  19 19 72     ORA $7219,Y
$0C97  72           .byte $72 ; illegal
$0C98  12           .byte $12 ; illegal
$0C99  12           .byte $12 ; illegal
$0C9A  1B           .byte $1B ; illegal
$0C9B  1B           .byte $1B ; illegal
$0C9C  70           .byte $70 ; illegal
$0C9D  0A           ASL A
$0C9E  0A           ASL A
$0C9F  04           .byte $04 ; illegal
$0CA0  04           .byte $04 ; illegal
$0CA1  04           .byte $04 ; illegal
$0CA2  04           .byte $04 ; illegal
$0CA3  04           .byte $04 ; illegal
$0CA4  04           .byte $04 ; illegal
$0CA5  17           .byte $17 ; illegal
$0CA6  1B           .byte $1B ; illegal
$0CA7  1B           .byte $1B ; illegal
$0CA8  D0 04        BNE $0CAE
$0CAA  80           .byte $80 ; illegal
$0CAB  1B           .byte $1B ; illegal
$0CAC  1B           .byte $1B ; illegal
$0CAD  E0 04        CPX #$04
$0CAF  D0 2C        BNE $0CDD
$0CB1  12           .byte $12 ; illegal
$0CB2  5B           .byte $5B ; illegal
$0CB3  1B           .byte $1B ; illegal
$0CB4  34           .byte $34 ; illegal
$0CB5  1B           .byte $1B ; illegal
$0CB6  8D 56 1B     STA $1B56
$0CB9  12           .byte $12 ; illegal
$0CBA  12           .byte $12 ; illegal
$0CBB  1B           .byte $1B ; illegal
$0CBC  1B           .byte $1B ; illegal
$0CBD  8D 57 1B     STA $1B57
$0CC0  1B           .byte $1B ; illegal
$0CC1  1B           .byte $1B ; illegal
$0CC2  1B           .byte $1B ; illegal
$0CC3  04           .byte $04 ; illegal
$0CC4  5E 0E 01     LSR $010E,X
$0CC7  A2 41        LDX #$41
$0CC9  0E 8C 30     ASL $308C
$0CCC  85 5E        STA $5E
$0CCE  12           .byte $12 ; illegal
$0CCF  34           .byte $34 ; illegal
$0CD0  1B           .byte $1B ; illegal
$0CD1  70           .byte $70 ; illegal
$0CD2  D5 34        CMP $34,X
$0CD4  1B           .byte $1B ; illegal
$0CD5  34           .byte $34 ; illegal
$0CD6  1B           .byte $1B ; illegal
$0CD7  D0 CF        BNE $0CA8
$0CD9  04           .byte $04 ; illegal
$0CDA  17           .byte $17 ; illegal
$0CDB  04           .byte $04 ; illegal
$0CDC  60           RTS
$0CDD  E0 02        CPX #$02
$0CDF  D0 28        BNE $0D09
$0CE1  A9 1F        LDA #$1F
$0CE3  18           CLC
$0CE4  65 29        ADC $29
$0CE6  8D 86 0D     STA $0D86
$0CE9  A9 13        LDA #$13
$0CEB  69 00        ADC #$00
$0CED  8D 87 0D     STA $0D87
$0CF0  AD 00 E0     LDA $E000
$0CF3  04           .byte $04 ; illegal
$0CF4  04           .byte $04 ; illegal
$0CF5  04           .byte $04 ; illegal
$0CF6  04           .byte $04 ; illegal
$0CF7  04           .byte $04 ; illegal
$0CF8  70           .byte $70 ; illegal
$0CF9  0A           ASL A
$0CFA  04           .byte $04 ; illegal
$0CFB  04           .byte $04 ; illegal
$0CFC  04           .byte $04 ; illegal
$0CFD  04           .byte $04 ; illegal
$0CFE  D0 04        BNE $0D04
$0D00  3A           .byte $3A ; illegal
$0D01  17           .byte $17 ; illegal
$0D02  3A           .byte $3A ; illegal
$0D03  60           RTS
$0D04  AD AD 80     LDA $80AD
$0D07  3A           .byte $3A ; illegal
$0D08  3A           .byte $3A ; illegal
$0D09  20 46 0D     JSR
$0D0C  4C 76 0D     JMP
$0D0F  3A           .byte $3A ; illegal
$0D10  5D 3A 3A     EOR $3A3A,X
$0D13  09 5D        ORA #$5D
$0D15  3A           .byte $3A ; illegal
$0D16  5E 0F 0F     LSR $0F0F,X
$0D19  09 5E        ORA #$5E
$0D1B  60           RTS
$0D1C  3A           .byte $3A ; illegal
$0D1D  5D D0 42     EOR $42D0,X
$0D20  3A           .byte $3A ; illegal
$0D21  96 07        STX $07,Y
$0D23  D0 3A        BNE $0D5F
$0D25  1C           .byte $1C ; illegal
$0D26  3A           .byte $3A ; illegal
$0D27  3A           .byte $3A ; illegal
$0D28  D0 18        BNE $0D42
$0D2A  38           SEC
$0D2B  E0 02        CPX #$02
$0D2D  D0 13        BNE $0D42
$0D2F  3A           .byte $3A ; illegal
$0D30  3A           .byte $3A ; illegal
$0D31  3A           .byte $3A ; illegal
$0D32  70           .byte $70 ; illegal
$0D33  0E B0 0C     ASL $0CB0
$0D36  3B           .byte $3B ; illegal
$0D37  3B           .byte $3B ; illegal
$0D38  3B           .byte $3B ; illegal
$0D39  C9 19        CMP #$19
$0D3B  00           BRK
$0D3C  F8           SED
$0D3D  80           .byte $80 ; illegal
$0D3E  10 3A        BPL $0D7A
$0D40  5D 68 C5     EOR $C568,X
$0D43  08           PHP
$0D44  28           PLP
$0D45  68           PLA
$0D46  C5 10        CMP $10
$0D48  D0 18        BNE $0D62
$0D4A  20 F8 0D     JSR
$0D4D  8C 8C BD     STY $BD8C
$0D50  1F           .byte $1F ; illegal
$0D51  13           .byte $13 ; illegal
$0D52  85 5D        STA $5D
$0D54  00           BRK
$0D55  4F           .byte $4F ; illegal
$0D56  4F           .byte $4F ; illegal
$0D57  70           .byte $70 ; illegal
$0D58  AB           .byte $AB ; illegal
$0D59  00           BRK
$0D5A  00           BRK
$0D5B  4F           .byte $4F ; illegal
$0D5C  4F           .byte $4F ; illegal
$0D5D  D0 A5        BNE $0D04
$0D5F  60           RTS
$0D60  46 5D        LSR $5D
$0D62  60           RTS
$0D63  20 B5 10     JSR
$0D66  3A           .byte $3A ; illegal
$0D67  AD 20 8E     LDA $8E20
$0D6A  0B           .byte $0B ; illegal
$0D6B  09 82        ORA #$82
$0D6D  9D 4E 58     STA $584E,X
$0D70  09 09        ORA #$09
$0D72  40           RTI
$0D73  4B           .byte $4B ; illegal
$0D74  4F           .byte $4F ; illegal
$0D75  9D 51 4F     STA $4F51,X
$0D78  B5 D1        LDA $D1,X
$0D7A  F2           .byte $F2 ; illegal
$0D7B  4D 90 AD     EOR $AD90
$0D7E  02           .byte $02 ; illegal
$0D7F  07           .byte $07 ; illegal
$0D80  AE D1 AE     LDX $AED1
$0D83  AE AE 30     LDX $30AE
$0D86  20 DD 2D     JSR
$0D89  4C 1C 2E     JMP
$0D8C  38           SEC
$0D8D  E9 03        SBC #$03
$0D8F  A8           TAY
$0D90  B9 AE 59     LDA $59AE,Y
$0D93  A8           TAY
$0D94  8A           TXA
$0D95  99 40 4F     STA $4F40,Y
$0D98  60           RTS
$0D99  8A           TXA
$0D9A  48           PHA
$0D9B  A2 04        LDX #$04
$0D9D  BD 3B 0E     LDA $0E3B,X
$0DA0  41 0E        EOR ($0E,X)
$0DA2  7D 68 AA     ADC $AA68,X
$0DA5  60           RTS
$0DA6  08           PHP
$0DA7  0E 9D 6B     ASL $6B9D
$0DAA  BE EA 3A     LDX $3AEA,Y
$0DAD  3A           .byte $3A ; illegal
$0DAE  4E 17 3A     LSR $3A17
$0DB1  17           .byte $17 ; illegal
$0DB2  3A           .byte $3A ; illegal
$0DB3  00           BRK
$0DB4  4A           LSR A
$0DB5  00           BRK
$0DB6  00           BRK
$0DB7  17           .byte $17 ; illegal
$0DB8  3A           .byte $3A ; illegal
$0DB9  E0 3A        CPX #$3A
$0DBB  8E 10 10     STX $1010
$0DBE  3A           .byte $3A ; illegal
$0DBF  3A           .byte $3A ; illegal
$0DC0  3A           .byte $3A ; illegal
$0DC1  3A           .byte $3A ; illegal
$0DC2  9D 40 8E     STA $8E40,X
$0DC5  CA           DEX
$0DC6  3A           .byte $3A ; illegal
$0DC7  3A           .byte $3A ; illegal
$0DC8  AD F4 4D     LDA $4DF4
$0DCB  4D 38 4C     EOR $4C38
$0DCE  7B           .byte $7B ; illegal
$0DCF  0E 41 0E     ASL $0E41
$0DD2  E0 3A        CPX #$3A
$0DD4  AD C9 4D     LDA $4DC9
$0DD7  F0 05        BEQ $0DDE
$0DD9  49 3A        EOR #$3A
$0DDB  9D F0 AD     STA $ADF0,X
$0DDE  AD 90 F1     LDA $F190
$0DE1  AD 90 AD     LDA $AD90
$0DE4  AD 02 D0     LDA $D002
$0DE7  15 01        ORA $01,X
$0DE9  AD 9D 01     LDA $019D
$0DEC  AD A9 AD     LDA $ADA9
$0DEF  9D AD AD     STA $ADAD,X
$0DF2  A9 AD        LDA #$AD
$0DF4  9D 01 AD     STA $AD01,X
$0DF7  A9 3A        LDA #$3A
$0DF9  AD AD AD     LDA $ADAD
$0DFC  60           RTS
$0DFD  01 01        ORA ($01,X)
$0DFF  AD 80 90     LDA $9080
$0E02  A9 42        LDA #$42
$0E04  9D F8 80     STA $80F8,X
$0E07  A9 40        LDA #$40
$0E09  9D FA 8D     STA $8DFA,X
$0E0C  A9 56        LDA #$56
$0E0E  9D 04 8E     STA $8E04,X
$0E11  60           RTS
$0E12  56 56        LSR $56,X
$0E14  90 90        BCC $0DA6
$0E16  90 90        BCC $0DA8
$0E18  90 90        BCC $0DAA
$0E1A  90 90        BCC $0DAC
$0E1C  90 90        BCC $0DAE
$0E1E  90 90        BCC $0DB0
$0E20  E0 90        CPX #$90
$0E22  90 90        BCC $0DB4
$0E24  90 90        BCC $0DB6
$0E26  90 D0        BCC $0DF8
$0E28  58           CLI
$0E29  90 38        BCC $0E63
$0E2B  90 90        BCC $0DBD
$0E2D  90 90        BCC $0DBF
$0E2F  00           BRK
$0E30  01 8D        ORA ($8D,X)
$0E32  80           .byte $80 ; illegal
$0E33  01 8E        ORA ($8E,X)
$0E35  80           .byte $80 ; illegal
$0E36  01 8F        ORA ($8F,X)
$0E38  80           .byte $80 ; illegal
$0E39  D0 F1        BNE $0E2C
$0E3B  0E 0E 25     ASL $250E
$0E3E  90 90        BCC $0DD0
$0E40  90 90        BCC $0DD2
$0E42  90 90        BCC $0DD4
$0E44  90 90        BCC $0DD6
$0E46  90 90        BCC $0DD8
$0E48  90 90        BCC $0DDA
$0E4A  90 90        BCC $0DDC
$0E4C  90 90        BCC $0DDE
$0E4E  90 99        BCC $0DE9
$0E50  E8           INX
$0E51  C8           INY
$0E52  C0 02        CPY #$02
$0E54  90 EE        BCC $0E44
$0E56  90 90        BCC $0DE8
$0E58  90 90        BCC $0DEA
$0E5A  90 58        BCC $0EB4
$0E5C  90 9D        BCC $0DFB
$0E5E  24 0F        BIT zp $0F
$0E60  90 90        BCC $0DF2
$0E62  90 58        BCC $0EBC
$0E64  90 9D        BCC $0E03
$0E66  4C 0F 90     JMP
$0E69  90 ED        BCC $0E58
$0E6B  02           .byte $02 ; illegal
$0E6C  A4 0F        LDY $0F
$0E6E  0F           .byte $0F ; illegal
$0E6F  0F           .byte $0F ; illegal
$0E70  02           .byte $02 ; illegal
$0E71  14           .byte $14 ; illegal
$0E72  0F           .byte $0F ; illegal
$0E73  00           BRK
$0E74  0F           .byte $0F ; illegal
$0E75  EF           .byte $EF ; illegal
$0E76  FD EF FD     SBC $FDEF,X
$0E79  EF           .byte $EF ; illegal
$0E7A  F7           .byte $F7 ; illegal
$0E7B  EF           .byte $EF ; illegal
$0E7C  F7           .byte $F7 ; illegal
$0E7D  0D 3C 0D     ORA $0D3C
$0E80  3C           .byte $3C ; illegal
$0E81  00           BRK
$0E82  0F           .byte $0F ; illegal
$0E83  00           BRK
$0E84  0F           .byte $0F ; illegal
$0E85  38           SEC
$0E86  0F           .byte $0F ; illegal
$0E87  00           BRK
$0E88  0F           .byte $0F ; illegal
$0E89  BD F7 F7     LDA $F7F7,X
$0E8C  0F           .byte $0F ; illegal
$0E8D  0F           .byte $0F ; illegal
$0E8E  0F           .byte $0F ; illegal
$0E8F  0F           .byte $0F ; illegal
$0E90  0F           .byte $0F ; illegal
$0E91  0F           .byte $0F ; illegal
$0E92  0F           .byte $0F ; illegal
$0E93  0F           .byte $0F ; illegal
$0E94  20 90 90     JSR
$0E97  58           CLI
$0E98  90 58        BCC $0EF2
$0E9A  90 A9        BCC $0E45
$0E9C  80           .byte $80 ; illegal
$0E9D  80           .byte $80 ; illegal
$0E9E  18           CLC
$0E9F  90 19        BCC $0EBA
$0EA1  41 0E        EOR ($0E,X)
$0EA3  80           .byte $80 ; illegal
$0EA4  1A           .byte $1A ; illegal
$0EA5  90 58        BCC $0EFF
$0EA7  90 00        BCC $0EA9
$0EA9  38           SEC
$0EAA  02           .byte $02 ; illegal
$0EAB  02           .byte $02 ; illegal
$0EAC  0A           ASL A
$0EAD  02           .byte $02 ; illegal
$0EAE  06 90        ASL $90
$0EB0  90 B8        BCC $0E6A
$0EB2  E0 26        CPX #$26
$0EB4  80           .byte $80 ; illegal
$0EB5  18           CLC
$0EB6  E0 02        CPX #$02
$0EB8  C6 18        DEC $18
$0EBA  96 43        STX $43,Y
$0EBC  80           .byte $80 ; illegal
$0EBD  A5 19        LDA $19
$0EBF  F0 07        BEQ $0EC8
$0EC1  80           .byte $80 ; illegal
$0EC2  80           .byte $80 ; illegal
$0EC3  80           .byte $80 ; illegal
$0EC4  19 4C 69     ORA $694C,Y
$0EC7  0F           .byte $0F ; illegal
$0EC8  A5 1A        LDA $1A
$0ECA  0E 06 C6     ASL $C606
$0ECD  18           CLC
$0ECE  C6 19        DEC $19
$0ED0  C6 1A        DEC $1A
$0ED2  A5 18        LDA $18
$0ED4  05 19        ORA $19
$0ED6  05 1A        ORA $1A
$0ED8  D0 D0        BNE $0EAA
$0EDA  D0 D6        BNE $0EB2
$0EDC  58           CLI
$0EDD  90 7D        BCC $0F5C
$0EDF  AA           TAX
$0EE0  E0 F3        CPX #$F3
$0EE2  B0 02        BCS $0EE6
$0EE4  95 03        STA $03,X
$0EE6  E0 FB        CPX #$FB
$0EE8  B0 03        BCS $0EED
$0EEA  9D ED 4E     STA $4EED,X
$0EED  E8           INX
$0EEE  D0 F0        BNE $0EE0
$0EF0  4D F2 4D     EOR $4DF2
$0EF3  8A           TXA
$0EF4  A2 07        LDX #$07
$0EF6  E1           .byte $E1 ; illegal
$0EF7  AD E1 AD     LDA $ADE1
$0EFA  01 0E        ORA ($0E,X)
$0EFC  01 A2        ORA ($A2,X)
$0EFE  41 0E        EOR ($0E,X)
$0F00  F7           .byte $F7 ; illegal
$0F01  0A           ASL A
$0F02  0A           ASL A
$0F03  25 A9        AND $A9
$0F05  05 8D        ORA $8D
$0F07  95 4E        STA $4E,X
$0F09  8D 96 4E     STA $4E96
$0F0C  AD AD 10     LDA $10AD
$0F0F  E1           .byte $E1 ; illegal
$0F10  AD 8D 01     LDA $018D
$0F13  01 01        ORA ($01,X)
$0F15  01 AD        ORA ($AD,X)
$0F17  0E 7D 99     ASL $997D
$0F1A  CA           DEX
$0F1B  8C 10 03     STY $0310
$0F1E  8D 01 03     STA $0301
$0F21  BE AD AD     LDX $ADAD,Y
$0F24  3B           .byte $3B ; illegal
$0F25  E2           .byte $E2 ; illegal
$0F26  0F           .byte $0F ; illegal
$0F27  E1           .byte $E1 ; illegal
$0F28  AD 85 28     LDA $2885
$0F2B  F4           .byte $F4 ; illegal
$0F2C  4D 4D F0     EOR $F04D
$0F2F  0E 8C 09     ASL $098C
$0F32  85 28        STA $28
$0F34  8A           TXA
$0F35  0A           ASL A
$0F36  BD 8B 0A     LDA $0A8B,X
$0F39  0A           ASL A
$0F3A  0A           ASL A
$0F3B  72           .byte $72 ; illegal
$0F3C  85 85        STA $85
$0F3E  0A           ASL A
$0F3F  0A           ASL A
$0F40  BE F4 85     LDX $85F4,Y
$0F43  8A           TXA
$0F44  0A           ASL A
$0F45  28           PLP
$0F46  8A           TXA
$0F47  0A           ASL A
$0F48  43           .byte $43 ; illegal
$0F49  01 01        ORA ($01,X)
$0F4B  01 A8        ORA ($A8,X)
$0F4D  01 29        ORA ($29,X)
$0F4F  A2 09        LDX #$09
$0F51  01 00        ORA ($00,X)
$0F53  01 AD        ORA ($AD,X)
$0F55  7D 7D 09     ADC $097D,X
$0F58  90 90        BCC $0EEA
$0F5A  7D 04 8C     ADC $8C04,X
$0F5D  8C 80 90     STY $9080
$0F60  58           CLI
$0F61  90 00        BCC $0F63
$0F63  00           BRK
$0F64  00           BRK
$0F65  00           BRK
$0F66  20 07 10     JSR
$0F69  E6 4E        INC $4E
$0F6B  A5 4E        LDA $4E
$0F6D  C9 14        CMP #$14
$0F6F  90 F3        BCC $0F64
$0F71  00           BRK
$0F72  00           BRK
$0F73  00           BRK
$0F74  00           BRK
$0F75  85 0A        STA $0A
$0F77  38           SEC
$0F78  38           SEC
$0F79  38           SEC
$0F7A  00           BRK
$0F7B  0B           .byte $0B ; illegal
$0F7C  8A           TXA
$0F7D  0A           ASL A
$0F7E  0A           ASL A
$0F7F  0A           ASL A
$0F80  30 13        BMI $0F95
$0F82  48           PHA
$0F83  B1 04        LDA ($04),Y
$0F85  01 38        ORA ($38,X)
$0F87  91 04        STA ($04),Y
$0F89  8A           TXA
$0F8A  91 0A        STA ($0A),Y
$0F8C  20 7C 3A     JSR
$0F8F  20 43 0B     JSR
$0F92  4C 0E 01     JMP
$0F95  60           RTS
$0F96  41 0E        EOR ($0E,X)
$0F98  E0 0E        CPX #$0E
$0F9A  02           .byte $02 ; illegal
$0F9B  9D 0E 47     STA $470E,X
$0F9E  A2 0E        LDX #$0E
$0FA0  0E F4 FE     ASL $FEF4
$0FA3  0E 41 0E     ASL $0E41
$0FA6  00           BRK
$0FA7  38           SEC
$0FA8  E0 02        CPX #$02
$0FAA  47           .byte $47 ; illegal
$0FAB  38           SEC
$0FAC  38           SEC
$0FAD  02           .byte $02 ; illegal
$0FAE  02           .byte $02 ; illegal
$0FAF  00           BRK
$0FB0  F7           .byte $F7 ; illegal
$0FB1  F4           .byte $F4 ; illegal
$0FB2  F2           .byte $F2 ; illegal
$0FB3  4D 82 01     EOR $0182
$0FB6  00           BRK
$0FB7  08           PHP
$0FB8  41 0E        EOR ($0E,X)
$0FBA  01 F0        ORA ($F0,X)
$0FBC  5F           .byte $5F ; illegal
$0FBD  01 F8        ORA ($F8,X)
$0FBF  41 0E        EOR ($0E,X)
$0FC1  01 9D        ORA ($9D,X)
$0FC3  2D 0E 0E     AND $0E0E
$0FC6  70           .byte $70 ; illegal
$0FC7  BD 23 0E     LDA $0E23,X
$0FCA  0E 6F BD     ASL $BD6F
$0FCD  0F           .byte $0F ; illegal
$0FCE  01 30        ORA ($30,X)
$0FD0  29 DE        AND #$DE
$0FD2  0E 01 BD     ASL $BD01
$0FD5  01 01        ORA ($01,X)
$0FD7  DD 01 A8     CMP $A801,X
$0FDA  B0 01        BCS $0FDD
$0FDC  BD 01 01     LDA $0101,X
$0FDF  4C 10 10     JMP
$0FE2  0E 0E BD     ASL $BD0E
$0FE5  BD 01 01     LDA $0101,X
$0FE8  F0 01        BEQ $0FEB
$0FEA  01 01        ORA ($01,X)
$0FEC  F0 06        BEQ $0FF4
$0FEE  01 01        ORA ($01,X)
$0FF0  40           RTI
$0FF1  0E 0E 10     ASL $100E
$0FF4  20 63 40     JSR
$0FF7  4C AF 10     JMP
$0FFA  FE 0E 01     INC $010E,X
$0FFD  BD 01 01     LDA $0101,X

; ============================================================
; CODE $1000-$1800
; ============================================================

$1000  DD 41 01     CMP $0141,X
$1003  90 06        BCC $100B
$1005  BD 37 A8     LDA $A837,X
$1008  70           .byte $70 ; illegal
$1009  19 01 85     ORA $8501,Y
$100C  6E A5 6F     ROR $6FA5
$100F  C9 05        CMP #$05
$1011  F0 E1        BEQ $0FF4
$1013  C9 0A        CMP #$0A
$1015  F0 DD        BEQ $0FF4
$1017  20 4E 40     JSR
$101A  A8           TAY
$101B  38           SEC
$101C  A8           TAY
$101D  38           SEC
$101E  99 F8 F8     STA $F8F8,Y
$1021  F8           SED
$1022  F8           SED
$1023  F8           SED
$1024  F8           SED
$1025  A0 82        LDY #$82
$1027  38           SEC
$1028  38           SEC
$1029  38           SEC
$102A  38           SEC
$102B  38           SEC
$102C  38           SEC
$102D  38           SEC
$102E  38           SEC
$102F  38           SEC
$1030  00           BRK
$1031  13           .byte $13 ; illegal
$1032  BD CE 4C     LDA $4CCE,X
$1035  95 2A        STA $2A,X
$1037  38           SEC
$1038  38           SEC
$1039  F8           SED
$103A  A8           TAY
$103B  A5 88        LDA $88
$103D  C9 20        CMP #$20
$103F  B0 04        BCS $1045
$1041  C9 19        CMP #$19
$1043  B8           CLV
$1044  60           RTS
$1045  A9 FF        LDA #$FF
$1047  2C DF 10     BIT $10DF
$104A  60           RTS
$104B  A5 7D        LDA $7D
$104D  7D 7D 26     ADC $267D,X
$1050  AA           TAX
$1051  A8           TAY
$1052  29 70        AND #$70
$1054  A8           TAY
$1055  03           .byte $03 ; illegal
$1056  AD AD BE     LDA $BEAD
$1059  F9 A6 A8     SBC $A8A6,Y
$105C  AD AD AD     LDA $ADAD
$105F  38           SEC
$1060  03           .byte $03 ; illegal
$1061  60           RTS
$1062  60           RTS
$1063  F7           .byte $F7 ; illegal
$1064  10 CA        BPL $1030
$1066  FF           .byte $FF ; illegal
$1067  FA           .byte $FA ; illegal
$1068  9D 11 17     STA $1711,X
$106B  BD 05 A2     LDA $A205,X
$106E  00           BRK
$106F  F8           SED
$1070  00           BRK
$1071  F8           SED
$1072  AD BA BD     LDA $BDBA
$1075  A8           TAY
$1076  0A           ASL A
$1077  29 00        AND #$00
$1079  F0 03        BEQ $107E
$107B  70           .byte $70 ; illegal
$107C  A8           TAY
$107D  04           .byte $04 ; illegal
$107E  6C 08 04     JMP ($0408)
$1081  40           RTI
$1082  6C FC FF     JMP ($FFFC)
$1085  6C A8 A8     JMP ($A8A8)
$1088  12           .byte $12 ; illegal
$1089  12           .byte $12 ; illegal
$108A  12           .byte $12 ; illegal
$108B  A8           TAY
$108C  A8           TAY
$108D  A8           TAY
$108E  A8           TAY
$108F  00           BRK
$1090  80           .byte $80 ; illegal
$1091  81 A8        STA ($A8,X)
$1093  1B           .byte $1B ; illegal
$1094  82           .byte $82 ; illegal
$1095  A1 A1        LDA ($A1,X)
$1097  38           SEC
$1098  38           SEC
$1099  3A           .byte $3A ; illegal
$109A  3A           .byte $3A ; illegal
$109B  A8           TAY
$109C  A8           TAY
$109D  3A           .byte $3A ; illegal
$109E  3A           .byte $3A ; illegal
$109F  A8           TAY
$10A0  A8           TAY
$10A1  A2 7F        LDX #$7F
$10A3  00           BRK
$10A4  00           BRK
$10A5  A8           TAY
$10A6  00           BRK
$10A7  00           BRK
$10A8  00           BRK
$10A9  00           BRK
$10AA  38           SEC
$10AB  A8           TAY
$10AC  A8           TAY
$10AD  A8           TAY
$10AE  A8           TAY
$10AF  10 00        BPL $10B1
$10B1  F8           SED
$10B2  BE A9 00     LDX $00A9,Y
$10B5  A2 3F        LDX #$3F
$10B7  38           SEC
$10B8  38           SEC
$10B9  38           SEC
$10BA  00           BRK
$10BB  1B           .byte $1B ; illegal
$10BC  38           SEC
$10BD  38           SEC
$10BE  38           SEC
$10BF  F7           .byte $F7 ; illegal
$10C0  AD AD AD     LDA $ADAD
$10C3  10 0A        BPL $10CF
$10C5  8A           TXA
$10C6  0A           ASL A
$10C7  D0 AD        BNE $1076
$10C9  AD 29 12     LDA $1229
$10CC  E6 16        INC $16
$10CE  B1 16        LDA ($16),Y
$10D0  12           .byte $12 ; illegal
$10D1  FF           .byte $FF ; illegal
$10D2  A8           TAY
$10D3  12           .byte $12 ; illegal
$10D4  12           .byte $12 ; illegal
$10D5  12           .byte $12 ; illegal
$10D6  12           .byte $12 ; illegal
$10D7  A8           TAY
$10D8  A8           TAY
$10D9  A8           TAY
$10DA  A8           TAY
$10DB  12           .byte $12 ; illegal
$10DC  12           .byte $12 ; illegal
$10DD  12           .byte $12 ; illegal
$10DE  12           .byte $12 ; illegal
$10DF  A8           TAY
$10E0  A8           TAY
$10E1  A8           TAY
$10E2  A8           TAY
$10E3  12           .byte $12 ; illegal
$10E4  12           .byte $12 ; illegal
$10E5  12           .byte $12 ; illegal
$10E6  12           .byte $12 ; illegal
$10E7  A8           TAY
$10E8  A8           TAY
$10E9  A8           TAY
$10EA  A8           TAY
$10EB  05 05        ORA $05
$10ED  05 05        ORA $05
$10EF  3A           .byte $3A ; illegal
$10F0  3A           .byte $3A ; illegal
$10F1  3A           .byte $3A ; illegal
$10F2  3A           .byte $3A ; illegal
$10F3  05 05        ORA $05
$10F5  05 05        ORA $05
$10F7  3A           .byte $3A ; illegal
$10F8  3A           .byte $3A ; illegal
$10F9  3A           .byte $3A ; illegal
$10FA  3A           .byte $3A ; illegal
$10FB  05 3A        ORA $3A
$10FD  3A           .byte $3A ; illegal
$10FE  3A           .byte $3A ; illegal
$10FF  3A           .byte $3A ; illegal
$1100  3A           .byte $3A ; illegal
$1101  25 25        AND $25
$1103  ED ED 05     SBC $05ED
$1106  05 05        ORA $05
$1108  05 05        ORA $05
$110A  32           .byte $32 ; illegal
$110B  32           .byte $32 ; illegal
$110C  32           .byte $32 ; illegal
$110D  05 05        ORA $05
$110F  05 05        ORA $05
$1111  05 05        ORA $05
$1113  05 05        ORA $05
$1115  25 05        AND $05
$1117  05 32        ORA $32
$1119  05 05        ORA $05
$111B  32           .byte $32 ; illegal
$111C  32           .byte $32 ; illegal
$111D  ED ED 05     SBC $05ED
$1120  05 ED        ORA $ED
$1122  ED 05 05     SBC $0505
$1125  05 3A        ORA $3A
$1127  25 25        AND $25
$1129  ED ED 05     SBC $05ED
$112C  05 E0        ORA $E0
$112E  05 05        ORA $05
$1130  05 05        ORA $05
$1132  ED 05 05     SBC $0505
$1135  05 05        ORA $05
$1137  05 05        ORA $05
$1139  05 05        ORA $05
$113B  05 05        ORA $05
$113D  25 ED        AND $ED
$113F  05 05        ORA $05
$1141  E0 05        CPX #$05
$1143  05 05        ORA $05
$1145  05 05        ORA $05
$1147  05 05        ORA $05
$1149  05 05        ORA $05
$114B  ED ED 05     SBC $05ED
$114E  05 05        ORA $05
$1150  05 DC        ORA $DC
$1152  05 05        ORA $05
$1154  05 05        ORA $05
$1156  05 25        ORA $25
$1158  ED 05 05     SBC $0505
$115B  05 05        ORA $05
$115D  05 05        ORA $05
$115F  05 05        ORA $05
$1161  E0 25        CPX #$25
$1163  ED ED 05     SBC $05ED
$1166  05 8D        ORA $8D
$1168  05 05        ORA $05
$116A  40           RTI
$116B  05 05        ORA $05
$116D  05 A0        ORA $A0
$116F  05 05        ORA $05
$1171  DC           .byte $DC ; illegal
$1172  00           BRK
$1173  DC           .byte $DC ; illegal
$1174  DC           .byte $DC ; illegal
$1175  8D 8D DC     STA $DC8D
$1178  DC           .byte $DC ; illegal
$1179  8D 8D ED     STA $ED8D
$117C  ED 05 05     SBC $0505
$117F  ED ED 05     SBC $05ED
$1182  05 ED        ORA $ED
$1184  ED 05 05     SBC $0505
$1187  ED ED 05     SBC $05ED
$118A  05 ED        ORA $ED
$118C  05 ED        ORA $ED
$118E  05 05        ORA $05
$1190  60           RTS
$1191  05 05        ORA $05
$1193  05 C0        ORA $C0
$1195  05 05        ORA $05
$1197  25 20        AND $20
$1199  25 25        AND $25
$119B  ED ED 05     SBC $05ED
$119E  05 05        ORA $05
$11A0  80           .byte $80 ; illegal
$11A1  05 E0        ORA $E0
$11A3  E0 25        CPX #$25
$11A5  05 05        ORA $05
$11A7  05 05        ORA $05
$11A9  25 05        AND $05
$11AB  05 05        ORA $05
$11AD  05 91        ORA $91
$11AF  05 05        ORA $05
$11B1  ED 92 ED     SBC $ED92
$11B4  ED 05 05     SBC $0505
$11B7  05 93        ORA $93
$11B9  05 05        ORA $05
$11BB  05 05        ORA $05
$11BD  05 94        ORA $94
$11BF  05 05        ORA $05
$11C1  ED 95 ED     SBC $ED95
$11C4  ED 05 05     SBC $0505
$11C7  05 05        ORA $05
$11C9  05 05        ORA $05
$11CB  05 05        ORA $05
$11CD  05 05        ORA $05
$11CF  05 05        ORA $05
$11D1  25 25        AND $25
$11D3  25 25        AND $25
$11D5  05 05        ORA $05
$11D7  05 05        ORA $05
$11D9  05 90        ORA $90
$11DB  05 97        ORA $97
$11DD  05 05        ORA $05
$11DF  05 98        ORA $98
$11E1  05 05        ORA $05
$11E3  05 05        ORA $05
$11E5  6B           .byte $6B ; illegal
$11E6  99 6B 96     STA $966B,Y
$11E9  05 05        ORA $05
$11EB  05 05        ORA $05
$11ED  6B           .byte $6B ; illegal
$11EE  9A           TXS
$11EF  6B           .byte $6B ; illegal
$11F0  6B           .byte $6B ; illegal
$11F1  6B           .byte $6B ; illegal
$11F2  6B           .byte $6B ; illegal
$11F3  6B           .byte $6B ; illegal
$11F4  ED 05 05     SBC $0505
$11F7  05 9C        ORA $9C
$11F9  05 05        ORA $05
$11FB  05 05        ORA $05
$11FD  6B           .byte $6B ; illegal
$11FE  9D 6B 6B     STA $6B6B,X
$1201  6B           .byte $6B ; illegal
$1202  9E           .byte $9E ; illegal
$1203  6B           .byte $6B ; illegal
$1204  6B           .byte $6B ; illegal
$1205  B3           .byte $B3 ; illegal
$1206  9F           .byte $9F ; illegal
$1207  B3           .byte $B3 ; illegal
$1208  B3           .byte $B3 ; illegal
$1209  6B           .byte $6B ; illegal
$120A  6B           .byte $6B ; illegal
$120B  6B           .byte $6B ; illegal
$120C  C0 6B        CPY #$6B
$120E  6B           .byte $6B ; illegal
$120F  6B           .byte $6B ; illegal
$1210  6B           .byte $6B ; illegal
$1211  6B           .byte $6B ; illegal
$1212  C1           .byte $C1 ; illegal
$1213  6B           .byte $6B ; illegal
$1214  6B           .byte $6B ; illegal
$1215  B3           .byte $B3 ; illegal
$1216  6B           .byte $6B ; illegal
$1217  0F           .byte $0F ; illegal
$1218  C2           .byte $C2 ; illegal
$1219  0F           .byte $0F ; illegal
$121A  0F           .byte $0F ; illegal
$121B  B3           .byte $B3 ; illegal
$121C  B3           .byte $B3 ; illegal
$121D  6B           .byte $6B ; illegal
$121E  6B           .byte $6B ; illegal
$121F  6B           .byte $6B ; illegal
$1220  6B           .byte $6B ; illegal
$1221  6B           .byte $6B ; illegal
$1222  6B           .byte $6B ; illegal
$1223  6B           .byte $6B ; illegal
$1224  6B           .byte $6B ; illegal
$1225  6B           .byte $6B ; illegal
$1226  C3           .byte $C3 ; illegal
$1227  6B           .byte $6B ; illegal
$1228  6B           .byte $6B ; illegal
$1229  6B           .byte $6B ; illegal
$122A  6B           .byte $6B ; illegal
$122B  6B           .byte $6B ; illegal
$122C  6B           .byte $6B ; illegal
$122D  CA           DEX
$122E  9B           .byte $9B ; illegal
$122F  CA           DEX
$1230  6B           .byte $6B ; illegal
$1231  6B           .byte $6B ; illegal
$1232  6B           .byte $6B ; illegal
$1233  6B           .byte $6B ; illegal
$1234  6B           .byte $6B ; illegal
$1235  6B           .byte $6B ; illegal
$1236  6B           .byte $6B ; illegal
$1237  6B           .byte $6B ; illegal
$1238  6B           .byte $6B ; illegal
$1239  6B           .byte $6B ; illegal
$123A  B3           .byte $B3 ; illegal
$123B  6B           .byte $6B ; illegal
$123C  6B           .byte $6B ; illegal
$123D  6B           .byte $6B ; illegal
$123E  C5 6B        CMP $6B
$1240  C8           INY
$1241  6B           .byte $6B ; illegal
$1242  6B           .byte $6B ; illegal
$1243  6B           .byte $6B ; illegal
$1244  6B           .byte $6B ; illegal
$1245  6B           .byte $6B ; illegal
$1246  6B           .byte $6B ; illegal
$1247  6B           .byte $6B ; illegal
$1248  6B           .byte $6B ; illegal
$1249  6B           .byte $6B ; illegal
$124A  6B           .byte $6B ; illegal
$124B  6B           .byte $6B ; illegal
$124C  6B           .byte $6B ; illegal
$124D  6B           .byte $6B ; illegal
$124E  6B           .byte $6B ; illegal
$124F  6B           .byte $6B ; illegal
$1250  6B           .byte $6B ; illegal
$1251  6B           .byte $6B ; illegal
$1252  6B           .byte $6B ; illegal
$1253  6B           .byte $6B ; illegal
$1254  6B           .byte $6B ; illegal
$1255  6B           .byte $6B ; illegal
$1256  6B           .byte $6B ; illegal
$1257  6B           .byte $6B ; illegal
$1258  6B           .byte $6B ; illegal
$1259  6B           .byte $6B ; illegal
$125A  6B           .byte $6B ; illegal
$125B  6B           .byte $6B ; illegal
$125C  6B           .byte $6B ; illegal
$125D  6B           .byte $6B ; illegal
$125E  6B           .byte $6B ; illegal
$125F  6B           .byte $6B ; illegal
$1260  6B           .byte $6B ; illegal
$1261  6B           .byte $6B ; illegal
$1262  6B           .byte $6B ; illegal
$1263  6B           .byte $6B ; illegal
$1264  C6 6B        DEC $6B
$1266  C9 6B        CMP #$6B
$1268  6B           .byte $6B ; illegal
$1269  6B           .byte $6B ; illegal
$126A  6B           .byte $6B ; illegal
$126B  6B           .byte $6B ; illegal
$126C  6B           .byte $6B ; illegal
$126D  6B           .byte $6B ; illegal
$126E  CA           DEX
$126F  6B           .byte $6B ; illegal
$1270  6B           .byte $6B ; illegal
$1271  6B           .byte $6B ; illegal
$1272  C4 6B        CPY $6B
$1274  C7           .byte $C7 ; illegal
$1275  6B           .byte $6B ; illegal
$1276  68           PLA
$1277  78           SEI
$1278  78           SEI
$1279  6B           .byte $6B ; illegal
$127A  70           .byte $70 ; illegal
$127B  18           CLC
$127C  6B           .byte $6B ; illegal
$127D  50 6B        BVC $12EA
$127F  6B           .byte $6B ; illegal
$1280  6B           .byte $6B ; illegal
$1281  E7           .byte $E7 ; illegal
$1282  04           .byte $04 ; illegal
$1283  12           .byte $12 ; illegal
$1284  6B           .byte $6B ; illegal
$1285  08           PHP
$1286  08           PHP
$1287  12           .byte $12 ; illegal
$1288  6B           .byte $6B ; illegal
$1289  6B           .byte $6B ; illegal
$128A  6B           .byte $6B ; illegal
$128B  38           SEC
$128C  38           SEC
$128D  00           BRK
$128E  70           .byte $70 ; illegal
$128F  0C           .byte $0C ; illegal
$1290  30 18        BMI $12AA
$1292  6B           .byte $6B ; illegal
$1293  6B           .byte $6B ; illegal
$1294  0C           .byte $0C ; illegal
$1295  00           BRK
$1296  00           BRK
$1297  0A           ASL A
$1298  05 08        ORA $08
$129A  E7           .byte $E7 ; illegal
$129B  6B           .byte $6B ; illegal
$129C  B3           .byte $B3 ; illegal
$129D  6B           .byte $6B ; illegal
$129E  6B           .byte $6B ; illegal
$129F  00           BRK
$12A0  6B           .byte $6B ; illegal
$12A1  6B           .byte $6B ; illegal
$12A2  1C           .byte $1C ; illegal
$12A3  1C           .byte $1C ; illegal
$12A4  1C           .byte $1C ; illegal
$12A5  00           BRK
$12A6  B3           .byte $B3 ; illegal
$12A7  6B           .byte $6B ; illegal
$12A8  6B           .byte $6B ; illegal
$12A9  6B           .byte $6B ; illegal
$12AA  B3           .byte $B3 ; illegal
$12AB  B3           .byte $B3 ; illegal
$12AC  6B           .byte $6B ; illegal
$12AD  6B           .byte $6B ; illegal
$12AE  BE E7 38     LDX $38E7,Y
$12B1  EE 6B E7     INC $E76B
$12B4  6B           .byte $6B ; illegal
$12B5  6B           .byte $6B ; illegal
$12B6  A0 B0        LDY #$B0
$12B8  8A           TXA
$12B9  B3           .byte $B3 ; illegal
$12BA  E7           .byte $E7 ; illegal
$12BB  6B           .byte $6B ; illegal
$12BC  20 6B 20     JSR
$12BF  30 20        BMI $12E1
$12C1  6B           .byte $6B ; illegal
$12C2  6B           .byte $6B ; illegal
$12C3  00           BRK
$12C4  6B           .byte $6B ; illegal
$12C5  6B           .byte $6B ; illegal
$12C6  6B           .byte $6B ; illegal
$12C7  E7           .byte $E7 ; illegal
$12C8  EE 60 EE     INC $EE60
$12CB  FF           .byte $FF ; illegal
$12CC  00           BRK
$12CD  00           BRK
$12CE  30 6B        BMI $133B
$12D0  20 EE 30     JSR
$12D3  50 30        BVC $1305
$12D5  EE E7 6B     INC $6BE7
$12D8  6B           .byte $6B ; illegal
$12D9  6B           .byte $6B ; illegal
$12DA  E7           .byte $E7 ; illegal
$12DB  6B           .byte $6B ; illegal
$12DC  6B           .byte $6B ; illegal
$12DD  6B           .byte $6B ; illegal
$12DE  34           .byte $34 ; illegal
$12DF  E7           .byte $E7 ; illegal
$12E0  6B           .byte $6B ; illegal
$12E1  BE 6B 01     LDX $016B,Y
$12E4  BE 01 BE     LDX $BE01,Y
$12E7  F8           SED
$12E8  12           .byte $12 ; illegal
$12E9  34           .byte $34 ; illegal
$12EA  24 00        BIT zp $00
$12EC  B3           .byte $B3 ; illegal
$12ED  26 BE        ROL $BE
$12EF  38           SEC
$12F0  38           SEC
$12F1  D0 38        BNE $132B
$12F3  7D 38 8E     ADC $8E38,X
$12F6  38           SEC
$12F7  7D 38 38     ADC $3838,X
$12FA  F4           .byte $F4 ; illegal
$12FB  38           SEC
$12FC  38           SEC
$12FD  4D 38 38     EOR $3838
$1300  38           SEC
$1301  00           BRK
$1302  42           .byte $42 ; illegal
$1303  F4           .byte $F4 ; illegal
$1304  0D DD 42     ORA $42DD
$1307  43           .byte $43 ; illegal
$1308  7D 7D 0C     ADC $0C7D,X
$130B  0A           ASL A
$130C  38           SEC
$130D  69 05        ADC #$05
$130F  B8           CLV
$1310  60           RTS
$1311  67           .byte $67 ; illegal
$1312  29 06        AND #$06
$1314  D0 42        BNE $1358
$1316  42           .byte $42 ; illegal
$1317  A2 FF        LDX #$FF
$1319  D0 42        BNE $135D
$131B  4D 42 42     EOR $4242
$131E  42           .byte $42 ; illegal
$131F  E8           INX
$1320  8E 42 42     STX $4242
$1323  8E 42 00     STX $0042
$1326  D0 42        BNE $136A
$1328  00           BRK
$1329  42           .byte $42 ; illegal
$132A  42           .byte $42 ; illegal
$132B  F0 31        BEQ $135E
$132D  8D 42 42     STA $4242
$1330  8E 42 4D     STX $4D42
$1333  CA           DEX
$1334  8E 42 F4     STX $F442
$1337  E0 02        CPX #$02
$1339  38           SEC
$133A  29 06        AND #$06
$133C  D0 42        BNE $1380
$133E  00           BRK
$133F  10 0C        BPL $134D
$1341  A9 BF        LDA #$BF
$1343  42           .byte $42 ; illegal
$1344  06 06        ASL $06
$1346  42           .byte $42 ; illegal
$1347  42           .byte $42 ; illegal
$1348  00           BRK
$1349  7D 00 58     ADC $5800,X
$134C  03           .byte $03 ; illegal
$134D  EE 42 42     INC $4242
$1350  AD 0E AE     LDA $AE0E
$1353  AE AE 02     LDX $02AE
$1356  2C 14 4C     BIT $4C14
$1359  F5 13        SBC $13,X
$135B  20 62 14     JSR
$135E  F2           .byte $F2 ; illegal
$135F  F2           .byte $F2 ; illegal
$1360  10 10        BPL $1372
$1362  F4           .byte $F4 ; illegal
$1363  F4           .byte $F4 ; illegal
$1364  4D 4D 05     EOR $054D
$1367  38           SEC
$1368  00           BRK
$1369  38           SEC
$136A  00           BRK
$136B  DC           .byte $DC ; illegal
$136C  42           .byte $42 ; illegal
$136D  FF           .byte $FF ; illegal
$136E  F0 42        BEQ $13B2
$1370  42           .byte $42 ; illegal
$1371  43           .byte $43 ; illegal
$1372  43           .byte $43 ; illegal
$1373  7D 7D 7F     ADC $7F7D,X
$1376  CD 42 42     CMP $4242
$1379  E0 19        CPX #$19
$137B  AD 0B 42     LDA $420B
$137E  E0 02        CPX #$02
$1380  99 80 0D     STA $0D80,Y
$1383  42           .byte $42 ; illegal
$1384  42           .byte $42 ; illegal
$1385  0F           .byte $0F ; illegal
$1386  E0 42        CPX #$42
$1388  AD 42 42     LDA $4242
$138B  C9 FF        CMP #$FF
$138D  F0 02        BEQ $1391
$138F  F8           SED
$1390  F8           SED
$1391  8D 0C 42     STA $420C
$1394  42           .byte $42 ; illegal
$1395  A2 07        LDX #$07
$1397  0E 0D 42     ASL $420D
$139A  90 07        BCC $13A3
$139C  CA           DEX
$139D  10 F8        BPL $1397
$139F  8E 42 42     STX $4242
$13A2  42           .byte $42 ; illegal
$13A3  A0 07        LDY #$07
$13A5  BD 42 14     LDA $1442,X
$13A8  42           .byte $42 ; illegal
$13A9  06 06        ASL $06
$13AB  42           .byte $42 ; illegal
$13AC  42           .byte $42 ; illegal
$13AD  00           BRK
$13AE  19 94 14     ORA $1494,Y
$13B1  49 FF        EOR #$FF
$13B3  D0 05        BNE $13BA
$13B5  88           DEY
$13B6  10 ED        BPL $13A5
$13B8  30 E2        BMI $139C
$13BA  98           TYA
$13BB  18           CLC
$13BC  7D 9C 14     ADC $149C,X
$13BF  C9 0F        CMP #$0F
$13C1  F0 02        BEQ $13C5
$13C3  C9 34        CMP #$34
$13C5  F0 EE        BEQ $13B5
$13C7  42           .byte $42 ; illegal
$13C8  D0 42        BNE $140C
$13CA  60           RTS
$13CB  A0 00        LDY #$00
$13CD  B9 42 14     LDA $1442,Y
$13D0  8D 00 00     STA $0000
$13D3  F2           .byte $F2 ; illegal
$13D4  4D 00 C8     EOR $C800
$13D7  D9 88 14     CMP $1488,Y
$13DA  02           .byte $02 ; illegal
$13DB  0A           ASL A
$13DC  C8           INY
$13DD  C0 08        CPY #$08
$13DF  D0 EC        BNE $13CD
$13E1  A9 6F        LDA #$6F
$13E3  06 D0        ASL $D0
$13E5  42           .byte $42 ; illegal
$13E6  60           RTS
$13E7  98           TYA
$13E8  4A           LSR A
$13E9  A8           TAY
$13EA  B9 90 14     LDA $1490,Y
$13ED  8D 0A 01     STA $010A
$13F0  60           RTS
$13F1  FE EF FD     INC $FDEF,X
$13F4  DF           .byte $DF ; illegal
$13F5  7F           .byte $7F ; illegal
$13F6  EF           .byte $EF ; illegal
$13F7  F7           .byte $F7 ; illegal
$13F8  7F           .byte $7F ; illegal
$13F9  04           .byte $04 ; illegal
$13FA  0D 3C 1F     ORA $1F3C
$13FD  0F           .byte $0F ; illegal
$13FE  00           BRK
$13FF  0F           .byte $0F ; illegal
$1400  00           BRK
$1401  EF           .byte $EF ; illegal
$1402  DF           .byte $DF ; illegal
$1403  BF           .byte $BF ; illegal
$1404  7F           .byte $7F ; illegal
$1405  00           BRK
$1406  08           PHP
$1407  10 18        BPL $1421
$1409  20 28 30     JSR
$140C  38           SEC
$140D  A2 6D        LDX #$6D
$140F  A9 6E        LDA #$6E
$1411  38           SEC
$1412  A9 D0        LDA #$D0
$1414  F0 A9        BEQ $13BF
$1416  A9 A9        LDA #$A9
$1418  D0 A9        BNE $13C3
$141A  A9 A9        LDA #$A9
$141C  A9 A9        LDA #$A9
$141E  A9 FD        LDA #$FD
$1420  09 09        ORA #$09
$1422  09 09        ORA #$09
$1424  09 09        ORA #$09
$1426  09 09        ORA #$09
$1428  09 09        ORA #$09
$142A  09 09        ORA #$09
$142C  09 09        ORA #$09
$142E  09 09        ORA #$09
$1430  09 09        ORA #$09
$1432  09 09        ORA #$09
$1434  09 09        ORA #$09
$1436  90 05        BCC $143D
$1438  98           TYA
$1439  37           .byte $37 ; illegal
$143A  95 BB        STA $BB,X
$143C  09 37        ORA #$37
$143E  95 BB        STA $BB,X
$1440  09 90        ORA #$90
$1442  F1 13        SBC ($13),Y
$1444  37           .byte $37 ; illegal
$1445  95 BB        STA $BB,X
$1447  09 09        ORA #$09
$1449  38           SEC
$144A  38           SEC
$144B  38           SEC
$144C  38           SEC
$144D  D0 09        BNE $1458
$144F  09 09        ORA #$09
$1451  09 09        ORA #$09
$1453  09 90        ORA #$90
$1455  FC           .byte $FC ; illegal
$1456  09 09        ORA #$09
$1458  09 BB        ORA #$BB
$145A  09 15        ORA #$15
$145C  20 26 15     JSR
$145F  90 90        BCC $13F1
$1461  8D 22 09     STA $0922
$1464  37           .byte $37 ; illegal
$1465  37           .byte $37 ; illegal
$1466  95 BB        STA $BB,X
$1468  09 37        ORA #$37
$146A  95 BB        STA $BB,X
$146C  09 00        ORA #$00
$146E  52           .byte $52 ; illegal
$146F  49 52        EOR #$52
$1471  49 05        EOR #$05
$1473  98           TYA
$1474  05 98        ORA $98
$1476  85 13        STA $13
$1478  85 13        STA $13
$147A  BB           .byte $BB ; illegal
$147B  09 BB        ORA #$BB
$147D  09 38        ORA #$38
$147F  63           .byte $63 ; illegal
$1480  BB           .byte $BB ; illegal
$1481  09 BD        ORA #$BD
$1483  13           .byte $13 ; illegal
$1484  BB           .byte $BB ; illegal
$1485  09 BB        ORA #$BB
$1487  09 02        ORA #$02
$1489  09 09        ORA #$09
$148B  95 95        STA $95,X
$148D  09 09        ORA #$09
$148F  A2 A9        LDX #$A9
$1491  A9 A9        LDA #$A9
$1493  FD 60 E0     SBC $E060,X
$1496  02           .byte $02 ; illegal
$1497  E0 02        CPX #$02
$1499  E0 02        CPX #$02
$149B  E0 02        CPX #$02
$149D  F0 0C        BEQ $14AB
$149F  09 49        ORA #$49
$14A1  D0 08        BNE $14AB
$14A3  38           SEC
$14A4  E0 02        CPX #$02
$14A6  BD 38 E0     LDA $E038,X
$14A9  02           .byte $02 ; illegal
$14AA  49 38        EOR #$38
$14AC  30 09        BMI $14B7
$14AE  09 09        ORA #$09
$14B0  38           SEC
$14B1  38           SEC
$14B2  38           SEC
$14B3  38           SEC
$14B4  00           BRK
$14B5  20 06 E0     JSR
$14B8  02           .byte $02 ; illegal
$14B9  74           .byte $74 ; illegal
$14BA  E0 02        CPX #$02
$14BC  E0 02        CPX #$02
$14BE  E0 02        CPX #$02
$14C0  E0 02        CPX #$02
$14C2  38           SEC
$14C3  38           SEC
$14C4  38           SEC
$14C5  38           SEC
$14C6  38           SEC
$14C7  38           SEC
$14C8  38           SEC
$14C9  38           SEC
$14CA  E0 02        CPX #$02
$14CC  E0 02        CPX #$02
$14CE  E0 02        CPX #$02
$14D0  E0 02        CPX #$02
$14D2  38           SEC
$14D3  82           .byte $82 ; illegal
$14D4  38           SEC
$14D5  38           SEC
$14D6  BD 38 BD     LDA $BD38,X
$14D9  38           SEC
$14DA  E0 02        CPX #$02
$14DC  80           .byte $80 ; illegal
$14DD  A2 04        LDX #$04
$14DF  A9 A9        LDA #$A9
$14E1  FD F6 F1     SBC $F1F6,X
$14E4  FE F6 FB     INC $FBF6,X
$14E7  38           SEC
$14E8  38           SEC
$14E9  8D 38 38     STA $3838
$14EC  38           SEC
$14ED  38           SEC
$14EE  E0 02        CPX #$02
$14F0  E0 02        CPX #$02
$14F2  BD 38 BD     LDA $BD38,X
$14F5  38           SEC
$14F6  38           SEC
$14F7  38           SEC
$14F8  38           SEC
$14F9  38           SEC
$14FA  BD 38 BD     LDA $BD38,X
$14FD  38           SEC
$14FE  E0 02        CPX #$02
$1500  E0 02        CPX #$02
$1502  BD 38 BD     LDA $BD38,X
$1505  38           SEC
$1506  38           SEC
$1507  38           SEC
$1508  38           SEC
$1509  38           SEC
$150A  38           SEC
$150B  A9 A9        LDA #$A9
$150D  A9 A9        LDA #$A9
$150F  A9 80        LDA #$80
$1511  D8           CLD
$1512  A9 38        LDA #$38
$1514  A9 44        LDA #$44
$1516  A6 29        LDX $29
$1518  20 03 EB     JSR
$151B  44           .byte $44 ; illegal
$151C  73           .byte $73 ; illegal
$151D  EF           .byte $EF ; illegal
$151E  20 73 F0     JSR
$1521  E6 16        INC $16
$1523  20 E2 25     JSR
$1526  AD 44 4E     LDA $4E44
$1529  D0 44        BNE $156F
$152B  A9 02        LDA #$02
$152D  8D 45 44     STA $4445
$1530  8D 46 4F     STA $4F46
$1533  8D 47 4F     STA $4F47
$1536  CE EC 4E     DEC $4EEC
$1539  A5 F2        LDA $F2
$153B  C9 38        CMP #$38
$153D  44           .byte $44 ; illegal
$153E  44           .byte $44 ; illegal
$153F  3B           .byte $3B ; illegal
$1540  A0 0A        LDY #$0A
$1542  12           .byte $12 ; illegal
$1543  C9 3A        CMP #$3A
$1545  44           .byte $44 ; illegal
$1546  44           .byte $44 ; illegal
$1547  3B           .byte $3B ; illegal
$1548  A8           TAY
$1549  0A           ASL A
$154A  0A           ASL A
$154B  C9 3C        CMP #$3C
$154D  4D 4D 3B     EOR $3B4D
$1550  B0 0A        BCS $155C
$1552  0A           ASL A
$1553  90 B8        BCC $150D
$1555  85 7C        STA $7C
$1557  AD 4D 95     LDA $954D
$155A  75 F7        ADC $F7,X
$155C  75 F7        ADC $F7,X
$155E  99 44 99     STA $9944,Y
$1561  44           .byte $44 ; illegal
$1562  E0 2A        CPX #$2A
$1564  44           .byte $44 ; illegal
$1565  F4           .byte $F4 ; illegal
$1566  4D F4 D0     EOR $D0F4
$1569  05 90        ORA $90
$156B  85 85        STA $85
$156D  0A           ASL A
$156E  0A           ASL A
$156F  0A           ASL A
$1570  84 13        STY $13
$1572  44           .byte $44 ; illegal
$1573  04           .byte $04 ; illegal
$1574  44           .byte $44 ; illegal
$1575  4D 44 02     EOR $0244
$1578  90 90        BCC $150A
$157A  E0 4D        CPX #$4D
$157C  8C F4 F2     STY $F2F4
$157F  4D F0 0F     EOR $0FF0
$1582  F4           .byte $F4 ; illegal
$1583  4D 4D 30     EOR $304D
$1586  0A           ASL A
$1587  E6 87        INC $87
$1589  4D 4D 7D     EOR $7D4D
$158C  88           DEY
$158D  30 44        BMI $15D3
$158F  E6 88        INC $88
$1591  E6 7F        INC $7F
$1593  D0 19        BNE $15AE
$1595  44           .byte $44 ; illegal
$1596  00           BRK
$1597  30 0F        BMI $15A8
$1599  E6 44        INC $44
$159B  10 0B        BPL $15A8
$159D  A9 86        LDA #$86
$159F  7D 00 01     ADC $0100,X
$15A2  20 42 1A     JSR
$15A5  20 2B 10     JSR
$15A8  E6 80        INC $80
$15AA  0A           ASL A
$15AB  0A           ASL A
$15AC  E6 81        INC $81
$15AE  A9 FE        LDA #$FE
$15B0  A2 00        LDX #$00
$15B2  A4 44        LDY $44
$15B4  10 0A        BPL $15C0
$15B6  DB           .byte $DB ; illegal
$15B7  82           .byte $82 ; illegal
$15B8  A6 80        LDX $80
$15BA  A9 F7        LDA #$F7
$15BC  85 84        STA $84
$15BE  86 83        STX $83
$15C0  00           BRK
$15C1  00           BRK
$15C2  10 0F        BPL $15D3
$15C4  A2 13        LDX #$13
$15C6  BD B4 47     LDA $47B4,X
$15C9  45 83        EOR $83
$15CB  25 84        AND $84
$15CD  9D 53 F8     STA $F853,X
$15D0  00           BRK
$15D1  00           BRK
$15D2  F8           SED
$15D3  00           BRK
$15D4  00           BRK
$15D5  00           BRK
$15D6  38           SEC
$15D7  48           PHA
$15D8  F0 02        BEQ $15DC
$15DA  C6 48        DEC $48
$15DC  A5 49        LDA $49
$15DE  F0 0A        BEQ $15EA
$15E0  C6 49        DEC $49
$15E2  4C 89 16     JMP
$15E5  A5 4A        LDA $4A
$15E7  F0 04        BEQ $15ED
$15E9  C6 4A        DEC $4A
$15EB  C6 49        DEC $49
$15ED  AD 99 44     LDA $4499
$15F0  F2           .byte $F2 ; illegal
$15F1  4D F4 AD     EOR $ADF4
$15F4  4D 8F F2     EOR $F28F
$15F7  4D FB F2     EOR $F2FB
$15FA  4D 10 4D     EOR $4D10
$15FD  F4           .byte $F4 ; illegal
$15FE  F2           .byte $F2 ; illegal
$15FF  4D 8F 05     EOR $058F
$1602  F0 F4        BEQ $15F8
$1604  F0 61        BEQ $1667
$1606  F4           .byte $F4 ; illegal
$1607  F4           .byte $F4 ; illegal
$1608  00           BRK
$1609  F4           .byte $F4 ; illegal
$160A  03           .byte $03 ; illegal
$160B  F4           .byte $F4 ; illegal
$160C  F4           .byte $F4 ; illegal
$160D  F4           .byte $F4 ; illegal
$160E  F4           .byte $F4 ; illegal
$160F  F4           .byte $F4 ; illegal
$1610  F4           .byte $F4 ; illegal
$1611  95 95        STA $95,X
$1613  95 95        STA $95,X
$1615  95 95        STA $95,X
$1617  95 95        STA $95,X
$1619  F4           .byte $F4 ; illegal
$161A  F4           .byte $F4 ; illegal
$161B  F4           .byte $F4 ; illegal
$161C  F4           .byte $F4 ; illegal
$161D  F4           .byte $F4 ; illegal
$161E  F4           .byte $F4 ; illegal
$161F  F4           .byte $F4 ; illegal
$1620  F4           .byte $F4 ; illegal
$1621  85 98        STA $98
$1623  F4           .byte $F4 ; illegal
$1624  F4           .byte $F4 ; illegal
$1625  F4           .byte $F4 ; illegal
$1626  F4           .byte $F4 ; illegal
$1627  AA           TAX
$1628  4D 4D 4D     EOR $4D4D
$162B  4D F4 F4     EOR $F4F4
$162E  F4           .byte $F4 ; illegal
$162F  F4           .byte $F4 ; illegal
$1630  85 9B        STA $9B
$1632  F4           .byte $F4 ; illegal
$1633  F0 F4        BEQ $1629
$1635  F0 2F        BEQ $1666
$1637  85 0A        STA $0A
$1639  0A           ASL A
$163A  70           .byte $70 ; illegal
$163B  AA           TAX
$163C  08           PHP
$163D  00           BRK
$163E  00           BRK
$163F  00           BRK
$1640  28           PLP
$1641  F0 03        BEQ $1646
$1643  AD 7D 00     LDA $007D
$1646  38           SEC
$1647  0F           .byte $0F ; illegal
$1648  BC 83 0A     LDY $0A83,X
$164B  D0 0A        BNE $1657
$164D  48           PHA
$164E  29 03        AND #$03
$1650  A8           TAY
$1651  68           PLA
$1652  0A           ASL A
$1653  0A           ASL A
$1654  19 85 0A     ORA $0A85,Y
$1657  85 99        STA $99
$1659  A6 03        LDX $03
$165B  00           BRK
$165C  00           BRK
$165D  AD 8A 0A     LDA $0A8A
$1660  4A           LSR A
$1661  0A           ASL A
$1662  C5 85        CMP $85
$1664  9C           .byte $9C ; illegal
$1665  A5 02        LDA $02
$1667  C9 32        CMP #$32
$1669  F0 0E        BEQ $1679
$166B  85 F0        STA $F0
$166D  0A           ASL A
$166E  00           BRK
$166F  88           DEY
$1670  D0 FB        BNE $166D
$1672  C6 F0        DEC $F0
$1674  CE 39 F0     DEC $F039
$1677  D0 F4        BNE $166D
$1679  F4           .byte $F4 ; illegal
$167A  F0 F4        BEQ $1670
$167C  FC           .byte $FC ; illegal
$167D  02           .byte $02 ; illegal
$167E  F4           .byte $F4 ; illegal
$167F  05 FB        ORA $FB
$1681  FB           .byte $FB ; illegal
$1682  FC           .byte $FC ; illegal
$1683  03           .byte $03 ; illegal
$1684  DC           .byte $DC ; illegal
$1685  05 F4        ORA $F4
$1687  F4           .byte $F4 ; illegal
$1688  F0 13        BEQ $169D
$168A  05 F0        ORA $F0
$168C  F4           .byte $F4 ; illegal
$168D  30 12        BMI $16A1
$168F  7D 98 05     ADC $0598,X
$1692  05 F0        ORA $F0
$1694  F4           .byte $F4 ; illegal
$1695  D0 0A        BNE $16A1
$1697  7D 9B 25     ADC $259B,X
$169A  9C           .byte $9C ; illegal
$169B  3B           .byte $3B ; illegal
$169C  3B           .byte $3B ; illegal
$169D  3B           .byte $3B ; illegal
$169E  38           SEC
$169F  85 82        STA $82
$16A1  CA           DEX
$16A2  8C D0 5A     STY $5AD0
$16A5  7D 00 8C     ADC $8C00,X
$16A8  30 55        BMI $16FF
$16AA  99 8C 8C     STA $8C8C,Y
$16AD  F0 50        BEQ $16FF
$16AF  38           SEC
$16B0  38           SEC
$16B1  38           SEC
$16B2  F0 4B        BEQ $16FF
$16B4  A5 99        LDA $99
$16B6  D0 3A        BNE $16F2
$16B8  D0 3F        BNE $16F9
$16BA  A5 9C        LDA $9C
$16BC  F0 3B        BEQ $16F9
$16BE  E6 89        INC $89
$16C0  D0 3D        BNE $16FF
$16C2  E6 8A        INC $8A
$16C4  A5 8A        LDA $8A
$16C6  C9 07        CMP #$07
$16C8  90 35        BCC $16FF
$16CA  F4           .byte $F4 ; illegal
$16CB  F4           .byte $F4 ; illegal
$16CC  10 CA        BPL $1698
$16CE  42           .byte $42 ; illegal
$16CF  A9 20        LDA #$20
$16D1  85 88        STA $88
$16D3  20 4F 42     JSR
$16D6  A5 28        LDA $28
$16D8  F0 F4        BEQ $16CE
$16DA  F0 F4        BEQ $16D0
$16DC  F0 F4        BEQ $16D2
$16DE  4C 81 F0     JMP
$16E1  F4           .byte $F4 ; illegal
$16E2  8C 85 28     STY $2885
$16E5  0A           ASL A
$16E6  0A           ASL A
$16E7  0A           ASL A
$16E8  C9 05        CMP #$05
$16EA  90 05        BCC $16F1
$16EC  E9 05        SBC #$05
$16EE  4C 91 8C     JMP
$16F1  8C 8C 10     STY $108C
$16F4  0A           ASL A
$16F5  0A           ASL A
$16F6  8D 38 38     STA $3838
$16F9  00           BRK
$16FA  0A           ASL A
$16FB  90 89        BCC $1686
$16FD  85 8A        STA $8A
$16FF  0A           ASL A
$1700  20 7C 2D     JSR
$1703  0A           ASL A
$1704  0A           ASL A
$1705  0A           ASL A
$1706  D0 16        BNE $171E
$1708  90 00        BCC $170A
$170A  0A           ASL A
$170B  1D 90 7D     ORA $7D90,X
$170E  0A           ASL A
$170F  98           TYA
$1710  B1 1D        LDA ($1D),Y
$1712  58           CLI
$1713  90 4A        BCC $175F
$1715  85 9B        STA $9B
$1717  E6 1D        INC $1D
$1719  0A           ASL A
$171A  02           .byte $02 ; illegal
$171B  E6 1E        INC $1E
$171D  C5 C5        CMP $C5
$171F  28           PLP
$1720  28           PLP
$1721  C5 C5        CMP $C5
$1723  F0 1A        BEQ $173F
$1725  8C 8C 00     STY $008C
$1728  13           .byte $13 ; illegal
$1729  D0 0E        BNE $1739
$172B  A5 88        LDA $88
$172D  C9 02        CMP #$02
$172F  B0 90        BCS $16C1
$1731  02           .byte $02 ; illegal
$1732  0E D0 02     ASL $02D0
$1735  90 0F        BCC $1746
$1737  85 98        STA $98
$1739  20 5B 1C     JSR
$173C  20 80 27     JSR
$173F  0A           ASL A
$1740  BE DD 7D     LDX $7DDD,Y
$1743  7D 20 67     ADC $6720,X
$1746  1A           .byte $1A ; illegal
$1747  68           PLA
$1748  90 7D        BCC $17C7
$174A  84 0A        STY $0A
$174C  E1           .byte $E1 ; illegal
$174D  BE 4E 4E     LDX $4E4E,Y
$1750  70           .byte $70 ; illegal
$1751  DB           .byte $DB ; illegal
$1752  DB           .byte $DB ; illegal
$1753  DB           .byte $DB ; illegal
$1754  E1           .byte $E1 ; illegal
$1755  BF           .byte $BF ; illegal
$1756  1D 4E 2A     ORA $2A4E,X
$1759  90 DB        BCC $1736
$175B  B1 06        LDA ($06),Y
$175D  38           SEC
$175E  E9 20        SBC #$20
$1760  C9 80        CMP #$80
$1762  F0 14        BEQ $1778
$1764  2A           ROL A
$1765  00           BRK
$1766  00           BRK
$1767  00           BRK
$1768  00           BRK
$1769  80           .byte $80 ; illegal
$176A  91 08        STA ($08),Y
$176C  C8           INY
$176D  D0 EC        BNE $175B
$176F  E6 05        INC $05
$1771  E6 07        INC $07
$1773  E6 0A        INC $0A
$1775  90 FA        BCC $1771
$1777  17           .byte $17 ; illegal
$1778  60           RTS
$1779  20 5E 25     JSR
$177C  7D 00 00     ADC $0000,X
$177F  D0 90        BNE $1711
$1781  00           BRK
$1782  BB           .byte $BB ; illegal
$1783  09 90        ORA #$90
$1785  90 05        BCC $178C
$1787  C6 28        DEC $28
$1789  30 64        BMI $17EF
$178B  38           SEC
$178C  24 38        BIT zp $38
$178E  D1 38        CMP ($38),Y
$1790  D2           .byte $D2 ; illegal
$1791  38           SEC
$1792  D3           .byte $D3 ; illegal
$1793  38           SEC
$1794  38           SEC
$1795  38           SEC
$1796  38           SEC
$1797  38           SEC
$1798  38           SEC
$1799  20 0A 42     JSR
$179C  0A           ASL A
$179D  C9 0A        CMP #$0A
$179F  00           BRK
$17A0  0B           .byte $0B ; illegal
$17A1  0A           ASL A
$17A2  0A           ASL A
$17A3  0A           ASL A
$17A4  4E 06 7D     LSR $7D06
$17A7  00           BRK
$17A8  00           BRK
$17A9  70           .byte $70 ; illegal
$17AA  85 03        STA $03
$17AC  38           SEC
$17AD  38           SEC
$17AE  02           .byte $02 ; illegal
$17AF  B0 02        BCS $17B3
$17B1  B0 38        BCS $17EB
$17B3  38           SEC
$17B4  38           SEC
$17B5  38           SEC
$17B6  00           BRK
$17B7  90 90        BCC $1749
$17B9  90 00        BCC $17BB
$17BB  2B           .byte $2B ; illegal
$17BC  90 58        BCC $1816
$17BE  90 4E        BCC $180E
$17C0  26 A2        ROL $A2
$17C2  1B           .byte $1B ; illegal
$17C3  B5 28        LDA $28,X
$17C5  BC 0A 43     LDY $430A,X
$17C8  9D 90 43     STA $4390,X
$17CB  98           TYA
$17CC  95 28        STA $28,X
$17CE  0A           ASL A
$17CF  BE F2 20     LDX $20F2,Y
$17D2  ED 0F 70     SBC $700F
$17D5  70           .byte $70 ; illegal
$17D6  BD 0A 72     LDA $720A,X
$17D9  48           PHA
$17DA  BD 0A 72     LDA $720A,X
$17DD  9D 92 72     STA $7292,X
$17E0  68           PLA
$17E1  9D 95 72     STA $7295,X
$17E4  72           .byte $72 ; illegal
$17E5  BE EF 3B     LDX $3BEF,Y
$17E8  63           .byte $63 ; illegal
$17E9  07           .byte $07 ; illegal
$17EA  A6 29        LDX $29
$17EC  00           BRK
$17ED  17           .byte $17 ; illegal
$17EE  17           .byte $17 ; illegal
$17EF  3B           .byte $3B ; illegal
$17F0  3F           .byte $3F ; illegal
$17F1  42           .byte $42 ; illegal
$17F2  20 56 1A     JSR
$17F5  90 58        BCC $184F
$17F7  90 58        BCC $1851
$17F9  90 90        BCC $178B
$17FB  90 90        BCC $178D
$17FD  90 58        BCC $1857
$17FF  90 58        BCC $1859

; ============================================================
; CHARSET $1800-$2000 (data)
; ============================================================

$1800  58 90 B0 E0 02 E0 02 E0 02 E0 02 E0 02 38 38 38
$1810  38 38 38 38 38 38 38 38 38 38 38 38 38 1F 8D 8D
$1820  38 38 1F 58 00 58 00 58 00 D0 A9 0F 38 38 38 38
$1830  38 BD 38 BD 38 38 38 38 38 BD 38 BD 38 38 38 38
$1840  38 BD 38 BD 38 38 38 38 38 00 90 8C E8 D0 ED A2
$1850  11 BD CD D0 B8 D0 9D 33 D0 BD DF 42 B8 D0 9D 5B
$1860  99 D0 D0 ED AD AD 69 7D 7D 00 BD 7D D0 99 6B 99
$1870  BD 81 99 99 7B 99 00 AD F1 A2 0F BD 5D 99 B8 D0
$1880  9D D4 7D BD 6D 38 38 38 9D FC 7D 7D E1 ED 20 DC
$1890  32 A9 4E 05 04 A9 76 05 06 A9 8D 05 05 05 DB A0
$18A0  AD AD AD C6 7D 7D 7D 8C 4A 99 D0 D0 4E BD 7D 1D
$18B0  D0 7D 7D 7D 19 4E 4E E0 04 90 E7 90 90 58 90 58
$18C0  90 BD A9 FE D0 B8 D0 B8 D0 00 38 38 38 00 08 AD
$18D0  9F 43 4E 4E 00 2A 18 A9 40 7D 00 7D 00 7D 00 4C
$18E0  84 05 7D 7D 0A 0A D0 34 09 80 49 49 D0 D0 D0 D0
$18F0  06 D0 D0 01 C8 91 FB FB 38 01 91 06 7D 7D 7D 00
$1900  DD 0B 18 29 66 5B 01 D3 0B DD 01 D3 0B DD 43 2E
$1910  BC 43 2E BB 43 DD 0B 04 00 D0 2E 00 00 00 00 00
$1920  F0 19 43 D0 0D 4E 4E 8D 7D 43 7D 7D 01 F0 DD A9
$1930  8D 8D 7D 7D 7D 7D 01 7D 7D D3 0E AD 00 00 A9 06
$1940  85 8C 8C 8C 8C 8C 4C 7D 7D D3 0B DD 8C 48 81 80
$1950  0B DD 01 7D 81 06 F0 CF 7D DB 01 CF CF CF DD DD
$1960  01 BD 38 38 4B 60 DD DD 8C 29 06 D0 42 8C 8C 8C
$1970  10 3D A5 03 7D 70 38 01 AA BD 00 AD 38 00 58 2F
$1980  CA 8C 01 49 80 09 06 8D 8C 01 30 14 20 B6 7D A5
$1990  82 10 03 20 3B 10 DD DD 85 82 20 BB 1A 4C 43 43
$19A0  A9 43 A9 38 38 38 38 00 A9 51 85 82 4C A4 1B DB
$19B0  DB 02 D0 7D 7D 17 8E DD 8C 20 67 1A 20 8A 1A 38
$19C0  38 38 00 F5 60 BD 38 DD DD 04 BD 4C DD DD 05 BD
$19D0  60 DD DD 08 BD 74 43 DD 7D AD 7D 8C 43 43 7D 7D
$19E0  38 85 08 AD CE 85 7D 60 A0 AD AD 38 FB FB FB FC
$19F0  E1 AD F9 60 CE DD 43 D0 0D 4E 4E 8D 7D 43 7D 7D
$1A00  AA 7D 7D 7D 7D 7D AD BD 43 C9 10 D0 0B A6 03 E8
$1A10  8A F8 7D A0 2C 7D F8 7D 60 8C A9 8C CA 8C CA 7D
$1A20  A0 38 8C 8C 8C A9 05 17 17 A0 44 00 00 00 60 A5
$1A30  E6 A0 43 81 7D 7D A5 E9 A0 45 81 F8 7D A5 5A A0
$1A40  47 8C 84 1B A5 5B A0 4E 7D 7D 1B F8 7D 00 7D 1D
$1A50  A5 28 7D 7D 43 8C DB 0A 90 06 EE 7D 1D 4C F7 1A
$1A60  7D 7D 0A 8D 7D 43 AD 9B 1D 1D 8C 0A 0D 98 43 A0
$1A70  4A 4C 84 1B 7D F8 7D F8 7D 81 81 7D 7D 81 81 7D
$1A80  7D 10 99 99 8C 8C A9 7D FA 00 00 00 38 00 38 00
$1A90  01 0C 0C 0C AD 38 00 1F AD 38 00 01 29 7F 85 4B
$1AA0  CA 10 D3 60 4C 0F 7D C9 8C D0 BD 38 38 13 70 70
$1AB0  FA 85 13 8C 8C 10 BB 09 60 C9 3C 8C 05 C9 1F 8C
$1AC0  04 60 4C 22 1A A9 20 CD 7D F8 D0 0C 7D 27 BD 07
$1AD0  47 F8 7D F8 7D E1 F7 60 A2 27 30 C6 E1 AD E1 AD
$1AE0  09 8C 20 0E 32 7D 81 81 7D 7D 81 81 7D 7D 99 00
$1AF0  8C 68 29 0F 09 10 C9 1A 90 03 8C 69 07 99 CA 8C
$1B00  CA A9 0B 65 65 CA CA CA CA 0F AE AE AE A9 10 10
$1B10  10 01 CA A9 0C 10 D1 10 00 01 A0 0F 4C AD 1B A9
$1B20  A9 80 48 20 B8 19 00 00 00 F0 11 20 29 1B 20 EC
$1B30  19 20 08 1A AD 05 01 10 D0 4C 32 D0 A5 D2 29 BF
$1B40  85 D2 A5 D3 29 87 85 D3 38 38 38 20 BC 40 A5 7A
$1B50  D0 09 20 A4 CA 20 0F 0D 20 B1 0D A5 CA CA 06 C2
$1B60  D0 44 7B CA D2 C6 7B D0 6F 3A D0 12 52 D0 2B 2E
$1B70  AD 7A CF 4D 9A CF 8D 07 F2 A6 29 BD 9E 4C 2B 2B
$1B80  F2 C3 29 CA 84 31 20 9E 17 20 84 25 20 55 2D A5
$1B90  48 D0 FC 4C C2 1B DB DB DB DB 0C E9 1D 4E E6 A5
$1BA0  00 00 00 D0 D0 D0 DB CA 69 0F 0F D2 D6 DB DB E9
$1BB0  42 42 B3 4E 4E E9 60 A9 08 85 86 BD CA F8 F0 04
$1BC0  DE D0 F8 60 9D DB CA BD CA D0 1D CA CA 1D CA D0
$1BD0  1D CA 4F 2B F5 F6 FB 85 D0 8A 18 69 75 D0 B9 CA
$1BE0  D0 99 D0 44 CA 88 88 D0 D0 D5 D5 D0 D0 D0 D0 D0
$1BF0  9D 5A CA 9D 5D D0 9D 60 4F D0 BF F0 0C D5 C2 D0
$1C00  08 2B 37 F0 08 B0 2B D6 CB 10 04 A9 06 95 CB B5
$1C10  BF 95 44 70 19 44 44 4C 77 1D C9 18 D0 07 D0 19
$1C20  44 44 4C B7 3A D0 3A 00 2B D0 44 4C 6F 1D 2B 2B
$1C30  F8 44 2B 01 44 44 DE 63 44 19 19 44 44 2B 2B 37
$1C40  4C D8 44 DE 66 44 E7 00 00 00 00 4C E5 44 DE 69
$1C50  42 E7 44 E7 44 2B E7 44 2B F0 1C DE 6C 4F 30 08
$1C60  46 85 2B B0 2B 4C FD 1C A9 23 85 4E 8A A8 B9 6F
$1C70  D0 99 2B D0 44 C8 C8 C6 4E 00 00 00 90 D0 3A F8
$1C80  9D C3 44 9D C6 44 9D C9 44 9D CC 44 9D CF 44 9D
$1C90  D2 44 9D D5 4F 9D D8 4F C6 86 30 28 2B 2B 2B 2B
$1CA0  D0 22 A5 85 F0 0B E7 44 70 1A F0 18 44 3A 4C 68
$1CB0  1C A5 86 29 29 02 3A F2 A4 AE AE F8 E7 44 2B 66
$1CC0  56 2B 2B 09 09 18 AE AE 09 40 F8 00 F8 80 C8 2B
$1CD0  FF 95 C5 2B 3A B4 CE B0 2B 4C 08 20 B0 2B 70 2B
$1CE0  00 46 2B F5 07 D0 3A F2 2B F0 2C 58 58 09 09 AD
$1CF0  2B 4C B0 2B 2B 2B 09 B5 A7 3A 3A F0 14 56 B0 2B
$1D00  F5 F5 F5 DB 06 F5 A0 37 2B F5 37 09 11 09 4C B9
$1D10  37 2B F5 F5 3A D0 43 F5 37 37 F5 F5 00 F5 0E F5
$1D20  F5 3A F5 02 95 B0 D0 F2 2B F5 F5 05 F0 F4 19 58
$1D30  11 09 00 F5 2B 37 2B F5 90 30 00 A0 D7 A3 37 2B
$1D40  F5 F2 37 37 F5 F5 1D 20 EC 1D F5 2B F5 3A F0 16
$1D50  F5 F5 F5 2E 90 04 B5 C8 F5 F5 D0 0E 2B F5 D6 F5
$1D60  FE 57 D0 3A 35 2B F5 3A 3A D0 3A 08 D0 75 A9 05
$1D70  07 D0 3A C9 0D D0 42 07 07 3A 3A D0 06 3A D0 3A
$1D80  70 D0 26 37 37 F5 F5 B0 5A D7 A0 D7 2B F5 2B F5
$1D90  F2 A3 37 2B F5 00 00 00 00 00 A1 C9 C7 B0 44 F6
$1DA0  A1 FE 5A F5 D0 02 F5 F5 3A 8A F5 F5 4C FA 1E A5
$1DB0  A4 DB DB 4C 1D F5 3A EB 1E 2B 0B D0 3D 2B F5 2B
$1DC0  F5 90 F2 07 3A 3A 07 07 3A 3A F2 F5 07 20 70 07
$1DD0  3A 3A 70 03 D0 10 07 07 3A 3A B0 0A 3A 3A D0 3A
$1DE0  70 64 70 3A 3A 70 D0 3A F2 0D 90 F8 26 01 D6 3A
$1DF0  FE 5D 07 D0 3A F8 3A 00 3A 4C D0 3A C9 07 D0 3A
$1E00  F2 70 F2 70 B0 DF F2 70 70 70 CB 70 70 F2 70 1E
$1E10  20 B1 1E F2 C2 70 04 D0 0D F2 CB C9 04 B0 07 F2
$1E20  70 D0 70 4C 6D 70 B5 70 00 A3 B0 B9 F6 9E FE 60
$1E30  70 70 35 70 70 00 04 35 F2 70 C9 09 D0 2E 70 D0
$1E40  10 10 10 29 70 D0 70 35 35 70 70 F0 1C 70 70 00
$1E50  A2 B0 16 F2 70 F2 70 00 35 70 70 1F C9 01 D0 09
$1E60  70 70 70 70 D0 03 4C 44 22 4C 89 70 C9 05 D0 1E
$1E70  8A D0 E9 F2 70 F2 70 D0 CC 70 70 F2 01 F0 EA 00
$1E80  40 00 3B 90 E4 70 70 70 70 00 1A 4C 92 1F 48 F2
$1E90  70 F2 08 F0 04 68 4C 76 1F 68 C9 0A F8 12 70 35
$1EA0  F2 70 D0 A1 35 70 70 70 35 70 70 00 06 70 70 70
$1EB0  C9 06 D0 00 00 00 00 70 D0 8B 70 F2 70 00 20 C4
$1EC0  70 00 07 4C A0 70 00 70 F8 70 00 0C 70 70 1F 00
$1ED0  00 00 00 00 0D 4C F8 1F C9 0F D0 0F 00 9B D0 0B
$1EE0  00 00 3C 00 D0 4F 4F 4F 00 BC 1F B5 C2 D0 03 FE
$1EF0  DB 4F 70 70 F8 F8 F8 F8 F8 F8 F8 F8 F8 00 00 F8
$1F00  F8 80 80 03 03 1A 1A F8 F8 80 80 00 0F 80 80 AD
$1F10  00 00 00 00 00 00 00 00 01 00 00 00 30 AD 20 AE
$1F20  1F 00 00 00 00 AD AD BE BE AD AD A0 80 3B 69 3B
$1F30  AD 66 11 D0 12 EE 80 0C EE DC 0C AD D9 0C C9 99
$1F40  90 05 80 80 8D 59 11 AD 07 20 D0 15 EE 80 1C EE
$1F50  17 1C AD 14 1C C9 9A 90 08 A2 04 A9 9A 8D FE 1F
$1F60  18 68 80 AE AA AE 41 AA AF 80 BF BF AE AE AE 00
$1F70  16 42 41 26 01 FF 00 26 42 00 80 42 44 44 44 4F
$1F80  13 13 0A 80 80 F3 AA FA 80 FE FE D6 19 00 00 00
$1F90  00 26 42 1D 26 26 10 42 42 42 00 42 42 26 26 26
$1FA0  41 13 1D 13 13 13 26 80 26 15 13 13 41 42 26 42
$1FB0  20 13 73 42 72 26 42 00 42 42 00 F3 0A F3 20 26
$1FC0  26 26 26 23 1D 1D 1D 1D 1D 00 00 42 42 42 1D 1D
$1FD0  1D 1D 40 26 1D 1D 04 1D 1D 1D F2 26 26 10 42 42
$1FE0  1D 1D B3 26 1D C0 C0 80 13 26 F0 26 26 B3 C4 13
$1FF0  C4 13 3F CF 33 13 00 00 42 26 26 10 13 26 C4 13

; ============================================================
; CHARSET $2000-$2800 (multicolor game charset)
; ============================================================

$2000  C4 FF 3F 3F CF CF C3 41 26 1D 0A FF 0A 26 00 00
$2010  00 0A 26 26 42 26 13 26 26 00 42 26 26 44 26 26
$2020  42 FF 00 44 42 42 1F C4 0A 00 0A 0A 26 42 0A C4
$2030  42 42 00 77 F7 26 41 26 01 42 42 42 00 17 C4 00
$2040  00 00 26 26 D7 00 00 5F 41 41 26 DF 26 26 26 00
$2050  0A 0A 42 42 42 42 21 42 42 26 00 00 00 F3 26 26
$2060  26 42 73 0A 0A 1D 26 26 26 26 55 26 42 21 42 1F
$2070  FF 00 41 00 42 26 26 42 1D 41 41 26 26 0A 75 C4
$2080  0A FF 7F 0A 42 42 42 26 26 00 26 26 00 75 00 0A
$2090  5D 5D 7D 7D 00 00 00 00 00 00 00 00 00 00 42 42
$20A0  26 26 1D 18 26 26 42 F3 F0 CC 42 26 27 42 F3 30
$20B0  3C C4 0A 42 FF F0 FF 00 42 42 26 21 21 1A 1D 1D
$20C0  1D 05 42 42 26 10 10 26 26 0A 14 0A FD 1D 1D DF
$20D0  0A 0A 1D 1D 20 00 00 42 26 10 0A D7 D7 42 42 42
$20E0  1D 42 42 FD 42 41 00 00 00 41 42 1F 26 42 1F B3
$20F0  26 1D 26 1D DF DD 42 42 55 44 44 4F FF 00 26 42
$2100  42 42 21 1F 1F 1F 1F 1F 73 1D 1D F7 26 26 F5 1F
$2110  1F 73 25 88 1F 26 26 26 26 F3 25 88 1F 1F 00 42
$2120  26 26 00 1F 1F 1F 00 1D 1D 1D 55 44 40 44 00 88
$2130  1F FF 1F 26 1F 72 26 44 00 73 73 73 73 00 00 00
$2140  00 73 73 73 73 00 00 00 00 73 73 73 73 00 00 00
$2150  00 1D D6 12 7F 1D 1D 26 26 26 26 26 53 26 0F 1F
$2160  26 26 26 1D 26 10 09 26 26 44 1F 1F 00 1F 26 1F
$2170  1F 00 26 10 1F 1F 20 64 1D B3 26 64 21 21 21 55
$2180  45 42 42 21 1F 26 26 26 B1 1F 42 1D 42 42 42 42
$2190  42 F5 D7 1F 1F 00 26 26 10 26 26 26 23 88 1F 00
$21A0  1D 1D 1D 41 26 26 1D 88 1F 00 26 26 FF F5 F7 B3
$21B0  26 72 1F 26 0F B1 B1 1D 1D 20 00 13 C4 FF 00 26
$21C0  1F 00 1F 26 F5 42 42 42 05 26 45 26 FF 1F 1F FF
$21D0  42 42 42 42 42 26 26 10 00 FF 00 7F 41 26 BC 26
$21E0  26 42 26 7B 26 26 26 26 FF FF FF FF FF 00 00 00
$21F0  00 00 00 00 00 00 00 00 00 00 00 00 00 42 26 26
$2200  10 26 CC 10 63 10 10 1A 00 10 D6 00 7B 10 10 00
$2210  44 44 44 44 44 44 44 15 7B 23 10 1D 10 00 10 42
$2220  10 10 42 F3 0A F3 AE 00 FF 00 B3 1D 10 10 26 26
$2230  B1 00 00 42 26 26 1D 45 45 42 42 A2 B7 57 7B 23
$2240  10 00 42 42 42 42 D5 23 10 45 26 26 B3 00 00 00
$2250  42 42 42 B1 45 42 42 4F 00 00 1D C4 C4 00 00 F3
$2260  10 45 10 42 00 00 10 10 0A 00 00 41 41 41 26 0A
$2270  00 00 55 00 00 00 A2 42 42 42 C4 FF 00 00 7B 23
$2280  10 42 10 00 42 42 26 FD 00 FF 00 42 45 42 42 26
$2290  B1 B1 1D 1D 40 42 42 FF 10 FC 10 1D 68 1A 1A 1A
$22A0  4E 00 00 00 00 1D 1D 26 FF 00 26 1D 1D F5 42 42
$22B0  42 41 10 44 26 29 21 26 26 26 26 42 42 42 42 42
$22C0  10 44 00 00 00 26 FF 00 21 00 F3 44 44 44 44 F3
$22D0  44 44 44 0A 0C 45 42 42 42 00 FF 00 42 FF 75 F5
$22E0  DD 00 00 00 C4 C4 00 00 44 42 42 26 42 42 B3 FF
$22F0  00 1D 00 00 FC FC 26 26 26 26 26 73 13 C4 FF 00
$2300  41 3F 0D 00 21 D5 44 40 44 0A D7 72 30 72 21 72
$2310  21 72 21 72 21 FF B3 26 05 00 00 08 00 42 0C 00
$2320  00 00 00 00 00 00 00 26 41 26 7F 75 00 42 85 4E
$2330  7F 00 26 5F 45 42 42 41 00 F3 26 DF 00 5F 5D 26
$2340  26 26 26 F3 42 42 41 42 42 1D F3 1D 1D 41 1D 1D
$2350  1D F3 42 42 1D 55 7F 1D 1D D6 00 1D 26 26 26 26
$2360  1D 1D 1D 1D F0 42 42 ED F0 42 27 00 26 0A 48 42
$2370  42 41 26 26 0A 21 21 26 42 B3 1D 26 26 5F 1D 1D
$2380  1D 26 26 26 26 26 26 72 42 42 72 07 42 1D 00 00
$2390  26 42 42 26 26 41 41 26 26 60 42 A2 44 72 21 26
$23A0  1D 1D 44 00 7D 7D D6 00 00 21 1D 26 26 55 45 44
$23B0  40 44 60 B3 26 01 57 42 B3 07 F5 21 72 21 5F 42
$23C0  42 21 00 0D 00 42 26 26 44 42 42 42 42 41 42 42
$23D0  24 24 00 00 26 26 1D 0F 42 42 42 42 07 07 C4 B3
$23E0  26 1D 42 42 41 1D 40 26 1D 1D 1D 14 14 45 42 42
$23F0  26 0D 00 26 42 42 42 21 26 26 26 26 0C 45 42 42
$2400  26 ED 42 42 0E 1D 1D 1D 1C 1F 00 0C 0E 24 0F B3
$2410  42 FF 41 26 41 26 21 B3 42 42 08 B3 42 91 42 26
$2420  26 C4 42 A2 A2 42 42 04 01 01 1D 40 44 60 1D 1D
$2430  72 08 42 D5 42 B3 42 26 42 B3 42 41 91 A2 B3 42
$2440  26 41 41 26 4F 26 21 A2 42 42 A2 D5 42 B3 42 42
$2450  B3 42 26 EF A2 A2 42 42 26 26 26 42 42 40 42 42
$2460  42 B3 D5 B1 1D 1D 20 B3 42 26 1D 1D 1D 4F 26 26
$2470  26 26 41 26 FF 0F 0F FF D6 0B 1D 1D 01 01 14 10
$2480  21 21 21 21 26 42 42 BE 41 41 26 1D 26 1F 1D 1D
$2490  26 42 60 26 26 BE 42 B3 26 26 21 50 1D 1D 06 60
$24A0  BE BE 4E 26 26 1D B3 26 88 0F 26 26 1D 7F 1D 3F
$24B0  26 26 26 1D 1D 1D F5 1D 41 21 21 21 26 42 42 1D
$24C0  B1 1D 1D 06 26 B3 26 7F 5F 5F D7 D7 42 1D 1D B1
$24D0  26 26 26 40 42 04 B3 1D 1D 1D 1D B3 26 04 1D 7C
$24E0  10 26 26 1D 1D 1D 1D 1D 1D 1D F0 26 B3 1D 1D 1D
$24F0  1D B3 26 1D 1D 1D 1D B3 26 B3 1D 1D 1D 1D B3 26
$2500  B3 1D B3 26 B3 41 1D 1D 1D 41 1D 1D 1D F2 0C 26
$2510  26 0C B3 B3 1D 01 BE 22 3C 41 1D 1D 1D 26 1D 1D
$2520  1D 1D FF C3 1D 1D C3 1D 1D FF 0F 33 0F 1D CE 1D
$2530  F2 33 33 10 26 26 40 00 64 B3 10 1D C0 10 10 26
$2540  26 60 21 04 C2 D3 ED 10 51 1D 21 21 21 0E 1D 54
$2550  26 26 26 60 60 60 BE 40 1D 1D 1D 1D 54 26 41 26
$2560  50 1D 1D 1D 1D 1D 40 B3 0D 18 B3 72 1D 1D 1D 1D
$2570  18 1C 1C 04 72 21 D6 1D 1D 72 08 1D F2 18 88 24
$2580  24 3F 9C 9C 3F B3 F3 D7 72 21 1D 0D 64 B3 1D 7F
$2590  1D 08 7F 1D 1D 1D 41 26 01 21 21 57 55 55 1D 1D
$25A0  72 26 01 1D 1D 1D 1D 1D 04 06 44 44 F3 B3 64 B3
$25B0  64 B3 64 B3 1D 1D 1D 01 44 44 44 9A 64 B3 1D DD
$25C0  64 64 B3 B3 1D 1D 26 F0 C4 C4 F0 B3 05 B3 1D B3
$25D0  B3 D5 B3 26 1D 1D 26 B3 B3 B3 41 26 01 F5 B3 B3
$25E0  B3 B3 1D DD 26 26 1D 1D 1D 1D 1D 1D 01 B3 1D 26
$25F0  26 05 1D 1D 1D B3 26 B3 F3 26 F3 1D 41 1D 1D 1D
$2600  44 5D 41 41 26 26 01 26 26 01 F2 F0 C0 F0 F0 26
$2610  26 26 1D 1D 1D 1D 60 F2 F2 F2 F2 1C 14 F6 F2 26
$2620  1D 1D 1D 18 26 26 21 F2 D6 F2 E3 F2 01 F2 F2 10
$2630  10 1D 1D 1D 1D 1D 72 21 1A 40 54 E3 E3 E3 E3 1C
$2640  1C 14 1C 28 1C 0E 26 1D F2 01 1D 1D 26 01 F2 0C
$2650  26 26 01 1D 1D 1D 50 F2 16 1A 0F 1A CE 15 26 1D
$2660  B1 1D 1D 15 F5 D5 41 41 26 1D F3 0A F3 AE D7 26
$2670  26 40 1D 1D 1D 1D 1D 26 26 26 26 0E 7C F2 F2 F2
$2680  F2 FC F2 F6 F2 F2 F2 F2 F2 3C F2 F2 F2 F2 F2 F2
$2690  F6 F2 F2 F2 F2 0C F2 F6 F2 F2 F2 F0 F2 CC F6 F2
$26A0  F6 F2 FF 26 26 1D F2 F2 F2 FF F2 1D 1D 7F 1D F0
$26B0  F2 CC 0C CC F2 F2 FF 0C 26 21 26 1D F2 FF 72 72
$26C0  21 21 7F 0C FF C3 CC C3 26 26 4E FF CC CC 7F 1D
$26D0  1D 08 FF 04 05 C0 C1 C1 26 26 1D 41 26 01 26 7F
$26E0  11 11 F2 26 F2 26 1D 1D 44 26 26 26 41 41 D6 13
$26F0  1D 1D 26 26 7F 05 D6 16 55 72 21 1D F2 41 41 26
$2700  26 26 26 BC BC 01 01 21 1D 1D 05 1D 1D 21 BC 53
$2710  01 01 18 01 53 40 40 44 4F 1D 1D 1D 44 40 44 4F
$2720  01 01 28 60 60 1D 1D 72 44 1D 1D 0E 44 44 44 F3
$2730  01 01 BC 01 01 01 40 53 01 F3 01 26 BC 01 01 01
$2740  44 40 44 4F 01 01 01 53 01 44 01 01 DF 60 1D 1D
$2750  4F 01 DF DF 60 1D 1D 40 1D 1D F7 BC 01 01 44 5F
$2760  53 01 F7 44 40 44 0A 0A F3 0A 01 01 0A 01 F3 F3
$2770  F3 F3 F3 0A 1D 1D F7 01 26 0F 1D 0E 7F 1D 7F 1D
$2780  7F 1D 1D FC 7F 1D 1D 01 45 72 72 21 7F 01 26 04
$2790  21 21 21 50 50 45 45 BC 53 01 0E 26 0E 72 21 26
$27A0  1D 26 07 7F 1D 1D 1D 10 26 26 1D 1D 1D C9 50 1D
$27B0  1D 05 1D 1D 0E 72 21 26 1D 12 34 24 C1 01 1D 03
$27C0  01 09 FF 01 01 01 01 53 01 1D 72 21 5F 5F F3 0A
$27D0  F3 0A FD DD 5D 1D 1D 1D 57 57 10 26 26 1D FF 1D
$27E0  F5 1D 1D 1D 40 FF 7F 7F 1D 44 21 26 1D 1D D6 1D
$27F0  72 F3 F3 0A 01 40 1D F7 01 01 1D 40 44 60 1D 1D

; ============================================================
; GAME CODE $2800-$3000 (main entry)
; ============================================================

$2800  44           .byte $44 ; illegal
$2801  44           .byte $44 ; illegal
$2802  44           .byte $44 ; illegal
$2803  44           .byte $44 ; illegal
$2804  4F           .byte $4F ; illegal
$2805  0E 0E F7     ASL $F70E
$2808  F3           .byte $F3 ; illegal
$2809  F3           .byte $F3 ; illegal
$280A  F3           .byte $F3 ; illegal
$280B  0A           ASL A
$280C  0E 1D ED     ASL $ED1D
$280F  3D ED 00     AND $00ED,X
$2812  1D 1D 1D     ORA $1D1D,X
$2815  1D 1D 1D     ORA $1D1D,X
$2818  1D 1D F7     ORA $F71D,X
$281B  21 21        AND ($21,X)
$281D  21 F3        AND ($F3,X)
$281F  0E 72 F7     ASL $F772
$2822  07           .byte $07 ; illegal
$2823  07           .byte $07 ; illegal
$2824  04           .byte $04 ; illegal
$2825  40           RTI
$2826  63           .byte $63 ; illegal
$2827  40           RTI
$2828  04           .byte $04 ; illegal
$2829  0E 04 0E     ASL $0E04
$282C  F3           .byte $F3 ; illegal
$282D  0E 72 04     ASL $0472
$2830  0E 04 0E     ASL $0E04
$2833  F3           .byte $F3 ; illegal
$2834  0E 72 1D     ASL $1D72
$2837  1D D6 21     ORA $21D6,X
$283A  F3           .byte $F3 ; illegal
$283B  CA           DEX
$283C  CA           DEX
$283D  0E FF F0     ASL $F0FF
$2840  1D 7F 1D     ORA $1D7F,X
$2843  A2 21        LDX #$21
$2845  72           .byte $72 ; illegal
$2846  21 B5        AND ($B5,X)
$2848  21 21        AND ($21,X)
$284A  4B           .byte $4B ; illegal
$284B  21 72        AND ($72,X)
$284D  21 1D        AND ($1D,X)
$284F  72           .byte $72 ; illegal
$2850  21 1F        AND ($1F,X)
$2852  FF           .byte $FF ; illegal
$2853  FF           .byte $FF ; illegal
$2854  0F           .byte $0F ; illegal
$2855  0E 05 8F     ASL $8F05
$2858  0E 0E 0E     ASL $0E0E
$285B  0E C5 C4     ASL $C4C5
$285E  C4 C0        CPY $C0
$2860  50 50        BVC $28B2
$2862  41 40        EOR ($40,X)
$2864  40           RTI
$2865  0E 1D 1D     ASL $1D1D
$2868  1D B1 0E     ORA $0EB1,X
$286B  0E 26 26     ASL $2626
$286E  26 18        ROL $18
$2870  72           .byte $72 ; illegal
$2871  21 1D        AND ($1D,X)
$2873  54           .byte $54 ; illegal
$2874  21 72        AND ($72,X)
$2876  21 B1        AND ($B1,X)
$2878  26 26        ROL $26
$287A  54           .byte $54 ; illegal
$287B  4E 60 0E     LSR $0E60
$287E  21 21        AND ($21,X)
$2880  15 0E        ORA $0E,X
$2882  05 05        ORA $05
$2884  51 51        EOR ($51),Y
$2886  0E 12 1D     ASL $1D12
$2889  54           .byte $54 ; illegal
$288A  26 26        ROL $26
$288C  1D 0E A9     ORA $A90E,X
$288F  0E 0E A9     ASL $A90E
$2892  50 24        BVC $28B8
$2894  02           .byte $02 ; illegal
$2895  24 EA        BIT zp $EA
$2897  05 21        ORA $21
$2899  0F           .byte $0F ; illegal
$289A  0F           .byte $0F ; illegal
$289B  0F           .byte $0F ; illegal
$289C  AE AE AE     LDX $AEAE
$289F  AE 16 7F     LDX $7F16
$28A2  DF           .byte $DF ; illegal
$28A3  DF           .byte $DF ; illegal
$28A4  0E F7 F7     ASL $F7F7
$28A7  D7           .byte $D7 ; illegal
$28A8  0A           ASL A
$28A9  F3           .byte $F3 ; illegal
$28AA  FD F5 F5     SBC $F5F5,X
$28AD  F7           .byte $F7 ; illegal
$28AE  F7           .byte $F7 ; illegal
$28AF  DF           .byte $DF ; illegal
$28B0  0E 1D 7D     ASL $7D1D
$28B3  5D 44 44     EOR $4444,X
$28B6  44           .byte $44 ; illegal
$28B7  5F           .byte $5F ; illegal
$28B8  26 26        ROL $26
$28BA  26 5F        ROL $5F
$28BC  26 26        ROL $26
$28BE  B1 1D        LDA ($1D),Y
$28C0  1D 1D 26     ORA $261D,X
$28C3  26 0E        ROL $0E
$28C5  D7           .byte $D7 ; illegal
$28C6  D7           .byte $D7 ; illegal
$28C7  72           .byte $72 ; illegal
$28C8  20 72 21     JSR
$28CB  28           PLP
$28CC  72           .byte $72 ; illegal
$28CD  72           .byte $72 ; illegal
$28CE  21 AE        AND ($AE,X)
$28D0  72           .byte $72 ; illegal
$28D1  21 26        AND ($26,X)
$28D3  0E FA 21     ASL $21FA
$28D6  0E 26 26     ASL $2626
$28D9  B1 C4        LDA ($C4),Y
$28DB  FA           .byte $FA ; illegal
$28DC  FA           .byte $FA ; illegal
$28DD  36 36        ROL $36,X
$28DF  91 91        STA ($91),Y
$28E1  C4 C4        CPY $C4
$28E3  FA           .byte $FA ; illegal
$28E4  FA           .byte $FA ; illegal
$28E5  36 36        ROL $36,X
$28E7  91 91        STA ($91),Y
$28E9  44           .byte $44 ; illegal
$28EA  44           .byte $44 ; illegal
$28EB  28           PLP
$28EC  28           PLP
$28ED  72           .byte $72 ; illegal
$28EE  72           .byte $72 ; illegal
$28EF  21 21        AND ($21,X)
$28F1  44           .byte $44 ; illegal
$28F2  44           .byte $44 ; illegal
$28F3  28           PLP
$28F4  28           PLP
$28F5  72           .byte $72 ; illegal
$28F6  72           .byte $72 ; illegal
$28F7  21 21        AND ($21,X)
$28F9  44           .byte $44 ; illegal
$28FA  44           .byte $44 ; illegal
$28FB  28           PLP
$28FC  28           PLP
$28FD  72           .byte $72 ; illegal
$28FE  72           .byte $72 ; illegal
$28FF  21 21        AND ($21,X)
$2901  44           .byte $44 ; illegal
$2902  44           .byte $44 ; illegal
$2903  28           PLP
$2904  28           PLP
$2905  72           .byte $72 ; illegal
$2906  72           .byte $72 ; illegal
$2907  21 21        AND ($21,X)
$2909  1D 72 1F     ORA $1F72,X
$290C  21 1F        AND ($1F,X)
$290E  1D BE 1D     ORA $1DBE,X
$2911  1D 1D 0F     ORA $0F1D,X
$2914  1D B1 1D     ORA $1DB1,X
$2917  1D 1D 1D     ORA $1D1D,X
$291A  1D 0F 1D     ORA $1D0F,X
$291D  B1 1D        LDA ($1D),Y
$291F  1D E5 0F     ORA $0FE5,X
$2922  1D 0F 1D     ORA $1D0F,X
$2925  B1 1D        LDA ($1D),Y
$2927  1D 9A F0     ORA $F09A,X
$292A  1D 0F 0F     ORA $0F0F,X
$292D  B1 B1        LDA ($B1),Y
$292F  1D 1D 3E     ORA $3E1D,X
$2932  8F           .byte $8F ; illegal
$2933  0F           .byte $0F ; illegal
$2934  1D B1 1D     ORA $1DB1,X
$2937  1D 03 FF     ORA $FF03,X
$293A  21 26        AND ($26,X)
$293C  26 26        ROL $26
$293E  26 1D        ROL $1D
$2940  1D 00 C4     ORA $C400,X
$2943  C4 C4        CPY $C4
$2945  31 0E        AND ($0E),Y
$2947  10 0E        BPL $2957
$2949  0E 0E 0E     ASL $0E0E
$294C  04           .byte $04 ; illegal
$294D  15 11        ORA $11,X
$294F  B1 1D        LDA ($1D),Y
$2951  1D B1 26     ORA $26B1,X
$2954  0C           .byte $0C ; illegal
$2955  15 51        ORA $51,X
$2957  26 00        ROL $00
$2959  26 D6        ROL $D6
$295B  44           .byte $44 ; illegal
$295C  44           .byte $44 ; illegal
$295D  15 D6        ORA $D6,X
$295F  1D 26 26     ORA $2626,X
$2962  26 50        ROL $50
$2964  1D 1D 1D     ORA $1D1D,X
$2967  C4 7F        CPY $7F
$2969  1D 44 26     ORA $2644,X
$296C  21 7F        AND ($7F,X)
$296E  7F           .byte $7F ; illegal
$296F  7F           .byte $7F ; illegal
$2970  1D 44 26     ORA $2644,X
$2973  26 26        ROL $26
$2975  06 1A        ASL $1A
$2977  1A           .byte $1A ; illegal
$2978  1A           .byte $1A ; illegal
$2979  0F           .byte $0F ; illegal
$297A  21 3F        AND ($3F,X)
$297C  3F           .byte $3F ; illegal
$297D  7F           .byte $7F ; illegal
$297E  1D 60 F5     ORA $F560,X
$2981  26 26        ROL $26
$2983  F3           .byte $F3 ; illegal
$2984  10 26        BPL $29AC
$2986  26 55        ROL $55
$2988  26 26        ROL $26
$298A  26 5F        ROL $5F
$298C  DF           .byte $DF ; illegal
$298D  7F           .byte $7F ; illegal
$298E  75 26        ADC $26,X
$2990  1D F7 57     ORA $57F7,X
$2993  F5 DD        SBC $DD,X
$2995  5F           .byte $5F ; illegal
$2996  21 57        AND ($57,X)
$2998  26 26        ROL $26
$299A  AE 21 26     LDX $2621
$299D  26 5F        ROL $5F
$299F  D7           .byte $D7 ; illegal
$29A0  57           .byte $57 ; illegal
$29A1  57           .byte $57 ; illegal
$29A2  5F           .byte $5F ; illegal
$29A3  26 1D        ROL $1D
$29A5  23           .byte $23 ; illegal
$29A6  0A           ASL A
$29A7  F3           .byte $F3 ; illegal
$29A8  08           PHP
$29A9  B7           .byte $B7 ; illegal
$29AA  AE AE AE     LDX $AEAE
$29AD  AE FF CF     LDX $CFFF
$29B0  CF           .byte $CF ; illegal
$29B1  21 1D        AND ($1D,X)
$29B3  F2           .byte $F2 ; illegal
$29B4  F2           .byte $F2 ; illegal
$29B5  26 1D        ROL $1D
$29B7  F3           .byte $F3 ; illegal
$29B8  F3           .byte $F3 ; illegal
$29B9  B5 B5        LDA $B5,X
$29BB  24 1F        BIT zp $1F
$29BD  21 C4        AND ($C4,X)
$29BF  CA           DEX
$29C0  B1 1D        LDA ($1D),Y
$29C2  1D 00 1F     ORA $1F00,X
$29C5  21 1F        AND ($1F,X)
$29C7  21 C4        AND ($C4,X)
$29C9  4B           .byte $4B ; illegal
$29CA  C4 4B        CPY $4B
$29CC  C4 4B        CPY $4B
$29CE  C4 4B        CPY $4B
$29D0  1F           .byte $1F ; illegal
$29D1  21 1F        AND ($1F,X)
$29D3  21 1F        AND ($1F,X)
$29D5  21 1F        AND ($1F,X)
$29D7  21 C4        AND ($C4,X)
$29D9  4B           .byte $4B ; illegal
$29DA  C4 4B        CPY $4B
$29DC  C4 4B        CPY $4B
$29DE  C4 4B        CPY $4B
$29E0  1F           .byte $1F ; illegal
$29E1  21 1F        AND ($1F,X)
$29E3  21 1F        AND ($1F,X)
$29E5  21 1F        AND ($1F,X)
$29E7  21 8C        AND ($8C,X)
$29E9  8A           TXA
$29EA  B1 1D        LDA ($1D),Y
$29EC  1D E9 FF     ORA $FFE9,X
$29EF  7F           .byte $7F ; illegal
$29F0  7F           .byte $7F ; illegal
$29F1  1D FF 7F     ORA $7FFF,X
$29F4  7F           .byte $7F ; illegal
$29F5  1D 8C 8F     ORA $8F8C,X
$29F8  7F           .byte $7F ; illegal
$29F9  1D 7F 1D     ORA $1D7F,X
$29FC  1D 10 26     ORA $2610,X
$29FF  26 BE        ROL $BE
$2A01  F3           .byte $F3 ; illegal
$2A02  F0 0B        BEQ $2A0F
$2A04  7F           .byte $7F ; illegal
$2A05  7F           .byte $7F ; illegal
$2A06  1D F0 06     ORA $06F0,X
$2A09  FF           .byte $FF ; illegal
$2A0A  0C           .byte $0C ; illegal
$2A0B  26 85        ROL $85
$2A0D  85 85        STA $85
$2A0F  CE 26 C0     DEC $C026
$2A12  60           RTS
$2A13  4E 60 00     LSR $0060
$2A16  0C           .byte $0C ; illegal
$2A17  26 BE        ROL $BE
$2A19  0C           .byte $0C ; illegal
$2A1A  26 18        ROL $18
$2A1C  26 0C        ROL $0C
$2A1E  26 26        ROL $26
$2A20  54           .byte $54 ; illegal
$2A21  38           SEC
$2A22  BE BE 18     LDX $18BE,Y
$2A25  0C           .byte $0C ; illegal
$2A26  26 BE        ROL $BE
$2A28  26 B1        ROL $B1
$2A2A  26 05        ROL $05
$2A2C  26 1D        ROL $1D
$2A2E  0C           .byte $0C ; illegal
$2A2F  26 B1        ROL $B1
$2A31  26 1D        ROL $1D
$2A33  50 51        BVC $2A86
$2A35  41 41        EOR ($41,X)
$2A37  11 05        ORA ($05),Y
$2A39  05 1D        ORA $1D
$2A3B  05 D6        ORA $D6
$2A3D  10 B1        BPL $29F0
$2A3F  03           .byte $03 ; illegal
$2A40  03           .byte $03 ; illegal
$2A41  43           .byte $43 ; illegal
$2A42  53           .byte $53 ; illegal
$2A43  1D 1D 1D     ORA $1D1D,X
$2A46  B1 1D        LDA ($1D),Y
$2A48  1D 00 1D     ORA $1D00,X
$2A4B  1D 0F 0A     ORA $0A0F,X
$2A4E  F3           .byte $F3 ; illegal
$2A4F  AE 26 26     LDX $2626
$2A52  26 57        ROL $57
$2A54  57           .byte $57 ; illegal
$2A55  55 57        EOR $57,X
$2A57  57           .byte $57 ; illegal
$2A58  F5 26        SBC $26,X
$2A5A  26 D5        ROL $D5
$2A5C  D5 55        CMP $55,X
$2A5E  D5 D5        CMP $D5,X
$2A60  1D 1D 1D     ORA $1D1D,X
$2A63  7F           .byte $7F ; illegal
$2A64  B1 1D        LDA ($1D),Y
$2A66  1D F3 26     ORA $26F3,X
$2A69  26 26        ROL $26
$2A6B  5F           .byte $5F ; illegal
$2A6C  1D 1D 55     ORA $551D,X
$2A6F  5F           .byte $5F ; illegal
$2A70  26 26        ROL $26
$2A72  44           .byte $44 ; illegal
$2A73  1D 44 44     ORA $4444,X
$2A76  44           .byte $44 ; illegal
$2A77  44           .byte $44 ; illegal
$2A78  F3           .byte $F3 ; illegal
$2A79  B1 1D        LDA ($1D),Y
$2A7B  1D 7F 1D     ORA $1D7F,X
$2A7E  1A           .byte $1A ; illegal
$2A7F  26 26        ROL $26
$2A81  BE B7 26     LDX $26B7,Y
$2A84  26 FF        ROL $FF
$2A86  26 BE        ROL $BE
$2A88  AE AE AE     LDX $AEAE
$2A8B  FF           .byte $FF ; illegal
$2A8C  F2           .byte $F2 ; illegal
$2A8D  F2           .byte $F2 ; illegal
$2A8E  26 B1        ROL $B1
$2A90  1D 1D CA     ORA $CA1D,X
$2A93  26 26        ROL $26
$2A95  A7           .byte $A7 ; illegal
$2A96  A7           .byte $A7 ; illegal
$2A97  A7           .byte $A7 ; illegal
$2A98  A7           .byte $A7 ; illegal
$2A99  26 26        ROL $26
$2A9B  26 26        ROL $26
$2A9D  A7           .byte $A7 ; illegal
$2A9E  A7           .byte $A7 ; illegal
$2A9F  A7           .byte $A7 ; illegal
$2AA0  A7           .byte $A7 ; illegal
$2AA1  26 26        ROL $26
$2AA3  26 26        ROL $26
$2AA5  A7           .byte $A7 ; illegal
$2AA6  A7           .byte $A7 ; illegal
$2AA7  A7           .byte $A7 ; illegal
$2AA8  A7           .byte $A7 ; illegal
$2AA9  26 26        ROL $26
$2AAB  26 26        ROL $26
$2AAD  44           .byte $44 ; illegal
$2AAE  8A           TXA
$2AAF  B1 1D        LDA ($1D),Y
$2AB1  1D 9A 7F     ORA $7F9A,X
$2AB4  1D A2 B1     ORA $B1A2,X
$2AB7  1D 1D B1     ORA $B11D,X
$2ABA  1D 44 8F     ORA $8F44,X
$2ABD  20 0C 26     JSR
$2AC0  98           TYA
$2AC1  20 0C 26     JSR
$2AC4  40           RTI
$2AC5  B1 1D        LDA ($1D),Y
$2AC7  1D B1 26     ORA $26B1,X
$2ACA  1D 26 40     ORA $4026,X
$2ACD  B1 1D        LDA ($1D),Y
$2ACF  1D 3E F3     ORA $F33E,X
$2AD2  F3           .byte $F3 ; illegal
$2AD3  1D 40 B1     ORA $B140,X
$2AD6  1D 1D C0     ORA $C01D,X
$2AD9  1D 1D 29     ORA $291D,X
$2ADC  2A           ROL A
$2ADD  FF           .byte $FF ; illegal
$2ADE  1D C0 1D     ORA $1DC0,X
$2AE1  26 F1        ROL $F1
$2AE3  F1 1D        SBC ($1D),Y
$2AE5  FC           .byte $FC ; illegal
$2AE6  1D 00 C4     ORA $C400,X
$2AE9  C4 31        CPY $31
$2AEB  26 0C        ROL $0C
$2AED  26 1D        ROL $1D
$2AEF  BE 7F 1D     LDX $1D7F,Y
$2AF2  44           .byte $44 ; illegal
$2AF3  55 BE        EOR $BE,X
$2AF5  BE BE 01     LDX $01BE,Y
$2AF8  1D 1D 1D     ORA $1D1D,X
$2AFB  0F           .byte $0F ; illegal
$2AFC  1D B1 1D     ORA $1DB1,X
$2AFF  1D 1D 1D     ORA $1D1D,X
$2B02  BE 00 B1     LDX $B100,Y
$2B05  B1 7F        LDA ($7F),Y
$2B07  B1 DB        LDA ($DB),Y
$2B09  06 1D        ASL $1D
$2B0B  1D 1A 44     ORA $441A,X
$2B0E  1D 1D 1D     ORA $1D1D,X
$2B11  54           .byte $54 ; illegal
$2B12  54           .byte $54 ; illegal
$2B13  B1 B1        LDA ($B1),Y
$2B15  44           .byte $44 ; illegal
$2B16  40           RTI
$2B17  40           RTI
$2B18  44           .byte $44 ; illegal
$2B19  F3           .byte $F3 ; illegal
$2B1A  3D 0D 0D     AND $0D0D,X
$2B1D  41 B1        EOR ($B1,X)
$2B1F  1D 07 5F     ORA $5F07,X
$2B22  D5 D5        CMP $D5,X
$2B24  B1 06        LDA ($06),Y
$2B26  D7           .byte $D7 ; illegal
$2B27  B1 1D        LDA ($1D),Y
$2B29  B1 5F        LDA ($5F),Y
$2B2B  B1 55        LDA ($55),Y
$2B2D  B1 44        LDA ($44),Y
$2B2F  5F           .byte $5F ; illegal
$2B30  55 B1        EOR $B1,X
$2B32  F5 5F        SBC $5F,X
$2B34  9A           TXS
$2B35  B1 1D        LDA ($1D),Y
$2B37  F5 F5        SBC $F5,X
$2B39  0A           ASL A
$2B3A  F3           .byte $F3 ; illegal
$2B3B  20 44 40     JSR
$2B3E  44           .byte $44 ; illegal
$2B3F  F3           .byte $F3 ; illegal
$2B40  D6 11        DEC $11,X
$2B42  FF           .byte $FF ; illegal
$2B43  C0 B1        CPY #$B1
$2B45  C4 C1        CPY $C1
$2B47  C4 C0        CPY $C0
$2B49  FF           .byte $FF ; illegal
$2B4A  F0 E9        BEQ $2B35
$2B4C  E9 00        SBC #$00
$2B4E  00           BRK
$2B4F  B1 B1        LDA ($B1),Y
$2B51  B1 0F        LDA ($0F),Y
$2B53  E9 EE        SBC #$EE
$2B55  00           BRK
$2B56  9A           TXS
$2B57  B1 E5        LDA ($E5),Y
$2B59  9A           TXS
$2B5A  B1 7F        LDA ($7F),Y
$2B5C  EE 00 9A     INC $9A00
$2B5F  B1 9A        LDA ($9A),Y
$2B61  B1 E9        LDA ($E9),Y
$2B63  0B           .byte $0B ; illegal
$2B64  7B           .byte $7B ; illegal
$2B65  0B           .byte $0B ; illegal
$2B66  E5 3E        SBC $3E
$2B68  E5 3E        SBC $3E
$2B6A  7F           .byte $7F ; illegal
$2B6B  E9 7F        SBC #$7F
$2B6D  E9 9A        SBC #$9A
$2B6F  B1 9A        LDA ($9A),Y
$2B71  B1 7F        LDA ($7F),Y
$2B73  E9 7F        SBC #$7F
$2B75  E9 9A        SBC #$9A
$2B77  B1 9A        LDA ($9A),Y
$2B79  B1 4E        LDA ($4E),Y
$2B7B  1D B1 42     ORA $42B1,X
$2B7E  12           .byte $12 ; illegal
$2B7F  42           .byte $42 ; illegal
$2B80  1D C0 1D     ORA $1DC0,X
$2B83  7F           .byte $7F ; illegal
$2B84  1D 84 1D     ORA $1D84,X
$2B87  1D 80 4E     ORA $4E80,X
$2B8A  4E EB B1     LSR $B1EB
$2B8D  1D 1D 1D     ORA $1D1D,X
$2B90  03           .byte $03 ; illegal
$2B91  C0 00        CPY #$00
$2B93  48           PHA
$2B94  1D 1D 8C     ORA $8C1D,X
$2B97  00           BRK
$2B98  00           BRK
$2B99  00           BRK
$2B9A  00           BRK
$2B9B  45 05        EOR $05
$2B9D  11 00        ORA ($00),Y
$2B9F  11 C0        ORA ($C0),Y
$2BA1  F0 FC        BEQ $2B9F
$2BA3  7F           .byte $7F ; illegal
$2BA4  1D 44 C4     ORA $C444,X
$2BA7  13           .byte $13 ; illegal
$2BA8  C4 BE        CPY $BE
$2BAA  DB           .byte $DB ; illegal
$2BAB  DB           .byte $DB ; illegal
$2BAC  70           .byte $70 ; illegal
$2BAD  55 01        EOR $01,X
$2BAF  28           PLP
$2BB0  E3           .byte $E3 ; illegal
$2BB1  E3           .byte $E3 ; illegal
$2BB2  55 B1        EOR $B1,X
$2BB4  54           .byte $54 ; illegal
$2BB5  13           .byte $13 ; illegal
$2BB6  C4 BE        CPY $BE
$2BB8  B1 7F        LDA ($7F),Y
$2BBA  7F           .byte $7F ; illegal
$2BBB  1D 40 60     ORA $6040,X
$2BBE  BE BE 2A     LDX $2ABE,Y
$2BC1  7F           .byte $7F ; illegal
$2BC2  7F           .byte $7F ; illegal
$2BC3  1D 1D 1D     ORA $1D1D,X
$2BC6  44           .byte $44 ; illegal
$2BC7  40           RTI
$2BC8  44           .byte $44 ; illegal
$2BC9  05 1D        ORA $1D
$2BCB  1D 1D 75     ORA $751D,X
$2BCE  1D 09 1D     ORA $1D09,X
$2BD1  57           .byte $57 ; illegal
$2BD2  1D 1D 55     ORA $551D,X
$2BD5  51 B1        EOR ($B1),Y
$2BD7  54           .byte $54 ; illegal
$2BD8  54           .byte $54 ; illegal
$2BD9  7F           .byte $7F ; illegal
$2BDA  1D 1D 7F     ORA $7F1D,X
$2BDD  7D B1 0F     ADC $0FB1,X
$2BE0  03           .byte $03 ; illegal
$2BE1  1D 00 54     ORA $5400,X
$2BE4  D7           .byte $D7 ; illegal
$2BE5  1D 5F DF     ORA $DF5F,X
$2BE8  7F           .byte $7F ; illegal
$2BE9  1D 10 0F     ORA $0F10,X
$2BEC  B1 1D        LDA ($1D),Y
$2BEE  1D 40 15     ORA $1540,X
$2BF1  20 3F 00     JSR
$2BF4  44           .byte $44 ; illegal
$2BF5  44           .byte $44 ; illegal
$2BF6  9A           TXS
$2BF7  7F           .byte $7F ; illegal
$2BF8  1D 44 F3     ORA $F344,X
$2BFB  F3           .byte $F3 ; illegal
$2BFC  FF           .byte $FF ; illegal
$2BFD  7F           .byte $7F ; illegal
$2BFE  7F           .byte $7F ; illegal
$2BFF  1D 44 44     ORA $4444,X
$2C02  4F           .byte $4F ; illegal
$2C03  1B           .byte $1B ; illegal
$2C04  1D D6 8C     ORA $8CD6,X
$2C07  CA           DEX
$2C08  C0 C2        CPY #$C2
$2C0A  F2           .byte $F2 ; illegal
$2C0B  F2           .byte $F2 ; illegal
$2C0C  1D 8C A2     ORA $A28C,X
$2C0F  B5 B5        LDA $B5,X
$2C11  24 84        BIT zp $84
$2C13  1D 8C 8A     ORA $8A8C,X
$2C16  80           .byte $80 ; illegal
$2C17  03           .byte $03 ; illegal
$2C18  1D 43 1D     ORA $1D43,X
$2C1B  8C A3 03     STY $03A3
$2C1E  1D 1D FF     ORA $FF1D,X
$2C21  29 29        AND #$29
$2C23  29 29        AND #$29
$2C25  1D 1D 1D     ORA $1D1D,X
$2C28  1D 1D 1D     ORA $1D1D,X
$2C2B  1D 1D F0     ORA $F01D,X
$2C2E  1D 4F F3     ORA $F34F,X
$2C31  F3           .byte $F3 ; illegal
$2C32  40           RTI
$2C33  44           .byte $44 ; illegal
$2C34  4F           .byte $4F ; illegal
$2C35  CF           .byte $CF ; illegal
$2C36  CF           .byte $CF ; illegal
$2C37  F0 44        BEQ $2C7D
$2C39  1D 00 8C     ORA $8C00,X
$2C3C  F0 8C        BEQ $2BCA
$2C3E  F0 00        BEQ $2C40
$2C40  1D D6 53     ORA $53D6,X
$2C43  21 53        AND ($53,X)
$2C45  FF           .byte $FF ; illegal
$2C46  C0 D6        CPY #$D6
$2C48  05 15        ORA $15
$2C4A  1D 1D 44     ORA $441D,X
$2C4D  00           BRK
$2C4E  10 D6        BPL $2C26
$2C50  00           BRK
$2C51  1D 44 04     ORA $0444,X
$2C54  F0 F0        BEQ $2C46
$2C56  CF           .byte $CF ; illegal
$2C57  01 15        ORA ($15,X)
$2C59  1D 44 1D     ORA $1D44,X
$2C5C  CF           .byte $CF ; illegal
$2C5D  1D 40 15     ORA $1540,X
$2C60  15 15        ORA $15,X
$2C62  40           RTI
$2C63  1C           .byte $1C ; illegal
$2C64  1C           .byte $1C ; illegal
$2C65  1C           .byte $1C ; illegal
$2C66  04           .byte $04 ; illegal
$2C67  60           RTS
$2C68  60           RTS
$2C69  6D 04 04     ADC $0404
$2C6C  1D 50 1D     ORA $1D50,X
$2C6F  40           RTI
$2C70  44           .byte $44 ; illegal
$2C71  05 44        ORA $44
$2C73  15 15        ORA $15,X
$2C75  1D 1D 1D     ORA $1D1D,X
$2C78  1D 1D D7     ORA $D71D,X
$2C7B  40           RTI
$2C7C  44           .byte $44 ; illegal
$2C7D  4F           .byte $4F ; illegal
$2C7E  1D 57 F5     ORA $F557,X
$2C81  5D 1D CF     EOR $CF1D,X
$2C84  75 D5        ADC $D5,X
$2C86  5D 1D 75     EOR $751D,X
$2C89  CF           .byte $CF ; illegal
$2C8A  1D AE 1D     ORA $1DAE,X
$2C8D  44           .byte $44 ; illegal
$2C8E  DD 57 5D     CMP $5D57,X
$2C91  1D 4F 44     ORA $444F,X
$2C94  40           RTI
$2C95  44           .byte $44 ; illegal
$2C96  77           .byte $77 ; illegal
$2C97  44           .byte $44 ; illegal
$2C98  75 44        ADC $44,X
$2C9A  5F           .byte $5F ; illegal
$2C9B  44           .byte $44 ; illegal
$2C9C  44           .byte $44 ; illegal
$2C9D  F3           .byte $F3 ; illegal
$2C9E  44           .byte $44 ; illegal
$2C9F  57           .byte $57 ; illegal
$2CA0  75 DD        ADC $DD,X
$2CA2  1D 1D D6     ORA $D61D,X
$2CA5  05 44        ORA $44
$2CA7  DD 7F FD     CMP $FD7F,X
$2CAA  0F           .byte $0F ; illegal
$2CAB  43           .byte $43 ; illegal
$2CAC  1D 54 D5     ORA $D554,X
$2CAF  75 FD        ADC $FD,X
$2CB1  40           RTI
$2CB2  44           .byte $44 ; illegal
$2CB3  4F           .byte $4F ; illegal
$2CB4  3F           .byte $3F ; illegal
$2CB5  0F           .byte $0F ; illegal
$2CB6  CF           .byte $CF ; illegal
$2CB7  DF           .byte $DF ; illegal
$2CB8  44           .byte $44 ; illegal
$2CB9  20 0A 44     JSR
$2CBC  40           RTI
$2CBD  44           .byte $44 ; illegal
$2CBE  F7           .byte $F7 ; illegal
$2CBF  AE AE D6     LDX $D6AE
$2CC2  06 44        ASL $44
$2CC4  4F           .byte $4F ; illegal
$2CC5  18           CLC
$2CC6  00           BRK
$2CC7  1D F2 F2     ORA $F2F2,X
$2CCA  B3           .byte $B3 ; illegal
$2CCB  F0 F0        BEQ $2CBD
$2CCD  00           BRK
$2CCE  B7           .byte $B7 ; illegal
$2CCF  81 84        STA ($84,X)
$2CD1  80           .byte $80 ; illegal
$2CD2  F0 F0        BEQ $2CC4
$2CD4  F0 00        BEQ $2CD6
$2CD6  7F           .byte $7F ; illegal
$2CD7  13           .byte $13 ; illegal
$2CD8  43           .byte $43 ; illegal
$2CD9  03           .byte $03 ; illegal
$2CDA  40           RTI
$2CDB  44           .byte $44 ; illegal
$2CDC  4F           .byte $4F ; illegal
$2CDD  44           .byte $44 ; illegal
$2CDE  4F           .byte $4F ; illegal
$2CDF  1D 60 5D     ORA $5D60,X
$2CE2  40           RTI
$2CE3  44           .byte $44 ; illegal
$2CE4  60           RTS
$2CE5  44           .byte $44 ; illegal
$2CE6  4F           .byte $4F ; illegal
$2CE7  D7           .byte $D7 ; illegal
$2CE8  55 D5        EOR $D5,X
$2CEA  DD 55 44     CMP $4455,X
$2CED  AE 08 55     LDX $5508
$2CF0  F0 00        BEQ $2CF2
$2CF2  C4 54        CPY $54
$2CF4  0E C9 0E     ASL $0EC9
$2CF7  BE 44 1D     LDX $1D44,Y
$2CFA  40           RTI
$2CFB  44           .byte $44 ; illegal
$2CFC  45 44        EOR $44
$2CFE  40           RTI
$2CFF  44           .byte $44 ; illegal
$2D00  41 41        EOR ($41,X)
$2D02  05 44        ORA $44
$2D04  04           .byte $04 ; illegal
$2D05  45 00        EOR $00
$2D07  40           RTI
$2D08  4F           .byte $4F ; illegal
$2D09  4F           .byte $4F ; illegal
$2D0A  55 15        EOR $15,X
$2D0C  05 57        ORA $57
$2D0E  4F           .byte $4F ; illegal
$2D0F  5D DF 57     EOR $57DF,X
$2D12  77           .byte $77 ; illegal
$2D13  5F           .byte $5F ; illegal
$2D14  57           .byte $57 ; illegal
$2D15  04           .byte $04 ; illegal
$2D16  4F           .byte $4F ; illegal
$2D17  00           BRK
$2D18  04           .byte $04 ; illegal
$2D19  4F           .byte $4F ; illegal
$2D1A  4F           .byte $4F ; illegal
$2D1B  4F           .byte $4F ; illegal
$2D1C  4F           .byte $4F ; illegal
$2D1D  4F           .byte $4F ; illegal
$2D1E  4F           .byte $4F ; illegal
$2D1F  4F           .byte $4F ; illegal
$2D20  F3           .byte $F3 ; illegal
$2D21  75 4F        ADC $4F,X
$2D23  04           .byte $04 ; illegal
$2D24  4F           .byte $4F ; illegal
$2D25  F3           .byte $F3 ; illegal
$2D26  F3           .byte $F3 ; illegal
$2D27  F3           .byte $F3 ; illegal
$2D28  5D F3 20     EOR $20F3,X
$2D2B  4F           .byte $4F ; illegal
$2D2C  4F           .byte $4F ; illegal
$2D2D  57           .byte $57 ; illegal
$2D2E  5F           .byte $5F ; illegal
$2D2F  4F           .byte $4F ; illegal
$2D30  06 4F        ASL $4F
$2D32  4F           .byte $4F ; illegal
$2D33  F3           .byte $F3 ; illegal
$2D34  F3           .byte $F3 ; illegal
$2D35  F3           .byte $F3 ; illegal
$2D36  00           BRK
$2D37  DF           .byte $DF ; illegal
$2D38  4F           .byte $4F ; illegal
$2D39  4F           .byte $4F ; illegal
$2D3A  0A           ASL A
$2D3B  D2           .byte $D2 ; illegal
$2D3C  4F           .byte $4F ; illegal
$2D3D  4F           .byte $4F ; illegal
$2D3E  F3           .byte $F3 ; illegal
$2D3F  F3           .byte $F3 ; illegal
$2D40  F3           .byte $F3 ; illegal
$2D41  7D FD 4F     ADC $4FFD,X
$2D44  AE 05 0A     LDX $0A05
$2D47  F3           .byte $F3 ; illegal
$2D48  77           .byte $77 ; illegal
$2D49  4F           .byte $4F ; illegal
$2D4A  4F           .byte $4F ; illegal
$2D4B  F3           .byte $F3 ; illegal
$2D4C  F5 F5        SBC $F5,X
$2D4E  77           .byte $77 ; illegal
$2D4F  F3           .byte $F3 ; illegal
$2D50  AE 06 F7     LDX $F706
$2D53  77           .byte $77 ; illegal
$2D54  F7           .byte $F7 ; illegal
$2D55  AE 08 7B     LDX $7B08
$2D58  4F           .byte $4F ; illegal
$2D59  17           .byte $17 ; illegal
$2D5A  AE AE AE     LDX $AEAE
$2D5D  3F           .byte $3F ; illegal
$2D5E  B7           .byte $B7 ; illegal
$2D5F  4F           .byte $4F ; illegal
$2D60  4F           .byte $4F ; illegal
$2D61  60           RTS
$2D62  F3           .byte $F3 ; illegal
$2D63  0A           ASL A
$2D64  60           RTS
$2D65  60           RTS
$2D66  60           RTS
$2D67  60           RTS
$2D68  60           RTS
$2D69  60           RTS
$2D6A  60           RTS
$2D6B  15 15        ORA $15,X
$2D6D  15 15        ORA $15,X
$2D6F  15 15        ORA $15,X
$2D71  15 15        ORA $15,X
$2D73  14           .byte $14 ; illegal
$2D74  14           .byte $14 ; illegal
$2D75  14           .byte $14 ; illegal
$2D76  14           .byte $14 ; illegal
$2D77  14           .byte $14 ; illegal
$2D78  14           .byte $14 ; illegal
$2D79  14           .byte $14 ; illegal
$2D7A  14           .byte $14 ; illegal
$2D7B  4F           .byte $4F ; illegal
$2D7C  4F           .byte $4F ; illegal
$2D7D  4F           .byte $4F ; illegal
$2D7E  4F           .byte $4F ; illegal
$2D7F  4F           .byte $4F ; illegal
$2D80  4F           .byte $4F ; illegal
$2D81  4F           .byte $4F ; illegal
$2D82  4F           .byte $4F ; illegal
$2D83  60           RTS
$2D84  60           RTS
$2D85  60           RTS
$2D86  60           RTS
$2D87  60           RTS
$2D88  60           RTS
$2D89  60           RTS
$2D8A  60           RTS
$2D8B  15 15        ORA $15,X
$2D8D  15 15        ORA $15,X
$2D8F  15 15        ORA $15,X
$2D91  15 15        ORA $15,X
$2D93  14           .byte $14 ; illegal
$2D94  14           .byte $14 ; illegal
$2D95  14           .byte $14 ; illegal
$2D96  14           .byte $14 ; illegal
$2D97  14           .byte $14 ; illegal
$2D98  14           .byte $14 ; illegal
$2D99  14           .byte $14 ; illegal
$2D9A  14           .byte $14 ; illegal
$2D9B  4F           .byte $4F ; illegal
$2D9C  4F           .byte $4F ; illegal
$2D9D  4F           .byte $4F ; illegal
$2D9E  4F           .byte $4F ; illegal
$2D9F  4F           .byte $4F ; illegal
$2DA0  4F           .byte $4F ; illegal
$2DA1  4F           .byte $4F ; illegal
$2DA2  4F           .byte $4F ; illegal
$2DA3  16 AE        ASL $AE,X
$2DA5  AE AE 16     LDX $16AE
$2DA8  DD F5 0A     CMP $0AF5,X
$2DAB  F3           .byte $F3 ; illegal
$2DAC  0A           ASL A
$2DAD  F3           .byte $F3 ; illegal
$2DAE  0A           ASL A
$2DAF  F3           .byte $F3 ; illegal
$2DB0  77           .byte $77 ; illegal
$2DB1  DF           .byte $DF ; illegal
$2DB2  4F           .byte $4F ; illegal
$2DB3  4F           .byte $4F ; illegal
$2DB4  FD 5F 04     SBC $045F,X
$2DB7  4F           .byte $4F ; illegal
$2DB8  44           .byte $44 ; illegal
$2DB9  C7           .byte $C7 ; illegal
$2DBA  C4 44        CPY $44
$2DBC  4C 44 44     JMP
$2DBF  45 05        EOR $05
$2DC1  17           .byte $17 ; illegal
$2DC2  15 1D        ORA $1D,X
$2DC4  3F           .byte $3F ; illegal
$2DC5  35 14        AND $14,X
$2DC7  4F           .byte $4F ; illegal
$2DC8  4F           .byte $4F ; illegal
$2DC9  4F           .byte $4F ; illegal
$2DCA  D5 F7        CMP $F7,X
$2DCC  4F           .byte $4F ; illegal
$2DCD  0A           ASL A
$2DCE  01 50        ORA ($50,X)
$2DD0  4F           .byte $4F ; illegal
$2DD1  75 4F        ADC $4F,X
$2DD3  75 4F        ADC $4F,X
$2DD5  0A           ASL A
$2DD6  5F           .byte $5F ; illegal
$2DD7  75 57        ADC $57,X
$2DD9  7F           .byte $7F ; illegal
$2DDA  77           .byte $77 ; illegal
$2DDB  DF           .byte $DF ; illegal
$2DDC  4F           .byte $4F ; illegal
$2DDD  0A           ASL A
$2DDE  DF           .byte $DF ; illegal
$2DDF  DF           .byte $DF ; illegal
$2DE0  4F           .byte $4F ; illegal
$2DE1  4F           .byte $4F ; illegal
$2DE2  4F           .byte $4F ; illegal
$2DE3  4F           .byte $4F ; illegal
$2DE4  0A           ASL A
$2DE5  0A           ASL A
$2DE6  5D D5 4F     EOR $4FD5,X
$2DE9  04           .byte $04 ; illegal
$2DEA  4F           .byte $4F ; illegal
$2DEB  0A           ASL A
$2DEC  75 77        ADC $77,X
$2DEE  F3           .byte $F3 ; illegal
$2DEF  F3           .byte $F3 ; illegal
$2DF0  F3           .byte $F3 ; illegal
$2DF1  F3           .byte $F3 ; illegal
$2DF2  0A           ASL A
$2DF3  F3           .byte $F3 ; illegal
$2DF4  0A           ASL A
$2DF5  F3           .byte $F3 ; illegal
$2DF6  0A           ASL A
$2DF7  0A           ASL A
$2DF8  F3           .byte $F3 ; illegal
$2DF9  9A           TXS
$2DFA  F3           .byte $F3 ; illegal
$2DFB  F3           .byte $F3 ; illegal
$2DFC  0A           ASL A
$2DFD  F3           .byte $F3 ; illegal
$2DFE  0A           ASL A
$2DFF  F3           .byte $F3 ; illegal
$2E00  0A           ASL A
$2E01  0A           ASL A
$2E02  0A           ASL A
$2E03  0A           ASL A
$2E04  0A           ASL A
$2E05  0A           ASL A
$2E06  0A           ASL A
$2E07  0A           ASL A
$2E08  0A           ASL A
$2E09  FD FD 7D     SBC $7DFD,X
$2E0C  0A           ASL A
$2E0D  F3           .byte $F3 ; illegal
$2E0E  0A           ASL A
$2E0F  0A           ASL A
$2E10  77           .byte $77 ; illegal
$2E11  77           .byte $77 ; illegal
$2E12  75 62        ADC $62,X
$2E14  0A           ASL A
$2E15  0A           ASL A
$2E16  0A           ASL A
$2E17  0A           ASL A
$2E18  9A           TXS
$2E19  77           .byte $77 ; illegal
$2E1A  E5 0A        SBC $0A
$2E1C  0A           ASL A
$2E1D  9A           TXS
$2E1E  0A           ASL A
$2E1F  AE AE 55     LDX $55AE
$2E22  0A           ASL A
$2E23  AE 7B AE     LDX $AE7B
$2E26  AE AE AE     LDX $AEAE
$2E29  AE 20 08     LDX $0820
$2E2C  AE AE 08     LDX $08AE
$2E2F  F7           .byte $F7 ; illegal
$2E30  B7           .byte $B7 ; illegal
$2E31  B7           .byte $B7 ; illegal
$2E32  B5 BF        LDA $BF,X
$2E34  BF           .byte $BF ; illegal
$2E35  0A           ASL A
$2E36  0A           ASL A
$2E37  FF           .byte $FF ; illegal
$2E38  0A           ASL A
$2E39  AE 0A 0A     LDX $0A0A
$2E3C  AE 6A AE     LDX $AE6A
$2E3F  AE AE FF     LDX $FFAE
$2E42  0A           ASL A
$2E43  0A           ASL A
$2E44  A1 A1        LDA ($A1,X)
$2E46  A1 A1        LDA ($A1,X)
$2E48  9A           TXS
$2E49  9A           TXS
$2E4A  9A           TXS
$2E4B  9A           TXS
$2E4C  A4 A4        LDY $A4
$2E4E  A4 A4        LDY $A4
$2E50  21 21        AND ($21,X)
$2E52  21 21        AND ($21,X)
$2E54  08           PHP
$2E55  08           PHP
$2E56  08           PHP
$2E57  08           PHP
$2E58  04           .byte $04 ; illegal
$2E59  04           .byte $04 ; illegal
$2E5A  04           .byte $04 ; illegal
$2E5B  04           .byte $04 ; illegal
$2E5C  15 15        ORA $15,X
$2E5E  15 15        ORA $15,X
$2E60  AA           TAX
$2E61  AA           TAX
$2E62  AA           TAX
$2E63  AA           TAX
$2E64  73           .byte $73 ; illegal
$2E65  73           .byte $73 ; illegal
$2E66  73           .byte $73 ; illegal
$2E67  73           .byte $73 ; illegal
$2E68  D0 D0        BNE $2E3A
$2E6A  D0 D0        BNE $2E3C
$2E6C  54           .byte $54 ; illegal
$2E6D  54           .byte $54 ; illegal
$2E6E  54           .byte $54 ; illegal
$2E6F  54           .byte $54 ; illegal
$2E70  98           TYA
$2E71  98           TYA
$2E72  98           TYA
$2E73  98           TYA
$2E74  62           .byte $62 ; illegal
$2E75  62           .byte $62 ; illegal
$2E76  62           .byte $62 ; illegal
$2E77  62           .byte $62 ; illegal
$2E78  0A           ASL A
$2E79  0A           ASL A
$2E7A  0A           ASL A
$2E7B  0A           ASL A
$2E7C  E4 E4        CPX $E4
$2E7E  E4 E4        CPX $E4
$2E80  0A           ASL A
$2E81  0A           ASL A
$2E82  0A           ASL A
$2E83  0A           ASL A
$2E84  A1 A1        LDA ($A1,X)
$2E86  A1 A1        LDA ($A1,X)
$2E88  9A           TXS
$2E89  9A           TXS
$2E8A  9A           TXS
$2E8B  9A           TXS
$2E8C  A4 A4        LDY $A4
$2E8E  A4 A4        LDY $A4
$2E90  21 21        AND ($21,X)
$2E92  21 21        AND ($21,X)
$2E94  08           PHP
$2E95  08           PHP
$2E96  08           PHP
$2E97  08           PHP
$2E98  04           .byte $04 ; illegal
$2E99  04           .byte $04 ; illegal
$2E9A  04           .byte $04 ; illegal
$2E9B  04           .byte $04 ; illegal
$2E9C  15 15        ORA $15,X
$2E9E  15 15        ORA $15,X
$2EA0  AA           TAX
$2EA1  AA           TAX
$2EA2  AA           TAX
$2EA3  AA           TAX
$2EA4  73           .byte $73 ; illegal
$2EA5  73           .byte $73 ; illegal
$2EA6  73           .byte $73 ; illegal
$2EA7  73           .byte $73 ; illegal
$2EA8  D0 D0        BNE $2E7A
$2EAA  D0 D0        BNE $2E7C
$2EAC  54           .byte $54 ; illegal
$2EAD  54           .byte $54 ; illegal
$2EAE  54           .byte $54 ; illegal
$2EAF  54           .byte $54 ; illegal
$2EB0  98           TYA
$2EB1  98           TYA
$2EB2  98           TYA
$2EB3  98           TYA
$2EB4  62           .byte $62 ; illegal
$2EB5  62           .byte $62 ; illegal
$2EB6  62           .byte $62 ; illegal
$2EB7  62           .byte $62 ; illegal
$2EB8  0A           ASL A
$2EB9  0A           ASL A
$2EBA  0A           ASL A
$2EBB  0A           ASL A
$2EBC  AE AE AE     LDX $AEAE
$2EBF  AE AE AE     LDX $AEAE
$2EC2  AE AE AE     LDX $AEAE
$2EC5  FF           .byte $FF ; illegal
$2EC6  C4 C4        CPY $C4
$2EC8  CD 00 00     CMP $0000
$2ECB  CE 00 00     DEC $0000
$2ECE  00           BRK
$2ECF  00           BRK
$2ED0  91 91        STA ($91),Y
$2ED2  91 91        STA ($91),Y
$2ED4  91 91        STA ($91),Y
$2ED6  91 91        STA ($91),Y
$2ED8  52           .byte $52 ; illegal
$2ED9  52           .byte $52 ; illegal
$2EDA  52           .byte $52 ; illegal
$2EDB  52           .byte $52 ; illegal
$2EDC  52           .byte $52 ; illegal
$2EDD  52           .byte $52 ; illegal
$2EDE  52           .byte $52 ; illegal
$2EDF  52           .byte $52 ; illegal
$2EE0  07           .byte $07 ; illegal
$2EE1  07           .byte $07 ; illegal
$2EE2  07           .byte $07 ; illegal
$2EE3  07           .byte $07 ; illegal
$2EE4  07           .byte $07 ; illegal
$2EE5  07           .byte $07 ; illegal
$2EE6  07           .byte $07 ; illegal
$2EE7  07           .byte $07 ; illegal
$2EE8  8E 8E 8E     STX $8E8E
$2EEB  8E 8E 8E     STX $8E8E
$2EEE  8E 8E 52     STX $528E
$2EF1  52           .byte $52 ; illegal
$2EF2  52           .byte $52 ; illegal
$2EF3  52           .byte $52 ; illegal
$2EF4  52           .byte $52 ; illegal
$2EF5  52           .byte $52 ; illegal
$2EF6  52           .byte $52 ; illegal
$2EF7  52           .byte $52 ; illegal
$2EF8  AE AE AE     LDX $AEAE
$2EFB  AE AE AE     LDX $AEAE
$2EFE  AE AE 07     LDX $07AE
$2F01  07           .byte $07 ; illegal
$2F02  07           .byte $07 ; illegal
$2F03  07           .byte $07 ; illegal
$2F04  07           .byte $07 ; illegal
$2F05  07           .byte $07 ; illegal
$2F06  07           .byte $07 ; illegal
$2F07  07           .byte $07 ; illegal
$2F08  8E 8E 8E     STX $8E8E
$2F0B  8E 8E 8E     STX $8E8E
$2F0E  8E 8E 52     STX $528E
$2F11  52           .byte $52 ; illegal
$2F12  52           .byte $52 ; illegal
$2F13  52           .byte $52 ; illegal
$2F14  52           .byte $52 ; illegal
$2F15  52           .byte $52 ; illegal
$2F16  52           .byte $52 ; illegal
$2F17  52           .byte $52 ; illegal
$2F18  AE AE AE     LDX $AEAE
$2F1B  AE AE AE     LDX $AEAE
$2F1E  AE AE AA     LDX $AAAE
$2F21  D6 04        DEC $04,X
$2F23  AE 16 AE     LDX $AE16
$2F26  FF           .byte $FF ; illegal
$2F27  AA           TAX
$2F28  AE FF AE     LDX $AEFF
$2F2B  F7           .byte $F7 ; illegal
$2F2C  55 AE        EOR $AE,X
$2F2E  F7           .byte $F7 ; illegal
$2F2F  A6 F7        LDX $F7
$2F31  F7           .byte $F7 ; illegal
$2F32  AE 7B 7B     LDX $7B7B
$2F35  FB           .byte $FB ; illegal
$2F36  FB           .byte $FB ; illegal
$2F37  AB           .byte $AB ; illegal
$2F38  AE FF D6     LDX $D6FF
$2F3B  08           PHP
$2F3C  2A           ROL A
$2F3D  AE FF FF     LDX $FFFF
$2F40  AE BF BF     LDX $BFBF
$2F43  AF           .byte $AF ; illegal
$2F44  AA           TAX
$2F45  16 58        ASL $58,X
$2F47  2A           ROL A
$2F48  AE 16 58     LDX $5816
$2F4B  2A           ROL A
$2F4C  AE 7F 20     LDX $207F
$2F4F  13           .byte $13 ; illegal
$2F50  C4 00        CPY $00
$2F52  0F           .byte $0F ; illegal
$2F53  20 3F 20     JSR
$2F56  3F           .byte $3F ; illegal
$2F57  FF           .byte $FF ; illegal
$2F58  55 D6        EOR $D6,X
$2F5A  07           .byte $07 ; illegal
$2F5B  FF           .byte $FF ; illegal
$2F5C  7F           .byte $7F ; illegal
$2F5D  FF           .byte $FF ; illegal
$2F5E  FF           .byte $FF ; illegal
$2F5F  AE FE FE     LDX $FEFE
$2F62  FA           .byte $FA ; illegal
$2F63  AA           TAX
$2F64  D6 C0        DEC $C0,X
$2F66  72           .byte $72 ; illegal
$2F67  01 AE        ORA ($AE,X)
$2F69  40           RTI
$2F6A  4C 49 40     JMP
$2F6D  B4 58        LDY $58,X
$2F6F  2A           ROL A
$2F70  AE 09 06     LDX $0609
$2F73  C0 23        CPY #$23
$2F75  B0 DC        BCS $2F53
$2F77  90 04        BCC $2F7D
$2F79  C0 25        CPY #$25
$2F7B  B0 D6        BCS $2F53
$2F7D  01 D6        ORA ($D6,X)
$2F7F  A9 F8        LDA #$F8
$2F81  F8           SED
$2F82  F8           SED
$2F83  F8           SED
$2F84  F8           SED
$2F85  F8           SED
$2F86  F8           SED
$2F87  F8           SED
$2F88  00           BRK
$2F89  AE 40 D8     LDX $D840
$2F8C  07           .byte $07 ; illegal
$2F8D  07           .byte $07 ; illegal
$2F8E  02           .byte $02 ; illegal
$2F8F  02           .byte $02 ; illegal
$2F90  F8           SED
$2F91  F8           SED
$2F92  4C 2F 40     JMP
$2F95  20 72 40     JSR
$2F98  A6 4C        LDX $4C
$2F9A  F6 71        INC $71,X
$2F9C  A9 02        LDA #$02
$2F9E  AE 77 D0     LDX $D077
$2FA1  B3           .byte $B3 ; illegal
$2FA2  A9 CA        LDA #$CA
$2FA4  AE 77 A9     LDX $A977
$2FA7  08           PHP
$2FA8  95 71        STA $71,X
$2FAA  09 11        ORA #$11
$2FAC  09 04        ORA #$04
$2FAE  A9 C8        LDA #$C8
$2FB0  95 77        STA $77,X
$2FB2  C6 4C        DEC $4C
$2FB4  10 8F        BPL $2F45
$2FB6  60           RTS
$2FB7  AE AE AE     LDX $AEAE
$2FBA  A9 1C        LDA #$1C
$2FBC  0F           .byte $0F ; illegal
$2FBD  11 97        ORA ($97),Y
$2FBF  16 58        ASL $58,X
$2FC1  2A           ROL A
$2FC2  AE A9 1B     LDX $1BA9
$2FC5  11 97        ORA ($97),Y
$2FC7  16 58        ASL $58,X
$2FC9  2A           ROL A
$2FCA  AE A4 20     LDX $20A4
$2FCD  78           SEI
$2FCE  40           RTI
$2FCF  A9 55        LDA #$55
$2FD1  2A           ROL A
$2FD2  AE A4 70     LDX $70A4
$2FD5  B0 D4        BCS $2FAB
$2FD7  00           BRK
$2FD8  A9 54        LDA #$54
$2FDA  A6 6F        LDX $6F
$2FDC  A4 6E        LDY $6E
$2FDE  2A           ROL A
$2FDF  AE A4 A0     LDX $A0A4
$2FE2  89           .byte $89 ; illegal
$2FE3  4C 09 25     JMP
$2FE6  09 19        ORA #$19
$2FE8  09 09        ORA #$09
$2FEA  09 09        ORA #$09
$2FEC  09 30        ORA #$30
$2FEE  60           RTS
$2FEF  58           CLI
$2FF0  2A           ROL A
$2FF1  AE A6 74     LDX $74A6
$2FF4  A4 71        LDY $71
$2FF6  A4 72        LDY $72
$2FF8  A4 72        LDY $72
$2FFA  A4 72        LDY $72
$2FFC  A6 75        LDX $75
$2FFE  A4 72        LDY $72

; ============================================================
; DATA $3000-$4000
; ============================================================

$3000  16 01 16 01 69 1F A6 76 A4 73 3B 3B 3B 3B 69 01
$3010  4C 86 01 01 DA EC 16 01 4C 90 01 01 DC 01 69 07
$3020  4C 9A 40 01 DE CE 01 2D 01 EC EC 01 01 EC EC 01
$3030  01 01 2D 2D 2D 01 01 01 01 01 9A 01 01 9B 01 09
$3040  01 8D 9A 01 8D 9B 01 AD B8 8D 32 01 8D 33 A4 CE
$3050  01 01 D0 1D EC 01 01 EC EC 01 01 01 02 01 01 01
$3060  01 3B 30 01 8A AD 01 8B AD 09 CC 8D 8A A5 8D 8B
$3070  A5 CE 01 01 D0 25 01 01 01 3B 0F F0 F9 01 03 01
$3080  00 4C 17 3B 0C 01 A2 AC 01 A3 AC 09 33 8D A2 A4
$3090  8D A3 A4 AD 2E 8D 3A A7 8D 3B A7 60 A2 03 A0 00
$30A0  01 01 01 01 01 01 99 AD 83 E1 AD 00 3D 22 43 99
$30B0  AD 83 01 4E 4E 4E 0D E8 AD AD C6 16 01 AD 01 C6
$30C0  01 01 20 01 01 01 01 01 CE 01 C6 E1 AD C6 D0 0E
$30D0  AD 01 AD D0 06 20 20 42 4C 75 41 CE 31 AD AD E1
$30E0  AD E1 AD F0 17 BE BE AD AD 69 05 9D AD AD C9 E0
$30F0  90 0A E1 AD 38 E1 AD C2 02 9D 30 C6 AD BE E1 AD
$3100  C2 C6 F0 00 AD C6 C6 F0 00 A2 C6 C6 C6 C6 F0 56
$3110  A0 01 C6 C6 C6 C9 A8 B0 01 C8 C2 C6 C6 C5 9E B0
$3120  05 FE C6 C6 D0 05 F0 03 DE C6 C6 C6 10 EC BD C6
$3130  C6 0A 48 38 38 BE BE AD 1D C5 42 C6 03 3D C7 42
$3140  8D 10 C6 C6 65 C2 C6 9D 0C 65 C6 C6 3B BD C6 C6
$3150  18 69 1D C6 0A C6 AA 68 9D 0D D0 8A 4A 3B 3B 3B
$3160  00 09 F0 9D 2D D0 C6 BE A2 C6 38 0D A1 FE 65 65
$3170  C6 C6 09 40 A1 DE 65 C2 C6 8D 2E C6 C2 50 8D 32
$3180  C6 C2 C6 8D 34 C6 C6 C6 2E A9 0E 8D FF 8F AD C6
$3190  8D 09 80 8D 8D 8D A9 01 8D 2F C6 A9 5E 8D 33 43
$31A0  A9 37 8D 35 43 4C 29 2E A2 17 00 C6 38 40 83 9D
$31B0  80 83 C6 C6 C6 BE F5 10 D0 0A 10 D1 10 A0 8A 10
$31C0  D0 D0 D0 D0 10 10 10 10 38 58 85 49 17 04 85 4A
$31D0  38 8D 8D 38 38 38 8C BE BE BE 09 00 00 00 00 D0
$31E0  20 E6 40 60 3B 69 3B AA A0 03 17 29 9D 4B 01 E8
$31F0  88 10 F9 3B C5 10 3B CA 33 3B E0 10 17 00 4C 17
$3200  32 3B 3B 3B 3B 3B 3B 3B A2 1C 9D AC 03 9D D4 03
$3210  9D FC DA 9D 24 03 9D 4C 03 9D 74 03 9D 9C DB 9D
$3220  C4 DB CA 10 E5 A9 04 A2 00 A0 0A 4C E2 17 40 80
$3230  BF 7F 03 03 7A 10 03 03 02 18 1A A9 A9 A9 5C 1C
$3240  1E 2C 2E 1A 1A 1A 26 11 13 01 03 19 1B A9 38 A9
$3250  5C 1D 1F 2D 2F 1A 1A 1A 27 2A 28 28 0A 0A 2A 2A
$3260  2A 2A 28 28 0A 0A 2A 2A 2A 2A 28 28 0A 0A 2A 2A
$3270  13 C4 13 C4 13 C4 13 13 ED 13 ED 13 ED 13 ED C4
$3280  13 C4 13 C4 13 C4 13 3F F8 7C F8 ED 24 24 C5 12
$3290  03 03 03 29 86 00 00 4C 86 00 00 4C 86 00 00 4C
$32A0  15 29 00 29 15 29 00 29 15 29 00 29 15 29 00 29
$32B0  15 29 00 29 15 29 00 29 15 29 00 29 15 29 00 29
$32C0  15 29 00 29 15 29 00 29 15 29 00 29 15 29 00 29
$32D0  15 29 00 29 15 29 00 29 15 29 00 29 15 29 00 29
$32E0  00 C4 C4 7A 9C 40 00 75 00 01 D6 0D 00 00 14 29
$32F0  49 29 49 02 E6 02 E6 00 29 00 29 00 14 00 14 29
$3300  49 29 49 02 E6 02 E6 00 29 00 29 80 88 44 8C 44
$3310  90 44 94 44 50 47 98 44 9E 44 A6 44 CF 44 F4 44
$3320  19 6C 7E 45 8B 45 3E 6C AA 44 BC 45 B6 45 B0 45
$3330  AA 45 C2 45 C4 45 C6 45 C8 45 CD 45 CF 45 D4 45
$3340  D8 45 DC 45 DE 45 E4 45 E6 45 E8 45 EA 45 EC 45
$3350  EF 45 F2 45 F5 45 F8 45 FB 45 FD 45 FF 45 02 6C
$3360  05 6C 08 46 0B 6C 0E 6C 10 6C 12 46 16 6C 1A 6C
$3370  1E 6C 22 46 26 6C 28 6C 2A 6C 2C 46 4B 6C 2E 6C
$3380  68 6C DF 46 37 6C 71 6C 59 46 3C 46 76 6C 5E 6C
$3390  41 46 7B 46 63 6C 46 46 80 46 85 46 89 6C 8D 46
$33A0  91 46 95 46 99 6C 9D 46 6C 46 A3 46 BF 6C E0 46
$33B0  F5 46 FE 46 E0 45 E2 45 2F 00 32 47 34 47 36 47
$33C0  3A 00 3E 47 42 47 46 47 6C 00 4D 47 66 47 6E 47
$33D0  70 47 82 47 84 47 6C 6C 6C 6C 31 6C 6C 0F 32 55
$33E0  6C 0F 54 4F 50 0F 46 41 4C 4C 53 0F 0F 07 6B 38
$33F0  6C 6C 6C 5C D6 24 38 38 38 38 6C 6C 6C 6C 6C 6C
$3400  6C 6C 6C 6C 6C 6C 6C 6C 6C 6C 38 7D 7D DF DF 4E
$3410  4E 00 00 FE FE 6C 6C 6C 6C 58 58 7D 7D DF DF 4E
$3420  4E 00 00 FE FE 6C 6C 20 5C 51 03 03 03 38 38 38
$3430  38 00 00 00 00 6C 6C 6C 6C 00 00 00 00 6C 6C 6C
$3440  6C 6C 6C 6C 4E 4E 00 00 FE FE 6C 6C 4E 4E 00 00
$3450  FE FE 6C 6C 20 6C 0F 0F 0F 20 00 6C 7C 00 7C 00
$3460  00 6C 00 6C 00 6C D2 4A 4F 59 53 6C 49 43 4B 20
$3470  23 20 5C 1F 1F 5C 20 0F 0F 20 1F 1F 1F 1F 1F 20
$3480  48 41 4E 6C 00 6C 54 4D 4F 44 00 6C 42 52 55 43
$3490  6C 20 4C 0F 0F 08 42 59 A0 6C 4F 0F 20 4A 20 46
$34A0  4F 6C 54 49 6C 6C 0F 0F 0F 20 50 41 55 53 45 44
$34B0  54 54 0F 0F D6 1B 5C D2 0F 0F 0F D2 20 4F 56 6C
$34C0  0F 0F 4E 0F 0F 0F 0F 0F 20 6C 31 26 85 85 8C 0F
$34D0  31 6C 6C 6C 0F 0F 85 85 7E 6C 6C 0F 42 42 6C 0F
$34E0  0F 0F D2 1B DE 5C A2 13 C4 00 5C 1B 5C 5C 81 A4
$34F0  A4 6C 1B 81 A5 83 1B 5C B5 A5 A5 04 B5 05 1B 5C
$3500  3D B5 A5 E6 B5 E7 B5 B5 B5 B5 B5 B5 F6 B5 F4 3D
$3510  B5 3D F5 B5 3D F4 5C 3D B5 B5 B5 B5 B5 B5 F9 FA
$3520  B5 F8 B5 B5 0F F9 B5 0F F8 0F 0F F8 B5 B1 5C 4A
$3530  54 11 12 13 5C 3D B5 E0 54 E1 E1 19 A5 B5 1B B5
$3540  54 1D 00 1D A5 B3 A5 B4 A5 06 A5 0F A5 A7 A8 A9
$3550  AA AF 04 AF AE B5 BD B5 BF B5 B5 12 18 1C B5 B5
$3560  BD D3 DD C0 B5 12 DE EF D4 B5 0F 00 69 69 69 69
$3570  53 B5 D2 B0 B1 B5 B5 B5 B6 BC C1 B5 B5 F4 53 53
$3580  11 B5 14 E0 E0 E0 B5 0F C8 AF F9 19 1A 1B 0F D2
$3590  B5 F3 C9 CA B5 12 D0 D1 D2 54 03 F3 F4 00 54 12
$35A0  05 06 B5 54 B7 B8 B9 54 BC B8 1C 54 C4 C5 C6 54
$35B0  B0 C5 C1 54 F5 F6 F7 54 BE BF 18 54 F2 02 54 B1
$35C0  B6 54 0F 0F C6 B3 3D B5 62 31 51 51 B5 B5 B5 B5
$35D0  00 B5 B5 76 32 1F 1F 1F 1F 1F 1F 00 0F B5 0F 0F
$35E0  0F 0F 53 0F 20 0F C6 B5 0F 2D 62 0F D2 4D 50 55
$35F0  54 0F 0F 20 2D 76 0F 50 50 0F 4E 0F 0F 54 0F 0F
$3600  62 C6 B7 76 2D 20 54 4F 20 42 D2 47 49 4E 20 47
$3610  D2 4D D2 08 08 08 D2 D2 D2 D2 20 31 A0 BF 1F BE
$3620  16 00 1F 20 32 A0 22 32 35 23 D2 00 2C 25 25 00
$3630  08 23 09 00 11 19 18 14 00 24 21 0F 21 33 2F 26
$3640  0F 1A 32 25 36 0E 12 00 22 39 00 32 2A 4E 4E 20
$3650  D2 0F 0E 4F A0 D2 CF CF 0E 0F F8 D2 A0 D2 D2 D2
$3660  A0 D2 69 69 A0 64 64 A0 20 20 A3 A0 7A 7A A0 D2
$3670  2A 20 43 D2 4E 47 52 D2 54 55 4C D2 54 49 4F 4E
$3680  53 20 2A 2A A0 D6 07 29 A0 A6 A0 44 41 54 41 53
$3690  4F 46 54 20 50 52 45 53 45 4E 54 53 A0 27 A0 AE
$36A0  A0 FB 04 F8 D2 FB 05 D2 FB 06 D2 D2 FB 07 60 FB
$36B0  08 D0 FB FB 09 60 F0 F8 D2 18 F7 D6 04 FE D2 FC
$36C0  FC FF FA D2 F9 FB F9 FA F9 FC F9 FF 18 FF 18 08
$36D0  18 08 F8 D2 F8 D2 F1 D2 D2 F1 03 0A 0A A5 A5 C9
$36E0  C9 3A FB D2 FE FB D2 F1 FC FB F1 D2 D2 F1 F8 F9
$36F0  F1 F6 D2 FB FB FE FB F4 FE FB D2 F6 F1 FE F6 FB
$3700  BE FE F1 FF F8 01 BE F8 FB F0 FE F4 F6 F2 F1 8A
$3710  9A EA B7 B7 FC FC FC FC FD 78 FC FD 62 97 FD FD
$3720  56 FD B6 C7 FD FC C3 1E FE FC FE C8 FE FC FE FC
$3730  C3 D1 C3 1E FE FC FE D4 FE FC 47 DD FE FC 47 E0
$3740  FE FC 47 E3 47 D7 47 EC 47 EF 47 F2 47 F9 47 FC
$3750  47 FF 47 02 07 7C 58 94 6D B7 C3 1E FE FC 6D B7
$3760  6D B7 FE FC FE FC C3 FC FE FC C3 08 48 06 C3 1E
$3770  FE FC 48 05 48 48 FE FC 10 30 A9 27 85 F3 38 00
$3780  38 38 FC 85 04 FE FC E6 05 A5 08 1E FC FC 85 08
$3790  FC FC E6 09 A5 10 1E FE FC 85 10 FE FC E6 11 A5
$37A0  12 A9 69 28 85 12 90 02 E6 13 68 60 A0 00 FE FC
$37B0  FE FC FC FC FC FC 00 08 28 68 C5 00 FC 1E 1E FC
$37C0  FC EE A2 03 B1 04 FC FC FC FC 47 68 C5 68 C5 47
$37D0  DB DB 47 CA 10 EE C6 F3 10 D2 60 38 32 38 A9 80
$37E0  38 FC 38 A9 D0 38 1E A9 38 A9 38 A9 38 A9 38 A9
$37F0  38 A9 38 A9 38 A9 38 A9 38 A9 38 A9 38 A9 38 A9
$3800  40 DD 80 D0 38 38 38 38 00 0B 80 85 0A BD 0C 80
$3810  85 0B BD 33 80 85 0C BD 34 48 85 0D A0 0B B1 0A
$3820  99 80 01 C0 04 B0 05 B1 0C 99 80 47 88 10 EF 20
$3830  80 15 80 80 80 80 80 80 38 41 DD 80 D0 B0 FB C1
$3840  C1 80 80 FD A5 F2 DD 18 80 AD 80 01 DD 80 D0 AD
$3850  8B C1 DD 80 D0 AD DD 80 DD 80 D0 38 00 80 44 38
$3860  80 80 F4 38 82 C1 DD 80 38 49 02 02 1B 1B 38 38
$3870  1B 1B 38 38 1B 1B 38 38 1B 1B 38 38 38 C1 C1 80
$3880  80 47 8D 80 D0 C9 FD F0 06 10 10 10 10 38 40 38
$3890  A9 A9 A9 A9 38 38 38 38 04 4C 6F 49 80 F4 BC 53
$38A0  01 A6 44 BD F5 47 AA E8 E8 8A E8 EC 80 D0 F0 0A
$38B0  CD 12 D0 D0 F6 A2 0A CA D0 FD 8C 21 D0 A6 F4 BD
$38C0  54 80 8D 22 D0 BD 55 01 8D 23 D0 A5 F4 18 69 03
$38D0  85 F4 E6 44 4C 53 49 D6 0C 5C 7C F8 24 26 28 2A
$38E0  08 0A 80 0E 80 5C 1A 16 80 0E 1A 0E D6 16 5C 05
$38F0  07 1A 27 29 2B 09 0B 80 0F 1A 5C 1A 17 1A 0F 1A
$3900  0F 1A 4E 5C 61 62 1A 5E 1A 76 5D 5E 1A 74 1A 6E
$3910  1A 66 1A 76 1A 5C 85 70 1A 72 1A 64 1A 74 1A 64
$3920  1A 6C 1A 76 85 74 1A 06 5C 5F 60 85 78 1A 04 5C
$3930  1A 72 1A 6E 85 6C 1A 5C 69 6A 1A 5C 65 66 6D 6E
$3940  1A 72 75 76 67 68 63 64 71 72 1A 5C 20 22 14 16
$3950  00 02 30 32 0C 0E 24 26 1A 5C 1A 3A 21 23 15 17
$3960  01 03 31 33 0D 0F 25 27 5C 5C 1A 3B 38 3A 3C 3E
$3970  39 3B 3D 3F 24 08 1C 1C 00 3A 76 24 4E 1A CE 34
$3980  24 0E 04 4E CE 4E 0E 85 97 32 0A 0A 3A 1A 3A D0
$3990  3A 1A 3A 1A 0A E4 0A 0A 3A 1A 3A E9 3A 1A 4A FD
$39A0  4A 1A 4A 02 3A 1A 4A 0C 4B EE 4A 1B 4B 25 4B 2A
$39B0  4B 1A 1A 85 88 1A 1A 1A 1A 1A C4 85 5A 3A 1A C4
$39C0  1A 4E 0A 3A C4 85 85 77 3A 60 C4 BE 32 3A 40 85
$39D0  4E 3A 1A 3A 1A 1A 0E 1A 88 1A 1A 1A 85 88 66 31
$39E0  8E 02 88 13 C4 31 85 7C 85 31 85 0E 7C 86 1A B7
$39F0  85 7A 85 5A B7 0E 7A 85 4E B7 06 7E 26 26 85 85
$3A00  38 C4 9C 2C 04 38 E0 E0 82 68 F8 F8 E3 77 85 30
$3A10  84 85 70 0F 30 F9 09 3E 9D 1B 82 DD 27 11 91 D8
$3A20  4C 43 C6 46 B4 5C 8D 90 E0 E0 68 6A 6B 6C 6E 6F
$3A30  70 72 73 74 75 77 78 79 7A 7B 7C 7D 7E 8C 8C 22
$3A40  97 8C 85 85 C4 05 12 07 08 03 0A 85 0E 12 34 24
$3A50  0E 9C 9C 2A 85 0F 0A 85 C5 05 08 09 08 0B 0C 0B
$3A60  77 0B 11 0B 12 13 94 26 77 85 02 5A C5 02 08 C5
$3A70  C5 5A 4E 85 0E 4E 85 4E 0E 77 85 82 02 C4 E0 3C
$3A80  82 3C 82 09 CE 4E 13 C4 CE 4E 13 C4 0F C4 18 30
$3A90  20 94 22 86 B7 14 12 34 40 1C 85 4E B7 1C 1C 1C
$3AA0  12 C4 C4 C4 C0 B4 51 B3 44 46 C6 8C 4C 5C 32 5C
$3AB0  C3 5C B4 C6 95 9F 95 C4 38 C4 28 81 1F 85 00 C4
$3AC0  31 70 85 92 7A 34 24 00 C4 31 92 C4 C4 B4 C2 72
$3AD0  74 4E C4 C4 31 C4 31 BE C4 8E C1 C1 C1 10 85 C4
$3AE0  85 CE 9C 13 85 4E 13 85 C4 CE 4E 13 C4 00 C4 00
$3AF0  92 92 C4 BE C2 51 80 51 74 47 C4 5A CE 4E 13 C4
$3B00  31 93 44 31 BE 2C 31 38 1F 31 A0 31 31 A0 31 31
$3B10  34 BE 50 31 80 31 31 31 BE BE 60 B0 32 40 66 46
$3B20  53 C0 C4 5C 31 31 31 B3 BE C6 96 31 31 31 A1 A1
$3B30  31 38 16 31 A1 9D 31 38 31 31 00 00 00 00 00 7A
$3B40  31 62 C5 31 74 51 C0 B5 C7 31 5E 59 7A 31 31 BE
$3B50  31 31 D3 0F 31 31 31 31 58 20 20 0F 31 31 38 31
$3B60  C2 38 28 1C 0F 62 62 C4 62 31 66 51 51 C6 31 C2
$3B70  5C 31 C2 BE BE BE 9C 00 00 00 03 31 FF C1 C1 C1
$3B80  C1 00 C2 D3 D3 FF FF 84 08 06 31 02 31 06 08 32
$3B90  1F 1E 1A 18 1D 1B 33 35 30 72 5F 5E 5A 58 5D 5B
$3BA0  73 75 70 CF CF D1 31 CF 0A 08 0D B5 05 31 E0 E0
$3BB0  E0 B5 06 CF CF CF 00 0C 4D 25 4D 3E 4D 67 4D 70
$3BC0  4D 79 4D A2 4D C3 4D F8 4D 09 4E 1E 4E 2B 4E 38
$3BD0  4E 45 4E 4A 4E 5B 4E 74 4E 7D 4E 86 4E 8B 4E 90
$3BE0  4E 31 CF 1F CF CF 92 26 31 31 CF CF CF CF 9F 19
$3BF0  7A 31 92 CF CF CF 92 CF CF CF CF CF CF CF CF CF
$3C00  CF CF CF 92 06 D1 CF 17 8B D1 CF 9F 18 CF CF 92
$3C10  CF CF CF D3 92 D3 07 CF D3 D3 D3 D3 CF 16 D1 CF
$3C20  D3 1A 8B CF CF 3E CF CF D3 05 D1 CF 9F 3E C2 D3
$3C30  9E 0F CF CF 9F 15 CF CF D3 CF CF D1 CF CF 1D CF
$3C40  CF 9F D3 0A CF CF CF 0B D1 CF 9F 1C 04 CF CF CF
$3C50  15 15 0E CF 06 CF CF 9F 1C D1 CF 9E 20 CF CF 9F
$3C60  26 D1 CF 9F 1E D3 D3 9E 02 CF CF 9F 17 CF CF 9F
$3C70  1A 3E D3 D3 3E 3E D3 D3 9F 08 D1 CF 9E 0A D1 CF
$3C80  9F 0E D1 CF 9F 16 D1 CF 9F D1 CF CF 9E 1C CF CF
$3C90  9F 06 CF CF 9E 1E CF CF CF CF D3 CF CF D3 0C CF
$3CA0  CF D3 0D CF CF D3 19 CF CF D3 1A CF CF D3 05 CF
$3CB0  CF 9E 06 CF CF 9F 0C CF CF 9E 0D CF CF 9F 19 CF
$3CC0  CF 9E 1A 05 CF 9F 02 09 CF 9E D3 09 CF CF 9F 0F
$3CD0  D3 D3 9F 18 D3 D3 9E 06 D1 CF 9F 21 C2 D3 D3 9F
$3CE0  20 02 CF D3 0F C2 D3 D3 1B CF D3 9F 1C C2 D3 9E
$3CF0  20 3E D3 D3 9F D3 D3 D3 9F 3E C2 D3 9F 3E C2 D3
$3D00  D3 9E 12 D3 D3 9F C2 D3 D3 9F 07 C2 D3 D3 D3 24
$3D10  D3 D3 9E 24 C2 D3 D3 24 C2 D3 D3 3E 3E D3 D3 3C
$3D20  D3 09 D3 D3 D3 1E 07 D3 9F 09 D3 D3 9E 1E 0A D3
$3D30  D3 9F 13 D3 D3 9E 15 03 D3 9E 0E C2 D3 9F 1A D3
$3D40  D3 9E 0D 06 D3 9F 1B 06 D3 D3 9E 20 04 D3 9F 05
$3D50  07 C2 D3 9E 26 0A D3 9E 1F C2 D3 3E 9E 25 0B 73
$3D60  3E 3E D3 D3 3D 3C 3C 3C 3C 3D ED ED ED D3 33 F5
$3D70  C2 D3 33 FB 33 01 34 27 C2 D3 33 60 34 77 34 8E
$3D80  34 D3 33 F4 33 BC 34 C2 34 8C 35 92 35 9E 35 C3
$3D90  35 F9 35 5E 42 41 36 78 36 A5 36 01 37 5F 37 AA
$3DA0  38 A9 39 C2 39 D3 3A B1 3B 8F 3C BF 3C 4B 3E 7B
$3DB0  3E CB 3E E5 3E 5A 3F 70 3F DB 3C 71 42 02 4E 0C
$3DC0  0C 15 EE 00 38 38 38 38 8C 09 4E E9 11 D0 60 00
$3DD0  28 50 78 A0 C8 F0 18 40 68 90 B8 E0 08 30 58 80
$3DE0  A8 D0 F8 20 48 70 98 C0 D3 06 8C D3 06 8D D3 07
$3DF0  8E D3 05 8F D3 06 D8 D6 06 D9 D6 07 DA D6 05 DB
$3E00  AD 8F CF C9 B9 D0 F9 4D AF CF D0 F4 A2 D1 86 E1
$3E10  4E E1 E1 4E F1 E1 E1 51 4C 54 51 E1 5F E1 70 1D
$3E20  4E 4E E1 10 FA C6 E1 E1 51 4E 24 51 A6 51 4E 5A
$3E30  B9 E1 E1 E1 E1 E1 E1 07 A0 5F B1 06 19 E0 CA E1
$3E40  06 88 10 F6 CA E0 FF 70 70 4C 3D 51 E1 A1 A1 69
$3E50  69 59 85 04 BD 8F 5A 85 05 BC 61 5B C8 84 1D 4E
$3E60  4E 12 29 07 4E 4E 11 29 E1 E1 69 20 29 08 E1 E1
$3E70  E1 E1 29 09 A5 06 4E 69 40 29 0A A5 07 29 29 29
$3E80  0B 4E 00 BD BF 5C D0 23 47 4E 5A B9 E1 D1 86 8C
$3E90  47 4E 5A B9 E1 06 E1 70 47 5A 5A E1 E1 90 E9 E1
$3EA0  06 E1 08 B9 E1 C8 C0 E1 90 F5 60 E1 8D 85 1F E1
$3EB0  E1 E1 91 08 5A B9 E1 91 06 20 86 47 4E 8D 2A 70
$3EC0  70 20 FF 51 91 0A C8 C4 1D 90 DF 2A 70 69 CF A2
$3ED0  03 4E 3B 46 1F 90 02 09 C0 4E 69 05 4E 4E 4C 03
$3EE0  70 2A 70 02 86 4E 4E 95 29 01 D0 4E 00 70 52 B5
$3EF0  9E E1 E9 0C 4E E6 29 03 85 1B B5 A1 4E E9 1D 4E
$3F00  E9 29 07 85 1C 38 BE BE 00 BD 67 11 8D CC 52 BD
$3F10  39 12 8D CD 52 20 AD 52 A5 1C 18 69 15 8D 70 70
$3F20  70 E9 06 8D 70 70 20 AB 4E 4E 50 4E E6 A7 4E 95
$3F30  E6 4E 60 4E 4A 4A 95 E9 A0 00 70 52 A9 08 E9 A7
$3F40  4E A7 4E 24 E9 24 E9 A7 4E A7 4E A9 10 E9 15 15
$3F50  4E 4E D4 D4 E9 E9 15 15 4E 4E A9 18 03 03 15 15
$3F60  4E 4E 15 15 4E 4E 50 F6 E9 A9 20 8D 70 0D 20 0A
$3F70  53 20 7E 53 4E 50 A1 69 69 00 14 70 60 70 3B A8
$3F80  C4 1C 0D F1 15 4E 4E C8 D0 F6 A6 1B 4E 03 D0 09
$3F90  4E 1F 15 4E 4E C8 4E 0D F9 F8 09 F8 00 E0 99 4E
$3FA0  CA C8 E8 E0 60 90 F4 A5 00 00 00 10 03 F0 14 0A
$3FB0  A8 4E 1F 5E 4E CA 7E 4E 55 7E 4E CB 0D 0D F4 4E
$3FC0  D0 EF 60 A0 02 A2 1F 1E 40 4E 3E 70 CB 3E 70 55
$3FD0  3E 70 CA 70 10 F1 88 D0 EC 60 4E 50 60 60 60 00
$3FE0  C5 55 A6 50 B4 E6 8D D7 55 8D 8D 8D 8D 8D 8D 70
$3FF0  70 70 70 70 70 70 70 8D 81 55 BE D4 BE D4 2A 70

; ============================================================
; DATA $4000-$6000 (room/sprite data)
; ============================================================

$4000  2A 70 8D 82 70 C8 70 49 70 70 70 70 70 70 70 70
$4010  70 70 70 70 70 70 70 8D 9B 70 BE D4 BE D4 2A 70
$4020  2A 70 8D 9C 53 C8 C0 28 90 3D 60 3B 69 3B 00 BB
$4030  56 B1 04 08 28 68 C5 08 28 68 C5 43 38 E5 52 8D
$4040  B5 53 AD BB 43 E9 00 18 65 7C 8D B6 53 60 70 52
$4050  3B 2A 70 39 E0 CA 70 70 70 70 70 70 70 70 2A 70
$4060  4E 70 70 70 70 70 FA ED 4E 3B 70 70 39 00 55 16
$4070  E3 BE D4 E1 3B 2A 70 2A 70 4F D4 E1 3B 2A 70 FA
$4080  04 4F B9 00 E0 39 20 CB F0 12 85 4E D6 04 4A 70
$4090  2A 70 0C A5 4E 29 0F AA FA 0D 0C C8 CC 38 70 0D
$40A0  10 CC 39 70 0D 50 CC 3A 0D 0D F1 4C 80 53 84 52
$40B0  60 A2 02 BD 70 0D 9D 70 70 0D 10 F7 2A 70 54 B5
$40C0  B6 95 A7 FA 0D 0D CD 35 70 3B 3B 70 70 FA 52 0D
$40D0  0D 52 52 0D 0D 0C CD 36 70 0C 08 70 70 FA 68 68
$40E0  4C A4 52 FA 0D 0C CD 37 0D 0C B6 49 01 FA 0D 4F
$40F0  FA 0D 56 4C D4 53 20 31 54 68 68 4C A4 52 FA 0D
$4100  00 04 9D 3B FA 0D 10 FA 0C 0D 0D 0C F1 AE 0D 0C
$4110  20 E6 55 0C 0C 0C 43 F1 AE 0D 0C 20 58 F1 AD 0C
$4120  0C BE 06 AE 0C 4F 20 CA 56 AD EE F1 CF F1 F1 CF
$4130  F2 CF CF F1 F1 0D 0D 0D 0D 57 F1 0D F1 F1 0D FA
$4140  0D 0D 57 F1 0D 05 F1 CF 08 F1 CF 09 FE CF 57 F1
$4150  0D FA 0D 0D F1 F1 0D 57 F1 0D 0D 0D 0D F1 F1 0D
$4160  1C F1 F1 1F F1 F1 20 F1 F1 F1 F1 0C 0D 0D 0D 0D
$4170  0D 0D F1 F1 0C FA 0D 0D 0D 37 57 F1 EE 0D 4F AD
$4180  EF F1 0D F3 F1 0D F5 F1 0D F6 F1 0D F7 FA 0D FA
$4190  0D 0D 0D 0D 0D 57 F1 0D F1 F1 0D 06 F1 0D 0A F1
$41A0  0D 0C F1 0D 0D F1 0D 0E 0D 0D 0D 0D 0D FA 0D 0D
$41B0  F1 F1 0D 57 F1 0D 1D F1 0C 21 F1 0C 23 F1 0C 24
$41C0  F1 0C 25 0D 0C FA 0D 0D 0D 0D 0D FA 0D 0D 0D 37
$41D0  FA 0D EE 0D 34 AD 0D 37 0D 0D 37 0D 0D 37 0D 0D
$41E0  37 0D 0D 37 0D 0D 0C 0D 0C 1D 0D 0C 0C 0D 0C 0C
$41F0  0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C FA 0D
$4200  0C 0C 0D 0C 0C 0D 0C 0C 0D 2E 37 0D 2F 37 0D 30
$4210  37 0D 31 37 34 37 EE 37 37 37 37 37 0D 37 37 0D
$4220  37 37 0D 37 37 0D 37 37 0D 37 0C 0D 37 4E 0D 0C
$4230  0C 0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C 0C
$4240  0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C 0C 0D 0C 0C 0D
$4250  0C 0C 0D 0C 0C 0D 0C 4F F0 03 EE 37 58 0C FA 37
$4260  00 95 37 4E 3F 58 37 37 4E 3E 37 34 37 4E 3D 34
$4270  37 B6 4E 3C 4F 36 B6 00 00 00 00 16 9D ED 4E 9D
$4280  04 0C 9D 1B 0C CA 10 F4 8D 37 0C 8D 0C 0C 8D 0C
$4290  4F 60 BD E7 37 85 04 85 12 BD FF 50 85 05 BD 17
$42A0  51 85 13 0C AE 0C 0C 4E AE 0C FA 37 0C 0C AE 0C
$42B0  EE 0C 0C AD 37 37 AE 37 37 8E F0 37 8D FD 37 AD
$42C0  37 37 AE 37 37 8E F4 37 8D FE 37 AD 37 37 AE 37
$42D0  37 8E F8 37 8D FF 37 AD 37 37 AE 37 37 8E F9 37
$42E0  8D 00 37 AD 37 37 AE 37 37 8E FA 37 8D 01 37 AD
$42F0  37 0C AE 37 0C 8E FB 0C 8D 02 0C AD 0C 4E AE 0C
$4300  1D 8E FC 4E 8D 03 1D 43 FA 0C AD 0C 0C 0C FA 0C
$4310  CE 32 0C 4C E6 55 FA 0C FA 0C FA 0C FA 0C 0C 43
$4320  FA 0C EE 0C 0C AD 0C 0C AE 0C 0C 8E 07 0C 8D 14
$4330  0C AD 0C 0C AE 0C 0C 8E 0B 0C 8D 15 0C AD 0C 0C
$4340  AE 0C 0C 8E 0F 0C 8D 16 0C AD 0C 0C AE 0C 0C 8E
$4350  10 0C 8D 17 0C AD 0C 0C AE 0C 0C 8E 11 0C 8D 18
$4360  0C AD 0C 0C AE 0C 0C 8E 12 0C 8D 19 0C AD 0C 0C
$4370  AE 0C FA 8E 13 0C 8D 1A FA 0C FA 0C AD 0C 0C 43
$4380  FA 0C CE 33 0C 4C 58 56 B1 12 29 07 BE 43 FA 0C
$4390  4F BE 00 BE EE 0C 4F AD 0C 0C AE 0C 0C 8E 1E 0C
$43A0  8D 2B 0C AD 0C 0C AE 0C 0C 8E 22 0C 8D 2C 0C AD
$43B0  0C 0C AE 0C 0C 8E 26 0C 8D 2D 0C AD 0C 0C AE 0C
$43C0  0C 8E 27 0C 8D 2E 0C AD 0C 0C AE 0C 0C 8E 28 0C
$43D0  8D 2F 0C AD 0C 0C AE 0C 4F 8E 29 0C 8D 30 4F AD
$43E0  0C 4F AE 0C 4F 8E 2A 4F 8D 31 4F A6 50 60 AD 0C
$43F0  4F D0 01 60 CE 34 4F 4C CA 56 10 10 15 15 15 15
$4400  20 79 33 8C 46 E0 03 06 05 33 81 E0 33 03 0E 03
$4410  0E 0E 00 00 10 1E 1D 1B 17 0F 03 37 46 67 7F 25
$4420  55 10 47 7D 3D A9 49 BE 7C B4 8A CB 98 E2 A6 F9
$4430  1F D7 2E EC 10 C2 92 9E 2C 53 03 68 A8 B4 D5 02
$4440  C9 ED E1 17 43 37 37 62 62 6B 6B 22 22 03 03 52
$4450  3A 52 6A AC 76 D3 8B EB 97 00 69 7E 2A 3F 3B 68
$4460  87 C3 24 4E 41 ED 65 17 03 03 3A B8 4F CA 11 3B
$4470  26 4D E7 5F FC 71 8D DE FA 91 BB 1E 2D D0 EC 16
$4480  01 28 64 DC 79 EE 8E 00 A3 12 03 03 39 60 9C D5
$4490  03 03 03 03 03 03 03 03 86 C5 9B D7 4E A2 B4 63
$44A0  22 03 03 B1 72 B1 03 22 83 6B 6B 22 22 03 03 03
$44B0  98 22 AD 01 BE BE 27 BE BE 22 51 22 22 03 03 22
$44C0  22 03 03 43 43 37 37 43 43 37 37 22 22 03 03 22
$44D0  22 03 03 BE 03 BE 66 17 7B BE A5 4E BA 60 60 17
$44E0  40 BE C2 4E EC 03 03 BE FD BE BE 4E 03 03 03 07
$44F0  03 67 66 07 07 00 67 07 09 03 03 66 00 66 07 07
$4500  4F F0 9C 1E 00 1E 1E 1E 00 D6 0E 66 9C 1E 63 67
$4510  1E 63 63 00 05 64 00 00 00 00 1E 5F 5E 5F 5F 1E
$4520  1E 1E 04 1E D6 04 9C 1E 62 61 62 9C 1E 5D 5D 5D
$4530  5E 5E 5D 1E D6 08 60 61 60 D6 0F 61 1E 04 5F D6
$4540  04 5E D6 06 61 F0 9C 1E 9C 4E 4F F0 9C 1E 9C F0
$4550  9C 1E 9C F0 9C 1E 4F F0 9C 1E 17 F0 9C 1E 4F F0
$4560  9C 1E C0 2F A7 4D C0 2F A7 4D 4F F0 9C 1E 4F F0
$4570  9C 1E 9C 1E 9C 1E 17 F0 9C 1E 17 1E 17 1E 9C 63
$4580  9C 1E 9C 62 9C 1E 4E 67 4E 60 17 1E 9C 1E 49 1E
$4590  1E 1E 44 F0 9C 1E 1E 44 41 4E 4F F0 9C 1E 1E 1E
$45A0  1E F0 9C 1E 12 0E 12 82 12 0D 13 CE 49 82 49 82
$45B0  05 31 05 31 A7 4D A7 4D 41 4E 41 4E 9C 1E 9C 1E
$45C0  9C 1E 9C 0C 1E 1E 1E 0D D6 07 1E 0B 9C 1E 9C 1E
$45D0  82 1E 19 10 19 19 19 3C 3C 3C 3C 50 4E 4E 4E 1E
$45E0  1E 1E 1E C4 E3 1E C4 F8 F8 E3 C4 81 82 C4 82 C4
$45F0  82 C4 82 C4 50 19 50 19 50 19 50 19 82 3C 82 3C
$4600  82 3C 82 3C 82 3C 82 3C 82 3C 3C BE 15 39 3C 3C
$4610  3C 50 11 50 82 3C 8D 18 03 7C 7D 5D 5C 1E 8D 18
$4620  03 7C 7D 5D 5C 1E 8D 18 03 7C 7D 5D 5C 1E 8D 18
$4630  03 7C 7D 5D 5C 1E 85 CE 03 AF 83 50 82 3C 85 CE
$4640  03 AF 83 50 82 3C 85 CE 03 AF 83 50 82 3C 85 CE
$4650  03 AF 83 50 82 3C 00 14 00 50 82 3C 5C 50 3C 3C
$4660  1E 1E 5C 1E 5C 1E 5C 1E 5C 1E 5C 1E 5C 1E 5C 1E
$4670  5C 1E 5C 1E 5C 1E 5C 1E 5C 1E 5C 1E 82 3C 82 3C
$4680  82 3C 82 3C 82 3C 82 3C 82 3C 82 3C 82 3C 82 3C
$4690  82 3C 82 3C 82 3C 82 3C 82 3C 82 3C 03 F7 03 AF
$46A0  83 50 82 3C 82 C4 83 50 82 3C 83 50 82 3C 83 50
$46B0  82 3C 83 50 82 3C 82 3C 82 3C 83 50 82 3C 83 50
$46C0  82 3C F0 50 82 3C 83 50 82 3C 83 50 82 3C 83 50
$46D0  82 3C 83 50 82 3C 83 50 82 3C 82 3C 82 3C 3C 50
$46E0  82 3C F0 F5 F0 0E 0E 0E 0E 0E 3C 28 11 AF 82 3C
$46F0  82 3C 22 28 1C 04 60 60 BE BE 22 60 60 60 01 BE
$4700  BE BE D6 04 22 D6 22 C1 BE BE BE BE 22 22 D6 60
$4710  1C 24 34 24 00 22 F8 D6 38 22 22 22 22 4E 53 22
$4720  53 22 53 22 55 C1 55 9C 9C 9C 0C 22 22 C1 60 C1
$4730  32 22 22 56 22 85 22 00 26 03 FE 03 C1 C1 C1 00
$4740  3F 8C 0D 3F C1 3F C2 08 9C 8C 9C 85 4C 22 22 01
$4750  22 B0 4E 60 6D 3C 2C 38 7C 67 27 7D FC FC F8 B2
$4760  03 27 33 36 34 24 0E 1C C1 C1 C1 C1 C1 C1 C1 56
$4770  56 56 56 C1 C1 C1 C1 55 7F 22 FF C0 FF B0 FC B0
$4780  B0 B0 83 FC 43 FC 60 10 60 B0 4E 60 3F 8C 9C 80
$4790  E3 F8 F8 E3 8C 9C 04 0B 53 22 00 60 00 60 BE 1A
$47A0  22 60 4E 85 4E 82 6C E3 E3 00 60 55 3E BE 3D 8C
$47B0  9C 88 24 24 BE C1 E4 C0 24 24 0E 60 60 C1 7C F8
$47C0  04 0C BC 98 22 08 E4 4E 60 6D 22 2A 22 2A 60 17
$47D0  58 4E 60 C1 4E 4E 4E 4E B7 C1 C1 30 4C C1 C1 55
$47E0  BC 4E 60 82 C1 08 0C 1E 0A 1E 1E 1F 03 1F 0D 3D
$47F0  6D 67 60 2A 11 1B 16 14 5C 38 15 15 00 60 4E 60
$4800  4E D0 6D 17 6D 4E 4E 85 4E 10 4E 4E 82 F8 6D 6D
$4810  03 6D 02 FC 02 F4 13 34 13 0C 1F 0C 7C F0 0C 18
$4820  3C 34 1C 3E E6 E4 BE 3F 3F 1F 4D C0 E4 CC 6C 24
$4830  24 C1 38 0E 03 0E 15 C9 0E BE 1C 1C 1C 24 12 18
$4840  9F 9F 8E 6D 13 C4 2A 6D 17 9C 17 6D 0E ED 8C 9C
$4850  B7 48 17 6D 17 60 C1 C1 24 01 4E 01 6D F8 C8 6D
$4860  4E 4E 4E 03 08 01 27 03 34 24 00 6D 6D C1 7C F8
$4870  20 C1 3D 19 17 6D C1 C1 8C 6D 17 6D 8C 6D 8C C1
$4880  C1 C1 F8 4C 07 FC 07 FE 01 FE 17 6D 55 6D 2A 0A
$4890  17 6D 17 6D 0E 6D F8 6D 6D 6D 0E 1B 17 3B 6D 6D
$48A0  6D F8 6D 17 4E 0E 0E 85 17 6D 4E 55 32 55 3F 6D
$48B0  7F E0 7F 80 C1 55 C1 B7 50 6A 71 17 6D 28 C1 B0
$48C0  6D 6D 78 8C D8 04 DC C1 C1 02 8C 9C 04 16 17 6D
$48D0  0E 6D 0E 6D C1 34 C1 30 6D 6D 6D C1 4E 4E 0E 0E
$48E0  00 BE 74 BE 7A 2A 3A C1 12 BE BE BE 2A 72 C1 68
$48F0  17 6D 28 C1 28 24 C1 C1 0E F8 F8 56 6D C1 C1 C1
$4900  F8 F8 34 55 28 2E B7 5E B7 5C 8C 9C B7 30 78 50
$4910  78 78 F8 C0 F8 B0 BC B6 E6 E1 E1 88 D8 68 28 3A
$4920  1C 9C 9C 9C 4E 8C 9C C1 2C 0E 0E 0E 0E BE 55 2A
$4930  F8 28 64 55 7C 55 55 00 FF 00 FD 00 BD 00 B3 20
$4940  C3 20 07 E0 3C F8 E3 C0 BE A8 BE BE 08 38 7C F8
$4950  40 48 18 F9 F9 71 24 24 24 EA E4 D0 40 40 48 58
$4960  24 34 24 C1 02 42 4C 55 78 43 4E 0E 0E 00 08 0C
$4970  55 78 55 E3 7E FF 55 00 44 6E 34 24 A9 E7 08 08
$4980  55 E3 85 8D 89 FF FE 7E 7C F8 C4 E3 E3 E3 F8 F8
$4990  E3 6C C6 55 2C 78 3C 78 74 70 B0 4E 0E 0E B0 7C
$49A0  FD B9 81 00 B1 F5 FB F9 78 1C 1C D6 05 E3 E3 7C
$49B0  E3 F8 F8 30 00 10 12 32 F8 E3 A0 B2 BE DF 55 F9
$49C0  55 56 F8 6C 37 33 16 13 F8 2A 08 4C 4C F8 E3 05
$49D0  4D 7D FB FF 7E F8 56 F8 28 EC CC 68 C8 F8 24 2C
$49E0  C4 2C 28 E3 28 E3 38 F8 E3 2C 78 60 04 6C EC CE
$49F0  8C 9C 42 E3 28 E3 C4 2C C4 2C 28 E3 28 E3 7C F8
$4A00  E3 88 E3 E3 6C 46 C7 01 82 82 C4 2C E3 6C 28 E3
$4A10  88 30 E3 68 3C 0C 40 6C 6E E6 C8 E3 84 E3 FE FE
$4A20  82 82 C4 2C E3 6C 28 E3 3E 1F E3 20 E3 E3 36 62
$4A30  E3 80 30 30 8C 8C DE 9E 1E 30 24 56 30 E3 3F 3F
$4A40  E0 56 30 34 2A 2A 30 31 7B 79 78 2A 2A 2A F0 80
$4A50  FC FC 30 30 30 30 30 30 30 30 30 30 30 6C 40 30
$4A60  30 28 86 9C 30 30 30 9C E3 FE FE 82 82 2C 2C 6C
$4A70  6C E3 E3 01 04 E3 B8 B8 30 E3 82 82 C4 2C E3 6C
$4A80  28 E3 E3 30 28 28 C2 72 6C 28 E3 9C E3 FE FE 6C
$4A90  6C E3 E3 6C 6C E3 E3 ED 20 56 1D 1D 24 24 C1 56
$4AA0  30 56 30 7C 70 2C D8 CE CE E3 7C 2C C4 2C 28 E3
$4AB0  28 E3 66 18 1C E3 3C 3C 9C 24 24 BE 9F FB F3 E3
$4AC0  9C E3 E3 6C 6C E3 E3 66 E3 C0 54 E3 E3 4E 30 24
$4AD0  21 30 31 31 30 9C E3 E3 E3 28 05 23 0B 03 82 9A
$4AE0  D8 98 9C 9C 4E 24 00 24 6C E3 E3 E3 34 24 ED 30
$4AF0  E3 E3 7C 74 E3 E3 FE FE 82 82 C4 2C E3 6C 28 E3
$4B00  9C 18 3C 14 E3 3C 9C 0E 9C 1B 73 73 72 9C 9C 0E
$4B10  22 36 36 22 22 66 18 38 E3 3C 3C 9C 60 24 7D F9
$4B20  DF CF 4E 7C 00 44 6C 6C 44 44 66 80 E0 C0 D4 E3
$4B30  E3 4E 0E 0C 0E 00 E3 7C 3B D2 82 80 07 03 2A 28
$4B40  1C 24 E3 9C 84 E3 8C 8C E3 13 3E 1C E3 E3 A0 C4
$4B50  D0 C0 41 59 1B 9C 88 13 C4 13 30 9C 7C E3 E3 28
$4B60  9C 0C 1C 16 9C 9C 3C 4F 88 E3 7C E3 38 08 E3 4E
$4B70  E3 E3 4E 4E 24 E3 4E 0E 0B 0F 0F 1E 1C 7E FE 3C
$4B80  3E 13 01 20 E3 3C FC 8C 84 88 E3 88 E3 88 E3 88
$4B90  E3 38 38 7C 7C 3C 38 20 0C 0E 0C 1C 4E 02 4E 4E
$4BA0  60 70 D0 F0 F0 78 38 7E 7F 3C 7C C8 80 88 E3 3C
$4BB0  3F 31 21 9C 88 E3 E3 4F 4F E3 E3 34 4E 4E 0E 0E
$4BC0  4E 1C 4F E3 E3 28 04 1C 0C 28 9C 9C 2A 34 24 BE
$4BD0  01 01 34 3C B8 1C 4E F3 40 9C 60 28 1C 1C F3 E3
$4BE0  E3 4E E3 E3 C0 70 38 38 E3 28 20 38 30 14 28 28
$4BF0  28 28 00 E3 ED ED 2C 3C 1D 09 4E 85 4E ED 8C 9C
$4C00  90 9C 9C 98 BC BE FE FE BD 99 BC 3C 26 62 42 C3
$4C10  88 1C 88 39 39 B9 99 BD 7D 7D 3F 3B 19 1D 88 4E
$4C20  85 4E 20 60 60 01 0D 1C 0E 1D 19 3D 3F 3F 7D DD
$4C30  98 38 3C 4E 85 4E 04 24 24 00 2A 88 B7 1C 0E 88
$4C40  A9 2E 04 26 0E 4E 04 4F 88 27 04 1F 0E 1C 04 27
$4C50  80 3F 80 0E 0E 0E E0 1C 4E 4E 85 4E 01 34 AA 88
$4C60  1E 18 D6 17 4E 4E EB 43 F0 41 00 A2 8A F0 00 99
$4C70  50 7F 50 3F F0 88 F0 3F 60 88 1E 99 1E 02 0E 0E
$4C80  0E 1C 04 19 88 1C 80 0E 80 39 1C 3E 0E 0E BE 79
$4C90  C1 7F 1C 1C 4E 38 85 88 C1 1C A9 14 C1 0B 85 4E
$4CA0  B7 06 D6 24 C1 4E 0F C2 CE 4E 13 45 00 4D 0A 99
$4CB0  0A FE 4E 4E 0F F0 06 FC 88 20 60 50 70 70 60 E0
$4CC0  F0 F8 DC BE 15 0E 1C 4E 60 58 78 88 7E 73 F6 DE
$4CD0  24 24 15 0C 0E 4E 06 0A 0E 0E 06 07 0F 1F 3B 2A
$4CE0  34 24 C1 0C 06 1A 24 3C 7E CE 6F 7B 12 34 24 2A
$4CF0  34 24 34 24 00 28 1C 0F 20 22 72 70 50 38 28 1C
$4D00  1F 00 04 4E 00 00 4E 4E 00 00 4E 4E 00 00 4E 4E
$4D10  4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 10 24
$4D20  24 24 24 BE 04 04 0F 04 44 4E 0E 0A 1C 14 38 F8
$4D30  70 24 C1 04 04 19 19 24 24 24 24 C1 0E 0E 0E 03
$4D40  24 03 30 03 90 0F 80 0C C0 0C E0 04 F3 3F F3 F3
$4D50  04 04 06 0C 0A 3E 4E 4C D6 1D 04 04 04 18 18 12
$4D60  79 94 24 C0 1F B1 1F B3 D6 0F 04 24 30 50 7C 70
$4D70  30 D6 0E A9 24 00 04 18 48 18 29 9E 24 FE 8F F8
$4D80  CF F8 24 60 20 60 70 70 3C 3E 3A 3A 04 0E 70 18
$4D90  04 18 08 F3 04 0F 0A 04 0E 18 08 0E 0F 24 BE F3
$4DA0  24 00 04 F3 04 0E 0E 3C 7C 5C 5C 4E 4E B3 24 C1
$4DB0  0E 30 38 24 1E 24 C1 04 0E 0E 0E 4E 0E 0E 0E 1C
$4DC0  3C 24 0C 0C 24 0E 0E 0E 0E 0E F6 24 0F 50 58 18
$4DD0  18 10 70 F0 24 00 20 24 15 0E 0C 2C 4C 44 0E 0E
$4DE0  40 F3 04 08 78 78 4C 2C 24 16 AF AF 3D 4E 0C 0E
$4DF0  1A 19 B5 B5 E3 24 24 00 08 0F 0F 19 1A 12 34 24
$4E00  64 0E F6 08 C1 C1 C1 7E DB C5 C1 06 C1 C1 81 DB
$4E10  C1 7E C1 C1 C1 C5 C1 C1 C1 1C 1C C1 C1 7E 7E 7E
$4E20  42 C1 C1 C1 0E BE C1 C1 C1 81 81 C1 00 C1 ED 7E
$4E30  E7 C3 A9 0E A9 99 BD FF BD ED C1 C5 C1 0F 0E 0E
$4E40  C1 ED 24 42 C1 ED 30 24 20 20 C1 C1 0F 99 99 D6
$4E50  06 18 ED ED 00 C1 C1 58 7E 3F 7F F9 DA 9C 88 15
$4E60  15 15 4E 4E 4E 4E 00 C1 80 02 0A 0F 2A 00 0E 0E
$4E70  03 FE 07 FE CF C1 CC C5 C1 00 0D 0E 0E 24 0E 24
$4E80  C1 00 60 C0 90 00 00 00 00 D6 01 03 04 0E 1F 5F
$4E90  7B 33 36 0E 1E 3C 0E 06 03 09 BE BE BE BE 00 80
$4EA0  C0 20 70 F8 FA DE CC 6C 0E 78 3C C1 B7 00 00 03
$4EB0  85 4E 00 C1 0F 01 02 0A 0F 2A 00 20 7F C0 7F 0E
$4EC0  54 F3 B7 33 4E 4E B7 B0 4E 4E 03 09 09 09 10 30
$4ED0  68 58 78 7F 3F 7D 7C 7C 58 0E 0E 0E BE C1 C1 C1
$4EE0  1A 1E FE FC BE 3E 3E 1A 00 00 00 00 00 0C 16 1A
$4EF0  7E FC FE 9F 5B 39 24 00 2A 0E 4E 14 4E 4E 0C 0E
$4F00  1E 36 72 A9 A9 10 30 28 4E 4E 30 70 78 6C 4E 38
$4F10  0C 06 12 BE BE BE BE 00 88 8C A9 1C 1C 34 14 14
$4F20  A9 A9 E7 30 60 48 50 A9 F6 A9 B0 11 31 A9 38 38
$4F30  2C A9 A9 24 66 E7 54 05 F6 A9 F6 A9 E0 A9 3E 7A
$4F40  7A 70 80 15 BE 15 08 C0 40 C0 E0 70 F6 A9 F6 A9
$4F50  F6 A9 B0 06 A9 06 0E 1C A9 A9 38 A9 A9 A9 B0 03
$4F60  A9 03 07 A9 7C 5E 5E 0E A9 A9 A9 00 55 54 05 F0
$4F70  14 F6 A9 B0 0A 9A 9E 1C 28 6C 43 41 41 00 00 00
$4F80  00 E0 A9 B0 30 14 A9 A9 B0 00 2E 3C 3C 4E 4E 08
$4F90  4E 00 A9 A9 A9 B0 0E 4E 1A 4E 10 F6 A9 B0 0E E8
$4FA0  78 78 4E 4E 20 60 0E 0E 0E 0E B0 07 A9 0D 0C 00
$4FB0  34 00 00 50 59 79 38 14 36 C2 82 82 03 24 24 00
$4FC0  03 85 4E E0 4E 24 A9 A9 A9 BE 3C BE 38 4E 82 C9
$4FD0  0E 24 4E BE 70 01 F8 0E 1C A9 A9 85 1E 85 4E 0E
$4FE0  A9 85 00 00 00 40 30 B0 98 FC 4E 3E 1E 4E A5 00
$4FF0  4E 04 0C 0D 19 3F 4E 7C 78 15 BE 15 08 4E 85 4E
$5000  E0 B7 B7 00 B7 B3 82 B7 10 B7 B7 00 85 85 C7 A5
$5010  A5 B7 B7 B7 B7 B7 B7 B7 70 B7 B7 82 50 82 B7 00
$5020  98 82 9C B7 B7 00 B7 BE E0 82 B7 B7 10 B7 82 00
$5030  34 00 00 60 BE BE 2A A5 82 B7 82 0C 82 B7 0E B7
$5040  0E B7 01 4E 01 09 00 19 00 39 98 9C DC 8C F0 8C
$5050  F0 00 01 B7 18 B7 B7 24 4E 64 04 04 06 06 19 39
$5060  3B 31 30 D0 13 13 ED B7 18 18 24 24 26 26 20 20
$5070  60 60 CE 4E 0E 30 B7 09 B5 90 00 00 17 85 B5 09
$5080  0C 09 09 09 11 09 00 30 07 30 B7 10 CF 10 D6 B3
$5090  01 31 39 09 39 39 19 3D 7D 7F 7F BD 99 3D 3C 64
$50A0  46 42 C3 B7 B7 02 01 61 72 F0 B7 B7 B7 B7 78 B7
$50B0  B7 B8 98 18 B7 0C 00 0C 9D 00 00 02 61 73 36 7C
$50C0  7C 4E 78 78 7C B8 BC 2E 22 12 B7 08 B7 10 B7 40
$50D0  80 86 4E B7 A5 A5 B7 B7 1E B7 B7 1D 19 18 4E 30
$50E0  20 30 08 10 20 40 86 CE 6C 3E 3E 1C 1E 1E 3E 1D
$50F0  3D 74 44 48 18 10 18 01 02 1C 1C 0C 3C 5E CE 4E
$5100  7E 3E 0F 1F 36 26 64 64 C2 70 70 E4 C3 EB 0E EB
$5110  13 EB 13 13 80 EB EB EB F0 EB EB 3F F0 EB EB 03
$5120  F0 03 3C 03 CC EB CF EB 41 EB C4 80 40 38 38 30
$5130  3C 7A 73 72 7E 7C F0 F8 6C 64 26 26 43 EB 80 24
$5140  BE 15 0E EB EB 8D 24 8D 04 03 EB EB 24 EB EB 0F
$5150  FC 0F EB 0F 24 3C 0F 2A 24 F3 EB F0 13 C4 13 3F
$5160  06 32 3A 0A 3A 3A 1A 7E 7E FC F8 B8 10 38 78 68
$5170  4C 74 74 14 16 89 8D EB EB E0 EB A3 C3 EB 81 E0
$5180  A3 81 E0 A3 05 85 C7 04 85 F0 85 85 15 86 85 85
$5190  B5 EB 81 8C 85 15 88 EB EB EB 81 E0 A3 EB 04 AA
$51A0  8A F0 07 F0 F0 F0 10 81 E0 81 E0 76 85 85 B6 89
$51B0  F0 04 85 E0 45 EB EB 08 F0 F0 15 8A F0 E9 B5 B5
$51C0  1E 08 1B B5 B5 B5 B5 ED 23 EB 85 85 85 B5 B5 F0
$51D0  81 E0 04 85 04 04 04 85 E0 04 85 E0 E0 04 70 70
$51E0  BF 2A 85 85 E9 A6 08 8D 12 04 85 04 85 21 01 01
$51F0  A2 85 F0 04 F0 AA AA F0 F0 15 8A F0 8A F0 04 85
$5200  81 37 B5 B5 C5 F0 B5 C7 F3 F0 21 F0 E3 6E B5 B5
$5210  B5 B5 B5 48 F0 C7 82 BB F0 C0 F0 F0 86 B5 B5 B5
$5220  B5 B5 CC F0 B5 02 20 F0 21 C7 F0 F0 A6 F0 1E 04
$5230  A9 03 8D 01 01 00 94 B5 B5 E9 17 B5 B5 81 15 06
$5240  B5 B5 2C E0 E0 86 AA F0 F0 15 B1 92 06 99 1E 92
$5250  B1 BB 81 E0 E0 04 9C 0F B5 B5 B5 B5 1E 86 9C F0
$5260  97 95 97 9C 14 1E 1E B2 B9 99 1E D3 E0 E0 CE 81
$5270  D2 0E B5 B5 B5 B5 B5 81 F0 E0 F0 B5 98 E0 99 E0
$5280  E0 E0 E0 80 12 F0 F0 F0 F0 F0 A3 F0 F0 E0 10 89
$5290  88 8A F0 8A F0 B5 8A F0 15 F0 A3 F3 F0 E0 F0 81
$52A0  82 F0 8E E0 E0 E0 B5 B5 37 F0 8B B6 04 81 E0 81
$52B0  E0 A3 F0 15 82 F0 E0 03 89 C7 F0 B5 F0 F0 F0 EA
$52C0  C7 F3 F0 A3 8A F0 1E C7 F3 F0 B5 8E 8A F0 10 F0
$52D0  B5 8E A3 E0 B5 1E A3 A3 E0 E0 A3 B5 B5 84 26 F0
$52E0  E0 85 37 B5 B5 B0 F3 F0 E0 F0 F0 90 81 E0 03 90
$52F0  E0 2A F0 F0 E0 A6 B5 57 F0 AA AA 8A F0 AA 8A F0
$5300  15 B5 15 1E 82 3D 2B B5 1E 63 63 8A 8A 15 15 A8
$5310  15 15 15 57 82 8A F0 15 99 15 F0 15 1E 15 E1 82
$5320  24 3A E1 E1 10 F0 15 F0 15 9D 15 15 00 15 B5 15
$5330  A9 37 B5 B5 A9 15 1E 1E 1E 1E 04 82 E0 E0 03 99
$5340  1E A6 07 1E 82 A9 1E 15 A9 85 1E B5 1E 15 57 15
$5350  15 15 15 15 15 15 A8 B5 B5 83 B5 B5 B5 57 B5 B5
$5360  2C 14 99 1E E9 B5 B5 57 15 A8 83 B5 B5 10 03 A8
$5370  88 57 B5 57 15 00 99 1E 99 1E E9 83 1E E3 96 37
$5380  B5 B5 1E E3 E3 85 1E 1E 99 15 9D 15 B5 8B 9B 96
$5390  9D 00 B2 00 15 91 AA 8A F0 15 1E 04 04 04 9A B5
$53A0  B5 B5 E0 15 E0 02 A2 E0 E0 85 E0 A3 F0 15 9A B5
$53B0  1E 86 1E 1E 9A 91 B9 91 80 28 B5 8A F0 15 15 23
$53C0  F0 15 23 15 F0 A3 02 15 87 A3 E0 E0 A3 15 B5 81
$53D0  E0 A3 88 B4 B5 23 33 F0 15 36 23 02 33 83 34 35
$53E0  36 06 E0 81 B5 B5 1E 15 37 B5 B5 10 B7 C5 15 15
$53F0  B5 E0 C5 6A 6A B5 E9 82 07 6A 6A EA 81 37 B5 B5
$5400  83 37 1E 37 57 1E 87 0B B6 89 8A B6 8A 84 21 E9
$5410  83 EB EC ED 57 E9 09 57 57 B0 B0 57 1E 11 04 57
$5420  57 11 02 57 24 A6 C5 C5 FC B0 57 80 57 1E 84 11
$5430  EE EF F0 99 1E 82 BB 57 02 57 86 57 B1 10 57 57
$5440  57 14 14 8A 2C E0 E0 E0 B0 57 B0 57 92 57 57 A2
$5450  84 94 E0 E0 D0 57 80 04 04 04 6A B2 83 1E 95 99
$5460  1E E9 14 99 1E 1E 57 21 70 20 E0 E0 A3 1E 1E 1E
$5470  70 57 1E 00 8C 57 B2 57 81 CA 04 AF C5 57 B2 B8
$5480  1E 02 A9 86 1E 57 E0 57 57 1E 1E 1E 82 A5 E0 2A
$5490  21 83 20 80 A6 57 57 99 A9 02 1E 99 1E D3 80 8A
$54A0  E0 80 C6 AF AF AF AF CC B9 BB 02 B0 8E 57 B0 57
$54B0  00 57 57 57 57 10 10 57 57 93 00 03 2C 88 80 94
$54C0  B0 57 92 A8 92 93 A2 A2 24 99 99 99 57 57 57 57
$54D0  9C 81 1E 1E B2 E0 E0 81 1E 1E 1E 9C 99 1E 1E 10
$54E0  B0 57 99 EA EA 83 99 14 99 99 1E E9 99 1E 14 82
$54F0  9C E0 14 9C 83 80 B2 6E B5 B5 1E E0 E0 A3 81 E0
$5500  03 A3 A3 A3 A3 E0 09 1E 33 A3 E0 E0 05 E0 83 E0
$5510  E0 CD 04 CE E0 E0 E0 80 84 A3 A3 A3 A3 A3 89 81
$5520  A3 02 A3 89 A3 A3 1E 33 A3 A3 A3 A3 A3 02 89 94
$5530  33 A3 A3 A3 1E A3 A3 33 A3 B6 1E A3 A3 B5 A3 B5
$5540  B3 B5 B6 89 A3 33 A3 A3 84 A3 8E A3 A3 A3 A3 81
$5550  C5 C5 A0 83 8B 8E 33 A3 33 A3 EA A3 A3 B5 EA EA
$5560  A2 83 A3 E0 C5 C5 76 81 8B A3 E0 97 3B D0 F4 20
$5570  F4 20 33 A3 33 A3 69 00 1E A3 A3 3C A3 A3 33 A3
$5580  69 A3 69 6A 6A 22 A3 3C A3 3C 69 A3 69 80 68 3C
$5590  6A 3C 69 A3 33 A3 33 A3 33 A3 33 A3 33 A3 33 A3
$55A0  15 E3 E3 96 36 A3 A3 83 96 A3 96 02 A3 B5 15 E0
$55B0  E0 B5 36 A3 A3 82 15 BE 2A 04 A3 A3 A3 2A 04 04
$55C0  B9 09 05 AA 07 4B A3 AA 04 2A 03 A3 E0 AA E0 DA
$55D0  E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 5C 97 16 E0
$55E0  B2 E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 B5 E0 E0 E0 E0
$55F0  E0 E0 E0 DA E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 E0 E0
$5600  96 E0 5C E0 C5 14 14 14 14 14 E0 5C E0 B5 1C E0
$5610  E1 E1 8A E0 DA DA E0 E0 14 97 58 97 58 97 5C E0
$5620  5C E0 5C E0 5C E0 C5 95 B2 E0 B5 E0 E0 B5 B5 E0
$5630  B5 14 B5 B5 DA DA E0 E0 B5 E0 E0 B5 E0 E0 E0 E0
$5640  03 E0 E0 1C E0 E0 C5 90 E0 1E B5 21 20 B5 15 E0
$5650  17 B5 E0 1E 84 E0 E0 1C B5 B5 B5 03 E0 C5 B5 03
$5660  9C 16 9C 14 14 C5 82 82 E3 E3 83 1C 16 1C 14 14
$5670  14 B2 DA 5C E0 AD E0 E0 22 82 91 E0 E0 E0 E0 B5
$5680  E3 E3 96 B5 07 8F 6E B5 B5 1E B5 22 84 E0 AD B5
$5690  AD B5 B5 1E B9 80 6D 99 E0 AE E0 C0 6D EF 62 DA
$56A0  5C E0 B5 C0 0F AE 84 99 E0 D1 D0 04 B5 E0 E0 5C
$56B0  5C E0 D1 B5 B5 B5 B5 B5 6A B5 B5 B5 B5 B5 B5 B5
$56C0  B5 14 E0 B5 86 D0 B5 48 D1 E0 5C 03 B5 B5 D0 A3
$56D0  6A 18 1E 1E 01 85 DA 5C E0 B5 1E 1E 14 14 1E 1E
$56E0  6D B5 03 E0 B5 85 1E 1E E9 E0 B5 06 B5 82 82 B5
$56F0  B5 03 86 AA B5 B5 B5 B5 B5 B5 03 B5 B5 6E B5 B5
$5700  03 03 03 03 AA 04 04 14 00 B5 48 03 00 01 01 6D
$5710  83 AA B5 03 03 48 87 03 03 E3 48 03 00 B5 48 03
$5720  85 03 03 03 AF 01 01 01 03 D3 03 6E D7 03 03 90
$5730  79 0F 48 03 48 03 48 48 03 48 03 48 03 03 02 6E
$5740  6E B5 B5 03 03 B5 B5 03 03 E3 03 90 85 03 48 04
$5750  04 C1 03 48 85 D3 04 C0 6E 04 04 90 DE 6E DE 6E
$5760  DE 6E 48 03 48 03 48 03 48 03 96 03 03 96 87 97
$5770  03 48 03 48 03 E3 03 AA 6E 48 03 48 03 48 03 48
$5780  03 03 14 14 14 B2 04 AA 87 03 E3 20 21 00 E3 95
$5790  1E 96 96 97 E3 E3 96 99 1E 99 1E 9D E3 E3 03 2C
$57A0  87 E3 E3 E3 D3 E3 04 48 03 48 03 48 03 48 03 03
$57B0  1E E3 99 D3 04 D3 04 6A D0 04 04 02 2C 83 E3 96
$57C0  1E 1E 1E 1E 99 03 03 03 03 03 03 09 14 14 1E 1E
$57D0  E1 0F 0F 03 03 03 03 11 E3 E3 1E 99 1E 99 B2 09
$57E0  03 1E B9 1E 1E 1E 1E 1E 1E 1E 01 11 91 82 B9 E3
$57F0  12 70 81 E3 96 A8 04 8F 12 A8 85 D3 04 82 1E E3
$5800  23 1E 6A 96 96 A3 6A E1 96 1E 96 A8 96 96 96 A8
$5810  96 E3 96 01 96 3E 82 1E 96 96 C0 8A B0 1E 3E 96
$5820  96 93 96 6A 96 93 96 E9 9D 1E 1E 96 96 96 96 96
$5830  6A 96 6A 96 6A 96 C1 D3 1E 96 96 B2 96 93 99 1E
$5840  99 1E 6A 96 96 B2 96 6A 96 6A 96 6A 96 6A 96 97
$5850  1E 1E 1E 1E 1E 1E 83 E3 6A 96 6A 96 E9 83 96 96
$5860  E9 96 90 08 E3 E3 96 96 96 96 AD 0A 99 1E 01 96
$5870  3E 85 6A 96 23 1E 6A 96 3E 14 1E 1E E9 83 D3 04
$5880  01 96 96 96 D3 CF 1E 6A 96 D0 02 9C 86 1C D3 04
$5890  C1 85 6A 96 CF 8A D0 1E 85 99 1E B2 E3 E3 1E 1E
$58A0  96 96 E9 D3 1E 1E 1E 1E 1E 1E 1E 1E 1E 1E 97 1E
$58B0  E9 85 01 01 A3 1E 14 99 1E E9 84 1E 0C 99 1E 99
$58C0  1E 99 1E AD 06 1E 01 1E 96 E9 88 99 1E AE 1E 14
$58D0  99 1E B0 96 3E 96 1E 96 04 96 CF 85 1E 1E 6A 04
$58E0  96 96 CF 8D 04 20 9C 81 D0 85 9C 84 D0 1E 6A 1E
$58F0  85 1E 1E E9 96 1E 1E 1E 1E 1E 1E 1E 1E 14 99 1E
$5900  82 A7 93 0A 39 39 39 39 E9 E9 E9 E9 97 E9 E9 E9
$5910  E9 E9 B2 93 E9 E9 E9 1E B2 E9 1E 85 04 04 6A 1E
$5920  1E B2 0C E9 87 E9 E9 97 E9 95 96 97 E9 E9 E9 14
$5930  E9 E9 E1 14 14 E1 83 14 14 14 14 14 E9 B2 AE 0C
$5940  C7 E9 AD 01 3E 03 AD E9 3E 01 01 05 3E 89 AE 3E
$5950  AF 01 01 63 B0 3E AE 80 84 D1 6A A3 6A 6A D3 C7
$5960  E9 00 C7 E9 6A D1 6A 6A 6A D0 81 E9 00 D1 86 85
$5970  85 04 04 B9 00 00 6A 6A 6A 1E 6A D1 85 85 04 04
$5980  6A 01 01 01 D7 E9 E9 04 A6 15 1E 1E A5 14 14 E1
$5990  01 01 01 01 01 D7 04 04 04 04 EB 04 A6 E9 E9 04
$59A0  C7 E9 C0 E9 E9 87 1E 03 E9 87 C0 04 92 87 1E 04
$59B0  A5 7A 7A 06 4A 87 39 AC 94 C7 E9 F0 1E B2 01 01
$59C0  84 E9 E9 93 89 14 14 70 A3 E9 E9 9C 89 99 1E 9C
$59D0  A3 6A EA 84 89 1E A3 93 1E 99 1E 99 1E 6D E9 E9
$59E0  F0 04 B2 E9 E9 1D C7 E9 C7 E9 89 1E 1E 01 89 99
$59F0  1E 1D 1E 1E BC 84 1E F0 04 04 03 11 1E A6 99 1E
$5A00  A2 1D 1D 1E 1E A9 06 1E A2 A9 EA EA A2 A5 D3 04
$5A10  9C 1E B5 BC 29 80 F0 1D 99 1E 1E 85 00 FE 99 1E
$5A20  92 1E A8 09 92 F0 A8 84 92 A8 92 FF F0 1D 99 1E
$5A30  F0 1D 99 1E F0 1D 99 1E 1E 86 04 04 A3 F0 1D 99
$5A40  1E F0 1D 99 1E F0 1D 99 1E 9C 85 99 1E 89 C5 99
$5A50  1E C5 1E 99 1E 99 1E 99 1E 99 1E 99 1E 1E 1E 83
$5A60  89 1E 99 1E 9C 01 9D 09 1E 01 9B 02 9C 83 9D 01
$5A70  89 01 01 01 01 01 6D 99 1E D7 14 13 1E 28 1E 04
$5A80  82 AD 99 1E AD 1E 1E C5 C5 98 1E 04 AD 82 1E AD
$5A90  99 1E D3 01 01 01 01 01 24 D7 83 A3 6A A3 6A 6A
$5AA0  D7 80 1E B2 82 D1 93 1E C5 1E A7 D3 04 CF 04 D3
$5AB0  04 6A 07 04 04 D3 8D 99 1E 04 1E 14 1E 04 14 B2
$5AC0  04 04 04 D1 1E B2 0E 00 87 1E 1E 9D 04 D3 04 9D
$5AD0  A2 A2 7A 1E 1E C5 04 B2 05 1E 1E 04 08 91 85 04
$5AE0  04 9A 04 04 02 04 D3 04 D3 04 D3 04 81 B2 04 C5
$5AF0  02 B2 88 A7 B2 D1 04 01 04 04 04 04 A8 85 D3 04
$5B00  04 04 04 04 A7 04 01 82 A3 6A 6A 6A 83 04 04 6A
$5B10  03 A8 04 04 81 A7 C5 C5 A9 B2 A7 6D B2 14 6D B9
$5B20  C1 04 9D 11 04 E1 9B 9C 9D 14 14 8A 04 83 B9 04
$5B30  91 E0 04 B9 B9 04 04 9A 04 91 04 E0 03 91 81 E0
$5B40  06 91 83 04 AF 9A 07 91 04 B2 91 29 D7 88 D1 94
$5B50  93 6A 6A 6A CF B9 C1 04 C5 04 01 B9 C1 04 6A 81
$5B60  04 6A 00 04 D3 C1 04 A3 04 01 83 01 04 D3 6A 6A
$5B70  C5 04 D3 01 01 01 CF 81 D7 26 14 E1 84 D7 AA 02
$5B80  22 04 14 1F E4 04 AA 28 14 9F 00 01 82 6A A3 6A
$5B90  6A 83 A7 04 D3 03 01 92 01 01 D0 E1 D1 C0 04 C1
$5BA0  04 C1 04 C1 04 6A C0 D1 E3 6A 6A D0 01 01 82 D3
$5BB0  CF 02 D3 85 CF D3 14 D0 82 0C 14 14 E1 C1 04 A3
$5BC0  14 14 14 14 14 14 6A 94 A3 E3 01 A3 82 B2 83 02
$5BD0  04 04 2A 04 14 B9 B9 04 04 14 14 14 14 14 14 14
$5BE0  14 4B EA EA 9C 14 14 10 81 14 03 2A 88 B2 14 70
$5BF0  14 14 14 14 70 14 14 14 E1 14 AA 14 14 14 14 14
$5C00  70 4B 01 AA 81 70 70 10 85 4B E1 14 70 0E 9F 13
$5C10  C8 4B E1 14 70 70 AA 70 6D 8E E1 B2 D0 E1 70 70
$5C20  9F 70 70 70 C0 D0 B2 E3 01 6D 86 AA 70 70 E1 E1
$5C30  70 70 6A 86 70 70 70 70 70 01 01 10 14 70 4B E1
$5C40  14 70 4B E1 14 70 4B E1 14 70 B2 C5 C5 8A 94 4B
$5C50  E1 14 70 D7 01 6A 85 D7 70 14 70 70 01 01 01 01
$5C60  01 01 9F 9F C8 C8 E1 E1 70 70 C8 01 B2 01 01 8C
$5C70  70 14 70 70 D7 70 70 70 14 70 70 C0 70 6A E1 70
$5C80  70 BE 8C AE 01 01 A3 70 70 70 70 9F 6A B0 AE E1
$5C90  70 70 AF 6A 6A 8B 01 57 70 9F 70 70 C8 70 70 9F
$5CA0  9F C8 C8 E1 E1 70 70 9F 9F C8 C8 E1 E1 70 70 9F
$5CB0  9F C8 C8 E1 E1 70 70 10 8A 70 14 70 B2 01 6A E1
$5CC0  14 70 63 C5 C5 48 70 70 E3 6A 6A C5 70 70 01 70
$5CD0  70 01 E1 E1 27 E1 E2 E3 10 10 8B AF 01 01 B2 85
$5CE0  BE 01 01 01 63 70 70 BE 70 AF 70 01 01 01 BE E2
$5CF0  70 BE 01 AF 06 01 01 01 01 BE 83 E2 BE AF 01 01
$5D00  81 B0 02 BE 86 AF 61 62 63 B2 BE 80 82 D1 A3 6A
$5D10  6A 85 D3 D1 A3 6A D0 0B A3 6A D3 D0 E2 D1 6A 6A
$5D20  82 D0 D3 01 01 E1 94 92 01 6A C0 01 A3 01 EA 01
$5D30  2A 22 6D 01 A3 01 09 05 2A 82 22 01 01 6D 6D 01
$5D40  E2 82 08 01 01 6D 04 01 01 01 10 10 27 01 01 09
$5D50  22 6D 01 6D 6A 6A E2 6D 01 6D 01 6D 01 03 AA 22
$5D60  6D 01 24 22 6D 01 6D 03 22 01 01 90 A3 6A A3 6A
$5D70  A3 01 01 01 6D 83 00 6A A3 6A AF 00 A3 6A 03 01
$5D80  6D 01 01 6D 01 6D 01 6D 22 01 01 01 01 09 84 E2
$5D90  01 01 A3 EA 01 01 6D EA EA 52 C0 57 57 01 01 01
$5DA0  01 6D 83 B2 00 A3 6A 6A 01 6D 02 6D 01 01 27 A7
$5DB0  93 10 10 27 01 01 01 A3 01 6D FB 09 FB 6D 01 6D
$5DC0  01 6D 01 6D 01 B2 6D 57 6D 01 6D 01 8F 01 01 A2
$5DD0  A7 EA EA A2 B2 A3 6A A3 6A 6A 8F 8D 04 90 A3 6A
$5DE0  6A A2 63 6A 6A A2 B2 01 BF 02 6A A2 01 05 BE 81
$5DF0  AF C5 C5 E1 B0 BE AE 05 BF 04 BE 83 AF 00 A3 6A
$5E00  6A 6A 6A E2 03 A7 83 18 18 6A 6A D0 84 6A 6A CF
$5E10  D0 6A 6A 6A D0 05 6A C5 D3 CF D0 CF 02 D0 82 A2
$5E20  94 03 E2 A2 A2 7A D9 18 BD 6A 18 83 6A E2 83 1D
$5E30  6A 81 6A 04 00 81 A3 18 18 6A 6A E2 04 AA 15 E4
$5E40  BE BE BE A2 83 AA E2 AA 70 A2 E4 AA 61 70 62 E4
$5E50  63 E2 A2 A2 70 70 E4 E4 00 00 A2 A2 70 70 37 37
$5E60  98 98 A0 A0 1F 1F 37 37 98 98 A0 A0 1F 1F E4 E4
$5E70  00 00 A2 A2 70 70 E4 E4 00 00 A2 A2 70 70 70 AA
$5E80  AA C5 C5 AA AA C5 C5 F8 7F 53 EA EA EA EA EA EA
$5E90  EA EA EA EA EA EA EA EA EA EA BF EA EA EA EA EA
$5EA0  EA EA EA EA EA EA EA EA EA EA 74 C5 C5 AA AA C5
$5EB0  C5 06 03 0C 82 C5 70 70 EA 22 10 10 10 00 E1 E1
$5EC0  E1 E1 E1 E1 EA 2F A3 2F A3 BD 6A BD 6A C5 82 6A
$5ED0  3D C5 C5 8E 35 3D EA EA EA 06 EA EA EA 06 EA EA
$5EE0  EA A2 C5 C5 E1 EA 86 EA EA EA EA EA EA EA EA EA
$5EF0  BF E1 E1 E1 E1 E1 E1 E1 BF C5 C5 AA AA C5 C5 C5
$5F00  83 A0 A0 E1 10 10 02 0E 98 98 98 A0 A0 A0 98 A0
$5F10  A0 A0 A0 EA 0B A0 A2 48 A0 E1 E1 E1 0E C9 DB DB
$5F20  DB DB 8A 8A 8A 8A A0 A0 A0 A0 8A 8A 8A 8A A0 A0
$5F30  A0 A0 98 48 A0 48 A0 EA E1 E1 E1 25 06 5A 2C 5A
$5F40  2C 5A 2C 5A 2C 48 A0 48 A0 48 A0 48 A0 00 83 A0
$5F50  C3 C5 EA EA EA A2 A2 A2 02 0D 02 DE DE C6 C6 FC
$5F60  FC 2C 2C 60 60 8A 8A 98 98 A0 A0 11 88 8E C3 EA
$5F70  EA 10 E1 E1 E1 E1 76 03 44 A0 EA A0 48 A0 48 A0
$5F80  48 A0 00 EA EA A2 48 A0 10 94 A0 98 88 A0 C3 E1
$5F90  E1 25 60 8A 8A 98 98 A0 A0 E1 E1 E1 68 10 00 85
$5FA0  E1 E1 AA 10 10 10 00 82 46 C3 10 08 08 10 10 10
$5FB0  10 8D E1 E1 E1 E1 E1 E1 E1 C5 05 E1 E1 E1 E1 E1
$5FC0  E1 11 AF 04 AF EA 80 83 38 39 48 A0 E4 0D C0 12
$5FD0  70 E1 10 C0 A0 70 32 33 3B 3C 48 A0 E4 0C 48 84
$5FE0  93 10 10 94 0F 48 A0 70 36 37 98 98 A0 A0 E4 1F
$5FF0  70 12 70 12 70 12 70 12 70 E4 70 00 70 A2 12 70

; ============================================================
; DATA $6000-$8000
; ============================================================

$6000  E4 A2 C5 00 00 95 95 95 95 64 64 64 64 E4 E4 E4
$6010  E4 02 70 E4 F4 BF 70 E4 BF 05 90 04 BF 02 90 BF
$6020  70 E4 64 55 43 46 64 F4 BF 70 E4 E4 E4 E4 E4 E4
$6030  04 E4 81 64 F4 BF 70 E4 04 84 E4 81 A2 A2 24 81
$6040  04 85 83 81 E4 70 E4 64 86 70 E4 E4 E4 E4 E4 64
$6050  E4 E4 E4 02 70 E4 70 E4 70 E4 E1 05 E4 04 E1 EA
$6060  E4 E4 E2 64 64 E4 E4 E4 E4 03 E4 7A 70 E4 E2 02
$6070  46 64 70 E4 70 E4 62 05 C0 04 62 03 C0 7A 7A 7A
$6080  BF E4 E4 03 70 E4 70 82 E2 94 E1 EA E4 E4 E4 E4
$6090  E4 E4 E4 C5 02 44 07 C5 84 70 E4 C5 82 E1 C1 E4
$60A0  70 E4 E2 1E E1 27 70 E4 C5 03 CA 03 62 E1 E2 E4
$60B0  70 E4 A2 08 F0 E1 A2 0C F0 83 E2 E1 C5 80 81 37
$60C0  5A 91 95 55 43 46 64 F4 BF 70 E4 C8 B0 B5 6A 37
$60D0  5A 91 95 55 43 46 64 F4 BF 70 E4 C8 B0 B5 6A 37
$60E0  5A 91 95 55 43 46 64 F4 BF 70 E4 6D C5 C5 C5 C5
$60F0  6D C5 C5 0C E1 E1 E1 EA 0C 9A E1 E1 E1 E1 E1 E1
$6100  E1 E1 E1 0C 0C 0C 0C 27 27 27 27 C1 C1 C1 C1 06
$6110  0C 86 EA 06 EA EA EA 06 EA EA EA BF 68 C1 68 C1
$6120  68 C1 68 C1 EA A2 27 C1 C1 C1 C1 EA C1 C1 C1 C1
$6130  C1 C1 C1 EA 35 C1 C1 EA EA EA EA EA EA EA EA EA
$6140  EA EA 0C EA EA 27 C1 04 C1 EA A9 C1 C1 EA EA EA
$6150  EA EA EA 06 0E EA EA 06 EA EA EA BF 25 25 27 27
$6160  A9 A9 C1 C1 BF C5 C5 EA C5 04 FE 06 C1 EA 82 06
$6170  FE EA EA EA 06 EA EA EA A2 C1 11 A9 68 C1 C5 88
$6180  68 EA EA EA 15 68 C1 43 25 41 27 11 A9 68 C1 8E
$6190  82 C1 C5 C1 C5 81 68 C1 68 C1 35 EA EA EA EA 19
$61A0  11 A9 68 C1 76 88 AA C5 C5 AA AA C5 C5 A2 C5 C5
$61B0  C5 C5 10 EA EA EA 1C C5 C5 35 76 35 76 C5 C5 C5
$61C0  C5 BF 8A EA EA 83 C5 EA EA EA EA 21 FE 05 C5 C5
$61D0  76 76 76 76 C5 C5 C5 C5 8D C5 A2 04 8E 83 FE AA
$61E0  C5 C5 EA 83 C5 EA FE 03 8E 87 FE C5 C5 EA EA EA
$61F0  A2 EA EA EA EA 0E 3D EA EA 89 35 76 AA AA C5 C5
$6200  AA AA C5 C5 EA 8E C5 EA EA 52 EA EA EA A2 C5 22
$6210  EA EA EA 2C A2 A2 82 C5 10 0B 10 10 10 10 10 22
$6220  EA EA EA 10 EA EA EA EA EA EA BF 84 EA C5 84 FE
$6230  10 10 10 10 10 8D 08 10 10 10 10 8D 10 A2 A2 A2
$6240  80 A2 C5 AA 43 6D 43 6D C2 6B C2 6B 1B 76 1B 76
$6250  60 A9 60 A9 1B C5 1B C5 52 C5 C5 A9 10 10 10 10
$6260  C3 EA 52 A9 01 01 A9 A9 AA AA C5 C5 1B A9 1B C5
$6270  1B C5 04 C5 C5 1B C5 F8 04 04 04 04 7A 20 AA 1B
$6280  C5 84 C5 04 C5 04 C5 C5 C5 EA 04 04 90 C5 AF 1C
$6290  C5 04 C5 C5 EA 04 04 C3 C5 1B C5 EA 04 04 C3 C5
$62A0  C5 84 EA 01 04 04 04 90 1C E7 04 D0 84 EF 01 C5
$62B0  04 24 00 84 01 82 A2 04 20 E5 04 AF B3 CA 7A 7A
$62C0  80 B3 45 83 B3 C5 B3 B3 B3 B3 6D 6D 6D 6D B3 B3
$62D0  B3 B3 6D 6D 6D 6D A9 A9 A9 A9 C5 C5 C5 C5 A9 A9
$62E0  A9 A9 C5 C5 C5 C5 0C 82 C5 69 C5 0C 83 69 69 53
$62F0  F8 43 EA EA F8 0C 86 EA EA EA EA EA 06 EA EA EA
$6300  EA EA BF BF BF BF BF BF BF BF EA EA EA EA EA EA
$6310  EA EA 74 FA FA EA EA 74 87 EA 06 2D 2E EA 06 A2
$6320  A2 0C A2 A2 F8 01 A6 7A 7A 03 03 0C 0C 22 22 7A
$6330  7A 03 03 0C 0C 06 06 74 74 FA FA EA EA 06 06 74
$6340  74 FA FA EA EA EA EA EA 47 EA C5 01 A2 F8 01 FA
$6350  52 EA 44 06 36 74 83 FA 52 EA EA EA FA FA EA EA
$6360  FA FA EA EA FA FA EA EA 36 7F EA 44 06 36 74 83
$6370  FA 52 EA EA 82 48 02 24 EA 88 46 C5 83 FE 4B 4C
$6380  20 21 EA FE A2 A2 04 09 EA A2 52 EA 52 A2 A2 9C
$6390  47 07 8E 02 FE 90 12 27 41 15 8E FE C5 23 24 25
$63A0  A2 10 52 EA 10 EA 52 EA 52 EA 52 EA 00 52 52 EA
$63B0  27 11 10 17 18 19 EA 10 C5 10 29 2A 2B 2C 10 10
$63C0  10 A2 A2 A2 A2 A2 A2 7A 8A EA 10 30 1A 1B 1C 1D
$63D0  10 10 FE A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2 A2
$63E0  A2 A2 A2 A2 04 22 10 10 10 10 7A 7A 83 EA 0E A2
$63F0  A2 00 A2 A2 0E A2 00 83 10 10 27 A2 11 A2 A2 A2
$6400  01 24 24 27 04 24 82 E2 0E F8 24 F8 24 10 24 7A
$6410  F8 24 10 04 11 F8 24 27 85 FE 24 04 24 8D 10 10
$6420  10 8D 10 8E 10 8D 04 E0 10 8D 08 04 04 04 80 24
$6430  F8 82 24 8A 02 99 81 10 02 A3 82 8B 0C 1F 7A 87
$6440  C5 7A 7A 80 94 7A C3 1E 7A 7A 7A 7A F8 24 78 05
$6450  42 8D 04 02 F8 24 94 1D E2 0E D1 78 F8 24 24 24
$6460  82 24 99 0F F8 24 8C 0A 7A 7A 93 24 24 90 78 F8
$6470  24 24 24 24 C3 8D 04 90 94 09 00 03 8C 83 24 24
$6480  27 24 00 82 A3 C5 24 49 24 42 82 04 99 0C 00 10
$6490  10 A2 24 04 24 27 0E 24 9C 24 03 F8 24 49 24 C3
$64A0  0D 00 10 10 27 8D 04 05 78 24 24 8D 80 24 42 06
$64B0  F8 24 C5 03 42 04 04 04 C3 24 24 24 42 8D 04 9C
$64C0  42 05 C2 24 C5 12 10 04 49 13 10 82 C5 82 26 10
$64D0  24 C5 27 04 90 C5 80 87 0C 24 24 24 24 24 0A 1A
$64E0  0C 8A 24 0A 45 43 0B 0A 0C 10 10 10 0D 0C 10 10
$64F0  10 27 24 F8 24 27 07 24 10 10 27 08 22 10 10 10
$6500  02 0C 86 3C A2 8E 93 1E EA 0D 22 10 27 10 27 00
$6510  8D 47 27 27 00 0D 22 10 27 27 C7 27 27 00 BE 00
$6520  8B 93 22 27 27 22 27 10 04 90 27 10 04 01 0D 22
$6530  10 27 27 8B 27 10 27 10 27 10 27 27 00 27 27 27
$6540  00 88 27 27 EA 22 22 27 27 FE 06 27 27 22 22 27
$6550  27 8D 0B 27 27 27 27 8D 04 8D 8D 8E FE 22 22 27
$6560  27 27 10 27 10 27 08 94 8D 04 90 A2 A2 A2 A2 A2
$6570  27 27 27 27 27 27 27 27 27 8D 93 1E EA 0D 22 10
$6580  27 27 8D 04 01 27 08 8D 04 20 27 22 22 27 27 22
$6590  22 27 27 22 22 27 27 27 89 27 27 08 10 11 48 08
$65A0  27 FE 04 8D 05 8D 02 8D 02 8D 04 8D 02 8D 04 8E
$65B0  04 8D 04 8E 04 8D 04 8E 84 FE 01 10 10 10 10 EA
$65C0  EA EA EA 27 27 27 27 EA EA EA EA 27 27 27 27 11
$65D0  88 22 22 27 27 C3 84 10 27 07 10 02 46 81 27 27
$65E0  04 82 46 07 07 04 20 46 02 07 03 11 86 04 2D 2E
$65F0  04 C3 FE 0C 8D 02 8D 04 8D 04 8D 02 8E 04 8D 04
$6600  E0 03 8D 0A 8E 04 FE 80 82 90 90 90 90 04 90 E0
$6610  D9 04 AE 1F AE 1F B3 3E B3 3E 20 90 20 90 90 90
$6620  90 90 90 02 90 03 90 83 90 90 CA 05 90 3E CA 1D
$6630  90 90 01 84 90 C5 01 90 03 44 1A 90 20 8F 20 90
$6640  90 4A 83 CA C5 CA 09 AF 11 E4 E0 2F 3E E0 E0 90
$6650  90 49 84 90 90 90 12 03 49 82 90 12 05 12 12 3E
$6660  3E E0 E0 90 90 4D 3E 90 90 4D 90 44 3E 90 90 90
$6670  90 49 9C E0 20 90 05 90 20 90 20 90 83 90 C5 90
$6680  05 20 90 90 90 90 20 90 20 51 90 90 20 90 90 90
$6690  20 51 02 D1 20 90 9C C3 7A 7A 02 49 90 C3 02 E0
$66A0  E0 90 90 9C 1F 20 83 C5 82 AF B4 20 90 9C 90 90
$66B0  90 12 B3 3E 9C E0 20 90 90 C9 90 90 90 C9 90 90
$66C0  90 C3 05 E0 90 90 C3 02 90 05 90 90 90 06 20 90
$66D0  9C E0 20 90 01 7A 13 90 20 90 A5 81 01 AF A5 82
$66E0  93 C3 90 90 89 C3 00 C3 AF 04 AF 91 90 C5 06 90
$66F0  90 90 90 90 90 90 90 AF 90 CA 03 AF 81 CA 04 AF
$6700  87 C3 4C 19 91 90 91 C5 19 A5 80 8E 00 0A EA 3D
$6710  B4 3A 4C 19 B4 3A 4C 19 05 2A 2A 00 88 87 88 89
$6720  7A 7A 8C 8D 8E 19 EA 8D 4D 3A 4C 19 B4 3A 4C 19
$6730  05 12 13 01 05 3A A5 3A EA 3D EA 3D 01 20 01 20
$6740  4C 19 4C 19 3C 97 98 99 9A 9B ED 9D B3 BD A0 E1
$6750  A2 A3 A4 A5 A6 A7 D0 0A EA 3D 07 A0 01 20 B4 3A
$6760  4C 19 3C 7A 7A 3D EA 3D 01 20 01 20 4C 19 4C 19
$6770  18 93 3C AB AC AD AE AF F3 F2 BE CF B4 B5 B6 B7
$6780  B8 B9 BA BB EA 3D 01 20 01 20 4C 19 4C 19 18 81
$6790  3C 18 18 11 4C 4C 19 4C 19 4C 19 4C 19 4C 19 4E
$67A0  90 50 4E 40 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC
$67B0  4D 19 4C 19 4C 19 4C 19 4C 19 4E 81 50 02 4E 94
$67C0  50 00 19 19 19 19 19 19 19 19 19 7A 51 5E 7E 7A
$67D0  D5 09 09 D6 D7 D8 7A 7A 83 E4 D2 E2 7A 7A 8D 20
$67E0  20 20 20 19 19 19 19 5F 7D 5D 5C 5F 14 7E 14 5F
$67F0  7A 7A 03 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A
$6800  06 7A 02 7A 7A 7A 7A 7A 7A 82 7A 7A 7A 7A C4 7A
$6810  7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 3C
$6820  7A 7A 7A 7A 7A 7A 7A 7A 7A 3C 03 13 83 7A C4 3C
$6830  C4 13 02 7A 81 C5 C5 7A 7A C3 7A 5C 11 7A 7A 5C
$6840  81 82 C5 7A 7A C3 7A 5C 18 C3 81 93 7A 5C 81 7A
$6850  7A 5B 18 5A 7A 5B 18 18 AB 5B 02 00 80 24 18 54
$6860  7A 02 4E C5 9C 7A 4E C5 9C 7A 8B 08 C5 9C 7A 8B
$6870  7A 18 82 7A 8B 7A 7A 84 86 18 18 C3 A7 9C A7 9C
$6880  9C 7A 9C 7A 86 7A 18 7A 10 7A 86 04 7A 7A 18 9C
$6890  9C C5 C5 7A 7A 18 18 86 81 C5 C5 7A 7A 18 7A 7A
$68A0  7A 7A 86 7A 18 9C 7A 2E 7A 18 7A 86 7A 18 82 2D
$68B0  2E 7A 10 84 86 24 18 86 7A 18 7A C5 06 18 83 7A
$68C0  7A 18 7A 18 9C C5 C5 7A 7A EE 02 18 03 18 C3 86
$68D0  03 18 02 10 81 ED 18 86 81 EE 04 10 83 24 18 C3
$68E0  18 86 A6 18 18 18 18 18 C3 24 24 18 24 18 F0 7A
$68F0  7A 24 ED 86 8A 8B 86 18 11 9B AA 24 18 86 24 18
$6900  C3 C3 F0 F0 C3 C3 C3 C3 C3 C3 86 85 54 11 C3 10
$6910  11 C3 11 C3 11 C3 11 C3 F0 11 C3 C3 86 A4 98 86
$6920  C3 F0 45 08 F0 AB 54 11 C3 E7 91 11 C3 F0 C3 C3
$6930  54 54 C3 C3 86 C3 C3 C3 C3 C3 C3 C3 C3 13 54 54
$6940  C3 C3 13 83 C3 F0 1B 08 E7 83 2A 08 F0 08 F0 11
$6950  C3 11 C3 13 89 F0 F0 F0 C3 C3 C3 C3 E3 86 54 C2
$6960  C3 C3 C3 10 54 54 C3 C3 C3 C3 5A C3 11 13 5A AB
$6970  54 11 C3 11 02 13 C3 C3 11 C4 13 84 11 C3 C3 11
$6980  C3 86 E1 E3 05 86 9E 11 C3 10 6A 57 C3 59 C3 11
$6990  C3 11 C3 10 5D 6B 5D 59 C3 C3 57 C3 C3 C3 5D 58
$69A0  59 00 C3 C3 11 02 C3 C3 86 82 C3 ED 02 86 8C C3
$69B0  C3 11 C3 5D 5C 11 C3 10 5C 5A C3 C3 5E 90 6A C3
$69C0  11 C3 10 C3 C3 C3 10 5A 6B 5C 5D C3 10 C3 C3 86
$69D0  87 EE C3 C3 10 11 86 11 C3 5E 94 C3 C3 C3 53 C3
$69E0  C3 C3 5F C3 C3 6B C3 68 C3 C2 C3 69 5E 69 C2 02
$69F0  5E 84 6C 68 6A C2 04 86 83 10 11 10 80 15 BE 15
$6A00  BE 15 BE 20 84 C9 0E C9 0E C4 0F 0F 0F 0F 0F 0F
$6A10  9F 0F 0F 50 34 00 34 13 C4 13 C4 09 C9 0E C4 28
$6A20  39 50 39 50 39 50 39 50 9E 0F 9E 0F 9E 0F 9E 0F
$6A30  0E 13 C4 13 C4 13 C4 13 C4 13 C4 13 C4 13 C4 13
$6A40  C4 D0 50 50 50 B0 B0 B0 B0 0F 0F 0F 0F C4 9F 9F
$6A50  0F 0F 9E 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 44 B0
$6A60  0A 9F 9E 0F 50 0E 0E 0E 0E 0E C4 BE BE 40 BE BE
$6A70  08 C9 0E C9 0E C9 0E B0 50 8C E0 08 B0 0A 9F 9E
$6A80  0F 0E 13 C4 13 C4 54 C4 C4 C4 C4 D0 0F 0F 0F 0F
$6A90  0F 0F 0E 0F C4 0E 0E C9 0E C9 0E 0E 0F 9E 0F C9
$6AA0  0F C4 06 9F 0F 0F B0 00 C4 15 15 55 55 45 45 0F
$6AB0  0F 0F 9E 0F 0E C9 0E C4 0F 0E 0E 0E 0E 0E 0E 0E
$6AC0  0E C9 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 13 44 44 44
$6AD0  50 50 50 50 B0 B0 B0 B0 0F 0F 0F 0F 13 00 00 00
$6AE0  0E C9 0E C9 0E C4 15 BE 08 0F 0F 0F 0E C9 0E C9
$6AF0  0E C9 0E 13 0E 0E 0E 0E C4 0E C9 0E C9 0E C9 0E
$6B00  0E 0E 0E 0E 0E 0A C9 B0 B0 0E 0E C4 41 0E 0E 0E
$6B10  0E 0E BE B0 41 0E 0E 08 0E 0E 2A 15 BE 00 B0 B0
$6B20  0E 0E C4 0E 0E C9 BE BE C4 C4 82 BE 13 C4 D0 2A
$6B30  2A 24 C9 C4 BE 13 C4 C9 C4 C4 C4 D0 0E 0E 0E 0E
$6B40  0E 0E 0E 0E 0E 0E 0E C4 B0 0E 0E C9 0E 0E 0E 0E
$6B50  0E C4 BE BE 01 BE 0E C9 BE BE B0 B0 0E 0E C9 A5
$6B60  0A C4 BE A5 A5 C9 C9 B0 B0 0E 0E 0E 41 0E C4 C4
$6B70  C4 1F C4 C4 D0 C9 49 C9 41 0E 41 0E 13 C4 C4 BE
$6B80  0E 13 C9 C9 0E 0E 0E 0E 13 0E C4 BE BE C4 BE C4
$6B90  C4 C9 C4 C9 13 C4 13 C4 C4 C9 C4 C9 13 C4 13 C4
$6BA0  D0 0E 24 C4 C4 D0 41 0E C9 BE BE 24 13 C4 13 C4
$6BB0  D0 0E 0E 55 55 41 0E C4 C9 C9 B0 B0 0E 0E 13 0E
$6BC0  C9 C4 13 C4 D0 41 0E 41 0E BE C4 09 C4 C4 D0 C4
$6BD0  C4 04 13 D0 13 C4 C9 C4 C9 13 C4 13 C4 D0 C9 C4
$6BE0  C4 C4 C4 D0 C9 C9 BE BE C4 C4 D0 C9 C9 BE BE C4
$6BF0  C4 D0 13 C4 13 C4 D0 13 C4 13 C4 C9 C4 BE 13 C4
$6C00  13 82 C9 09 D0 D0 D0 D0 09 D0 D0 BE 00 1F 1F C9
$6C10  C9 D0 D0 09 D0 D0 D0 D0 D0 D0 D0 82 AD 1F C6 C9
$6C20  09 D0 D0 D0 D0 15 C6 C9 09 D0 D0 D0 D0 D0 D0 D0
$6C30  D0 09 D0 D0 D0 09 D0 82 D0 D0 D0 D0 D0 09 D0 09
$6C40  D0 D0 09 D0 D0 D0 D0 D0 D0 BE 2A 01 D0 D0 C6 C9
$6C50  09 D0 C9 09 D0 09 D0 D0 D0 D0 C9 82 1F 1F C9 C9
$6C60  D0 D0 D0 D0 D0 D0 D0 D0 D0 D0 D0 D0 BE D0 09 D0
$6C70  D0 D0 BE D0 09 D0 50 BE BE BE 09 D0 09 D0 09 D0
$6C80  D0 D0 D0 D0 D0 BE D0 D0 D0 09 D0 D0 09 D0 09 09
$6C90  D0 C9 54 D0 D0 D0 D0 D0 D0 BE 04 01 00 00 00 D0
$6CA0  BE 04 40 BE BE BE 17 D0 D0 D0 D0 BE 08 D0 09 D0
$6CB0  D0 D0 82 09 09 D0 09 D0 C9 D0 D0 D0 54 54 D0 09
$6CC0  D0 00 D0 D0 09 D0 09 D0 D0 D0 BE 09 D0 09 D0 15
$6CD0  D0 D0 82 82 1F 1F C9 C9 D0 D0 50 BE BE 00 D0 D0
$6CE0  D0 15 D0 D0 09 D0 D0 D0 D0 50 D0 15 D0 D0 00 BE
$6CF0  05 2A 2A 00 D0 BE D0 BE 50 15 BE 50 BE BE 15 BE
$6D00  08 BE BE BE 54 BE 08 BE 2A BE BE 00 05 BE 01 01
$6D10  BE BE 00 00 50 BE 40 40 17 17 08 08 08 08 08 08
$6D20  08 08 2A 2A 2A 2A 2A 2A 2A 2A 08 08 08 08 08 08
$6D30  08 08 2A 2A 2A 2A 2A 2A 2A 2A 91 3C 2A 2A 2A 2A
$6D40  2A 2A 05 3C 0A 0A 2A 2A 8C 15 20 3F 0F 15 20 3F
$6D50  0F 15 20 3F 0F 15 20 3F 0F 15 20 3F 0F 15 20 3F
$6D60  00 34 BE D6 08 FF 01 2A 2A 24 40 40 00 00 17 D6
$6D70  0D 00 24 24 EA 00 2A ED ED ED 00 00 00 95 95 00
$6D80  00 17 BE BE D6 00 00 55 00 FA A8 A0 A0 0F 2A 0F
$6D90  2A D6 BE 00 08 88 A8 59 D6 D6 D6 D6 A3 26 24 00
$6DA0  00 17 26 BE BE 24 00 17 24 00 17 00 00 00 24 00
$6DB0  24 00 20 00 00 00 08 ED 00 ED 08 BC 00 00 00 80
$6DC0  16 00 00 00 00 17 BE BE BE 3D 3D ED 00 BE BE BE
$6DD0  00 BE BE BE BE BE BE 00 26 BE BE BE BE BE BE BE
$6DE0  BE BE BE 2A BE BE BE 00 24 00 FF 2A 2A 2A 00 00
$6DF0  00 00 88 26 BE BE BE BE BE 16 00 16 24 24 24 00
$6E00  22 AA 22 24 24 00 16 17 17 24 24 00 17 17 17 17
$6E10  17 17 17 17 C0 FC C0 17 17 15 15 17 17 FC 00 00
$6E20  00 00 55 14 17 55 88 24 24 C4 A5 95 51 01 05 16
$6E30  17 17 11 15 00 00 A0 17 17 55 02 02 24 02 2A 00
$6E40  17 55 30 30 17 17 00 00 00 17 17 17 17 8C 17 17
$6E50  17 17 16 17 2A 16 17 55 17 FA 16 17 17 55 FF AA
$6E60  13 13 5B 00 00 00 A3 17 17 FC 8C F0 00 FC 24 EA
$6E70  17 2A 96 17 55 17 FF 17 17 17 17 17 77 17 11 17
$6E80  2A 01 14 50 17 50 17 00 2A 40 14 17 17 05 10 16
$6E90  17 FB 20 A8 24 A8 20 17 16 17 16 17 17 17 17 AA
$6EA0  A5 17 2A 17 45 2A 5A 17 2A 17 54 50 17 00 6A 5A
$6EB0  17 55 54 10 0A 2A 2A 2A 2A 00 14 04 17 17 17 17
$6EC0  17 17 17 55 55 FE FA 17 CF 17 CF 24 55 2A FF 17
$6ED0  17 17 00 54 FA FA FB 8C 8C F0 F3 CF 0F 2A 00 17
$6EE0  2A 82 2A 00 17 28 80 16 17 00 00 00 00 24 55 11
$6EF0  00 08 55 24 ED 00 00 08 2A 2A 91 28 02 0A 0F 2A
$6F00  91 91 00 C3 02 BE 02 24 D8 91 24 A3 BA 91 00 91
$6F10  24 91 00 AE 00 00 00 40 91 17 E0 A8 91 91 91 3F
$6F20  91 0A 00 91 10 BB 00 3F 3F 91 0A 15 10 D6 00 EA
$6F30  91 AB 3F 91 91 BA BA EA FA FE CA 28 87 91 91 8F
$6F40  BF ED ED F0 91 2A A8 91 91 91 00 00 00 00 D6 40
$6F50  91 02 00 24 00 02 87 91 FF 02 91 22 20 00 00 05
$6F60  FF D3 91 30 B3 8C F0 00 91 7F D0 91 91 B3 8C F0
$6F70  F3 3C CF 30 3C CC 24 91 91 F0 24 24 24 24 AA FF
$6F80  CF 91 00 88 24 24 02 04 19 00 00 00 3F 91 4A 04
$6F90  98 04 4A 87 91 24 91 20 91 24 80 20 33 91 91 CC
$6FA0  91 CC 91 CC 87 91 17 91 00 06 87 91 17 66 00 66
$6FB0  24 24 17 60 00 60 03 03 8C F0 00 30 F0 C4 C4 F0
$6FC0  91 00 01 13 A5 24 00 02 24 24 24 13 88 02 24 00
$6FD0  C4 C4 C4 50 02 24 00 00 0A 00 BE 18 24 22 2A 02
$6FE0  24 3C 0C 33 24 CC 24 33 0C C3 CC 00 00 FF 24 EA
$6FF0  F3 3F 13 CC 24 33 24 CC 13 13 5B 24 02 88 02 24
$7000  EA 55 00 00 00 00 44 44 55 F0 F0 00 30 FC A8 FC
$7010  30 00 00 00 00 00 ED 00 00 00 02 EA EA C4 ED ED
$7020  ED D6 C4 C4 00 C4 C4 00 EA EA 00 EA 24 05 ED ED
$7030  D8 13 13 33 3F 07 01 E3 FF 14 3C EA FF 7D ED ED
$7040  ED EA EA EA FC D0 40 30 EA 3F 01 17 55 50 00 BE
$7050  FF FF D7 D7 55 69 3C 0C EA FC 40 D4 55 05 00 00
$7060  ED 02 00 00 00 20 EA 82 24 EA 00 EA EA 00 20 24
$7070  EA 3F 24 EA 3C 88 88 A4 26 EA 59 9A 3C EA EA 00
$7080  EA 00 EA AA 3C 00 00 40 00 00 3F 22 20 22 00 40
$7090  22 A8 00 20 82 00 00 20 EA 00 80 88 00 08 82 22
$70A0  EA 00 EA AA 35 28 20 A4 66 9A 59 6A 88 22 28 00
$70B0  6A EA 55 6A 94 00 00 17 55 AA FF EA 03 33 33 3F
$70C0  EA 03 03 EA 00 CC CC FC EA 00 00 00 08 00 EA 00
$70D0  20 EA 08 FF 24 EA 02 00 40 08 02 AA EA 02 02 80
$70E0  D6 0A 00 00 13 3F C4 BF 00 00 A3 EA FC FC C4 FE
$70F0  00 00 00 C4 C4 13 C4 13 C4 13 C4 13 34 00 00 00
$7100  13 13 13 13 13 32 05 40 89 A9 59 11 11 0F 0F 40
$7110  40 0F 20 20 40 20 40 20 40 00 00 00 00 00 81 00
$7120  05 0F 20 40 13 A0 40 40 38 40 40 40 13 0A 40 40
$7130  2C E9 0F 20 40 00 25 00 96 40 5A 11 E9 0F 20 40
$7140  40 29 21 40 20 40 12 40 40 AC 00 00 00 17 40 00
$7150  85 56 1A 5A 5A 6A 6A 00 C4 A0 0F 25 24 95 91 40
$7160  5A 0F A8 40 89 56 40 40 0F A0 80 6A 40 0F 0F 40
$7170  40 82 A0 20 40 20 40 08 40 0F 20 40 A3 40 08 A8
$7180  40 13 C4 13 A3 20 40 40 40 13 20 40 00 89 00 20
$7190  40 84 40 40 00 42 00 00 13 13 82 13 ED 13 00 A5
$71A0  A5 A9 A9 00 C4 A1 00 17 00 17 00 AC 52 95 A4 54
$71B0  26 54 84 00 21 00 88 40 0F 0F 40 40 40 68 48 00
$71C0  00 00 62 55 98 15 12 0A 00 00 00 00 20 40 00 40
$71D0  40 C4 00 00 00 82 55 62 95 A9 C4 C4 0A 02 58 18
$71E0  56 46 55 00 ED 00 27 00 00 00 08 58 5A A5 02 2B
$71F0  AF AB AA AF 2A 02 00 FC AF FF BF AF BC 00 00 00
$7200  00 00 00 55 FF 17 AC 17 27 20 25 A5 5A 3D ED 00
$7210  17 95 95 AC 17 17 A5 65 17 00 A5 25 AA 17 56 27
$7220  17 17 AA 98 17 C4 17 ED A8 00 C4 00 13 13 3F 17
$7230  25 25 17 08 17 17 27 17 60 6A A2 22 17 17 08 AA
$7240  95 95 17 96 96 AA 26 A8 5A 59 17 17 5A 58 3D ED
$7250  05 96 56 56 17 13 17 09 A9 8A 88 17 17 27 17 58
$7260  58 17 27 17 17 08 2A 17 17 17 80 00 00 05 17 17
$7270  ED 17 17 88 AA 88 48 AC 17 17 2A 13 00 08 17 17
$7280  00 AC 17 88 17 22 20 2A A8 08 08 64 AC 17 FC FC
$7290  CC 17 17 00 00 00 AC 17 13 17 17 03 13 13 33 17
$72A0  00 13 00 AC 17 80 00 C4 00 80 ED ED ED ED 17 D6
$72B0  80 AA 17 80 80 17 05 13 13 5B 05 13 05 00 C4 00
$72C0  17 13 17 C4 17 00 58 55 96 95 A5 ED ED 00 88 55
$72D0  22 55 88 17 17 D6 17 17 17 AA 13 13 00 05 ED AA
$72E0  17 D6 D6 10 D6 10 D6 03 17 13 FC ED ED 00 C4 13
$72F0  00 13 C4 13 35 C4 13 ED 41 1C ED 7F 31 D0 C4 13
$7300  5B 00 5B 5B 2B 00 A8 5B 00 00 88 97 75 97 88 00
$7310  00 3F 28 80 ED 80 28 ED ED ED 30 01 5B 5B 82 03
$7320  40 40 43 34 00 00 13 10 0C 0C 0D 30 34 41 41 3D
$7330  44 04 3C 30 74 74 4C CC 70 57 DC D7 D4 DF D7 D7
$7340  30 54 DC 44 41 F0 D4 D5 75 05 44 30 44 51 1D C4
$7350  CC 5B FC FF 3F 10 34 45 82 ED 00 55 41 32 5B 34
$7360  05 30 3F 30 32 5B 3F 00 05 82 32 5B 82 5B 5B 5B
$7370  82 0C FC 0C C3 3F 3F 00 5B 82 84 33 33 35 35 19
$7380  19 82 82 5B 5B 3D 88 82 5B 5B 3D 5B 5B 00 44 55
$7390  77 3D 3D ED A3 DF DF 4F 1F C3 10 41 05 F5 F1 F0
$73A0  F1 C0 07 D0 01 41 34 ED FD 4C 07 13 C4 47 3C 75
$73B0  C7 C5 75 3C 47 D1 3C 5D 53 D3 5D 3C D1 32 5B 00
$73C0  0F 0F 00 C4 00 F0 F0 3F 33 33 F3 00 00 00 ED F0
$73D0  32 5B 05 82 32 5B 34 32 5B 00 02 00 2C 00 00 00
$73E0  ED ED 30 33 ED 33 3D ED 00 ED 10 E0 34 3D 3D ED
$73F0  ED D8 D8 34 34 3D 3D ED ED D8 DF 34 ED 3D 3D ED
$7400  ED 3D 3D ED ED 00 0C AC 00 33 A0 0C 23 8C C8 30
$7410  30 80 32 20 33 ED 10 C8 F0 C2 0C F0 F0 00 D8 ED
$7420  63 3D D8 ED 3C F3 3C ED D7 D8 F7 14 7D 20 D8 ED
$7430  63 3D D8 ED 3C 00 41 00 F0 F0 00 3C 3C AA 69 00
$7440  00 F0 FF ED ED ED AA D6 D6 00 00 D6 D6 00 00 D6
$7450  D6 00 00 D6 D6 00 00 D6 D6 00 00 D6 D6 00 00 D6
$7460  D6 00 00 D6 D6 A3 28 ED 02 ED ED ED ED C4 02 D6
$7470  D6 00 10 D6 A3 ED 05 2A 3F FD ED ED 00 AF BF FD
$7480  00 00 00 00 00 00 7F 00 00 00 D6 ED 00 A8 FC 7F
$7490  00 00 00 A8 ED 10 00 00 28 A0 80 D6 D6 A3 A0 C4
$74A0  C4 02 00 00 00 00 C4 00 C4 11 55 00 FF 00 00 00
$74B0  D5 04 55 55 D6 10 D6 10 D6 10 D6 10 D6 10 D6 10
$74C0  D6 10 D6 10 D6 10 D6 10 D6 10 D6 90 54 A0 00 00
$74D0  F0 D8 ED 00 0A 08 20 00 00 00 00 05 00 C4 15 11
$74E0  00 05 C4 00 15 10 46 46 66 56 44 04 C4 C4 50 5C
$74F0  74 75 D7 D7 D8 ED 34 00 00 2A 7E 5E 34 00 34 00
$7500  C4 00 AF BC A9 88 21 34 00 34 34 F2 21 BC 6D 55
$7510  34 C4 34 C1 21 34 00 34 34 40 04 15 FF C4 C4 C4
$7520  C4 01 10 54 FF 3E 79 55 34 C4 53 43 40 0F 21 34
$7530  00 00 00 00 00 34 34 00 C4 00 FA 3E 21 34 8C C4
$7540  05 A8 BD B5 C4 C4 05 35 1D 5D 34 57 C4 54 34 C1
$7550  C5 C5 C1 D0 40 C4 34 54 54 C4 40 34 C4 C4 00 20
$7560  C0 08 02 F0 F0 F0 F0 F0 00 C4 C4 C4 00 C4 55 55
$7570  FF 00 00 00 55 C4 00 55 F0 F0 00 C4 C4 00 04 24
$7580  34 A7 A4 A6 A4 A7 5F F0 F0 00 F3 BC B0 BF 6A 6A
$7590  6B B0 B3 8C F0 00 34 00 EA B0 B3 8C F0 00 C1 00
$75A0  00 00 00 00 00 F2 00 05 C4 00 00 00 00 8F A8 20
$75B0  08 2A 71 34 34 00 00 00 57 C4 00 40 00 04 F0 F0
$75C0  00 00 00 00 00 00 CA F2 2A 83 D6 D6 00 00 C4 00
$75D0  AF 8C F0 8C F0 F0 A9 AD FD 8C F0 8C F0 3C 55 56
$75E0  54 57 DA FB 00 00 D0 D8 D8 C4 05 DA 02 2B 02 08
$75F0  C4 C4 00 C4 15 F8 C0 20 8C F0 8C F0 8C F0 00 C4
$7600  00 00 D5 01 00 10 55 2A 00 05 00 00 00 F2 8C F0
$7610  8C F0 00 00 00 01 B3 F0 F0 B3 B3 F0 F0 A9 AF A1
$7620  A1 02 FF AB BC C2 FC 00 F8 15 A1 A1 00 0F F0 00
$7630  05 55 35 F5 FD A1 03 A1 50 40 50 50 54 5F A1 00
$7640  2A 2A A1 A1 00 00 F2 BC A1 00 00 0A A1 00 8F 3E
$7650  D6 D6 00 00 A1 00 A1 00 A1 00 A0 00 00 00 40 15
$7660  05 01 05 05 15 F7 0F 40 54 55 7D 7F F0 F0 00 A1
$7670  00 2A D6 A3 02 00 00 E8 AC 83 0A EA 3E 83 00 00
$7680  00 00 00 1A 6A 00 00 00 00 00 00 40 00 A8 82 00
$7690  80 00 00 8F 00 00 00 00 00 00 00 00 00 00 00 00
$76A0  00 00 00 00 00 00 00 00 00 00 00 00 F0 FD 75 55
$76B0  55 54 05 00 00 00 00 00 00 00 10 00 00 00 00 00
$76C0  00 03 03 03 03 00 00 00 00 00 00 00 00 00 00 00
$76D0  00 03 03 03 03 00 00 00 00 00 AB 00 00 F5 00 00
$7700  00 00 00 00 00 0F 13 57 D5 55 04 01 05 F0 00 00
$7710  00 00 05 05 01 CA 00 00 00 00 00 00 00 00 CB E5
$7720  D5 25 E9 AF EC 00 00 C0 00 00 00 00 05 F1 03 02
$7730  03 04 05 F2 D6 6A 05 05 15 04 05 8F 00 08 0A 15
$7740  3F 3F 00 00 00 00 00 05 C0 2A 0F 37 05 05 00 D6
$7750  A3 5F 5D 04 05 00 D6 00 FF 5F 05 05 0A A8 05 D6
$7760  00 FF 20 80 00 00 00 00 00 00 00 00 00 00 00 FB
$7770  8B F0 C4 15 57 55 D6 40 41 F0 F1 D5 F5 D5 D6 F0
$7780  D6 00 0F 7F 5D 55 55 15 54 FF EB 5B 57 58 6B FA
$7790  3B 3C 00 0C 10 D6 00 05 05 AF BC 04 05 05 F0 FE
$77A0  F2 15 0A 08 22 D6 00 80 05 55 A9 88 05 80 04 05
$77B0  F2 50 43 0C 05 05 05 05 8F 3C 00 00 05 F0 F0 D6
$77C0  00 55 05 22 05 F0 F0 00 F2 10 D6 00 FE FF F5 75
$77D0  04 05 D6 0A AA A8 F0 DC D6 20 A0 D6 00 D6 D6 A3
$77E0  55 A8 20 3C F0 F0 00 8F 00 C0 3C 00 00 3C 00 00
$77F0  00 C0 3C 00 00 3C 00 0F 4F 57 5F 57 D6 00 10 D6
$7800  09 00 43 BC 93 BC 55 6A 40 F0 10 F0 A7 B3 8C F0
$7810  00 A4 A5 A3 0E 32 C2 02 56 AA 02 EF 08 A3 A3 A3
$7820  00 EF EF A3 A3 A3 F0 00 A3 FF A3 A3 A3 A3 F0 A3
$7830  A3 00 00 00 00 00 00 00 03 00 03 00 00 00 00 00
$7840  A5 A3 00 00 A3 F0 00 00 00 00 F0 00 3C FF 3C F0
$7850  F0 00 07 00 F0 A3 F0 A3 A3 00 8C F0 00 00 00 00
$7860  B3 F0 F0 00 83 A3 A2 A3 B0 8C 83 80 00 38 86 00
$7870  C0 3E C2 3E 02 A8 00 A0 A0 AC 80 80 BC A0 90 F0
$7880  00 F0 00 A3 A3 A3 00 EA A3 FA FA EA 00 00 AA 32
$7890  0E CE 32 0F F0 00 0F A4 A4 A3 06 A7 0C 3C A3 A3
$78A0  F0 3C 00 00 B3 8C F0 00 8C F0 00 A3 EF EF A3 A3
$78B0  F0 FC 02 F2 0E 0E F2 F0 8C F0 00 B3 F0 F0 00 CF
$78C0  C3 2A 02 00 00 AB AF AE 00 00 00 A3 00 F0 80 02
$78D0  2A A3 3F A3 A3 F0 F3 C3 80 8F B0 B0 8F F0 F0 00
$78E0  F0 F0 F0 D6 8C F0 3F 00 00 00 C0 F0 8C F0 00 30
$78F0  3C 00 00 00 00 00 00 00 00 06 DA 8C B0 B3 8C F0
$7900  00 3C 00 00 00 00 30 C0 00 03 00 00 00 3C 3C 00
$7910  00 00 00 00 30 00 00 00 00 00 00 00 00 00 00 00
$7920  05 00 00 00 00 A7 00 00 05 A4 A7 00 00 00 3F 00
$7930  00 00 00 00 00 00 00 00 00 FF 00 00 00 FF 00 00
$7940  00 C3 00 00 00 00 00 00 00 00 33 00 00 00 00 00
$7950  CF FC 30 3C 00 00 00 00 00 00 00 00 00 00 00 00
$7960  00 0C 00 00 00 00 00 00 00 CF F3 00 C3 00 00 00
$7970  00 00 FC F3 00 00 F0 00 00 00 00 F3 0C 0C 3C 00
$7980  00 00 00 00 30 00 DA 00 00 00 1A DA 00 3F 00 0C
$7990  00 00 00 00 00 FC 00 30 00 00 00 D6 08 90 00 00
$79A0  3C 00 00 00 00 30 3C 00 00 C0 00 00 00 F3 00 00
$79B0  00 00 00 00 00 03 00 A4 A4 A8 A7 A6 A6 A9 00 00
$79C0  0F 00 00 00 FC C3 00 00 00 00 00 00 03 00 00 00
$79D0  00 00 00 00 00 00 00 C0 00 00 FC 00 00 00 00 00
$79E0  00 00 00 00 F3 3C 00 00 00 0F 00 00 CF 00 00 00
$79F0  00 00 00 00 00 00 00 00 F0 00 00 03 C0 00 00 00
$7A00  00 00 00 00 0F 00 00 00 05 00 00 00 00 3F 00 00
$7A10  03 00 00 00 00 C3 00 FF 3F C3 DA 1A DA 00 05 1A
$7A20  00 00 00 00 00 00 40 00 00 C3 00 00 00 00 CF 00
$7A30  90 90 D3 00 00 FA 00 00 00 00 AA 00 00 0A 00 00
$7A40  00 00 80 A0 A8 A8 00 F0 00 3C 00 00 00 00 00 00
$7A50  00 00 00 00 30 2A 03 AF FA 00 00 00 00 BF FF 00
$7A60  00 00 00 00 FF 00 00 00 00 00 AA FF 02 00 00 05
$7A70  3C 3C 00 00 00 00 FF 00 06 00 44 00 00 00 00 00
$7A80  00 66 55 00 00 00 06 00 A0 00 00 00 00 00 A0 00
$7A90  00 00 3C 00 0A 00 00 A0 3C 00 A0 00 00 00 0F 00
$7AA0  FF 00 00 0C 03 00 F0 00 00 00 00 00 F0 03 FA FA
$7AB0  FE FE FA 3A BA AA 00 CF 00 00 3F 00 00 FC FF 83
$7AC0  00 A0 00 3C 00 0F F3 00 00 00 00 00 F3 00 00 33
$7AD0  FF 00 00 00 CF 00 00 3C 00 00 3C 00 03 3C 00 00
$7AE0  00 FF 00 0F 3F 00 00 00 00 00 00 00 00 00 00 00
$7AF0  00 00 00 0F 00 00 C0 00 00 00 C0 3C 00 00 3C 00
$7B00  00 00 00 03 0C 00 FF CF F0 00 00 00 00 30 C0 C3
$7B10  F0 F3 00 00 FF 30 00 00 00 0F 00 00 FF 3F 00 00
$7B20  00 FF 00 00 00 3F 00 30 0C 00 00 00 00 00 00 FC
$7B30  00 00 00 F0 FF F3 3F 0F 0C 33 00 00 00 00 00 FF
$7B40  CC 00 00 00 3C F3 F0 C3 0C 00 00 C0 3C CF CF 0F
$7B50  00 00 00 00 03 00 FF FC 00 00 2A 00 AA AA 00 04
$7B60  00 00 04 FF 00 00 00 0F FF FC 00 FC 00 30 F0 C0
$7B70  00 00 00 C0 30 D6 00 00 FC 00 00 AA FA 0F A0 AA
$7B80  AA 0A AF F0 0A D6 04 AA 0F CF 00 FF FF 0C 3F 30
$7B90  D1 10 D1 10 00 20 3F 00 AA 00 18 00 40 05 D0 38
$7BA0  00 00 00 00 D0 6A C0 0D B0 14 00 00 00 10 C0 08
$7BB0  B0 00 18 00 40 00 D0 58 00 00 00 00 00 00 09 00
$7BC0  00 00 00 00 00 00 06 00 00 00 00 00 00 00 00 09
$7BD0  58 09 09 00 05 00 00 00 00 00 D0 00 00 00 00 00
$7BE0  D0 2E 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$7C10  D0 71 00 00 00 00 00 00 00 0C 00 00 00 00 09 00
$7C20  41 00 00 00 4F D0 5C 4C 4F 00 4F 00 4F A0 84 00
$7C30  4F 4F 00 00 4F 4F 00 00 90 00 20 00 00 00 00 00
$7C40  00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00
$7C50  00 00 00 00 00 D0 2C 00 00 00 00 00 00 00 0D 00
$7C60  00 00 00 06 D0 4A 00 00 00 00 D0 17 00 00 90 16
$7C80  00 00 00 00 00 4F C0 00 00 00 20 00 00 00 00 00
$7C90  00 00 00 00 00 00 00 00 00 D0 E8 00 58 58 09 09
$7CA0  00 00 00 00 00 00 00 00 00 00 00 09 06 00 00 00
$7CB0  00 09 D0 47 00 00 00 00 D0 C9 C0 0A 90 13 00 00
$7CC0  09 09 09 09 09 1D 00 00 00 00 00 00 00 00 00 00
$7CD0  09 C0 07 69 3B 20 00 00 00 00 00 00 00 00 00 09
$7CE0  4F 4F 4F 00 D0 9D 09 11 09 11 09 00 C0 06 09 00
$7CF0  09 19 58 11 09 00 09 07 09 09 09 00 19 58 11 09
$7D00  F8 58 04 38 00 BE 00 4F 00 4F 00 18 18 4F 4F 25
$7D10  C9 17 4F 4F 00 35 22 00 00 00 00 00 F0 00 00 D1
$7D20  AA 8A F0 15 10 10 10 D0 10 4F 4F 4F 4F AD 06 20
$7D30  07 00 98 69 69 20 0B 00 98 B5 AD 00 4F D3 60 D6
$7D40  AD 4C EE 21 B5 98 0F 00 00 00 00 00 00 00 00 1D
$7D50  00 00 00 C5 0D 00 00 00 00 00 00 00 00 4C 00 00
$7D60  C5 0B D0 00 00 00 00 00 00 00 4C E5 21 C5 00 D0
$7D70  0F 00 00 00 00 00 00 56 AA 00 00 00 AD 20 C4 1F
$7D80  A5 4F 00 4F AD 13 A5 65 F0 09 00 00 1E 00 00 1E
$7D90  4C 07 4F 00 00 1D 20 F2 1D 00 00 00 98 00 4F D1
$7DA0  9B 4F 00 00 00 00 38 FD 00 00 10 0E 4F 4F 4F 10
$7DB0  00 00 00 00 00 40 00 00 F0 08 40 57 00 00 00 40
$7DC0  5A 4F 00 17 00 00 00 00 10 D0 31 00 00 00 00 4F
$7DD0  4F F0 10 4F 4F 00 B5 9E C5 9E 90 38 38 38 00 00
$7DE0  10 12 40 00 F8 4C 01 30 38 7D 40 00 01 8A 48 00
$7DF0  00 49 00 00 68 AA 4F 4F 10 4C 4C 4F 00 00 00 4F
$7E00  00 00 0F 00 D0 00 C5 C5 D0 00 00 00 00 00 00 00
$7E10  00 00 00 00 00 00 00 C5 05 F0 11 00 00 00 F0 F0
$7E20  F0 F0 00 00 00 00 00 00 00 00 01 8A 00 0A 00 00
$7E30  00 70 14 B0 12 00 00 10 00 00 00 70 0D D1 10 D1
$7E40  10 D0 07 10 56 00 10 16 D1 10 D1 10 D1 10 60 00
$7E50  00 D0 32 53 0E 0F 00 00 00 00 04 25 C0 0C D0 0B
$7E60  86 51 A0 85 F0 F0 0A A6 51 00 52 BE BE C5 13 00
$7E70  00 00 00 AD 05 FE 00 00 8D 03 FE 5D 4F 00 16 2E
$7E80  00 00 00 00 00 00 14 00 00 00 CD 00 00 00 00 00
$7E90  F0 72 20 DD 2D 00 62 00 00 C9 10 B0 57 00 00 00
$7EA0  63 30 02 00 00 00 00 F0 64 98 00 00 C9 21 90 09
$7EB0  00 00 00 00 00 10 4C 52 23 A5 9E A4 63 10 00 00
$7EC0  E9 0F 00 00 18 69 0F 00 00 9E D0 D0 10 10 10 10
$7ED0  00 05 B0 02 00 05 00 00 00 15 00 00 00 00 00 00
$7EE0  01 95 C8 00 00 00 00 00 AD 14 00 00 00 E6 00 00
$7EF0  14 00 00 00 A5 62 30 EC 00 1C 2E 00 00 00 00 00
$7F00  00 4C 5B 23 00 C5 00 00 D0 DA 4C C4 1D 10 D1 10
$7F10  D1 10 81 D0 35 00 00 00 00 C9 00 90 9C C9 0C B0
$7F20  0D 20 7E 1F 0F 00 00 11 00 00 09 00 00 00 00 13
$7F30  B0 B2 00 00 00 00 F0 0E 00 00 00 00 00 00 00 30
$7F40  00 00 00 00 01 00 00 0D D0 F0 A5 63 38 00 C9 0B
$7F50  B0 92 C9 05 90 C5 10 16 00 00 10 13 00 00 10 00
$7F60  00 05 36 00 00 10 00 F0 A1 0F 00 00 00 AD D1 00
$7F70  00 F0 F0 F0 10 10 D1 10 00 10 10 10 10 01 A9 80
$7F80  10 10 10 B5 00 00 00 AD 08 20 AE 00 00 00 00 00
$7F90  00 20 6D 00 00 15 00 00 00 00 12 0F 00 4C 00 00
$7FA0  00 00 00 2E 00 10 00 00 00 00 24 00 00 00 00 AD
$7FB0  0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$7FC0  00 00 00 00 00 00 00 00 00 00 A9 0F 00 00 00 00
$7FD0  00 00 00 13 D0 6F 8A 10 10 00 D1 30 04 00 00 00
$7FE0  61 10 D1 10 05 D1 10 20 39 1E 00 A4 00 00 AD 2F
$7FF0  00 00 D0 1C 00 00 D0 18 00 00 00 00 00 00 00 00

; ============================================================
; DATA $8000-$A000
; ============================================================

$8010  00 00 00 20 86 00 10 F0 F0 10 00 00 00 00 24 C0
$8020  0A D0 10 BE 00 D0 0C 00 00 00 00 00 00 00 00 00
$8030  00 00 00 00 00 1E 20 C4 1E 10 10 10 A4 A9 13 00
$8040  00 24 4C 8C 22 00 00 D0 3D 00 00 00 00 D0 29 00
$8050  29 00 52 00 18 4C F4 24 8A 00 00 00 A0 27 1D 63
$8060  4F 00 E8 E8 88 10 F7 F0 F0 00 98 D0 12 00 00 00
$8070  51 A6 29 86 00 00 32 00 32 00 00 00 00 00 2F B5
$8080  A4 85 4C 4C D4 1C 95 BF A8 B9 8C 4A F0 F0 01 C6
$8090  52 A5 52 10 D1 10 00 00 4C 92 1F 38 38 20 00 00
$80A0  AD 00 07 00 00 00 00 07 00 00 00 00 00 00 00 8D
$80B0  00 00 00 00 00 EF 00 00 00 00 EF 00 00 00 00 00
$80C0  00 00 8D 00 00 BE AD 00 10 D0 0E 8C 00 10 00 00
$80D0  00 00 00 00 00 8D 00 25 60 05 05 0F 69 09 72 00
$80E0  CD 81 00 B0 C0 CD 82 00 B0 CE CD 83 25 B0 DC D1
$80F0  10 D1 10 38 07 07 F8 F8 F8 F8 10 A2 38 38 00 BE
$8100  16 00 1F 09 0B 0C 0A 18 08 07 09 06 00 18 01 C5
$8110  03 04 05 00 18 18 00 C5 00 00 00 00 00 00 F0 49
$8120  00 00 69 00 00 00 00 00 00 00 00 00 00 00 00 00
$8130  00 95 D4 00 95 DA 00 00 00 00 00 B5 D4 00 00 00
$8140  00 68 00 00 F0 23 BD D4 00 30 1E 20 04 27 BD 4E
$8150  00 00 38 20 19 27 48 8A 00 68 95 D7 68 95 DD 00
$8160  69 75 E0 A8 B5 D7 20 A0 26 28 68 C5 10 38 38 00
$8170  8D 00 27 09 AD 00 27 D3 60 09 EE 7E 27 04 10 10
$8180  D0 0A 10 D1 10 F0 3F 00 9E 95 B9 00 D4 C5 09 00
$8190  A4 00 00 C5 00 00 00 00 00 00 69 00 69 AD 00 00
$81A0  27 AD 00 00 69 D0 03 00 69 D0 03 00 00 98 69 A8
$81B0  00 98 69 A8 B5 A1 69 69 B5 A1 69 69 00 6D 69 B5
$81C0  DA 69 69 D0 E0 02 F0 44 BC 00 00 00 9E C0 05 F0
$81D0  0C C0 3F F0 08 C0 43 F0 04 C0 00 00 03 38 E9 08
$81E0  0A 48 69 69 27 AD 00 00 00 00 19 73 69 D0 03 00
$81F0  D4 00 00 10 00 98 69 A8 68 99 00 00 B5 A1 69 69
$8200  1D 99 00 00 00 00 27 B5 DD 99 27 D0 C5 C5 10 00
$8210  00 00 ED 25 A9 34 00 04 00 00 27 F0 02 A0 09 B9
$8220  63 27 38 38 8F 88 CA 10 F6 AD 00 27 3B 3B F8 00
$8230  27 60 D0 35 00 00 00 00 00 00 00 09 09 09 00 00
$8240  00 00 00 00 00 30 11 00 00 00 00 00 00 00 00 88
$8250  00 00 00 00 00 00 10 E4 AD 00 00 49 3F A8 00 00
$8260  00 0E C8 00 00 00 10 F8 60 A9 3F 8D 00 00 B5 00
$8270  0A AA 00 88 00 00 00 00 00 00 00 00 00 CA 88 C5
$8280  C5 E0 00 00 00 00 27 CA 30 CE 38 00 38 00 0E CE
$8290  7F 27 88 10 E0 00 0A AC 7D 27 9D 0D 00 69 0A A8
$82A0  B9 4F 00 85 0E B9 50 27 85 0F 60 BD BD 59 8D AB
$82B0  00 8D E4 00 8D EE 00 BD 8F 5A 8D AC 00 8D E5 26
$82C0  8D EF 26 BC 61 5B 20 02 C5 51 00 00 20 F0 00 00
$82D0  BD 33 00 48 BD BF 5C 48 A6 51 98 95 E0 10 D1 10
$82E0  00 80 81 C0 81 00 82 40 82 80 82 C0 82 00 83 40
$82F0  83 80 83 C0 83 06 07 08 53 53 0B 53 53 0E 0F 00
$8300  00 04 01 03 FF 01 02 04 08 10 FE FD FB F7 EF 00
$8310  01 00 BD 00 4F D0 C9 F0 F0 4F BD 18 00 9D 00 00
$8320  B4 A4 00 40 00 0E 00 00 00 00 00 00 00 00 00 00
$8330  00 00 00 A0 44 00 00 00 10 1A 00 00 00 00 00 00
$8340  00 42 00 00 00 00 40 00 00 00 10 19 00 00 00 00
$8350  00 00 00 10 18 D0 15 00 00 00 00 44 F0 09 B5 D4
$8360  15 D7 18 00 4C 00 C5 00 00 00 C5 00 10 1B 00 00
$8370  00 00 00 00 F0 00 C9 00 00 00 00 00 00 00 00 00
$8380  00 00 00 00 00 04 00 00 00 00 00 00 00 A0 00 00
$8390  00 00 00 13 00 00 00 00 00 00 00 00 00 00 00 00
$83A0  00 3C 00 00 00 A0 38 00 00 00 00 00 D0 00 00 3E
$83B0  00 00 00 A0 3A 00 00 00 00 10 00 00 00 2A 00 00
$83C0  00 00 11 00 00 00 00 00 00 00 06 00 00 00 A0 04
$83D0  00 00 00 00 12 00 00 00 00 00 00 00 2E 00 00 00
$83E0  A0 2C 00 00 00 00 16 D0 22 00 00 00 0B 90 00 00
$83F0  00 00 00 00 34 00 C5 00 A0 30 00 00 00 00 C5 00
$8400  00 00 36 00 00 00 A0 32 00 00 00 00 0F 00 0E 00
$8410  00 D0 00 00 02 00 00 00 A0 00 18 00 29 00 00 D0
$8420  00 00 00 00 00 00 00 00 16 00 00 00 A0 18 00 18
$8430  00 10 0D D0 10 B5 CE 68 C5 90 00 00 1A 00 00 00
$8440  A0 1C 00 00 00 10 14 00 00 00 00 C5 2E 05 0E C9
$8450  15 05 06 18 00 C5 24 05 00 60 60 05 00 00 00 00
$8460  00 00 00 00 00 00 00 00 00 C0 0E 00 00 00 0E 00
$8470  00 00 A0 10 00 00 00 10 00 D0 1A 18 00 18 00 F0
$8480  00 4C 85 29 BC 00 4F C0 12 18 00 00 12 00 00 00
$8490  A0 14 00 00 00 10 00 D0 2B 00 00 00 0F 00 00 38
$84A0  00 00 00 00 00 00 00 00 38 00 00 00 00 C0 02 00
$84B0  00 38 20 00 00 00 00 C5 00 00 38 1E 00 00 00 A0
$84C0  08 00 00 00 10 06 00 00 00 00 00 00 00 00 38 22
$84D0  00 00 00 00 00 00 00 A0 24 00 00 00 10 07 D0 14
$84E0  B4 CE 00 00 90 00 38 38 00 18 00 C0 03 00 F7 A0
$84F0  28 00 18 00 10 17 D0 0A 18 00 00 B5 AA 00 18 00
$8500  00 00 10 10 D0 11 40 00 40 00 F0 1C 00 00 00 00
$8510  00 00 0D C0 00 F0 09 BC 54 4F C0 0A 00 00 00 0A
$8520  00 00 00 A0 0C 00 00 29 C0 C5 C5 05 00 00 4C A1
$8530  29 A0 02 98 9D 00 4F 18 00 00 9D 4B F0 00 95 00
$8540  2A 2A 00 10 00 B9 A5 59 18 7D 48 4F 9D 4E 4F F0
$8550  10 9D 51 4F 10 10 38 00 C5 F0 B3 F0 00 00 F8 F9
$8560  4C 8D D0 00 00 09 85 00 00 10 60 60 4C 00 00 00
$8570  00 00 00 00 00 4C F2 29 00 00 00 00 85 00 00 00
$8580  F0 00 00 00 A5 00 00 30 F0 F0 4C 07 2A 00 B3 00
$8590  00 85 B3 00 00 F0 02 00 B5 00 00 29 00 F0 12 A5
$85A0  67 29 30 F0 0C A5 B4 F0 10 85 B4 A5 B5 F0 08 85
$85B0  B5 C5 C5 B5 B3 85 4C A0 00 46 4C B0 0B C8 C0 05
$85C0  90 F7 F8 F8 EE 4C 4E 2B 84 52 F0 F0 40 18 09 ED
$85D0  09 09 09 09 09 09 09 09 09 09 09 09 09 09 09 09
$85E0  09 09 09 09 B9 40 4F 30 1F A8 B9 BF F0 00 1B F0
$85F0  F0 10 16 10 18 F0 F0 F0 3E F0 F0 10 69 F0 F0 F0
$8600  65 C9 0E 60 60 4C FA 00 00 00 4C 2B 00 09 00 00
$8610  00 08 A9 34 38 04 00 00 00 00 00 90 EB 30 E9 0A
$8620  10 D1 10 A0 87 10 D0 0A 10 D1 10 00 00 00 00 00
$8630  00 10 00 00 00 D0 D1 00 00 00 00 00 00 00 90 C8
$8640  30 C6 B9 00 00 00 F5 A1 10 D0 10 10 10 10 00 16
$8650  B0 B6 00 00 00 00 00 00 00 00 10 04 00 00 00 00
$8660  00 00 00 00 D0 A2 B9 CE 00 00 0A B0 00 00 00 00
$8670  61 00 54 2C 90 57 30 55 00 00 2E 20 3E 2B 00 00
$8680  10 08 00 00 00 00 00 00 00 09 D0 41 10 10 00 F9
$8690  A1 00 00 0A 00 37 90 35 B9 00 4F 40 00 38 C5 00
$86A0  99 45 4F 00 00 00 10 58 24 00 00 00 38 00 58 1D
$86B0  C5 C5 40 0C F0 17 10 10 10 10 09 11 F0 0F 20 29
$86C0  2E 00 00 10 10 C0 00 D0 10 10 00 95 09 4C 76 2A
$86D0  09 09 00 09 29 99 BC 00 00 00 00 C5 29 D1 10 D4
$86E0  0A 10 D1 10 B0 00 29 C5 F0 58 90 38 00 00 00 04
$86F0  10 10 01 10 D1 10 00 FE DB 4F 8A F0 18 00 00 00
$8700  70 0F C5 07 D1 10 D0 09 4C 9A 2B 00 00 00 00 D1
$8710  1B A9 00 00 0A 10 D1 10 70 0E B0 06 00 00 00 00
$8720  20 10 20 10 C3 00 20 10 20 10 95 00 00 00 29 02
$8730  F0 11 00 00 00 E9 02 00 00 30 46 00 00 00 00 00
$8740  D1 10 00 00 00 29 04 00 00 00 00 00 00 A9 68 C5
$8750  10 00 00 00 00 00 00 00 00 E9 03 00 00 30 57 00
$8760  0F 00 00 00 04 00 00 00 00 29 08 00 00 00 00 00
$8770  00 A9 4B 00 00 00 00 00 00 00 00 00 00 E9 07 00
$8780  00 30 33 00 00 00 00 00 00 00 30 00 00 29 10 F0
$8790  1E 00 BC 10 09 A9 32 00 00 00 00 00 00 10 C5 D1
$87A0  C5 E9 05 00 10 30 10 38 1B 00 00 00 08 00 30 CA
$87B0  38 38 00 50 C5 00 B5 BC 29 80 F0 1D C5 51 00 00
$87C0  09 10 0A 0A A5 A5 C9 C9 A9 C2 00 00 00 00 C9 4C
$87D0  47 C5 00 C8 60 60 60 60 C9 C5 10 00 13 D1 10 00
$87E0  0C 10 30 4C F9 2B B9 9E 00 38 F5 9E 00 08 B9 A4
$87F0  00 00 00 AD 00 00 68 10 D1 10 00 48 08 28 68 C5
$8800  61 60 A5 60 30 05 C6 60 F0 1A 60 29 7F 00 E9 00
$8810  F0 05 D1 10 85 00 00 00 00 00 00 00 00 00 00 00
$8820  66 30 2B 00 00 A0 00 00 00 F1 00 00 A9 42 00 7E
$8830  10 60 60 0A 90 0C 90 90 00 7C 00 00 85 7D A9 00
$8840  49 7E 00 00 00 00 00 00 00 10 C6 66 10 1C CE 00
$8850  43 10 0B A2 07 8E 00 43 00 65 49 29 29 00 AE 21
$8860  43 BD B2 4C 85 10 00 10 85 66 A5 65 00 0A E6 64
$8870  A5 64 C9 08 90 0D B0 07 C6 64 10 07 00 07 2C 00
$8880  00 00 64 10 10 10 51 8A 00 0A 0A 00 65 7D 8D 2C
$8890  2D A5 7E 00 00 8D 2D 2D 8A 00 38 61 8D 00 43 20
$88A0  9F 19 AD BC 43 49 06 38 E9 00 49 08 AD BB 43 38
$88B0  65 7C 49 07 38 38 38 49 09 A0 00 A6 64 BD 00 E0
$88C0  C0 04 B0 0A 00 06 20 8D 00 91 06 4C 43 2D 00 00
$88D0  20 94 47 91 00 00 1F 13 00 D0 02 A2 00 C0 08 D0
$88E0  DC 10 10 10 10 9F 38 38 38 B5 10 D1 10 F0 18 10
$88F0  10 40 60 00 04 10 00 D0 04 10 10 D0 0A 10 D1 10
$8900  06 8A F0 07 00 D4 00 CA 10 DF 60 4C 00 00 00 8D
$8910  B5 D1 30 3A 90 90 38 D0 00 00 00 00 81 40 81 60
$8920  00 00 00 00 41 40 41 D0 25 00 00 40 00 D0 1F 00
$8930  CE D0 1B 00 00 29 05 40 00 B5 C2 09 09 F0 13 09
$8940  09 F0 0F 38 14 00 00 01 30 38 7D 40 00 01 00 10
$8950  BF 60 20 8C 22 A9 18 00 00 20 D0 10 70 0C B0 05
$8960  A5 40 D0 06 00 00 03 00 00 60 00 8D 00 CE 60 B5
$8970  A1 00 E5 A1 00 00 00 00 00 00 00 00 00 00 00 00
$8980  00 00 00 00 00 00 85 62 B5 9E 38 E5 9E 08 B0 04
$8990  49 FF 69 01 60 31 90 00 A9 30 28 B0 02 60 00 85
$89A0  63 00 00 38 40 00 00 00 95 CE 40 00 01 60 40 63
$89B0  10 38 38 8D 00 00 A9 00 95 A4 D4 D4 00 00 00 00
$89C0  A0 86 00 38 00 38 00 38 00 38 00 38 38 38 38 01
$89D0  00 00 86 51 B0 B0 00 00 F0 20 38 7D 40 00 09 1A
$89E0  C9 17 49 00 20 10 2E 40 00 29 60 F8 53 00 39 1C
$89F0  00 00 00 00 00 F6 E9 20 6E 2E 60 00 CA 10 D3 60
$8A00  B5 E9 00 00 00 1A 00 00 B4 E6 F8 F8 F8 4C 40 00
$8A10  29 7F 20 89 2E C8 C6 4C 10 F4 60 3B 05 00 00 4C
$8A20  7B 00 3B 00 00 00 4C 3C 00 3B 05 05 03 4C 51 00
$8A30  3B 04 00 00 4C 66 2F 3B 62 00 00 09 2D 00 3D 3B
$8A40  2E 00 39 06 53 00 00 3B 13 00 4B 09 14 09 47 3B
$8A50  31 00 43 09 64 09 3C 3B 66 00 31 09 09 09 34 3B
$8A60  40 00 30 3B 57 00 00 3B 54 90 10 3B 5B 90 24 3B
$8A70  71 90 04 3B 7D 90 1C 3B 00 00 0E 00 40 00 3B 10
$8A80  00 00 09 4C 00 38 D6 2F 4C 0C 31 4C 6B 30 00 00
$8A90  3B 0A B0 00 09 4C 4B 30 8A D0 E2 00 00 33 20 1C
$8AA0  33 B0 2A 48 20 00 33 00 00 00 00 00 2A 2A 2A 2A
$8AB0  00 00 00 00 00 29 7F 00 00 00 E9 00 00 68 4C 0E
$8AC0  33 A9 7D 4C 8D 4C 8D C9 D4 00 D4 00 00 4C 15 33
$8AD0  00 00 00 D4 A8 00 00 BD 5E 00 00 00 BD 12 00 00
$8AE0  BD FE 4B D0 3D 00 D4 00 D4 00 D4 00 BD 72 00 D4
$8AF0  00 BD 3A D4 00 BD 26 00 D0 00 00 D4 00 B0 D4 00
$8B00  00 BD 86 00 00 00 BD 62 00 00 BD 4E 4C D0 13 20
$8B10  D4 30 B0 E9 A6 29 BD 9A 4B 00 00 BD 8A 4C A8 BD
$8B20  76 4C 00 00 09 00 00 00 30 68 68 4C 68 2E 95 9E
$8B30  98 95 A1 A5 4E 85 00 38 38 B5 00 00 00 F0 0E B5
$8B40  D1 00 8E 00 9E 00 8A 00 3B 00 00 00 F8 00 00 95
$8B50  8A 95 00 38 00 30 CA D0 E0 78 90 00 0D 09 F8 9A
$8B60  90 90 38 20 84 25 90 90 90 1B 8A F0 00 09 3B 3B
$8B70  C9 A0 90 F9 A6 03 DE 95 4E 7D 7D 00 00 1A A0 8E
$8B80  00 00 00 00 00 00 0A 00 24 00 00 00 A9 56 00 00
$8B90  3D 24 3B 3B 3B 00 01 49 FF 35 00 95 95 BC 6D 00
$8BA0  00 00 00 00 00 00 00 00 B0 BC 70 27 30 09 8D 8D
$8BB0  C9 39 78 27 4C 8D B0 B5 EC 00 00 00 00 00 00 00
$8BC0  00 00 4F B5 EF F0 08 20 21 0E A9 FF 99 40 4F 09
$8BD0  F8 09 F8 20 31 00 4C 48 30 20 45 11 4C 42 0D 40
$8BE0  00 3B 12 00 00 09 38 00 38 00 38 A0 8C 38 38 38
$8BF0  38 38 38 38 68 A6 51 09 F8 4C 01 30 38 7D 40 00
$8C00  00 18 38 38 38 00 00 04 29 07 38 00 F0 52 AD 00
$8C10  00 8D 00 00 00 00 00 4F 00 00 8D 00 00 8C 00 00
$8C20  CE E1 00 CE E4 00 00 00 00 32 00 00 D0 16 00 00
$8C30  00 DF 00 00 00 8D 00 00 8C 00 00 CE E2 00 CE E5
$8C40  00 4C C8 00 32 00 00 D0 17 00 00 00 E0 00 B5 E9
$8C50  8D 00 4F 8C 00 00 CE E3 4F CE E6 4F A9 FD 91 38
$8C60  38 00 38 E9 38 38 00 00 00 29 3B 00 F0 30 38 B5
$8C70  9E 3B 3B B0 00 BD 5D 00 8D 24 A9 A1 D5 9E 00 00
$8C80  BD 60 00 8D 19 A9 C5 D5 A1 B0 06 00 00 8D 0E F0
$8C90  0D B5 A1 C9 31 B0 05 BD 57 00 8D 02 38 60 18 60
$8CA0  B5 8D 8D 8D 09 15 B5 B6 29 04 F0 0F 00 17 95 BF
$8CB0  00 10 95 CE 00 00 00 06 01 95 AA B1 04 4C A9 2E
$8CC0  00 00 18 00 41 75 25 95 41 00 00 00 00 00 B5 41
$8CD0  DD 00 00 90 19 00 00 00 90 A1 C9 02 18 BD 00 00
$8CE0  7D 8E 00 38 92 00 00 00 F4 00 28 38 38 1A 00 DC
$8CF0  32 A0 30 32 00 00 00 00 00 A0 32 00 00 00 00 00
$8D00  00 A0 34 00 00 00 00 00 1B 48 00 00 00 25 85 26
$8D10  85 27 68 95 25 38 2C 31 AD 04 01 F0 D1 AD 7B 00
$8D20  4D 9B 00 00 13 AD 7E 00 4D 9E 00 00 0B AD 81 CF
$8D30  4D A1 CF 00 8D 00 EA EA F8 F8 00 00 00 D5 41 90
$8D40  0B F0 02 B0 A9 1F 1F 03 90 F0 B0 00 00 03 38 38
$8D50  9D 00 00 00 00 00 38 03 BD 88 00 38 00 38 00 38
$8D60  00 38 00 38 00 F2 38 38 38 38 38 38 38 38 38 38
$8D70  38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38
$8D80  38 38 38 38 38 38 38 28 A0 3C AD 9C 00 00 00 00
$8D90  A0 3E AD 9D 00 20 00 1B A0 40 AD 38 00 4C 17 1B
$8DA0  B0 8D 05 8D 05 18 0F 38 A6 29 34 34 00 51 8A 85
$8DB0  4E BD C2 4B A8 BD AE 4B 4C 8E 2F 38 02 86 4F 00
$8DC0  00 BD 00 4F 8D 8D 4C 00 38 FE 38 4F 38 00 D0 23
$8DD0  20 CC 32 00 00 00 00 00 00 00 00 38 A9 2F 38 38
$8DE0  38 38 38 38 38 38 38 38 38 38 38 A9 30 38 38 38
$8DF0  38 38 38 C9 0C D0 1E 38 00 38 00 38 00 38 00 38
$8E00  38 38 17 00 00 00 00 00 00 00 00 00 00 A9 00 00
$8E10  00 00 00 00 00 C9 10 F0 BA C9 14 D0 31 00 00 00
$8E20  00 00 00 AA 00 00 00 00 34 88 88 A5 04 38 38 00
$8E30  D6 04 A5 00 69 00 D6 00 00 F8 00 00 A6 4F BC E1
$8E40  4F BD E4 4F AA E8 A9 33 34 34 34 4C C4 32 C9 18
$8E50  00 05 00 00 9D DE 4F C6 4F 05 05 00 2C 32 60 48
$8E60  8A 48 98 48 A0 8D 49 00 00 00 00 68 AA 68 00 00
$8E70  02 B5 41 9D 00 43 00 00 9D 00 43 00 00 F8 8D 9E
$8E80  00 08 F8 A2 17 0E 9A 00 2E 99 43 2E 98 43 A0 03
$8E90  B9 00 43 79 00 43 99 9B 43 88 00 F4 00 00 E6 28
$8EA0  60 85 57 86 58 84 00 60 A5 57 A6 58 A4 59 60 A6
$8EB0  51 B5 E9 85 5B 84 5A 00 00 00 A6 00 A6 00 D6 2A
$8EC0  D6 2A 00 00 00 00 00 00 00 34 00 00 00 30 1E D0
$8ED0  00 00 00 00 00 00 00 C5 5A 00 00 00 5C 00 00 00
$8EE0  C5 5B F0 02 46 5C A5 5C D0 05 C8 D0 DA 38 60 00
$8EF0  88 88 00 00 00 14 A6 00 8D 05 D6 2A 00 00 00 00
$8F00  7F 18 E6 00 29 00 29 09 00 00 00 00 00 00 00 00
$8F10  00 00 00 00 00 30 31 D0 28 00 00 00 00 C8 00 14
$8F20  48 C8 84 52 00 14 00 20 67 1A 68 00 68 29 7F 00
$8F30  00 09 80 48 98 38 00 28 A8 68 91 00 A4 52 4C AF
$8F40  33 D6 00 C8 4C 7E 33 00 00 58 00 9D 00 00 49 00
$8F50  FA 00 29 00 29 09 9D 00 29 BD 9C 00 29 00 00 13
$8F60  85 4E A5 4E 0A AA 20 DA 33 C6 4E 10 F5 60 BD E2
$8F70  00 85 14 BD E3 4C 85 15 A0 00 B1 14 30 0A 00 A9
$8F80  91 14 20 63 3A 4C E6 33 00 00 00 00 00 00 00 00
$8F90  00 03 00 00 00 00 00 1F 34 34 34 A9 A9 34 86 00
$8FA0  00 86 00 38 38 86 8D 00 49 00 75 00 00 02 38 86
$8FB0  00 00 00 00 00 00 00 86 F4 00 00 00 00 00 B5 02
$8FC0  A8 C0 32 D0 00 00 FC A2 00 9D 9A 00 9D C2 00 F8
$8FD0  00 00 00 38 86 71 00 00 A9 38 38 73 00 00 85 00
$8FE0  38 0A 00 00 38 00 38 00 02 00 00 00 38 00 00 00
$8FF0  86 00 34 00 38 00 00 38 00 00 00 00 00 F8 00 00
$9000  38 38 38 4C 00 00 00 38 00 00 00 00 00 00 00 00
$9010  4C 00 00 00 A9 00 00 00 00 00 38 00 00 00 38 F2
$9020  00 00 00 00 FA A2 03 9D 9B 09 9D C3 09 F8 38 F7
$9030  00 00 00 02 00 70 00 0C 00 00 00 00 00 71 00 00
$9040  A9 00 00 00 38 06 00 00 38 FC 00 00 38 FF 00 34
$9050  49 00 49 00 49 00 00 38 38 58 02 9D 0F 00 A9 82
$9060  9D 14 00 00 38 F8 F8 90 00 18 00 00 12 00 A9 00
$9070  00 38 00 00 1E 00 00 32 00 00 3C 00 00 3D 00 A9
$9080  02 00 1B 00 00 2F 00 00 39 00 00 3B 00 00 00 00
$9090  00 A9 58 00 20 00 00 34 00 00 3E 00 A9 12 00 00
$90A0  00 00 00 00 00 37 00 00 48 00 A9 15 00 00 00 00
$90B0  A9 13 00 1A 00 00 2E 00 00 42 00 A9 16 00 1F 00
$90C0  00 33 00 00 1D 00 00 31 00 00 40 00 00 A9 14 00
$90D0  21 00 00 35 00 00 3F 00 A9 21 00 19 00 00 2D 00
$90E0  00 41 01 00 40 F0 00 A9 25 00 43 00 00 45 00 A9
$90F0  26 A6 40 0D 00 A9 22 00 46 00 00 47 00 00 49 00
$9100  A9 00 00 28 00 00 29 00 A9 00 34 23 00 00 2A 00
$9110  A9 0A 00 24 00 00 2B 00 A9 0C 00 25 00 00 27 00
$9120  00 A9 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$9130  00 00 60 00 00 38 1C 00 8D 1D 00 8D 44 00 8D 45
$9140  00 8D 6C 00 8D 6D 00 8D 94 DB 8D 95 DB A6 00 BD
$9150  95 4C 8D 00 20 EF 2F 00 A9 00 38 1E DB 00 00 00
$9160  00 00 00 00 00 A9 08 F8 71 F8 72 00 73 00 03 F8
$9170  74 38 38 00 6F 00 00 F8 75 38 38 85 76 02 F8 F8
$9180  6E 86 F8 34 34 38 F1 34 34 86 EA 85 79 38 38 00
$9190  A9 FE 01 78 C5 C5 40 40 01 01 00 00 01 01 00 00
$91A0  F1 A2 7F 00 34 9D 40 38 38 38 FA 38 38 38 A9 38
$91B0  38 38 38 1F 01 00 00 00 8D 8D F8 A9 34 40 2E 00
$91C0  34 2F 00 34 30 00 29 10 34 31 00 29 06 34 36 00
$91D0  29 00 34 00 43 00 00 00 00 32 00 00 00 00 A5 00
$91E0  00 00 00 8D 00 00 00 00 00 00 00 00 00 00 00 00
$91F0  00 00 00 00 00 A5 00 00 34 00 00 00 00 00 00 00
$9200  07 0A AA A5 A1 C9 4E 00 00 00 00 00 00 00 00 00
$9210  28 00 00 00 C9 23 00 38 F0 1F A5 2A 05 2B 05 2C
$9230  00 00 00 00 00 11 00 00 3B 60 D6 08 EA 38 38 00
$9240  4F 00 00 00 00 00 00 00 3B 34 A9 34 00 1A 3D 8E
$9250  3D 69 3B 69 3B A9 07 00 00 00 3B 3B 3B C9 00 00
$9260  00 2E A5 A1 C9 38 29 8D 8D 8D 00 13 A0 81 3B 3B
$9270  25 A9 1D 00 00 00 00 00 00 A5 EE 00 00 D0 11 A9
$9280  1E 34 34 00 21 0A AA A5 A1 C9 00 A9 05 00 00 C9
$9290  60 A1 C9 00 20 34 A9 34 C9 1B A5 2D D0 A5 A1 C9
$92A0  00 34 34 A1 8D 05 8D 05 00 34 00 00 00 10 69 3B
$92B0  00 1D C9 A1 C9 F8 38 86 8D 01 60 A9 20 C9 C9 C9
$92C0  AD 00 34 F0 15 34 34 34 00 00 00 00 00 00 00 00
$92D0  00 34 00 00 00 00 00 00 00 3B EE 34 34 00 60 00
$92E0  00 00 09 34 34 34 34 00 69 3B 00 15 3B 3B 3B AD
$92F0  A9 34 86 34 8D 00 29 86 86 29 A9 34 A9 34 A9 34
$9300  00 00 00 00 00 00 00 4C 40 00 00 00 00 00 00 00
$9310  40 86 86 A9 36 00 00 00 00 00 00 00 00 00 86 D0
$9320  22 A1 C9 A1 C9 1D 0A C9 C9 C9 C9 00 00 00 00 00
$9330  00 00 00 00 00 00 00 00 00 00 0B 00 00 00 00 00
$9340  86 38 86 29 38 86 00 28 8D 8D 00 86 86 29 C9 20
$9350  D0 0C A9 35 00 00 00 00 00 00 00 4C E1 37 38 00
$9360  00 0E 00 40 40 8D 8D A9 37 69 3B A0 1C 86 00 00
$9370  AD 86 00 D0 2B 00 00 38 E6 26 86 00 00 00 86 00
$9380  00 00 86 00 00 00 86 00 00 00 00 C9 08 00 00 00
$9390  00 00 00 16 C9 C9 00 69 3B 69 3B 00 86 86 86 86
$93A0  00 00 00 00 00 00 00 38 38 00 00 00 00 00 00 38
$93B0  38 4C 40 00 38 86 00 03 38 38 38 38 38 38 38 38
$93C0  38 38 38 38 38 38 38 4C A0 86 86 38 38 00 86 29
$93D0  70 86 86 86 86 86 86 38 38 00 00 86 86 86 86 38
$93E0  38 00 00 86 86 8D 74 86 38 86 E0 0C 86 86 86 86
$93F0  86 86 86 86 86 86 86 86 86 86 86 38 86 00 38 86
$9400  0B 38 8D AD 74 00 00 00 00 00 00 00 00 00 00 00
$9410  38 38 00 00 38 38 00 00 38 4C A8 38 38 38 38 1B
$9420  00 00 00 00 0B 9A 38 00 38 00 38 00 38 00 38 4C
$9430  E4 00 38 00 1A 00 00 00 38 2C 00 00 38 D0 1B 29
$9440  29 29 8D 16 29 00 29 A9 00 00 29 29 29 00 00 00
$9450  00 1A 00 00 00 00 06 00 00 00 29 91 00 00 18 29
$9460  00 29 00 13 8D 4C 8D 00 0A 00 00 8D 00 00 00 15
$9470  00 00 8D 8D 8D 8D 3B 00 00 0D 81 00 F0 07 38 00
$9480  0D 89 38 00 1F 29 29 29 00 1A 29 00 29 3B 19 00
$9490  00 A0 22 40 4C 8D 00 03 A0 1E 00 00 00 00 06 A0
$94A0  29 29 29 29 29 00 00 14 14 00 00 49 49 90 90 E6
$94B0  E6 29 29 29 29 4C 44 00 A6 38 00 00 00 00 00 00
$94C0  0B 0B 0B 00 00 00 00 00 00 00 00 4C 00 38 00 38
$94D0  38 00 71 29 00 38 F0 2F 00 00 4C 80 00 8D 00 00
$94E0  0B 00 00 00 00 00 86 00 00 8D 78 38 A6 72 E0 1C
$94F0  0B 00 0B 00 0B 00 0B 00 00 00 00 00 00 00 00 38
$9500  00 00 78 86 00 00 8D E6 79 00 00 00 79 00 00 00
$9510  00 00 00 00 00 00 00 00 4C A7 39 A6 73 38 38 B0
$9520  00 00 00 00 B4 00 86 73 00 00 86 79 00 00 4C E2
$9530  00 79 00 29 00 73 00 00 2C A5 00 00 00 00 00 00
$9540  00 00 00 00 00 3B 00 69 29 00 00 29 8D 8D 8D 8D
$9550  8D 2C 4C 8D 32 AD C3 00 0D C7 00 0D CB 00 0D CF
$9560  00 0D D3 00 00 00 90 29 00 29 15 29 00 29 3B 29
$9570  A0 21 00 00 29 AD D7 00 0D DB 00 0D DF 00 0D E3
$9580  00 0D E7 00 0D EB 29 00 29 90 90 E6 E6 29 29 29
$9590  29 A9 05 69 3B 00 A0 29 00 29 00 29 00 29 00 29
$95A0  00 29 00 29 00 29 00 00 00 4C 38 29 A6 29 00 24
$95B0  00 0B 0B 00 00 0B 0B 86 86 00 00 86 86 00 00 4C
$95C0  22 00 00 4C E0 00 00 AD EF 4D 0D F3 4D F0 11 00
$95D0  00 00 00 00 00 C9 23 00 00 58 05 00 00 00 00 40
$95E0  00 00 00 00 00 00 C9 06 3B 3B 58 24 85 6E 4C 4E
$95F0  40 00 00 14 29 00 29 49 14 90 02 E6 15 29 00 29
$9600  8C 8C 09 C5 00 48 BD C4 4E 48 00 00 18 18 69 00
$9610  49 0A A5 0B 69 00 00 0B 60 00 00 00 00 00 00 00
$9620  00 00 00 00 00 A9 13 00 00 00 A9 14 00 00 00 00
$9630  00 00 00 00 A9 17 00 00 00 00 00 00 C6 6C A9 2D
$9640  00 00 3A 00 00 42 85 6C 84 6D 00 00 00 00 00 A9
$9650  63 20 00 3A A9 64 4C CA 3A A6 6C A4 6D 00 00 8D
$9660  E6 6C 60 00 31 0D 00 00 00 00 00 00 00 8D 00 3B
$9670  00 00 A9 00 A0 0E 00 00 00 3B F8 4D 0D FC 4D 00
$9680  00 3B 00 4E 00 00 3B 9A 4E AD 04 4E F0 09 00 00
$9690  00 00 00 00 00 00 8D 00 00 A0 00 00 00 00 A5 32
$96A0  00 00 00 00 00 00 8D 00 00 00 00 00 00 3B 9B 00
$96B0  3B 00 A0 00 00 AA 3A 00 00 00 4C 00 00 00 00 C9
$96C0  3B 3B 3B 3B 3B 3B A0 01 00 00 3A A5 31 05 32 D0
$96D0  0F 00 00 00 30 69 3B 69 3B A9 3B 3B 3B 00 00 3A
$96E0  00 00 00 86 00 00 00 86 00 00 00 86 00 00 00 00
$96F0  00 4C 80 00 8D 00 00 0B 00 00 00 00 00 86 00 00
$9700  00 00 00 00 00 00 00 4C 06 00 00 4C 00 8D 00 00
$9710  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 09
$9720  8D AF 3B 8D 8D E0 00 00 00 00 00 00 90 09 8D 40
$9730  4C 8D 8D 40 4C 8D 38 1B 4C 8D A9 DA 8D 8D 8D 8D
$9740  8D 00 00 8D 8D 8D AD 09 8D 4C 8D F8 8D 8D A9 01
$9750  00 00 00 00 00 00 8D 8D 0D C9 C9 00 8D 4C 8D C9
$9760  13 C9 A5 A5 C9 C9 A0 17 20 8A 3A 00 00 00 00 00
$9770  00 00 00 8D A5 33 D0 1D 3B 3B 3B 30 18 3B 69 3B
$9780  A9 3B 00 3B 00 4C 8D 4C 8D F8 4F 42 00 18 8D 8D
$9790  A0 23 8D 4C 8D AD 11 8D 0D 15 4C 8D 10 00 00 00
$97A0  F8 C6 00 C9 05 B0 14 A9 18 00 02 D0 0E 29 07 09
$97B0  F8 09 F8 C9 18 09 F8 58 04 49 02 09 F8 40 E6 F8
$97C0  00 00 A5 F8 09 F8 F0 00 00 00 00 00 00 00 8D 4C
$97D0  5E 8D A6 71 00 00 40 40 8D 8D 00 A4 8D E6 00 4C
$97E0  8D 00 77 4C 8D 4C 8D 85 71 4C 8D 85 77 E6 78 30
$97F0  2B A5 78 09 F8 F0 0A 09 F8 F0 3B 00 8D 40 4C 8D
$9800  3C A6 72 E0 14 B0 F4 00 00 00 AC 40 E6 00 A9 02
$9810  00 78 09 F8 38 10 85 72 A9 C0 85 78 00 00 00 00
$9820  00 C9 C9 C9 AD 1E C9 0D 22 A1 C9 A1 C9 A1 C9 A1
$9830  C9 A1 C9 A1 C9 00 D6 16 EA C9 C9 A5 A5 C9 C9 30
$9840  11 AD 33 29 07 09 F8 09 F8 A9 00 85 65 3B C9 8D
$9850  21 43 F8 F8 32 4C 70 2C 69 3B C9 00 00 4C AF 3D
$9860  AD 86 00 D0 34 8D C9 C9 00 3F 42 C9 A1 C9 29 1F
$9870  A1 C9 B0 A9 61 3B 3B C9 00 20 3B 3B 00 B8 00 02
$9880  A5 C9 C9 A9 00 A2 C9 A1 C9 31 A2 C9 A9 00 3B 69
$9890  3B A9 50 00 00 F8 4C 4E 3D 20 33 41 AD 1E D0 AA
$98A0  29 03 09 10 8A 29 C0 09 0B A2 00 A5 BF 09 09 09
$98B0  C9 05 7D 40 3B 3B 00 D0 43 A9 08 8D 3B F8 A5 9E
$98C0  00 02 DD 89 4A B0 03 CA D0 F8 8E 00 3B A9 38 3B
$98D0  00 3B 3B C9 02 A0 10 F8 F8 F8 AD 00 00 D0 10 EE
$98E0  00 00 00 00 00 00 00 3B 06 00 00 3D 4C 80 3D 09
$98F0  F8 4E 00 00 20 81 3D 3B 38 20 8E 3D 60 3B 69 3B
$9900  00 00 00 C9 00 00 00 00 00 00 18 69 3E 6D C9 4E
$9910  C9 C9 A0 12 00 00 00 00 38 A9 5E A2 0B C9 A1 C9
$9920  A1 C9 A9 5F A2 0C 00 00 00 00 00 AD 09 F8 F0 E7
$9930  C9 20 00 00 29 0F 09 80 09 F8 38 09 F8 38 F0 05
$9940  00 00 11 29 07 09 F8 A2 11 9D D3 00 9D FB 00 9D
$9950  23 00 9D 4B D9 E0 0C B0 12 9D 86 00 9D AE D8 9D
$9960  76 00 9D 9E 00 9D C6 D9 9D EE D9 F8 38 DB AE 00
$9970  00 00 00 00 A9 3E 00 F2 E0 11 90 0B 20 59 11 C9
$9980  10 B0 F8 58 3C 85 F2 A0 8B 20 09 25 AD 00 4E 49
$9990  F8 F8 F8 4E A9 47 00 00 00 00 00 00 00 0C 00 00
$99A0  00 00 49 00 00 00 00 00 C9 00 19 00 00 00 00 4B
$99B0  00 00 00 00 00 00 00 0E A5 C9 C9 00 4D 18 6D F8
$99C0  4E 38 38 00 F8 4C F8 F8 AD C9 C9 30 0F AD 40 0A
$99D0  0A AA A5 A1 C9 A9 F8 A0 00 00 00 A5 C9 C9 C9 30
$99E0  14 A5 36 0D 52 C9 0D 56 A5 C9 C9 00 09 F8 A9 C9
$99F0  A0 0A 0A A5 A5 C9 C9 32 A5 03 0A 0A AA A5 A1 C9
$9A00  64 90 35 C9 8A 00 00 00 00 00 F0 2C 00 00 00 00
$9A10  00 00 E8 C9 B6 B0 0B 00 00 00 F0 1C 00 00 01 4C
$9A20  AF 3E E8 BD 00 01 F0 10 DE 4B 01 A9 01 AA 20 00
$9A30  31 A9 F4 A2 02 4C 75 31 A5 7B 00 00 05 4B 10 AD
$9A40  00 B0 29 03 58 90 B0 00 00 00 00 30 12 AD 4A 00
$9A50  0D 00 00 00 00 00 00 00 A9 00 A0 26 00 00 00 00
$9A60  00 32 00 00 00 30 1D AD 5B 00 00 00 00 00 00 00
$9A70  00 00 00 00 00 00 00 00 00 A0 11 00 00 00 F8 00
$9A80  00 00 00 00 AD 00 4E 30 23 AD 5F 00 0D 63 F8 0D
$9A90  6B F8 00 18 A9 57 A2 03 00 00 00 00 00 A9 58 A2
$9AA0  04 A0 00 20 00 00 F8 F8 4E 00 00 42 AD 00 4E 30
$9AB0  25 A5 39 D0 21 A9 59 A2 09 00 00 00 00 00 A9 5A
$9AC0  38 38 A0 00 00 00 00 A9 5B 38 38 A0 F8 09 F8 00
$9AD0  20 4F 42 00 00 4E 60 F8 F8 00 30 0E A5 3A D0 0A
$9AE0  F8 09 F8 A9 07 A0 01 20 B4 3A 4C F8 32 CE 00 4E
$9AF0  38 38 00 0A 8D 99 4E AD F8 D8 29 07 49 02 09 F8
$9B00  A2 1B 9D 80 D8 38 38 FA CE 00 4E F0 18 10 90 00
$9B10  01 8D 9A 4E A5 6E 85 70 E6 6E C9 1B 90 00 58 0B
$9B20  85 6E 20 00 40 AD 00 00 00 00 AD 7D 00 00 00 CE
$9B30  97 00 A9 5D 00 00 A0 25 00 00 00 AD 00 4E F0 11
$9B40  AD 81 4E D0 0C CE 98 4E A9 5C 38 00 A0 18 38 38
$9B50  17 20 28 32 90 90 85 4C A6 4C F6 77 30 67 B5 77
$9B60  38 00 F0 1E C9 07 F0 4D E0 00 58 00 20 86 00 00
$9B70  00 40 E0 90 38 06 20 90 40 4C 49 40 00 01 58 00
$9B80  9A 90 90 90 90 90 90 90 38 AD FF 03 F0 03 4C D1
$9B90  00 58 38 38 00 EB 09 09 09 10 20 10 8D 00 D4 38
$9BA0  38 05 10 10 8D 0E 38 8D 8D 38 38 05 00 00 A0 60
$9BB0  88 D0 FD AD 1B D4 00 00 02 00 D0 F2 00 EA EA 58
$9BC0  00 85 AD AD 00 00 00 58 00 00 89 00 00 00 38 8B
$9BD0  BD 38 D1 00 38 88 49 00 00 38 8A E8 D0 E7 38 00
$9BE0  38 00 01 90 A9 8D 38 38 89 90 03 9D 38 8A 90 C0
$9BF0  9D B0 8A 38 38 EE 90 90 90 90 90 90 90 90 58 90
$9C00  00 00 00 00 00 00 00 00 A9 A0 00 00 A9 A4 00 00
$9C10  00 00 00 00 00 00 00 00 00 00 00 58 94 00 00 00
$9C20  00 00 00 00 00 A9 A8 00 00 A9 AC 00 00 00 00 00
$9C30  00 00 00 00 00 00 00 00 58 98 00 00 00 00 00 00
$9C40  00 00 A9 B0 00 00 A9 B4 00 00 00 00 48 58 7F 85
$9C50  F3 00 00 85 38 58 9C 85 00 00 00 85 06 85 08 A9
$9C60  B8 AA 9A 85 07 A9 BC 85 09 20 92 48 20 2F 51 20
$9C70  F7 10 A9 35 85 38 A9 38 38 28 00 B0 2A 00 B0 2B
$9C80  00 1F F7 1B 38 38 1F F5 8D 29 38 58 00 A2 00 B0
$9C90  38 38 38 38 38 38 38 38 38 00 E0 00 00 E0 38 00
$9CA0  02 85 17 78 00 00 00 00 00 07 4C 84 05 BD 38 38
$9CB0  E0 E0 B0 B0 BD BD 38 38 E0 E0 B0 B0 BD BD 38 38
$9CC0  38 B0 B0 B0 38 38 38 38 E0 B0 B0 B0 B0 38 38 38
$9CD0  38 07 4E 04 01 38 38 38 38 38 38 38 38 38 38 38
$9CE0  42 38 38 8D 38 38 8D 38 00 1B BD 38 38 8E E0 02
$9CF0  B0 1B BD 38 38 8E E0 02 B0 1B BD 38 38 1B 38 38
$9D00  38 38 38 38 38 38 00 38 5E 25 00 00 8D 00 01 38
$9D10  38 00 20 2E 0E A2 3F 38 38 AD C0 00 00 38 FA 00
$9D20  00 38 38 38 00 1D 00 38 10 BD 38 38 8D 38 38 38
$9D30  38 38 38 38 38 00 0A 38 38 38 00 56 38 38 38 00
$9D40  00 05 27 00 1F 0F 8D F8 8F A2 0B 00 00 0E 9D CC
$9D50  83 38 38 38 00 2C 38 38 38 58 15 20 69 08 8C 8D
$9D60  38 38 8C 8D 38 38 8C 8D 38 38 8C 8D 38 38 1F FD
$9D70  8D 38 38 1F F6 00 58 00 58 00 D0 00 00 05 22 D0
$9D80  8D 23 D0 00 08 8E 16 D0 8D 38 38 A2 00 A9 F1 00
$9D90  E0 D9 00 E0 DA A9 DC 38 38 8C 00 68 8C CA D0 ED
$9DA0  38 27 BD 0D 00 00 00 9D 38 8C BD BD 00 00 00 9D
$9DB0  C8 00 BD E5 49 00 00 9D F0 8C BD 35 4A 09 80 9D
$9DC0  68 38 00 38 38 00 38 05 00 01 A9 4F A2 06 00 00
$9DD0  00 00 17 A9 50 A2 07 A0 2B 00 00 17 A9 51 A2 08
$9DE0  A0 38 20 E2 17 A2 09 BD 00 38 00 00 00 9D F0 38
$9DF0  BD 00 8E 38 38 38 9D 40 8E E0 02 B0 1B BD 38 38
$9E00  00 00 00 9D EB 38 BD 00 8E 00 00 00 9D 3B 8E BD
$9E10  00 8E 30 18 40 9D 8B 8E 38 1F 00 00 00 42 8D 00
$9E20  00 00 00 42 8D 00 42 00 00 00 00 00 20 65 00 38
$9E30  00 42 F0 03 20 4C 00 38 85 13 D0 1B CE 00 00 10
$9E40  16 00 00 8D BB 00 A9 03 8D 14 1F 1F 1F 05 70 E8
$9E50  CA 8E 71 E8 20 03 E0 38 00 00 8F 00 5D B1 00 5D
$9E60  90 00 5D AF 00 5D 91 CF 5D B0 CF F0 07 91 1D E6
$9E70  1E 4C F3 06 38 09 85 4A A9 38 85 49 00 00 00 00
$9E80  00 00 58 20 B1 08 78 00 00 00 00 00 00 00 00 38
$9E90  8D 8D 38 38 00 00 38 00 00 38 85 00 58 00 00 0A
$9EA0  E3 20 00 E0 AD C9 00 8D CB 42 AD CA 42 8D CC 42
$9EB0  20 A7 0E 38 38 38 00 EF 38 38 00 A2 FD 9A 20 72
$9EC0  0F 20 63 07 20 BC 00 A9 00 85 1D A9 F3 85 1E 20
$9ED0  DB 50 D6 05 EA 58 4C C2 1B 00 38 85 8B 85 8C 20
$9EE0  2D 08 20 86 13 38 00 85 4B A0 8B 38 D8 20 69 08
$9EF0  38 38 1F 38 00 00 00 43 8D 00 43 A9 8C 8D 38 38
$9F00  A9 CE 00 00 43 8D 00 43 20 56 00 00 F8 20 00 09
$9F10  A2 27 00 00 AD 38 00 C9 28 00 58 20 00 00 8C A9
$9F20  00 00 50 8C E0 08 B0 0A 00 0F 9D F8 8F 00 00 9D
$9F30  00 89 00 1F 00 00 00 AA 00 80 81 00 80 82 00 00
$9F40  83 00 D0 F4 A2 03 BD 9B 47 9D 00 D0 00 1F F7 00
$9F50  00 00 00 DD 00 38 38 00 00 85 F2 00 00 00 00 00
$9F60  38 00 1F 15 00 00 17 00 00 1B 00 00 1C 00 00 00
$9F70  05 1D 00 1F 80 20 5A 31 20 C2 31 A9 11 8D BD 43
$9F80  20 96 00 20 BB 00 20 C7 1A 20 ED 1A 00 00 85 60
$9F90  85 66 A2 00 58 FF 9D 40 4F 1F 1F FA 00 00 A9 00
$9FA0  4C 8E 00 A9 00 00 00 DD 8D 00 DC 00 0D DD AD 0D
$9FB0  DC D8 58 C1 00 08 00 58 48 00 09 04 58 00 00 1A
$9FC0  00 00 19 00 00 38 00 00 7F 00 38 00 1F FB 00 8D
$9FD0  00 1F 05 05 0E 10 20 10 D4 38 00 58 8D 05 60 00
$9FE0  00 8D 00 00 8C 00 38 BD AD 00 00 69 00 9D 39 00
$9FF0  BD 00 38 00 00 9D 4D 00 AD AD 00 00 1F AD 38 00

; ============================================================
; DATA $A000-$A617
; ============================================================

$A000  00 69 28 8D 00 43 AD 4C 00 00 00 8D 00 43 00 00
$A010  00 60 43 18 69 50 9D 61 43 BD 74 43 69 00 9D 75
$A020  43 00 E0 0D 00 1F 60 00 49 05 4A D0 03 4C 31 05
$A030  00 00 1F 0E 01 20 9E 13 AD 00 01 F0 19 16 00 1F
$A040  00 01 AD 09 01 4C 56 09 29 7F C9 03 F0 24 C9 06
$A050  F0 2C C9 05 F0 4C A5 4A C9 08 D0 0F A5 49 C9 00
$A060  B0 00 A9 0E A2 0A A0 00 00 E2 17 AD 00 00 00 00
$A070  58 B5 20 4B 09 A9 A9 80 58 00 D0 00 91 02 00 00
$A080  E5 1F 0B 00 00 00 1F 0E 00 00 D0 A9 00 8D 00 00
$A090  00 00 00 00 00 A9 1E 00 00 04 00 73 05 00 73 06
$A0A0  00 73 07 A9 0C 40 73 C5 C9 40 00 01 58 00 00 01
$A0B0  58 00 D0 E1 A9 3B 00 00 00 AD 00 DC 2D 01 DC 00
$A0C0  10 58 F6 58 00 58 00 58 00 58 00 1F C8 00 16 00
$A0D0  1F 16 00 18 00 1F 00 8D 00 D0 00 00 E5 78 00 58
$A0E0  00 01 01 00 00 00 A0 00 00 20 01 00 00 EE 70 C5
$A0F0  EE 00 C5 AD 73 C5 C9 40 00 E8 A9 37 00 01 58 00
$A100  00 00 00 00 F0 0B A9 A5 8D 26 18 8D E5 2F 8D 55
$A110  31 20 33 00 C9 00 F0 08 A9 09 8D E2 29 8D F7 29
$A120  78 D8 A2 FF 9A E8 8A 95 00 00 D0 FB E8 86 CC A9
$A130  2F 85 00 A9 36 85 01 20 36 E5 20 BF 00 1F 00 A9
$A140  06 8D 20 D0 8D 21 D0 00 00 D8 00 00 D9 00 00 DA
$A150  00 00 DB 00 D0 F1 AD 00 D0 00 00 00 11 D0 1F 32
$A160  85 02 1F 40 8D 1F 00 1F 00 8D 19 00 1F 1F 00 13
$A170  00 8D 18 00 85 BA 1F 1F 8D 02 03 85 BB A9 04 8D
$A180  03 03 58 00 00 8A 9D 34 03 E8 E0 CC D0 F8 A2 00
$A190  BD 00 C0 9D 00 04 E8 D0 F7 EE 1C C6 EE 00 C6 AD
$A1A0  1F C6 C9 09 D0 E8 3F 00 04 A2 1F A9 0D 00 04 D8
$A1B0  BD 59 C6 9D 04 04 CA 10 F2 A9 79 8D 3B C6 A9 1B
$A1C0  8D 11 D0 20 E4 FF C9 4E F0 04 C9 59 D0 F5 60 3F
$A1D0  00 20 55 0E 00 09 0D 00 14 05 04 20 0C 09 16 05
$A1E0  00 20 3F 3F D6 0A 20 4F 10 10 0F 0E 05 0E 00 13
$A1F0  20 03 01 0E 27 00 20 08 09 14 20 19 0F 15 20 3F
$A200  3F 00 20 20 00 00 00 00 00 00 00 00 00 00 00 00
$A210  00 00 00 00 00 00 00 00 00 00 00 00 00 67 00 BF
$A220  00 00 00 C0 53 08 00 00 00 00 FF 21 53 07 FF C6
$A230  00 00 00 A7 00 A7 00 00 00 00 00 00 00 00 00 00
$A240  0F 00 FF B7 00 00 00 F6 00 00 FF EE 00 0E 00 F5
$A250  00 00 00 00 00 97 B7 00 00 00 00 00 00 0D 00 91
$A260  51 91 46 31 1A 11 45 44 B4 A2 91 AC 88 88 89 00
$A270  00 00 00 00 00 00 00 00 00 00 00 00 00 00 B3 18
$A280  55 A5 28 4A C4 2A 00 22 2A A2 22 22 8A 89 88 E6
$A290  7C C9 F4 52 DA B9 B4 B4 26 EF A7 9E 6C 9A B3 00
$A2A0  00 00 00 00 00 D2 F9 00 53 12 21 53 FF FB 00 00
$A2B0  F3 00 07 00 D0 00 05 00 00 06 97 33 21 53 97 02
$A2C0  FF 00 12 00 FF 12 00 00 00 00 00 00 00 00 00 00
$A2F0  00 00 B5 20 20 B5 00 00 00 00 06 E3 00 00 E4 00
$A320  00 00 00 26 00 AA 00 00 00 00 00 00 B3 00 00 00
$A330  00 00 00 00 00 00 00 00 00 00 6B 26 00 00 00 00
$A350  00 00 00 00 00 AE 00 00 00 00 6B 00 00 00 00 00
$A370  00 00 00 00 00 AE 6E 00 00 2A 00 00 13 2A 00 00
$A380  00 AA 00 26 F7 AA 00 00 00 00 3F 00 33 00 00 00
$A390  00 00 00 00 00 B2 00 00 00 00 EE 26 93 00 00 26
$A3A0  D3 AA E6 26 D7 AA 00 00 00 00 00 00 B3 32 00 00
$A3B0  00 B2 BF BF F3 B2 00 00 00 00 00 00 00 00 00 00
$A3D0  00 00 00 00 00 AE 00 00 00 00 7B 00 00 00 00 00
$A3E0  00 BE 73 A6 32 BE 00 00 00 00 00 00 00 00 00 00
$A3F0  00 AE 0E 1E 9B AE 00 00 00 00 00 00 00 00 00 00
$A410  00 00 00 00 00 B7 00 00 00 00 00 00 00 00 00 00
$A430  00 00 00 F6 00 00 00 00 00 00 00 00 00 00 00 00
$A450  00 17 00 00 00 17 00 00 00 00 00 00 00 00 00 00
$A470  00 00 00 1E B2 17 00 00 00 2F 00 00 00 2F 00 00
$A490  00 00 00 F6 8F B7 42 3E 00 00 00 00 B3 00 00 00
$A4A0  00 AF C2 7E 00 AF 00 00 00 00 00 00 89 00 00 00
$A4B0  00 B7 3F F6 8B B7 00 00 00 00 00 00 00 00 00 00
$A4C0  00 00 00 BE 36 00 00 00 00 00 00 00 00 00 00 00
$A4D0  00 00 00 00 00 17 00 00 00 00 00 00 00 00 00 00
$A4E0  00 0F 96 BE 32 0F 00 00 00 00 00 00 00 00 00 00
$A4F0  00 17 52 1E 92 17 F8 16 37 59 7D A3 CB F4 21 53
$A500  85 B8 F1 2D 6E B2 F9 45 95 E9 44 A3 08 73 E5 5E
$A510  DC 63 F2 89 29 D3 89 47 11 E7 C9 BA B7 C7 E5 14
$A520  53 A5 0D 8A 21 CD 95 75 6D 8E C8 29 AB 4A 1C 14
$A530  3D 95 21 EF DA 1C 8C 52 56 94 38 28 7A 2A 42 DE
$A540  B4 38 2C A4 AC 28 70 50 F4 54 01 00 07 02 D6 05
$A550  03 D6 04 04 00 05 05 06 06 00 00 07 08 08 09 09
$A560  0A 0B 0B 0C 0D 0E 0E 0F 10 11 12 13 15 16 17 19
$A570  1A 1C 1D 1F 21 23 25 00 2A 2C 2F 32 35 38 3B 3F
$A580  42 46 4B 4F 54 59 5E 64 6A 70 77 7E 85 8D 96 9F
$A590  A8 B2 BD C8 D4 E0 EE D6 07 00 00 00 FF 00 07 07
$A5A0  00 FF FF 00 00 00 00 00 00 00 21 21 97 22 97 11
$A5B0  00 00 00 00 00 00 00 00 00 00 93 11 97 30 18 97
$A5C0  93 85 09 09 09 09 85 85 85 85 09 09 09 09 27 2A
$A5D0  2D 30 00 DE EA 00 B7 DE 0F 2E B7 00 00 00 00 00
$A5E0  00 00 00 00 00 00 AE 2F 0E AF AE 00 34 E4 00 52
$A5F0  00 00 79 E4 00 00 BF B6 02 A7 BF 1F BE 16 00 1F
$A600  00 4D 00 43 52 00 50 45 41 52 4C 20 4D 55 53 00
$A610  43 20 50 4C 41 59 45
