@ECHO OFF
CALL:RandomColor %1 %2
:Done
GOTO :Done

:RandomColor
SETLOCAL ENABLEDELAYEDEXPANSION
SET /a LETTER=(%Random% %%6)+1
SET /a NUMBER=(%Random% %%9)+1
GOTO :CASE_!LETTER!
:CASE_1
  SET RETURN=A
  GOTO :END_CASE
:CASE_2
  SET RETURN=B
  GOTO :END_CASE
:CASE_3
  SET RETURN=C
  GOTO :END_CASE
:CASE_4
  SET RETURN=D
  GOTO :END_CASE
:CASE_5
  SET RETURN=E
  GOTO :END_CASE
:CASE_6
  SET RETURN=F
  GOTO :END_CASE
:END_CASE

ENDLOCAL && set "RETURN_COLOR=%return%" && SET "NUMBER=%NUMBER%"
IF DEFINED RETURN_COLOR (
  COLOR %NUMBER%%RETURN_COLOR%
  ECHO COLOR %NUMBER%%RETURN_COLOR%
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