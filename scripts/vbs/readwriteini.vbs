' Written by: 		GarylBaird
' Version:			1.1
' Creation Date:	2010
' Purpose	        Read and write create to INI.
' Assumptions:	    User access level meets minimum operation to read, write or create(file does not exist) 
'					Lists each external variable, control, open file, or other element accessed by the procedure
' Inputs:			Read Requires -r, filename, section, key
' 					Write Requires -w, filename, section, key, value
' 					Read Scction -rs, filename, section
' 					Write Scction -ws, filename, section
' Format:			[Section]
' 					key=value
' Unsupported:		Multiple sections, keys or values. (Room for improvement)
' Returns:          -r returns the value of the key specified.   

' Make sure arguments were passed and display usage if not
' # Catch missing args:
dim objArgs
Set objArgs = WScript.Arguments
num = objArgs.Count
if num < 2 then
  CustomMsgBox CStr(BuildUsage(""))
  WScript.Quit 1
End if


Sub CustomMsgBox(msg)
  Set ie = CreateObject("InternetExplorer.Application")
  ie.Navigate "about:blank"
  ie.Document.title =  "readwriteini.vbs"

  While ie.ReadyState <> 4 : WScript.Sleep 100 : Wend

  ie.ToolBar    = False
  ie.StatusBar  = True
  ie.Width      = 800
  ie.Height     = 850
  ie.MenuBar    = False
  ie.AddressBar = False
  ie.Resizable  = True
  ie.Visible    = True
  ie.StatusText = "Please correct any errors and try again."

  ie.document.body.innerHTML = "<p class='msg'><pre>" & msg & "</pre></p>" & _
    "<p class='ctrl'><input type='hidden' id='OK' name='OK' value='0'>" & _
    "<input type='submit' value='OK' id='OKButton' " &_
    "onclick='document.all.OK.value=1'></p>"

  Set style = ie.document.CreateStyleSheet
  style.AddRule "p.msg", "font-family:times new roman;font-weight:bold;"
  style.AddRule "p.ctrl", "text-align:rightf;"

  On Error Resume Next
  Do While ie.Document.all.OK.value = 0 
    WScript.Sleep 200
  Loop
  ie.Quit
End Sub

Dim currentvalue, Debug_
Debug_ = False
Debug_writeLine=False
currentvalue = ""
If (WScript.Arguments.Count > 0) Then
	CaseOperation = WScript.Arguments(0)
	If (WScript.Arguments.Count > 1) Then
		iniFilePath   = WScript.Arguments(1)
	End If
	If (WScript.Arguments.Count > 2) Then
		iniSection    = WScript.Arguments(2)
	End If
	If (WScript.Arguments.Count > 3) Then
		iniKey        = WScript.Arguments(3)
	End If
	If (WScript.Arguments.Count > 4) Then
		iniValue      = WScript.Arguments(4)
		iniValue      = Replace(iniValue,", ",",",1,-1)
	End If
  If (WScript.Arguments.Count > 5) Then
    newarg       = WScript.Arguments(5)
  End If
	If Debug_ Then
		WScript.StdOut.Write "CaseOperation:" &_
		 CaseOperation & vbNewLine &_
		 "iniFilePath:" & iniFilePath & vbNewLine &_
		 "iniSection:" & iniSection & vbNewLine &_
		 "iniKey:" & iniKey  & vbNewLine &_
		 "iniValue:" & iniValue &_
		 "newarg:" & newarg
	 End If
	'WScript.StdOut.WriteLine CaseOperation
   Select Case CStr(CaseOperation)
      Case "-r"
        dim sout, tout
      	sout = (ReadIni(iniFilePath,iniSection,iniKey))
        tout = iniKey & "=" & sout
        WScript.StdOut.WriteLine tout
        Set wshShell = CreateObject( "WScript.Shell" )
        Set wshSystemEnv = wshShell.Environment( "Process" )
        temp = Cstr(wshSystemEnv("temp"))
        Set objFSO = CreateObject("Scripting.FileSystemObject")
        Set objFile = objFSO.CreateTextFile(temp & "\output.bat", True)
        objFile.WriteLine "@ECHO OFF"
        If not isEmpty(iniValue) Then
          objFile.WriteLine "SET " & iniValue & "=" & sout
        else
          objFile.WriteLine "SET " & "__" & iniKey & "__" & "=" & sout
        End If
      Case "-w"
		If Debug_writeLine Then
			WScript.StdOut.WriteLine "Checking..." & vbNewLine & iniFilePath & vbNewLine & iniSection & vbNewLine & iniKey
		End If
      	currentvalue = ReadIni(iniFilePath,iniSection,iniKey)
		If Debug_writeLine Then
			WScript.StdOut.WriteLine iniKey & "=" & currentvalue
		End If
      	Call WriteIni(iniFilePath,iniSection,iniKey,iniValue)
		If Debug_writeLine Then
			WScript.StdOut.WriteLine iniKey & "=" & (ReadIni(iniFilePath,iniSection,iniKey))
		End If
      Case "-rs"
      	WScript.StdOut.WriteLine (ReadSectionIni (iniFilePath,iniSection))
      Case "-ws"
      	WScript.StdOut.WriteLine ( WriteSectionIni (iniFilePath, iniSection ))
   End Select
