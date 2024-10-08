	JSR	SETSUPER
	JSR	SETSCREEN
	JSR	INITSTARS
	JSR	PRECALCSTARS
	JSR	INIT
	MOVE.W	#$777,$FF8242
	MOVE.W	#$555,$FF8244
	MOVE.W	#$333,$FF8246
	MOVE.L	#STARSDATA2,STARADD
	MOVE.L	STARADD,OLDSTARADD
DEMOLOOP:
	JSR	WAITVBL

*	REPT	4000
*	NOP
*	ENDR
*	MOVE.W	#$700,$FF8240

	MOVE.L	STARADD,OLDSTARADD
	ADD.L	#6*200,STARADD
	CMP.L	#STARSDATA2+6*200*100,STARADD
	BNE	NORESSTARADD
	MOVE.L	#STARSDATA2,STARADD
NORESSTARADD:

	MOVE.L	OLDSTARADD,A0
	MOVE.L	$44E,A1
	MOVE.W	#199,D0
CLRSTARLOOP:
	MOVE.W	(A0)+,D1
	CLR.L	(A1,D1.W)
	ADDQ.W	#4,A0
	DBF.W	D0,CLRSTARLOOP
	
	MOVE.L	STARADD,A0
	MOVE.W	#199,D0
STARSLOOP:
	MOVE.W	(A0)+,D1
	MOVE.L	(A0)+,D2
	OR.L	D2,(A1,D1.W)
	DBF.W	D0,STARSLOOP

	MOVE.W	#$000,$FF8240

	JMP	DEMOLOOP
STARADD:	DC.L	0
OLDSTARADD:	DC.L	0
*******************************
*         SUB - ROUTS         *
*******************************
SETSUPER:
	CLR.L	-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	MOVE.L	D0,SAVESUPER
	RTS
ENDSUPER:
	MOVE.L	SAVESUPER,-(SP)
	MOVE.W	#$20,-(SP)
	TRAP	#1
	ADDQ.L	#6,SP
	RTS
*******************************
SETSCREEN:
	MOVE.W	#0,-(SP)
	MOVE.L	#$78000,-(SP)
	MOVE.L	#$78000,-(SP)
	MOVE.W	#$5,-(SP)
	TRAP	#14
	ADD.L	#12,SP
	RTS
*******************************
INIT:
	MOVE.L	$70,OLDVBL
	MOVE.L	#NEWVBL,$70
	RTS
RETINIT:
	MOVE.L	OLDVBL,$70
	RTS
*******************************
WAITVBL:
	CMP.W	#1,WFNC
	BNE.S	WAITVBL
	MOVE.W	#0,WFNC
	RTS
*******************************
*        MAIN - ROUTS         * 
*******************************
INITSTARS:
	MOVE.L	#STARSDATA,A3
	MOVE.W	#199,D7			* ANTAL STJ�RNOR
INITSTARX:
	MOVE.W	#17,-(SP)
	TRAP	#14
	ADDQ.L	#2,SP
	AND.L	#$FFF,D0
	CMP.L	#0,D0
	BEQ	INITSTARX
	CMP.L	#2000,D0
	BGT	INITSTARX
	SUB.L	#1000,D0
	MULS.W	#100,D0
	MOVE.L	D0,(A3)+
INITSTARY:
	MOVE.W	#17,-(SP)
	TRAP	#14
	ADDQ.L	#2,SP
	AND.L	#$FFF,D0
	CMP.L	#0,D0
	BEQ	INITSTARY
	CMP.L	#1200,D0
	BGT	INITSTARY
	SUB.L	#600,D0
	MULS.W	#100,D0
	MOVE.L	D0,(A3)+
INITSTARZ:
	CLR.L	D0
	MOVE.W	#17,-(SP)
	TRAP	#14
	ADDQ.L	#2,SP
	AND.L	#$7F,D0
	CMP.L	#0,D0
	BEQ	INITSTARZ
	CMP.L	#100,D0
	BGT	INITSTARZ
	MULU.W	#2,D0
	MOVE.L	D0,(A3)+

	DBF.W	D7,INITSTARX
	RTS
*******************************
PRECALCSTARS:
	MOVE.L	#SQRTTAB,A1
	MOVE.L	#STARSDATA2,A2
	MOVE.L	#STARNIBBLES,A3
	MOVE.W	#99,D5
PRECALCSTARSMAINLOOP:
	MOVE.L	#STARSDATA,A0
	MOVE.W	#199,D7			* ANTAL STJ�RNOR
PRECALCSTARSLOOP:
	MOVE.L	(A0)+,D0
	MOVE.L	(A0)+,D1
	MOVE.L	(A0)+,D2
	DIVS.W	(A1,D2),D0
	DIVS.W	(A1,D2),D1
	ADD.W	#160,D0
	ADD.W	#100,D1

	SUBQ.L	#2,-4(A0)
	CMP.L	#0,-4(A0)
	BGT	NORESZ
	MOVE.L	#200,-4(A0)
NORESZ:
	CMP.W	#319,D0
	BGT	PRENOSTAR
	CMP.W	#0,D0
	BLT	PRENOSTAR
	CMP.W	#199,D1
	BGT	PRENOSTAR
	CMP.W	#0,D1
	BLT	PRENOSTAR
	
	CMP.W	#40,D2
	BGE	PRENOPLANE1
	MOVE.W	#0,D6	
	BRA.S	PREPLANEEND
PRENOPLANE1:
	CMP.W	#90,D2
	BGE	PRENOPLANE2
	MOVE.W	#1,D6	
	BRA.S	PREPLANEEND
PRENOPLANE2:
	MOVE.W	#2,D6	
PREPLANEEND:
	MULU	#160,D1
	MOVE.W	D0,D2
	AND.W	#$FFF0,D2
	ASR.W	D2
	ADD.W	D2,D1
	AND.W	#$000F,D0
	ASL.W	D0
	MOVE.W	(A3,D0.W),D0
	MOVE.W	D1,(A2)+
	CMP.W	#0,D6
	BNE	PRENOPL1
	MOVE.W	D0,(A2)+
	CLR.W	(A2)+
	BRA.S	PRESTARSCONT
PRENOPL1:
	CMP.W	#1,D6
	BNE	PRENOPL2
	CLR.W	(A2)+
	MOVE.W	D0,(A2)+
	BRA.S	PRESTARSCONT
PRENOPL2:
	MOVE.W	D0,(A2)+
	MOVE.W	D0,(A2)+
PRESTARSCONT:
	DBF.W	D7,PRECALCSTARSLOOP
	DBF.W	D5,PRECALCSTARSMAINLOOP
	RTS
* * * * * * * * * * * * * * * *
PRENOSTAR:
	CLR.W	(A2)+
	CLR.L	(A2)+
	BRA	PRESTARSCONT
*******************************
*            VBL              * 
*******************************
NEWVBL:
	MOVE.W	#1,WFNC
	RTE
*******************************
*          VARIABLES          *
*******************************
SAVESUPER:	DC.L	0
OLDVBL:		DC.L	0
WFNC:		DC.W	0
SQRTTAB:	INCBIN	A:\3DSTARS\SQUARE_R.DAT
STARNIBBLES:	DC.W	$8000,$4000,$2000,$1000,$800,$400,$200,$100,$80,$40,$20,$10,$8,$4,$2,$1
STARSDATA:	DS.L	3*200
STARSDATA2:	DS.B	6*200*100
