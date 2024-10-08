  data

filespec:               ; actual string begins here
  dC.b 'A:F6',0
SCOREDAT:
  DC.B  '  CHICAGO   ',$00,$00,$00,$10,0
  DC.B  '------------',$00,$00,$00,$10,0
  DC.B  '   SCOTT    ',$00,$00,$00,$10,0
  DC.B  '     ED     ',$00,$00,$00,$10,0
  DC.B  '    BOB     ',$00,$00,$00,$10,0
  DC.B  '    DAVE    ',$00,$00,$00,$10,0
  DC.B  '   CRAIG    ',$00,$00,$00,$10,0
  DC.B  '   STEVE    ',$00,$00,$00,$10,0
  DC.B  '   LARRY    ',$00,$00,$00,$10,0
  DC.B  '    UKN     ',$00,$00,$00,$10,0

  bss
handle:                 ; space for file handle
  ds.w 1

  text
  move #0,-(sp)         ; create file
  move.l #filespec,-(sp)
  move #$3c,-(sp)
  trap #1
  addq.l #8,sp
  move d0,handle

  move.l #SCOREDAT,-(sp)  ; save
  move.l #17*10,-(sp)
  move handle,-(sp)
  move #$40,-(sp)
  trap #1
  add.l #12,sp

  move handle,-(sp)     ; close file
  move #$3e,-(sp)
  trap #1
  addq.l #6,sp

  clr -(sp)             ; term
  trap #1

  end
 