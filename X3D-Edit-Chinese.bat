@ECHO OFF > NUL

REM	Batch file:  X3D-Edit-Chinese.bat
REM                  http://www.web3D.org/x3d/content/X3D-Edit-Chinese.bat
REM	Author:      Don Brutzman and yiqi meng
REM	Created:      9 February 2003
REM	Revised:     27 December 2005
REM     Description: Launch X3D-Edit profile for x3d-3.1.profileChinese.xml
REM	             override other language preference variable (if any)

@echo SET X3dLanguagePreference=Chinese
SET X3dLanguagePreference=Chinese
X3D-Edit.bat %1 %2 %3 %4

