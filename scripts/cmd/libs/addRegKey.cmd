@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:AddReg %1 %2 %3 %4
GOTO :Done
:AddReg
  REG ADD "%~1" /v "%~2" /t %~3 /d %~4 /f>nul
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done