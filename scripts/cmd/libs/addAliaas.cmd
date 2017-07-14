@echo OFF
%1 %2
GOTO :Done
:choiceListInput ret list title max -- lets the user choose from list of last entered values
::                                  -- ret   [out]    - varref returns input value
::                                  -- list  [in,out] - varref with choice list, returns trimmed reordered choice list
::                                  -- title [in]     - list title
::                                  -- max   [in]     - maximum number of list entries
:$created 20060101 :$changed 20080219 :$categories Input
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set l=,!%~2!,&          rem.-- get the choice list
set t=%~3&              rem.-- get the list title
set c=%~4&              rem.-- get the list entry count limit
set m=&                 rem.-- a message
set l2=,
set v=
:choiceListInput_LOOP1
echo.%t%
set i=0&for /f "delims=" %%a in ('"echo.%l:,=&echo.%"') do (
    set /a i+=1
    set l2=!l2!!i!;%%~a,
    set v=%%~a
    echo.  !i! - %%~a
)
if "%m%" NEQ "" echo.  ^>^> %m%
echo.  Make a choice or enter a new value [%v%]
set v1=%v%
set /p v1=  :
echo.
set v2=!v1!&set v2=!v2:,=!&set v2=!v2:@=!&set v2=!v2:;=!&set v2=!v2:"=!
rem.--reject entry with illegal character
if "!v1!" NEQ "!v2!" (
    set m=Note: ,;@" and empty string not allowed.  Try again.
    goto:choiceListInput_LOOP1
)
rem.--if first character is minus then remove the entry
set remove=&if "%v1:~0,1%"=="-" set remove=y&set v1=%v1:~1%
set v=%v1%
rem.--if number chosen then find corresponding value
set l3=!l2:,%v%;=,@!
if "%l3%" NEQ "%l2%" (
    for /f "delims=@ tokens=2" %%a in ("!l3!") do set l3=%%a
    for /f "delims=,"          %%a in ("!l3!") do set v=%%a
)
rem.--remove value from list if exist
set l3=%l%
set l=!l:,%v%,=,!
if "%remove%"=="y" (
    if "%l%"=="%l3%" (set m='%v%' cannot be removed from list
    ) ELSE (set m='%v%' has been removed from list)
    goto:choiceListInput_LOOP1
)
if "%l%"=="%l3%" echo.  ^>^>'%v%' has been added to the list
rem.--add to the value to the end
set l=!l:~1!%v%
rem.--enforce the list entry count limit if requested
if "%c%" NEQ "" (
    set i=0&for %%a in (%l%) do set /a i+=1
    if /i !i! GTR !c! (
        for /f "delims=, tokens=1,*" %%a in ("!l!") do (
            set l=%%b
            echo.  ^>^>'%%a' dropped out of the list
        )
    )
)
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" (SET %~1=%v%) ELSE (echo.%v%)
    IF "%~2" NEQ "" (SET %~2=%l%) ELSE (echo.%l%)
)
:Done
