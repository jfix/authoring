REM java locations
SET JAVA_HOME=%CommonProgramFiles%\Java\jre7
SET JAVA=%JAVA_HOME%\bin\java.exe
SET SAXON_LICENSE=%CommonProgramFiles%\Saxonica\SaxonEE9.4N\bin
SET CLASSPATH=%FRAMEWORK%\bin\saxonee9.jar;%FRAMEWORK%\bin\calabash.jar;%SAXON_LICENSE%

REM path to all OECD scripts
set OECDROOT=C:\_DEV

REM path to the QC framework files.
set FRAMEWORK=%OECDROOT%\authoring\tools\quality-assurance\framework

REM path to the list of schemas
set SCHEMA_MANIFEST=%FRAMEWORK%\configs\schema-manifest.xml

REM path to the path to uri conversion script
set PATH_TO_URI=%FRAMEWORK%\bin\path-to-uri.vbs

REM command line args
set MANIFEST_FILE=%1
set OUTPUT_DIR=%2

REM this is the XPROC script. Doesn't need to be a URI.
set SCRIPT=%OECDROOT%\authoring\tools\quality-assurance\framework\xproc\process-test-manifest.xpl

REM the schema config does need to be a file URI
cscript //NoLogo %PATH_TO_URI% %SCHEMA_MANIFEST% > %TEMP%\schema_manifest.txt
set /P SCHEMA_MANIFEST_URI=< %TEMP%\schema_manifest.txt

REM the output directory needs to be a URI as well.
cscript//NoLogo %PATH_TO_URI% %OUTPUT_DIR% > %TEMP%\output_dir.txt
set /P OUTPUT_DIR_URI=< %TEMP%\output_dir.txt

REM as does the manifest
cscript //NoLogo %PATH_TO_URI% %MANIFEST_FILE% > %TEMP%\manifest_file.txt
set /P MANIFEST_FILE_URI=< %TEMP%\manifest_file.txt

echo Processing $MANIFEST_FILE to $OUTPUT_DIR

ECHO %JAVA% -Xmx2048m -classpath "%CLASSPATH%" com.xmlcalabash.drivers.Main --saxon-processor=ee --input manifest=%MANIFEST_FILE_URI% --input config=%SCHEMA_MANIFEST_URI% %SCRIPT%  output-base-uri=%OUTPUT_DIR_URI%