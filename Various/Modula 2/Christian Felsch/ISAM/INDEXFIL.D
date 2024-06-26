DEFINITION MODULE IndexFiles;

(*                             Von Michael H.                               *)
(*  portiert nach M-2 August '91 von Christian Felsch und Peter Oleski.     *)       
(*  Diese ISAM ist Public Domain und darf von jedem f�r zivile Aufgaben     *)
(*  benutzt werden. Eine Nutzung f�r milit�rische Zwecke ist untersagt !    *)
(*                         Diese ISAM ist Peace-Ware !                      *)
(*                         ---------------------------                      *)
(*  Diese ISAM darf ver�ndert und erweitert werden. Bei guten Erweiterungen *)
(*  und Fehlern benachrichtigung bitte an uns senden.                       *)
(*  Die ISAM hat unsere Platte NICHT zerst�rt aber wir �bernehmen keine     *)
(*  Verantwortung f�r nichts.                                               *)
(*  Wir bitten aber, falls diese ISAM einmal eine Verwendung findet, uns    *)
(*  mit dem Satz ' ISAM by Jau-Team ' zu erw�hnen.                          *)
(*  Wird mit dieser Bibliothek ein kommerzielles Programm erstellt, so ist  *)
(*  uns ein kostenloses Exemplar zuzusenden                                 *)
(*  Zu erreichen unter:                                                     *)
(*                                                                          *)
(*      E-Mail: Peter Oleski        oder   Christian Felsch @ HH (MausNet)  *)
(*  gelbe Post: Ei�endorfergrenzweg 83a     Bevenser Weg 18                 *)
(*                             2100 Hamburg 90                              *)


 (* Modul zur Verwaltung der Indexdateien    *)
 
 (* Erl�uterungen zu den zu �bergebenden Variablen:       *)
 
 (*  I  : Eingabewerte vom Benutzer                       *)
 (*  o  : nur interne Statusinformationen werden ge�ndert *)
 (*  O  : relevante Informationen werden zur�ckgeliefert  *)
 
 
 FROM IsamGlobals IMPORT IndexType, IdxFile,IsamKeyStr;
 FROM SYSTEM      IMPORT BYTE;
 
 
 PROCEDURE IndexMake(VAR Index  : IdxFile;                 (* O *)
                         FName  : ARRAY OF CHAR;           (* I *)
                         KeyLen : BYTE;                    (* I *)
                         Typ    : IndexType);              (* I *)

  (* Kreiert neue Indexdatei *)
  
  
 PROCEDURE IndexOpen(VAR Index  : IdxFile;                 (* O *)
                         FName  : ARRAY OF CHAR;           (* I *) 
                         KeyLen : BYTE;                    (* I *)
                         Typ    : IndexType);              (* I *)

  (* �ffnet Indexdatei *)
  
  
 PROCEDURE IndexReset(VAR Index : IdxFile);                (* I/o *)

  (* Ein folgendes IndexNext liefert den ersten, ein folgendes IndexPrev *)
  (* den letzten Index. *)
  
  
 PROCEDURE IndexFlush(VAR Index : IdxFile);                (* I/o *)

  (* F�hrt ein Flush auf Indexdatei aus *)


 PROCEDURE IndexClose(VAR Index : IdxFile);                (* I *)

  (* Schlie�t Indexdatei *)
  
  
 PROCEDURE IndexErase(VAR Index : IdxFile);                (* I *)

  (* L�scht Indexdatei *)
  
  
 PROCEDURE IndexAdd(VAR Index      : IdxFile;              (* I/o *)
                        DataRecNum : LONGINT;              (* I *)
                        ProcKey    : ARRAY OF CHAR);       (* I *)

  (* F�gt einen neuen Index ein *)
  

 PROCEDURE IndexDel(VAR Index      : IdxFile;              (* I/o *)
                        DataRecNum : LONGINT;              (* I *)
                        ProcKey    : ARRAY OF CHAR);       (* I *)

  (* L�scht einen Index. Bei Dups: man mu� erst die DataRecNum ermitteln *)
  (* und dann �bergeben um den richtigen von mehreren gleichen ProcKeys  *)
  (* zu l�schen . *)
  

 PROCEDURE IndexFind(VAR Index      : IdxFile;             (* I/o *)
                     VAR DataRecNum : LONGINT;             (* O *)
                         ProcKey    : IsamKeyStr);         (* I *)

  (* Findet ein Listeneintrag. Der Eintrag mu� garantiert in der    *)
  (* Liste enthalten sein, sonst gibt es einen Fehler !             *)
  (* Bei Dups wird der passende Index mit der kleinsten DataRecNum  *)
  (* zur�ckgeliefert. *)
  

 PROCEDURE IndexRefind(VAR Index      : IdxFile;           (* I/o *)
                           DataRecNum : LONGINT;           (* I *)
                           ProcKey    : IsamKeyStr);       (* I *)

  (* Wie IndexFind, zuz�tzlich wird DataRecNum ber�cksichtigt.  *)
  (* Dient zum Wiederaufsetzen an einem zuvor gefundenen Index. *)
  (* Wenn der IndexZeiger durch z.B. ein Abspeichern verbogen ist *)
  (* kann man ihn hiermit wieder auf den vorherigen Index setzen  *)


 PROCEDURE IndexSearch(VAR Index      : IdxFile;           (* I/o *)
                       VAR DataRecNum : LONGINT;           (* O *)
                       VAR ProcKey    : ARRAY OF CHAR);    (* I/O *)

  (* Sucht nach einem Eintrag in der Liste. Wird keiner gefunden  *)
  (* wird derjenige zur�ckgegeben, der alphabet. nach dem gesuchten folgt.  *)
  (* Es reicht den Anfang vom ProcKey anzugeben. *)
  (* Sollte der Gesuchte nach dem Letzten der Liste folgen *)
  (* so wird ProcKey nicht ge�ndert und fFileNotFound wird geliefert *)
  

 PROCEDURE IndexNext(VAR Index      : IdxFile;             (* I/o *)
                     VAR DataRecNum : LONGINT;             (* O *)
                     VAR ProcKey    : ARRAY OF CHAR);      (* O *)

  (* Liefert den alphabet. Nachfolger zur�ck. Zuvor mu� mit IndexFind/Search *)
  (* ( und ggf. IndexNext/Prev ) der interne Zeiger gesetzt werden. *)
                                            

 PROCEDURE IndexPrev(VAR Index      : IdxFile;             (* I/o *)
                     VAR DataRecNum : LONGINT;             (* O *)
                     VAR ProcKey    : ARRAY OF CHAR);      (* O *)

  (* Liefert den alphabet. Vorg�nger zur�ck. Zuvor mu� mit IndexFind/Search *)
  (* ( und ggf. IndexNext/Prev ) der interne Zeiger gesetzt werden. *)


END IndexFiles.