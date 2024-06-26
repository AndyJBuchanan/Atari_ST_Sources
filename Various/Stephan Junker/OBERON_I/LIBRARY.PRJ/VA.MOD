MODULE VA;
(*
 * va.mod
 *
 * author: stefan eissing
 * adapted for Oberon by Stephan Junker @ AC2
 *
 * description: Definition der Nachrichten des Venus <-> Accessory
 * Protokolls
 *
 * last change: 28.09.1990
 *)

(* Message-Nummern f�r das xAcc-Protokoll von Konrad Hinsen
 * Venus gibt bei ACCID "VENUS.APP" und Gemini gibt "GEMINI.APP"
 * zur�ck. Gemini unterst�tzt xAcc der Stufe 0.
 *)
CONST ACCID*		= 400;
CONST ACCOPEN*		= 401;
CONST ACCCLOSE*		= 402;
CONST ACCACC*		= 403;

(* Message-Nummern f�r die Kommunikation zwischen Venus und
 * verschiedenen Accesories.
 * Sollten in Nachrichten Pfade oder Dateinamen vorkommen, so
 * mu� immer der absolute Pfad angegeben werden (also mit Laufwerk)
 * und alle Buchstaben m�ssen Gro�buchstaben sein. Pfade enden
 * IMMER mit einem Backslash!
 *
 * Nachrichten von Venus beginnen mit VA (Venus -> Accessory).
 * Nachrichten an Venus beginnen mit AV (Accessory -> Venus).
 *
 * Mit AVPROTOKOLL kann jedes Acc nachfragen, welche Nachrichten
 * verstanden werden (Dies ist ja bei VENUS und GEMINI
 * unterschiedlich! Es w�re sch�n, wenn auch andere Programme auf
 * dieses Protokoll reagieren w�rden. Zumindest AVSENDKEY ist
 * sicher leicht zu implementieren und ist die einzige Methode, wie
 * �ber Nachrichten Tastaturdr�cke simuliert werden k�nnen.
 *)

(* AVPROTOKOLL: Mit dieser Nachrichtennummer sollte man bei
 * anderen Applikationen und auch VENUS/GEMINI nachfragen, ob
 * und welche Nachrichten sie versteht.
 *)
CONST AVPROTOKOLL*	= 4700H;
(*
 * Word 6+7: Pointer auf den Accessorynamen, wie er bei
 *           applfind benutzt werden mu�; also 8 Zeichen lang
 *           nullterminiert (char name[9]).
 * Die Bits in den Worten 3, 4 und 5 haben folgende Bedeutung:
 * Word 3:
 * Bit 0:		(VASETSTATUS)
 * Bit 1:		(VASTART)
 * Alle anderen Bits sind f�r Erweiterungen reserviert und sollten
 * daher mit 0 vorbesetzt werden. Das gilt nat�rlich auch f�r die
 * Bits in den Worten 4 und 5.
 *)

(* VAPROTOSTATUS: Dem Sender von AVPROTOKOLL wird mitgeteilt, da�
 * der Empf�nger etwas von diesem Protokoll wei�. Die Worte 3-7 des
 * Nachrichtenpuffers enthalten die Information, welche Nachrichten
 * verstanden werden. Gesetzte Bits stehen daf�r, da� eine Nachricht
 * (Nachrichtengruppe) verstanden werden.
 *)
CONST VAPROTOSTATUS*	= 4701H;
(*
 * Word 6+7: Pointer auf den Programmnamen, wie er bei
 *           applfind benutzt werden mu�; also 8 Zeichen lang
 *           nullterminiert (char name[9]).
 * Die Bits in den Worten 3, 4 und 5 haben folgende Bedeutung:
 * Word 3:
 * Bit 0		(AVSENDKEY)
 * Bit 1		(AVASKFILEFONT)
 * Bit 2		(AVASKCONFONT, AVOPENCONSOLE)
 * Bit 3		(AVASKOBJECT)
 * Bit 4		(AVOPENWIND)
 * Bit 5		(AVSTARTPROG)
 * Bit 6		(AVACCWINDOPEN, AVACCWINDCLOSED)
 * Bit 7		(AVSTATUS, AVGETSTATUS)
 * Alle anderen Bits sind f�r Erweiterungen reserviert und sollten
 * daher mit 0 vorbesetzt werden. Das gilt nat�rlich auch f�r die
 * Bits in den Worten 4 und 5.
 *
 * AVSENDKEY kann sicher jeder leicht in seine Programme einbauen.
 * Bei AVOPENWIND k�nnte ein Hauptprogramm auch seine "normale"
 * Routine zum �ffnen eines Dokumentes anwerfen und dabei den
 * �bergebenen Pfad benutzen. Dies ist zusammen mit der Benutzung
 * von TreeView sicher eine einfache Art, Dateien aus anderen Ordnern
 * oder Laufwerken zu laden.
 *)

(* AVGETSTATUS: Ein Accessory erfragt bei Venus den aktuellen
 * Status, den es Venus mit AVSTATUS mal gegeben hat.
 *)
CONST AVGETSTATUS*	= 4703H;

(* AVSTATUS: Ein Accessory kann Venus seinen Status mitteilen,
 * der dann von Venus im INF-File gespeichert wird und mit
 * AVGETSTATUS wieder abgerufen werden kann.
 * Zuvor MUSS es sich aber mit AVPROTOKOLL anmelden!
 * Word 3+4: Pointer auf einen String, der keine Steuerzeichen
 *           enthalten darf und nicht l�nger als 256 Zeichen
 *           sein darf. Dieser Pointer darf allerdings NULL sein.
 *)
CONST AVSTATUS*		= 4704H;

(* VASETSTATUS: Venus teilt dem Accessory den abgespeicherten
 * Status bei Nachfrage durch AVGETSTATUS mit. Dieser kann dann
 * von einem Accessory gesetzt werden.
 * Word 3+4: Pointer auf einen String, der keine Steuerzeichen
 *           enth�lt.
 *           Dieser Pointer kann allerdings NULL sein, dann war
 *           kein Status gespeichert.
 *)
CONST VASETSTATUS*	= 4705H;

(* AVSENDKEY: Ein Acc sendet VENUS/GEMINI einen Tastaturevent, den
 * es selber vielleicht nicht versteht.
 * Word 3 = Tastaturstatus                 evmmokstate
 * Word 4 = Scancode der gedr�ckten Taste  evmkreturn
 *)
CONST AVSENDKEY*	= 4710H;

(* VASTART: Accessory wird aktiviert. Word 3 + 4 enthalten einen
 * Pointer auf eine Kommandozeile, der auch NULL sein kann.
 * In der Kommandozeile stehen Pfade oder Dateinamen.
 *)
CONST VASTART*		= 4711H;

(* AVASKFILEFONT: Frage nach dem eingestellten Zeichensatz
 * f�r Dateinamen.
 *)
CONST AVASKFILEFONT*	= 4712H;

(* VAFILEFONT: Gibt den derzeit eingestellten Zeichensatz.
 * Word 3 = Dateifontnummer (font id)
 * Word 4 = Dateifontgr��e (in points)
 *)
CONST VAFILEFONT*	= 4713H;

(* (Nur Gemini) AVASKCONFONT: Frage nach dem eingestellten
 * Zeichensatz f�r das Console-Fenster.
 *)
CONST AVASKCONFONT*	= 4714H;

(* VACONFONT: Gibt den derzeit eingestellten Zeichensatz.
 * Word 3 = Consolefontnummer (font id)
 * Word 4 = Consolefontgr��e (in points)
 *)
CONST VACONFONT*	= 4715H;

(* AVASKOBJECT: Fragt nach dem derzeit selektiertem Objekt.
 * Es wird der Name des derzeit selektierten Objektes zur�ckgegeben.
 * Ist kein Objekt selektiert, so ist der String leer.
 * Sind mehrere Objekte selektiert, so sind ihre Namen durch Leer-
 * zeichen getrennt.
 *)
CONST AVASKOBJECT*	= 4716H;

(* VAOBJECT: Gibt Namen der derzeit selektierten Objekte.
 * Aufbau wie bei VASTART
 *)
CONST VAOBJECT*		= 4717H;

(* (Nur Gemini)AVOPENCONSOLE: Venus soll das Console-Fenster �ffnen.
 * Ist es schon offen, so wird es nach vorne gebracht. Diese Aktion
 * ist vor allen Dingen sinnvoll, wenn ein Accessory ein TOS-Programm
 * mittels der system()-Funktion starten will (Warnung: Auf keinen
 * Fall darf ein GEM-Programm von einem Accessory via system()
 * gestartet werden! (siehe auch AVSTARTPROG)
 * Auch sollte diese Nachricht nur auf ausdr�cklichen Wunsch des
 * Benutzers gebraucht werden, da es ihn sonst nur verwirren kann.
 *
 * ACHTUNG: Diese Nachricht steht nur in Gemini.app zur Verf�gung.
 *)
CONST AVOPENCONSOLE*	= 4718H;

(* VACONSOLEOPEN: Gibt zur�ck, ob das Console-Fenster nach vorne
 * gebracht worden ist. Word 3 == 0 (nein) != 0 (ja)
 *)
CONST VACONSOLEOPEN*	= 4719H;

(* AVOPENWIND: Venus soll ein Datei-Fenster �ffnen.
 * Dies sollte auch nur geschehen, wenn die Ursache f�r den
 * Benutzer ersichtlich ist.
 * Word 3+4 (Pointer) Pfad f�r das Fenster (s.o.).
 * Word 5+6 (Pointer) Wildcard f�r darzustellende Dateien.
 *)
CONST AVOPENWIND*	= 4720H;

(* VAWINDOPEN: Gibt an, ob das Fenster ge�ffnet werden konnte.
 * siehe VACONSOLEOPEN
 *)
CONST VAWINDOPEN*	= 4721H;

(* AVSTARTPROG: Venus soll ein Programm starten. Hierbei
 * werden die angemeldeten Applikationen der Venus mit
 * ber�cksichtigt. Man kann also auch eine Datei angeben, f�r
 * die Venus dann ein Programm sucht.
 * Word 3+4 (Pointer) Programmname mit kompletten Pfad
 * Word 5+6 (Pointer) Kommandozeile (kann NULL sein)
 *)
CONST AVSTARTPROG*	= 4722H;

(* VAPROGSTART: Gibt an, ob Venus das Programm startet.
 * Word 3 == 0: nicht gestartet, != 0 gestartet
 * Im Allgemeinen wird das Acc. im Fehlerfall sofort eine
 * Nachricht bekommen. Wenn das Programm aber gestartet wird, erh�lt
 * das Acc. diese Nachricht erst nach dem Start des Programms, da
 * die Routine, die den Pexec macht nicht mehr wissen kann, das ein
 * Acc. noch schnell eine Nachricht bekommen mu�. Bei einem GEM-
 * Programm, kann man der Erfolg auch an dem ACCLOSE erkennen.
 * Auch ist die Fehlererkennung nicht optimal. Der R�ckgabewert weist
 * auch nicht aus, das das Programm fehlerfrei gelaufen ist.
 *)
CONST VAPROGSTART*	= 4723H;

(* AVACCWINDOPEN: Mit dieser Nachricht kann ein Acc Venus mitteilen, da�
 * es ein Fenster ge�ffnet hat.
 * Word 3 AES-Handle des ge�ffneten Fensters
 *)
CONST AVACCWINDOPEN*	= 4724H;

(* VADRAGACCWIND: Venus teilt dem Acc mit, da� Objekte auf eines seiner
 * mittels AVACCWINDOPEN angemeldeten Fenster gezogen worden sind.
 * Word 3   AES-Handle des Fensters
 * Word 4   X-Position der Maus
 * Word 5   Y-Position der Maus
 * Word 6+7 Pointer auf einen String, der die Namen der Objekte enth�lt.
 *)
CONST VADRAGACCWIND*	= 4725H;

(* AVACCWINDCLOSED: Acc teilt Venus mit, da� sein Fenster geschlossen
 * wurde. Dies braucht das Acc nur in dem Fall zu tun, wenn es selbst das
 * Fenster schlie�t. Bekommt es eine ACCLOSE Mitteilung vom AES, so wei�
 * Venus schon, da� alle Fenster weg sind.
 * Word 3   AES-Handle des Fensters
 *)
CONST AVACCWINDCLOSED*	= 4726H;

END VA.