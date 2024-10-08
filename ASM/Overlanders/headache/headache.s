
		********************************
		*  THE ULTIMATE HEADACHE DEMO  *
		* by Humungus & Dogue de Mauve *
		*    from OVERLANDERS (1991)   *
		*       for INNER CIRCLE       *
		********************************
		
* Coding: 	Dogue de Mauve (Intro) - Humungus (Main Demo)
* Graphix:	Furyo (Font) - Ludug (Font) - Walter (Bubbles)
* Music:		Doclands (Main Theme)

* Message from Dogue de Mauve to INNER CIRCLE :

* I hope you won't laugh too much at my little ASM code. I would like 
* to pretend that it was quickly coded (it was, in fact!) and that my
* next demos will be far better but it would hardly proove true.


* And forgive all the GFA precalculations but I was a GFA coder before,
* remember, and it's hard to get rid of bad habits.

* Also sorry for the french comments...

* I and Humungus wish you a happy including of this screen (we tried
* to code it in the cleanest and clearest way possible but I guess that
* the final source is really huge and not so easy to handle) and we're
* both very proud to take part to the new INNER CIRCLE demo... Thanx!

* May the Mauve be with you all!			17/2/91


	opt	d-,o+,ow-
	
TESTVBL	EQU	0
NSPR	EQU	24-1

N_MINI	EQU	9
HT	EQU	7
N	EQU	11

TOL	EQU	1
PAUSE	EQU	0

NB_POS	EQU	92
ROT	EQU	1	test avec rotation
HH	EQU	15
N_SPR	EQU	NB_POS/4


X_SCR	EQU	37 	dimension de la grille a afficher
Y_SCR	EQU	7
NB_PTS	EQU	X_SCR*Y_SCR
N_CAR	EQU	20

NB_PNTS	equ	180*2
NB_POS2	EQU	90

	SECTION TEXT
	
Vsync	macro
	move.w	#$25,-(a7)
	trap	#14
	addq.l	#2,a7
	endm

	bsr	INIT		* Lance l'initialisation

MAIN:	
	move.l	$466,d0
VSYNC:	cmp.l	$466,d0		* Synchro VBL ($466=counter)
	beq.s	VSYNC

SWAP:	move.l	ecran2,d0
	move.l	ecran1,ecran2
	move.l	d0,ecran1
	lsr.w	#8,d0
	move.l	d0,$ffff8200.w
	
	bsr	SPRITES
	bsr	SCROLL

	cmpi.b	#57,$fffffc02	* Test ESPACE
	bne.s	MAIN	
	
FIN:

	move.l	$466,d0
VSYNC2:	cmp.l	$466,d0		* Synchro VBL ($466=counter)
	beq.s	VSYNC2

	bsr	DEMO

	move.l	$466,d0
VSYNC3:	cmp.l	$466,d0		* Synchro VBL ($466=counter)
	beq.s	VSYNC3

	move.l	oldsync,$70.w

	clr.b	$fffffa19.w	* Timer B OFF
	move.l	old120,$120.w

	move.b	inter1,$fffffa07.w
	move.b	inter2,$fffffa09.w

	move.l	oldscreen,$ffff8200.w
	move.b	oldrez,$ffff8260.w
	movem.l	oldpal,d0-d7
	movem.l	d0-d7,$ffff8240.w

	move.b	#7,$484.w		* retablit clavier
	move.b	#8,$fffffc02.w	* retablit souris
	
	move.l	#$08000000,$ff8800
	move.l	#$09000000,$ff8800
	move.l	#$0a000000,$ff8800

	move.l	old418,$418.w

	move.l	super,-(a7)	* mode superviseur
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	
	clr.w	-(a7)		* retour bureau
	trap	#1
	

* Routines VBL *


VBL:	addq.l	#1,$466.w

	movem.l	d0-d7,-(a7)
	jsr	player+8

	movem.l	logopal,d0-d7	* Palette logo
	movem.l	d0-d7,$ffff8240.w

	move.l	#CHANGE,$120.w	* Nouvelle HBL
	move.b	#33+1,$fffffa21.w	* Nb de lignes
	move.b	#8,$fffffa1b.w	* Even Count Mode ON
	movem.l	(a7)+,d0-d7

	rte

CHANGE:	
	movem.l	d0-d7,-(a7)
	movem.l	pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	clr.b	$fffffa1b.w	* Even Count Mode OFF
	movem.l	(a7)+,d0-d7
	rte	

**** PROCEDURES **** 

SPRITES:
	move.l	ecran1,a3		* a3 = ecran actuel
	addq	#4,a3
	
D_SWAP:	move.l	do2,do3
	move.l	do1,do2	
	move.l	do,do1	

D_EFF:	move.l	do3,a0
	addq	#2,a0
	
	move.w	(a0)+,d0		* Position de l'effacage
	move.l	a3,a2
	add.w	d0,a2
	moveq	#0,d0

Q	set	0
	rept	10
	move.l	d0,Q(a2)
	move.l	d0,Q+1*8(a2)
	move.l	d0,Q+2*8(a2)
	move.l	d0,Q+3*8(a2)
	move.l	d0,Q+4*8(a2)
	move.l	d0,Q+5*8(a2)
Q	set	Q+160
	endr

H_SWAP:	move.l	h2,h3
	move.l	h1,h2	
	move.l	h,h1	

H_EFF:	move.l	h3,a0
	addq	#2,a0
	
	move.w	(a0)+,d0		* Position de l'effacage
	move.l	a3,a2
	add.w	d0,a2
	moveq	#0,d0

Q	set	0
	rept	10
	move.l	d0,Q(a2)
	move.l	d0,Q+1*8(a2)
	move.l	d0,Q+2*8(a2)
	move.l	d0,Q+3*8(a2)
	move.l	d0,Q+4*8(a2)
Q	set	Q+160
	endr

S_SWAP:	move.l	s2,s3
	move.l	s1,s2	
	move.l	s,s1	

S_EFF:	move.l	s3,a0
	
	moveq	#NSPR,d7
EFF:		
	addq	#2,a0
	move.w	(a0)+,d1		* Position de l'effacage
	move.l	a3,a2
	add.w	d1,a2
	
Q	set	0
	rept	16
	move.l	d0,Q(a2)
	move.l	d0,Q+8(a2)
Q	set	Q+160
	endr
	dbra	d7,EFF

D_AFF:	move.l	do,a0
	
	move.w	(a0)+,d0		* Position dans le buffer sprite
	lea	dog,a1
	add.w	d0,a1	
	
	move.w	(a0)+,d0		* Position de l'affichage
	move.l	a3,a2
	add.w	d0,a2

Q	set	0
	rept	10
	movem.l	(a1)+,d0-d5
	move.l	d0,Q(a2)
	move.l	d1,Q+1*8(a2)
	move.l	d2,Q+2*8(a2)
	move.l	d3,Q+3*8(a2)
	move.l	d4,Q+4*8(a2)
	move.l	d5,Q+5*8(a2)
Q	set	Q+160
	endr
	
D_TEST:	cmpa.l	#fdog,a0
	bne.s	D_OK
	lea	dogtbl,a0
D_OK	move.l	a0,do

H_AFF:	move.l	h,a0
	
	move.w	(a0)+,d0		* Position dans le buffer sprite
	lea	hum,a1
	add.w	d0,a1	
	
	move.w	(a0)+,d0		* Position de l'affichage
	move.l	a3,a2
	add.w	d0,a2

Q	set	0
	rept	10
	movem.l	(a1)+,d0-d4
	or.l	d0,Q(a2)
	or.l	d1,Q+1*8(a2)
	or.l	d2,Q+2*8(a2)
	or.l	d3,Q+3*8(a2)
	or.l	d4,Q+4*8(a2)
Q	set	Q+160
	endr
	
H_TEST:	cmpa.l	#fhum,a0
	bne.s	H_OK
	lea	humtbl,a0
H_OK	move.l	a0,h


S_AFF:	move.l	s,a0
	lea	bubble,a4	

	moveq	#NSPR,d7
AFF:		
	move.w	(a0)+,d0		* Position dans le buffer sprite
	move.l	a4,a1
	add.w	d0,a1	
	
	move.w	(a0)+,d0		* Position de l'affichage
	move.l	a3,a2
	add.w	d0,a2	

	movem.l	(a1)+,d0-d6
	or.l	d0,(a2)
	or.l	d1,1*8(a2)
	or.l	d2,1*160(a2)
	or.l	d3,1*160+8(a2)
	or.l	d4,2*160(a2)
	or.l	d5,2*160+8(a2)
	or.l	d6,3*160(a2)
	movem.l	(a1)+,d0-d6
	or.l	d0,3*160+8(a2)
	or.l	d1,4*160(a2)
	or.l	d2,4*160+8(a2)
	or.l	d3,5*160(a2)
	or.l	d4,5*160+8(a2)
	or.l	d5,6*160(a2)
	or.l	d6,6*160+8(a2)
	movem.l	(a1)+,d0-d6
	or.l	d0,7*160(a2)
	or.l	d1,7*160+8(a2)
	or.l	d2,8*160(a2)
	or.l	d3,8*160+8(a2)
	or.l	d4,9*160(a2)
	or.l	d5,9*160+8(a2)
	or.l	d6,10*160(a2)
	movem.l	(a1)+,d0-d6
	or.l	d0,10*160+8(a2)
	or.l	d1,11*160(a2)
	or.l	d2,11*160+8(a2)
	or.l	d3,12*160(a2)
	or.l	d4,12*160+8(a2)
	or.l	d5,13*160(a2)
	or.l	d6,13*160+8(a2)
	movem.l	(a1)+,d0-d3
	or.l	d0,14*160(a2)
	or.l	d1,14*160+8(a2)
	or.l	d2,15*160(a2)
	or.l	d3,15*160+8(a2)

	dbra	d7,AFF

