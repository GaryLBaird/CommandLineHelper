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

IF NOT DEFINED IsAdmin CALL:check_Permissions
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

:check_Permissions
    CALL:FORMATOUT 50,50,"Administrative permissions required.","Detecting permissions..."
    net session >nul 2>&1
    if %errorLevel% == 0 (
        CALL:FORMATOUT 50,50,"Success:","Administrative permissions confirmed."
        SET IsAdmin=True
    ) else (
        CALL:FORMATOUT 50,50,"Failed:","Please start a new command window with administrative permissions."
        SET /P _USER_=Press Enter Continue:
        SET ARGS=GoToDone
    )
GOTO:EOF

:GoToDone
SET ARGS=Done
GOTO:EOF

:PADRIGHT
  CALL SET padded=%%%1%%%spaces%
  CALL SET %1=%%padded:~0,%2%%
GOTO:EOF

:PADLEFT
  CALL SET padded=%spaces%%%%1%%
  CALL SET %1=%%padded:~-%2%%
GOTO:EOF

:SETUP_FORMATOUT
CALL:PADRIGHT __TEXT__ %__Left__%
CALL:PADLEFT __SIZE__ %__RIGHT__%
::ECHO %__TEXT__%+%__SIZE__%+%__OTHER__%
ECHO. %__TEXT__% %__OTHER__%
GOTO:EOF

:FORMATOUT
SETLOCAL ENABLEDELAYEDEXPANSION
  SET __Left__=%~1
  SET __RIGHT__=%~2
  SET "__TEXT__=%~3"
  SET "__OTHER__=%~4 %~5 %~6"
  SET "spaces=                                                                                                                    "
  SET /A __SIZE__=10
  IF EXIST " %CLHLibs%\FORMATOUT.cmd" (
    %CLHLibs%\FORMATOUT.cmd "!__Left__!" "!__RIGHT__!" "!__TEXT__!" "!__OTHER__!"
  )
  IF NOT EXIST " %CLHLibs%\FORMATOUT.cmd" (
    CALL:SETUP_FORMATOUT "!__Left__!" "!__RIGHT__!" "!__TEXT__!" "!__OTHER__!"
  )
  
ENDLOCAL
GOTO:EOF

:--AliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
  REM CALL:FORMATOUT 12,12,""," Please pick a directory for your alias file."
  REM CALL:FORMATOUT 12,12," Recommended:"," Like: c:\CommandLineHelper"
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
  CALL %CLHLibs%\addRegKey.cmd "HKCU\Software\Microsoft\Command Processor" "AutoRun" "REG_SZ" "!CommandLineHelper!\scripts\cmd\alias.cmd"
  ECHO. Setting Install directory to: %CommandLineHelper%
  CALL %CLHLibs%\addRegKey.cmd "HKCU\Software\Microsoft\Command Processor" "CommandLineHelper" "REG_SZ" "!_INSTALLDIR_!"
ENDLOCAL && SET "_INSTALLDIR_=%_INSTALLDIR_%" && SET "AliasFile=%_INSTALLDIR_%\scripts\cmd\alias.cmd"
IF DEFINED ADD_REG (
  SET ADD_REG=
)
echo done


GOTO:EOF

REM :: Support for external function.

:--Copy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:-Copy "%~1" "%~2" %~3
ENDLOCAL
GOTO:EOF

REM :: Non-protected Internal function.

