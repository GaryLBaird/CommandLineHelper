@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
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

GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done