S_TEST:	cmpa.l	#fstbl,a0
	bne.s	S_OK
	lea	stbl,a0
S_OK	move.l	a0,s

	rts



* SCROLLUS *

	
SCROLL:
	move.l	scrpt,a0		* Mets scroll pointeur dans a0

SWAP_SWAP:	
	move.l	buffer1,d0	* Swapping des buffers
	move.l	buffer2,buffer1
	move.l	d0,buffer2

	move.l	bplus1,d0		* Swapping des "bonus buffer"
	move.l	bplus2,bplus1
	move.l	d0,bplus2
	
BUFFCOOL:
	addi.w	#32*4,bplus2
	cmpi.w	#32*20*4,bplus2
	bne.s	TRANCHE
	move.w	#0,bplus2

TRANCHE:	

	move.l	oldt,d1		* Recup�re ancienne tranche

	addq.b	#1,trpt		* Compteur de tranches
	cmpi.b	#4,trpt		* Si compteur = 4
	bne.s	AFFI

	* Changement de lettre
	
	moveq	#0,d1
	move.b	#0,trpt		* Tranche = 0
	move.b	(a0)+,d1		* Caract�re suivant
	tst.b	d1		* Test de Wraping
	bne.s	CONT_SCROLL
	lea	phrase,a0		* Si oui, remet au d�but
	move.b	(a0)+,d1		* Caract�re suivant
		
CONT_SCROLL:
	cmpi.b	#73,d1		* Cas sp�cial pour le "I"
	bne.s	SUITE
	move.b	#2,trpt		* Tranche = 2

SUITE:
	sub.w	#32,d1		* Valeur ASCII - 32
	ext.w	d1		* Sur un mot long...
	lsl.l	#8,d1		* d1 x 256 (Taille x Plan x Tranches)
	
	add.l	#ludug,d1		* Ajoute l'adresse de la font
	sub.l	#32*2,d1		* Soustrait une tranche puis...
	
AFFI:
	addi.l	#32*2,d1		* Ajoute une tranche
	move.l	a0,scrpt		* Reinitialise le scroll pointeur


PUT:
	move.l	buffer2,a2
	adda	bplus2,a2		* Tranche invisible
	lea	32*4*20(a2),a3	* Tranche visible
	move.l	oldt,a0		* Mets ancienne adr. tranche ds a0
	move.l	d1,a1		* Mets nouvelle adr. tranche ds a1
	move.l	d1,oldt		* Stocke tranche

Q	set	0
	rept	8*4
	move.b	(a0)+,Q(a2)	
	move.b	(a0)+,Q+2(a2)
	move.b	(a1)+,Q+1(a2)
	move.b	(a1)+,Q+3(a2)
Q	set	Q+4
	endr

Q	set	0
	rept	8*4
	move.l	(a2)+,Q(a3)	
Q	set	Q+4
	endr

SHOWIT:	
	move.l	ecran1,a1		* Adr. �cran dans a1
	lea	39*160(a1),a1	* Position � l'�cran
	move.l	qsin,a3		* Table de Sinus dans a3


	move.l	#160-1,d0		* 160 lignes � afficher
BIG:
	moveq	#0,d1
	move.l	a2,a0
	move.b	(a3)+,d1
	cmpi.b	#32*4,d1
	bne.s	ADDU
	move.l	#vide,a0
	bra.s 	TRUC
	
ADDU:	lea	(a0,d1),a0 

TRUC:
Z	set	0
Q	set	0	
	rept	20
	move.l	Q(a0),Z(a1)
Z	set	Z+8
Q	set	Q+32*4
	endr
	
	lea	160(a1),a1

	dbra	d0,BIG
	
	ifne	TESTVBL
	move.w	#$77,$ffff8240.w
	endc

	cmpa.l	#fsin,a3
	blt	suitos
	lea	sin,a3
	
SUITOS:
	move.l	a3,qsin

	rts


* Appelle l' "Ultimate Headache Screen" *

VBL2:	addq.l	#1,$466.w

	jsr	player+8

	movem.l	d0-d7/a0-a6,-(a7)
	movem.l	logopal,d0-d7	* Palette logo
	movem.l	d0-d7,$ffff8240.w

	move.l	#CHANGE,$120.w	* Nouvelle HBL
	move.b	#33+1,$fffffa21.w	* Nb de lignes
	move.b	#8,$fffffa1b.w	* Even Count Mode ON

	bsr	efface
	bsr	sprite
	
	movem.l	(a7)+,d0-d7/a0-a6
	rte

*	routines sprites

sprite:	move.w	AV,d6
	move.w	d6,d5
	mulu.w	#N,d5
	
	lea	minipos,a2
	lea	minipre,a3
	add.w	d5,a3
	add.w	d5,d5
	add.w	d5,a2
	
	move.l	ecran1,a1
	lea	spr_str,a6
	move.l	eff0,a5
	moveq.l	#0,d2
	moveq.l	#N-1,d1

aff_spr:	move.l	a1,a0
	add.w	(a2)+,a0
	move.l	a0,(a5)+
	
	move.l	(a6)+,a4
	
	move.b	(a3)+,d2
	move.l	(a4,d2.w),a4
	jsr	(a4)
	
	dbra	d1,aff_spr
	
	addq.w	#1,d6
	cmp.w	#180,d6
	bne.s	ok_sp
	moveq.w	#0,d6
ok_sp:	move.w	d6,AV
	
*	move.l	eff0,d0
*	move.l	eff2,eff0
*	move.l	d0,eff2
	
	rts
	
efface:	move.l	eff0,a0
	moveq	#0,d0
	moveq.l	#N-1,d1
zu_eff:	move.l	(a0)+,a1
X	set	0	
	rept	HT
	move.w	d0,X(a1)
	move.w	d0,X+8(a1)
X	set	X+160
	endr
	
	dbra	d1,zu_eff
	rts

DEMO:

	move.l	$466,d0
VW:	cmp.l	$466,d0		* Synchro VBL ($466=counter)
	beq.s	VW

	movem.l	vide,d0-d7
	movem.l	d0-d7,$ffff8240.w

	movem.l	plpal,d0-d7
	movem.l	d0-d7,pal

	move.l	ecran1,a0
	lea	32000(a0),a0
	move.l	ecran2,a1	
	lea	32000(a1),a1

	movem.l	vide,d0-d6/a2-a6
	
	move.l	#562,d7
CLRS:	movem.l	d0-d6/a2-a6,-(a0)
	movem.l	d0-d6/a2-a6,-(a1)
	dbra	d7,CLRS

PREPARE:	lea	pleez,a0
	move.l	ecran1,a1
	lea	160*90+4*8(a1),a1

	move.l	#21-1,d7		* 21 lignes de haut
GP_AFF:

	movem.l	(a0)+,d0-d6/a2-a5
	move.l	d0,(a1)
	move.l	d1,1*8(a1)
	move.l	d2,2*8(a1)
	move.l	d3,3*8(a1)
	move.l	d4,4*8(a1)
	move.l	d5,5*8(a1)
	move.l	d6,6*8(a1)
	move.l	a2,7*8(a1)
	move.l	a3,8*8(a1)
	move.l	a4,9*8(a1)
	move.l	a5,10*8(a1)
	lea	160(a1),a1
	dbra	d7,GP_AFF
	
	bsr	INI_SPR
	
	move.l	$466,d0
VSYNC4:	cmp.l	$466,d0		* Synchro VBL ($466=counter)
	beq.s	VSYNC4
	
	bsr	efface
	bsr	sprite

	move.l	ecran2,a0		* Stupid routine!!!
	move.l	ecran1,a1
	move.w	#160,d0
	rept	8
	move.l	(a0),(a1)	
	move.l	8(a0),8(a1)	
	move.l	16(a0),16(a1)	
	add.w	d0,a0
	add.w	d0,a1
	endr
	
	move.l	#VBL2,$70.w
		
	bsr	rotat2		* 25"
	bsr	rot_spr
	bsr	rotation
	bsr	ini_spr2
	bsr	calcul
	bsr	init_gal
	
	jsr	V_SYNC
	move.l	#VBL3,$70.w
	move.l	#raster,$120.w	* Nouvelle HBL
	
	movem.l	vide,d0-d7	
	movem.l	d0-d7,$ffff8240.w
	
	move.l	ecran1,a0
	lea	32000(a0),a0
	move.l	ecran2,a1	
	lea	32000(a1),a1

	movem.l	vide,a2-a6
	
	move.l	#666,d7
