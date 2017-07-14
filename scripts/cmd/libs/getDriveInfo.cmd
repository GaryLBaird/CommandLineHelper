@ECHO OFF
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