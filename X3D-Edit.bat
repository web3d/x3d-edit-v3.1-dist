@ECHO OFF > NUL

@ECHO =======================================================================
REM	Batch file:  X3D-Edit.bat  X3D-Edit-3.1.bat
REM                  http://www.web3d.org/TaskGroups/x3d/content/X3D-Edit.bat
REM	Author:      Don Brutzman
REM	Affiliation: Naval Postgraduate School
REM	Created:     30 April 2005
REM	Revised:     2 February 2006
REM     Description: Launch X3D-Edit profile for x3d-3.1 using Xeena 1.2EA
REM     License:     license.html

REM -------------------------------------------------------------------------
REM -------------------------------------------------------------------------

REM *** User editing is allowed between ----- double lines ----- as follows.

REM ***	Choose default tooltip language via environment variable or override.
REM ***	Edit the following directories as needed to match your installation.
REM ***	You may also need to check X3D-Edit's modified C:\IBM\Xeena\Xeena.bat

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM Language selection

REM Delete 'REM' before your language of choice, or else
REM set X3dLanguagePreference as an environment variable
REM in your operating system (as described in README file).
REM Default language preference is English.

REM	SET X3dLanguagePreference=Chinese
REM	SET X3dLanguagePreference=English
REM	SET X3dLanguagePreference=French
REM	SET X3dLanguagePreference=German
REM	SET X3dLanguagePreference=Italian
REM	SET X3dLanguagePreference=Portuguese
REM	SET X3dLanguagePreference=Spanish

REM	Under development, in progress:
REM	SET X3dLanguagePreference=Croatian
REM	SET X3dLanguagePreference=Russian

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM Local directory configuration (risky business, breaks easy updates, etc.)

REM ***	Edit warning:  no whitespace allowed on either side of = equal signs!

SET XEENA_LOCATION=.

REM SET CONTENT_DRIVE=C:

SET CONTENT_LOCATION=.

SET     DTD_LOCATION=SchemaDTD
REM SET DTD_LOCATION=\www.web3d.org\TaskGroups\x3d\translation

REM	Transitional DOCTYPE location - only used if X3D-Edit must stay offline
REM SET	DTD_LOCATION=\www.web3d.org\TaskGroups\x3d\translation

SET     X3D_DTD=x3d-3.1.dtd

REM 	X3D tagset and DTD status available in
REM	http://www.web3d.org/specifications/x3d-dtd-changelog.txt

REM -------------------------------------------------------------------------
REM -------------------------------------------------------------------------

REM ***	Stop!!  No need for further user editing after this point. ***

REM -------------------------------------------------------------------------
REM -------------------------------------------------------------------------

REM	Begin system section of X3D-Edit batch file.

REM	Don't add '.xml' to profile name since language name gets inserted
SET	PROFILE=x3d-3.1

SET EXAMPLES_DIR=examples

SET X3D_EDIT_DIR=%CONTENT_LOCATION%

SET X3D_EDIT_VERSION=v3.1 using x3d-3.1.dtd (X3D International Specification Amendment 1)

SET X3D_EDIT_SITE=docs

SET READMEFILE=README.X3D-Edit.html

SET CLASSPATH=%CLASSPATH%;.

REM -------------------------------------------------------------------------

@ECHO X3D-Edit %X3D_EDIT_VERSION%

REM -------------------------------------------------------------------------

REM note that profile must be in same directory as DTD

SET X3dLanguagePreferenceProfile=%PROFILE%.profile.xml
IF '%X3dLanguagePreference%'=='' SET X3dLanguagePreference=English
@ECHO Tooltips language:  %X3dLanguagePreference%
IF '%X3dLanguagePreference%'==''        GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='English' GOTO EQUALBAR
REM reset profile name to match different language
SET X3dLanguagePreferenceProfile=%PROFILE%.profile%X3dLanguagePreference%.xml

IF '%X3dLanguagePreference%'=='Chinese'    GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='Croatian'   @echo [Croatian language support under development.]
IF '%X3dLanguagePreference%'=='Croatian'   GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='English'    GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='French'     GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='German'     GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='Italian'    GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='Portuguese' @echo [Portuguese language support under development.]
IF '%X3dLanguagePreference%'=='Portuguese' GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='Russian'    @echo [Russian language support under development.]
IF '%X3dLanguagePreference%'=='Russian'    GOTO EQUALBAR
IF '%X3dLanguagePreference%'=='Spanish'    GOTO EQUALBAR

@echo *** Illegal X3dLanguagePreference language!
@echo *** Supported tooltips languages:  English (default), Chinese, Croatian, French, German, Italian, Portuguese, Spanish
PAUSE
SET X3dLanguagePreferenceProfile=%PROFILE%.profile.xml

:EQUALBAR

@echo X3D_DTD=%DTD_LOCATION%\%X3D_DTD%

@ECHO =======================================================================
@ECHO Support:  e-mail problem summary and command console output to
@ECHO           mailto:brutzman@nps.edu or mailto:x3d-public@web3d.org
@ECHO           %X3D_EDIT_SITE%/%READMEFILE%
REM   Warning:  online operation only with scenes using final X3D DTD!


IF EXIST %DTD_LOCATION%\%X3D_DTD% GOTO ENVIRONMENT_OK

@ECHO %DTD_LOCATION%\%X3D_DTD% not found
@ECHO Possible causes:  improper installation, or your operating system might be out of environment space.
@ECHO See README.X3D-Edit section on Bugfixes at
@ECHO http://www.web3d.org/x3d/content/README.X3D-Edit.html#Bugfixes
pause
@GOTO DONE