CLRS2:	movem.l	d0-d6/a2-a6,-(a0)
	movem.l	d0-d6/a2-a6,-(a1)
	dbra	d7,CLRS2
	
	movem.l	palett,d0-d7
	movem.l	d0-d7,$ffff8240.w
	
LOOP:	jsr	V_SYNC
	
	bsr	efface
	subq.w	#1,w_scr
	tst.w	w_scr
	bne.s	no_scroll
	jsr	scrollo
	move.w	#2,w_scr
no_scroll:	
	jsr	effaco
	jsr	affiche
	jsr	scro_spr
	jsr	dots
	bsr	sprite
	move.l	eff0,d0
	move.l	eff2,eff0
	move.l	d0,eff2
	
	bsr	SWAP_SCR
	cmpi.b	#$39,$fffffc02.w	test clavier
	bne.s	LOOP
	
	RTS			fin
	
*
*	THAT'S ALL FOLKS
*	
	
VBL3:	addq.l	#1,$466.w

	movem.l	a0/d0,-(a7)
	jsr	player+8

	lea	degrad+4,a0
	move.l	a0,raster+4
	move.l	-4(a0),d0		couleur ligne 0
	
	move.w	d0,$ffff8242.w
	move.l	d0,$ffff8250.w
	
	move.b	#3,$fffffa21.w	 Nb de lignes
	move.b	#8,$fffffa1b.w	 Even Count Mode ON
	
	movem.l	(a7)+,a0/d0

	rte
	
raster:	move.l	d0,-(a7)
	move.l	degrad,d0
	bpl.s	ok_rast
	
	clr.b	$fffffa1b.w
	move.l	(a7)+,d0
	rte
	
ok_rast:	addq.l	#4,raster+4
	move.w	d0,$ffff8242.w
	move.l	d0,$ffff8250.w
	move.l	(a7)+,d0
	rte	

V_SYNC:	move.l	$466.w,d0
w_vbl:	cmp.l	$466.w,d0
	beq.s	w_vbl
	rts

SWAP_SCR: move.l	ecran1,d0
	move.l	ecran2,ecran1
	move.l	d0,ecran2
	
	move.l	ecran2,d0
	lsr.w	#8,d0
	move.l	d0,$ffff8200.w	* changement d'adresse
	rts

	rts

*
*	DEMO --  HEADACHE  --
*

*
*	SCROLL + AFFICHAGE
*

scrollo:	lea	buf_scr,a0
	move.w	pt_scr,d0
	mulu.w	#Y_SCR,d0
	add.w	d0,a0
	move.l	a0,pos
	move.l	a0,a1
	move.l	a0,a2
	add.w	#NB_PTS,a1
	sub.w	#Y_SCR,a2
	
	move.l	pt_txt,a3
	move.w	blc,d0
	addq.w	#1,d0
	cmp.w	#8,d0
	bne.s	ok_car
	moveq.w	#0,d0
	addq.l	#1,a3
	cmp.l	#fin_txt,a3
	bne.s	ok_warp
	lea	texte,a3
ok_warp:	move.l	a3,pt_txt
ok_car:	move.w	d0,blc

	lea	fonte,a4
	moveq.l	#0,d1
	move.b	(a3),d1
	mulu.w	#Y_SCR*8,d1
	mulu.w	#Y_SCR,d0
	add.l	d0,a4
	add.l	d1,a4
	
	rept	Y_SCR
	move.b	(a4)+,d0
	move.b	d0,(a1)+
	move.b	d0,(a2)+
	endr
	
	addq.w	#1,pt_scr
	cmp.w	#X_SCR+1,pt_scr
	bne.s	ok_scr
	clr.w	pt_scr
ok_scr:	
	rts

affiche:	move.l	#NB_PTS-1,d7
	move.l	ecran1,a5
	lea	adr_dec,a1
	lea	adr_aff,a2
	move.w	angle,d1
	mulu.w	#NB_PTS,d1
	add.l	d1,a1
	add.l	d1,d1
	add.l	d1,a2
	
	move.l	pos,a3
	lea	adr_rout,a4
	move.l	#NB_POS,d1
	sub.w	angle,d1
	
aff_6:	cmp.w	#NB_POS/4,d1
	blt.s	aff_5
	sub.w	#NB_POS/4,d1
	bra.s	aff_6

aff_5:	lsl.w	#6,d1
	add.l	d1,a4
	move.l	a4,d5
	
	move.l	a_eff,a6
	move.w	#-1,d4
	
	moveq	#0,d1	
	moveq	#0,d6
	
aff_1:	tst.b	(a3)+
	beq.s	aff_2
	move.w	(a2)+,d6
	beq.s	aff_78
	move.l	a5,a0
	add.w	d6,a0
	move.l	d5,a4
	move.b	(a1)+,d1	
	add.l	d1,a4	
	
	move.l	(a4),a4
	jmp	(a4)
	
aff_r:	addq.w	#1,d4
	move.l	a0,(a6)+
	dbra	d7,aff_1
	
	bra.s	aff_3
	
aff_2:	addq.w	#2,a2
aff_78:	addq.w	#1,a1
	dbra	d7,aff_1
	
aff_3:	move.l	a_eff,d0
	move.l	a_eff0,a_eff
	move.l	d0,a_eff0
	
	move.w	nb_eff0,nb_eff
	move.w	d4,nb_eff0
	
	
	
	cmp.w	#-1,nb_eff
	bne.s	ok_eff
	clr.w	nb_eff
ok_eff:	rts

*	effacage des blocs

effaco:	move.w	nb_eff,d0
	move.l	a_eff,a0
	moveq	#0,d1
	
eff_1:	move.l	(a0)+,a2
Y	set	0	
	rept	HH
	move.l	d1,Y(a2)
Y	set	Y+160
	endr
	dbra	d0,eff_1
	rts

*	
*	SCROLL 16*16 + DECALAGE-AFFICHAGE-EFFACAGE
*

scro_spr:	subq.w	#1,t_scr2		scroll toutes les 4 VBL
	bne	ok_scr2
	move.w	#4,t_scr2

	lea	buf_scr2,a1	scroll dans un buffer
	move.w	pt_scr2,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a1
	move.l	a1,pos2
	move.l	a1,a2
	move.l	a1,a3
	add.l	#N_CAR*4,a2
	subq.w	#4,a3
	
	move.l	pt_txt2,a4
	addq.l	#1,a4
	cmp.l	#fin_txt2,a4
	bne.s	ok_warp2
	lea	texte2,a4
ok_warp2:	move.l	a4,pt_txt2

	moveq	#0,d0
	move.b	(a4),d0
	bne.s	ok_c
	move.l	d0,(a2)
	move.l	d0,(a3)
	bra.s	ne_c
ok_c:	mulu.w	#21*4,d0
	lea	fonte2-21*4,a4
	add.l	d0,a4
	
	move.l	a4,(a2)
	move.l	a4,(a3)
	
ne_c:	addq.w	#1,pt_scr2
	cmp.w	#N_CAR+1,pt_scr2
	bne.s	ok_scr2
	clr.w	pt_scr2

ok_scr2:	move.l	a_eff2,a0		effacage ancien sprites
	moveq	#0,d1
	move.w	nb_sp2,d0
	
eff2_1:	move.l	(a0)+,a2
Y	set	0	
	rept	21
	move.w	d1,Y(a2)
	move.w	d1,Y+8(a2)
	move.w	d1,Y+16(a2)
Y	set	Y+160
	endr
	dbra	d0,eff2_1
	
	moveq	#N_CAR-1,d7	affichage nouveau sprites
	lea	adr_dec2,a2
	lea	adr_aff2,a3
	move.w	angle,d1
	add.w	#24,d1
	cmp.w	#92,d1
	blt.s	okk
	sub.w	#92,d1
	
okk:	move.w	d1,d5
	ext.l	d5
	mulu.w	#N_CAR,d1
	add.l	d1,a2
	add.l	d1,d1
	add.l	d1,a3
	move.l	pos2,a1
	lsr.w	#2,d5
	mulu.w	#21*4*32,d5
	
	move.l	a_eff2,a6		buffer pour l'effacage
	move.w	#-1,nb_sp2	nombre de sprites a effacer
	move.l	ecran1,d6
	addq.l	#2,d6		base ecran

aff2_1:	move.l	(a1)+,d1		adresse caractere
	beq.s	no_spr0		0 = ESPACE
	
	move.l	d1,a5
	add.l	d5,a5

	move.w	(a3)+,d1		offset sprite
	beq.s	no_spr		si 0 pas de sprite
	move.l	d6,a0
	add.w	d1,a0
	
	moveq	#0,d1
	lea	tab_s,a4		table routine decalage
	move.b	(a2)+,d1		decalage 0...15
	move.l	d1,d2	
	add.l	d2,d2
	add.l	d2,d2
	add.l	d2,a4		
	
	move.l	(a4),a4		
	jmp	(a4)		saut a la routine de decalage
	
