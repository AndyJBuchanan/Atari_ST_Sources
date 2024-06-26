****************************
*-------- IMG_IO.S --------*
* Routine de d�compression *
* Du format IMG            *
****************************

    .EXPORT img_dcmps
* typedef struct _IMGS_STR
* {
*   void* adr_src ;   /* Source address                  */
*   void* adr_dest ;  /* Destination address             */
*   int   nb_plan ;   /* Number of planes                */
*   int   octet_run ; /* Number of bytes for pattern run */
*   int   nb_pixel ;  /* Number of piwels per line       */
*   int   nb_ligne ;  /* Number of lines                 */
*   int   mot_larg ;  /* Number of words per line        */
* }
* IMGS_STR, *PIMGS_STR ;
adr_src   EQU 0
adr_dest  EQU 4
nb_plan   EQU 8
octet_run EQU 10
nb_pixel  EQU 12
nb_ligne  EQU 14
mot_larg  EQU 16

* img_dcmps(IMGS_STR* data)
*                     A0
img_dcmps:
    MOVEM.L   D0-D7/A0-A6,-(SP) ; Sauvegarde du contexte

    MOVE.L    A0,A1
    SUBI.W    #1,nb_ligne(A1)
    MOVEQ.L   #0,D0
    MOVEQ.L   #0,D6
    MOVE.W    nb_pixel(A1),D0
    DIVU.W    #8,D0
    MOVE.W    D0,D6
    SWAP      D0
    TST.W     D0
    BEQ       reste_nul
    ADDQ.W    #1,D6
reste_nul:
    MOVEQ.L   #0,D0
    MOVE.W    nb_plan(A1),D0
    MULU.W    D0,D6             ; Nombre d'octets par ligne
    MOVE.L    adr_src(A1),A2
    SUBI.W    #1,octet_run(A1)
    
    MOVEQ.L   #0,D7
    MOVE.W    nb_plan(A1),D7
    MOVE.W    D7,D5
    SUBQ.W    #1,D7
    ADD.L     D7,D7
    
    SWAP      D7
    MOVE.W    nb_ligne(A1),D4
    MOVE.L    adr_dest(A1),A4
    MOVE.L    A4,A3
    
start_plan:
    MOVE.L    A3,A0
decompt_plan:
    CLR       D3
    CLR       D0
*   Teste si la ligne doit se r�p�ter ($0000FF)
    CMPI.B    #0,(A2)
    BNE       decompresse_ligne
    CMPI.B    #0,1(A2)
    BNE       decompresse_ligne
    CMPI.B    #$FF,2(A2)
    BNE       decompresse_ligne
*   La ligne doit se r�p�ter
    MOVE.B    3(A2),D0
    SUBI.W    #1,D0
    ADDQ.L    #4,A2
decompresse_ligne:
    CMP.W     nb_pixel(A1),D3
    BGE       fin_ligne
    CLR.W     D1
    MOVE.B    (A2)+,D1
    BEQ       pattern_run
    CMPI.B    #$80,D1
    BEQ       bit_string
    
*****************
* Cas SOLID_RUN *
*****************
    MOVE.B    #0,D2
    BCLR      #7,D1
    BEQ       ici
    MOVE.B    #$FF,D2
ici:
    SUBI      #1,D1
bcl_srh1:
    MOVE.B    D2,(A3)+
    ADDQ.W    #8,D3
    ADDA.W    D7,A3
    SWAP      D7
    DBF       D1,bcl_srh1
    BRA       decompresse_ligne

*******************
* Cas PATTERN_RUN *
*******************
pattern_run:
    CLR       D2
    MOVE.B    (A2)+,D2
    SUBI.W    #1,D2
    MOVE.L    A2,A5
loop_pr1:
    MOVE.L    A5,A2
    MOVE.W    octet_run(A1),D1
rprun:
    MOVE.B    (A2)+,(A3)+
    ADDQ      #8,D3
    ADDA.W    D7,A3
    SWAP      D7
    DBF       D1,rprun
    DBF       D2,loop_pr1
    BRA       decompresse_ligne
    
******************
* Cas BIT_STRING *
******************
bit_string:
    CLR       D2
    MOVE.B    (A2)+,D2
    SUBI      #1,D2
loop_bs:
    MOVE.B    (A2)+,(A3)+
    ADDQ      #8,D3
    ADDA.W    D7,A3
    SWAP      D7
    DBF       D2,loop_bs
    BRA       decompresse_ligne
    
fin_ligne:
    TST.W     D7
    BEQ       ici_d7
    SWAP      D7
ici_d7:
    SUBI.W    #1,D5
    BEQ       fin_plan

    ADDQ.L    #2,A4
    MOVE.L    A4,A3
    CLR.W     D3
    BRA       decompresse_ligne
    
fin_plan:
    MOVE.W    nb_plan(A1),D5
    MOVEQ.L   #0,D2
    MOVE.W    mot_larg(A1),D2
    ADD.L     D2,D2
    ADD.L     D2,adr_dest(A1)
    MOVE.L    adr_dest(A1),A4
    MOVE.L    A4,A3
    
    TST       D0
    BEQ       no_rep
    
rep:
    MOVE.W    D6,D1
    MOVE.L    A0,A5
loop:
    MOVE.B    (A5)+,(A3)+
    SUBQ.W    #1,D1
    BNE       loop
    ADDA.L    D2,A4
    MOVE.L    A4,A3
    SUBQ.W    #1,D4
    BLT       retour
    SUBQ.W    #1,D0
    BNE       rep
    MOVE.L    A4,adr_dest(A1)
    
no_rep:
    SUBI      #1,D4
    BPL       start_plan

retour:
    MOVEM.L   (SP)+,D0-D7/A0-A6 ; Restauration du contexte
    RTS                         ; Retour au programme C