Else
	WScript.Echo CStr(BuildUsage("")) 'MsgBox CStr(msg), 16, "Incorrect Number of Arguments:"
End If
'Case Else     WScript.Echo CStr(BuildUsage(CStr(WScript.Arguments(4)))) 'MsgBox CStr(msg), 16, "Unsupported Option:" & CaseOperation  	
    Set objOrgIni = Nothing
    Set objNewIni = Nothing
    Set objFSO    = Nothing
    Set wshShell  = Nothing
    
Function ReadIni( ini_file_Path, ini_Section, ini_Key )

    Const ForReading   = 1
    Const ForWriting   = 2
    Const ForAppending = 8

    Dim intEqualPos
    Dim objFSO, objIniFile
    Dim strFilePath, strKey, strLeftString, strLine, strSection
    
    
	    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
	
	    ReadIni     = ""
	    strFilePath = Trim( ini_file_Path )
	    strSection  = Trim( ini_Section )
	    strKey      = Trim( ini_Key )

	'WScript.Echo strKey
    If objFSO.FileExists( strFilePath ) Then
        Set objIniFile = objFSO.OpenTextFile( strFilePath, ForReading, False )
        Do While objIniFile.AtEndOfStream = False
            strLine = Trim( objIniFile.ReadLine )

            ' Check if section is found in the current line
            'WScript.Echo LCase( strSection )
            If StrComp(LCase( strLine ),"[" & LCase(strSection ) & "]",0)=0 Then
                strLine = Trim( objIniFile.ReadLine )
				'WScript.Echo strline
                ' Parse lines until the next section is reached
                Do While Left( strLine, 1 ) <> "["
                    ' Find position of equal sign in the line
                    intEqualPos = InStr( 1, strLine, "=", 1 )
                    If intEqualPos > 0 Then
                        strLeftString = Trim( Left( LCase(strLine), intEqualPos - 1 ) )
                        ' Check if item is found in the current line
                        If LCase( LCase(strLeftString) ) = LCase( LCase(strKey) ) Then
                            ReadIni = Trim( Mid( strLine, intEqualPos + 1 ) )
                            ReadIni = Replace(ReadIni,", ",",",1,-1)
                            ' In case the item exists but value is blank
                            If ReadIni = "" Then
                                ReadIni = " "
                            End If
                            ' Abort loop when item is found
                            Exit Do
                        End If
                    End If

                    ' Abort if the end of the INI file is reached
                    If objIniFile.AtEndOfStream Then Exit Do

                    ' Continue with next line
                    strLine = Trim( objIniFile.ReadLine )
                    'ReadIni = 1
                Loop

            Exit Do
            End If
        Loop
        objIniFile.Close
    Else
        WScript.Echo strFilePath & " doesn't exists. Exiting..."
        Wscript.Quit 1
    End If
End Function

