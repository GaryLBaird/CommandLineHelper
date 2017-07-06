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
IF NOT DEFINED IsInstalled (
  CALL:--IsInstalled NOSHOW
)
IF DEFINED IsInstalled (
  ECHO %IsInstalled%
) ELSE (
  ECHO You should run "setup.bat --Install"
)
IF NOT DEFINED Settings CALL:Settings
:: This is where the functions are called, but only if an argument has been passed.
IF DEFINED ARGS CALL:%ARGS%
::  If no arguments were passed it will automatically show the help screen.
IF NOT DEFINED ARGS CALL:--Help
:: All Done time to clean up any variables and finish.
GOTO :DONE

:: Everything below this line will only be called if a function above has been passed on the command line.

::Formatout is an internal utility to format text.
:: Small Text Formatter Code Begin

:--IsInstalled
CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper",%~1
SET IsInstalled=%RegKey%
GOTO:EOF

:-FindKey
ECHO %~0
SETLOCAL ENABLEDELAYEDEXPANSION
set KEY_NAME=%~1
set VALUE_NAME=%~2
SET NOSHOW=%~3
SET FOUND_KEY=Begin
FOR /F "skip=2 tokens=1*" %%A IN ('REG QUERY "%KEY_NAME%" /S ') DO (
  IF "!FOUND_KEY!"=="Begin" (
    SET "FOUND_KEY=%%A"
  ) ELSE (
    SET "FOUND_KEY=!FOUND_KEY!,%%A"
  )
)
ECHO FOUND_KEYS:"!FOUND_KEY!"
ENDLOCAL && SET FOUND_KEYS=%FOUND_KEY%
GOTO:EOF

:--ReadReg
SETLOCAL ENABLEDELAYEDEXPANSION
set KEY_NAME=%~1
set VALUE_NAME=%~2
SET NOSHOW=%~3
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
    CALL:FORMATOUT 50,50,"ENV:RegKey","%ValueValue%"
    CALL:FORMATOUT 50,50,"---------------------------------------------------","---------------------------------------------------"
  ) ELSE (
    CALL:FORMATOUT 50,50,"---------------------------------------------------","---------------------------------------------------"
    CALL:FORMATOUT 50,50,"Result:","Key and Name:"
    CALL:FORMATOUT 50,50,"-------","-------------"
    CALL:FORMATOUT 50,50,"Key Not Found!","'%KEY_NAME%' '%VALUE_NAME%'"
  )
)
ENDLOCAL && SET RegKey=%ValueValue%
GOTO:EOF

:Settings
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
CALL:INI_Config
SET _MySettings_=%IsInstalled%\clhelper.ini
CALL:--READINI "%_MySettings_%" "Local" "CLHelper_Dir" "FOUND"
IF NOT DEFINED FOUND (
  CALL:--WriteINI "%_MySettings_%" "Local" "CLHelper_Dir" "%IsInstalled%"
)
SET FOUND=
SET Settings=Set
GOTO:EOF

:: sleep for x number of seconds

:--Sleep
ping -n %1 127.0.0.1 > NUL 2>&1
GOTO:EOF

:FORMATOUT

SET __Left__=%~1
SET __RIGHT__=%~2
SET "__TEXT__=%~3"
SET "__OTHER__=%~4 %~5 %~6"
SET "spaces=                                                                                                                    "
SET /A __SIZE__=10
CALL:PADRIGHT __TEXT__ %__Left__%
CALL:PADLEFT __SIZE__ %__RIGHT__%
ECHO. %__TEXT__% %__OTHER__%
GOTO:EOF

:PADRIGHT
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:EOF

:PADLEFT
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

:--Install
If /I NOT "%~1"=="Options" CALL:%~1
If /I "%~1"=="Options" CALL:FORMATOUT 20,20,"Optional Paramters:","_"
If /I "%~1"=="Options" CALL:FORMATOUT 20,20,"Optional Paramters:","Git"
If /I "%~1"=="Options" CALL:FORMATOUT 20,20,"Optional Paramters:","Options"
If /I "%~1"=="Options" GOTO:Done
GOTO:EOF

