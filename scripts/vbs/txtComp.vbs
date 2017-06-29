On Error Resume Next
Dim patternmatchexample
Sub help()
    WScript.Echo ""
    WScript.Echo "Replacement for command line or batch FindStr"
    WScript.Echo "replication topology for a given DC."
    WScript.Echo ""
    WScript.Echo "usage:--PatternMatch [pattern] as String, [string] as String" 
    WScript.Echo "Results: Returns matches found."
    WScript.Quit
End Sub    

Set oShell = CREATEOBJECT("Wscript.Shell") 

Select Case WScript.Arguments.Count
    Case 0
        help
    Case 3
        Select Case WScript.Arguments(0)
            Case "-?"
                help
               
            Case "?"
                help

            Case "/?"
                help              
            
            Case "--PatternMatch"
                PatternMatch WScript.Arguments(1), WScript.Arguments(2)
      
            Case Else
            	WScript.Echo WScript.Arguments(0)
        End Select
End Select

Function PatternMatch(patrn, strng)
  'WScript.Echo "Expression:", patrn, "String:", strng
  Dim regEx, Match, Matches, RetStr, Return   ' Create variables.
  Return = 0
  Set regEx = New RegExp   ' Create a regular expression.
  regEx.Pattern = patrn   ' Set pattern.
  regEx.IgnoreCase = True   ' Set case insensitivity.
  regEx.Global = True   ' Set global applicability.
  Set Matches = regEx.Execute(strng)   ' Execute search.

  For Each Match in Matches   ' Iterate Matches collection.
    RetStr = RetStr & Match.Value '& "'." & vbCRLF
    Return = Return + 1
  Next
  WScript.Echo "Result=" & RetStr
  PatternMatch = RetStr + Return
End Function
