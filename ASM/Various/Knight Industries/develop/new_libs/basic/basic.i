
MENUBAR equ 0	; TREE - MENU
ABOUT equ 8	; G_STRING in (#0) MENUBAR
QUIT equ 17	; G_STRING in (#0) MENUBAR
ICONIFYWIND equ 21	; G_STRING in (#0) MENUBAR

DETAILS equ 1	; TREE - DIALOG
URL equ 1	; G_STRING in (#1) DETAILS
MAIL equ 2	; G_STRING in (#1) DETAILS

ABOUTBOX equ 2	; TREE - DIALOG
PUTURL equ 6	; G_TEXT in (#2) ABOUTBOX
PUTMAIL equ 9	; G_TEXT in (#2) ABOUTBOX

ICON equ 3	; TREE - DIALOG
SOUNDSYSLOCKED equ 3	; STRING
CANTLOADMEM equ 4	; STRING
NULLSTRING equ 0	; FREE STRING
PROGRAMTITLE equ 1	; FREE STRING
ABOUTTITLE equ 2	; FREE STRING