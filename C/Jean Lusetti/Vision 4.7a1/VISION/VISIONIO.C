/******************************/
/*--------- VISIONIO.C -------*/
/* Module des fonctions       */
/* Appel�es par l'utilisateur */
/******************************/
#include  <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>

#include     "..\tools\stdprog.h"
#include     "..\tools\stdinput.h"
#include     "..\tools\xgem.h"
#include      "..\tools\xfile.h"
#include     "..\tools\gwindows.h"
#include    "..\tools\aides.h"
#include   "..\tools\dither.h"
#include  "..\tools\logging.h"
#include  "..\tools\tiff_io.h"
#include "..\tools\imgmodul.h"
#include "..\tools\rasterop.h"
#include  "..\tools\msgtxt.h"

#include          "undo.h"
#include        "gstenv.h"
#include        "rtzoom.h"
#include       "fullscr.h"
#include       "actions.h"
#include      "vsldshow.h"
#include      "vtoolbar.h"
#include      "visionio.h"
#include       "hexdump.h"
#include "forms\fdecoup.h"
#include "forms\finout.h"
#include "forms\falbum.h"

#ifndef __VISION_H
#define __VISION_H
#include "langues\francais\vision.h"
#endif

char last_path[PATH_MAX] ; /* Chemin pr�c�dent                         */

DECOUP decoup = { 0, 1, 1, 0 } ;


void log_event(int type, char *file_name)
{
  char buf[512] ;
  char ttime[20] ;
  char date[20] ;

  if ( config.log_stream )
  {
    get_england_time_date( ttime, date ) ;
    switch( type )
    {
      case CMD_DISPLAY : sprintf( buf, "Display %s ; %s %s\r\n", file_name, date, ttime ) ;
                         fwrite( buf, strlen(buf), 1, config.log_stream ) ;
                         break ;
    }
  }
}

void open_where(int wkind, int w, int h, int *xout, int *yout, int *wout, int *hout)
{
  int xo, yo, wo, ho ;
  int dummy ;

  wind_calc( WC_WORK, wkind, xopen, yopen, 16, 16, &xo, &yo, &dummy, &dummy ) ;
  wind_calc( WC_BORDER, wkind, xo, yo, w, h, &xo, &yo, &wo, &ho ) ;
  if (xopen+wo > Xmax) wo = w-(xopen+wo-Xmax) ;
  if (yopen+ho > Ymax) ho = h-(yopen+ho-Ymax) ;
  *xout = xo ; *yout = yo ;
  *wout = wo ;  *hout = ho ;
}

GEM_WINDOW *VImgCreateWindow(void)
{
  GEM_WINDOW *gwnd ;
  int        wkind ;

  wkind = NAME|CLOSER|FULLER|MOVER|INFO|SIZER|UPARROW|DNARROW|VSLIDE|LFARROW|RTARROW|HSLIDE ;
  if ( !config.w_info ) wkind &= ~INFO ;
  wkind |= SMALLER ;
  gwnd = GWCreateWindow( wkind, sizeof(VXIMAGE), VIMG_CLASSNAME ) ;
  if ( gwnd )
  {
    VXIMAGE *vximage = (VXIMAGE *) gwnd->Extension ;

    InitializeListHead( &vximage->UndoListHead ) ;
  }

  return( gwnd ) ;
}

static char* VImgGetWindowID(void *wnd)
{
  GEM_WINDOW* gwnd = (GEM_WINDOW*) wnd ;
  VXIMAGE*    vimage = (VXIMAGE*) gwnd->Extension ;

  return vimage->inf_img.filename ;
}

