@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:getIPConfig %1 %2
GOTO :Done
:getIPConfig arr -- return IPCONFIG /ALL data in array variable
::               -- arr [out] - target array variable for IPCONFIG data
:$created 20091111 :$changed 20091111 :$categories Network,Array
:$source http://www.dostips.com
if "%~1" NEQ "" for /f "delims==" %%A in ('set %~1[ 2^>NUL') do @set "%%A="
SETLOCAL ENABLEDELAYEDEXPANSION
set "data="
set /a n=0
for /f "tokens=1,* delims=:" %%A in ('ipconfig /all^|find ":"') do (
    set "v=%%~A "
    if "!v:~0,8!" NEQ "        " (
        rem it's a new section
        set /a n+=1
        set "data=!data!&set %~1[!n!].DisplayName=%%A"
    ) ELSE (
        set "v=!v:~8!"
        set "v=!v:.=!"
        set "v=!v: =!"
        set "x=%%~B"
        set "data=!data!&set %~1[!n!].!v!=!x:~1!"
    )
)
set "data=rem.%data:)=^)%"
ECHO !data!
( ENDLOCAL & REM RETURN VALUES
    %data%
    SET "%~1[#]=%n%"
)
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done