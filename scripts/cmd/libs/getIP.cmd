@ECHO OFF
CALL:getIP %1 %2
:getIP host ret -- return THIS computers IP address
::              -- host [in,opt]  - host name, default is THIS computer
::              -- ret  [out,opt] - IP v6 unless it's a domain.
:$created 20060101 :$changed 20080219 :$categories Network
:$source http://www.dostips.com
SETLOCAL
set host=%~1
set ip=
if "%host%"=="" ( for /f "tokens=2,* delims=:. " %%a in ('"ipconfig|find "IP Address""') do set ip=%%b
) ELSE ( for /f "tokens=2 delims=[]" %%a in ('"ping /a /n 1 %host%|find "Pinging" 2>NUL"') do set ip=%%a)
ENDLOCAL & IF "%~2" NEQ "" (SET %~2=%ip%) ELSE (echo.%ip%)
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