void AttachPictureToWindow(GEM_WINDOW *gwnd)
{
  VXIMAGE *vimage ;
  int     dummy, ww, wh ;
  char    *pt ;

  /* R�ponses aux �v�nements */
  gwnd->OnClose         = OnVImgClose ;
  gwnd->OnTopped        = OnVImgTopped ;
  gwnd->OnKeyPressed    = OnVImgKeyPressed ;
  gwnd->OnMenuSelected  = OnVImgMenuSelected ;
  gwnd->OnDraw          = OnVImgDraw ;
  gwnd->OnArrow         = OnVImgArrow ;
  gwnd->OnHSlider       = OnVImgHSlider ;
  gwnd->OnVSlider       = OnVImgVSlider ;
  gwnd->OnSize          = OnVImgSize ;
  gwnd->OnFulled        = OnVImgFulled ;
  gwnd->OnRestoreFulled = OnVImgRestoreFulled ;
  gwnd->OnMouseMove     = OnVImgMouseMove ;
  gwnd->OnIconify       = OnVImgIconify ;
  gwnd->OnUnIconify     = OnVImgUnIconify ;
  gwnd->OnLButtonDown   = OnVImgLButtonDown ;
  gwnd->OnRButtonDown   = OnVImgRButtonDown ;
  gwnd->OnDLButtonDown  = OnVImgDLButtonDown ;
  gwnd->OnDRButtonDown  = OnVImgDLButtonDown ;
  gwnd->ProgRange       = OnVImgProgRange ;
  gwnd->GetWindowID     = VImgGetWindowID ;

  vimage = (VXIMAGE *) gwnd->Extension ;
  vimage->inf_img.mfdb.fd_w = align16( vimage->inf_img.mfdb.fd_w ) ;
  vimage->x1          = 0 ;
  vimage->y1          = 0 ;
  vimage->x2          = vimage->inf_img.mfdb.fd_w-1 ;
  vimage->y2          = vimage->inf_img.mfdb.fd_h-1 ;
  vimage->zoom_level  = 1 ;
  pt = strrchr( vimage->inf_img.filename, '\\' ) ;
  if ( pt ) strcpy( vimage->nom, 1+pt ) ;
  GWSetWindowCaption( gwnd, vimage->nom ) ;
  gwnd->GetWorkXYWH( gwnd, &dummy, &dummy, &ww, &wh ) ;
  ww = (int) (1000.0*(double)ww/(double)vimage->inf_img.mfdb.fd_w) ;
  wh = (int) (1000.0*(double)wh/(double)vimage->inf_img.mfdb.fd_h) ;
  GWSetHSlider( gwnd, 1 ) ;
  GWSetVSlider( gwnd, 1 ) ;
  GWSetHSliderSize( gwnd, ww ) ;
  GWSetVSliderSize( gwnd, wh ) ;
  update_view( gwnd ) ;
  update_zview( gwnd ) ;
}

