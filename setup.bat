@ECHO OFF
::Capture Args to be used by functions below.
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

IF DEFINED ARGS CALL:%ARGS%
IF NOT DEFINED ARGS CALL:--Help
GOTO :DONE

::Formatout is an internal utility to format text.
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

:--CreateAliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
CALL:FORMATOUT 12,12,"Please pick a directory for your alias file.",""
CALL:FORMATOUT 12,12,"We recommend something simple with no spaces.","Like: c:\dev\scripts"
SET /P _AliasFile_=[c:\dev\scripts]
IF NOT DEFINED _AliasFile_ SET _AliasFile_=C:\dev\scripts\
IF NOT EXIST "!_AliasFile_!" MKDIR !_AliasFile_!
:: Disabled command for testing. REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d !_AliasFile_!\alias.cmd /f
IF NOT EXIST "!_AliasFile_!\alias.cmd" ECHO.>!_AliasFile_!\alias.cmd
ENDLOCAL && SET AliasFile=%_AliasFile_%\alias.cmd
CALL:FORMATOUT 12,12,"%~1","Created File:%AliasFile%.alias.cmd"
GOTO:EOF

:--Help
CALL:FORMATOUT 12,12,"---------------------------","---------------------------"
CALL:FORMATOUT 12,12,"Options:","Description:"
CALL:FORMATOUT 12,12,"---------------------------","---------------------------"
GOTO:EOF

:DONE
SET _DEBUG_=
SET _PASSWORD_=
SET __CLEAN__=
SET ARGS=
goto :Finished
:Finished
