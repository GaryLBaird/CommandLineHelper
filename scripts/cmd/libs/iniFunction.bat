@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:INI %1 %2 %3 %4 %5 %6
:Done
GOTO :Done

:INI
REM """Reads and writes to ini files. If found section key and value will SET key as varriable."""
SET _INI_RETURN_=
SETLOCAL ENABLEDELAYEDEXPANSION
SET _INI_FILE_=%~1
IF DEFINED _DEBUG_ CALL:DateTime "_INI_FILE_=!_INI_FILE_!"
 SET _INI_RETURN_FILE_=!TEMP!\INI_RETURN_!RANDOM!.log
IF DEFINED _DEBUG_ CALL:DateTime "_INI_RETURN_FILE_=!_INI_RETURN_FILE_!"
 SET _INI_COMMAND_=%~2
IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_=!_INI_COMMAND_!"
 SET _INI_SECTION_=%~3
IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_=!_INI_SECTION_!"
 SET _INI_KEY_=%~4
IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_=!_INI_KEY_!"
 SET _INI_VALUE_=%~5
IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_=!_INI_VALUE_!"
 IF DEFINED _INI_VALUE_ (
    SET _INI_VALUE_=!_INI_VALUE_:_comma_=,!
    SET _INI_VALUE_=!_INI_VALUE_:_backslash_=\!
    SET _INI_VALUE_=!_INI_VALUE_:_and_=^&!
)
SET _RETURN_VALUE=%~6
IF DEFINED _DEBUG_ CALL:DateTime "_RETURN_VALUE=!_RETURN_VALUE!"
 IF DEFINED _INI_COMMAND_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_ hit"
    IF DEFINED _INI_SECTION_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_ hit"
        IF DEFINED _INI_KEY_ (
            IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_ hit"
            IF /I "!_INI_COMMAND_!"=="-r" (
                    %READ_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" >"%_INI_RETURN_FILE_%"
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
            )
            IF DEFINED _INI_VALUE_ (
                IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_ hit"
                IF /I "!_INI_COMMAND_!"=="-w" (
                    IF DEFINED _DEBUG_ (
                        CALL:DateTime "_INI_COMMAND_ == !_INI_COMMAND_!"
                        CALL:DateTime "%WRITE_INI_VALUE% '%_INI_FILE_%' '!_INI_SECTION_!' '!_INI_KEY_!' '!_INI_VALUE_!'"
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!"
                    ) ELSE (
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!" >"%_INI_RETURN_FILE_%"
                    )
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
                )
            )
        )
        IF /I "!_INI_COMMAND_!"=="-rs" (
            %READ_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
        IF /I "!_INI_COMMAND_!"=="-ws" (
            %WRITE_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
    )
)
IF EXIST "!_INI_RETURN_FILE_!" (
    FOR /F %%A IN ('TYPE "!_INI_RETURN_FILE_!"') DO SET _INI_RETURN_=%%A
    DEL "!_INI_RETURN_FILE_!" /Q
)
ENDLOCAL&& SET _INI_RETURN_=%_INI_RETURN_%
IF DEFINED _INI_RETURN_ (
    IF /I "%~2"=="-rs" (
        FOR /F "eol=; tokens=1*" %%A IN ("%_INI_RETURN_%") DO (
            SET INI_RETURN=%_INI_RETURN_%
        )
    ) ELSE (
        FOR /F "tokens=1*" %%A IN ('ECHO "%_INI_RETURN_%" ^| findstr /r "="') DO (
            SET %_INI_RETURN_%
            )
        )
    )
)
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done