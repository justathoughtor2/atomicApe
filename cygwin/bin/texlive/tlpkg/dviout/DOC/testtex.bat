echo off
echo *********************************************************
echo *****  Check the fundamental setting of TeX system  *****
echo *****             Push [Enter] to continue          *****
echo *********************************************************
echo ----- 1. Check the existence of latex -----
pause
tex -version
if exist testtex.txt del testtex.txt
tex -version > testtex.txt
echo ----- 2. Check for making a DVI file by tex! -----
pause
echo \documentclass[12pt]{article}> testtex.tex
echo \begin{document}>> testtex.tex
echo Hello world!>> testtex.tex
echo \[\frac xy + \frac uv=\frac {xv+yu}{yv}\]>> testtex.tex
echo \end{document}>> testtex.tex
if exist testtex.dvi del testtex.dvi
latex testtex
echo ----- 3. Check the existence of ptex -----
pause
if not exist testtex.dvi echo *** testtex.dvi cannot be created. ***>> testtex.txt
platex -version
echo ----- 4. Check the existence of mktextfm and cmr10.tfm -----
pause
echo - cmr10.tfm ->> testtex.txt
mktextfm cmr10.tfm>> testtex.txt
echo ----- 5. Check the existence of kpsewhich -----
pause
kpsewhich -version
echo - min10.tfm ->> testtex.txt
kpsewhich min10.tfm >> testtex.txt
echo - TEXMF ->> testtex.txt
kpsewhich --expand-braces $TEXMF>> testtex.txt
echo - MFINPUTS ->> testtex.txt
kpsewhich --expand-braces $MFINPUTS>> testtex.txt
echo - MAKETEX_MODE ->> testtex.txt
kpsewhich --expand-braces $MAKETEX_MODE>> testtex.txt
echo - PKFONTS ->> testtex.txt
kpsewhich --expand-braces $PKFONTS>> testtex.txt
echo ----->> testtex.txt
platex -version>> testtex.txt
echo ----- 6. Check for making a DVI file by ptex! -----
pause
echo \documentclass{jarticle}> testtexj.tex
echo \begin{document}>> testtexj.tex
echo \Huge こんにちわ！>> testtexj.tex
echo \end{document}>> testtexj.tex
if exist testtexj.dvi del testtexj.dvi
platex testtexj
echo ----- 7. Check the existence of gswin32c -----
pause
if not exist testtexj.dvi echo *** testtexj.dvi cannot be created. *** >> testtex.txt
echo ----->> testtex.txt
gswin32c -version
gswin32c -h>> testtex.txt
echo ----- 8. Check Environment variables! -----
pause
echo ----->> testtex.txt
echo TEXMF="%TEXMF%"
echo TEXMF="%TEXMF%">> testtex.txt
echo TEXMFMAIN="%TEXMFMAIN%"
echo TEXMFMAIN="%TEXMFMAIN%">> testtex.txt
echo TEXMFCNF="%TEXMFCNF%"
echo TEXMFCNF="%TEXMFCNF%">> testtex.txt
echo TEMP="%TEMP%"
echo TEMP="%TEMP%">> testtex.txt
echo TMP="%TMP%"
echo TMP="%TMP%">> testtex.txt
echo GS_LIB="%GS_LIB%"
echo GS_LIB="%GS_LIB%">> testtex.txt
echo PATH="%PATH%"
echo PATH="%PATH%">> testtex.txt
if not "%TEMP%/"=="/" goto :temp
if not "%TMP%/"=="/" goto :tmp
echo *******************************************************************************
echo ******   Error:  Environment variables TEMP and TMP are not defined.     ******
echo ******   エラー: 環境変数 TEMP と TMP が共に定義されていない！           ******
echo ******   エラー: 環境変数 TEMP と TMP が共に定義されていない！           ******>> testtex.txt
goto :tmpend
:temp
if exist "%TEMP%\test.$$$" del "%TEMP%\test.$$$"
echo test> "%TEMP%\test.$$$"
if exist "%TEMP%\test.$$$" goto :tmp0
echo *******************************************************************************
echo ****** Error:  Cannot write in the holder %TEMP%         ******
echo ****** エラー: %TEMP% が存在しないか、書き込みが出来ない ******
echo ****** エラー: %TEMP% が存在しないか、書き込みが出来ない ******>> testtex.txt
goto :tmp
:tmp0
del "%TEMP%\test.$$$"
:tmp
if "%TEMP%/"=="%TMP%/" goto :tmpend
if "%TMP%/"=="/" goto :tmpend
if exist "%TMP%\test.$$$" del "%TMP%\test.$$$"
echo test> "%TMP%\test.$$$"
if exist "%TMP%\test.$$$" goto :tmp1
echo *******************************************************************************
echo ****** Error:  Cannot write in the holder %TMP%         ******
echo ****** エラー: %TMP% が存在しないか、書き込みが出来ない ******
echo ****** エラー: %TMP% が存在しないか、書き込みが出来ない ******>> testtex.txt
goto :tmpend
:tmp1
del "%TMP%\test.$$$"
:tmpend
if %TEXMFMAIN%/==/ goto :env
if %TEXMF%/==/ goto :env
echo *******************************************************************************
echo ******    Error : Environment variables TEXMF and TEXMFMAIN are set!     ******
echo ******    エラー：環境変数 TEXMF と TEXMFMAIN の両方が設定されています！ ******
echo ******    エラー：環境変数 TEXMF と TEXMFMAIN の両方が設定されています！ ******>> testtex.txt
goto :notshow
:env
if exist testtex.dvi goto :show
if exist testtexj.dvi goto :show
if not %TEXMFCNF%/==/ goto :chk
if %TEXMFMAIN%/==%TEXMF%/ goto :nodvi
:chk
echo -- Check LaTeX after eracing Environment variables TEXMF/TEXMFMAIN/TEXMFCNF --
pause
set TX1XT=%TEXMFCNF%
set TEXMFCNF=
set TX2XT=%TEXMFMAIN%
set TEXMFMAIN=
set TX3XT=%TEXMF%
set TEXMF=
latex testtex
set TEXMFCNF=%TX1XT%
set TX1XT=
set TEXMFMAIN=%TX2XT%
set TX2XT=
set TEXMF=%TX3XT%
set TX3XT=
:nodvi
echo *******************************************************************************
if not exist testtex.dvi goto :notshow
echo ***  Error : Environment variables TEXMF/TEXMFMAIN/TEXMF should be eraced!  ***
echo ***  エラー：環境変数 TEXMF/TEXMFMAIN/TEXMF を全て削除する必要があります！  ***
echo ***  エラー：環境変数 TEXMF/TEXMFMAIN/TEXMF を全て削除する必要があります！  ***>> testtex.txt
goto :notshow
:show
echo *******************************************************************************
echo *****   Please check if testtex.dvi and testtexj.dvi are correctly made!  *****
echo ***  testtex.dvi, testtexj.dvi が正しく生成されているかどうか確かめましょう ***
:notshow
echo ****  Some results are written in testtex.txt（testtex.txt を参照のこと）  ****
echo *******************************************************************************
echo ----- 9. END -----
echo メモ帳で testtex.txt を見る場合は [Enter] 、終了する場合は Ctrl+C を押します！
pause
notepad testtex.txt
