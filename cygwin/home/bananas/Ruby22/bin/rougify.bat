@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"F:\atomicApe\babun\cygwin\home\bananas\Ruby22\bin\ruby.exe" "F:/atomicApe/babun/cygwin/home/bananas/Ruby22/bin/rougify" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"F:\atomicApe\babun\cygwin\home\bananas\Ruby22\bin\ruby.exe" "%~dpn0" %*
