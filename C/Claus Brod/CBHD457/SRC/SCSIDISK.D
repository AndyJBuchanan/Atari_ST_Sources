DEFINITION MODULE ScsiDisk;
(****************************************************************************
 *
 *
 * $Source: E:\HM2\LIB\se\rcs\scsidisk.d,v $
 *
 * $Revision: 1.2 $
 *
 * $Author: S_Engel $
 *
 * $Date: 1996/02/03 19:31:46 $
 *
 * $State: Exp $
 *
 *****************************************************************************
 * History:
 *
 * $Log: scsidisk.d,v $
 * Revision 1.2  1996/02/03  19:31:46  S_Engel
 * Kleine Anpassungen
 *
 * Revision 1.1  1995/11/13  17:38:26  S_Engel
 * Initial revision
 *
 *
 *
 ****************************************************************************)


FROM SYSTEM  IMPORT BYTE, ADDRESS, TSIZE;

FROM Portab IMPORT UChar, Char;

PROCEDURE Read6(BlockAdr : LONGCARD;
                TransferLen : SHORTCARD; Adr : ADDRESS) : BOOLEAN;

PROCEDURE Read10(BlockAdr : LONGCARD;
                 TransferLen : SHORTCARD; Adr : ADDRESS) : BOOLEAN;

PROCEDURE Write6(BlockAdr : LONGCARD;
                 TransferLen : SHORTCARD; Adr : ADDRESS) : BOOLEAN;

PROCEDURE Write10(BlockAdr : LONGCARD;
                  TransferLen : SHORTCARD; Adr : ADDRESS) : BOOLEAN;


PROCEDURE Read(BlockAdr : LONGCARD;
               TransferLen : SHORTCARD; ADR : ADDRESS) : BOOLEAN;
  (*
   * ReadCmd liest Datenbl�cke ein
   * Wenn n�tig, wird ein langes Kommando (10 Byte, Class 1) verwendet.
   *)

PROCEDURE Write(BlockAdr : LONGCARD;
                TransferLen : SHORTCARD; ADR : ADDRESS) : BOOLEAN;
  (*
   * WriteCmd speichert Datenbl�cke ab.
   * Wenn n�tig, wird ein langes Kommando (10 Byte, Class 1) verwendet.
   *)


(*
 *)
PROCEDURE StartStop(LoadEject, StartFlag : BOOLEAN) : BOOLEAN;


PROCEDURE Seek6(BlockAdr : LONGCARD) : BOOLEAN;
PROCEDURE Seek10(BlockAdr : LONGCARD) : BOOLEAN;

PROCEDURE Seek(BlockAdr : LONGCARD) : BOOLEAN;


PROCEDURE Format() : BOOLEAN;

(*-------------------------------------------------------------------------*)
(*-                                                                       -*)
(*- ReadCapacity fragt die Gr��e des Laufwerkes ab.                       -*)
(*- Bei PMI = TRUE wird der nach BlockAdr n�chste Block angegeben, der    -*)
(*- noch ohne Verz�gerung �bertragen werden kann.                         -*)
(*- Bei Platten kann dies der letzte PBlock auf dem gleichen Zylinder wie -*)
(*- BlockAdr sein, bei CD-ROMs in etwa der letzte Block, der ohne         -*)
(*- Geschwindigkeits�nderung �bertragen werden kann.                      -*)
(*- PMI=FALSE erfragt die absolute Gr��e des Ger�tes.                     -*)
(*- SCSI-Opcode $25                                                       -*)
(*-                                                                       -*)
(*-                                                                       -*)
(*-------------------------------------------------------------------------*)
PROCEDURE ReadCapacity(PMI : BOOLEAN; VAR BlockAdr, BlockLen : LONGCARD) : BOOLEAN;


END ScsiDisk.