no_spr0:	addq.l	#2,a3	
no_spr:	addq.l	#1,a2
	
	dbra	d7,aff2_1
	
last_spr:	move.l	a_eff2,d0
	move.l	a_eff20,a_eff2
	move.l	d0,a_eff20
	
	move.w	nb_sp2,d0
	bpl.s	ok_nbs
	moveq	#0,d0
ok_nbs:	move.w	nb_sp20,nb_sp2
	move.w	d0,nb_sp20
	
	ifne	ROT
	move.w	angle,d0
	addq.w	#1,d0
	cmp.w	#92,d0
	bne.s	aff2_4
	moveq	#0,d0
aff2_4:	move.w	d0,angle
	endc
	
	rts
	
*	Routines decalage temps reel

sprite_0:				* decalage 0
Y	SET	0
	REPT	21	
	move.l	(a5)+,d1
	or.w	d1,Y+16(a0)
	swap	d1
	or.w	d1,Y+8(a0)
Y	SET	Y+160
	ENDR
	
	move.l	a0,(a6)+
	addq.w	#1,nb_sp2
	dbra	d7,aff2_1
	bra	last_spr
	
sprite_1:				* decalage 1
Y	SET	0
	REPT	21	
	move.l	(a5)+,d1
	add.l	d1,d1
	or.w	d1,Y+16(a0)
	swap	d1
	or.w	d1,Y+8(a0)
Y	SET	Y+160
	ENDR
	
	move.l	a0,(a6)+
	addq.w	#1,nb_sp2
	dbra	d7,aff2_1
	bra	last_spr
	
sprite_2:				* decalage 2
Y	SET	0
	REPT	21	
	move.l	(a5)+,d1
	add.l	d1,d1
	add.l	d1,d1
	or.w	d1,Y+16(a0)
	swap	d1
	or.w	d1,Y+8(a0)
Y	SET	Y+160
	ENDR
	
	move.l	a0,(a6)+
	addq.w	#1,nb_sp2
	dbra	d7,aff2_1
	bra	last_spr

sprite_3:				* decalage 3...11
Y	SET	0
	REPT	21	
	move.l	(a5)+,d2
	lsl.l	d1,d2
	or.w	d2,Y+16(a0)
	swap	d2
	or.w	d2,Y+8(a0)
Y	SET	Y+160
	ENDR
	
	move.l	a0,(a6)+
	addq.w	#1,nb_sp2
	dbra	d7,aff2_1
	bra	last_spr
	
sprite_4:	moveq	#16,d2		decalage 12...15
	sub.b	d1,d2
Y	SET	0
	REPT	21	
	move.l	(a5)+,d3
	move.l	d3,d4
	lsl.l	d1,d3
	swap	d4
	lsr.w	d2,d4
	or.w	d3,Y+16(a0)
	swap	d3
	or.w	d3,Y+8(a0)
	or.w	d4,Y(a0)
Y	SET	Y+160
	ENDR
	
	move.l	a0,(a6)+
	addq.w	#1,nb_sp2
	dbra	d7,aff2_1
	bra	last_spr

*
*	AFFICHAGE POINTS
*

dots:	move.l	ecran1,a0
	addq.l	#4,a0
	lea	adr_rout2,a1
	add.l	p_eff,a1
	move.l	(a1),a1
	lea	vide,a2
	
	moveq.b	#0,d0
	move.b	d0,d1
	move.b	d0,d2
	move.b	d0,d3
	move.b	d0,d4
	move.b	d0,d5
	move.b	d0,d6
	move.b	d0,d7
	jsr	(a1)
	
	lea	adr_rout2,a1
	add.l	p_aff,a1
	move.l	(a1),a1
	move.l	d_tbl,a2
	
	moveq	#128,d0
	moveq.b	#64,d1
	moveq.b	#32,d2
	moveq.b	#16,d3
	moveq.b	#8,d4
	moveq.b	#4,d5
	moveq.b	#2,d6
	moveq.b	#1,d7
	jsr	(a1)
	
	move.l	a2,d_tbl
	
	move.l	p_att,p_eff
	move.l	p_aff,p_att

	move.l	p_aff,a1
	
	addq.l	#4,a1
	cmp.l	max_dot,a1
	blt.s	no_warp
	move.l	#0,a1
	move.l	#excd,d_tbl
	
no_warp:	move.l	a1,p_aff
	rts


* Initialisation *

* Sprites MINI *

INI_SPR:	moveq	#N_MINI-1,d7
	lea	mini_dat,a6	donnees sprites
	lea	adr_rout0,a5	adresse des routines
	lea	r_sprite0,a4	emplacement des routines

z_mini:	
	lea	dec_spr0,a1
	moveq	#0,d1
	moveq.l	#HT-1,d0		recopie sprite 1er decalage
a_dmin:	move.w	(a6)+,(a1)+
	move.w	d1,(a1)+
	dbra	d0,a_dmin
	
	moveq.l	#14,d0		nbre de decalage
	lea	dec_spr0,a0
	move.l	a0,a1
	add.l	#HT*2*2,a1
	moveq.l	#1,d1
b_dmin:	moveq.l	#HT-1,d2
c_dmin:	move.l	(a0)+,d3
	lsr.l	d1,d3		decale 15 fois
	move.l	d3,(a1)+
	dbra	d2,c_dmin
	dbra	d0,b_dmin
	
	lea	dec_spr0,a0	adresse des decalages
	moveq.l	#15,d0		nbre de decalage
	
a_mini:	move.l	a4,(a5)+		sauve l'adresse de debut de la routine
	
	moveq.l	#2*HT-1,d1		nombre de .W a tester dans 1 sprites
	move.w	#8,add1
	move.w	#152,add2
	moveq.l	#0,d2
	lea	buf_spr0,a2	adresse pour les stat. du sprite
	sub.l	#32,a2
	move.l	#0,a3
			
b_mini:	move.w	(a0)+,d3		debut boucle stat.		
	tst.w	d3		si .W=0 on passe au suivant
	beq.s	e_mini
	move.w	d2,d4		nbre de .W deja trouves
	moveq.w	#0,d5
c_mini:	cmp.w	(a2,d5.w),d3	teste si ce .W a deja ete trouve	
	beq.s	d_mini		
	add.w	#32,d5
	dbf	d4,c_mini
	addq.w	#1,d2		nouveau .W
	move.w	d3,(a2,d5.w)	sauve ce .W
	move.w	#0,2(a2,d5.w)	initialise son compteur
	move.w	a3,4(a2,d5.w)	sauve l'emplacement de ce .W ds le sprite
	bra.s	e_mini

d_mini	move.w	2(a2,d5.w),d6	.W deja trouve
	addq.l	#1,d6		incremente son compteur
	move.w	d6,2(a2,d5.w)
	add.w	d6,d6
	add.w	d6,d5
	move.w	a3,4(a2,d5.w)	sauve son emplacement ds le sprite

e_mini:	add.w	add1,a3		emplacement suivant ds le sprite
	move.w	add1,d3
	move.w	add2,add1
	move.w	d3,add2
	dbra	d1,b_mini		boucle stat.
	
	subq.l	#1,d2		nbre de .W recenses
	lea	buf_spr0,a2	donnees stat.	
	moveq.l	#0,d1
f_mini:	move.w	2(a2,d1.w),d3	nbre d'apparitions de ce .W
	tst.w	d3
	beq.s	h_mini		si 1 seule apparition
	
	move.w	(a2,d1.w),d5
	cmp.w	#127,d5
	bhi.s	tstq_2
	or.w	#$7000,d5		moveq	A,d0
	move.w	d5,(a4)+
	bra.s	q_mini
	
tstq_2:	cmp.w	#$FF00,d5
	bhi.s	q2
	bra.s	no_quick0
q2:	and.w	#$00FF,d5
	or.w	#$7000,d5		moveq	A,d0
	move.w	d5,(a4)+
	bra.s	q_mini
	
no_quick0:move.w	#$303C,(a4)+	move.w	A,d0
	move.w	d5,(a4)+
q_mini:	move.w	d1,d4
	addq.w	#4,d4

g_mini:	move.w	(a2,d4.w),d5	offset
	tst.w	d5
	bne.s	offset0
	
	move.w	#$8150,(a4)+	or.w	d0,(a0)
	bra.s	g2_mini
	
offset0:	move.w	#$8168,(a4)+	or.w	d0,X(a0)
	move.w	d5,(a4)+
	
g2_mini:	addq.w	#2,d4
	dbra	d3,g_mini
	bra.s	i_mini

h_mini:	move.w	4(a2,d1.w),d5	offset
	tst.w	d5
	bne.s	offset20
	
	move.w	#$0050,(a4)+
	move.w	(a2,d1.w),(a4)+	or.w	A,(a0)
	bra.s	i_mini

