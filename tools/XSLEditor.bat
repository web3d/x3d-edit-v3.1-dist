SET JAVA_HOME=c:\jdk1.1.8
SET SWING_HOME=d:\swing-1.0.3

SET XSLEditorDRIVE=d:
SET XSLEditorPATH=%XSLEditorDRIVE%\xml\XSLEditorV1PR1

SET CLASSPATH=.;%JAVA_HOME%\lib\classes.zip;%SWING_HOME%\swingall.jar;
SET CLASSPATH=%XSLEditorPATH%\Libraries\b2b.zip;%XSLEditorPATH%\Libraries\jface12.zip;%XSLEditorPATH%\Libraries\js.jar;%CLASSPATH%;
SET CLASSPATH=%XSLEditorPATH%\Libraries\lotusxsl.jar;%XSLEditorPATH%\Libraries\sop.zip;%XSLEditorPATH%\Libraries\TEdi.jar;%XSLEditorPATH%\Libraries\xml4j.jar;%CLASSPATH%;

REM SET PATH=.;%JAVA_HOME%\bin;%SystemRoot%\system32;%SystemRoot%;

ECHO %CLASSPATH%

rm -f %XSLEditorPATH%\working.cfg

%XSLEditorDRIVE%
cd %XSLEditorPATH%

java com.ibm.xsl.tedi.TEdi  c:\web3D\TaskGroups\x3d\translation\HelloWorld.xml c:\web3D\TaskGroups\x3d\translation\X3dToVrml97.xsl
REM java com.ibm.xsl.tedi.TEdi  Examples\orderlarger.xml Examples\order.xsl

