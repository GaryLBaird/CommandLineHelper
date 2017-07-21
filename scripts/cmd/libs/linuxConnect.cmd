@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
IF "%1"=="" ECHO You must provide a server name. && goto :LinuxDone
IF NOT DEFINED _MyLinuxUser_ CALL:ReadINI "%_MySettings_%" "%UserName%" "MyLinuxUser" "_MyLinuxUser_"
IF NOT DEFINED _MyLinuxPass_ CALL:ReadINI "%_MySettings_%" "%UserName%" "MyLinuxPass" "_MyLinuxPass_"
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET __MACHINES__=%1
IF NOT DEFINED _MyLinuxUser_ SET _MyLinuxUser_=%_MyUserName_%@%_MyDomainOrWorkgroup_%
CALL:FORMATOUT 50,50,"----------------------------------------------------------------------",""
CALL:FORMATOUT 50,50,"User:","%_MyLinuxUser_%"
CALL:FORMATOUT 50,50,"----------------------------------------------------------------------",""
CALL:FORMATOUT 50,50,"Is this user name correct:","%_MyLinuxUser_%"
CALL:FORMATOUT 50,50,"",""
SET /P Correct= [Y/N]
IF /I "!Correct!"=="Y" goto :LinuxReady
:LinuxLoop
  CALL:FORMATOUT 50,50,"Please enter the correct user credentials.",""
  SET /P _MyLinuxUser_= Linux Machine Credentials username or username@domainname:
  CALL:FORMATOUT 50,50,"Is this user name correct:","%_MyLinuxUser_%"
  SET /P Correct= [Y/N]
  IF /I NOT "!Correct!"=="Y" goto :LinuxLoop
  CALL:FORMATOUT 50,50,"Would you like to save MyLinuxUser for later?","%_MyLinuxUser_%"
  SET /P Correct= [Y/N]
  IF /I "!Correct!"=="Y" CALL:--WriteINI "%_MySettings_%" "%UserName%" "MyLinuxUser" "!_MyLinuxUser_!"
:LinuxReady
CALL:FORMATOUT 50,50,"Ready:","Connecting to Linux machine."
SET /P Correct=Press any key to continue.
:: Begin Script
SET LocalFile=%USERPROFILE%\.ssh\authorized_keys
SET SSHDIR=/home/%_MyLinuxUser_%/.ssh
FOR /D %%i in (!__MACHINES__!) do (
  ECHO connecting to server
  %CommandLineHelper%\bin\OpenSSH\bin\ssh.exe %_MyLinuxUser_%@%%i -I %USERPROFILE%\.ssh\id_rsa
)
ENDLOCAL
:LinuxDone

GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done