Sub WriteIni( myFilePath, mySection, myKey, myValue )

    Const ForReading   = 1
    Const ForWriting   = 2
    Const ForAppending = 8

    Dim blnInSection, blnKeyExists, blnSectionExists, blnWritten
    Dim intEqualPos
    Dim objFSO, objNewIni, objOrgIni, wshShell
    Dim strFilePath, strFolderPath, strKey, strLeftString
    Dim strLine, strSection, strTempDir, strTempFile, strValue

    strFilePath = Trim( myFilePath )
    strSection  = Trim( mySection )
    strKey      = Trim( myKey )
    strValue    = Trim( myValue )

    Set objFSO   = CreateObject( "Scripting.FileSystemObject" )
    Set wshShell = CreateObject( "WScript.Shell" )

    strTempDir  = wshShell.ExpandEnvironmentStrings( "%TEMP%" )
    strTempFile = objFSO.BuildPath( strTempDir, objFSO.GetTempName )

    Set objOrgIni = objFSO.OpenTextFile( strFilePath, ForReading, True )
    Set objNewIni = objFSO.CreateTextFile( strTempFile, False, False )

    blnInSection     = False
    blnSectionExists = False
    ' Check if the specified key already exists
    blnKeyExists     = ( ReadIni( strFilePath, strSection, strKey ) <> "" )
    blnWritten       = False

    ' Check if path to INI file exists, quit if not
    strFolderPath = Mid( strFilePath, 1, InStrRev( strFilePath, "\" ) )
    If Not objFSO.FolderExists ( strFolderPath ) Then
        WScript.Echo "Error: WriteIni failed, folder path (" _
                   & strFolderPath & ") to ini file " _
                   & strFilePath & " not found!"
        Set objOrgIni = Nothing
        Set objNewIni = Nothing
        Set objFSO    = Nothing
        WScript.Quit 1
    End If

    While objOrgIni.AtEndOfStream = False
        strLine = Trim( objOrgIni.ReadLine )
        If blnWritten = False Then
            If LCase( strLine ) = "[" & LCase( strSection ) & "]" Then
                blnSectionExists = True
                blnInSection = True
            ElseIf InStr( strLine, "[" ) = 1 Then
                blnInSection = False
            End If
        End If

        If blnInSection Then
            If blnKeyExists Then
                intEqualPos = InStr( 1, strLine, "=", vbTextCompare )
                If intEqualPos > 0 Then
                    strLeftString = Trim( Left( strLine, intEqualPos - 1 ) )
                    If LCase( strLeftString ) = LCase( strKey ) Then
                        ' Only write the key if the value isn't empty
                        ' Modification by Johan Pol
                        If strValue <> "<DELETE_THIS_VALUE>" Then
                            objNewIni.WriteLine strKey & "=" & strValue
                        End If
                        blnWritten   = True
                        blnInSection = False
                    End If
                End If
                If Not blnWritten Then
                    objNewIni.WriteLine strLine
                End If
            Else
                objNewIni.WriteLine strLine
                    ' Only write the key if the value isn't empty
                    ' Modification by Johan Pol
                    If strValue <> "<DELETE_THIS_VALUE>" Then
                        objNewIni.WriteLine strKey & "=" & strValue
                    End If
                blnWritten   = True
                blnInSection = False
            End If
        Else
            objNewIni.WriteLine strLine
        End If
    Wend

    If blnSectionExists = False Then ' section doesn't exist
        objNewIni.WriteLine
        objNewIni.WriteLine "[" & strSection & "]"
            ' Only write the key if the value isn't empty
            ' Modification by Johan Pol
            If strValue <> "<DELETE_THIS_VALUE>" Then
                objNewIni.WriteLine strKey & "=" & strValue
            End If
    End If

    objOrgIni.Close
    objNewIni.Close

    ' Delete old INI file
    objFSO.DeleteFile strFilePath, True
    ' Rename new INI file
    objFSO.MoveFile strTempFile, strFilePath

End Sub

Function ReadSectionIni( ini_file_Path, ini_Section )
	If Debug_writeLine Then
		WScript.StdOut.WriteLine "Running ReadSectionINI"
	End If
    Const ForReading   = 1
    Const ForWriting   = 2
    Const ForAppending = 8

    Dim intEqualPos
    Dim objFSO, objIniFile
    Dim strFilePath, strKey, strLeftString, strLine, strSection
    
    
	    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
	
	    ReadSectionIni     = ""
	    strFilePath = Trim( ini_file_Path )
	    strSection  = Trim( ini_Section )


    If objFSO.FileExists( strFilePath ) Then
		If Debug_writeLine Then
			WScript.StdOut.WriteLine "FoundFile:" & strFilePath
		End If
    	ReadSectionIni = ""
        Set objIniFile = objFSO.OpenTextFile( strFilePath, ForReading, False )
        LineFound = null
        Do While objIniFile.AtEndOfStream = False
            strLine = Trim( objIniFile.ReadLine )

            ' Check if section is found in the current line
            If LCase( strLine ) = "[" & LCase( strSection ) & "]" Then   	
                ReadSectionIni = Trim( LCase( strSection ) )
                'WScript.StdOut.WriteLine ReadSectionIni  
            Else
            	WScript.StdOut.WriteLine "Not Set ReadSectionIni"
            	'ReadSectionIni = ""
            End If
            
        Loop
        objIniFile.Close
    Else
		If Debug_writeLine Then
			WScript.StdOut.WriteLine strFilePath & " doesn't exists. Exiting..."
		End If
        Wscript.Quit 1
    End If
End Function

Function WriteSectionIni ( ini_file_Path, ini_Section )

    ' Returns:
    ' 0 Successfully updated
    ' 1 Section already Exists
    
	If (CInt(StrComp(ReadSectionIni( ini_file_Path, ini_Section),ini_Section,1)) = 0 ) Then
		WriteSectionIni = 1
	Else	    
		Const ForReading   = 1
	    Const ForWriting   = 2
	    Const ForAppending = 8
	
	    Dim blnInSection, blnKeyExists, blnSectionExists, blnWritten
	    Dim intEqualPos
	    Dim objFSO, objNewIni, objOrgIni, wshShell
	    Dim strFilePath, strFolderPath, strLeftString
	    Dim strLine, strSection, strTempDir, strTempFile
	
	    strFilePath = Trim( ini_file_Path )
	    strSection  = Trim( ini_Section )    
	
	    Set objFSO   = CreateObject( "Scripting.FileSystemObject" )
	    Set wshShell = CreateObject( "WScript.Shell" )
	
	    strTempDir  = wshShell.ExpandEnvironmentStrings( "%TEMP%" )
	    strTempFile = objFSO.BuildPath( strTempDir, objFSO.GetTempName )
	
	    Set objOrgIni = objFSO.OpenTextFile( strFilePath, ForReading, True )
	    Set objNewIni = objFSO.CreateTextFile( strTempFile, False, False )
	
	    blnInSection     = False
	    ' Check if the specified Section already exists
	    blnWritten       = False
	
	    ' Check if path to INI file exists, quit if not
	    strFolderPath = Mid( strFilePath, 1, InStrRev( strFilePath, "\" ) )
	    If Not objFSO.FolderExists ( strFolderPath ) Then
	        WScript.Echo "Error: WriteIni failed, folder path (" _
	                   & strFolderPath & ") to ini file " _
	                   & strFilePath & " not found!"
	        Set objOrgIni = Nothing
	        Set objNewIni = Nothing
	        Set objFSO    = Nothing
	        WScript.Quit 1
	    End If
	
	    If blnSectionExists = False Then ' section doesn't exist
	    	strLine = ""
	    	Do While objOrgIni.AtEndOfStream = False
            	objNewIni.WriteLine Trim( objOrgIni.ReadLine )
            loop
	        objNewIni.WriteLine "[" & strSection & "]" & vbNewLine
	        WriteSectionIni = 0
	    End If
	
	    objOrgIni.Close
	    objNewIni.Close
	
	    ' Delete old INI file
	    objFSO.DeleteFile strFilePath, True
	    ' Rename new INI file
	    objFSO.MoveFile strTempFile, strFilePath
	
	    Set objOrgIni = Nothing
	    Set objNewIni = Nothing
	    Set objFSO    = Nothing
	    Set wshShell  = Nothing 
	End If
End Function

Function BuildUsage(str)
  Dim Usage
  If WScript.Arguments.Count() = 5 Then
    If Not (StrComp(str,"",0) = 0) Then
      Usage = "The argument " & str & " appears to have a problem.                                       " & vbNewLine
    Else
      Usage = "Error In:                                                                                 " & str & vbNewLine
    End If
  Else
    Usage = "Error: [" & WScript.Arguments.Count() & "] argument(s) were received.                       " & vbNewLine
  End If
  Usage = Usage & vbNewLine
  Usage = Usage & "Description:                                                                          " & vbNewLine
  Usage = Usage & "Readwriteini is utility that reads and writes to INI files.                           " & vbNewLine & vbNewLine
  Usage = Usage & "Usage:" & vbTab & "Five arguments are required for all operations.                    " & vbNewLine 
  Usage = Usage & " readwriteini.vbs [Operation] [File] [Section] [Key] [Value]                          " & vbNewLine & vbNewLine
  Usage = Usage & " Operation[-r|-w|-rs|-ws) File Section Key Value                                      " & vbNewLine
  Usage = Usage & "  File" & vbTab & "Location and name of the INI file.                                 " & vbNewLine
  Usage = Usage & "  Section" & vbTab & "Section in the INI file. Note: you should not included brackets." & vbNewLine
  Usage = Usage & "  Key  " & vbTab & "Key in the INI file under the desired section.                      " & vbNewLine
  Usage = Usage & "  Value" & vbTab & "The value being passed to the Key.                                " & vbNewLine	
  Usage = Usage & "       " & vbTab & "Note: this is only used when writing a value.                     " & vbNewLine & vbNewLine
  Usage = Usage & "  Operation: Definition:                                                              " & vbNewLine
  Usage = Usage & "  -r " & vbTab & "Reads the value found at the Section and Key passed in.             " & vbNewLine
  Usage = Usage & "  -w " & vbTab & "Writes the value provided at the Section and Key passed.            " & vbNewLine
  Usage = Usage & "     " & vbTab & " in, if the section is missing it will attempt to create            " & vbNewLine
  Usage = Usage & "     " & vbTab & " the section and Key.                                               " & vbNewLine 
  Usage = Usage & "  -rs" & vbTab & "Returns the Section name if found in the INI.                       " & vbNewLine
  Usage = Usage & "  -ws" & vbTab & "Writes the Section name provided.                                   " & vbNewLine & vbNewLine
  Usage = Usage & "  Operation:                                                                          " & vbNewLine
  Usage = Usage & "    StdErr: StdOut:      Description:                                                 " & vbNewLine
  Usage = Usage & "  -r  0     Key=Value    Only returns the search key and value found.                 " & vbNewLine
  Usage = Usage & "      1                  An error occured.                                            " & vbNewLine
  Usage = Usage & "                         If a key and value is passed in on read you can call         " & vbNewLine
  Usage = Usage & "                          %temp%\output.bat. This will set an environment variable to " & vbNewLine
  Usage = Usage & "                          the name passed.                                            " & vbNewLine
  Usage = Usage & "  -w  0                  Does not return anything.                                    " & vbNewLine
  Usage = Usage & "      1                  An error occured.                                            " & vbNewLine
  Usage = Usage & "  -rs 0     Key=Value    Returns [Section|Key|Value] if found.                        " & vbNewLine
  Usage = Usage & "      1                  Key was not found.                                           " & vbNewLine
  Usage = Usage & "  -ws 0                  Exists and replaced [Section|Key|Value]                      " & vbNewLine
  Usage = Usage & "      1                  Created new [Section|Key|Value]                              " & vbNewLine & vbNewLine
  Usage = Usage & " Example of use:                                                                      " & vbNewLine
  Usage = Usage & " Use CScript.exe instead of Wscript.exe to avoid messageboxes.                        " & vbNewLine
  Usage = Usage & "  CScript.exe //B -s readwriteini.vbs -r c:\filename.ini Section Key                  " & vbNewLine	
  Usage = Usage & "  CScript.exe //B -s readwriteini.vbs -w c:\filename.ini Section Key ""Value""        " & vbNewLine
  Usage = Usage & "  CScript.exe //B -s readwriteini.vbs -rs c:\filename.ini Section                     " & vbNewLine 
  Usage = Usage & "  CScript.exe //B -s readwriteini.vbs -ws c:\filename.ini Section                     " & vbNewLine & vbNewLine
  Usage = Usage & " Example Output:                                                                      " & vbNewLine	
  Usage = Usage & "  [Section]                                                                           " & vbNewLine	
  Usage = Usage & "  Key=Value                                                                           " & vbNewLine
  BuildUsage = Usage
End Function

' Password Encryption / Decryption Section:
Function PasswordEncryption(Operation, password)
Dim sbox(255)
Dim key(255)
Dim Encryptkey
Dim EncryptStr
Dim Encryptedstr

Encryptkey = "lkjie8935-53242lskajf3904l.z,xmcopsf"
EncryptStr = InputBox("String")

Encryptedstr = EnDeCrypt(EncryptStr,Encryptkey)
testresult = InputBox("String","test",Encryptedstr)
End Function

Sub RC4Initialize(strPwd)
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
':::  This routine called by EnDeCrypt function. Initializes the :::
':::  sbox and the key array)                                    :::
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  dim tempSwap
  dim a
  dim b

  intLength = len(strPwd)
  For a = 0 To 255
     key(a) = asc(mid(strpwd, (a mod intLength)+1, 1))
     sbox(a) = a
  next

  b = 0
  For a = 0 To 255
     b = (b + sbox(a) + key(a)) Mod 256
     tempSwap = sbox(a)
     sbox(a) = sbox(b)
     sbox(b) = tempSwap
  Next

End Sub

Function EnDeCrypt(plaintxt, psw)
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
':::  This routine does all the work. Call it both to ENcrypt    :::
':::  and to DEcrypt your data.                                  :::
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  dim temp
  dim a
  dim i
  dim j
  dim k
  dim cipherby
  dim cipher

  i = 0
  j = 0

  RC4Initialize psw

  For a = 1 To Len(plaintxt)
     i = (i + 1) Mod 256
     j = (j + sbox(i)) Mod 256
     temp = sbox(i)
     sbox(i) = sbox(j)
     sbox(j) = temp

     k = sbox((sbox(i) + sbox(j)) Mod 256)

     cipherby = Asc(Mid(plaintxt, a, 1)) Xor k
     cipher = cipher & Chr(cipherby)
  Next

  EnDeCrypt = cipher

End Function

