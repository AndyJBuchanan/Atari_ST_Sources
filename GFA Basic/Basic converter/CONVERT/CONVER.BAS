 GfABASIC          j   �   �   �   �   �   �    *  *  *  *  |  �  �  .  V  ^  ^  ^  j  j  z  �  �  �  '�BUTTON	FILE_ENDEPOSL STOEDQFILE_INFILE_OUTMMESSAGELL2TOKENLOUTTXDUMMYD	OLD_TOKENL_OLDY NOLLILIPCOUNT_IFDUMMYZEILE	OLD_ZEILELNEN 	FLAG_THENLABEL_FOUNDLABELP_FOUNDFLAG_GS LABELSLABELSP FSPROCESS_LINE_RPROCESS_TOKEN_RR_GET_TOKENHELLOPHASE1PHASE2
SHOW_STATSTITLEFEHLER	GET_TOKENNO_LINE_NUMBER
ADD_LABELSPROCESS_LINEPROUTCHECK_LABELPROCESS_TOKEN
PROCESS_IFPROCESS_THENPROCESS_GOTOPROCESS_GOSUB
PROCESS_ONPROCESS_RESTOREPROCESS_REM
PROCESS_DQUNGET_TOKENREMOVE_BLANKSRPFP	MAKE_FILE
LOOK_LABELLOOK_LABELP  index for label_arrays *� �zz    !��zz    F� E�QF� E�       F!�E�       F!�E�       F!� E�       F!�EB�    F� |F�E�       FF,� F 2)�     !�Stop on error|!�     !�YES|NO!� F  �D� �    Fn� E�NF �PFF� E�YFFEYFE�E�TEST.BASFF�E�
RESULT.LSTFn�Select input file Frf�\*.*!�TEST.LST!�Fo ��� JFT-� F�F �Select output file Ff�\*.*!�
RESULT.LST!�F| �F��F@)�      !� In and outfile must|be different!�      !�OK!�F -� F F  �^�� JFn-� F�F ,�F�YF"�E�End of Phase I|Press returnF")�      !�!�      !� OK !� F ,�F ,�F qF+�F �E�P H A S E  IF,�FPv�L�FH�E�       F �E�     F �E�       F 7�I!M�     !�FF=`M�      !�F

 ��Z�F4� FZ�E�FF,�FF �t]� �      F ,�F] ��F�"Y�      !�     "� LINE "5� F
�E5� F�,�F,�FF�$F 8M�     F�.F�+�F �E�P H A S E  IIF,�FPFF�E�       F v�L�F 7�I!M�     !�F7�O!M�    !�FF=`M�      !�F

 �VZ�F,�	FZ�.F� ���      FF�	E�ENDIFF,�
