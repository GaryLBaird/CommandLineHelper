GOTO :%1
GOTO :ConfDone
:-Alias
%NOTEPAD% "%CommandLineHelper%\scripts\cmd\alias.cmd
GOTO :ConfDone
:-Custom_Alias
IF NOT EXIST "%_CustomAliasFile_%" (
	ECHO.>>"%_CustomAliasFile_%"
)
%NOTEPAD% "%_CustomAliasFile_%"
GOTO :ConfDone
:-MySettings
%NOTEPAD% "%_MySettings_%"
GOTO :ConfDone
:-installs
%NOTEPAD% "%CommandLineHelper%\scripts\installs\configuration.ini"
GOTO :ConfDone
:ConfDone