void load_wpicture(char *name, long lformat)
{
  GEM_WINDOW *gwnd, *wprog ;
  VXIMAGE    *vimage ;
  INFO_IMAGE inf ;
  int        w, h ;
  int        ret ;
#if !defined(__NO_LOGGING)
  char*      cf = (char*) &lformat ;
#endif

  gwnd = VImgCreateWindow() ;
  if ( gwnd )
  {
    vimage = (VXIMAGE *) gwnd->Extension ;

    /* Analyse de couleurs si mode 256 couleurs et flag non positionn� */
#if !defined(__NO_LOGGING)
    if ( cf[0] ) LoggingDo(LL_INFO, "Loading %s with format '%c%c%c'", name, cf[0], cf[1], cf[2]) ;
    else         LoggingDo(LL_INFO, "Loading %s with auto format", name) ;
#endif
    ret = vimg_format( lformat, -1, name, &inf ) ;
    if ( ret != 0 )
    {
      free_info( &inf ) ; /* Probably not necessary */
      switch( ret )
      {
        case EIMG_FILENOEXIST :        LoggingDo(LL_ERROR, "File %s can't be opened", name) ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_FILENOTEXIST) ) ;
                                       break ;
        case EIMG_DATAINCONSISTENT :   LoggingDo(LL_ERROR, "File %s is inconsistent", name) ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_ERRFORMAT) ) ;
                                       break ;
        case EIMG_NOMEMORY :           form_error(8) ;
                                       break ;
        case EIMG_DECOMPRESERR :       LoggingDo(LL_ERROR, "Data decompression error on file %s", name) ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_DECOMPRESERR) ) ;
                                       break ;
        case EIMG_UNKOWNFORMAT :
        case EIMG_OPTIONNOTSUPPORTED : LoggingDo(LL_WARNING, "Unknown file format or not supported feature for file %s, opening it as hex dump...", name) ;
                                       GWDestroyWindow( gwnd ) ;
                                       CreateHexDump( name ) ;
                                       return ;
        case EIMG_UNKNOWNCOMPRESSION : LoggingDo(LL_WARNING, "Unknown compression algorithm for file %s", name) ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_UNKNOWNCOMP) ) ;
                                       break ;
        case EIMG_USERCANCELLED :      LoggingDo(LL_INFO, "User cancelled loading for file %s", name) ;
                                       break ;
        case EIMG_NOJPEGDRIVER :       LoggingDo(LL_ERROR, "No JPEG driver for file %s", name) ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_NOJPEGDRIVER) ) ;
                                       break ;
        case EIMG_NOPNGSLB :           LoggingDo(LL_ERROR, "PNG shared library NOT found, please install it") ;
                                       form_stop(1, MsgTxtGetMsg(hMsg, MSG_NOPNGSLB) ) ;
                                       break ;
        case EIMG_NOPNGDRIVER :        LoggingDo(LL_ERROR, "No PNG driver for file %s", name) ;
                                       break ;
      }
      LoggingDo(LL_WARNING, "Failed to identify image %s:error %d", name, ret) ;
      return ;
    }

    if ( !( config.flags & FLG_DITHERAUTO ) &&
         !Truecolor && ( inf.nplanes > nb_plane )
       )
    {
      if (form_interrogation(1, MsgTxtGetMsg(hMsg, MSG_RESOLSCREEN) ) == 2)
      {
        GWDestroyWindow( gwnd ) ;
        free_info( &inf ) ;
        return ;
      }
    }

    inf.mfdb.fd_nplanes = nb_plane ;
    wprog = DisplayStdProg( MsgTxtGetMsg(hMsg, MSG_LOADINGIMG) , "", name, 0 ) ;
    mouse_busy() ;
    LoggingDo(LL_INFO, "Loading image file %s", name) ;
    inf.prog = wprog ;
    ret = vload_picture( &inf ) ;
    mouse_restore() ;
    GWDestroyWindow( wprog ) ;
    if ( ret == 0 )
    {
      int xo, yo, wo, ho ;

      log_event( CMD_DISPLAY, name ) ;
      if ( inf.multiple_images ) form_stop(1, MsgTxtGetMsg(hMsg, MSG_MULTIMG) ) ;
      memcpy( &vimage->inf_img, &inf, sizeof(INFO_IMAGE) ) ;
      w = vimage->inf_img.mfdb.fd_w ;
      h = vimage->inf_img.mfdb.fd_h ;
      open_where( gwnd->window_kind, w, h, &xo, &yo, &wo, &ho ) ;
      if ( GWOpenWindow( gwnd, xo, yo, wo, ho ) != 0 )
      {
        free_info( &inf ) ;
        GWDestroyWindow( gwnd ) ;
        form_stop(1, MsgTxtGetMsg(hMsg, MSG_NOMOREWINDOW) ) ;
        return ;
      }

      AttachPictureToWindow( gwnd ) ;
      if (config.flag_fullscreen) pleine_page( gwnd ) ;
    }
    else
    {
      switch(ret)
      {
        case -1 : form_stop(1, MsgTxtGetMsg(hMsg, MSG_FILENOTEXIST) ) ;
                  break ;
        case -2 : form_stop(1, MsgTxtGetMsg(hMsg, MSG_ERRFORMAT) ) ;
                  break ;
        case -3 : form_error(8) ;
                  break ;
        case -4 : form_stop(1, MsgTxtGetMsg(hMsg, MSG_DECOMPRESERR) ) ;
                  break ;
        case -5 : form_stop(1, MsgTxtGetMsg(hMsg, MSG_UNKNOWNFMT) ) ;
                  break ;
        case -9 : form_stop(1, MsgTxtGetMsg(hMsg, MSG_DSPISLOCKED) ) ;
                  break ;
      }
      LoggingDo(LL_WARNING, "Failed to load image %s:error %d", name, ret) ;
      GWDestroyWindow( gwnd ) ;
    }
  }
  else
    form_stop(1, MsgTxtGetMsg(hMsg, MSG_NOMOREWINDOW) ) ;
}