:-Copy
SET OVERWRITEALL=%~3
SETLOCAL ENABLEDELAYEDEXPANSION
IF DEFINED OVERWRITEALL __OVERWRITE__=Y
  CALL:FORMATOUT 30,50,"Running:%~0","%~nx1"
  SET _File_=%~1
  SET _LOCATION_=%~2
  SET _EXISTS_=%~nx1
  IF EXIST "!_LOCATION_!\!_EXISTS_!" (
    IF NOT DEFINED OVERWRITEALL ECHO Would you like to overwrite !_File_! Y/N?
    IF NOT DEFINED OVERWRITEALL SET /P __OVERWRITE__=
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
SET OVERWRITEALL=%~3
SETLOCAL ENABLEDELAYEDEXPANSION
IF DEFINED OVERWRITEALL SET __OVERWRITE__ =Y
  CALL:FORMATOUT 50,50,"Running:%~0","%~1"
  SET _SOURCE_=%~1
  SET _DESTINATION_=%~2
  IF EXIST "%~1" (
    IF NOT DEFINED OVERWRITEALL ECHO Would you like to overwrite !_File_! Y/N?
    IF NOT DEFINED OVERWRITEALL SET /P __OVERWRITE__=
  )
  IF /I NOT "!__OVERWRITE__!"=="N" ( 
    C:\Windows\System32\xcopy.exe /E /V /I /Y "!_SOURCE_!" "!_DESTINATION_!"
    IF EXIST "%~1" (
      CALL:FORMATOUT 50,50," Results:!_DESTINATION_!"," Was successfully copied."
    ) ELSE (
      CALL:FORMATOUT 50,50," Results:!_DESTINATION_!"," Was not copied. %ERRORLEVEL%"
    )
  ) ELSE (
    CALL:FORMATOUT 50,50," Results:!_DESTINATION_!"," Was not copied."
  )
ENDLOCAL
:: DONE!
GOTO:EOF

:--Install
SET __Prompt__=%~1
SET __KeepWriteSetting__=%~1
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","CommandLineHelper",%~1
  SET CLH_INSTALLDIR=%CommandLineHelper%
  IF NOT DEFINED AliasFile (
    CALL:--AliasFile
  )
  IF NOT DEFINED CommandLineHelper SET /P CommandLineHelper=Where to install? Default is [c:\CommandLineHelper].
  IF NOT DEFINED CommandLineHelper SET /P CommandLineHelper=c:\CommandLineHelper
  SET CLH_INSTALLDIR=CommandLineHelper
  CALL:-Copy "%SELF_1%scripts\cmd\alias.cmd","!_CLHScripts_!" %__Prompt__%
  CALL:-Copy "%SELF_1%scripts\cmd\alias.cmd","!_CLHScripts_!\cmd" %__Prompt__%
  CALL:-Copy "%SELF_1%CLHelper.bat","!_CLHScripts_!" %__Prompt__%
  REM CALL:-Copy "%SELF_1%scripts\cmd\alias.cmd","!_CLHScripts_!"
  REM CALL:-Copy "%SELF_1%scripts\vbs\readwriteini.vbs","!_CLHScripts_!\vbs"
  REM CALL:-Copy "%SELF_1%scripts\vbs\txtComp.vbs","!_CLHScripts_!\vbs"
  REM CALL:-Copy "%SELF_1%scripts\powershell\downloadfile.ps1","!_CLHScripts_!\PowerShell"
  CALL:FORMATOUT 50,50,"Setting Install directory to:","!CommandLineHelper!"
  CALL:--RegAdd "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","REG_SZ","!CommandLineHelper!","/f"
  CALL:XCopy "%SELF_1%scripts\PowerShell","!CommandLineHelper!\scripts\PowerShell"%__Prompt__%
  CALL:XCopy "%SELF_1%scripts\vbs","!CommandLineHelper!\scripts\vbs" %__Prompt__%
  CALL:XCopy "%SELF_1%bin\curl","!CommandLineHelper!\bin\curl" %__Prompt__%
  CALL:XCopy "%SELF_1%scripts\cmd","!CommandLineHelper!\scripts\cmd" %__Prompt__%
  CALL:XCopy "%SELF_1%bin\OpenSSH","!CommandLineHelper!\bin\OpenSSH" %__Prompt__%
  CALL:XCopy "%SELF_1%scripts\ruby","!_CLHScripts_!\ruby" %__Prompt__%
  CALL:XCopy "%SELF_1%bin\PuTTY","!CommandLineHelper!\bin\PuTTY" %__Prompt__%
  CALL:XCopy "%SELF_1%scripts\installs","!CommandLineHelper!\scripts\installs" %__Prompt__%
  WHERE Curl.exe >nul
  IF "%ERRORLEVEL%"=="1" (
    SETX PATH "%PATH%;!CommandLineHelper!\bin\curl" /M
  )
  WHERE scp.exe >nul
  IF "%ERRORLEVEL%"=="1" (
    SETX PATH "%PATH%;!CommandLineHelper!\bin\OpenSSH\bin" /M
  )
ENDLOCAL && SET "AliasFile=%AliasFile%" && SET "CommandLineHelper=%CommandLineHelper%"
CALL %CommandLineHelper%\scripts\cmd\alias.cmd
IF NOT DEFINED __KeepWriteSetting__ SET /P SET __KeepWriteSetting__=Keep your current settings? Y for yes or enter to continue:
IF /I "%__KeepWriteSetting__%"=="Y" (
  SET __KeepWriteSetting__=Y
) ELSE (
  SET __KeepWriteSetting__=
)
CALL %_CLHScripts_%\clhelper.bat --SetupUserIniSettings %__KeepWriteSetting__%
GOTO:EOF

:IsInstalled
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","CommandLineHelper",%~1
ENDLOCAL && SET "IsInstalled=%CommandLineHelper%" && SET "CommandLineHelper=%CommandLineHelper%" && SET "_CLHScripts_=%CommandLineHelper%\Scripts"
REM SETLOCAL ENABLEDELAYEDEXPANSION
  REM CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AlternateAlias","AlternateAlias",%~1
REM ENDLOCAL && SET "AlternateAlias=%AlternateAlias%"
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AutoRun","AutoRun",%~1
ENDLOCAL && SET "AutoRunAlias=%AutoRun%"
IF EXIST "%CD%\scripts\cmd\libs" (
  SET CLHLibs=%CD%\scripts\cmd\libs
)
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
    CALL:FORMATOUT 50,50," ---------------------------------------------------","---------------------------------------------------"
    CALL:FORMATOUT 50,50," Key:","Value:"
    CALL:FORMATOUT 50,50," ----","------"
    CALL:FORMATOUT 50,50," Name","%KEY_NAME%"
    CALL:FORMATOUT 50,50," REG_Type","%Type%"
    CALL:FORMATOUT 50,50," %VALUE_NAME%","%ValueValue%"
    CALL:FORMATOUT 50,50," ENV:%~3","%ValueValue%"
    CALL:FORMATOUT 50,50," ---------------------------------------------------","---------------------------------------------------"
  ) ELSE (
    CALL:FORMATOUT 50,50," ---------------------------------------------------","---------------------------------------------------"
    CALL:FORMATOUT 50,50," Result:","Key and Name:"
    CALL:FORMATOUT 50,50," -------","-------------"
    CALL:FORMATOUT 50,50," Key Not Found!","'%KEY_NAME%' '%VALUE_NAME%'"
  )
)
ENDLOCAL && SET "%~3=%ValueValue%"
GOTO:EOF

:--Alias-Remove
SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--Alias-Remove" (
    CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
    CALL:FORMATOUT 20,20," File:%SELF_0% %~0","Attempting to remove registry key."
    CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
    REG DELETE "HKCU\Software\Microsoft\Command Processor" /v AutoRun
    CALL:FORMATOUT 20,20," Results:","%ERRORLEVEL%"
    CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
  )
ENDLOCAL
GOTO:EOF

REM :: Help Content Below

:--Help
IF /I "%ARGS%" GEQ "--Help" (
  CLS
  %CLHLibs%\setup_help.cmd
)
GOTO:EOF

REM :: Author Information Below

:--About
IF /I "%ARGS%" GEQ "--About" (
  CLS
  %CLHLibs%\about.cmd
)
GOTO:EOF

REM :FORMATOUT
REM CALL:--FORMATOUT "%~1","%~2","%~3","%~4","%~5%~6%~7"
REM goto :formatdone
REM :formatdone
REM GOTO:EOF

:DONE

REM :: Clears Any Default Variables that might have been set while running this batch file.

SET _DEBUG_=
SET _PASSWORD_=
SET _CLEAN_=
SET ARGS=
SET NOSHOW=NOSHOW
goto :Finished

:Finished
