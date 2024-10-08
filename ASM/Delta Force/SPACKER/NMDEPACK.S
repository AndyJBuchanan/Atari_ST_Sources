

; #############################################################################
; Entpackroutine f�r Modulpacker
; Eingabeparameter :
; a0 = Pointer auf Module

depack_module:

                bsr     analyse_module       ; Samplestart finden

                bsr     init_depack

                movea.l sample_start(PC),A0  ; gepacktes Sample
                move.l  sample_end(PC),D0
                sub.l   A0,D0                ; Ungepackte L�nge

                move.l  D0,-(A7)
                bsr     depack_sample        ; �ber das gepackte File
                move.l  (A7)+,D0             ; entpacken
                rts


; a0=module address

analyse_module: move.l  A0,-(A7)

                lea     $03b8(A0),A1

                moveq   #$7f,D0
                moveq   #0,D4
mt_loop:        move.l  D4,D2
                subq.w  #1,D0
mt_lop2:        move.b  (A1)+,D4
                cmp.b   D2,D4
                bgt.s   mt_loop
                dbra    D0,mt_lop2
                addq.b  #1,D2

                asl.l   #8,D2
                asl.l   #2,D2
                add.l   #$043c,D2
                move.l  D2,D1
                add.l   A0,D2
                movea.l D2,A2

                move.l  A2,sample_start

                moveq   #$1e,D0
mt_lop3:
                moveq   #0,D4
                move.w  42(A0),D4
                add.l   D4,D4
                adda.l  D4,A2
                adda.l  #$1e,A0
                dbra    D0,mt_lop3

                move.l  A2,sample_end

                movea.l (A7)+,A0

                rts



depack_sample:
; a0=gepacktes Sample (ist gleichzeitig auch Ziel)
; d0=Ungepackte L�nge

                lea     depack_hi(PC),A2
                lea     depack_lo(PC),A3

                addq.l  #1,D0
                and.b   #-2,D0               ; L�nge aufrunden
                move.l  D0,D7
                lsr.l   #1,D7                ; Samplel�nge in Worten

                lea     0(A0,D0.l),A1        ; Ende des Ziels
                adda.l  D7,A0                ; Ende der Quelldaten

                move.w  #128,D0              ; Letztes Byte
                moveq   #0,D1                

depack_loop:    move.b  -(A0),D1             ; 2 Distanzen holen
                add.b   0(A2,D1.w),D0
                move.b  D0,-(A1)
                add.b   0(A3,D1.w),D0
                move.b  D0,-(A1)

                subq.l  #1,D7
                bne.s   depack_loop

                rts

init_depack:
; muss vor erstem Entpacken initialisiert werden

                lea     depack_lo(PC),A1
                move.w  #15,D7
init1:          lea     power_bytes(PC),A0
                move.w  #15,D6
init2:          move.b  (A0)+,(A1)+
                dbra    D6,init2
                dbra    D7,init1

                lea     power_bytes(PC),A0
                lea     depack_hi(PC),A1
                move.w  #15,D7
init3:          move.w  #15,D6
                move.b  (A0)+,D0
init4:          move.b  D0,(A1)+
                dbra    D6,init4
                dbra    D7,init3

                rts


power_bytes:    DC.B -128,-64,-32,-16,-8,-4,-2,-1,0,1,2,4,8,16,32,64

sample_start:   DC.L 0
sample_end:     DC.L 0

depack_lo:      DS.B 256
depack_hi:      DS.B 256

; DEPACK END
                END
