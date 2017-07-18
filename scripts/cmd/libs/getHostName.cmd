@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
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

GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done