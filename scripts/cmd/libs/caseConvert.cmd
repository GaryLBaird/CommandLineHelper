@ECHO OFF
:: Written by:          Brian Williams
:: Last Updated by:     GarylBaird
:: Revision date:       Fri 07/21/2017
:: Version:             1.0

SETLOCAL ENABLEDELAYEDEXPANSION
IF /I "%1"=="LCase" SET ARGCase=%1
IF /I "%1"=="UCase" SET ARGCase=%1
SET "ConvertString=%2"
IF NOT DEFINED ConvertString ECHO USAGE: && ECHO Convert to Uppercase: 'UCase "string" && ECHO Convert to Lowercase: 'LCase "string" && ECHO Returns converted string to the RESULTS variable. && GOTO :Done
IF DEFINED ARGCase CALL:!ARGCase! ConvertString _RESULTS_
ECHO.!_RESULTS_!
ENDLOCAL && SET "RESULTS=%_RESULTS_%"
GOTO DONE:

GOTO:EOF


:LCase
:UCase
:: Converts to upper/lower case variable contents
:: Syntax: CALL :UCase _VAR1 _VAR2
:: Syntax: CALL :LCase _VAR1 _VAR2
:: _VAR1 = Variable NAME whose VALUE is to be converted to upper/lower case
:: _VAR2 = NAME of variable to hold the converted value
:: Note: Use variable NAMES in the CALL, not values (pass "by reference")

SET _UCase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
SET _LCase=a b c d e f g h i j k l m n o p q r s t u v w x y z
SET _Lib_UCase_Tmp=!%1!
IF /I "%0"==":UCase" SET _Abet=%_UCase%
IF /I "%0"==":LCase" SET _Abet=%_LCase%
FOR %%Z IN (%_Abet%) DO SET _Lib_UCase_Tmp=!_Lib_UCase_Tmp:%%Z=%%Z!
SET %2=%_Lib_UCase_Tmp%
GOTO:EOF

:Done