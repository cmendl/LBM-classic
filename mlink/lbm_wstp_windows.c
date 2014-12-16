/*
 * This file automatically produced by wsprep from:
 *	lbm.tm
 * mprep Revision 18 Copyright (c) Wolfram Research, Inc. 1990-2013
 */

#define MPREP_REVISION 18


#include "wstp.h"

int WSAbort = 0;
int WSDone  = 0;
long WSSpecialCharacter = '\0';
HANDLE WSInstance = (HANDLE)0;
HWND WSIconWindow = (HWND)0;

WSLINK stdlink = 0;
WSEnvironment stdenv = 0;
#if WSINTERFACE >= 3
WSYieldFunctionObject stdyielder = (WSYieldFunctionObject)0;
WSMessageHandlerObject stdhandler = (WSMessageHandlerObject)0;
#else
WSYieldFunctionObject stdyielder = 0;
WSMessageHandlerObject stdhandler = 0;
#endif /* WSINTERFACE >= 3 */

#include <windows.h>

#if defined(__GNUC__)

#	ifdef TCHAR
#		undef TCHAR
#	endif
#	define TCHAR char

#	ifdef PTCHAR
#		undef PTCHAR
#	endif
#	define PTCHAR char *

#	ifdef __TEXT
#		undef __TEXT
#	endif
#	define __TEXT(arg) arg

#	ifdef _tcsrchr
#		undef _tcsrchr
#	endif
#	define _tcsrchr strrchr

#	ifdef _tcscat
#		undef _tcscat
#	endif
#	define _tcscat strcat

#	ifdef _tcsncpy
#		undef _tcsncpy
#	endif
#	define _tcsncpy _fstrncpy
#else
#	include <tchar.h>
#endif

#include <stdlib.h>
#include <string.h>
#if (WIN32_WSTP || WIN64_WSTP || __GNUC__) && !defined(_fstrncpy)
#       define _fstrncpy strncpy
#endif

#ifndef CALLBACK
#define CALLBACK FAR PASCAL
typedef LONG LRESULT;
typedef unsigned int UINT;
typedef WORD WPARAM;
typedef DWORD LPARAM;
#endif


