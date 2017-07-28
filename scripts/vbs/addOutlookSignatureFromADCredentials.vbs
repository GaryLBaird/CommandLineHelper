' Last Update Date	:	7/20/2017
On Error Resume Next

Const HKEY_CLASSES_ROOT 	= &H80000000
Const HKEY_CURRENT_USER 	= &H80000001
Const HKEY_LOCAL_MACHINE 	= &H80000002
Const HKEY_USERS 			= &H80000003
Const HKEY_CURRENT_CONFIG 	= &H80000005

' Windows 7 Kerberos packet size is not compatible with certain domains and may need a registry fix.
' Check for Windows 7
Dim returns, NeedsKerberosFix

Set dtmConvertedDate = CreateObject("WbemScripting.SWbemDateTime")
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set oss = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")


For Each os in oss
    Wscript.Echo os.Caption
    'NeedsKerberosFix = StrComp("Microsoft Windows 7 Professional ", CStr(os.Caption), 0)
    'WScript.Echo NeedsKerberosFix
    If (RegularExpression(CStr(os.Caption), "^Microsoft.*(2000$|XP|7|8)((?!\/).)*$")(0,0) >= 0) Then
		NeedsKerberosFix = 0
	End If
    Wscript.Echo " Encryption Level: " & os.EncryptionLevel
    dtmConvertedDate.Value = os.InstallDate
    dtmInstallDate = dtmConvertedDate.GetVarDate
    Wscript.Echo " Install Date: " & dtmInstallDate 
    Wscript.Echo " Version: " & os.Version
Next


If NeedsKerberosFix=0 Then
	WScript.Echo "Windows 7/8 and Windows Server 2008 have Kerberos packet size issues. " & vbNewLine & _
		"" & vbNewLine & _
		"Attempting to identify and fix this issue now." & vbNewLine & _
		"" & vbNewLine & _
		"NOTE:" & vbTab & "This may require(and probably will) you to restart your" & vbNewLine & _
		" computer and re-run this script." & vbNewLine & _
		vbTab & "Cscript.exe '" & WScript.ScriptFullName & "'" & " before the signature" & vbNewLine & _
		vbTab & "appears in Microsoft Word." & vbNewLine 
	CheckAddReg
End If
Set objSysInfo = CreateObject("ADSystemInfo")

strUser = objSysInfo.UserName
Set objUser = GetObject("LDAP://" & strUser)

If IsNull(objUser) Then
	CheckAddReg
	Set objUser = GetObject("LDAP://" & strUser)
	If IsNull(objUser) Then
		WScript.Echo "You will need to restart your computer and attempt to try running" & vbNewLine & _
			"to run cscript.exe '" & WScript.ScriptName & "' again."
	End If
End If
strName = objUser.FullName
strTitle = objUser.Title
strDepartment = objUser.Department
strCompany = objUser.Company
strPhone = objUser.telephoneNumber
strEmail = objUser.mail

Dim Return_FirstIndex, Return_Value
Set objRE = New RegExp
objRE.Global     = True
objRE.IgnoreCase = True
objRE.Pattern    = "((\w+)(\.|\_|\-)(\w+)|(\w+))(\@)(\w+)(\.)(w+).*"

Set colMatches = objRE.Execute(strEmail)
WScript.Echo vbNewLine & "Resulting Matches:"
For Each objMatch In colMatches
	WScript.Echo objMatch.FirstIndex
   Return_FirstIndex = objMatch.FirstIndex
   Return_Value = objMatch.Value
Next

WScript.Echo Return_FirstIndex, Return_Value
WScript.Sleep(15)

Set objWord = CreateObject("Word.Application")
If IsNull(objWord) Then
	WScript.Echo CStr(WScript.ScriptFullName) & " failed to find Microsoft Word. Please Install Microsoft word and try again."
	WScript.Quit(1)
Else
	WScript.Echo "Found Word installed at path: " & CStr(objWord.Path)
End If
Set objDoc = objWord.Documents.Add()
Set objSelection = objWord.Selection
objSelection.Style = "No Spacing"

