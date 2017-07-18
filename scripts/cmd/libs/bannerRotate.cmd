@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
%1 %2
GOTO :Done
:bannerRotate varref -- rotates text in varref one step and updates title
::                   -- varref [in,out] - variable name with banner text, format: "Banner Text------"
:$created 20060101 :$changed 20080219
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set s=!%~1: =-!
set s=!s:~1!!s:~0,1!
TITLE !s!
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%s%
)

GOTO :Done
:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done