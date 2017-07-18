' List Registry Values and Types

' Standard housekeeping
Const HKEY_CLASSES_ROOT              = &H80000000
Const HKEY_CURRENT_USER              = &H80000001
Const HKEY_LOCAL_MACHINE             = &H80000002
Const HKEY_USERS                     = &H80000003
Const HKEY_CURRENT_CONFIG            = &H80000005
Const HKEY_DYN_DATA                  = &H80000006 ' Windows 95/98 only
Const REG_SZ = 1
Const REG_EXPAND_SZ = 2
Const REG_BINARY = 3
Const REG_DWORD = 4
Const REG_MULTI_SZ = 7
 
strComputer = "."
 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _ 
    strComputer & "\root\default:StdRegProv")
 
strKeyPath = "Software\Microsoft\Command Processor"
 
oReg.EnumValues HKEY_CURRENT_USER, strKeyPath, _
    arrValueNames, arrValueTypes
For i=0 To UBound(arrValueNames)
    Wscript.Echo "Value Name: " & arrValueNames(i)

    Select Case arrValueTypes(i)
        Case REG_SZ
            Wscript.Echo "Data Type: String"
            Wscript.Echo
        Case REG_EXPAND_SZ
            Wscript.Echo "Data Type: Expanded String"
            Wscript.Echo
        Case REG_BINARY
            Wscript.Echo "Data Type: Binary"
            Wscript.Echo
        Case REG_DWORD
            Wscript.Echo "Data Type: DWORD"
            Wscript.Echo
        Case REG_MULTI_SZ
            Wscript.Echo "Data Type: Multi String"
            Wscript.Echo
    End Select 
Next