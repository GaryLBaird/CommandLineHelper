@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:BestColor %1 %2
GOTO :Done

:BestColor
SETLOCAL ENABLEDELAYEDEXPANSION
  SET "BackBroundColor=%~1"
  SET "TextColor=%~2"
  REM SET DEFAULTS:
  IF NOT DEFINED BackBroundColor SET BackBroundColor=5
  IF NOT DEFINED TextColor SET TextColor=E

  IF "%~1"=="" GOTO :BestColorDone
  IF /I "Black"=="%~1" SET BackBroundColor=0
  IF /I "Black"=="%~2" SET TextColor=0
  IF /I "Gray"=="%~1" SET BackBroundColor=8
  IF /I "Gray"=="%~2" SET TextColor=8
  IF /I "Grey"=="%~1" SET BackBroundColor=8
  IF /I "Grey"=="%~2" SET TextColor=8
  IF /I "Blue"=="%~1" SET BackBroundColor=1
  IF /I "Blue"=="%~2" SET TextColor=1
  IF /I "Light Blue"=="%~1" SET BackBroundColor=9
  IF /I "Light Blue"=="%~2" SET TextColor=9
  IF /I "lBlue"=="%~1" SET BackBroundColor=9
  IF /I "LBlue"=="%~2" SET TextColor=9
  IF /I "Green"=="%~1" SET BackBroundColor=2
  IF /I "Green"=="%~2" SET TextColor=2
  IF /I "Light Green"=="%~1" SET BackBroundColor=A
  IF /I "Light Green"=="%~2" SET TextColor=A
  IF /I "LGreen"=="%~1" SET BackBroundColor=A
  IF /I "LGreen"=="%~2" SET TextColor=A
  IF /I "Aqua"=="%~1" SET BackBroundColor=3
  IF /I "Aqua"=="%~2" SET TextColor=3
  IF /I "Light Aqua"=="%~1" SET BackBroundColor=B
  IF /I "Light Aqua"=="%~2" SET TextColor=B
  IF /I "LAqua"=="%~1" SET BackBroundColor=B
  IF /I "LAqua"=="%~2" SET TextColor=B
  IF /I "Red"=="%~1" SET BackBroundColor=4
  IF /I "Red"=="%~2" SET TextColor=4
  IF /I "Light Red"=="%~1" SET BackBroundColor=C
  IF /I "Light Red"=="%~2" SET TextColor=C
  IF /I "LRed"=="%~1" SET BackBroundColor=C
  IF /I "LRed"=="%~2" SET TextColor=C
  IF /I "Purple"=="%~1" SET BackBroundColor=5
  IF /I "Purple"=="%~2" SET TextColor=5
  IF /I "Light Purple"=="%~1" SET BackBroundColor=D
  IF /I "Light Purple"=="%~2" SET TextColor=D
  IF /I "LPurple"=="%~1" SET BackBroundColor=D
  IF /I "LPurple"=="%~2" SET TextColor=D
  IF /I "Yellow"=="%~1" SET BackBroundColor=6
  IF /I "Yellow"=="%~2" SET TextColor=6
  IF /I "Light Yellow"=="%~1" SET BackBroundColor=E
  IF /I "Light Yellow"=="%~2" SET TextColor=E
  IF /I "LYellow"=="%~1" SET BackBroundColor=E
  IF /I "LYellow"=="%~2" SET TextColor=E
  IF /I "White"=="%~1" SET BackBroundColor=7
  IF /I "White"=="%~2" SET TextColor=7
  IF /I "Bright White"=="%~1" SET BackBroundColor=F
  IF /I "Bright White"=="%~2" SET TextColor=F
  IF /I "LWhite"=="%~1" SET BackBroundColor=F
  IF /I "LWhite"=="%~2" SET TextColor=F
  REM Yellow Text Purple Background 
  :BestColorDone
  Color !BackBroundColor!!TextColor!
ENDLOCAL
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done