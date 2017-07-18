' Read a Text File into an Array

If WScript.Arguments.Count = 1 Then
	Const ForReading = 1
	Dim results
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objTextFile = objFSO.OpenTextFile _
	    (WScript.Arguments(0), ForReading)
	
	Do Until objTextFile.AtEndOfStream
	    strNextLine = objTextFile.Readline
	    If RegularExpressionCheck("^SET _CustomAliasDir_.*", CStr(strNextLine)) Then
		    arrServiceList = Split(strNextLine , "=")
		    If IsArray(arrServiceList) And UBound(arrServiceList) >= 0 Then
			    'Wscript.Echo "arrServiceList(0)" & arrServiceList(0)
			    For i = 1 to Ubound(arrServiceList)
					myValue = InputBox("Where do you want to put your custom alias file?", "Custom Alias Directory", CStr(arrServiceList(i)))
					results=results & arrServiceList(0) & "=" & CStr(myValue) & vbNewLine
				Next
			End If
	    Else 
		    If RegularExpressionCheck("^SET _CustomAliasFile_.*", CStr(strNextLine)) Then
			    arrServiceList = Split(strNextLine , "=")
			    If IsArray(arrServiceList) And UBound(arrServiceList) >= 0 Then
				    'Wscript.Echo "arrServiceList(0)" & arrServiceList(0)
				    For i = 1 to Ubound(arrServiceList)
						myValue = InputBox("What would you like to name your custom alias file?", "Custom Alias CMD File", CStr(arrServiceList(i)))
						If RegularExpressionCheck(".*.cmd", CStr(myValue)) Then
							results=results & arrServiceList(0) & "=" & CStr(myValue) & vbNewLine
						Else
							WScript.Echo "You must provide a valid string value."
							results=results & CStr(strNextLine) & vbNewLine
						End If
					Next
				End If
		    Else
		    	results=results & CStr(strNextLine) & vbNewLine
		    End If
		    
	    End If
	Loop
	
	WScript.Echo results
Else
	WScript.Echo "This is a setup script."
End If

Function RegularExpressionCheck(pattern, strContents)
	Dim returned
	returned = False
	Set objRE = New RegExp
	objRE.Global     = True
	objRE.IgnoreCase = True
	objRE.Pattern    = pattern
	
	Set colMatches = objRE.Execute(strContents)
	' WScript.Echo vbNewLine & "Resulting Matches:"
	For Each objMatch In colMatches
	   returned = True
	Next
	RegularExpressionCheck = returned
End Function