Set objEmailOptions = objWord.EmailOptions
Set objSignatureObject = objEmailOptions.EmailSignature

Set objSignatureEntries = objSignatureObject.EmailSignatureEntries

' Beginning of signature block

objSelection.TypeText strName
objSelection.TypeParagraph()
objSelection.TypeText strTitle
objSelection.TypeParagraph()
objSelection.TypeText strCompany
objSelection.TypeParagraph()
objSelection.TypeText "Office Phone: " & strPhone
objSelection.TypeParagraph()
Set objLink = objSelection.Hyperlinks.Add(objSelection.Range, "mailto: " & strEmail, , , strEmail) 

' End of signature block

Set objSelection = objDoc.Range()

objSignatureEntries.Add "Script Signature", objSelection
'objSignatureObject.NewMessageSignature = "Script Signature"
'objSignatureObject.ReplyMessageSignature = "Script Signature"

objDoc.Saved = True
objWord.Quit

Function RegularExpression(string_CheckContent, string_RegularExp)
	Dim Return_Value, Return_FirstIndex, Return_arr(1,0)
	Set objRE = New RegExp
	objRE.Global     = True
	objRE.IgnoreCase = True
	objRE.Pattern    = string_RegularExp
	
	Set colMatches = objRE.Execute(string_CheckContent)
	' WScript.Echo vbNewLine & "Resulting Matches:"
	' WScript.Echo "Count:" & colMatches.Count
	If colMatches.Count >= 1 Then
		For Each objMatch In colMatches
		   Return_FirstIndex = objMatch.FirstIndex
		   Return_Value = objMatch.Value
		   ' WScript.Echo objMatch.Value
		Next
		Return_arr(0,0) = Return_FirstIndex
		Return_arr(1,0) = Return_Value
	Else
		Return_arr(0,0) = -1
	End If
	RegularExpression = Return_arr
End Function

Function ReadKeyCreateExists(HKEY, RegKey)
	Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
	objReg.GetStringValue HKEY_LOCAL_MACHINE,RegKey,"",regValue
	
	If IsEmpty(regValue) Then
	    Return = objReg.CreateKey(HKEY_LOCAL_MACHINE, RegKey)
		If (Return = 0) And (Err.Number = 0) Then    
		    Wscript.Echo "CreateKey Succeeded: " & RegKey
		    ReadKeyCreateExists = True
		Else
		    Wscript.Echo "CreateKey failed. Error = " & Err.Number
		    ReadKeyCreateExists = False
		End If
	Else
		ReadKeyCreateExists = True
	End If
End Function

Function CreateDword(HKEY, strKeyPath, strValueName, dwValue)
	Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _  
	    ".\root\default:StdRegProv")
	 Dim Success_Failure
	oReg.GetDWORDValue HKEY,strKeyPath,strValueName,regValue
	
	If IsEmpty(regValue) Then
	    Success_Failure = oReg.SetDWORDValue(HKEY,strKeyPath,strValueName,dwValue)
	Else
		Success_Failure = oReg.SetDWORDValue(HKEY,strKeyPath,strValueName,dwValue)
	End If
	' Read the values that were just written
	oReg.GetDWORDValue HKEY, strKeyPath,_
	    strValueName, arrStringValues   
	If CStr(arrStringValues) = CStr(dwValue) Then
	    CreateDword = CStr(arrStringValues)
	Else
		CreateDword = CInt(Success_Failure)
	End If
End Function

Sub CheckAddReg
	strKeyPath = "SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters"
	If ReadKeyCreateExists(HKEY_LOCAL_MACHINE, strKeyPath) Then
		returns = CreateDword(HKEY_LOCAL_MACHINE, strKeyPath, "MaxTokenSize2", "65535")
	End If
	
	If Not CStr(returns) = "65535" Then
		WScript.Echo "Failed to correct kerberos issue.", "Error:" & CStr(returns)
	Else
		WScript.Echo "Successfully created MaxTokenSize. You may need to restart computer and re-run this script."
	End If
End Sub