LRESULT CALLBACK WSEXPORT
IconProcedure( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

LRESULT CALLBACK WSEXPORT
IconProcedure( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch( msg){
	case WM_CLOSE:
		WSDone = 1;
		WSAbort = 1;
		break;
	case WM_QUERYOPEN:
		return 0;
	}
	return DefWindowProc( hWnd, msg, wParam, lParam);
}


#ifdef _UNICODE
#define _APISTR(i) L ## #i
#else
#define _APISTR(i) #i
#endif

#define APISTR(i) _APISTR(i)

HWND WSInitializeIcon( HINSTANCE hInstance, int nCmdShow)
{
	TCHAR path_name[260];
	PTCHAR icon_name;

	WNDCLASS  wc;
	HMODULE hdll;

	WSInstance = hInstance;
	if( ! nCmdShow) return (HWND)0;

	hdll = GetModuleHandle( __TEXT("ml32i" APISTR(WSINTERFACE)));

	(void)GetModuleFileName( hInstance, path_name, 260);

	icon_name = _tcsrchr( path_name, '\\') + 1;
	*_tcsrchr( icon_name, '.') = '\0';


	wc.style = 0;
	wc.lpfnWndProc = IconProcedure;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hInstance;

	if( hdll)
		wc.hIcon = LoadIcon( hdll, __TEXT("MLIcon"));
	else
		wc.hIcon = LoadIcon( NULL, IDI_APPLICATION);

	wc.hCursor = LoadCursor( NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)( COLOR_WINDOW + 1);
	wc.lpszMenuName =  NULL;
	wc.lpszClassName = __TEXT("mprepIcon");
	(void)RegisterClass( &wc);

	WSIconWindow = CreateWindow( __TEXT("mprepIcon"), icon_name,
			WS_OVERLAPPEDWINDOW | WS_MINIMIZE, CW_USEDEFAULT,
			CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
			(HWND)0, (HMENU)0, hInstance, (void FAR*)0);

	if( WSIconWindow){
		ShowWindow( WSIconWindow, SW_MINIMIZE);
		UpdateWindow( WSIconWindow);
	}
	return WSIconWindow;
}


#if __BORLANDC__
#pragma argsused
#endif

#if WSINTERFACE >= 3
WSYDEFN( int, WSDefaultYielder, ( WSLINK mlp, WSYieldParameters yp))
#else
WSYDEFN( devyield_result, WSDefaultYielder, ( WSLINK mlp, WSYieldParameters yp))
#endif /* WSINTERFACE >= 3 */
{
	MSG msg;

#if !__BORLANDC__
	mlp = mlp; /* suppress unused warning */
	yp = yp; /* suppress unused warning */
#endif

	if( PeekMessage( &msg, (HWND)0, 0, 0, PM_REMOVE)){
		TranslateMessage( &msg);
		DispatchMessage( &msg);
	}
	return WSDone;
}


/********************************* end header *********************************/


void LatticeBoltzmann P(( float _tp1, int _tp2, float * _tp3, int _tpl3, float * _tp4, int _tpl4, int * _tp5, long _tpl5));

#if WSPROTOTYPES
static int _tr0( WSLINK mlp)
#else
static int _tr0(mlp) WSLINK mlp;
#endif
{
	int	res = 0;
	float _tp1;
	int _tp2;
	float * _tp3;
	int _tpl3;
	float * _tp4;
	int _tpl4;
	int * _tp5;
	long _tpl5;
	if ( ! WSGetReal32( mlp, &_tp1) ) goto L0;
	if ( ! WSGetInteger( mlp, &_tp2) ) goto L1;
	if ( ! WSGetReal32List( mlp, &_tp3, &_tpl3) ) goto L2;
	if ( ! WSGetReal32List( mlp, &_tp4, &_tpl4) ) goto L3;
	if ( ! WSGetIntegerList( mlp, &_tp5, &_tpl5) ) goto L4;
	if ( ! WSNewPacket(mlp) ) goto L5;

	LatticeBoltzmann(_tp1, _tp2, _tp3, _tpl3, _tp4, _tpl4, _tp5, _tpl5);

	res = 1;
L5:	WSReleaseInteger32List( mlp, _tp5, _tpl5);
L4:	WSReleaseReal32List(mlp, _tp4, _tpl4);
L3:	WSReleaseReal32List(mlp, _tp3, _tpl3);
L2: L1: 
L0:	return res;
} /* _tr0 */


static struct func {
	int   f_nargs;
	int   manual;
	int   (*f_func)P((WSLINK));
	const char  *f_name;
	} _tramps[1] = {
		{ 5, 0, _tr0, "LatticeBoltzmann" }
		};

static const char* evalstrs[] = {
	"LatticeBoltzmann::usage = \"LatticeBoltzmann[omega_Real, numsteps",
	"_Integer, gravity_List, f0_List, type0_List] runs a Lattice Bolt",
	"zmann Method (LBM) simulation\"",
	(const char*)0,
	"LatticeBoltzmann::invalidOmega = \"'omega' parameter must be betw",
	"een 0 and 2\"",
	(const char*)0,
	"LatticeBoltzmann::invalidDimensionf0 = \"'f0' must be a Real32Lis",
	"t of length 9*dimX*dimY for dimension 2 (D2Q9), and 19*dimX*dimY",
	"*dimZ for dimension 3 (D3Q19)\"",
	(const char*)0,
	"LatticeBoltzmann::invalidDimensionType0 = \"'type0' must be an in",
	"teger list of length dimX*dimY for dimension 2 (D2Q9), and dimX*",
	"dimY*dimZ for dimension 3 (D3Q19)\"",
	(const char*)0,
	"LatticeBoltzmann::outOfMemory = \"malloc failed, probably out of ",
	"memory\"",
	(const char*)0,
	(const char*)0
};
#define CARDOF_EVALSTRS 5

static int _definepattern P(( WSLINK, char*, char*, int));

static int _doevalstr P(( WSLINK, int));

int  _WSDoCallPacket P(( WSLINK, struct func[], int));


#if WSPROTOTYPES
int WSInstall( WSLINK mlp)
#else
int WSInstall(mlp) WSLINK mlp;
#endif
{
	int _res;
	_res = WSConnect(mlp);
	if (_res) _res = _definepattern(mlp, (char *)"LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, f0_List, type0_List]", (char *)"{ omega, numsteps, gravity, f0, type0 }", 0);
	if (_res) _res = _doevalstr( mlp, 0);
	if (_res) _res = _doevalstr( mlp, 1);
	if (_res) _res = _doevalstr( mlp, 2);
	if (_res) _res = _doevalstr( mlp, 3);
	if (_res) _res = _doevalstr( mlp, 4);
	if (_res) _res = WSPutSymbol( mlp, "End");
	if (_res) _res = WSFlush( mlp);
	return _res;
} /* WSInstall */


#if WSPROTOTYPES
int WSDoCallPacket( WSLINK mlp)
#else
int WSDoCallPacket( mlp) WSLINK mlp;
#endif
{
	return _WSDoCallPacket( mlp, _tramps, 1);
} /* WSDoCallPacket */

/******************************* begin trailer ********************************/

#ifndef EVALSTRS_AS_BYTESTRINGS
#	define EVALSTRS_AS_BYTESTRINGS 1
#endif

#if CARDOF_EVALSTRS
static int  _doevalstr( WSLINK mlp, int n)
{
	long bytesleft, charsleft, bytesnow;
#if !EVALSTRS_AS_BYTESTRINGS
	long charsnow;
#endif
	char **s, **p;
	char *t;

	s = (char **)evalstrs;
	while( n-- > 0){
		if( *s == 0) break;
		while( *s++ != 0){}
	}
	if( *s == 0) return 0;
	bytesleft = 0;
	charsleft = 0;
	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = (long)(t - *p);
		bytesleft += bytesnow;
		charsleft += bytesnow;
#if !EVALSTRS_AS_BYTESTRINGS
		t = *p;
		charsleft -= WSCharacterOffset( &t, t + bytesnow, bytesnow);
		/* assert( t == *p + bytesnow); */
#endif
		++p;
	}


	WSPutNext( mlp, WSTKSTR);
#if EVALSTRS_AS_BYTESTRINGS
	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = (long)(t - *p);
		bytesleft -= bytesnow;
		WSPut8BitCharacters( mlp, bytesleft, (unsigned char*)*p, bytesnow);
		++p;
	}
