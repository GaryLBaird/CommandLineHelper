@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:getColorCode %1 %2
:getColorCode col ret -- converts color text to color code
::                    -- col [in]  - color text BackgroundForeground, i.e.: BlueLYellow for 1E
::                    -- ret [out] - return variable to return color code in
:$created 20060101 :$changed 20080219 :$categories Color,Echo
:$source http://www.dostips.com
SETLOCAL
set col=%~1
set col=%col:Gray=8%
set col=%col:LBlue=9%
set col=%col:LGreen=A%
set col=%col:LAqua=B%
set col=%col:LRed=C%
set col=%col:LPurple=D%
set col=%col:LYellow=E%
set col=%col:LWhite=F%
set col=%col:Black=0%
set col=%col:Blue=1%
set col=%col:Green=2%
set col=%col:Aqua=3%
set col=%col:Red=4%
set col=%col:Purple=5%
set col=%col:Yellow=6%
set col=%col:White=7%
ENDLOCAL & IF "%~2" NEQ "" (SET %~2=%col%) ELSE (echo.%col%)

GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done