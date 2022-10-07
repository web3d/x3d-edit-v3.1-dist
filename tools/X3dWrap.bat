@ECHO OFF > NUL

REM	Batch file:  X3dWrap.bat
REM	Author:      Don Brutzman
REM	Created:     29 July 2000
REM	Revised:     6 March 2004
REM -------------------------------------------------------------------------

REM	Edit the following directories as needed to match your installation.

SET  SAXON_LOCATION=c:\xml\saxon

SET VORLON_LOCATION=c:\vrml\vorlon

SET    X3D-EDIT-DIR=c:\www.web3D.org\TaskGroups\x3d\content

SET   X3D-EDIT-SITE=http://www.web3D.org/TaskGroups/x3d/content

SET XMLINT_LOCATION=c:\xml\microsoft

SET    VPP_LOCATION=%X3D-EDIT-DIR%

REM -------------------------------------------------------------------------

REM Saxon:   http://users.iclway.co.uk/mhkay/saxon
REM Vorlon:  http://www.trapezium.com
REM vpp:     Bob Crispen's VRML Pages at hiwaay.net/~crispen/vrml
REM          edited copy included with bigger MAXBUFSIZE

if NOT EXIST %1.x3d	echo !
if NOT EXIST %1.x3d	echo Warning:  %1.x3d not found
if NOT EXIST %1.x3d	echo Usage:    X3dWrap fileName    (without .x3d extension!)
if NOT EXIST %1.x3d	echo Output:   fileNameWrapped.x3d
if NOT EXIST %1.x3d	exit

REM further safety tests require DOS command extensions?  bleah
REM if DEFINED %2	echo !
REM if DEFINED %2	echo Usage:  X3dWrap fileName    (without .x3d extension!)
REM if DEFINED %2	echo Output: fileNameWrapped.x3d
REM if DEFINED %2	exit

@echo Syntax check the XML input:

@ECHO ON
%XMLINT_LOCATION%\xmlint.exe %1.x3d
@ECHO OFF
@ECHO - - - - -

@ECHO Wrap %1.x3d

@ECHO ON
%SAXON_LOCATION%\saxon.exe -t -o %1Wrapped.x3d %1.x3d %X3D-EDIT-DIR%\X3dWrap.xslt
@ECHO OFF

DIR /n %1.x3d %1Wrapped.x3d

@ECHO - - - - -

@echo Syntax check the XML output:

@ECHO ON
%XMLINT_LOCATION%\xmlint.exe %1.x3d
@ECHO OFF

@ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

