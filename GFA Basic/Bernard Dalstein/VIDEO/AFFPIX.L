
;********************************
;*   afficher une image video   *
;* mode 320 x 200 => 8 couleurs *
;*    code: (c) rafale 1995     *
;********************************

;  r�cup�ration des variables
; ----------------------------

   ;adresse de base du buffer
        move.l 4(SP),A5

   ;initialisation compteur pixel
        clr.l  D5
        move.w 8(SP),D5
        add #1,D5

   ;initialisation info couleur
        move.l #0,A6
        move.w 10(SP),A6

   ;initialisation du compteur ligne
        move #128,D4

   ;se d�caler de l'entete de format TGA
        add  #18,A5
        clr.l D1


 ;initialisation compteurs ligne et pixel
        add    #38,D5   ; d�caler position pixel � l'�cran
        move   #36,D4   ; d�caler position ligne � l'�cran
suite   move   #38,D3   ; bref,c'est un centrage � l'�cran

 ;lecture data RAM --> D1 suivant couleur
retour  CMPA #0,A6
        beq rouge
        CMPA #1,A6
        beq vert
        CMPA #2,A6
        beq bleu
        CMPA #3,A6
        beq bleu   ;3=gris:on affiche la composante B, ce qui revient
                   ;au meme qu'afficher R ou V.
        bra mix    ;si diff�rent de R, V, B ou Gris, alors mixage

ROUGE   ADD    #2,A5
        MOVE.B (A5),D1
        add    #1,A5
        bra    affpix

VERT    ADD    #1,A5
        move.b (A5),D1
        add    #2,A5
        bra    affpix

BLEU    MOVE.B (A5),D1
        add    #3,A5
        bra    affpix

MIX     clr.l  D1
        clr.l  D2
        move.b (A5),D1
        add    #1,A5
        move.b (A5),D2
        add.w  D2,D1
        add    #1,A5
        move.b (A5),D2
        add.w  D2,D1
        add    #1,A5
        divu   #3,D1

 ;affichage du pixel en huit niveaux � l'�cran
affpix  lsr     #5,D1
        andi.w  #7,D1
        dc.w    $a000
        movea.l 8(a0),A3   ;recherche des pointeurs
        movea.l 12(a0),A4  ;sous GEM pour affichage
        move.w  D3,(A4)
        move.w  D4,2(A4)
        move.w  D1,(A3)
        dc.w    $a001      ;appel de la procedure "aff. pixel"

 ;inc. compteur pixel + comparer avec valeur finale
        add    #1,D3
        cmp.b  D5,D3
        bne retour    ;si pas fini, aff. pixel suivant,

 ;inc. compteur ligne + comparer avec valeur finale
        add    #1,D4
        cmpi.b #164,D4
        bne    suite  ;si pas fini, aff. ligne suivante

 ;retour au PRG
        rts  ; good bye !
        end

 