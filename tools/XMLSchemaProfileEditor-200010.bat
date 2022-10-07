@echo off
rem XmlSchemaProfileEditor.bat

set XEENA_HOME=C:\IBM\Xeena

rem Run XEENA to edit (or rebuild) a new XML Schema profile

echo -
echo update schema from these drafts (or later)
echo http://www.w3.org/2000/10/XMLSchema.xsd/.xml
echo http://www.w3.org/2000/10/XMLSchema.dtd
echo http://www.w3.org/2000/10/datatypes.xsd/.xml
echo http://www.w3.org/2000/10/datatypes.dtd

echo -
echo update public and system identifiers in the defaults tag:
echo file://localhost/C:/www.web3D.org/TaskGroups/x3d/translation/XMLSchema.dtd
echo file://localhost/C:/www.web3D.org/TaskGroups/x3d/translation/datatypes.dtd
echo http://www.w3.org/2000/10/XMLSchema.dtd
echo http://www.w3.org/2000/10/datatypes.dtd
echo -
echo delete  XMLSchema.profile to start over
echo save as XMLSchema.profile
echo -

REM %XEENA_HOME%\xeena -cfg -dtd "%XEENA_HOME%\XMLSchema.dtd" -root "schema"

%XEENA_HOME%\xeena -cfg -dtd "C:\www.web3D.org\TaskGroups\x3d\translation\XMLSchema.dtd" -root "schema"

