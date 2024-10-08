; SEE DATA AT END OF FILE
;
;------------------------------------------------------------------------------
;                       INITIALIZE SHIP SHOT (1 TO 4)
;------------------------------------------------------------------------------
;
SHOTINIT:
    BTST      #7,JOY1            ;BUTTON PRESSED?
    BNE       SS2
SS1:
    RTS
SS2:
        LEA     SHOTFLG1+6,A0  ; LOOK FOR UNUSED BULLET
        ORI.B   #0,-(A0)        ; LOOK
        BEQ     SS2A            ; GOT ONE!
        ORI.B   #0,-(A0)        ; ETC...
        BEQ     SS2A
        ORI.B   #0,-(A0)
        BEQ     SS2A
        ORI.B   #0,-(A0)
        BEQ     SS2A
        ORI.B   #0,-(A0)
        BEQ     SS2A
        ORI.B   #0,-(A0)
        BEQ     SS2A
        RTS                     ; NO DICE ... RETURN

SS2A:
        TST     STUNS           ; TEST AMMO
        BEQ     SS1             ; NO BULLETS NO SHOOTING!
        SUBQ    #1,STUNS
        CLR     SNDDMAC
        MOVE    #1,SNDDMAC
        MOVE.B    #1,(A0)            ;SET SHOT FLAG
        MOVE.L  A0,D0
        SUB.L   #SHOTFLG1,D0
;
    LEA       SHOTX,A1           ;SETUP X & Y INCREMENT FOR THIS SHOT
    LSL.W     #1,D0
    ADDA.L    D0,A1
;
    CLR.L     D1
    MOVE.W    SHIPDIR,D1         ;GET SHIP'S DIRECTION
    LSL.W     #1,D1              
    LEA       SHOTTBL,A2         ;GET SHOT DIRECTION TABLE
    ADDA.L    D1,A2
;
    MOVE.W    (A2),(A1)          ;SAVE THE X INCREMENT OR DECREMENT VALUE
    MOVE.W    32(A2),(6*2)(A1)   ;SAVE THE Y INCREMENT OR DECREMENT VALUE
;
    LEA       SHIPPARM,A2        ;GET SHIP'S PARMS
    LEA       SHOTPARM,A1        ;GET BASE OF SHOT PARMS
    LSL.W     #3,D0              ;*16 FOR OFFSET TO SHOT PARMS
    ADDA.L    D0,A1              ;A1 POINTS TO SHOT PARMS
    MOVE.W    XCORD(A2),XCORD(A1)       ;SAVE SHIPS XCORD
        ADD     #6,XCORD(A1)
    MOVE.W    YCORD(A2),YCORD(A1)       ;SAVE SHIPS YCORD
        ADD     #6,YCORD(A1)
    RTS                                 ;DONE WITH INIT

;------------------------------------------------------------------------------
;                       MOVE SHIP SHOT (1 TO 4)
;------------------------------------------------------------------------------
;
SHOTMOVE:
    MOVE.W    WINDX,D0
    MOVE.W    D0,D1
    MOVE.W    WINDY,D2
    MOVE.W    D2,D3
    ADDI.W    #((WINDW+1)*16),D1
    ADDI.W    #((WINDH+1)*16),D3
;
    ORI.B     #0,SHOTFLG1
    BEQ       SHM3
    LEA       SHOTPARM,A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM2
    CMP.W     YCORD(A2),D2
    BHI       SHM2
    CMP.W     XCORD(A2),D1
    BLS       SHM2
    CMP.W     YCORD(A2),D3
    BLS       SHM2
;
    LEA       SHOTX,A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    BRA       SHM3
SHM2:
    CLR.B     SHOTFLG1
SHM3:
;
    ORI.B     #0,SHOTFLG2
    BEQ       SHM5
    LEA       SHOTPARM+16,A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM4
    CMP.W     YCORD(A2),D2
    BHI       SHM4
    CMP.W     XCORD(A2),D1
    BLS       SHM4
    CMP.W     YCORD(A2),D3
    BLS       SHM4
;
    LEA       SHOTX+2,A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    BRA       SHM5
SHM4:
    CLR.B     SHOTFLG2
SHM5:
;
    ORI.B     #0,SHOTFLG3
    BEQ       SHM7
    LEA       SHOTPARM+32,A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM6
    CMP.W     YCORD(A2),D2
    BHI       SHM6
    CMP.W     XCORD(A2),D1
    BLS       SHM6
    CMP.W     YCORD(A2),D3
    BLS       SHM6
;
    LEA       SHOTX+4,A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    BRA       SHM7
SHM6:
    CLR.B     SHOTFLG3
SHM7:
;
    ORI.B     #0,SHOTFLG4
    BEQ       SHM9
    LEA       SHOTPARM+48,A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM8
    CMP.W     YCORD(A2),D2
    BHI       SHM8
    CMP.W     XCORD(A2),D1
    BLS       SHM8
    CMP.W     YCORD(A2),D3
    BLS       SHM8
;
    LEA       SHOTX+6,A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    BRA         SHM9
SHM8:
    CLR.B     SHOTFLG4
SHM9:

    ORI.B     #0,SHOTFLG5
    BEQ       SHM11
    LEA       SHOTPARM+(4*16),A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM10
    CMP.W     YCORD(A2),D2
    BHI       SHM10
    CMP.W     XCORD(A2),D1
    BLS       SHM10
    CMP.W     YCORD(A2),D3
    BLS       SHM10
;
    LEA       SHOTX+(2*4),A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    BRA         SHM11
SHM10:
    CLR.B     SHOTFLG5
SHM11:

    ORI.B     #0,SHOTFLG6
    BEQ       SHM13
    LEA       SHOTPARM+(5*16),A2
;
    CMP.W     XCORD(A2),D0
    BHI       SHM12
    CMP.W     YCORD(A2),D2
    BHI       SHM12
    CMP.W     XCORD(A2),D1
    BLS       SHM12
    CMP.W     YCORD(A2),D3
    BLS       SHM12
;
    LEA       SHOTX+(2*5),A1
    MOVE      (A1),D4
    ADD.W     D4,XCORD(A2)
    MOVE      (6*2)(A1),D4
    ADD.W     D4,YCORD(A2)
    RTS
SHM12:
    CLR.B     SHOTFLG6
SHM13:
    RTS
;
   END
 