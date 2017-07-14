@ECHO OFF
CALL:getHostName %1
:getHostName ip ret -- resolves IP address to computer name
::         -- ip  [in,opt]  - ip, default is THIS computer's IP
::         -- ret [out,opt] - computer name
:$created 20060101 :$changed 20080219 :$categories Network
:$source http://www.dostips.com
SET getHostName=
SETLOCAL
SET ip=%~1
if "%ip%"=="" call:getIP "" ip
SET name=
for /f "tokens=2" %%a in ('"ping /a /n 1 %ip%|find "Pinging" 2>NUL"') DO SET name=%%a
ENDLOCAL & IF "%~2" NEQ "" (SET %~2=%name%) ELSE (rem echo.%name%)
GOTO :Done

:getIP host ret -- return THIS computers IP address
::              -- host [in,opt]  - host name, default is THIS computer
::              -- ret  [out,opt] - IP
:$created 20060101 :$changed 20080219 :$categories Network
:$source http://www.dostips.com
SETLOCAL
IF NOT "%~1"=="" (
  SET host=%~1
  IF NOT "%~2"=="" (
    SET ip=%~2
  ) ELSE (
    SET ip=
    SET getHostName=TRUE
  )
) ELSE (
    SET host=%computername%
    SET ip=
    SET getHostName=TRUE
)
if "%host%"=="" ( for /f "tokens=2,* delims=:. " %%a in ('"ipconfig|find "IP Address""') DO SET ip=%%b
) ELSE ( for /f "tokens=2 delims=[]" %%a in ('"ping /a /n 1 %host%|find "Pinging" 2>NUL"') DO SET ip=%%a)
REM CALL:FORMATOUT 20,20,"Returned:","%ip%"
ENDLOCAL & IF "%~2" NEQ "" (SET %~2=%ip%) & IF "%getHostName%" NEQ "TRUE" DO (SET getHostName=%ip%)
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