 GfABASIC              4   <   <   D   F   F   F   x   x   x   x  �  	�  	�  	�  
  
  
  
  
  
  
  
"  
"  
"  
"STRINGXCUR NRETPTRSPZELAENGEYTSIGNSCAN INSERT STRING S
SPRITEDEFS
MASK_INPUTNO_ASCII_TASTENO_CHARACTER*� � !� �@� F^�F,� F! G�del,10,10,25FEscher,10,11,30Bach,12,12,20    � E�G�F0 Q� �  !� � @� !� � @� !� � @� F
	    � F�� E�FFE(,���� !� �  !� � @� !� � @� !� � @�  F
� �  E� F    ������F 4� F�    F    ��    F�� E�F    F    ��    F�5� F�F F F     � �    F� L************************************************************************L* Maskeneingabeprozedur. Globaler R�ckgabewert: Ret%. Dieser kann die  *L* Werte 1 bis 5 haben. Siehe Programmkommentare                        *L* Vor der Erstbenutzung: <Gosub Spritedefs> eingeben                   *L************************************************************************D                                            ! �bergabeparameter:*,+���!�!�!�!� F  Ptr%=R�ckgabestring$h�F$ X$=Vorbelegung des Stringsb"�E�F& Anfangskkordinaten, L�nge(�E6� �Fg --------------------------('��    �    !��     !�� F.~�!#��� �    !��     ��   FbF�Ea� FE    ��;   F 
,��� F     F B    ��X   ��     ��~~   ��PP   ��   F*
,��� F     F 
    � F �E;�@�� B� >�@� F~    F@�E;�@�� B� >�@�� F FE4�F    ��F Ret% =1
Ret%=1�y�!� p   !M�    F�z�!�!�!� r�  !�F 5�F�FFF~�F�('��    �    !��     !�� F.~�!#��� �    !��     ��   F ��E�F
    Z��F    F�.F  +��� FF"    ��     ��F Backspace5�F�&�E;�@�� >�@�� FFE)    ��P   F# CR/LF�E�F& dann Ret%=2FE)     ��~    ��F Deletec�E;�@�� >�@�� FFE).FE*2                                              !+���	 F      �	�R   F " Inserttaste    � �F  
� E�F 
    F(� E�F!FE'FE)0                                            !    �	�G   F " CLR-Home *�E�     F & Cursor an Anfang, Ret%=5 FE)&    �	�K    ��F Cursor links%5�F�F)(    �	�M    ��Fs Cursor rechts4�F�&F)&    �	�P   F" Cursor nach unten�E�F& Ret%=3FE)&    �	�H   F " Cursor nach oben�E�     F & Ret%=4sFE).FE*E+� F 8�Eb�p    b�@    b� b� b� b� b� b� b� b� F4�E�b� b� b� b� b� b� b� b� b� b� b� F�T�E�b� b� b� b� b� b� b� b� b� b� b� b� b� b� �   b� b��   F.FEE�                                                                                        