@echo off
rem Advanced launcher for tlmgr with auto-update
rem
rem Public Domain
rem Originally written 2009 by Tomasz M. Trzeciak

rem Make environment changes local
setlocal enableextensions

rem Get TL installation root (w/o trailing backslash)
set tlroot=%~dp0:
set tlroot=%tlroot:\bin\win32\:=%

rem Remove remains of previous update if any
set tlupdater=%tlroot%\temp\updater-w32
if exist "%tlupdater%" del "%tlupdater%"
if exist "%tlupdater%" goto :err_updater_exists

rem Start tlmgr
set PERL5LIB=%tlroot%\tlpkg\tlperl\lib
path %tlroot%\tlpkg\tlperl\bin;%tlroot%\bin\win32;%path%
"%tlroot%\tlpkg\tlperl\bin\perl.exe" "%tlroot%\texmf-dist\scripts\texlive\tlmgr.pl" %*

rem Finish if there are no updates to do; the last error code will be returned
if not exist "%tlupdater%" goto :eof
rem Rename updater script before it is run
move /y "%tlupdater%" "%tlupdater%.bat">nul
if errorlevel 1 goto :err_rename_updater
rem Run updater and don't return
"%tlupdater%.bat"

rem This should never execute
echo %~nx0: this message should never show up, please report it to tex-live@tug.org>&2
exit /b 1

:err_updater_exists
echo %~nx0: failed to remove previous updater script>&2
exit /b 1

:err_rename_updater
echo %~nx0: failed to rename "%tlupdater%">&2
exit /b 1
