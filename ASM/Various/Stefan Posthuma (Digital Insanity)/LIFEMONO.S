* LIFE.S
*
* DIGITAL INSANITY'S OWN LITTLE VERSION
*
* THE TRUE 68000 GOSPEL...

LINES		EQU	50
COLS		EQU	80
COLS2		EQU	COLS+2
SCANLINE	EQU	80
HERTZ		EQU	70

		OPT	O+,X+

PUTS		MACRO
		MOVE.W	#9,-(SP)
		TRAP	#1
		ADDQ.L	#6,SP
		ENDM

* SUBSTRACT 1 FROM ALL THE CELLS AROUND A1
SUB_AROUND	MACRO
		SUBQ.B	#1,-1(A1)
		SUBQ.B	#1,1(A1)
		SUBQ.B	#1,-COLS2-1(A1)
		SUBQ.B	#1,-COLS2(A1)
		SUBQ.B	#1,-COLS2+1(A1)
		SUBQ.B	#1,COLS2-1(A1)
		SUBQ.B	#1,COLS2(A1)
		SUBQ.B	#1,COLS2+1(A1)
		ENDM

* ADD 1 TO ALL THE CELLS AROUND A1
ADD_AROUND	MACRO
		ADDQ.B	#1,-1(A1)
		ADDQ.B	#1,1(A1)
		ADDQ.B	#1,-COLS2-1(A1)
		ADDQ.B	#1,-COLS2(A1)
		ADDQ.B	#1,-COLS2+1(A1)
		ADDQ.B	#1,COLS2-1(A1)
		ADDQ.B	#1,COLS2(A1)
		ADDQ.B	#1,COLS2+1(A1)
		ENDM

		TEXT

* WHY NOT SUPERVISOR MODE?
		CLR.L	-(SP)
		MOVE.W	#$20,-(SP)
		TRAP	#1
		ADDQ.L	#6,SP
		MOVE.L	D0,OLDSP

* GET SCREEN ADDRESS
IT		MOVE.W	#3,-(SP)
		TRAP	#14
		ADDQ.L	#2,SP
		MOVE.L	D0,SCREEN

* DO A HELP
		CLR.L	HSCREEN
		BSR	DO_HELP

* CLEAR SCREEN
		PEA	CLS(PC)
		PUTS

* CLEAR FIELDS
		BSR	CLRFIELDS

* INSTALL VBL COUNTER
		MOVE.L	#VBL,$4DE.W

* INIT VARS
		CLR.W	CX
		MOVE.W	#2,CY
		MOVE.L	#FIELD1,USE_FIELD

* MAIN LOOP
MAIN:		BSR.S	EDIT
		SF	VBLCOUNT
		BSR	RUN
		BRA.S	MAIN

THE_END:	ADDQ.L	#4,SP		CORRECT CUZ WERE IN A SUBROUT
		CLR.L	$4DE.W		DON'T NEED NO VBL COUNTER NO MORE

		MOVE.L	OLDSP,-(SP)	BACK TO USER MODE
		MOVE.W	#$20,-(SP)
		TRAP	#1
		ADDQ.L	#6,SP

		CLR.W	-(SP)
		TRAP	#1

* THE EDITOR SIMPLE YET EFFECTIVE
EDIT:		LEA	EDITXT(PC),A0
		SF	VBLFLAG
		BSR	DO_STAT
		BSR	DRAW_CURS

EDITLOOP:	MOVE.W	#7,-(SP)
		TRAP	#1
		ADDQ.L	#2,SP
		
		MOVE.L	CURS_ADDR,DRAW_LIST

		TST.W	D0
		BEQ.S	SPECIAL

		CMP.B	#' ',D0
		BNE.S	.1
		BSR	DRAW_ONE
		BRA.S	EDITLOOP

.1		CMP.B	#'6',D0
		BNE.S	.2
		BSR	DRAW_ONE
		MOVE.W	#$4D,D0
		BRA.S	SPEC1
		
.2		CMP.B	#'4',D0
		BNE.S	.3
		BSR	DRAW_ONE
		MOVE.W	#$4B,D0
		BRA.S	SPEC1

.3		CMP.B	#'8',D0
		BNE.S	.4
		BSR	DRAW_ONE
		MOVE.W	#$48,D0
		BRA.S	SPEC1

.4		CMP.B	#'2',D0
		BNE.S	.5
		BSR	DRAW_ONE
		MOVE.W	#$50,D0
		BRA.S	SPEC1