:ENVIRONMENT_OK
REM @echo ENVIRONMENT_OK

@TYPE build.date.X3D-Edit.txt

@ECHO Make default newScene.x3d available just in case network is offline
ATTRIB -R          %CONTENT_LOCATION%\examples\newScene.x3d
java X3dDtdChecker %CONTENT_LOCATION%\examples\newScene.x3d -setTransitionalDTD
ATTRIB +R          %CONTENT_LOCATION%\examples\newScene.x3d

REM Drag+Drop doesn't always wrap filename in "quotes" so be careful about doubly wrapped quoting & hanging

IF '%1'==''									GOTO DEFAULT_NAME
IF '%1'=='%EXAMPLES_DIR%\newScene.x3d'						GOTO DEFAULT_NAME
IF '%1'=='%EXAMPLES_DIR%/newScene.x3d'						GOTO DEFAULT_NAME
IF '%1'=='"%EXAMPLES_DIR%\newScene.x3d"'					GOTO DEFAULT_NAME
IF '%1'=='"%EXAMPLES_DIR%/newScene.x3d"'					GOTO DEFAULT_NAME
IF '%1'=='"%CONTENT_LOCATION%\%EXAMPLES_DIR%\newScene.x3d"'			GOTO DEFAULT_NAME
IF '%1'=='"%CONTENT_LOCATION%\%EXAMPLES_DIR%\newScene.x3d"'	GOTO DEFAULT_NAME
IF '%1'=='%CONTENT_LOCATION%\%EXAMPLES_DIR%\newScene.x3d'			GOTO DEFAULT_NAME
IF '%1'=='%CONTENT_LOCATION%\%EXAMPLES_DIR%\newScene.x3d'	GOTO DEFAULT_NAME
IF EXIST %1  									GOTO COMMAND_LINE
IF EXIST '%1'									GOTO COMMAND_LINE_ADD_TICKS
IF EXIST '%CONTENT_LOCATION%\%1'					GOTO RELATIVE_NAME

GOTO NOT_FOUND

REM ==================================================================
:RELATIVE_NAME
@ECHO X3D-Edit startup using path\file specified on command line
@ECHO via relative path:  %CONTENT_LOCATION%\%1

java X3dDtdChecker %CONTENT_LOCATION%\%1 -setTransitionalDTD
REM @echo ERRORLEVEL=%ERRORLEVEL%
IF NOT ERRORLEVEL 0 EXIT

@ECHO  %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml '%1'
cmd /c %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml '%1'

java X3dDtdChecker %CONTENT_LOCATION%\%1 -setFinalDTD
@GOTO DONE

REM ==================================================================
:COMMAND_LINE
@ECHO X3D-Edit startup using path\files specified by command line,
@ECHO   by clicking or by drag + drop:

java X3dDtdChecker %1 -setTransitionalDTD
REM @echo ERRORLEVEL=%ERRORLEVEL%
IF NOT ERRORLEVEL 0 EXIT

@ECHO  %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml %1
cmd /c %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml %1

java X3dDtdChecker %1 -setFinalDTD
@GOTO DONE

REM ==================================================================
:COMMAND_LINE_ADD_TICKS
@ECHO X3D-Edit startup using path\file specified on command line, wrapping quotes:

java X3dDtdChecker '%1' -setTransitionalDTD
REM @echo ERRORLEVEL=%ERRORLEVEL%
IF NOT ERRORLEVEL 0 EXIT

@ECHO  %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml '%1'
cmd /c %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml '%1'

java X3dDtdChecker '%1' -setFinalDTD
@GOTO DONE

REM ==================================================================
:NOT_FOUND
@ECHO [Warning] file %1 not found!

REM ==================================================================
:DEFAULT_NAME
@ECHO X3D-Edit startup using read-only default file "examples\newScene.x3d"

@ECHO Set "%EXAMPLES_DIR%\newScene.x3d" writable to temporarily assign Transitional DTD
ATTRIB -R "%EXAMPLES_DIR%\newScene.x3d"
java X3dDtdChecker  "%EXAMPLES_DIR%\newScene.x3d" -setTransitionalDTD
@ECHO Set "%EXAMPLES_DIR%\newScene.x3d" read-only to prevent over-writing
ATTRIB +R "%EXAMPLES_DIR%\newScene.x3d"
REM @echo ERRORLEVEL=%ERRORLEVEL%
IF NOT ERRORLEVEL 0 EXIT

@ECHO  %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml "%EXAMPLES_DIR%\newScene.x3d"
cmd /c %XEENA_LOCATION%\xeena.bat -dtd "%DTD_LOCATION%\%X3D_DTD%" -root X3D -profile "%X3dLanguagePreferenceProfile%" -xml "%EXAMPLES_DIR%\newScene.x3d"

@ECHO Set "%EXAMPLES_DIR%\newScene.x3d" writable to restore final DTD
ATTRIB -R "%EXAMPLES_DIR%\newScene.x3d"
java X3dDtdChecker  "%EXAMPLES_DIR%\newScene.x3d" -setFinalDTD
@ECHO Set "%EXAMPLES_DIR%\newScene.x3d" read-only to prevent over-writing
ATTRIB +R "%EXAMPLES_DIR%\newScene.x3d"

REM ==================================================================
:DONE

ATTRIB -R          %CONTENT_LOCATION%\examples\newScene.x3d
java X3dDtdChecker %CONTENT_LOCATION%\examples\newScene.x3d -setFinalDTD
ATTRIB +R          %CONTENT_LOCATION%\examples\newScene.x3d

@ECHO X3D-Edit complete.

REM	PAUSE to view console output before final exit

