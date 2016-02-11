@echo off
rem $Id: install-tl.bat 30369 2013-05-10 13:01:27Z siepo $
rem Wrapper script to set up environment for installer
rem
rem Public domain.
rem Originally written 2009 by Tomasz M. Trzeciak.

rem First, check if this is DOS based system
rem in DOS '^' is just a normal character
if not ^x==x goto DOS

rem Localize environment changes
setlocal enableextensions

rem Batch subroutines require a cd to the batchfile directory.
rem For UNC paths, pushd will create a temporary mapping.
pushd "%~dp0"

rem Remove any double quotes from PATH (why we care for it at all???)
set "path=%path:"=%"

rem Break search path into dir list and rebuild w/o tex dirs
call :rebuildpath ";" "%path:;=" "%"
if "%path:~0,1%"==";" set "path=%path:~1%"

rem Use TL Perl
set "path=%~dp0tlpkg\tlperl\bin;%path%"
set "PERL5LIB=%~dp0tlpkg\tlperl\lib"

rem Clean environment from other Perl variables
set PERL5OPT=
set PERLIO=
set PERLIO_DEBUG=
set PERLLIB=
set PERL5DB=
set PERL5DB_THREADED=
set PERL5SHELL=
set PERL_ALLOW_NON_IFS_LSP=
set PERL_DEBUG_MSTATS=
set PERL_DESTRUCT_LEVEL=
set PERL_DL_NONLAZY=
set PERL_ENCODING=
set PERL_HASH_SEED=
set PERL_HASH_SEED_DEBUG=
set PERL_ROOT=
set PERL_SIGNALS=
set PERL_UNICODE=

set errlev=0
rem Start installer
path
echo "%~dp0install-tl" %*
perl "%~dp0install-tl" %*

rem The nsis installer will need this:
if errorlevel 1 set errlev=1
pause
goto :eoff

rem Subroutine to build search path without tex directories 
rem any dir containing pdftex.exe is considered a tex dir
:rebuildpath ";" dir list ...
shift
rem The first argument (";") serves as a marker to reset the path
if "%~0"==";" set path=
rem Finish if no more arguments to process
if [%1]==[] goto :eof
rem Continue if tex dir
if exist "%~1\pdftex.exe" goto :rebuildpath
rem Add dir to path
set "path=%path%;%~1"
goto :rebuildpath

:DOS
echo DOS and Windows 9x systems are not supported. Sorry.
echo Windows 2000 or newer is required.
pause

:eoff
if unc == 1 popd
