X:        BRA       MAIN


SETINTS:  MOVE.W    #$2700,SR
          MOVE.L    $70,OLDVSYNC
          MOVE.L    #VSYNC,$70
          MOVE.B    $FFFA07,MFPIEA
          MOVE.B    $FFFA09,MFPIEB
          MOVE.B    $FFFA1B,MFPTBC
          MOVE.B    $FFFA21,MFPTBD
          MOVE.L    $120,OLDTIMB

          MOVE.B    #0,$FFFA07
;          MOVE.B    #1,$FFFA07
;          MOVE.B    #1,$FFFA13
          MOVE.B    #0,$FFFA09
;          MOVE.L    #HSYNC,$120
;          MOVE.B    #1,$FFFA21
;          MOVE.B    #0,$FFFA1B
          MOVE.W    #$2300,SR
          RTS

RETINTS:  MOVE.W    #$2700,SR
          MOVE.L    OLDVSYNC,$70
          MOVE.B    MFPIEA,$FFFA07
          MOVE.B    MFPIEB,$FFFA09
          MOVE.B    MFPTBC,$FFFA1B
          MOVE.B    MFPTBD,$FFFA21
          MOVE.L    OLDTIMB,$120
          MOVE.W    #$2300,SR
          RTS


VSYN:     


VSYNC:    ST        VFLAG
          MOVE.L    D5,PIXCOUNT
          MOVEQ     #0,D5
          MOVE.L    #3840,D6
          MOVEQ     #0,D4
          MOVE.L    PHYSADDR,A4
          RTE



PALETTE:  DC.W      $0000,$0777,$0321,$0321,$0532,$0532,$0642,$0642
          DC.W      $0753,$0753,$0201,$0201,$0402,$0402,$0603,$0777

PALETTE2: DC.W      $000,$111,$222,$333,$444,$555,$666,$777,$700
          DC.W      $234,$345,$001,$456,$012,$567,$123






; D6 = COLOR NUMBER * 256
; D7 = PLACE NUMBER * 16
; A6 = POINTER TO PIXTAB
; A5 = POINTER TO SCREENPOS

;PUTPIX:   ADD.L     D6,D7
          MOVEM.L   (A6,D7.W),D0-D3
          AND.L     D0,(A5)
          OR.L      D2,(A5)+
          AND.L     D1,(A5)
          OR.L      D3,(A5)
          RTS

; D6 = COLOR NUMBER * 4
; D7 = PLACE NUMBER
; A6 = POINTER TO JUMPTAB
; A5 = POINTER TO SCREENPOS

PUTPIX:   JMP       (A6,D6.W)

COLOR15:  BCLR      #3,D7
          BNE.S     FORBIC15_1
          ADDQ.L    #1,A5
FORBIC15_1:
          BSET      D7,(A5)
          BSET      D7,2(A5)
          BSET      D7,4(A5)
          BSET      D7,6(A5)
          RTS




MAKPIXTAB:
          LEA       PIXTAB(PC),A0
          MOVE.W    #$8000,D2
          MOVEQ     #0,D0
          MOVEQ     #15,D6
OMMP3:    MOVEQ     #15,D1
OMMP2:    MOVE.W    D0,D4
          MOVEQ     #3,D5
OMMP1:    MOVE.W    D2,D3
          BTST      #0,D4
          BEQ       FORBIMP1
          MOVE.W    D3,8(A0)
          NOT.W     D3
          MOVE.W    D3,(A0)
          BRA       FORBIMP2
FORBIMP1: NOT.W     D3
          MOVE.W    D3,(A0)
          MOVE.W    #0,8(A0)
FORBIMP2: ADDQ.L    #2,A0
          LSR.W     #1,D4
          DBRA      D5,OMMP1
          LSR.W     #1,D2
          ADDQ.L    #8,A0
          DBRA      D1,OMMP2
          MOVE.W    #$8000,D2
          ADDQ.L    #1,D0
          DBRA      D6,OMMP3
          RTS



