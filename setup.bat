@ECHO OFF
REM :: Capture Args to be used by functions below.
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
FOR /f "delims=- tokens=1,2,3*" %%A IN ("%ARG_1%") DO SET ARG_1=%%A 

CALL:IsInstalled %NOSHOW%
REM :: This is where the functions are called, but only if an argument has been passed.
IF DEFINED ARGS CALL:%ARGS%
REM ::  If no arguments were passed it will automatically show the help screen.
IF NOT DEFINED ARGS CALL:--Help
REM :: All Done time to clean up any variables and finish.
GOTO :DONE

REM :: Everything below this line will only be called if a function above has been passed on the command line.

REM :: Formatout is an internal utility to format text.
REM :: Small Text Formatter Code Begin

:FORMATOUT
SETLOCAL ENABLEDELAYEDEXPANSION
  SET __Left__=%~1
  SET __RIGHT__=%~2
  SET "__TEXT__=%~3"
  SET "__OTHER__=%~4 %~5 %~6"
  SET "spaces=                                                                                                                    "
  SET /A __SIZE__=10
  CALL:PADRIGHT __TEXT__ %__Left__%
  CALL:PADLEFT __SIZE__ %__RIGHT__%
  REM ECHO %__TEXT__%+%__SIZE__%+%__OTHER__%
  ECHO. %__TEXT__% %__OTHER__%
ENDLOCAL
GOTO:eof

:PADRIGHT
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:eof

:PADLEFT
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:EOF

REM :: Small Text Formatter Code End

REM :: Creates the alias file used when ever a command prompt window loads.

:--AliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:FORMATOUT 12,12,"","Please pick a directory for your alias file."
  CALL:FORMATOUT 12,12,"Recommended:","Like: c:\CommandLineHelper"
  IF NOT DEFINED IsInstalled (
    SET /P CommandLineHelper= [c:\CommandLineHelper]
  ) ELSE (
    SET CommandLineHelper=%IsInstalled%
  )
  IF NOT DEFINED CommandLineHelper SET CommandLineHelper=c:\CommandLineHelper
  IF NOT EXIST "!CommandLineHelper!" MKDIR !CommandLineHelper!
ENDLOCAL && SET "CommandLineHelper=%CommandLineHelper%"
SETLOCAL ENABLEDELAYEDEXPANSION
  SET _INSTALLDIR_=!CommandLineHelper:\Scripts=!
  REM :: Disabled command for testing.
  IF DEFINED ADD_REG REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d !CommandLineHelper!\alias.cmd /f
  IF NOT EXIST "!CommandLineHelper!\alias.cmd" ECHO.>!CommandLineHelper!\alias.cmd
  ECHO. Setting Install directory to: %CommandLineHelper%
  REG ADD "HKCU\Software\Microsoft\Command Processor" /v CommandLineHelper /t REG_SZ /d %_INSTALLDIR_% /f
ENDLOCAL && SET "_INSTALLDIR_=%_INSTALLDIR_%" && SET "AliasFile=%CommandLineHelper%\alias.cmd"
IF DEFINED ADD_REG (
  SET ADD_REG=
)
CALL:FORMATOUT 12,12,"%~1","Created File:%AliasFile%"
GOTO:EOF

REM :: Support for external function.

:--Copy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:-Copy "%~1","%~2"
ENDLOCAL
GOTO:EOF

REM :: Non-protected Internal function.