:--Git
REM Eventually we need to look up the versions but for now this is not supported.
SET _GIT32bit_=https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/Git-2.13.2-32-bit.exe
SET _GIT64bit_=https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/Git-2.13.2-64-bit.exe
CALL:FORMATOUT 100,50,"--------------------------------------------------------------------------------------------------------",""
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" SET _AMD64_=True
IF DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 64-bit version","Y/N"
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 32-bit version:","Y/N"
SET /P _DOINSTALLGIT_=Do you wish to install Git?
CALL:FORMATOUT 100,50,"--------------------------------------------------------------------------------------------------------",""
IF DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_GIT64bit_%",""
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_GIT32bit_%",""
IF DEFINED _AMD64_ (
  SET _DOWNLOAD_=%_GIT64bit_%
) ELSE (
  SET _DOWNLOAD_=%_GIT32bit_%
)
IF /I "%_DOINSTALLGIT_%"=="Y" CALL:Download "%_DOWNLOAD_%","C:\CommandLineHelper\Downloads\Installs"

GOTO:EOF

:GetConfig
echo %~0
GOTO:EOF

:Download
CALL:FORMATOUT 40,30,"%~0",""
CALL:FORMATOUT 40,30,"%~1,%~2",""
REM IF NOT EXIST "%~2" (
  REM MKDIR %~2
REM )
SET _STRINGREPLACE_=%~2\%~nx1
SET _STRINGREPLACE_=%_STRINGREPLACE_:\=/%
powershell -executionPolicy bypass -noexit -file c:\CommaneLineHelper\scripts\powershell\downloadfile.ps1 "%~1" "%~nx1"
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


:--ReadINI
SET __INI_FILE__=%~1
SET __SEARCH_KEY__=%~2
SET __FIND_KEY__=%~3
SET _INI_RETURN_FILE_=%TEMP%\_INI_RETURN_FILE_.return
SET __INI_VAR_TO_SET__=%~4
SET __ECHO__=%~5
IF DEFINED __ECHO__ ECHO File:%~1 Section:%~2 Key:%~3 ReturnVar:"%~4"
IF EXIST "%_INI_RETURN_FILE_%" DEL /Q "%_INI_RETURN_FILE_%"
IF EXIST "%__INI_FILE__%" (
    FOR /F "delims=* usebackq" %%I in (%__INI_FILE__%) do (
        IF DEFINED _DEBUG_ CALL:DateTime "%~0 I1=%%I"
         FOR /F "tokens=1,2,3 delims==" %%A in ("%%I") do (
            IF DEFINED _DEBUG_ CALL:DateTime "%~0 A1=%%A"
             IF DEFINED _DEBUG_ CALL:DateTime "%~0 B1=%%B"
             IF /I ""=="%%B" (
                IF /I NOT "%%A"=="[%__SEARCH_KEY__%]" (
                    SET __SEARCH_KEY_FOUND__=
                    IF DEFINED _DEBUG_ CALL:DateTime "%~0 SET __SEARCH_KEY_FOUND__^="
                 )
                IF /I "%%A"=="[%__SEARCH_KEY__%]" (
                    SET __SEARCH_KEY_FOUND__=%__SEARCH_KEY__%
                    ECHO.%__SEARCH_KEY__%>"%_INI_RETURN_FILE_%"
                    IF DEFINED _DEBUG_ CALL:DateTime "%~0 SET __SEARCH_KEY_FOUND__^=%__SEARCH_KEY__%"
                 )
            )
        )
        IF EXIST "%_INI_RETURN_FILE_%" (
            IF DEFINED _DEBUG_ CALL:DateTime "%~0 I2=%%I"
             FOR /F "tokens=1,2,3 delims==" %%A in ("%%I") do (
                IF DEFINED _DEBUG_ CALL:DateTime "%~0 A2=%%A"
                 IF DEFINED _DEBUG_ CALL:DateTime "%~0 B2=%%B"
                 IF "%__FIND_KEY__%"=="%%A" SET %__INI_VAR_TO_SET__%=%%B
            )
        )
    )
) ELSE (
    IF DEFINED _DEBUG_ CALL:DateTime "%~0 Could Not Find File:%__INI_FILE__%"
 )
