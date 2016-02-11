option explicit
On Error Resume next

dim oWsh, oArgs, oFS, oDia, oTS, infile, outfile, f, c, result

set oWsh = createobject( "wscript.Shell" )
Set oFS = CreateObject("Scripting.FileSystemObject")
Set oArgs = wscript.arguments

' assume sam2p and bmeps on searchpath
If oArgs.count = 0 Then
  ' This appears to fail on win7: 'No file to convert' messagebox
  Set oDia = CreateObject("UserAccounts.CommonDialog")
  'oDia.InitialDir = oWsh.SpecialFolders("MyDocuments")
  oDia.filter = _
    "Bitmaps|*.bmp;*.png;*.gif;*.bmp;*.jpg;*.jpeg;*.tif;*.tiff|All files|*.*"
  oDia.filterindex = 1
  oDia.flags = 1
  If oDia.ShowOpen = False then
    msgBox "No file to convert"
    wscript.quit
  End If
  infile = oDia.filename
  ' MsgBox "infile: " & infile
Else
  ' may have to flip slashes if the file was on a network drive !!!
  infile = replace(oArgs(0), "/", "\")
  infile = ofs.getabsolutepathname(infile)
End If

' name of output file
outfile = ofs.buildpath(ofs.getparentfoldername(infile), _
  ofs.getbasename(infile) & ".eps")

If ofs.fileexists(outfile) Then
  result = MsgBox(outfile & vbcrlf & "exists; overwrite?", _
    vbyesno+vbquestion)
  If result <> vbyes Then
    wscript.quit
  Else
    oFS.deletefile(outfile)
    Err.clear
    If ofs.fileexists(outfile) Then
      MsgBox "Unable to remove old " & outfile, vbcritical
      wscript.quit
    End If
  End If
End If

' MsgBox "trying sam2p"
owsh.run "sam2p """ & infile & """ EPS: """ & outfile & """", 0
If Err Then
  ' This is a failure of this script to start sam2p,
  ' not just a failure of sam2p to do its job
  MsgBox "Unspecified failure", vbcritical
  wscript.quit
End If
wscript.sleep(1000)

If ofs.fileexists(outfile) Then
  MsgBox ofs.getbasename(infile) & "." & ofs.getextensionname(infile) & _
  " successfully converted", vbInformation
Else
 Err.clear
  ' clear sam2p temp files
  For Each f in ofs.getfolder(ofs.getparentfoldername(infile)).files
    If InStr(f.Name, "tmp__sam2p") = 1 Then
      f.delete
      Err.clear
    End If
  Next
  ' MsgBox "trying bmeps"
  owsh.run "bmeps -c """ & infile & """ """ & outfile & """", 0
  If Err Then
    MsgBox "Unspecified failure", vbcritical
    wscript.quit
  End If
  wscript.sleep(1000)
  If ofs.fileexists(outfile) Then
    result = True
    ' check the eps file; it may contain just an error mesage from bmeps
    Set oTS = ofs.opentextfile (outfile, 1)
    If Err Then
      result = False
      Err.clear
    Else
      c = oTS.read(2)
      If Err Then
        result = false
        Err.clear
      Else
        If c <> "%!" Then
          result = False
        End If
      End If
      oTS.close
    End If
    If result then
      MsgBox ofs.getbasename(infile) & "." & ofs.getextensionname(infile) & _
      " successfully converted with bmeps", vbInformation
    Else
      'ofs.deletefile(outfile)
      MsgBox "Conversion failed", vbCritical
    End If
  Else
   MsgBox "Conversion failed", vbCritical
  End If
End If
