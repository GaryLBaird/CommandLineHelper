CALL:FORMATOUT
:FORMATOUT
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
GOTO:EOF

:padright
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:EOF

:padleft
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:EOF

:Done