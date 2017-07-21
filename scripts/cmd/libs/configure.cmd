GOTO :%1
GOTO :ConfDone
:-Alias
%NOTEPAD% "%CommandLineHelper%\scripts\alias.cmd
GOTO :ConfDone
:-Custom_Alias
%NOTEPAD% "%_CustomAliasFile_%"
GOTO :ConfDone
:-MySettings
%NOTEPAD% "%_MySettings_%"
GOTO :ConfDone
:-installs
%NOTEPAD% "%CommandLineHelper%\scripts\installs\configuration.ini"
GOTO :ConfDone
:ConfDone