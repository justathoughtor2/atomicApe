@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\node_modules\phonegap\bin\phonegap.js" %*
) ELSE (
  node  "%~dp0\node_modules\phonegap\bin\phonegap.js" %*
)