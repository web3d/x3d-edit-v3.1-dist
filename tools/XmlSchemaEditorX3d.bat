@echo off
rem XmlSchemaEditorX3d.bat

set XEENA_HOME=C:\IBM\Xeena

rem Run XEENA to edit the XML Schema for X3D-Edit

REM update schema editor using XmlSchemaProfileEditor.bat

REM %XEENA_HOME%\xeena -cfg -dtd "%XEENA_HOME%\XMLSchema.dtd" -root "schema"

%XEENA_HOME%\xeena -dtd "C:\www.web3D.org\TaskGroups\x3d\translation\XMLSchema.dtd" -root "schema" -xml X3dSchemaDraft.xml

