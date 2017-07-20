' Last Update Date	:	7/20/2017
On Error Resume Next

Set dtmConvertedDate = CreateObject("WbemScripting.SWbemDateTime")
Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Set oss = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")

' Windows 7 Kerberos packet size is not compatible with certain domains and may need a registry fix.
' Check for Windows 7
Dim Windows7, MessageboxText

For Each os in oss
    MessageboxText = MessageboxText & vbNewLine & os.Caption
    Windows7 = StrComp("Microsoft Windows 7 Professional ", CStr(os.Caption), 0)
    MessageboxText = MessageboxText & " Encryption Level: " & os.EncryptionLevel
    dtmConvertedDate.Value = os.InstallDate
    dtmInstallDate = dtmConvertedDate.GetVarDate
    MessageboxText = MessageboxText & vbNewLine & " Install Date: " & dtmInstallDate 
    MessageboxText = MessageboxText & vbNewLine & " Version: " & os.Version
Next
Const HKEY_CLASSES_ROOT 	= &H80000000
Const HKEY_CURRENT_USER 	= &H80000001
Const HKEY_LOCAL_MACHINE 	= &H80000002
Const HKEY_USERS 			= &H80000003
Const HKEY_CURRENT_CONFIG 	= &H80000005
Dim returns
Function ReadKeyCreateExists(HKEY, RegKey)
	Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
	objReg.GetStringValue HKEY_LOCAL_MACHINE,RegKey,"",regValue
	
	If IsEmpty(regValue) Then
	    Return = objReg.CreateKey(HKEY_LOCAL_MACHINE, RegKey)
		If (Return = 0) And (Err.Number = 0) Then    
		    MessageboxText = MessageboxText & vbNewLine & "CreateKey Succeeded: " & RegKey
		    ReadKeyCreateExists = True
		Else
		    MessageboxText = MessageboxText & vbNewLine & "CreateKey failed. Error = " & Err.Number
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
		returns = CreateDword(HKEY_LOCAL_MACHINE, strKeyPath, "MaxTokenSize", "65535")
	End If
	
	If Not CStr(returns) = "65535" Then
		MessageboxText = MessageboxText & vbNewLine & "Failed to correct kerberos issue." & vbNewLine & "Error:" & CStr(returns)
	Else
		MessageboxText = MessageboxText & vbNewLine & "Successfully created MaxTokenSize." & vbNewLine & "You may need to restart computer and re-run this script."
	End If
End Sub

If Windows7=0 Then
	MessageboxText = MessageboxText & vbNewLine & "Windows 7 has Kerberos packet size issues. We are attempting" & vbNewLine & _
		"to determine identify and fix this issues for you." & vbNewLine & _
		"NOTE:" & vbTab & "This may require you to restart your computer and re-run " & vbNewLine & _
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
		MessageboxText = MessageboxText & vbNewLine & "You will need to restart your computer and attempt to try running" & vbNewLine & _
			"to run cscript.exe '" & WScript.ScriptName & "' again."
		WScript.Echo MessageboxText
		WScript.Quit(1)
	End If
End If
strName = objUser.FullName
strTitle = objUser.Title
strDepartment = objUser.Department
strCompany = objUser.Company
strPhone = objUser.telephoneNumber
strEmail = objUser.mail

Set objWord = CreateObject("Word.Application")
If IsNull(objWord) Then
	MessageboxText = MessageboxText & vbNewLine & CStr(WScript.ScriptFullName) & " failed to find Microsoft Word. Please Install Microsoft word and try again."
	WScript.Echo MessageboxText
	WScript.Quit(1)
Else
	MessageboxText = MessageboxText & vbNewLine & "Found Word installed at path: " & CStr(objWord.Path)
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
objselection.TypeText(strEmail)
Set objLink = objSelection.Hyperlinks.Add(objSelection.Range, "mailto: " & strEmail, , , strEmail) 

' End of signature block

Set objSelection = objDoc.Range()

objSignatureEntries.Add "Script Signature", objSelection


objDoc.Saved = True
objWord.Quit
WScript.Echo MessageboxText