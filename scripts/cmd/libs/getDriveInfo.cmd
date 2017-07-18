@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:getDriveInfo %1
:getDriveInfo var -- returns array of fsutil drive information
::             -- var [out] - return variable, as array
:$created 20060101 :$changed 20091115 :$categories DriveInfo,Array
:$source http://www.dostips.com
if "%~1" NEQ "" for /f "delims==" %%A in ('set %~1[ 2^>NUL') do @set "%%A="
SETLOCAL ENABLEDELAYEDEXPANSION
set "data="
set /a n=-1
for /f "tokens=1 delims=" %%A in ('fsutil fsinfo drives^|find "\"') do (
    set "dr=%%~A"
    set "dr=!dr:~-3,-1!"
    set /a n+=1
    set "data=!data!&set %~1[!n!].Drive=!dr!"
    ECHO.!data!
    for /f "tokens=1,* delims=- " %%a in ('"fsutil fsinfo drivetype !dr!"') do set "data=!data!&set %~1[!n!].DriveType=%%b"
    for /f "tokens=1,* delims=:" %%a in ('"fsutil volume diskfree !dr!"') do (
        set "v= %%a"
        set "v=!v: =!"
        set "d= %%b"
        set "d=!d:~2!"
        set "data=!data!&set %~1[!n!].!v!=!d!"
        ECHO !data!
    )
)
ECHO !data!
set "data=rem.%data:)=^)%"
( ENDLOCAL & REM RETURN VALUES
    %data%
    SET "%~1[#]=%n%"
)
GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done