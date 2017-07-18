@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
  CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
  CALL:FORMATOUT 20,20," File: Setup.bat"," Options and Usage Help."
  CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
  CALL:FORMATOUT 20,20," Options:","Description 'Setup.bat'"
  CALL:FORMATOUT 20,20," --About","Describes the author and purpose."
  CALL:FORMATOUT 20,20," --Alias-Remove","Removes the alias key to the registry."
  CALL:FORMATOUT 20,20," --AliasFile","Adds the alias file to the registry."
  CALL:FORMATOUT 20,20," ..","Every time a command windows loads this alias.cmd file"
  CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
  CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
  CALL:FORMATOUT 20,20," .."," created or modified."
  CALL:FORMATOUT 20,20," --Copy","Copies a file and creates destination directory if missing."
  CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
  CALL:FORMATOUT 20,20," ..  Usage:","Setup.bat c:\directory\filename.name c:\destination"
  CALL:FORMATOUT 20,20," --Help","Displays this help menu."
  CALL:FORMATOUT 20,20," --Install","Installs CommandLineHelper."
  CALL:FORMATOUT 20,20," ..  NOTE:"," You must run "SET ADD_REG=True" from the comandline to install the"
  CALL:FORMATOUT 20,20," ..       "," registry key. The registry key must be set in order to have the"
  CALL:FORMATOUT 20,20," ..       "," alias.cmd load everytime a command window has been launched ."
  CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done