void traite_slideshow(char *name)
{
  VSS_INFO vss_info ;
  int      err ;
  char     buf[200] ;

  err = vss_load( name, &vss_info ) ;
  switch( err )
  {
    case VSSERR_NOERROR    : vss_doslideshow( &vss_info ) ;
                             vss_free( &vss_info ) ;
                             break ;
    case VSSERR_FILE       : form_stop(1, MsgTxtGetMsg(hMsg, MSG_FILENOTEXIST) ) ;
                             break ;
    case VSSERR_MEMORY     : form_error( 8 ) ;
                             break ;
    case VSSERR_CMDUNKNOWN : sprintf( buf, MsgTxtGetMsg(hMsg, MSG_VSSERRCMDU) , vss_info.line_err ) ;
                             form_stop( 1, buf ) ;
                             break ;
  }
}

void traite_ouvre(int flag)
{
  int  valid ;
  char name[PATH_MAX] ;
  char path[PATH_MAX] ;

  if ( *last_path == 0 ) strcpy( path, config.path_img ) ;
  else                   strcpy( path, last_path ) ;
  strcat( path, "\\*.*" ) ;
  valid = file_name( path, "", name ) ;

  if ( valid )
  {
    long lfmt = 0 ;
    char ext[5] ;
    char *last_slash ;

    strcpy( last_path, name ) ;
    last_slash = strrchr( last_path, '\\' ) ;
    if ( last_slash ) *last_slash = 0 ;
    else              *last_path  = 0 ;
    if ( flag )
    {
      lfmt = get_format( &decoup, 0 ) ;
      if ( lfmt == 0 ) return ;
    }

    get_ext( name, ext ) ;
    if ( strcmpi( ext, "VIC" ) == 0 ) traite_album( name ) ;
    else if ( strcmpi( ext, "VSS" ) == 0 ) traite_slideshow( name ) ;
#ifndef __NO_SCRIPT
    else if ( strcmpi( ext, "VCS" ) == 0 ) traite_command_script( name ) ;
#endif
    else
    {
      if ( lfmt == IID_HEXDUMP ) CreateHexDump( name ) ;
      else                       load_wpicture( name, lfmt ) ;
    }                       
  }
}

int input_format(GEM_WINDOW *gwnd)
{
  VXIMAGE*    vimage ;
  INFO_IMAGE* inf_img ;
  
  if ( gwnd == NULL ) return( -1 ) ;
  vimage = (VXIMAGE *) gwnd->Extension ;
  inf_img = &vimage->inf_img ;

  inf_img->lformat = get_format( &decoup, 1 ) ;

  if ( inf_img->lformat == IID_UNKNOWN ) return -1 ;

  if ( inf_img->lformat == IID_JPEG ) return( jpeg_options( inf_img ) ) ;

  if ( inf_img->lformat == IID_TARGA ) return( targa_options( inf_img ) ) ;

  if ( inf_img->lformat == IID_TIFF )
  {
    if ( ( inf_img->palette == NULL ) && !Truecolor )
    {
      size_t taille ;
      int    pal[256*6] ;

      taille = (1 << inf_img->nplanes)*6 ;
      inf_img->palette = Xalloc(taille) ;
      if (inf_img->palette == NULL)
        form_error(8) ;
      else
      {
        get_tospalette(pal) ;
        memcpy(inf_img->palette, pal, taille) ;
        inf_img->nb_cpal = 1 << inf_img->nplanes ;
      }
    }
    return( tiff_options( inf_img ) ) ;
  }

  if ( inf_img->lformat == IID_GIF )
  {
    if ( inf_img->palette == NULL )
    {
      size_t taille ;
      int    pal[256*6] ;

      taille = (1 << inf_img->nplanes)*6 ;
      inf_img->palette = Xalloc(taille) ;
      if (inf_img->palette == NULL)
        form_error(8) ;
      else
      {
        get_tospalette(pal) ;
        memcpy(inf_img->palette, pal, taille) ;
        inf_img->nb_cpal = 1 << inf_img->nplanes ;
      }
    }
  }

  if ( inf_img->lformat == IID_IMG )
  {
    if ( inf_img->palette == NULL )
    {
      size_t taille ;
      int    pal[256*6] ;

      taille = (1 << inf_img->nplanes)*6 ;
      inf_img->palette = Xalloc(taille) ;
      if (inf_img->palette == NULL)
        form_error(8) ;
      else
      {
        get_tospalette(pal) ;
        memcpy(inf_img->palette, pal, taille) ;
        inf_img->nb_cpal = 1 << inf_img->nplanes ;
      }
    }
  } 

  if ( inf_img->lformat == IID_DEGAS )
  {
    inf_img->compress = 0 ;
  }

  return( 0 ) ;
}