offset20:	move.w	#$0068,(a4)+	or.w	A,X(a0)
	move.w	(a2,d1.w),(a4)+
	move.w	d5,(a4)+
i_mini:	add.w	#32,d1
	dbra	d2,f_mini
	
	move.w	#$4E75,(a4)+	rts
	
	dbra	d0,a_mini
	
	dbra	d7,z_mini
	
	
	lea	b_eff,a0
	lea	b_eff2,a1
	move.l	a0,eff0
	move.l	a1,eff2
	move.l	ecran1,d0
	move.l	#N-1,d1
j_mini:	move.l	d0,(a0)+
	move.l	d0,(a1)+
	dbra	d1,j_mini
	
	rts
		

INIT:	
	clr.l	-(a7)		* mode superviseur
	move	#$20,-(a7)
	trap	#1
	adda.l	#6,a7
	move.l	d0,super
	
	Vsync

	move.l	$70.w,oldsync
	move.b	$ffff8260.w,oldrez
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,oldpal
	clr.b	$ffff8260.w
		
	move.b	#$12,$fffffc02.w	* coupe souris
	clr.b	$484.w		* coupe clavier
	move.w	#1,$4ee.w		* coupe ALT-HELP

	move.l	$ffff8200.w,oldscreen

	move.l	#mem,d0		* adresse 1er ecran
	move.b	#0,d0
	move.l	d0,ecran1
	add.l	#32000+14*256,d0	* adresse 2eme ecran
	move.l	d0,ecran2
	
	Vsync
	
	move.l	$418.w,old418
	move.l	#16,$418.w

	move.b	$fffffa07.w,inter1	* sauve interruptions MFP 0-7
	move.b	$fffffa09.w,inter2	* sauve interruptions MFP 8-15
	clr.b	$fffffa09.w	* Coupe MFP 8-15

	clr.b	$fffffa19.w	* Timer B OFF
	move.b	#1,$fffffa07.w	* Timer B Enable
	
	move.b	#1,$fffffa13.w	* Timer B masqu�
	bclr.b	#3,$fffffa17.w	* Automatic End of Interrupt

	move.l	$120.w,old120	* Sauve HBL
	move.l	#CHANGE,$120.w	* Nouvelle HBL

	move.l	#pic,a0	
	move.l	ecran1,a1
	move.l	ecran2,a2	

	move.l	#31*40-1,d7
LOGO:	movem.l	(a0)+,d0
	move.l	d0,(a1)+
	move.l	d0,(a2)+
	dbra	d7,LOGO
	
	move.l	#169*40-1,d7
CLEAR:	clr.l	(a1)+
	clr.l	(a2)+
	dbra	d7,CLEAR

	move.l	#buff1,buffer1	* Stocke addresse buffers 
	move.l	#buff2,buffer2	* dans variables buffers

	move.l	buffer1,a0
	move.l	buffer2,a1
	move.l	#(32*160*2/4)-1,d7
EFFBUFF:	clr.l	(a0)+
	clr.l	(a1)+
	dbra	d7,EFFBUFF

	lea	vide,a0
	move.l	#(20*32*4/4)-1,d7
EFFVID:	clr.l	(a0)+
	dbra	d7,EFFVID

	jsr	player		* Appelle la musique

	move.l	#VBL,$70.w	* Installe nouvelle VBL

	move.l	#dogtbl,do
	move.l	do,do1
	move.l	do,do2
	move.l	do,do3

	move.l	#humtbl,h
	move.l	h,h1
	move.l	h,h2
	move.l	h,h3

	move.l	#stbl,s
	move.l	s,s1
	move.l	s,s2
	move.l	s,s3

	clr.l	bplus1
	clr.l	bplus2

	move.l	#phrase,scrpt	* scrpt pointe sur le texte 
	move.l	#ludug,oldt	* oldt pointe sur vide
	move.b	#3,trpt		* tranche = 3

	rts
	
*
*	INITIALISATIONS   -- HEADACHE --
*

*
*	GENERATION DES SPRITES/BLOCS POUR LE GROS SCROLL
*

ini_spr2:	moveq	#N_SPR-1,d7
	lea	blk_dat,a6	donnees sprites
	lea	adr_rout,a5	adresse des routines
	lea	r_sprite,a4	emplacement des routines
	move.l	#buf_reg,reg

z_spr:	
	lea	dec_spr,a1
	moveq	#0,d1
	moveq.l	#HH-1,d0		recopie sprite 1er decalage
a_dec:	move.w	(a6)+,(a1)+
	move.w	d1,(a1)+
	dbra	d0,a_dec
	
	moveq.l	#14,d0		nbre de decalage
	lea	dec_spr,a0
	move.l	a0,a1
	add.l	#HH*2*2,a1
	moveq.l	#1,d1
b_dec:	moveq.l	#HH-1,d2
c_dec:	move.l	(a0)+,d3
	lsr.l	d1,d3		decale 15 fois
	move.l	d3,(a1)+
	dbra	d2,c_dec
	dbra	d0,b_dec
	
	lea	dec_spr,a0	adresse des decalages
	moveq.l	#15,d0		nbre de decalage
	
a_spr:	move.l	a4,(a5)+		sauve l'adresse de debut de la routine
	
	moveq.l	#HH-1,d1		nombre de .L a tester dans 1 sprites
	moveq.l	#0,d2
	lea	buf_spr,a2	adresse pour les stat. du sprite
	sub.l	#34,a2
	move.l	#0,a3
			
b_spr:	move.l	(a0)+,d3		debut boucle stat.		
	tst.l	d3		si .L=0 on passe au suivant
	beq.s	e_spr
	move.w	d2,d4		nbre de .L deja trouves
	moveq.w	#0,d5
c_spr:	cmp.l	(a2,d5.w),d3	teste si ce .L a deja ete trouve	
	beq.s	d_spr		
	add.w	#34,d5
	dbf	d4,c_spr
	addq.w	#1,d2		nouveau .L
	move.l	d3,(a2,d5.w)	sauve ce .L
	move.w	#0,4(a2,d5.w)	initialise son compteur
	move.w	a3,6(a2,d5.w)	sauve l'emplacement de ce .L ds le sprite
	bra.s	e_spr

d_spr	move.w	4(a2,d5.w),d6	.L deja trouve
	addq.l	#1,d6		incremente son compteur
	move.w	d6,4(a2,d5.w)
	add.w	d6,d6
	add.w	d6,d5
	move.w	a3,6(a2,d5.w)	sauve son emplacement ds le sprite

e_spr:	add.w	#160,a3		emplacement suivant ds le sprite
	dbra	d1,b_spr		boucle stat.
	
	subq.l	#1,d2		nbre de .W recenses
	lea	buf_spr,a2	donnees stat.	
	moveq.l	#0,d1
f_spr:	move.w	4(a2,d1.w),d3	nbre d'apparitions de ce .W
	tst.w	d3
	beq.s	h_spr		si 1 seule apparition
	
*	addq.w	#1,nb_reg
	move.l	(a2,d1.w),d5
	moveq	#0,d6
	tst.w	d5
	beq	word_1
	moveq	#2,d6
	swap	d5
	tst.w	d5
	beq	word_1
	swap	d5
	
	cmp.l	#$FFFFFF00,d5
	bhi.s	qq2
	bra.s	no_quick
qq2:	and.w	#$00FF,d5
	or.w	#$7000,d5		moveq	A,d0
	move.w	d5,(a4)+
	bra.s	q_spr
	
no_quick:	move.w	#$203C,(a4)+	move.l	A,d0
	move.l	d5,(a4)+
q_spr:	move.w	d1,d4
	addq.w	#6,d4

g_spr:	move.w	(a2,d4.w),d5	offset
	tst.w	d5
	bne.s	offset
	
	move.w	#$8190,(a4)+	or.l	d0,(a0)
	bra.s	g2_spr
	
offset:	move.w	#$81A8,(a4)+	or.l	d0,X(a0)
	move.w	d5,(a4)+
	
g2_spr:	addq.w	#2,d4
	dbra	d3,g_spr
	bra.s	i_spr

h_spr:	move.l	(a2,d1.w),d5
	
	moveq	#0,d6
	tst.w	d5
	beq	word_2
	moveq	#2,d6
	swap	d5
	tst.w	d5
	beq	word_2
	swap	d5
	
	move.w	6(a2,d1.w),d6	offset
	tst.w	d6
	bne.s	offset2
	
	move.w	#$0090,(a4)+
	move.l	d5,(a4)+		or.l	A,(a0)
	bra.s	i_spr

offset2:	move.w	#$00A8,(a4)+	or.l	A,X(a0)
	move.l	d5,(a4)+
	move.w	d6,(a4)+
i_spr:	add.w	#34,d1
	dbra	d2,f_spr
	
	move.w	#$4EF9,(a4)+
	move.l	#aff_r,(a4)+
