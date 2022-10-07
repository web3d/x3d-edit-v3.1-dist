@ECHO OFF > NUL

@ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

REM	Batch file:  X3dUnwrap.bat
REM	Author:      Don Brutzman
REM	Created:     5 January 2001
REM	Revised:     6 March 2004

REM -------------------------------------------------------------------------

REM	Edit the following directories as needed to match your installation.

SET  SAXON_LOCATION=c:\xml\saxon

SET VORLON_LOCATION=c:\vrml\vorlon

SET    X3D-EDIT-DIR=c:\www.web3D.org\x3d\content

SET   X3D-EDIT-SITE=http://www.web3D.org/x3d/content

SET XMLINT_LOCATION=c:\xml\microsoft

SET    VPP_LOCATION=%X3D-EDIT-DIR%

REM Saxon:   http://users.iclway.co.uk/mhkay/saxon

	SET SAXON_TIMING=no
REM	SET SAXON_TIMING=-t

REM Vorlon:  http://www.trapezium.com
REM vpp:     Bob Crispen's VRML Pages at hiwaay.net/~crispen/vrml
REM          edited copy included with bigger MAXBUFSIZE

REM -------------------------------------------------------------------------

if NOT EXIST %1.x3d	echo !
if NOT EXIST %1.x3d	echo Warning:  %1.x3d not found
if NOT EXIST %1.x3d	echo Usage:    X3dUnwrap fileName    (without .x3d extension!)
if NOT EXIST %1.x3d	echo Output:   fileNameUnwrapped.x3d
if NOT EXIST %1.x3d	exit

REM further safety tests require DOS command extensions?  bleah
REM if DEFINED %2	echo !
REM if DEFINED %2	echo Usage:  X3dUnwrap fileName    (without .x3d extension!)
REM if DEFINED %2	echo Output: fileNameUnwrapped.x3d
REM if DEFINED %2	exit

@echo Syntax check the XML input:

@ECHO ON
%XMLINT_LOCATION%\xmlint.exe %1.x3d
@ECHO OFF
@ECHO - - - - -

@ECHO Unwrap %1.x3d

@ECHO ON
%SAXON_LOCATION%\saxon.exe -t -o %1Unwrapped.x3d %1.x3d %X3D-EDIT-DIR%\X3dUnwrap.xslt
@ECHO OFF

DIR %1*.*/n

if -%2 == -same 	GOTO SAME_NAME
if -%2 == --same	GOTO SAME_NAME
if -%2 == -SAME 	GOTO SAME_NAME
if -%2 == --SAME	GOTO SAME_NAME

@ECHO - - - - -

@echo Syntax check the XML output:

@ECHO ON
%XMLINT_LOCATION%\xmlint.exe %1Unwrapped.x3d
@ECHO OFF


REM -------------------------------------------------------------------------

:SAME_NAME

mv  %1Unwrapped.x3d %1.x3d
DIR %1*.*/n

@ECHO - - - - -

@echo Syntax check the XML output:

@ECHO ON
%XMLINT_LOCATION%\xmlint.exe %1.x3d
@ECHO OFF