.5		CMP.B	#'C',D0		CLEAR FIELD
		BNE.S	.6
		MOVE.L	SCREEN,A0
		LEA	SCANLINE*16(A0),A0
		MOVE.W	#(LINES*COLS*8)/4-1,D0
.X		CLR.L	(A0)+
		DBRA	D0,.X
		BSR	CLRFIELDS
		BSR	DRAW_CURS
		BRA	EDITLOOP
		
.6		CMP.B	#27,D0
		BEQ	THE_END
		BRA	EDITLOOP

SPECIAL:	SWAP	D0
SPEC1:		MOVE.W	CY,D1
		MOVE.W	CX,D2
		BSR	DRAW_CURS	ERASE

		CMP.W	#$3B,D0		F1
		BNE.S	.1
		RTS

.1		CMP.W	#$62,D0		HELP
		BNE.S	.2
		BSR	DO_HELP
		BSR	DRAW_CURS
		BRA	EDITLOOP

.2		CMP.W	#$50,D0
		BNE.S	SP1
DOWN:		CMP.W	#LINES-1,D1
		BNE.S	.1
		MOVE.W	#2,D1
		BRA.S	SPEC_END
.1		ADDQ.W	#1,D1
		BRA.S	SPEC_END

SP1:		CMP.W	#$48,D0
		BNE.S	SP2
UP:		CMP.W	#2,D1
		BNE.S	.1
		MOVE.W	#LINES-1,D1
		BRA.S	SPEC_END
.1		SUBQ.W	#1,D1
		BRA.S	SPEC_END

SP2:		CMP.W	#$4D,D0
		BNE.S	SP3
RIGHT:		CMP.W	#COLS-1,D2
		BNE.S	.1
		MOVEQ	#0,D2
		BRA.S	SPEC_END
.1		ADDQ.W	#1,D2
		BRA.S	SPEC_END

SP3:		CMP.W	#$4B,D0
		BNE.S	SPEC_END
LEFT:		SUBQ.W	#1,D2
		BPL.S	SPEC_END
		MOVE.W	#COLS-1,D2

SPEC_END:	MOVE.W	D1,CY
		MOVE.W	D2,CX
		BSR	DRAW_CURS	DRAW
		BRA	EDITLOOP

RUN:		LEA	RUNTXT(PC),A0
		BSR	DO_STAT
		SF	VBLCOUNT
		ST	VBLFLAG

RUNLOOP:	MOVE.W	#$FF,-(SP)	RAWCONIO
		MOVE.W	#6,-(SP)
		TRAP	#1
		ADDQ.L	#4,SP
		TST.L	D0
		BEQ.S	DO_IT
		CMP.W	#27,D0
		BEQ	THE_END
		SWAP	D0
		CMP.W	#$3B,D0
		BNE.S	DO_IT
		RTS

* THIS IS IT FOLKS, THE ACTUAL GENERATION ROUT
* IT GOES FROM A0 TO A1
DO_IT		ADDQ.W	#1,GENCOUNT
		MOVE.L	USE_FIELD(PC),A0
		CMP.L	#FIELD1,A0
		BNE.S	.1
		LEA	FIELD2(PC),A1
		BRA.S	.2
.1		LEA	FIELD1(PC),A1
.2		MOVE.L	A1,USE_FIELD
		LEA	COLS+3(A0),A0		ADJUST
		LEA	COLS+3(A1),A1
		MOVE.L	SCREEN(PC),A2
		LEA	SCANLINE*16(A2),A2	SKIP STATUSLINE
		LEA	DRAW_LIST(PC),A3
		MOVEQ	#2,D1			TEST VALUES
		MOVEQ	#3,D2
		MOVEQ	#COLS-1,D3		COLUMN COUNTER
		MOVEQ	#LINES-1,D4		LINE COUNTER
		MOVEQ	#0,D5

* THIS LOOP SHOULD BE FAST!!!
THE_LOOP:	TST.B	(A2)			CELL ON SCREEN?
		BEQ.S	NOCELL
CELL:		MOVE.B	(A0),D0			NR OF SURROUNDING CELLS
		CMP.B	D1,D0			TWO?
		BEQ.S	NEXTCELL		FINE
		CMP.B	D2,D0			THREE?
		BEQ.S	NEXTCELL
DIE:		SUB_AROUND			NO, DECREASE COUNTERS
		MOVE.L	A2,(A3)+		PUT IN DRAWLIST
		BRA.S	NEXTCELL
NOCELL:		MOVE.B	(A0),D0			GET NR OF SURR. CELLS
		BEQ.S	N1			SKIP 0 CELLS (FASTER)
		CMP.W	D2,D0			THREE CELLS SURROUND?
		BNE.S	NEXTCELL		NO WAY
