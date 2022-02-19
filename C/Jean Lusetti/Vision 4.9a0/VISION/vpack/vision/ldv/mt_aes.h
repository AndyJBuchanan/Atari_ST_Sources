/*
 *	MT_AES library
 *	initied by A. Kromke
 *	this version (for LDG) comes from GemLib pl36
 *	tabulation size : 4 characters
 *	New version (with LDG v1.2)
 */

#ifndef _MT_AES_H_
#ifndef XFSL_FILTER
typedef int cdecl (*XFSL_FILTER)(char *path, char *name, void /*XATTR*/ *xa);
#endif

#ifndef EVNT
typedef struct {
	int	mwhich;
	int	mx;
	int	my;
	int	mbutton;
	int	kstate;
	int	key;
	int	mclicks;
	int	reserved[9];
	int	mesg[16];
} EVNT;
#endif

						  int *OutX, int *OutY, int *ButtonState, int *KeyState, WORD *pb); 
						  int WhichButton, int WhichState, 
						  int EnterExit1, int In1X, int In1Y, int In1W, int In1H,
						  int EnterExit2, int In2X, int In2Y, int In2W, int In2H,
						  int EnterExit1, int In1X, int In1Y, int In1W, int In1H,
                          int *KeyState, int *Key, int *ReturnCount, WORD *pb);
						  int Sx, int Sy, int Bx, int By, int Bw, int Bh, 
						  int *Fw, int *Fh, WORD *pb); 
						  int Fx, int Fy, int Fw, int Fh, WORD *pb); 
						  int Cx, int Cy, int Cw, int Ch, int NewState, int Redraw, WORD *pb);
						  int Cx, int Cy, int Cw, int Ch, WORD *pb);
						  int *OutX, int *OutY, int *OutW, int *OutH, WORD *pb); 
/*
 *	fslx functions
 */
void* mt_fslx_do		( char *title, char *path, int pathlen, char *fname, int fnamelen,
						  char *patterns, XFSL_FILTER *filter, char *paths, int *sort_mode,
						  int flags, int *button, int *nfiles, char **pattern, WORD *gl);
int mt_fslx_evnt		( void *fsd, EVNT *events, char *path, char *fname, int *button,
						  int *nfiles, int *sort_mode, char **pattern, WORD *gl);
void* mt_fslx_open		( char *title, int x, int y, int *handle, char *path, int pathlen,
						  char *fname, int fnamelen, char *patterns, XFSL_FILTER *filter,
						  char *paths, int sort_mode, int flags, WORD *gl);
int mt_fslx_close		( void *fsd, WORD *gl);

/*
int	mt_wind_calc_grect	( int Type, int Parts, GRECT *In, GRECT *Out, WORD *pb);