::Cleanup
SET __INI_FILE__=
SET __SEARCH_KEY__=
SET __FIND_KEY__=
SET __SEARCH_KEY_FOUND__=
SET __INI_VAR_TO_SET__=
IF EXIST "%_INI_RETURN_FILE_%" DEL /Q "%_INI_RETURN_FILE_%"
GOTO:EOF

:INI_Config
SET READ_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -r
SET WRITE_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -w
SET READ_INI_SECTION="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -rs
SET WRITE_INI_SECTION="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -ws
GOTO:EOF

:--WRITEINI
IF NOT EXIST "%~1" (
  ECHO [%~2] >"%~1"
  ECHO.>>"%~1"
)
%WRITE_INI_VALUE% %~1 %~2 %~3 %~4
CALL:--SLEEP 2
GOTO:EOF

:INI_Func
REM """Reads and writes to ini files. If found section key and value will SET key as varriable."""
SET _INI_RETURN_=
SETLOCAL ENABLEDELAYEDEXPANSION
SET _INI_FILE_=%~1
IF DEFINED _DEBUG_ CALL:DateTime "_INI_FILE_=!_INI_FILE_!"
 SET _INI_RETURN_FILE_=!TEMP!\INI_RETURN_!RANDOM!.log
IF DEFINED _DEBUG_ CALL:DateTime "_INI_RETURN_FILE_=!_INI_RETURN_FILE_!"
 SET _INI_COMMAND_=%~2
IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_=!_INI_COMMAND_!"
 SET _INI_SECTION_=%~3
IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_=!_INI_SECTION_!"
 SET _INI_KEY_=%~4
IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_=!_INI_KEY_!"
 SET _INI_VALUE_=%~5
IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_=!_INI_VALUE_!"
 IF DEFINED _INI_VALUE_ (
    SET _INI_VALUE_=!_INI_VALUE_:_comma_=,!
    SET _INI_VALUE_=!_INI_VALUE_:_backslash_=\!
    SET _INI_VALUE_=!_INI_VALUE_:_and_=^&!
)
SET _RETURN_VALUE=%~6
IF DEFINED _DEBUG_ CALL:DateTime "_RETURN_VALUE=!_RETURN_VALUE!"
 IF DEFINED _INI_COMMAND_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_ hit"
    IF DEFINED _INI_SECTION_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_ hit"
        IF DEFINED _INI_KEY_ (
            IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_ hit"
            IF /I "!_INI_COMMAND_!"=="-r" (
                    %READ_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" >"%_INI_RETURN_FILE_%"
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
            )
            IF DEFINED _INI_VALUE_ (
                IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_ hit"
                IF /I "!_INI_COMMAND_!"=="-w" (
                    IF DEFINED _DEBUG_ (
                        CALL:DateTime "_INI_COMMAND_ == !_INI_COMMAND_!"
                        CALL:DateTime "%WRITE_INI_VALUE% '%_INI_FILE_%' '!_INI_SECTION_!' '!_INI_KEY_!' '!_INI_VALUE_!'"
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!"
                    ) ELSE (
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!" >"%_INI_RETURN_FILE_%"
                    )
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
                )
            )
        )
        IF /I "!_INI_COMMAND_!"=="-rs" (
            %READ_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
        IF /I "!_INI_COMMAND_!"=="-ws" (
            %WRITE_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
    )
)
IF EXIST "!_INI_RETURN_FILE_!" (
    FOR /F %%A IN ('TYPE "!_INI_RETURN_FILE_!"') DO SET _INI_RETURN_=%%A
    DEL "!_INI_RETURN_FILE_!" /Q
)
ENDLOCAL&& SET _INI_RETURN_=%_INI_RETURN_%
IF DEFINED _INI_RETURN_ (
    IF /I "%~2"=="-rs" (
        FOR /F "eol=; tokens=1*" %%A IN ("%_INI_RETURN_%") DO (
            SET INI_RETURN=%_INI_RETURN_%
        )
    ) ELSE (
        FOR /F "tokens=1*" %%A IN ('ECHO "%_INI_RETURN_%" ^| findstr /r "="') DO (
            SET %_INI_RETURN_%
            )
        )
    )
)
GOTO:EOF

:: Help Content Below

