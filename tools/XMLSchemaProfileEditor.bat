@echo off
rem filename:  XmlSchemaProfileEditor.bat

rem author:    Don Brutzman

rem revised:   2 July 2001

set XEENA_HOME=C:\IBM\Xeena

rem Run XEENA to edit (or rebuild) a new XML Schema profile

echo -
echo Schema Recommendation sources
echo http://www.w3.org/2001/XMLSchema.html
echo http://www.w3.org/2001/XMLSchema.xsd
echo http://www.w3.org/2001/XMLSchema.dtd
echo http://www.w3.org/2001/datatypes.dtd

echo -
echo update public and system identifiers in the defaults tag:
echo file://localhost/C:/www.web3D.org/TaskGroups/x3d/translation/XMLSchema.dtd
echo file://localhost/C:/www.web3D.org/TaskGroups/x3d/translation/datatypes.dtd
echo http://www.w3.org/2001/XMLSchema.dtd
echo http://www.w3.org/2001/datatypes.dtd
echo -
echo ** Delete  XMLSchema.profile to start over **
echo ** Save as XMLSchema.profile when ready    **
echo -

REM %XEENA_HOME%\xeena -cfg -dtd "%XEENA_HOME%\XMLSchema.dtd" -root "schema"

%XEENA_HOME%\xeena -cfg -dtd "C:\www.web3D.org\TaskGroups\x3d\translation\XMLSchema.dtd" -root "schema"

