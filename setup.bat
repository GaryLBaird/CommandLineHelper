@ECHO OFF
::Capture Args to be used by functions below.
SET SELF_0=%0
SET SELF_1=%~dp0
SET ARG_1=%1
SET ARG_2=%2
SET ARG_3=%3
SET ARG_4=%4
SET ARG_5=%5
SET ARG_6=%6
SET ARG_7=%7
SET ARG_8=%8
SET ARG_9=%9
IF DEFINED ARG_1 SET ARGS=%ARG_1%
IF DEFINED ARG_2 SET ARGS=%ARGS%,%ARG_2%
IF DEFINED ARG_3 SET ARGS=%ARGS%,%ARG_3%
IF DEFINED ARG_4 SET ARGS=%ARGS%,%ARG_4%
IF DEFINED ARG_5 SET ARGS=%ARGS%,%ARG_5%
IF DEFINED ARG_6 SET ARGS=%ARGS%,%ARG_6%
IF DEFINED ARG_7 SET ARGS=%ARGS%,%ARG_7%
IF DEFINED ARG_8 SET ARGS=%ARGS%,%ARG_8%
IF DEFINED ARG_9 SET ARGS=%ARGS%,%ARG_9%
for /f "delims=- tokens=1,2,3*" %%a in ("%ARG_1%") do SET ARG_1=%%a 

:: This is where the functions are called, but only if an argument has been passed.
IF DEFINED ARGS CALL:%ARGS%
::  If no arguments were passed it will automatically show the help screen.
IF NOT DEFINED ARGS CALL:--Help
:: All Done time to clean up any variables and finish.
GOTO :DONE

:: Everything below this line will only be called if a function above has been passed on the command line.

::Formatout is an internal utility to format text.
:: Small Text Formatter Code Begin

:FORMATOUT
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
GOTO:eof

:padright
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:eof

:padleft
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:eof

:: Small Text Formatter Code End

:: Creates the alias file used when ever a command prompt window loads.

:--AliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
CALL:FORMATOUT 12,12,"","Please pick a directory for your alias file."
CALL:FORMATOUT 12,12,"Recommended:","Like: c:\CommaneLineHelper\Scripts"
SET /P _AliasFile_=[c:\CommaneLineHelper\Scripts]
IF NOT DEFINED _AliasFile_ SET _AliasFile_=c:\CommaneLineHelper\Scripts
IF NOT EXIST "!_AliasFile_!" MKDIR !_AliasFile_!
:: Disabled command for testing.
IF DEFINED ADD_REG REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d !_AliasFile_!\alias.cmd /f
IF NOT EXIST "!_AliasFile_!\alias.cmd" ECHO.>!_AliasFile_!\alias.cmd
ENDLOCAL && SET AliasFile=%_AliasFile_%
IF DEFINED ADD_REG SET ADD_REG=
CALL:FORMATOUT 12,12,"%~1","Created File:%AliasFile%\alias.cmd"
GOTO:EOF

:: Support for external function.

:--Copy
CALL:Copy "%~1","%~2"
GOTO:EOF

:: Non-protected Internal function.

:Copy
CALL:FORMATOUT 30,50,"Running:%~0","%~nx1"
SETLOCAL ENABLEDELAYEDEXPANSION
SET _File_=%~1
SET _LOCATION_=%~2
SET _EXISTS_=%~nx1
IF Exist "!_LOCATION_!\!_EXISTS_!" (
  SET /P __OVERWRITE__=Y/N
)
IF NOT EXIST "!_LOCATION_!" (
  CALL:FORMATOUT 30,50,"Make Directory:","!_LOCATION_!"
  MKDIR !_LOCATION_!
  CALL:FORMATOUT 30,50,"Make Directory Results:","%ERRORLEVEL%"
)
IF EXIST "!_File_!" (
  IF DEFINED __OVERWRITE__ (
    CALL:FORMATOUT 30,50,"OVERWRITE:","!__OVERWRITE__!"
  )
  IF NOT "!__OVERWRITE__!"=="N" (
    CALL:FORMATOUT 30,50,"Copying File:","!_EXISTS_!"
    COPY /Y !_File_! !_LOCATION_!
    CALL:FORMATOUT 30,50,"File Copy Results:","%ERRORLEVEL%"
  )
) ELSE (
  CALL:FORMATOUT 30,50,"File Not Found:","!_File_!"
)