:--Help
SETLOCAL ENABLEDELAYEDEXPANSION
IF /I "%ARGS%" GEQ "--Help" (
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
CALL:FORMATOUT 20,20,"-FindKey","Recursively search a registry hive for keys."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% -FindKey 'HKLM\Software\Hive' 'key' "
CALL:FORMATOUT 20,20," ..  Returns:","Env:Variable 'FOUND_KEYS'"
CALL:FORMATOUT 20,20,"--Install","Download and install a utility."
CALL:FORMATOUT 20,20," ..  Parameters:","[Git/Python2.7/Python3.1]"
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --Install Git"
CALL:FORMATOUT 20,20," ..  ListOptions:","%SELF_0% --Install Options"
CALL:FORMATOUT 20,20,"--GitCommit","Commits changes using git.exe"
CALL:FORMATOUT 20,20,"--GitForce","Cleans Source Repository for Git.exe"
CALL:FORMATOUT 20,20,"--Sleep","Sleep for x number of seconds."
CALL:FORMATOUT 20,20," ..  Usage:","'%SELF_0% --Sleep 10'","Will sleep for 10 seconds."
CALL:FORMATOUT 20,20,"--ReadINI","Reads a value from an '.ini' file."
CALL:FORMATOUT 20,20," ..  Parameters:","[file.ini] [section] [key] [Environment_Variable_Name]"
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --ReadINI 'FileName.ini' 'Section' 'Key' 'EnvVar'"
CALL:FORMATOUT 20,20," ..  Results:","If the key was found, the value of the Key will be"
CALL:FORMATOUT 20,20," ..  "," the value of EnvVar."
CALL:FORMATOUT 20,20," ..  Section:"," [section]"
CALL:FORMATOUT 20,20," ..  Key:Value:"," key=value"
CALL:FORMATOUT 20,20,"--RegRead","Reads a registry key and then sets an environment variable to"
CALL:FORMATOUT 20,20," ..  "," 'RegKey'."
CALL:FORMATOUT 20,20," ..Example:","%SELF_0% --ReadReg 'HKCU\Name\Name' 'KeyName' 'NOSHOW'"
CALL:FORMATOUT 20,20," ..Parameters:","Registry_Key Registry_Key_Name Optional:['NOSHOW']"
CALL:FORMATOUT 20,20,"--RandomColor","Randomly picks and sets the color of the command window."
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --RandomColor Background_Color Text_Color"
CALL:FORMATOUT 20,20,"--Help","Displays this help menu."
CALL:FORMATOUT 20,20,"--WindowsExplorer","Opens the Windows Explorer."
CALL:FORMATOUT 20,20," ..  Usage:","It will open to the directory passed on the command line."
CALL:FORMATOUT 20,20," ..  "," If no command was passed the current working directory is used."
CALL:FORMATOUT 20,20,"--WRITEINI","Writes a value to an '.ini' file."
CALL:FORMATOUT 20,20," ..  Parameters:","[file.ini] [section] [key] ['Your Data Here']"
CALL:FORMATOUT 20,20," ..  Usage:","%SELF_0% --WriteINI 'FileName.ini' 'Section' 'Key' 'Data'"
CALL:FORMATOUT 20,20," ..  Results:","If the file does not exist the file will be created."
CALL:FORMATOUT 20,20," ..  ","If the [Section] you provided was not found it will be created."
CALL:FORMATOUT 20,20," ..  ","If the [Key] you provided was not found it will be created."
CALL:FORMATOUT 20,20," ..  ","The string of data will be set to the value of the key you provided."
CALL:FORMATOUT 20,20," ..  Note:","Please do not use brackets when specifying a section."
CALL:FORMATOUT 20,20," ..  "," Malformed INI files are not supported. "
CALL:FORMATOUT 20,20," ..  Section:"," [section]"
CALL:FORMATOUT 20,20," ..  Key:Value:"," key=value"
CALL:FORMATOUT 20,20,"---------------------------","------------------------------------------------------"
)
ENDLOCAL
GOTO Done
GOTO:EOF

:: Author Information Below

:--About
SETLOCAL ENABLEDELAYEDEXPANSION
IF /I "%ARGS%" GEQ "--About" (
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
)
ENDLOCAL
GOTO Done
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
