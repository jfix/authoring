@ECHO OFF

REM path to all OECD scripts
set OECDROOT=C:\_DEV

REM path to QUARK_SCHEMAS
set SCHEMAS=%OECDROOT%\authoring\models\schemas

REM path to the QC framework files.
set FRAMEWORK=%OECDROOT%\authoring\tools\quality-assurance\framework

REM Process all the XAS files with xmllint to resolve the entities and store them into the framework diretories.
SET OXYGEN=%ProgramFiles%\Oxygen XML Editor 15
SET QUARK_SCHEMAS=%ProgramFiles(x86)%\Quark\Quark XML Author\en\OECD
FOR %%F in ("%QUARK_SCHEMAS%\*.xas") do "%OXYGEN%\xmllint"  --noent --output "%FRAMEWORK%\configs\%%~nxF" "%%F"

REM Process all the XSD files with the Oxygen schema flattening files
FOR %%F in ("%SCHEMAS%\*.xsd") do "%OXYGEN%\flattenSchema.bat" %%F "%FRAMEWORK%\schemas\%%~nxF"