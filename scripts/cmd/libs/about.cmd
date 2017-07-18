@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
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
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done
