@ECHO OFF

CALL:About %1 %2
GOTO :Done
:About
  CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
  CALL:FORMATOUT 20,20," Author: "," Gary L Baird",""
  CALL:FORMATOUT 20,20," Written by:"," Gary L Baird"
  CALL:FORMATOUT 20,20," Phone: "," TBA"
  CALL:FORMATOUT 20,20," Email: "," TBA"
  CALL:FORMATOUT 20,20," Filename: "," %~1"
  CALL:FORMATOUT 20,20," Purpose: "," Make the Windows Command Line more friendly."
  CALL:FORMATOUT 20,20," Project: "," Part of the Command Line Helper project."
  CALL:FORMATOUT 20,20," Location: "," github.com/GaryLBaird/CommandLineHelper"
  CALL:FORMATOUT 20,20," License: "," GNU GENERAL PUBLIC LICENSE"
  CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
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