:-Copy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:FORMATOUT 30,50,"Running:%~0","%~nx1"
  SET _File_=%~1
  SET _LOCATION_=%~2
  SET _EXISTS_=%~nx1
  IF EXIST "!_LOCATION_!\!_EXISTS_!" (
    ECHO Would you like to overwrite !_File_! Y/N?
    SET /P __OVERWRITE__=
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

:XCopy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:FORMATOUT 50,50,"Running:%~0","%~1"
  SET _SOURCE_=%~1
  SET _DESTINATION_=%~2
  IF EXIST "%~1" (
    ECHO Would you like to overwrite !_File_! Y/N?
    SET /P __OVERWRITE__=
  )
  IF /I NOT "!__OVERWRITE__!"=="N" ( 
    C:\Windows\System32\xcopy.exe /E /V /I /Y "!_SOURCE_!" "!_DESTINATION_!"
    IF EXIST "%~1" (
      CALL:FORMATOUT 50,50,"Results:!_DESTINATION_!","Was successfully copied."
    ) ELSE (
      CALL:FORMATOUT 50,50,"Results:!_DESTINATION_!","Was not copied. %ERRORLEVEL%"
    )
  ) ELSE (
    CALL:FORMATOUT 50,50,"Results:!_DESTINATION_!","Was not copied."
  )
ENDLOCAL
GOTO:EOF


:--Install
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","CommandLineHelper",%~1
  SET CLH_INSTALLDIR=%CommandLineHelper%
  IF NOT DEFINED AliasFile (
    CALL:--AliasFile
  )
  IF NOT DEFINED CommandLineHelper SET /P CommandLineHelper=Where to install? Default is [c:\CommandLineHelper].
  IF NOT DEFINED CommandLineHelper SET /P CommandLineHelper=c:\CommandLineHelper
  SET CLH_INSTALLDIR=CommandLineHelper
  CALL:XCopy "%SELF_1%bin\OpenSSH","!CommandLineHelper!\bin\OpenSSH"
  CALL:-Copy "%SELF_1%CLHelper.bat","!_CLHScripts_!"
  CALL:-Copy "%SELF_1%scripts\cmd\alias.cmd","!_CLHScripts_!\%AliasFile%"
  CALL:-Copy "%SELF_1%scripts\vbs\readwriteini.vbs","!_CLHScripts_!\vbs"
  CALL:-Copy "%SELF_1%scripts\vbs\txtComp.vbs","!_CLHScripts_!\vbs"
  CALL:-Copy "%SELF_1%scripts\powershell\downloadfile.ps1","!_CLHScripts_!\PowerShell"
  CALL:FORMATOUT 50,50,"Setting Install directory to:","!CommandLineHelper!"
  CALL:--RegAdd "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","REG_SZ","!CommandLineHelper!","/f"
ENDLOCAL && SET "AliasFile=%AliasFile%" && SET "CommandLineHelper=%CommandLineHelper%"
CALL %CommandLineHelper%\alias.cmd
CALL %_CLHScripts_%\clhelper.bat --SetupUserIniSettings
GOTO:EOF

:IsInstalled
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","CommandLineHelper",%~1
ENDLOCAL && SET "IsInstalled=%CommandLineHelper%" && SET "CommandLineHelper=%CommandLineHelper%" && SET "_CLHScripts_=%CommandLineHelper%\Scripts"
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AlternateAlias","AlternateAlias",%~1
ENDLOCAL && SET "AlternateAlias=%AlternateAlias%"
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AutoRun","AutoRun",%~1
ENDLOCAL && SET "AutoRunAlias=%AutoRun%"
GOTO:EOF

:--RegAdd
SETLOCAL ENABLEDELAYEDEXPANSION
REG ADD "%~1" /v "%~2" /t %~3 /d "%~4" %~5
ENDLOCAL
GOTO:EOF

:--ReadReg
SETLOCAL ENABLEDELAYEDEXPANSION
set KEY_NAME=%~1
set VALUE_NAME=%~2
set VAR_NAME=%~3
SET NOSHOW=%~4
FOR /F "tokens=1,2,3*" %%A IN ('REG QUERY "%KEY_NAME%" /v %VALUE_NAME% ') DO (
  IF /I "%%B" GEQ "REG" (
    SET Type=%%B
  )
  SET ValueValue=%%C
)
IF NOT DEFINED NOSHOW (
  IF DEFINED ValueValue (
    CALL:FORMATOUT 50,50,"---------------------------------------------------","---------------------------------------------------"
    CALL:FORMATOUT 50,50,"Key:","Value:"
    CALL:FORMATOUT 50,50,"----","------"
    CALL:FORMATOUT 50,50,"Name","%KEY_NAME%"
    CALL:FORMATOUT 50,50,"REG_Type","%Type%"
    CALL:FORMATOUT 50,50,"%VALUE_NAME%","%ValueValue%"
    CALL:FORMATOUT 50,50,"ENV:%~3","%ValueValue%"
    CALL:FORMATOUT 50,50,"---------------------------------------------------","---------------------------------------------------"
  ) ELSE (
    CALL:FORMATOUT 50,50,"---------------------------------------------------","---------------------------------------------------"
    CALL:FORMATOUT 50,50,"Result:","Key and Name:"
    CALL:FORMATOUT 50,50,"-------","-------------"
    CALL:FORMATOUT 50,50,"Key Not Found!","'%KEY_NAME%' '%VALUE_NAME%'"
  )
)
ENDLOCAL && SET "%~3=%ValueValue%"
GOTO:EOF

:--Alias-Remove
SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--Alias-Remove" (
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20,"File:%SELF_0% %~0","Attempting to remove registry key."
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
    REG DELETE "HKCU\Software\Microsoft\Command Processor" /v AutoRun
    CALL:FORMATOUT 20,20,"Results:","%ERRORLEVEL%"
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
  )
ENDLOCAL
GOTO:EOF

REM :: Help Content Below

:--Help
REM SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--Help" (
    CLS
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20,"File: %SELF_0%"," Options and Usage Help."
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
  )
REM ENDLOCAL
GOTO :HelpDone
:HelpDone
GOTO:EOF

REM :: Author Information Below

:--About
SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--About" (
    CLS
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20,"Author:","Gary L Baird"
    CALL:FORMATOUT 20,20,"Written by:","Gary L Baird"
    CALL:FORMATOUT 20,20,"Phone:","TBA"
    CALL:FORMATOUT 20,20,"Email:","TBA"
    CALL:FORMATOUT 20,20,"Filename:","%SELF_0%"
    CALL:FORMATOUT 20,20,"Purpose:","Make the Windows Command Line more friendly."
    CALL:FORMATOUT 20,20,"Project:","Part of the Command Line Helper project."
    CALL:FORMATOUT 20,20,"Location:","github.com/GaryLBaird/CommandLineHelper"
    CALL:FORMATOUT 20,20,"License:","GNU GENERAL PUBLIC LICENSE"
    CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
  )
ENDLOCAL
GOTO :AboutDone
:AboutDone
GOTO:EOF

:DONE

REM :: Clears Any Default Variables that might have been set while running this batch file.

SET _DEBUG_=
SET _PASSWORD_=
SET _CLEAN_=
SET ARGS=
SET NOSHOW=NOSHOW
goto :Finished

:Finished
