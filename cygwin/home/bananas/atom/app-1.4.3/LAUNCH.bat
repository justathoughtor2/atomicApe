@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
:: NOTE: %~dp0 already has a trailing backslash
:: enclose in double quotes in case of folder names with spaces
:: %1 to open the file when associated with a file extension in windows
:: %1 to open a file when said file "dropped" onto this batch file
PUSHD "%~dp0"
SET atom=atom.exe
SET "ATOM_HOME=%~dp0.atom"

IF EXIST "%~dp0%atom%" (
IF NOT EXIST "%~dp0.atom" MKDIR "%~dp0.atom"
START /w "atom.io" "%~dp0%atom%" %1
)

IF NOT EXIST "%~dp0%atom%" (
ECHO.
ECHO.
ECHO.   Warning: %~dp0%atom% is not found!
ECHO.
ECHO.   Is atom.bat in the correct folder?
ECHO.
PAUSE
EXIT
)

TASKKILL /F /IM "%~dp0%atom%"
TASKKILL /F /IM "%~dp%resources\app\apm\bin\node"
EXIT
