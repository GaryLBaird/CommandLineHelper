@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:getIPConfig %1 %2
GOTO :Done
:getIPConfig arr -- return IPCONFIG /ALL data in array variable
::               -- arr [out] - target array variable for IPCONFIG data
if "%~1" NEQ "" for /f "delims==" %%A in ('set %~1[ 2^>NUL') do @set "%%A="
SETLOCAL ENABLEDELAYEDEXPANSION
set "data="
set /a n=0
for /f "tokens=1,* delims=:" %%A in ('ipconfig /all ') do (
    ECHO A:%%A,B:%%B
    set "v=%%~A "
    SET "v=!v:   =!
    SET "v=!v:. . . . . . . .=!
    SET "v=!v: . =!
    SET "v=!v:.=!
    if "!v:~0,8!" NEQ "" (
        rem it's a new section
        set /a n+=1
        set "data=!data!&set %~1[!n!].DisplayName=%%A"
    ) ELSE (
        set "v=!v:~8!"
        set "v=!v:.=!"
        set "v=!v: =!"
        set "x=%%~B"
        ECHO !x!
        set "data=!data!&set %~1[!n!].!v!=!x:~1!"
        REM ECHO !data!
        pause
    )
)
set data=rem.!data:^)=^)!
ECHO !data!
( ENDLOCAL
    REM & REM RETURN VALUES
    %data%
    SET "%~1[#]=%n%"
)
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done