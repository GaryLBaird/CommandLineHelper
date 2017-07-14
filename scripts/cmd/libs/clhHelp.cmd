@ECHO OFF
CALL:HELP %1 %2
:Done
GOTO :Done

:HELP
    CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20," File:%~1","Options and Usage Help."
    CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20," Options: ","Description %SELF_1% --Help"
    CALL:FORMATOUT 20,20," --About","Describes the author and purpose."
    CALL:FORMATOUT 20,20," --BestColor","Sets the color of the command window."
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --BestColor Background_Color Text_Color"
    CALL:FORMATOUT 20,20," --Copy","Copies a file and creates destination directory if missing."
    CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 c:\directory\filename.name c:\destination"
    CALL:FORMATOUT 20,20," --CreateAliasFile","Creates the alias file."
    CALL:FORMATOUT 20,20," ..","Every time a command windows loads this alias.cmd file"
    CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
    CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
    CALL:FORMATOUT 20,20," .."," created or modified."
    CALL:FORMATOUT 20,20," --FindKey","Recursively search a registry hive for keys."
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --FindKey 'HKLM\Software\Hive' 'key' "
    CALL:FORMATOUT 20,20," ..  Returns: ","Env:Variable 'FOUND_KEYS'"
    CALL:FORMATOUT 20,20," --GitCommit","Commits changes using git.exe"
    CALL:FORMATOUT 20,20," --GitForce","Cleans Source Repository for Git.exe"
    CALL:FORMATOUT 20,20," --Help","Displays this help menu."
    CALL:FORMATOUT 20,20," --Install","Download and install a utility."
    CALL:FORMATOUT 20,20," ..  Parameters: ","[Git/Python2.7/Python3.1]"
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --Install Git"
    CALL:FORMATOUT 20,20," ..  ListOptions: ","%~1 --Install Options"
    CALL:FORMATOUT 20,20," --JsonCheck","Checks file for valid json."
    CALL:FORMATOUT 20,20," ..  Usage: ","'%~1 --JsonCheck file.json'","Will sleep for 10 seconds."
    CALL:FORMATOUT 20,20," --ReadINI","Reads a value from an '.ini' file."
    CALL:FORMATOUT 20,20," ..  Parameters: ","[file.ini] [section] [key] [Environment_Variable_Name]"
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --ReadINI 'FileName.ini' 'Section' 'Key' 'EnvVar'"
    CALL:FORMATOUT 20,20," ..  Results: ","If the key was found, the value of the Key will be"
    CALL:FORMATOUT 20,20," ..  "," the value of EnvVar."
    CALL:FORMATOUT 20,20," ..  Section: "," [section]"
    CALL:FORMATOUT 20,20," ..  Key:Value: "," key=value"
    CALL:FORMATOUT 20,20," --RegRead","Reads a registry key and then sets an environment variable to"
    CALL:FORMATOUT 20,20," ..  "," 'RegKey'."
    CALL:FORMATOUT 20,20," ..Example: ","%~1 --ReadReg 'HKCU\Name\Name' 'KeyName' 'NOSHOW'"
    CALL:FORMATOUT 20,20," ..Parameters: ","Registry_Key Registry_Key_Name Optional:['NOSHOW']"
    CALL:FORMATOUT 20,20," --RandomColor","Randomly picks and sets the color of the command window."
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --RandomColor Background_Color Text_Color"
    CALL:FORMATOUT 20,20," --RDP","Opens remote desktop session for computername specified."
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --RDP Servername"
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --RDP "
    CALL:FORMATOUT 20,20," ..  Default: ","If no server is specified it will attempt to connect to "
    CALL:FORMATOUT 20,20," ..  Default: "," all the servers in the __WINDOWS_SERVERS__ variable."
    CALL:FORMATOUT 20,20," --Sleep","Sleep for x number of seconds."
    CALL:FORMATOUT 20,20," ..  Usage: ","'%~1 --Sleep 10'"
    CALL:FORMATOUT 20,20," ..  Results: ","Will sleep for 10 seconds."
    CALL:FORMATOUT 20,20," --WindowsExplorer","Opens the Windows Explorer."
    CALL:FORMATOUT 20,20," ..  Usage: ","It will open to the directory passed on the command line."
    CALL:FORMATOUT 20,20," ..  "," If no command was passed the current working directory is used."
    CALL:FORMATOUT 20,20," --WRITEINI","Writes a value to an '.ini' file."
    CALL:FORMATOUT 20,20," ..  Parameters: ","[file.ini] [section] [key] ['Your Data Here']"
    CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --WriteINI 'FileName.ini' 'Section' 'Key' 'Data'"
    CALL:FORMATOUT 20,20," ..  Results: ","If the file does not exist the file will be created."
    CALL:FORMATOUT 20,20," ..  ","If the [Section] you provided was not found it will be created."
    CALL:FORMATOUT 20,20," ..  ","If the [Key] you provided was not found it will be created."
    CALL:FORMATOUT 20,20," ..  ","The string of data will be set to the value of the key you provided."
    CALL:FORMATOUT 20,20," ..  Note: ","Please do not use brackets when specifying a section."
    CALL:FORMATOUT 20,20," ..  "," Malformed INI files are not supported. "
    CALL:FORMATOUT 20,20," ..  Section: "," [section]"
    CALL:FORMATOUT 20,20," ..  Key:Value: "," key=value"
    CALL:FORMATOUT 20,20," ---------------------------"," ------------------------------------------------------"
GOTO:EOF

:FORMATOUT
SETLOCAL ENABLEDELAYEDEXPANSION
  SET __Left__=%~1
  SET __RIGHT__=%~2
  SET "__TEXT__=%~3"
  SET "__OTHER__=%~4 %~5 %~6"
  SET "spaces=                                                                                                                    "
  SET /A __SIZE__=10
  CALL:padright __TEXT__ %__Left__%
  CALL:padleft __SIZE__ %__RIGHT__%
  REM ECHO %__TEXT__%+%__SIZE__%+%__OTHER__%
  ECHO. %__TEXT__% %__OTHER__%
ENDLOCAL
GOTO:eof

:padright
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:eof

:padleft
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:EOF

:Done