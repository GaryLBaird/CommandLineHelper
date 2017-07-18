' Standard housekeeping
Const HKEY_CLASSES_ROOT              = &H80000000
Const HKEY_CURRENT_USER              = &H80000001
Const HKEY_LOCAL_MACHINE             = &H80000002
Const HKEY_USERS                     = &H80000003
Const HKEY_CURRENT_CONFIG            = &H80000005
Const HKEY_DYN_DATA                  = &H80000006 ' Windows 95/98 only

Const REG_SZ                         =  1
Const REG_EXPAND_SZ                  =  2
Const REG_BINARY                     =  3
Const REG_DWORD                      =  4
Const REG_DWORD_BIG_ENDIAN           =  5
Const REG_LINK                       =  6
Const REG_MULTI_SZ                   =  7
Const REG_RESOURCE_LIST              =  8
Const REG_FULL_RESOURCE_DESCRIPTOR   =  9
Const REG_RESOURCE_REQUIREMENTS_LIST = 10
Const REG_QWORD                      = 11

If WScript.Arguments.Count >= 3 Then
	res = ReadRegValue(WScript.Arguments(0), WScript.Arguments(1), WScript.Arguments(2))
	Dim arr1, arr2
	Select Case res(1)
	Case HKEY_CLASSES_ROOT
		arr1 = "HKEY_CLASSES_ROOT"
	Case HKEY_CURRENT_USER
		arr1 = "HKEY_CURRENT_USER"
	Case HKEY_LOCAL_MACHINE
		arr1 = "HKEY_LOCAL_MACHINE"
	Case HKEY_USERS
		arr1 = "HKEY_USERS"
	Case HKEY_CURRENT_CONFIG
		arr1 = "HKEY_CURRENT_CONFIG"
	Case HKEY_DYN_DATA
		arr1 = "HKEY_DYN_DATA"
	End Select
	Select Case res(5)
	Case REG_SZ
		arr2 = "REG_SZ"
	Case REG_EXPAND_SZ
		arr2 = "REG_EXPAND_SZ"
	Case REG_BINARY
		arr2 = "REG_BINARY"
	Case REG_DWORD
		arr2 = "REG_DWORD"
	Case REG_DWORD_BIG_ENDIAN
		arr2 = "REG_DWORD_BIG_ENDIAN"
	Case REG_LINK
		arr2 = "REG_LINK"
	Case REG_MULTI_SZ
		arr2 = "REG_MULTI_SZ"
	Case REG_RESOURCE_LIST
		arr2 = "REG_RESOURCE_LIST"
	Case REG_FULL_RESOURCE_DESCRIPTOR
		arr2 = "REG_FULL_RESOURCE_DESCRIPTOR"
	Case REG_RESOURCE_REQUIREMENTS_LIST
		arr2 = "REG_RESOURCE_REQUIREMENTS_LIST"
	Case REG_QWORD
		arr2 = "REG_QWORD"
	End Select
	If WScript.Arguments.Count >= 4 Then
		Const ForAppending = 8

		Set objFSO = CreateObject("Scripting.FileSystemObject")
		objFSO.CreateTextFile WScript.Arguments(3), True
		
		Set objTextFile = objFSO.OpenTextFile _
		    (WScript.Arguments(3), ForAppending, True)
		objTextFile.WriteLine("SET RegistryOn=" &  CStr(res(0)))
		objTextFile.WriteLine("SET RegistryHiveKey=" & CStr(arr1))
		objTextFile.WriteLine("SET RegistryPath=" &  CStr(res(2)))
		objTextFile.WriteLine("SET KeyName=" &  CStr(res(3)))
		objTextFile.WriteLine("SET ReturnCode=" &  CStr(res(4)))
		objTextFile.WriteLine("SET DataType=" &  CStr(arr2))
		objTextFile.WriteLine("SET Value=" &  CStr(res(6)))
		objTextFile.Close
	End If
	
	WScript.Echo "RegistryOn=" &  CStr(res(0))
	WScript.Echo "RegistryHiveKey=" & CStr(arr1)
	WScript.Echo "RegistryPath=" &  CStr(res(2))
	WScript.Echo "KeyName=" &  CStr(res(3))
	WScript.Echo "ReturnCode=" &  CStr(res(4))
	WScript.Echo "DataType=" &  CStr(arr2)
	WScript.Echo "Value=" &  CStr(res(6))