*	move.w	#$4E75,(a4)+	rts
	
	dbra	d0,a_spr
	
*	move.l	reg,a1
*	move.w	nb_reg,(a1)
*	addq.l	#2,reg
	clr.w	nb_reg
	
	dbra	d7,z_spr
	
	rts
	
*	cas d'un .W dans un registre

word_1:	swap	d5
	cmp.w	#127,d5
	bhi.s	w2
	or.w	#$7000,d5		moveq	A,d0
	move.w	d5,(a4)+
	bra.s	w5
	
w2:	cmp.w	#$FF00,d5
	bhi.s	w3
	bra.s	w4
w3:	and.w	#$00FF,d5
	or.w	#$7000,d5		moveq	A,d0
	move.w	d5,(a4)+
	bra.s	w5
	
w4:	move.w	#$303C,(a4)+	move.w	A,d0
	move.w	d5,(a4)+
w5:	move.w	d1,d4
	addq.w	#6,d4

w6:	move.w	(a2,d4.w),d5	offset
	add.w	d6,d5
	tst.w	d5
	bne.s	w7
	
	move.w	#$8150,(a4)+	or.w	d0,(a0)
	bra.s	w8
	
w7:	move.w	#$8168,(a4)+	or.w	d0,X(a0)
	move.w	d5,(a4)+
	
w8:	addq.w	#2,d4
	dbra	d3,w6
	
	bra	i_spr

*	cas d'un .W unique	

word_2:	swap	d5
	add.w	6(a2,d1.w),d6	offset
	tst.w	d6
	bne.s	w10
	
	move.w	#$0050,(a4)+
	move.w	d5,(a4)+		or.w	A,(a0)
	bra	i_spr

w10:	move.w	#$0068,(a4)+	or.w	A,X(a0)
	move.w	d5,(a4)+
	move.w	d6,(a4)+
		
	bra	i_spr
		
*
*	CALCUL DE LA ROTATION POUR LE GROS SCROLL
*

rotation:	lea	coord,a0
	lea	coord2,a1
	move.w	#-(X_SCR-1)*5,d0
	move.w	#-(Y_SCR-1)*5,d1
	move.w	#X_SCR-1,d2
gr1:	move.w	#Y_SCR-1,d3
	move.w	d1,d4
gr2:	move.w	d0,(a0)+
	move.w	d4,(a0)+
	
	move.w	d0,d5
	subq.w	#5,d5
	move.w	d5,(a1)+
	move.w	d4,(a1)+
	
	add.w	#10,d4
	dbra	d3,gr2
	add.w	#10,d0
	dbra	d2,gr1

	move.w	#0,a
	lea	adr_aff,a5	buffer adresse bloc
	lea	adr_dec,a6	buffer decalage bloc
	lea	tab_x,a3
	lea	tab_y,a4

rot_1:	lea	sin2,a0
	move.w	a,d7
	move.l	(a0,d7),d0	sin(a),cos(a)
	move.w	d0,d1
	swap	d0
	ext.l	d0
	ext.l	d1
	
	move.l	#(NB_PTS-1),d7	calcul de la rotation
	tst.w	tcd
	bne.s	cd1
	lea	coord,a0		pour chaque point
	bra.s	cd2
cd1:	lea	coord2,a0
cd2:	not.w	tcd
	
rot_2:	move.w	(a0)+,d3
	move.w	(a0)+,d2
	move.w	d2,d4
	move.w	d3,d5
	
	muls.w	d0,d2
	muls.w	d1,d3
	add.l	d3,d2
	add.l	d2,d2
	swap	d2
	add.w	#160,d2		X'=X*cos(a)+Y*sin(a)
	
	neg.w	d1
	muls.w	d1,d4
	neg.w	d1
	muls.w	d0,d5
	add.l	d5,d4
	add.l	d4,d4
	swap	d4
	add.w	#100,d4		Y'=-X*sin(a)+Y*cos(a)
	
	clr.w	htst
	cmp.w	#200,d4
	blt.s	ok_h1
	move.w	#1,htst
ok_h1:	cmp.w	#1-HH,d4
	bge.s	ok_h2
	move.w	#1,htst
ok_h2:	cmp.w	#320-15,d2
	blt.s	ok_h3
*	not.w	$ffff8240.w
	move.w	#1,htst
ok_h3:	cmp.w	#0,d2
	bge.s	ok_h4
*	not.w	$ffff8240.w
	move.w	#1,htst
ok_h4:	
	tst.w	htst
	ifne	TOL
	beq.s	ok_h5
	endc
	
	move.b	#0,(a6)+
	move.w	#0,(a5)+
	
	bra.s	ok_h6
	
	
ok_h5:	add.w	d2,d2
	add.w	d2,d2
	move.w	(a3,d2.w),d3	decalage adresse en X
	move.b	3(a3,d2.w),d2	decalage bloc
	add.b	d2,d2
	add.b	d2,d2
	move.b	d2,(a6)+		decalage bloc

	add.w	d4,d4
	move.w	(a4,d4.w),d4	hauteur en Y
	add.w	d4,d3		position a l'ecran dans D5
	addq.w	#6,d3		"BIG RUSE"
	move.w	d3,(a5)+		et dans le buffer	
	
ok_h6:	dbra	d7,rot_2
	
	add.w	#4,a
	cmp.w	#92*4,a
	blt	rot_1
	
	rts
	
*	
*	CALCUL DE LA ROTATION DES FONTES
*

rot_spr:	lea	sin2,a2		table sinus
	move.w	#1,angle
	lea	fonte2,a0		fonte
	
rs_0:	lea	buf_tst,a1	routine test
	
crea_tst:	move.w	#23,d0
	sub.w	angle,d0
	lsl.w	#4,d0
	move.w	(a2,d0.w),d6	sin(A)
	move.w	2(a2,d0.w),d7	cos(A)
	neg.w	d6		sin(-A)
	ext.l	d6
	ext.l	d7

	moveq	#0,d1		Y0
rs_1:	moveq	#11,d0		X0

rs_2:	move.w	d0,d3		X
	sub.w	#22,d3		X-22	
	move.w	d1,d4		Y
	sub.w	#10,d4		Y-10
	
	muls.w	d7,d3
	muls.w	d6,d4
	add.l	d4,d3
	add.l	d3,d3
	swap	d3
	add.w	#22,d3		X'=(X-22)*cos(-A)+(Y-10)*sin(-A)+22
	
	
	move.w	d0,d2		X
	sub.w	#22,d2		X-22	
	move.w	d1,d4		Y
	sub.w	#10,d4		Y-10
	neg.w	d6
	muls.w	d6,d2
	neg.w	d6
	muls.w	d7,d4
	add.l	d2,d4
	add.l	d4,d4
	swap	d4
	add.w	#10,d4		Y'=(X-22)*cos(-A)+(Y-10)*sin(-A)+10
	
	cmp.w	#32,d3
	bge	rs_3
	cmp.w	#13,d3
	blt.s	rs_3
	
	moveq	#0,d5		A'=0
	sub.w	#8,d3
	ble.s	rs_7
	addq.w	#1,d5		A'=1
	sub.w	#8,d3
	ble.s	rs_7
	addq.w	#1,d5		A'=2
	sub.w	#8,d3
	ble.s	rs_7
	addq.w	#1,d5		A'=3
	sub.w	#8,d3
	
rs_7:	neg.w	d3		D'=8-X'[8] bit 0...7
	
	move.w	d0,d2		X
	sub.w	#22,d2		X-22	
	move.w	d1,d4		Y
	sub.w	#10,d4		Y-10
	neg.w	d6
	muls.w	d6,d2
	neg.w	d6
	muls.w	d7,d4
	add.l	d2,d4
	add.l	d4,d4
	swap	d4
	add.w	#10,d4		Y'=(X-22)*cos(-A)+(Y-10)*sin(-A)+10
	
	ble.s	rs_3
	cmp.w	#21,d4
	bge.s	rs_3
	
	add.w	d4,d4
	add.w	d4,d4		
	add.w	d5,d4		H'=Y'*4+A'
	
	move.w	#$082E,(a1)+	btst #D',H'(a6)
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	
	move.w	#$6706,(a1)+	beq.s (pc+6)
	
	move.w	d0,d3
	moveq	#0,d5		A=0
	sub.w	#8,d3
	ble.s	rs_8
	addq.w	#1,d5		A=1
	sub.w	#8,d3
	ble.s	rs_8
	addq.w	#1,d5		A=2
	sub.w	#8,d3
	ble.s	rs_8
	addq.w	#1,d5		A=3
	sub.w	#8,d3
	
