
;********************************
;* num�riser une s�quence video *
;*    code: (c) rafale 1994     *
;********************************

;  r�cup�ration des variables
; ----------------------------

   ;adresse de base du buffer
        move.l 4(SP),A1

   ;initialisation compteur pixel
        clr.l  D5
        move.w 8(SP),D5
        add #1,D5

   ;initialisation info couleur
        move.l #0,A2
        move.w 10(SP),A2

   ;initialisation du compteur ligne
        move #128,D4

   ;se d�caler de l'entete de format TGA
        add  #18,A1
        move.l A1,A5

   ;mise hors GEL de la RAM VIDEO
        move.b $FB0040,D2

   ;attente de fin de trame
wait1   move.b $FA0001,D1
        cmpi.b #128,D1
        blt    wait1

   ;activation du mode GEL
        move.b $FB00C0,D2

   ;temporisation de 1 ms (pour stabiliser l'�lectronique de la carte)
tempo   move.w #1000,D1
boucl   sub       #1,D1
        bne    boucl


   ;RAZ des compteurs ligne et pixel
        move.b $FB0082,D2 ;raz pixel
        move.b $FB0080,D2
        move.b $FB0084,D2 ;raz ligne
        move.b $FB0080,D2

   ;d�caler 7 pixels � chaque ligne (version 192 � 210 pixels/ligne)
suite   move.b $FB0081,D2
        move.b $FB0080,D2
        move.b $FB0081,D2
        move.b $FB0080,D2
        move.b $FB0081,D2
        move.b $FB0080,D2
        move.b $FB0081,D2    ;(le couper/coller, c'est moins classe
        move.b $FB0080,D2    ;qu'une boucle, mais � 3 heures du mat'
        move.b $FB0081,D2    ;�a d�foule un peu !!!!)
        move.b $FB0080,D2
        move.b $FB0081,D2
        move.b $FB0080,D2
        move.b $FB0081,D2
        move.b $FB0080,D2
        move.l D5,D3       ;transfert du nombre de pixels/ligne dans D3

   ;lecture data --> D1
retour  move.b $FA0001,D1
        lsl    #2,D1

   ;stockage data --> buff(n)
   ;en fonction de la couleur
        CMPA #0,A2
        beq rouge
        CMPA #1,A2
        beq vert
        CMPA #2,A2
        beq bleu
        bra gris

rouge   add    #2,A1         ;inc 2 fois buffer RAM
        move.b D1,(A1)       ;stockage dans buffer point� par A1
        add    #1,A1         ;inc 1 fois buffer RAM
        bra incpix           ;(Buffer du type B-V-R par pixel)

vert    add    #1,A1
        move.b D1,(A1)
        add    #2,A1
        bra incpix

bleu    move.b D1,(A1)
        add    #3,A1
        bra incpix

gris    move.b D1,(A1)       ;si image monochrome,stockage de l'info
        add    #1,A1         ;dans chaque emplacement R, V et B, de
        move.b D1,(A1)       ;fa�on � restituer les niveaux de gris
        add    #1,A1         ;dans le fichier TGA final
        move.b D1,(A1)
        add    #1,A1

   ;horloge pixel
incpix  move.b $FB0081,D2    ;on se d�place dans la RAM de la carte
        move.b $FB0080,D2    ;vid�o externe

 ;d�cr. compteur de pixels
 ;et comparer avec valeur finale (0!)
        sub    #1,D3         ;
        bne    retour

 ;incrementation des lignes deux fois sur la RAM 210x128
        move.b $FB0082,D2    ;la capacit� de la RAM externe ne permet
        move.b $FB0080,D2    ;de ne m�moriser qu'une ligne sur deux
        move.b $FB0082,D2    ;d�livr�e par la cam�ra vid�o. Avec la RAM
        move.b $FB0080,D2    ;de 420x288, on incr. 1 fois seulement

 ;d�cr. compteur de lignes
 ;et comparer avec valeur finale
        sub    #1,D4
        bne    suite

 ;suppression GEL et retour au PRG
 ;      move.b $FB0040,D2   (fin_gel non trait� ici)
        rts  ; good bye !
        end

 