@echo off
rem Run XEENA - XML Editing Environment, Naturally in Java!
rem Brought to you by the IBM Haifa Research Lab, Israel
rem Please send feedback to helpmap@il.ibm.com
rem (C) 1999-2004 IBM Corporation. All rights reserved. 


rem -----------------------------------------------------------------------------------------------
rem To be able to run Xeena from any directory change XEENA_HOME to point to where it is installed
rem ----------------------------------------------------------------------------------------------- 
set XEENA_HOME=.
set PROXY_SETTINGS=-DproxySet=false
rem -----------------------------------------------------------------------------------------------
rem Change JAVA_HOME to point to where it is installed 
rem ----------------------------------------------------------------------------------------------- 
rem set JAVA_HOME=C:\programs\jdk1.3.1_04


set CLASSPATH=%XEENA_HOME%\lib\xmleditor.jar;%XEENA_HOME%\lib\xerces.jar;%XEENA_HOME%\lib\jgl3.1.0.jar;%XEENA_HOME%\lib\swingall.jar;%XEENA_HOME%\lib\xalan.jar;%XEENA_HOME%\lib\Vrml97ToX3dNist.jar;%XEENA_HOME%\lib\Vrml97ToX3dImport.jar;%XEENA_HOME%\vrtp\dis-java-vrml.jar;%CLASSPATH%
if exist %BML_HOME% set CLASSPATH=%BML_HOME%;%BML_HOME%\lib\bmlall.jar;%CLASSPATH%;.

rem -------------------------------------------------------------------
rem If you use Java 1 uncomment the 3 lines after 'rem JDK 1.1!' and 
rem comment the 3 lines after 'rem Java 2!' and vice versa
rem --------------------------------------------------------------------

rem JDK 1.1!
rem if not exist "%JAVA_HOME%\bin\jre.exe" goto nojre
rem echo running Xeena with JDK1.1
rem "%JAVA_HOME%\bin\jre.exe" -cp "%CLASSPATH%" %PROXY_SETTINGS% -Dswing.defaultlaf=com.sun.java.swing.plaf.windows.WindowsLookAndFeel -mx100m -ms30m com.ibm.hrl.xmleditor.Xeena %1 %2 %3 %4 %5 %6 %7 %8

rem Java 2!
if not exist "%JAVA_HOME%\bin\java.exe" goto nojava
echo running Xeena with Java 2
"%JAVA_HOME%\bin\java.exe" %PROXY_SETTINGS% -Dswing.defaultlaf=com.sun.java.swing.plaf.windows.WindowsLookAndFeel -Xmx100m -Xms30m com.ibm.hrl.xmleditor.Xeena %1 %2 %3 %4 %5 %6 %7 %8

goto done

:nojre
echo No jre.exe in %JAVA_HOME%\bin - please set the JAVA_HOME environment variable correctly in xeena.bat
pause

:nojava
java -Dswing.defaultlaf=com.sun.java.swing.plaf.windows.WindowsLookAndFeel -Xmx100m -Xms30m com.ibm.hrl.xmleditor.Xeena %1 %2 %3 %4 %5 %6 %7 %8

:done
