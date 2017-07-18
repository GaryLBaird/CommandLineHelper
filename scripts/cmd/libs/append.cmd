@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
:append str file line -- appends a string to a specific line in a text file
::                    -- str  [in] - string to be appended
::                    -- file [in] - file name to append the string to
::                    -- line [in] - line number to append the string to, first line is 1, omit for last line
:$created 20060101 :$changed 20080219 :$categories FileManipulation
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set ap=%~1
set f=%~2
set c=%~3
if not defined c (
    set c=0
    for /f %%a in ('find /v /c ""^<"%f%"') do set c=%%a
)
(for /f "tokens=1,* delims=:" %%a in ('findstr /v /n "$$"^<"%f%"') do (
    if "%%a"=="%c%" (echo.%%b%ap%) ELSE echo.%%b
))>"%temp%.\t0815.txt"
move /y "%temp%.\t0815.txt" "%f%"
ENDLOCAL
GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done