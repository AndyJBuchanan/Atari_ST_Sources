; cpxstart.s
; Bei der Erzeugung von CPX-Modulen mu� dieser Code anstelle
; von PCSTART.O verwendet werden.
;
; (c)1992 by Richard Kurz
; Vogelherdbogen 62
; 7992 Tettnang
; Fido 2:241/7232
;
; Erstellt mit Pure Assembler
;

; Wir geben bekannt.....
.globl cpxstart,cpx_init
.globl errno,ainf
    
.text

cpxstart:
    jmp cpx_init    ; Dieser Sprung ist lebenswichtig!
                    ; Er mu� am Anfang des Textsegments
                    ; stehen, da XControl dort den Anfang
                    ; des CPX-Moduls vermutet.
.data
; Die Funktion CPX_Save speichert die Werte am Anfang des
; Datensegments. ACHTUNG, es mu� gen�gend Platz sein!!!!

ainf:  dcb.w 2048,0         ; Puffer f�r die Voreinstellungen
errno:      dc.w 0          ; Diese Variable wird von Pure-C-Funktionen
                            ; ben�tigt.
.end        
