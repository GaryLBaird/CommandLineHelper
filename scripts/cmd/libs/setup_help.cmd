  CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
  CALL:FORMATOUT 20,20," File: %SELF_0%"," Options and Usage Help."
  CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
  CALL:FORMATOUT 20,20," Options:","Description '%~0'"
  CALL:FORMATOUT 20,20," --About","Describes the author and purpose."
  CALL:FORMATOUT 20,20," --Alias-Remove","Removes the alias key to the registry."
  CALL:FORMATOUT 20,20," --AliasFile","Adds the alias file to the registry."
  CALL:FORMATOUT 20,20," ..","Every time a command windows loads this alias.cmd file"
  CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
  CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
  CALL:FORMATOUT 20,20," .."," created or modified."
  CALL:FORMATOUT 20,20," --Copy","Copies a file and creates destination directory if missing."
  CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
  CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% c:\directory\filename.name c:\destination"
  CALL:FORMATOUT 20,20," --Help","Displays this help menu."
  CALL:FORMATOUT 20,20," --Install","Installs CommandLineHelper."
  CALL:FORMATOUT 20,20," ..  NOTE:"," You must run "SET ADD_REG=True" from the comandline to install the"
  CALL:FORMATOUT 20,20," ..       "," registry key. The registry key must be set in order to have the"
  CALL:FORMATOUT 20,20," ..       "," alias.cmd load everytime a command window has been launched ."
  CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO :Done

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