INITVARS: 
          MOVE.W    #4,-(SP)
          TRAP      #14
          ADDQ.L    #2,SP
          MOVE.W    D0,OLDRES
          MOVE.W    #2,-(SP)
          TRAP      #14
          ADDQ.L    #2,SP
          MOVE.L    D0,PHYSADDR
          MOVE.L    PHYSADDR,PHYSADD2
          SUB.L     #32000,PHYSADD2
          CLR.L     -(SP)
          MOVE.W    #$20,-(SP)
          TRAP      #1
          ADDQ.L    #6,SP
          MOVE.L    D0,SAVESTCK
          CLR.W     -(SP)
          MOVE.L    PHYSADDR,-(SP)
          MOVE.L    PHYSADDR,-(SP)
          MOVE.W    #5,-(SP)
          TRAP      #14
          ADDA.L    #12,SP
          MOVE.L    #SPALETTE,A0
          MOVEM.L   $FF8240,D0-D4/D6-D7/A1
          MOVEM.L   D0-D4/D6-D7/A1,(A0)
          MOVE.L    #PALETTE,A0
          MOVEM.L   (A0),D0-D4/D6-D7/A1
          MOVEM.L   D0-D4/D6-D7/A1,$FF8240
          MOVE.L    PHYSADDR,OLDPHYS



          LEA       TAB160,A0
          MOVEQ.L   #0,D1
          MOVE.L    #199,D0
MAKTAB:   MOVE.L    D1,(A0)+
          ADD.L     #160,D1
          DBRA      D0,MAKTAB

;          BSR       MAKPIXTAB
          BSR       SETINTS

          MOVE.L    #COLOR15,JUMPTAB

          RTS
            
ENDP:     TST.B     VFLAG
          BEQ       ENDP
      
          BSR       RETINTS

          MOVE.W    OLDRES,-(SP)
          MOVE.L    OLDPHYS,-(SP)
          MOVE.L    OLDPHYS,-(SP)
          MOVE.W    #5,-(SP)
          TRAP      #14
          ADD.L     #12,SP

          MOVE.L    #$FF8240,A0
          MOVE.L    #SPALETTE,A2
          MOVEM.L   (A2),D0-D7
          MOVEM.L   D0-D7,(A0)
            
            
            
          MOVE.L    SAVESTCK,-(SP)
          MOVE.W    #$20,-(SP)
          TRAP      #1
          ADDQ.L    #6,SP
            

          RTS


MAIN:     BSR       INITVARS
          MOVE.L    PHYSADDR,A4
          LEA       JUMPTAB(PC),A6
          MOVE.L    #0,D6
          MOVEQ     #16,D4
          MOVEQ     #0,D5
MLOOP:    MOVE.L    D4,D7
          MOVE.L    A4,A5
          JSR       PUTPIX
          SUBQ.W    #1,D4
          BNE       FORBIM1
          MOVEQ     #16,D4
          ADDQ.L    #8,A4
FORBIM1:  ADDQ.L    #1,D5
          CMP.B     #185,$FFFC02
          BNE       MLOOP

          BSR       ENDP

          MOVE.L    PIXCOUNT,D4
          RTS



PIXTAB:   DS.L      1024
JUMPTAB:  DC.L      0
VFLAG:    DC.W      0
PIXCOUNT: DC.L      0

PHYSADDR: DC.L      0
PHYSADD2: DC.L      0
HANDLE:   DC.L      0
OLDVSYNC: DC.L      0
MFPIEA:   DC.W      0
MFPIEB:   DC.W      0
MFPTBC:   DC.W      0
MFPTBD:   DC.W      0
OLDTIMB:  DC.L      0

SPALETTE: DS.L      8


OLDPHYS:  DC.L      0
OLDRES:   DC.W      0
SAVESTCK: DC.L      0

TAB160:   DS.L      200

          END
 
