set drive=%cd:~0,2%
set git=%drive%\atomicApe\cygwin\bin\git.exe
set node=%drive%\atomicApe\cygwin\bin\node.exe
set python=%drive%\atomicApe\cygwin\bin\python2.7.exe
set ruby=%drive%\atomicApe\cygwin\bin\ruby.exe
set preferencesDir=%drive%\atomicApe\cygwin\home\bananas\Brackets\www\extensions\dev\brackets-git-master\src
set home=%drive%\atomicApe\cygwin\home\bananas
set builderDir=%drive%\atomicApe\cygwin\home\bananas\Brackets\www\extensions\dev\brackets-builder-extended-0.0.6

"%home%\fnr.exe" --cl --dir "%preferencesDir%" --fileMask "*.js" --excludeFileMask "*.dll, *.exe" --useRegEx --find """gitPath"": { ""type"": ""string"", ""value"": "".*"" }," --replace """gitPath"": { ""type"": ""string"", ""value"": ""%git%"" },"

"%home%\fnr.exe" --cl --dir "%builderDir%" --fileMask "*.json" --excludeFileMask "*.dll, *.exe" --useRegEx --find """name"": ""JavaScript"", ""cmd"": "".*""" --replace """name"": ""JavaScript"", ""cmd"": ""%node% $FILE"""

"%home%\fnr.exe" --cl --dir "%builderDir%" --fileMask "*.json" --excludeFileMask "*.dll, *.exe" --useRegEx --find """name"": ""Python"", ""cmd"": "".*""" --replace """name"": ""JavaScript"", ""cmd"": ""%python% $FILE"""

"%home%\fnr.exe" --cl --dir "%builderDir%" --fileMask "*.json" --excludeFileMask "*.dll, *.exe" --useRegEx --find """name"": ""Ruby"", ""cmd"": "".*""" --replace """name"": ""JavaScript"", ""cmd"": ""%ruby% $FILE"""