Else
	WScript.Echo "Options: " & """ComputerName"",""RegHive\KeyPath"",""KeyName"",Optional:{""FileName.[bat/cmd]""}""" & vbNewLine
	WScript.Echo "Note:    " & "Using the OutTextFile is intended for batch processing where" & vbNewLine & vbTab & " you might want to call the file it created."
	WScript.Echo "Example: "& vbNewLine & "CALL cscript.exe ReadRegValue.vbs ""computername"",""HKCU\Software\Microsoft\Command Processor"",""CommandLineHelper"",""%temp%\filename.bat""" & vbNewLine & "CALL %temp%\filename.bat" & vbNewLine & "IF DEFINED Value (ECHO %VALUE%) ELSE (ECHO Value=)"
	WScript.Echo "Returns: " & vbNewLine & vbTab & "RegistryOn=ComputerName" & vbNewLine & vbTab & "RegistryHiveKey=HKEY_CURRENT_USER" & vbNewLine & vbTab & "RegistryPath=Software\Microsoft\Command Processor" & vbNewLine & vbTab & "KeyName=CommandLineHelper" & vbNewLine & vbTab & "ReturnCode=0" & vbNewLine & vbTab & "DataType=REG_SZ" & vbNewLine & vbTab & "Value=c:\CommandLineHelper" & vbNewLine
	WScript.Echo "Optional Example FileName.bat:" & vbNewLine & vbTab & "{" & vbNewLine & vbTab & "SET RegistryOn=ComputerName" & vbNewLine & vbTab & "SET RegistryHiveKey=HKEY_CURRENT_USER" & vbNewLine & vbTab & "SET RegistryPath=Software\Microsoft\Command Processor" & vbNewLine & vbTab & "SET KeyName=CommandLineHelper" & vbNewLine & vbTab & "SET ReturnCode=0" & vbNewLine & vbTab & "SET DataType=REG_SZ" & vbNewLine & vbTab & "Value=c:\CommandLineHelper" & vbNewLine & vbTab & "}" & vbNewLine & vbTab 
End If