BIRTH:		ADD_AROUND
		MOVE.L	A2,(A3)+		PUT IN DRAWLIST
NEXTCELL:	ADD.B	D0,(A1)			TRANSPORT VALUE
N1:		MOVE.B	D5,(A0)+		CLEAR USED CELL
		ADDQ.L	#1,A1
		ADDQ.L	#1,A2			INCREASE SCREEN ADDRESS
		DBRA	D3,THE_LOOP		NOT YET AT EDGE
		MOVE.W	#COLS-1,D3
		LEA	SCANLINE*7(A2),A2
		ADDQ.L	#2,A1			SKIP EDGES
		ADDQ.L	#2,A0
		DBRA	D4,THE_LOOP
* OK, ALL CELLS SCANNED, DRAW THE SUCKERS!!
		SUB.L	#DRAW_LIST,A3		GET NR. OF CELLS
		MOVE.L	A3,D6
		LSR.W	#2,D6			DIVIDE BY FOUR
		SUBQ.W	#1,D6
		BSR	DRAW_THEM		DRAW THE CELLS
		BRA	RUNLOOP			BACK TO THE BEGINNING!

		
* DRAW THE CURSOR
* USES A5/A6/D7
DRAW_CURS:	MOVE.W	CY,D7
		MULU	#SCANLINE*8,D7
		MOVE.L	SCREEN,A6
		ADD.W	D7,A6
		ADD.W	CX,A6
		MOVE.L	A6,CURS_ADDR
		LEA	CURSOR(PC),A5
VAL		SET	0
		REPT	8
		MOVE.B	(A5)+,D7
		EOR.B	D7,VAL(A6)
VAL		SET	VAL+SCANLINE
		ENDR
YEAH		RTS

DRAW_ONE:	MOVEQ	#0,D6
		BSR.S	DRAW_CURS
		BSR.S	DRAW_THEM
		BSR.S	DRAW_CURS
		MOVE.L	USE_FIELD,A1
		MOVE.W	CY,D0
		SUBQ.W	#1,D0		CY IS TWO TOO HIGH, SINCE IT
*					SKIPS STATUS LINE. SO SUBSTRACT
*					ONE TO SKIP EDGE
		MULU	#COLS+2,D0
		ADD.W	D0,A1
		ADD.W	CX,A1
		ADDQ.W	#1,A1		ADJUST SO EDGE STAYS ZERO
		MOVE.L	CURS_ADDR,A0
		TST.B	(A0)
		BEQ.S	.1		THE CURSOR HAS TOGGLED IT!
		SUB_AROUND
		RTS
.1		ADD_AROUND
		RTS
		
* DRAW THE CELLS
* THIS USES A LIST OF ADDRESSES TO TOGGLE
* IT DOES THIS BY SIMPLY USING NOT ON THE FIRST ADDRESS
* AND STUFFING THE RESULTING VALUE IN THE NEXT 7 SCANLINES
DRAW_THEM:	LEA	DRAW_LIST(PC),A0
		TST.W	D6
		BPL.S	.1
		RTS
.1		MOVE.L	(A0)+,A1
		MOVE.B	(A1),D0
		NOT.B	D0
VAL		SET	0
		REPT	8
		MOVE.B	D0,VAL(A1)
VAL		SET	VAL+SCANLINE
		ENDR
		DBRA	D6,.1
		RTS

DO_STAT:	LEA	RUNEDIT(PC),A1
.1		MOVE.B	(A0)+,D0
		BEQ.S	.2
		MOVE.B	D0,(A1)+
		BRA.S	.1
.2		PEA	STATLINE(PC)
		PUTS
		RTS

VBL:		TST.B	VBLFLAG
		BNE.S	.1
		RTS
.1		ADDQ.B	#1,VBLCOUNT
		CMP.B	#HERTZ,VBLCOUNT
		BEQ.S	DISPGEN
		RTS

* DISPLAY GENERATION PER SECOND COUNTER ON STATUS LINE
DISPGEN		SF	VBLCOUNT
		MOVEQ	#0,D0
		MOVE.W	GENCOUNT,D0
		LEA	GENSEC+2(PC),A0		
		MOVEQ	#1,D7
.3		DIVU	#10,D0
		SWAP	D0
		ADD.W	#'0',D0
		MOVE.B	D0,-(A0)
		CLR.W	D0
		SWAP	D0
		DBRA	D7,.3
		CLR.W	GENCOUNT
		PEA	STATLINE(PC)
		PUTS
		RTS