rs_8:	neg.w	d3		D=8-X[8] bit 0...7
	
	move.w	d1,d4
	add.w	d4,d4
	add.w	d4,d4		
	add.w	d5,d4		H=Y*4+A		
	
	move.w	#$08ED,(a1)+	bset #D,H(a6)
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	
rs_3:	addq.w	#1,d0		X=X+1
	cmp.w	#32,d0
	blt	rs_2
	
	addq.w	#1,d1		Y=Y+1
	cmp.w	#21,d1
	blt	rs_1
	
	move.w	#$4E75,(a1)+	rts
	
	move.l	a0,a5
	move.w	angle,d0
	mulu.w	#32*21*4,d0
	add.l	d0,a5		image
	
	move.l	a0,a6		source
	moveq	#31,d0		30 caracteres
	moveq	#21*4,d1		84=taille mem d'1 caractere

	moveq	#0,d2
rs_9:	
Y	set	0
	rept	21
	move.l	d2,Y(a5)
Y	set	Y+4
	endr
	
	jsr	buf_tst
	add.l	d1,a5
	add.l	d1,a6
	dbra	d0,rs_9
	
	addq.w	#1,angle
	cmp.w	#23,angle
	blt	rs_0
	
	rts
	
*
*	CALCUL DES POSITIONS DES SPRITES POUR LE SCROLL 16*16
*

rotat2:	lea	coord,a0
	moveq	#3,d7
	move.w	#-160+27-16,d6
	moveq	#16,d2
	
rt2_00:	moveq	#N_CAR-1,d0
	move.w	d6,d1
rt2_0:	move.w	d1,(a0)+
	add.w	d2,d1
	dbra	d0,rt2_0
	subq.w	#4,d6
	dbra	d7,rt2_00
	
	move.w	#0,angle
	lea	adr_aff2,a5	buffer adresse bloc
	lea	adr_dec2,a6	buffer decalage bloc
	lea	tab_x,a3
	lea	tab_y,a4
	lea	coord,a1
	lea	sin2,a0
	lea	osci,a2

rot2_1:	move.w	angle,d7
	move.l	(a0,d7.w),d0	sin(a),cos(a)
	move.w	d0,d1
	swap	d0
	ext.l	d0
	ext.l	d1
	
	move.w	(a2),d3
	muls.w	d0,d3
	add.l	d3,d3
	swap	d3
	move.w	d3,add_x
	
	move.w	(a2)+,d3
	neg.l	d1
	muls.w	d1,d3
	add.l	d3,d3
	swap	d3
	move.w	d3,add_y
	neg.l	d1
	
	moveq	#N_CAR-1,d7	calcul de la rotation
	
rot2_2:	move.w	(a1)+,d3		abscisse
	move.w	d3,d5
	
	muls.w	d1,d3
	add.l	d3,d3
	swap	d3
	add.w	#160-22,d3	X'=X*cos(a)
	add.w	add_x,d3
	
	muls.w	d0,d5
	add.l	d5,d5
	swap	d5
	add.w	#89,d5		Y'=-X*sin(a)
	add.w	add_y,d5
	
	clr.w	add
	
	cmp.w	#200,d5		Y>=200
	blt.s	clip_1
	bra	out
	
clip_1:	cmp.w	#-20,d5		Y<-20
	bge.s	clip_2
	bra	out
	
clip_2:	cmp.w	#320-32,d3	X>320-32
	ble.s	clip_3
	bra	out
	cmp.w	#320-16,d3
	bge.s	right_1
	move.w	#3,add		2 W a afficher a droite
	bra.s	ok_clip
right_1:	cmp.w	#320,d3
	bge	out
	move.w	#1,add		1 W a afficher a droite
	bra.s	ok_clip

clip_3:	tst.w	d3		X<0
	bge.s	ok_clip
	bra	out
	cmp.w	#-16,d3
	blt.s	left_1
	move.w	#5,add		2 W a afficher a gauche
	add.w	#16,d3
	bra.s	ok_clip
left_1:	cmp.w	#-21,d3
	ble.s	out
	move.w	#7,add
	add.w	#32,d3
	bra.s	ok_clip	
	
out:	move.b	#0,(a6)+
	move.w	#0,(a5)+	
	
	bra.s	next
	
ok_clip:	add.w	d3,d3
	add.w	d3,d3
	move.w	(a3,d3.w),d2	decalage adresse en X
	add.w	add,d2		cas particuliers
	move.b	#15,d4
	sub.b	3(a3,d3.w),d4	decalage bloc
	move.b	d4,(a6)+		decalage bloc

	add.w	d5,d5
	move.w	(a4,d5.w),d5	hauteur en Y
	add.w	d5,d2		position a l'ecran dans D5
	move.w	d2,(a5)+		et dans le buffer	
	
next:	dbra	d7,rot2_2

	cmp.l	#coord+N_CAR*2*4,a1
	bne.s	ok2_h7
	lea	coord,a1
	
ok2_h7:	add.w	#4,angle
	cmp.w	#92*4,angle
	blt	rot2_1
	
	clr.w	angle
	move.w	#2,t_scr2

	rts
	
*
*	CALCUL POINTS
*

calcul:	movem.l	vide,d0-d7
	lea	rout,a3		adresse routine points
	move.w	#NB_POS2-1,d7	nombre de positions
	lea	adr_rout2,a4	liste des routines
	lea	mvt,a1		mouvement
	lea	zeze-2,a2		buffer pour le tri
	lea	excd,a6		points cote a cote
	
av_dot:	move.l	a3,(a4)+		table des routines
	move.l	#nb_pnts-1,d0	nbre de points
	move.l	(a1)+,d6
	swap	d6
	neg.w	d6
	swap	d6
	lea	xyz,a0	
	move.w	#-1,2(a2)		
	
b_dot:	move.w	(a0)+,d1		x
	move.w	(a0)+,d2		y
	move.w	(a0),d3		profondeur
	
	add.w	d6,d2
	swap	d6
	add.w	d6,d1
	swap	d6
	ext.l	d1
	ext.l	d2
		
	subq.w	#2,d3		on avance
	bgt.s	ok_prof
	add.w	#180-1,d3		repart au fond	

ok_prof:	move.w	d3,(a0)+

	divs	d3,d1		effet de profondeur
	divs	d3,d2
	add.w	#160,d1
	blt.s	no_dot
	add.w	#100,d2
	blt.s	no_dot
		
	cmp.w	#320,d1		clipping
	bge.s	no_dot
	cmp.w	#200,d2
	bge.s	no_dot
	
	ext.l	d1
	ext.l	d2
	
	move.w	d1,d4
	and.w	#%1111111111110000,d4
	lsr.w	#1,d4
	and.w	#15,d1	

	cmpi.w	#8,d1
	blt.s	decalage
	
	subq.w	#8,d1
	addq.w	#1,d4

decalage:	moveq	#15,d3
	sub.b	d1,d3
	
	mulu.w	#160,d2
	add.w	d4,d2		d2=offset
	move.l	a2,a5		buffer test
t_rec:	addq.l	#2,a5
	move.w	(a5)+,d4
	bmi.s	no_rec
	cmp.w	d2,d4
	bne.s	t_rec
	bset.b	d3,(a5)		offset deja trouve
	bra.s	fin_rec
	
no_rec:	move.w	d2,-2(a5)		nouvel offset
	clr.w	(a5)
	bset.b	d3,(a5)
	move.w	#-1,2(a5)
fin_rec:	
no_dot:	dbra	d0,b_dot

	lea	zeze,a5
	moveq	#0,d2
	
crea_dot:	move.w	(a5)+,d1		offset
	bmi	fin_cr_d
	move.b	(a5),d2		valeur
	addq.l	#2,a5
	
	cmp.b	#%00000001,d2
	bne.s	cr_d1
	move.w	#$1147,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d1:	cmp.b	#%00000010,d2
	bne.s	cr_d2
	move.w	#$1146,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d2:	cmp.b	#%00000100,d2
	bne.s	cr_d3
	move.w	#$1145,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d3:	cmp.b	#%00001000,d2
	bne.s	cr_d4
	move.w	#$1144,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d4:	cmp.b	#%00010000,d2
	bne.s	cr_d5
	move.w	#$1143,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d5:	cmp.b	#%00100000,d2
	bne.s	cr_d6
	move.w	#$1142,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d6:	cmp.b	#%01000000,d2
	bne.s	cr_d7
	move.w	#$1141,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d7:	cmp.b	#%10000000,d2
	bne.s	cr_d8
	move.w	#$1140,(a3)+
	move.w	d1,(a3)+
	bra.s	crea_dot
cr_d8:	move.w	#$115A,(a3)+
	move.w	d1,(a3)+
	move.b	d2,(a6)+
	bra	crea_dot
	
fin_cr_d:	move.w	#$4e75,(a3)+	rts
	
	dbra	d7,av_dot
	
	move.l	#NB_POS2*4,max_dot
	move.l	#excd,d_tbl
	rts	
	
*
*	INITIALISATIONS VARIABLES
*

init_gal:	lea	font,a0
	lea	fonte,a1
	moveq.w	#46,d0
font1:	moveq.w	#7,d1
font2:	move.b	(a0)+,d2
	
	moveq.b	#6,d3
font3:	moveq.b	#0,d4
	btst	d3,d2
	beq.s	no_bit
	moveq.b	#1,d4
