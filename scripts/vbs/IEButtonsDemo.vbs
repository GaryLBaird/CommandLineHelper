Function IEButtons(ArrayToProcess())
  Dim buttons
  
  For i = 0 To ArrayToProcess.count()-1
    buttons = buttons & "<input type=""submit"" value=""" & ArrayToProcess(i)& """ onClick=""VBScript:OK.value=" & i+1 & """></p>"
  Next
    ' This function uses Internet Explorer to create a dialog.
    Dim objIE, sTitle, iErrorNum

    ' Create an IE object
    Set objIE = CreateObject( "InternetExplorer.Application" )
    ' specify some of the IE window's settings
    objIE.Navigate "about:blank"
    sTitle="Make your choice " & String( 80, "." ) 'Note: the String( 80,".") is to push "Internet Explorer" string off the window
    objIE.Document.title = sTitle
    objIE.MenuBar        = False
    objIE.ToolBar        = False
    objIE.AddressBar     = false
    objIE.Resizable      = True
    objIE.StatusBar      = False
    objIE.Width          = 300
    objIE.Height         = 400
    ' Center the dialog window on the screen
    With objIE.Document.parentWindow.screen
        objIE.Left = (.availWidth  - objIE.Width ) \ 2
        objIE.Top  = (.availHeight - objIE.Height) \ 2
    End With
    ' Wait till IE is ready
    Do While objIE.Busy
        WScript.Sleep 200
    Loop
    

    ' Insert the HTML code to prompt for user input
    objIE.Document.body.innerHTML = "<div align=""center"">" & vbcrlf _
                                  & "<p><input type=""hidden"" id=""OK"" name=""OK"" value=""0"">" _
                                  & buttons _
                                  & "<p><input type=""hidden"" id=""Cancel"" name=""Cancel"" value=""0"">" _
                                  & "<input type=""submit"" id=""CancelButton"" value=""Cancel"" onClick=""VBScript:Cancel.value=-1""></p></div>"

    ' Hide the scrollbars
    objIE.Document.body.style.overflow = "auto"
    ' Make the window visible
    objIE.Visible = True
    ' Set focus on Cancel button
    objIE.Document.all.CancelButton.focus


    'CAVEAT: If user click red X to close IE window instead of click cancel, an error will occur.
    '        Error trapping Is Not doable For some reason
    On Error Resume Next
    Do While objIE.Document.all.OK.value = 0 and objIE.Document.all.Cancel.value = 0
        WScript.Sleep 200
        iErrorNum=Err.Number
        If iErrorNum <> 0 Then    'user clicked red X (or alt-F4) to close IE window
            IEButtons = 0
            objIE.Quit
            Set objIE = Nothing
            Exit Function
        End if
    Loop
    On Error Goto 0

    objIE.Visible = False

    ' Read the user input from the dialog window
    IEButtons = objIE.Document.all.OK.value
    
    ' Close and release the object
    objIE.Quit
    Set objIE = Nothing
End Function

Dim MyArray()
Set objArgs = Wscript.Arguments

res = IEButtons(objArgs)
'WScript.Echo res
WScript.Quit(res)