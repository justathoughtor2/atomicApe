@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"D:\atomicApe\cygwin\home\bananas\Ruby22\bin\ruby.exe" "D:/atomicApe/cygwin/home/bananas/Ruby22/bin/jekyll" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"D:\atomicApe\cygwin\home\bananas\Ruby22\bin\ruby.exe" "%~dpn0" %*