no_bit:	move.b	d4,(a1)+
	subq.b	#1,d3
	tst.b	d3
	bge.s	font3
	
	dbra	d1,font2
	dbra	d0,font1

	move.w	#2,w_scr
	move.l	#texte,pt_txt
	move.l	#buf_scr,pos
	move.l	#coord,a_eff
	move.l	#coord+NB_PTS*4,a_eff0
	
	move.l	#NB_PTS-1,d0
	move.l	ecran1,a0
	move.l	a_eff,a1
	move.l	a_eff0,a2
ii:	move.l	a0,(a1)+
	move.l	a0,(a2)+
	dbra	d0,ii
	
	move.l	ecran1,a0
	lea	coord2,a1
	moveq	#N_CAR*2,d0
jl:	move.l	a0,(a1)+
	dbra	d0,jl
	
	moveq	#0,d1
	lea	buf_scr2-4,a1
	moveq	#2*N_CAR+1,d0
jk:	move.l	d1,(a1)+
	dbra	d0,jk
	
	move.l	#buf_scr2,pos2
	clr.w	nb_sp2
	clr.w	nb_sp20

	rts	
	
	
	SECTION	DATA

pal:	incbin	\headache.\LINK.O\SCROLLUS.PAL
logopal:	incbin	\headache.\LINK.O\LOGO.PAL
player:	incbin	\headache.\LINK.O\SCROLLUS.MUS

fonte2:	incbin	\headache.\LINK.O\FONTE2.DAT

phrase:	incbin	\headache.\LINK.O\SCROLLUS.TXT
nul:	dc.b	0
	even

plpal:	incbin	\headache.\LINK.O\PLEEZ.PAL
pic:	incbin	\headache.\LINK.O\OVERLOGO
ludug:	incbin	\headache.\LINK.O\LUDUG.FNT
sin:	incbin	\headache.\LINK.O\SCROLLUS.TBL
fsin:
qsin:	dc.l	sin
pleez:	incbin	\headache.\LINK.O\PLEEZ.DAT
dog:	incbin	\headache.\LINK.O\DOGUE.SPR
hum:	incbin	\headache.\LINK.O\HUMUNGUS.SPR
bubble:	incbin	\headache.\LINK.O\BUBBLE.SPR

dogtbl:	incbin	\headache.\LINK.O\DOGUE.TBL
fdog:
humtbl:	incbin	\headache.\LINK.O\HUMUNGUS.TBL
fhum:
stbl:	incbin	\headache.\LINK.O\SPRITES.TBL
fstbl:

mini_dat:	incbin	\headache.\LINK.O\MINISPR.DAT



minipos:	incbin	\headache.\LINK.O\MINIPOS.DAT
minipre:	incbin	\headache.\LINK.O\MINIPRE.DAT
	even
spr_str:	dc.l	adr_rout0+16*4*0
	dc.l	adr_rout0+16*4*1
	dc.l	adr_rout0+16*4*2
	dc.l	adr_rout0+16*4*3
	dc.l	adr_rout0+16*4*4
	dc.l	adr_rout0+16*4*5
	dc.l	adr_rout0+16*4*6
	dc.l	adr_rout0+16*4*7
	dc.l	adr_rout0+16*4*2
	dc.l	adr_rout0+16*4*3
	dc.l	adr_rout0+16*4*8
	
degrad:	incbin	\headache.\LINK.O\RASTERS2.PAL
	dc.l	-1
font:	incbin	\headache.\LINK.O\FONTE.DAT
blk_dat:	incbin	\headache.\LINK.O\BLK3.DAT
	
tab_x:	incbin	\headache.\LINK.O\TAB_X3.DAT

Y	set	-22
	rept	21
	dc.w	Y*160
Y	set	Y+1
	endr	
tab_y:	
Y	set	0
	rept	200
	dc.w	Y*160
Y	set	Y+1
	endr	

sin2:	incbin	\headache.\LINK.O\TAB_SIN2.DAT
	even

palett:	dc.w	0,$777,$507,$507,$656,$656,$507,$507,$777,$777,$507,$507,$656,$777,$507,$507

texte:	incbin	\headache.\LINK.O\TEXTE.DAT
fin_txt:

tab_s:	dc.l	sprite_0
	dc.l	sprite_1
	dc.l	sprite_2
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_3
	dc.l	sprite_4
	dc.l	sprite_4
	dc.l	sprite_4
	dc.l	sprite_4
	dc.l	sprite_4


osci:	incbin	\headache.\LINK.O\OSCI.DAT
		
pt_txt2:	dc.l	texte2
texte2:	incbin	\headache.\LINK.O\TEXTE2.DAT		
fin_txt2:
a_eff2:	dc.l	coord2	
a_eff20:	dc.l	coord2+N_CAR*4

xyz:	incbin	\headache.\LINK.O\XYZ.DAT		fichiers points
mvt:	incbin	\headache.\LINK.O\MVT.DAT


	
	SECTION	BSS

	
	ds.b	15*256
mem:	ds.b	64000		memoire ecran
	ds.b	2*14*256
	even
	
* Variables  Scrollus*

buffer1:	ds.l	1
buffer2:	ds.l	1

bplus1:	ds.w	1
bplus2:	ds.w	1

scrpt:	ds.l	1
oldt:	ds.l	1

do:	ds.l	1
do1:	ds.l	1
do2:	ds.l	1
do3:	ds.l	1

h:	ds.l	1
h1:	ds.l	1
h2:	ds.l	1
h3:	ds.l	1

s:	ds.l	1
s1:	ds.l	1
s2:	ds.l	1
s3:	ds.l	1

trpt:	ds.b	1		* Compteur de tranches
	even

* Memoire & adresses *

ecran1:	ds.l	1
ecran2:	ds.l	1

buff1:	ds.b	32*160*2		* Buffers Double-largeur
buff2:	ds.b	32*160*2
	
vide:	ds.b	20*4*32		* Ligne vide

AV:	ds.w	1		* BSS MINISPRITES
add1:	ds.w	1
add2:	ds.w	1

eff0:	ds.l	1
eff2:	ds.l	1
b_eff:	ds.l	N
b_eff2:	ds.l	N

adr_rout0:ds.l	16*N_MINI

r_sprite0:ds.b	N_MINI*(HT*12+2)*16
	ds.b	32
buf_spr0:	ds.b	32*HT
dec_spr0:	ds.w	16*HT*2

*	BSS  --  HEADACHE  --

coord:	ds.w	4*NB_PTS
coord2:	ds.w	4*NB_PTS
adr_aff:	ds.w	NB_PTS*NB_POS	adresses affichage a l'ecran
adr_dec:	ds.b	NB_PTS*NB_POS	decalage pour chaque bloc
	even			=38640
	
aa:	ds.l	1
adr_blk:	ds.l	1
angle:	ds.w	1
nb_eff	ds.w	1
nb_eff0	ds.w	1
a_eff	ds.l	1
a_eff0:	ds.l	1
a:	ds.w	1	
tcd:	ds.w	1
htst:	ds.w	1
hcpt:	ds.l	1
adr_rast:	ds.l	1
	even
	
reg:	ds.l	1
nb_reg:	ds.w	1
buf_reg:	ds.w	N_SPR
	
fonte:	ds.w	Y_SCR*8*47

	ds.b	Y_SCR
buf_scr:	ds.b	2*NB_PTS+Y_SCR
pt_scr:	ds.w	1
pt_txt:	ds.l	1
blc:	ds.w	1
pos:	ds.l	1
w_scr:	ds.w	1

adr_rout:	ds.l	16*N_SPR		=1472

r_sprite:	ds.b	35820		N_SPR*(H*12+2)*16	=66976
	ds.b	34		       
buf_spr:	ds.b	34*HH		       
dec_spr:	ds.w	16*HH*2

*	Variables Scroll 16x16

adr_aff2:	ds.w	92*N_CAR
adr_dec2:	ds.b	92*N_CAR
	ds.l	1
buf_scr2:	ds.l	2*N_CAR+1
pt_scr2:	ds.w	1
add_x:	ds.w	1
add_y:	ds.w	1
add:	ds.w	1
t_scr2:	ds.w	1
pos2:	ds.l	1
nb_sp2:	ds.w	1
nb_sp20:	ds.w	1

buf_tst:	ds.b	7000
	ds.b	7000

adr_rout2:ds.l	NB_POS2		bss points

max_dot	ds.l	1
p_aff	ds.l	1
p_eff	ds.l	1
p_att	ds.l	1
d_tbl:	ds.l	1
zeze:	ds.l	nb_pnts
excd:	ds.b	1062
	even
rout:	ds.b	88848	(nb_pnts*4+2)*NB_POS2


* Variables r�serv�es *

inter1:	ds.b	1
inter2:	ds.b	1
	even

old418	ds.l	1
oldscreen	ds.l	1
oldpal	ds.w	16
oldrez	ds.w	1
oldsync	ds.l	1
old120	ds.l	1
super	ds.l	1

	ds.b	200
stack:	ds.l	16
	
	even

end