#else
	WSPut7BitCount( mlp, (long_st)charsleft, (long_st)bytesleft);

	p = s;
	while( *p){
		t = *p; while( *t) ++t;
		bytesnow = t - *p;
		bytesleft -= bytesnow;
		t = *p;
		charsnow = bytesnow - WSCharacterOffset( &t, t + bytesnow, bytesnow);
		/* assert( t == *p + bytesnow); */
		charsleft -= charsnow;
		WSPut7BitCharacters(  mlp, charsleft, *p, bytesnow, charsnow);
		++p;
	}
#endif
	return WSError( mlp) == WSEOK;
}
#endif /* CARDOF_EVALSTRS */


static int  _definepattern( WSLINK mlp, char *patt, char *args, int func_n)
{
	WSPutFunction( mlp, "DefineExternal", (long)3);
	  WSPutString( mlp, patt);
	  WSPutString( mlp, args);
	  WSPutInteger( mlp, func_n);
	return !WSError(mlp);
} /* _definepattern */


int _WSDoCallPacket( WSLINK mlp, struct func functable[], int nfuncs)
{
#if WSINTERFACE >= 4
	int len;
#else
	long len;
#endif
	int n, res = 0;
	struct func* funcp;

	if( ! WSGetInteger( mlp, &n) ||  n < 0 ||  n >= nfuncs) goto L0;
	funcp = &functable[n];

	if( funcp->f_nargs >= 0
#if WSINTERFACE >= 4
	&& ( ! WSTestHead(mlp, "List", &len)
#else
	&& ( ! WSCheckFunction(mlp, "List", &len)
#endif
	     || ( !funcp->manual && (len != funcp->f_nargs))
	     || (  funcp->manual && (len <  funcp->f_nargs))
	   )
	) goto L0;

	stdlink = mlp;
	res = (*funcp->f_func)( mlp);

L0:	if( res == 0)
		res = WSClearError( mlp) && WSPutSymbol( mlp, "$Failed");
	return res && WSEndPacket( mlp) && WSNewPacket( mlp);
} /* _WSDoCallPacket */


wsapi_packet WSAnswer( WSLINK mlp)
{
	wsapi_packet pkt = 0;
#if WSINTERFACE >= 4
	int waitResult;

	while( ! WSDone && ! WSError(mlp)
		&& (waitResult = WSWaitForLinkActivity(mlp),waitResult) &&
		waitResult == WSWAITSUCCESS && (pkt = WSNextPacket(mlp), pkt) &&
		pkt == CALLPKT)
	{
		WSAbort = 0;
		if(! WSDoCallPacket(mlp))
			pkt = 0;
	}
#else
	while( !WSDone && !WSError(mlp) && (pkt = WSNextPacket(mlp), pkt) && pkt == CALLPKT){
		WSAbort = 0;
		if( !WSDoCallPacket(mlp)) pkt = 0;
	}
#endif
	WSAbort = 0;
	return pkt;
}



/*
	Module[ { me = $ParentLink},
		$ParentLink = contents of RESUMEPKT;
		Message[ MessageName[$ParentLink, "notfe"], me];
		me]
*/

static int refuse_to_be_a_frontend( WSLINK mlp)
{
	int pkt;

	WSPutFunction( mlp, "EvaluatePacket", 1);
	  WSPutFunction( mlp, "Module", 2);
	    WSPutFunction( mlp, "List", 1);
		  WSPutFunction( mlp, "Set", 2);
		    WSPutSymbol( mlp, "me");
	        WSPutSymbol( mlp, "$ParentLink");
	  WSPutFunction( mlp, "CompoundExpression", 3);
	    WSPutFunction( mlp, "Set", 2);
	      WSPutSymbol( mlp, "$ParentLink");
	      WSTransferExpression( mlp, mlp);
	    WSPutFunction( mlp, "Message", 2);
	      WSPutFunction( mlp, "MessageName", 2);
	        WSPutSymbol( mlp, "$ParentLink");
	        WSPutString( mlp, "notfe");
	      WSPutSymbol( mlp, "me");
	    WSPutSymbol( mlp, "me");
	WSEndPacket( mlp);

	while( (pkt = WSNextPacket( mlp), pkt) && pkt != SUSPENDPKT)
		WSNewPacket( mlp);
	WSNewPacket( mlp);
	return WSError( mlp) == WSEOK;
}


#if WSINTERFACE >= 3
int WSEvaluate( WSLINK mlp, char *s)
#else
int WSEvaluate( WSLINK mlp, charp_ct s)
#endif /* WSINTERFACE >= 3 */
{
	if( WSAbort) return 0;
	return WSPutFunction( mlp, "EvaluatePacket", 1L)
		&& WSPutFunction( mlp, "ToExpression", 1L)
		&& WSPutString( mlp, s)
		&& WSEndPacket( mlp);
}


#if WSINTERFACE >= 3
int WSEvaluateString( WSLINK mlp, char *s)
#else
int WSEvaluateString( WSLINK mlp, charp_ct s)
#endif /* WSINTERFACE >= 3 */
{
	int pkt;
	if( WSAbort) return 0;
	if( WSEvaluate( mlp, s)){
		while( (pkt = WSAnswer( mlp), pkt) && pkt != RETURNPKT)
			WSNewPacket( mlp);
		WSNewPacket( mlp);
	}
	return WSError( mlp) == WSEOK;
} /* WSEvaluateString */


#if __BORLANDC__
#pragma argsused
#endif

#if WSINTERFACE >= 3
WSMDEFN( void, WSDefaultHandler, ( WSLINK mlp, int message, int n))
#else
WSMDEFN( void, WSDefaultHandler, ( WSLINK mlp, unsigned long message, unsigned long n))
#endif /* WSINTERFACE >= 3 */
{
#if !__BORLANDC__
	mlp = (WSLINK)0; /* suppress unused warning */
	n = 0;          /* suppress unused warning */
#endif

	switch (message){
	case WSTerminateMessage:
		WSDone = 1;
	case WSInterruptMessage:
	case WSAbortMessage:
		WSAbort = 1;
	default:
		return;
	}
}



#if WSINTERFACE >= 3
static int _WSMain( char **argv, char **argv_end, char *commandline)
#else
static int _WSMain( charpp_ct argv, charpp_ct argv_end, charp_ct commandline)
#endif /* WSINTERFACE >= 3 */
{
	WSLINK mlp;
#if WSINTERFACE >= 3
	int err;
#else
	long err;
#endif /* WSINTERFACE >= 3 */

#if WSINTERFACE >= 4
	if( !stdenv)
		stdenv = WSInitialize( (WSEnvironmentParameter)0);
#else
	if( !stdenv)
		stdenv = WSInitialize( (WSParametersPointer)0);
#endif

	if( stdenv == (WSEnvironment)0) goto R0;

	if( !stdyielder)
#if WSINTERFACE >= 3
		stdyielder = (WSYieldFunctionObject)WSDefaultYielder;
#else
		stdyielder = WSCreateYieldFunction( stdenv,
			NewWSYielderProc( WSDefaultYielder), 0);
#endif /* WSINTERFACE >= 3 */


#if WSINTERFACE >= 3
	if( !stdhandler)
		stdhandler = (WSMessageHandlerObject)WSDefaultHandler;
#else
	if( !stdhandler)
		stdhandler = WSCreateMessageHandler( stdenv,
			NewWSHandlerProc( WSDefaultHandler), 0);
#endif /* WSINTERFACE >= 3 */


	mlp = commandline
		? WSOpenString( stdenv, commandline, &err)
#if WSINTERFACE >= 3
		: WSOpenArgcArgv( stdenv, (int)(argv_end - argv), argv, &err);
#else
		: WSOpenArgv( stdenv, argv, argv_end, &err);
#endif
	if( mlp == (WSLINK)0){
		WSAlert( stdenv, WSErrorString( stdenv, err));
		goto R1;
	}

	if( WSIconWindow){
#define TEXTBUFLEN 64
		TCHAR textbuf[TEXTBUFLEN];
		PTCHAR tmlname;
		const char *mlname;
		size_t namelen, i;
		int len;
		len = GetWindowText(WSIconWindow, textbuf, 62 );
		mlname = WSName(mlp);
		namelen = strlen(mlname);
		tmlname = (PTCHAR)malloc((namelen + 1)*sizeof(TCHAR));
		if(tmlname == NULL) goto R2;

		for(i = 0; i < namelen; i++){
			tmlname[i] = mlname[i];
		}
		tmlname[namelen] = '\0';
		
#if defined(_MSC_VER) && (_MSC_VER >= 1400)
		_tcscat_s( textbuf + len, TEXTBUFLEN - len, __TEXT("("));
		_tcsncpy_s(textbuf + len + 1, TEXTBUFLEN - len - 1, tmlname, TEXTBUFLEN - len - 3);
		textbuf[TEXTBUFLEN - 2] = '\0';
		_tcscat_s(textbuf, TEXTBUFLEN, __TEXT(")"));
#else
		_tcscat( textbuf + len, __TEXT("("));
		_tcsncpy( textbuf + len + 1, tmlname, TEXTBUFLEN - len - 3);
		textbuf[TEXTBUFLEN - 2] = '\0';
		_tcscat( textbuf, __TEXT(")"));
#endif
		textbuf[len + namelen + 2] = '\0';
		free(tmlname);
		SetWindowText( WSIconWindow, textbuf);
	}

	if( WSInstance){
		if( stdyielder) WSSetYieldFunction( mlp, stdyielder);
		if( stdhandler) WSSetMessageHandler( mlp, stdhandler);
	}

	if( WSInstall( mlp))
		while( WSAnswer( mlp) == RESUMEPKT){
			if( ! refuse_to_be_a_frontend( mlp)) break;
		}

R2:	WSClose( mlp);
R1:	WSDeinitialize( stdenv);
	stdenv = (WSEnvironment)0;
R0:	return !WSDone;
} /* _WSMain */


#if WSINTERFACE >= 3
int WSMainString( char *commandline)
#else
int WSMainString( charp_ct commandline)
#endif /* WSINTERFACE >= 3 */
{
#if WSINTERFACE >= 3
	return _WSMain( (char **)0, (char **)0, commandline);
#else
	return _WSMain( (charpp_ct)0, (charpp_ct)0, commandline);
#endif /* WSINTERFACE >= 3 */
}

int WSMainArgv( char** argv, char** argv_end) /* note not FAR pointers */
{   
	static char FAR * far_argv[128];
	int count = 0;
	
	while(argv < argv_end)
		far_argv[count++] = *argv++;
		 
#if WSINTERFACE >= 3
	return _WSMain( far_argv, far_argv + count, (char *)0);
#else
	return _WSMain( far_argv, far_argv + count, (charp_ct)0);
#endif /* WSINTERFACE >= 3 */

}

#if WSINTERFACE >= 3
int WSMain( int argc, char **argv)
#else
int WSMain( int argc, charpp_ct argv)
#endif /* WSINTERFACE >= 3 */
{
#if WSINTERFACE >= 3
 	return _WSMain( argv, argv + argc, (char *)0);
#else
 	return _WSMain( argv, argv + argc, (charp_ct)0);
#endif /* WSINTERFACE >= 3 */
}
 