Function ReadRegValue( myComputer, myRegPath, myRegValue )
' This function reads a value from the registry of any WMI
' enabled computer.
'
' Arguments:
' myComputer        a computer name or IP address,
'                   or a dot for the local computer
' myRegPath         a full registry key path, e.g.
'                   HKEY_CLASSES_ROOT\.jpg or
'                   HKLM\SOFTWARE\Microsoft\DirectX
' myRegValue        the value name to be queried, e.g.
'                   InstalledVersion or "" for default
'                   values
'
' The function returns an array with the following elements:
' ReadRegValue(0)   the computer name (the first argument)
' ReadRegValue(1)   the hive number (see const declarations)
' ReadRegValue(2)   the key path without the hive
' ReadRegValue(3)   the value name (the third argument)
' ReadRegValue(4)   the error number: 0 means no error
' ReadRegValue(5)   the data type of the result
' ReadRegValue(6)   the actual data, or the first element of an
'                   array of data for REG_BINARY or REG_MULTI_SZ
'
' Written by Rob van der Woude
' http://www.robvanderwoude.com



    Dim arrRegPath, arrResult(), arrValueNames, arrValueTypes
    Dim i, objReg, strHive, valRegError, valRegType, valRegVal
    ' Assume no error, for now
    valRegError = 0

    ' Split the registry path in a hive part
    ' and the rest, and check if that succeeded
    arrRegPath = Split( myRegPath, "\", 2 )
    If IsArray( arrRegPath ) Then
        If UBound( arrRegPath ) <> 1 Then valRegError = 5
    Else
        valRegError = 5
    End If

    ' Convert the hive string to a hive number
    Select Case UCase( arrRegPath( 0 ) )
        Case "HKCR", "HKEY_CLASSES_ROOT"
            strHive = HKEY_CLASSES_ROOT
        Case "HKCU", "HKEY_CURRENT_USER"
            strHive = HKEY_CURRENT_USER
        Case "HKLM", "HKEY_LOCAL_MACHINE"
            strHive = HKEY_LOCAL_MACHINE
        Case "HKU",  "HKEY_USERS"
            strHive = HKEY_USERS
        Case "HKCC", "HKEY_CURRENT_CONFIG"
            strHive = HKEY_CURRENT_CONFIG
        Case "HKDD", "HKEY_DYN_DATA"
            strHive = HKEY_DYN_DATA
        Case Else
            valRegError = 5
    End Select

    ' Abort if any error occurred, and return an error code
    If valRegError > 0 Then
        ReadRegValue = Array( myComputer, myRegPath, _
                              myRegPath, myRegValue, _
                              valRegError, "-", "-" )
        Exit Function
    End If

    ' Initiate custom error handling
    On Error Resume Next

    ' Create a WMI registry object
    Set objReg = GetObject( "winmgmts:{impersonationLevel=impersonate}!//" _
               & myComputer & "/root/default:StdRegProv" )

    ' Abort on failure to create the object
    If Err Then
        valRegError = Err.Number
        Err.Clear
        On Error Goto 0
        ReadRegValue = Array( myComputer, myRegPath, _
                              myRegPath, myRegValue, _
                              valRegError, "-", "-" )
        Exit Function
    End If

    ' Get a list of all values in the registry path;
    ' we need to do this in order to find out the
    ' exact data type for the requested value
    objReg.EnumValues strHive, arrRegPath( 1 ), arrValueNames, arrValueTypes

    ' If no values were found, we'll need to retrieve a default value
    If Not IsArray( arrValueNames ) Then
        arrValueNames = Array( "" )
        arrValueTypes = Array( REG_SZ )
    End If

    If Err Then
        ' Abort on failure, returning an error code
        valRegError = Err.Number
        Err.Clear
        On Error Goto 0
        ReadRegValue = Array( myComputer, myRegPath, _
                              myRegPath, myRegValue, _
                              valRegError, "-", "-" )
        Exit Function
    Else
        ' Loop through all values in the list . . .
        For i = 0 To UBound( arrValueNames )
            ' . . . and find the one requested
            If UCase( arrValueNames( i ) ) = UCase( myRegValue ) Then
                ' Read the requested value's data type
                valRegType = arrValueTypes( i )
                ' Based on the data type, use the appropriate query to retrieve the data
                Select Case valRegType
                    Case REG_SZ
                        objReg.GetStringValue strHive, arrRegPath( 1 ), _
                                              myRegValue, valRegVal
                        
                        If Err Then valRegError = Err.Number
                    Case REG_EXPAND_SZ
                        objReg.GetExpandedStringValue strHive, arrRegPath( 1 ), _
                                                      myRegValue, valRegVal
                        If Err Then valRegError = Err.Number
                    Case REG_BINARY ' returns an array of bytes
                        objReg.GetBinaryValue strHive, arrRegPath( 1 ), _
                                              myRegValue, valRegVal
                        If Err Then valRegError = Err.Number
                    Case REG_DWORD
                        objReg.GetDWORDValue strHive, arrRegPath( 1 ), _
                                             myRegValue, valRegVal
                        If Err Then valRegError = Err.Number
                    Case REG_MULTI_SZ ' returns an array of strings
                        objReg.GetMultiStringValue strHive, arrRegPath( 1 ), _
                                                   myRegValue, valRegVal
                        If Err Then valRegError = Err.Number
                    Case REG_QWORD
                        objReg.GetQWORDValue strHive, arrRegPath( 1 ), _
                                             myRegValue, valRegVal
                        If Err Then valRegError = Err.Number
                    Case Else
                        valRegError = 5
                End Select
            End If
        Next
    End If

    ' Check if an error occurred
    If valRegError > 0 Then
        valRegType = ""
        valRegVal  = ""
        Err.Clear
        On Error Goto 0
    End If

    ' Return the data in an array
    If valRegType = REG_BINARY Or valRegType = REG_MULTI_SZ Then
        ' First, deal with registry data which is
        ' returned as array instead of single value
        ReDim Preserve arrResult( 6 + UBound( valRegVal ) )
        arrResult( 0 ) = myComputer
        arrResult( 1 ) = strHive
        arrResult( 2 ) = arrRegPath( 1 )
        arrResult( 3 ) = myRegValue
        arrResult( 4 ) = valRegError
        arrResult( 5 ) = valRegType
        For i = 0 To UBound( valRegVal )
            arrResult( 6 + i ) = valRegVal( i )
        Next
        ReadRegValue = arrResult
    Else
        ReadRegValue = Array( myComputer, strHive, arrRegPath( 1 ), _
                              myRegValue, valRegError, valRegType, valRegVal )
    End If

    ' Finished
    Set objReg = Nothing
    On Error Goto 0
    ReadRegValue = ReadRegValue
End Function