FE5�FE�VFN.F +�	FFh�
!�F�	E� FF ����      FF�	E�ENDIFF,�
FE5�FE�FN,�FF�
E�FI
�E5�
 FF ���      JF,�F�-�F�F�E�F� Y�      !�     !�Line "�F ,�F 
 �`�JF�	E�L��:F,�
FLF

 ��JF�	E�
PROCEDURE �L�F,�
FPF
F
,�FP,�FP
 �Z�� FE�F��|FF.F|+�FFh�
FF�
E�F ���
�IFJF,�F�-�F�F ���THENJF,�F�-�F�F �4�
�GOTOJF,�F�-�F�F �V�
�GOSUBJF,�F�-�F�F �v�
�ONJFJ,�F�-�F�F ��
�RESTOREJF,�F�-�F�F ��
�REMJF,�F�-�F�F ���
�JFF,�F�-�F�F ���
� �
�:JF,�
F� �F
�	E�	�
� FFE�|F.F|+�Fh�FF8��/Line number expected. last number read: ###### !�F�Line in error --> Fe
�E��F�E���    6�  F �F ��� �YJF$:�Press return to continue -> !�FF�E� Fs�	E� Fs�E� Fs.FE+�FF�EC�@� F�	E�	�;�@� F�E>�@��      F.FE+�F�	E�	�ON F FE,�F
 �xZ��GOSUB��GOTOF
�	E�	�F�DF��	E�	� �� FFE,�F
 ��Z�� ��:F ����,JF�	E�	�,FF ��F��	E�	�L�FFE�F� ����:JF,�F�F,�
F�.F
+�F��	E�	�IF FFE,�F�	E�	� �F
 �LZ��THENF:�F�4�FF,�FF,�
FF.F
+�FF,�FF �5� �      JF�	E�	� GOTO �L�FO �F�,�FFF.F+�FF�	E�	� GOTO F,�F�	E�	�L�F.FE+�F�	E�	� GOSUB F,�F�	E�	�L�F.FE+�F�	E�	�REM F
�	E�	�F�E� F.FE+�FF�	E�	�RESTORE F,�F �t]� JF�	E�	�L�FFE.FE+�Fh�F
�E� ,:F add doublequote�E�B�     F�E�F �E�F �E� F ,�FF
�E� F  ���� JF-�F�F" �BC�@;�@�        �      JF�E;�@�       F�E>�@�      F-�FF" ��C�@;�@�        �      Fr
 ��Z�� F��E�;�@�      F�E>�@�      F�BF@�|FF.F|+�FF�E�F �E�F .FE+�FFh�FFh�FF ���� P   JF�E�     F��FFF�E�F�Unexpected Error "�F v�F��Fe&:�press return to stop program !�F qF.F+�Fe ��;�@�       � F�E>�@�      F�\F@.F +�
FFM�    !�	F�	E� F.FE+�FFh�	FF�E�       FF�E�       FF �$�	E�      G�F ��� �	 JF�E�     FFFE

�$Z�F
	���	F  �n�	E�      G�F �Z���	 JF�E�     FFFE

�nZ�F
	�8�	F .F +�F�h�!�FF�E�F  ���GOTO��THENJFr,�F� ��5� �      JF� � E5� F4�FE �F5 �
��GOSUB��GOTOJF,�F��E� FFEFEFE �@��GOSUBJF,�F��� E5� F4�FEF ����RESTOREJF,�F� ��]� �      JF� � E5� F4�FEFF �p��ONJF F ,�F� ��#��GOSUB #��GOTO F! ����GOSUBJF�E�     FB ��F �E�       FBFEFE,�F  �X]� �      JF
 �>�JF�� E5� F4�FE �TF5� � E5� F4�FEFF� ��:�� FF ,�F�
 ��Z�� F��F�.F +�FF8F�E�       Fv�L�F 7�I!M�     !�FF=`M�      !�F

 �Z�F�FZ ��S� JF:�FSF��F.F +�FFh�FFYF
�E6� FF(Y�#�    � �     !�      !�Fd.F�+� F h�F <�E�4KLAUS MULDER|OBERE HAUPTSTRASSE 4|8051 MASSENHAUSEN|F��E��Tel: 08165-8437FUYFE$(�      !�    !�      !�    FS2'� H   !�H   !�BASIC CONVERTER -KM- 16AUG86F(�      !�      F�{�    F�&)�      !�!�      !� RETURN !� FK.F +�F YF�E� END OF CONVERSION    |F*�E��Lines: A�  �|�Labels: A� F �E��|�Procedures: A� F:")�      !�!�      !� OK !� F:.F   ,  following procedures used for debuggingG,  =======================================G = (will print the input-file)+�Flh�Fl8F�E�       F 7�I!M�     !�Fv�L�F FL=`M�      !�F

 ��Z�F�FZ��F�.F " (will make a little basic file=+�Flh�Fl8F7�O!M�    !�TEST.LSTFF=`�F
 �LZ�� F!M�    !�F�"F 8F .F +�FFh�!�	F":�Enter label# for GOTO -->"�F=�	E�     F#FE4�	F 
 ��Z� �	 ��	�F��F� ��� �	 �JF�Found !. Index  "�	F �Fn �label for GOTO  not found FF.F+�Fbh�!�	F&:�Enter label# for procedure -->"�F�	E�     F#FE4�	F 
 �|Z��	 ��	�F�XF� ����	 �JF�Found !. Index  "�	F ��Fn$�label for procedure not found F�F.F�                        ��  ��  �� 	 ��  �`   ��                                                                                       ����        ����                �  ������ �T �� �� �Z � �� �~ � �x � �� �� �� � �h � �� �2 �> � �� �� �\ �� �p �� �Z �