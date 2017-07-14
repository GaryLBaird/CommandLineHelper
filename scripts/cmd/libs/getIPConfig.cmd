@ECHO OFF
CALL:getIPConfig %1 %2
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