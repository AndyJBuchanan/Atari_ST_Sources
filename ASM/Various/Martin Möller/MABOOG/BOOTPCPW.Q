;--------------------------------------
;      Bootsektor-Pictureleser
;      Passwordabfrage
;      Monochromeversion
;      Version 1.11mono
;      (c)1989 by Martin M�ller
;                 Klopstockweg 23
;                 4440 Rheine
;--------------------------------------
; Liest Bild PICTURE.PIC von Disk A:
; Bild liegt im Screenformat vor
;--------------------------------------
       move.w #$00,$482   ; kein Command.Prg laden
       move.w #$04,-(sp)  ; getrez
       trap #14           ; do it!
       addq.l #2,sp
       cmp.w #2,D0        ; if rez=high
       bne.s error        ; nein, dann error!
       move.w #2,-(sp)    ; read/write
       pea fname          ; A:\PICTURE.PIC
       move.w #$3D,-(sp)  ; Fopen
       trap #1
       addq.l #8,sp
       tst.w D0
       bmi error
       move.w d0,d7       ; Handle nach D7
       move.w #$02,-(sp)  ; Physbase
       trap #14
       addq.l #2,sp
       move.l D0,-(sp)    ; Physbase
       move.l #32000,-(sp) ; Bilddaten
       move.w d7,-(sp)    ; Handle
       move.w #$3f,-(sp)  ; Fread
       trap #1
       add.l #12,sp
       move.w d7,-(sp)    ; Handle
       move.w #$3E,-(sp)  ; Fclose
       trap #1
       addq.l #4,sp
error: move.w #3,D6
       lea buff,a5
lp1:   move.w #$07,-(sp) ; Crawcin
       trap #1
       addq.l #2,sp
       move.b d0,(a5)+
       dbf D6,lp1
       move.l buff,D1     ; INPUT nach D1
       cmp.l #'1606',D1  ;
       bne.s loop       
       clr.l D0           ; all right!
       rts                ; return if you want!
loop:  bra.s loop    
       align.w
hndl:  dc.w $0000
fname: dc.b "A:\picture.pic",$00
       align.l
buff:  dc.b 0,0,0,0,0
       end

 