* CLEAR THE FIELDS
CLRFIELDS:	LEA	FIELD1(PC),A0
		MOVE.W	#(COLS+2)*(LINES+2),D0
		MOVEQ	#0,D1
.1		MOVE.W	D1,(A0)+
		DBRA	D0,.1
		RTS

* GIVE THE DUDE SOME INFO
DO_HELP:	TST.L	HSCREEN
		BNE.S	JUST_SWAP
		MOVE.L	#HELPSCR+256,D0
		AND.L	#$FFFFFF00,D0
		MOVE.L	D0,A6
		MOVE.L	A6,HSCREEN
		PEA	HELPTXT(PC)
		PUTS
		MOVE.L	SCREEN,A0
		MOVE.W	#7999,D0
.1		MOVE.L	(A0)+,(A6)+
		DBRA	D0,.1
		MOVE.W	#7,-(SP)
		TRAP	#1
		ADDQ.L	#2,SP
		RTS
* JUST SWAP HELPSCREEN WITH CURRENT SCREEN AND BACK AFTER A KEYPRESS
JUST_SWAP	MOVE.L	HSCREEN,A6
		MOVE.W	#-1,-(SP)
		MOVE.L	A6,-(SP)
		MOVE.L	A6,-(SP)
		MOVE.W	#5,-(SP)
		TRAP	#14
		LEA	12(SP),SP
		MOVE.W	#7,-(SP)
		TRAP	#1
		ADDQ.L	#2,SP
		MOVE.L	SCREEN,A6
		MOVE.W	#-1,-(SP)
		MOVE.L	A6,-(SP)
		MOVE.L	A6,-(SP)
		MOVE.W	#5,-(SP)
		TRAP	#14
		LEA	12(SP),SP
		RTS

		DATA

CLS:		DC.B	27,'E',27,'f',0
STATLINE:	DC.B	27,'H',27,'p Life     '
RUNEDIT:	DC.B	'              '
GENSEC:		DC.B	'                                  Digital Insanity 1991 ',27,'q',0
RUNTXT:		DC.B	'Running ...                ',0
EDITXT:		DC.B	'Edit mode          Try Help',0

HELPTXT:	DC.B	27,'E',10,13
		DC.B    ' ',27,'p                                                                              ',27,'q',10,13
		DC.B 	' ',27,'p                                   L I F E                                    ',27,'q',10,13
		DC.B    ' ',27,'p                                                                              ',27,'q',10,13
 		DC.B	' ',27,'p                A true 68000 implementation by Digital Insanity               ',27,'q',10,13
 		DC.B	' ',27,'p                                  April 1991                                  ',27,'q',10,13
		DC.B	10,13
		DC.B	' The following keys are available in the editor:',10,13
		DC.B	10,13
		DC.B	'  Arrows left, right, up and down move the cursor.',10,13
		DC.B	'  Shift+Arrows or corresponding number keys move the cursor and draw cells.',10,13
		DC.B	10,13
		DC.B	'  Spacebar  toggles cell.',10,13
		DC.B	'  C         clears the screen.',10,13
		DC.B	'  F1        starts running.',10,13
		DC.B	'  Escape    quits.',10,13
		DC.B	'  Help      displays this message.',10,13
		DC.B	10,13
		DC.B	' While running, press F1 to enter edit mode and Escape to quit.',10,13
		DC.B	' The funny changing number is the generations/second counter.',10,13
		DC.B	10,13
		DC.B	' ',27,'p        By the way, this was done solely to annoy Hubert J and EriCvO.        ',27,'q',10,13
		DC.B	' ',27,'p           This sucker does 16 generations/second with 4000 cells!!           ',27,'q',10,13
		DC.B	10,13
		DC.B	'                          PRESS A KEY TO CONTINUE!!',0

CURSOR:		DC.B	%11111111
		DC.B	%10000001
		DC.B	%10000001
		DC.B	%10011001
		DC.B	%10011001
		DC.B	%10000001
		DC.B	%10000001
		DC.B	%11111111

		BSS

VBLCOUNT	DS.B	1
VBLFLAG		DS.B	1
GENCOUNT	DS.W	1

OLDSP		DS.L	1
CX:		DS.W	1
CY:		DS.W	1

SCREEN:		DS.L	1
HSCREEN:	DS.L	1
CURS_ADDR:	DS.L	1
USE_FIELD:	DS.L	1
FIELD1:		DS.B	(COLS+2)*(LINES+2)
FIELD2:		DS.B	(COLS+2)*(LINES+2)
DRAW_LIST:	DS.L	COLS*LINES+1
HELPSCR:	DS.L	8064