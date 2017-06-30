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

:: Command Line Helper needs to know a few things.
:: The MySettingsINI path is used to hold specific variables you use in your environment.
IF NOT DEFINED _MySettings_ SET /P _MySettings_=Please provide the path to your settings ini file.
:: The Command Line Helper needs to know where it's installed and where the VB scripts are.
IF NOT EXIST "C:\Windows\System32\cscript.exe" (
  IF NOT DEFINED _CSCRIPT_PATH_ SET /P _CSCRIPT_PATH_=Please provide the path to cscript.
) ELSE (
  SET _CSCRIPT_PATH_=C:\Windows\System32\cscript.exe
)
:: READWRITEINI PATH
IF NOT DEFINED _READWRITEINI_ (
  IF NOT EXIST "%SELF_1%\scripts\vbs\readwriteini.vbs" (
    SET /P _READWRITEINI_=Please provide the path to the readwriteini.vbs.
  ) ELSE (
    SET _READWRITEINI_=%SELF_1%\scripts\vbs\readwriteini.vbs
  )
)
:: READWRITEINI can only handle up to 7000 lines of text. After that it will truncate everything.
SET READ_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -r
SET WRITE_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -w

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
GOTO:EOF

:padleft
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:EOF

:: Small Text Formatter Code End
:: Creates the alias file used when ever a command prompt window loads.

:--CreateAliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
CALL:FORMATOUT 12,12,"Please pick a directory for your alias file.",""
CALL:FORMATOUT 12,12,"We recommend something simple with no spaces.","Like: c:\dev\scripts"
SET /P _AliasFile_=[c:\development\scripts]
IF NOT DEFINED _AliasFile_ SET _AliasFile_=C:\development\scripts
IF NOT EXIST "!_AliasFile_!" MKDIR !_AliasFile_!
:: Disabled command for testing. REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d !_AliasFile_!\alias.cmd /f
IF NOT EXIST "!_AliasFile_!\alias.cmd" ECHO.>!_AliasFile_!\alias.cmd
ENDLOCAL && SET AliasFile=%_AliasFile_%\alias.cmd
CALL:FORMATOUT 12,12,"%~1","Created File:%AliasFile%.alias.cmd"
GOTO:EOF

:: GitForce forces a removes all local changes and then pulls in new clean repo.

:--GitForce
git reset HEAD --hard
git clean -f
git pull origin master
GOTO:EOF

:: GitCommit pulls down latest and then commits your changes.

:--GitCommit
git pull
git add *
SET /P __MESSAGE__=Enter a message here.
git commit -am "%__MESSAGE__%"
git push
GOTO:EOF

:--Copy
CALL:Copy "%~1","%~2"
GOTO:EOF

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

:--BestColor
SETLOCAL ENABLEDELAYEDEXPANSION
SET "BackBroundColor=%~1"
SET "TextColor=%~2"
REM SET DEFAULTS:
IF NOT DEFINED BackBroundColor SET BackBroundColor=5
IF NOT DEFINED TextColor SET TextColor=E

IF "%~1"=="" GOTO :BestColorDone
IF /I "Black"=="%~1" SET BackBroundColor=0
IF /I "Black"=="%~2" SET TextColor=0
IF /I "Gray"=="%~1" SET BackBroundColor=8
IF /I "Gray"=="%~2" SET TextColor=8
IF /I "Grey"=="%~1" SET BackBroundColor=8
IF /I "Grey"=="%~2" SET TextColor=8
IF /I "Blue"=="%~1" SET BackBroundColor=1
IF /I "Blue"=="%~2" SET TextColor=1
IF /I "Light Blue"=="%~1" SET BackBroundColor=9
IF /I "Light Blue"=="%~2" SET TextColor=9
IF /I "lBlue"=="%~1" SET BackBroundColor=9
IF /I "LBlue"=="%~2" SET TextColor=9
IF /I "Green"=="%~1" SET BackBroundColor=2
IF /I "Green"=="%~2" SET TextColor=2
IF /I "Light Green"=="%~1" SET BackBroundColor=A
IF /I "Light Green"=="%~2" SET TextColor=A
IF /I "LGreen"=="%~1" SET BackBroundColor=A
IF /I "LGreen"=="%~2" SET TextColor=A
IF /I "Aqua"=="%~1" SET BackBroundColor=3
IF /I "Aqua"=="%~2" SET TextColor=3
IF /I "Light Aqua"=="%~1" SET BackBroundColor=B
IF /I "Light Aqua"=="%~2" SET TextColor=B
IF /I "LAqua"=="%~1" SET BackBroundColor=B
IF /I "LAqua"=="%~2" SET TextColor=B
IF /I "Red"=="%~1" SET BackBroundColor=4
IF /I "Red"=="%~2" SET TextColor=4
IF /I "Light Red"=="%~1" SET BackBroundColor=C
IF /I "Light Red"=="%~2" SET TextColor=C
IF /I "LRed"=="%~1" SET BackBroundColor=C
IF /I "LRed"=="%~2" SET TextColor=C
IF /I "Purple"=="%~1" SET BackBroundColor=5
IF /I "Purple"=="%~2" SET TextColor=5
IF /I "Light Purple"=="%~1" SET BackBroundColor=D
IF /I "Light Purple"=="%~2" SET TextColor=D
IF /I "LPurple"=="%~1" SET BackBroundColor=D
IF /I "LPurple"=="%~2" SET TextColor=D
IF /I "Yellow"=="%~1" SET BackBroundColor=6
IF /I "Yellow"=="%~2" SET TextColor=6
IF /I "Light Yellow"=="%~1" SET BackBroundColor=E
IF /I "Light Yellow"=="%~2" SET TextColor=E
IF /I "LYellow"=="%~1" SET BackBroundColor=E
IF /I "LYellow"=="%~2" SET TextColor=E
IF /I "White"=="%~1" SET BackBroundColor=7
IF /I "White"=="%~2" SET TextColor=7
IF /I "Bright White"=="%~1" SET BackBroundColor=F
IF /I "Bright White"=="%~2" SET TextColor=F
IF /I "LWhite"=="%~1" SET BackBroundColor=F
IF /I "LWhite"=="%~2" SET TextColor=F
:: Yellow Text Purple Background 
:BestColorDone
Color !BackBroundColor!!TextColor!
ENDLOCAL
CLS
GOTO:EOF

