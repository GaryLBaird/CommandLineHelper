@echo off
%1 %2
GOTO :Done
:bannerPingPong varref -- moves text in varref one step left or right and updates title
::                     -- varref [in,out] - variable name with banner text, format: "Banner Text------"
:$created 20060101 :$changed 20080219
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set s=!%~1: =-!
if "!s:~-1!" NEQ "-" if "!s:~-1!" NEQ "+" set s=!s!--------
set d=!s:~-1!
if "!s:~0,1!" NEQ "-" set d=+
if "!s:~-2,1!" NEQ "-" set d=-
if "!d!"=="+" (set s=-!s:~0,-2!+) ELSE (set s=!s:~1,-1!--)
TITLE !s!
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%s%
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