void traite_sauves(GEM_WINDOW *gwnd, int flag)
{
  IMG_MODULE* img_module ;
  VXIMAGE*    vimage ;
  INFO_IMAGE* inf_vimage ;
  int         res ;
  int         valid = 1 ;
  char        name[256] ;

  if ( !gwnd ) return ;

  vimage     = (VXIMAGE*) gwnd->Extension ;
  inf_vimage = &vimage->inf_img ;
  /* Si l'image a �t� tram�e, demander un nouveau nom de sauvegarde */
  if ( vimage->inf_img.multiple_images || vimage->inf_img.has_been_dithered ) flag = 1 ;

  if ( flag == 0 )
  {
    int i = 0 ;
    
    while (vimage->nom[i] == '*') i++ ;
    strcpy(name, &vimage->nom[i]) ;
    img_module = DImgGetModuleFromIID( inf_vimage->lformat ) ;
  }
  else
  {
    char path[PATH_MAX] ;
    char buf[30] ;

    if ( input_format( gwnd ) == -1 ) return ;

    if ( *last_path == 0 ) strcpy( path, config.path_img ) ;
    else                   strcpy( path, last_path ) ;

    img_module = DImgGetModuleFromIID( inf_vimage->lformat ) ;
    if ( img_module )
    {
      sprintf( buf, "\\*.%s", img_module->Capabilities.file_extension ) ;
      strcat( path, buf ) ;
      valid = file_name( path, "", name ) ;
    }

    if ( img_module == NULL )
    {
      form_stop( 1,MsgTxtGetMsg(hMsg, MSG_UNKNOWNSAVE)  ) ;
      return ;
    }
  }

	if ( valid )
	{
    GEM_WINDOW *wprog ;
	  DECOUP     dcp ;
	  INFO_IMAGE inf ;
	  MFDB       raster ;
	  int        xy[8] ;
	  int        x, y ;
	  int        r = 1 ;
	  int        has_been_cancelled = 0 ;
	  int        num, rx, ry ;
	  char       pre_name[256] ;
	  char       post_name[50] ;

      inf_vimage->nplanes = vimage->inf_img.mfdb.fd_nplanes ;
      memcpy( &inf, inf_vimage, sizeof(INFO_IMAGE) ) ;
      memcpy( &raster, &vimage->inf_img.mfdb, sizeof(MFDB) ) ;
      memcpy( &dcp, &decoup, sizeof(DECOUP) ) ;

      if ( dcp.valid )
      {
        char *last_slash, *point ;

        num = dcp.num ;
        ry  = 0 ;
        last_slash = strrchr( name, '\\' ) ;
        if ( last_slash == NULL ) return ;
        point = strrchr( name, '.' ) ;
        if  ( point == NULL ) point = &name[strlen(name)-1] ;
        if ( point - last_slash <= 6 ) *point = 0 ;
        else                           *(last_slash+6) = 0 ;
        strcpy( pre_name, name ) ;
        strcpy( post_name, 1+point ) ;
        raster.fd_w    = raster.fd_w / dcp.nb_colonnes ;
        raster.fd_h    = raster.fd_h / dcp.nb_lignes ;
        raster.fd_addr = img_alloc( raster.fd_w, raster.fd_h, raster.fd_nplanes ) ;
        if ( raster.fd_addr == NULL )
        {
          form_error( 8 ) ;
          return ;
        }
        raster.fd_wdwidth = w2wdwidth( raster.fd_w ) ;
        inf.width  = raster.fd_w ;
        inf.height = raster.fd_h ;
      }
      else dcp.nb_colonnes = dcp.nb_lignes = 1 ;

      for ( y = 0; y < dcp.nb_lignes; y++ )
      {
        rx = 0 ;
        for ( x = 0; x < dcp.nb_colonnes; x++ )
        {
          if ( dcp.valid )
          {
            if ( *post_name) sprintf( name, "%s%02d.%s", pre_name, num++, post_name ) ;
            else             sprintf( name, "%s%02d", pre_name, num++ ) ;
          }
          if ( FileExist( name ) && ( flag == 1 ) )
            r = form_interrogation( 2, MsgTxtGetMsg(hMsg, MSG_FILEEXISTS)  ) ;
          if ( r != 2 )
          {
            if ( dcp.valid )
            {
              img_raz( &raster ) ;
              xy[0] = rx ; xy[1] = ry ;
              xy[2] = xy[0] + raster.fd_w - 1 ;
              if ( xy[2] >= vimage->inf_img.mfdb.fd_w ) xy[2] = vimage->inf_img.mfdb.fd_w - 1 ;
              xy[3] = xy[1] + raster.fd_h - 1 ;
              if ( xy[3] >= vimage->inf_img.mfdb.fd_h ) xy[3] = vimage->inf_img.mfdb.fd_h - 1 ;
              xy[4] = xy[5] = 0 ;
              xy[6] = xy[4] + ( xy[2]-xy[0] ) ;
              xy[7] = xy[5] + ( xy[3]-xy[1] ) ;
              vro_cpyfm( handle, S_ONLY, xy, &vimage->inf_img.mfdb, &raster ) ;
              rx += raster.fd_w ;
            }

            wprog = DisplayStdProg( MsgTxtGetMsg(hMsg, MSG_SAVINGIMG) , "", name, CLOSER ) ;
            res = vsave_picture( name, &raster, &inf, wprog ) ;
            GWDestroyWindow( wprog ) ;
            switch( res )
            {
              case EIMG_FILENOEXIST :
              case EIMG_DATAINCONSISTENT :   form_stop(1,MsgTxtGetMsg(hMsg, MSG_WRITEERROR) ) ;
                                             break ;
              case EIMG_NOMEMORY :           form_error(8) ;
                                             break ;
              case EIMG_DECOMPRESERR :       form_stop(1,MsgTxtGetMsg(hMsg, MSG_ERRIMGFMT) ) ;
                                             break ;
              case EIMG_UNKOWNFORMAT :       form_stop(1,MsgTxtGetMsg(hMsg, MSG_UNKNOWNSAVE) ) ;
                                             break ;
              case EIMG_OPTIONNOTSUPPORTED : form_stop(1,MsgTxtGetMsg(hMsg, MSG_FMTNOSUPPORT) ) ;
                                             break ;
            }
          }
          else has_been_cancelled = 1 ;
          r = 1 ;
        }
        ry += raster.fd_h ;
      }

      if ( !has_been_cancelled )
      {
        strcpy( vimage->nom, name ) ;
        GWSetWindowCaption( gwnd, vimage->nom ) ;
        vimage->modif = 0 ;
        if ( UseStdVDI && Truecolor ) GWInvalidate( gwnd ) ; /* En True Color, l'image passe en format TC standard "sur place" */
      }
      if ( dcp.valid ) Xfree( raster.fd_addr ) ;
	}
}

int vimg_format(IID format, char img_analyse, char* filename, INFO_IMAGE* inf)
{
  inf->lformat       = format ;
  inf->dither_method = config.dither_method ;
  if ( img_analyse == -1 )
  {
    if ( ( config.color_protect != 0 ) && ( nb_colors == 256 ) ) inf->img_analyse = 1 ;
    else                                                         inf->img_analyse = 0 ;
  }
  else inf->img_analyse = img_analyse ;

  return img_format( filename, inf ) ;
}

int vload_picture(INFO_IMAGE* inf)
{
  if ( nb_plane == 16 ) inf->force_16b_load = 1 ;
  else                  inf->force_16b_load = 0 ;

  return load_picture( inf ) ;
}

int vsave_picture(char* name, MFDB* raster, INFO_IMAGE* inf, GEM_WINDOW* wprog )
{
  char software_name[64] ;

  sprintf( software_name, "VISION %s", config.version ) ;
  inf->SoftwareName = software_name ;

  return save_picture( name, raster, inf, wprog ) ;
}