:--RandomColor
SETLOCAL ENABLEDELAYEDEXPANSION
SET /a LETTER=(%Random% %%6)+1
SET /a NUMBER=(%Random% %%9)+1
GOTO :CASE_!LETTER!
:CASE_1
  SET RETURN=A
  GOTO :END_CASE
:CASE_2
  SET RETURN=B
  GOTO :END_CASE
:CASE_3
  SET RETURN=C
  GOTO :END_CASE
:CASE_4
  SET RETURN=D
  GOTO :END_CASE
:CASE_5
  SET RETURN=E
  GOTO :END_CASE
:CASE_6
  SET RETURN=F
  GOTO :END_CASE
:END_CASE

ENDLOCAL && set RETURN=%return% && SET NUMBER=%NUMBER%
IF DEFINED RETURN COLOR %NUMBER%%RETURN%
GOTO:EOF

:: --WindowsExplorer opens an instance of file system explorer.
::   Supports 1 directory argument. If no arguments passed the directory
::   where the command was run will be used.

:--WindowsExplorer
SETLOCAL ENABLEDELAYEDEXPANSION
IF "%~1"=="" (
  SET _DIR_=%CD%
) ELSE (
  SET _DIR_=%~1
)
"C:\Windows\explorer.exe" "!_DIR_!"
ENDLOCAL
GOTO:EOF

:: Help Content Below

:--Help

CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"File:%SELF_0%","Options and Usage Help."
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"Options:","Description%~0"
CALL:FORMATOUT 20,20,"--About","Describes the author and purpose."
CALL:FORMATOUT 20,20,"--BestColor","Sets the color of the command window."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --BestColor Background_Color Text_Color"
CALL:FORMATOUT 20,20,"--Copy","Copies a file and creates destination directory if missing."
CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% c:\directory\filename.name c:\destination"
CALL:FORMATOUT 20,20,"--CreateAliasFile","Creates the alias file."
CALL:FORMATOUT 20,20," ..","Every time a command windows loads this alias.cmd file"
CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
CALL:FORMATOUT 20,20," .."," created or modified."
CALL:FORMATOUT 20,20,"--RandomColor","Randomly picks and sets the color of the command window."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --RandomColor Background_Color Text_Color"
CALL:FORMATOUT 20,20,"--Help","Displays this help menu."
CALL:FORMATOUT 20,20,"--WindowsExplorer","Opens the Windows Explorer."
CALL:FORMATOUT 20,20," ..  Usage:","It will open to the directory passed on the command line."
CALL:FORMATOUT 20,20," ..  "," If no command was passed the current working directory is used."
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO:EOF

:: Author Information Below

:--About

CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20,"Author:--------------------","Gary L Baird"
CALL:FORMATOUT 20,20,"Written by:----------------","Gary L Baird"
CALL:FORMATOUT 20,20,"Phone:---------------------","TBA"
CALL:FORMATOUT 20,20,"Email:---------------------","TBA"
CALL:FORMATOUT 20,20,"Filename:------------------","%SELF_0%"
CALL:FORMATOUT 20,20,"Purpose:-------------------","Make the Windows Command Line more friendly."
CALL:FORMATOUT 20,20,"Project:-------------------","Part of the Command Line Helper project."
CALL:FORMATOUT 20,20,"Location:-------------------","github.com/GaryLBaird/CommaneLineHelper"
CALL:FORMATOUT 20,20,"License:-------------------","GNU GENERAL PUBLIC LICENSE"
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
GOTO:EOF

:DONE
::Clears Any Default Variables that might have been set while running this batch file.
SET _DEBUG_=
SET _PASSWORD_=
SET _CLEAN_=
SET ARGS=
SET __RUNONCEONLY__=
goto :Finished
:Finished