IF EXIST "!_LOCATION_!\!_EXISTS_!" (
  CALL:FORMATOUT 30,50,"Results:!_EXISTS_!","Was successfully copied."
) ELSE (
   CALL:FORMATOUT 30,50,"Results:!_EXISTS_!","Was not successfully copied."
)
ENDLOCAL
GOTO:EOF

:--Install
IF NOT DEFINED AliasFile CALL:--AliasFile
SET _CLHScripts_=c:\CommaneLineHelper\Scripts
CALL:Copy "%SELF_1%CLHelper.bat","%_CLHScripts_%"
CALL:Copy "%SELF_1%scripts\cmd\alias.cmd","%AliasFile%"
CALL:Copy "%SELF_1%scripts\vbs\readwriteini.vbs","%_CLHScripts_%\vbs"
CALL:Copy "%SELF_1%scripts\vbs\txtComp.vbs","%_CLHScripts_%\vbs"
CALL:Copy "%SELF_1%scripts\bin\wget.1.txt","%_CLHScripts_%\bin"
CALL:Copy "%SELF_1%scripts\bin\wget.exe","%_CLHScripts_%\bin"
CALL %AliasFile%\alias.cmd
GOTO:EOF

:--Alias-Remove
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"File:%SELF_0% %~0","Attempting to remove registry key."
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
REG DELETE "HKCU\Software\Microsoft\Command Processor" /v AutoRun
CALL:FORMATOUT 20,20,"Results:","%ERRORLEVEL%"
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO:EOF

:: Help Content Below
:--Help
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"File:%SELF_0%","Options and Usage Help."
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"Options:","Description%~0"
CALL:FORMATOUT 20,20,"--About","Describes the author and purpose."
CALL:FORMATOUT 20,20,"--Alias-Remove","Removes the alias key to the registry."
CALL:FORMATOUT 20,20,"--AliasFile","Adds the alias file to the registry."
CALL:FORMATOUT 20,20," ..","Every time a command windows loads this alias.cmd file"
CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
CALL:FORMATOUT 20,20," .."," created or modified."
CALL:FORMATOUT 20,20,"--Copy","Copies a file and creates destination directory if missing."
CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% c:\directory\filename.name c:\destination"
CALL:FORMATOUT 20,20,"--Help","Displays this help menu."
CALL:FORMATOUT 20,20,"--Install","Installs CommandLineHelper."
CALL:FORMATOUT 20,20," ..  NOTE:"," You must run "SET ADD_REG=True" from the comandline to install the"
CALL:FORMATOUT 20,20," ..       "," registry key. The registry key must be set in order to have the"
CALL:FORMATOUT 20,20," ..       "," alias.cmd load everytime a command window has been launched ."
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO:EOF

:: Author Information Below
:--About
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"Author:","Gary L Baird"
CALL:FORMATOUT 20,20,"Written by:","Gary L Baird"
CALL:FORMATOUT 20,20,"Phone:","TBA"
CALL:FORMATOUT 20,20,"Email:","TBA"
CALL:FORMATOUT 20,20,"Filename:","%SELF_0%"
CALL:FORMATOUT 20,20,"Purpose:","Make the Windows Command Line more friendly."
CALL:FORMATOUT 20,20,"Project:","Part of the Command Line Helper project."
CALL:FORMATOUT 20,20,"Location:","github.com/GaryLBaird/CommaneLineHelper"
CALL:FORMATOUT 20,20,"License:","GNU GENERAL PUBLIC LICENSE"
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO:EOF

:DONE
::Clears Any Default Variables that might have been set while running this batch file.
SET _DEBUG_=
SET _PASSWORD_=
SET _CLEAN_=
SET ARGS=
goto :Finished
:Finished
