@ECHO OFF
:: Alias is run every time you open a command window
:: Note:
::   1. Don't use the command "cls" in your alias file.
::   2. Don't use "ECHO" in your alias file because it add 
::      un-necessary text to your for loop e.g.:
::      "For %%A IN ('something') do %%A"
::SETTINGS
SET _CLHScripts_=c:\CommandLineHelper\Scripts
SET _CLHBIN_=c:\CommandLineHelper\bin
SET _READWRITEINI_=%_CLHScripts_%\vbs\readwriteini.vbs
SET CLHelper=%_CLHScripts_%\CLHelper.bat
::Edit this field with your username you will use when connecting to a linux server.
::If your linux machines are in a domain you might need to put it in as user@domain.com
:: This is a good candidate for your override alias i.e. c:\dev\scripts\custom_alias.cmd
SET _Linux_USERNAME_=%username%
::Create Default Directories
IF NOT EXIST "%_CLHScripts_%\vbs" (
  MKDIR %_CLHScripts_%\vbs
)
IF NOT EXIST "%_CLHScripts_%\logs" (
  MKDIR %_CLHScripts_%\logs
)
::Doskey Commands
::Add Temporary Path Assignments
DOSKEY add_python26=set PATH=%PATH%;"C:\Python26\"
DOSKEY add_python33=set PATH=%PATH%;"C:\Python33\"
::Regular Expression Pattern Search Begin ::
DOSKEY FindString=cscript.exe //Nologo //T:15 %_CLHScripts_%\vbs\vbs\txtComp.vbs --PatternMatch $1 $2
::Change Directory Commands
DOSKEY desktop=CD /D "%userprofile%\Desktop"
DOSKEY dev=CD /D "c:\Dev"
DOSKEY Downloads=cd /d "%USERPROFILE%\Downloads"
DOSKEY Pictures=cd /d "%USERPROFILE%\Pictures"
DOSKEY Videos=cd /d "%USERPROFILE%\Videos"
DOSKEY OneDrive=cd /d "%USERPROFILE%\onedrive"
DOSKEY Documents=cd /d "%USERPROFILE%\Documents"
DOSKEY iCloudDrive=cd /d "%USERPROFILE%\iCloudDrive"
DOSKEY Searches=cd /d "%USERPROFILE%\Searches"
::CommandLineHelper alias
DOSKEY clh=c:\CommandLineHelper\Scripts\CLHelper.bat $*
::Aliases for Shutdown Commands
DOSKEY logout=Shutdown -l
DOSKEY logoff=Shutdown -l
DOSKEY restart=Shutdown -g -t 30 -c "Because %_USERNAME_% said to restart." -f
DOSKEY forceoff=Shutdown /p
DOSKEY shutoff=Shutdown -s -t 30 -c "Because %_USERNAME_% said to shutdown."
DOSKEY Hibernate=Shutdown -h
DOSKEY rshutdown=Shutdown -i
DOSKEY abort=Shutdown -a
DOSKEY lock=rundll32.exe user32.dll, LockWorkStation
::Aliases for Microsoft Office Products
DOSKEY word="c:\Program Files\Microsoft Office\Office15\winword.exe" $*
DOSKEY mspub="c:\Program Files\Microsoft Office\Office15\mspub.exe" $*
DOSKEY outlook="c:\Program Files\Microsoft Office\Office15\outlook.exe" $*
DOSKEY ppt="c:\Program Files\Microsoft Office\Office15\powerpnt.exe" $*
DOSKEY excel="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY excell="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY xls="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY xlsx="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
::Custom Alias Notepad++
IF EXIST "C:\Program Files (x86)\Notepad++\notepad++.exe" (
DOSKEY np="C:\Program Files (x86)\Notepad++\notepad++.exe" $*
)
IF EXIST "C:\Program Files\Notepad++\notepad++.exe" (
DOSKEY np="C:\Program Files\Notepad++\notepad++.exe" $*
)
::CommandLineHelper Alias's
DOSKEY CLHelper=%CLHelper% $*
DOSKEY GitForce=%CLHelper% --GitForce $*
DOSKEY GitCommit=%CLHelper% --GitCommit $*
DOSKEY explorer=%CLHelper% --WindowsExplorer $*
DOSKEY CLCopy=%CLHelper% --Copy $*
DOSKEY rc=%CLHelper% --RandomColor $*
DOSKEY commit=%CLHelper% --GitCommit $*
DOSKEY custom=%_CustomAlias_%
DOSKEY ls=%CLHelper% --ls $*
DOSKEY vjson=%CLHelper% --JsonCheck $*
DOSKEY rdp=%CLHelper% --RDP $*
DOSKEY window=%CLHelper% --mode $*
DOSKEY plink=%CLHelper% --PuTTy plink $*
DOSKEY pscp=%CLHelper% --PuTTy pscp $*
DOSKEY psftp=%CLHelper% --PuTTy psftp $*
DOSKEY putty=%CLHelper% --PuTTy putty $*
DOSKEY puttygen=%CLHelper% --PuTTy puttygen $*
DOSKEY download=%CLHelper% --download $*
:: This is a good candidate for your override alias i.e. c:\dev\scripts\custom_alias.cmd
DOSKEY sshi=%_CLHBIN_%\OpenSSH\bin\ssh.exe %_Linux_USERNAME_%@$1 -I %USERPROFILE%\.ssh\id_rsa
::Custom Alias Directory
SET _CustomAliasDir_=C:\dev\scripts
::Custom Alias Create If Missing
IF NOT EXIST "%_CustomAliasDir_%" MKDIR %_CustomAliasDir_%
SET _CustomAliasFile_=%_CustomAliasDir_%\custom_alias.cmd
IF NOT EXIST "%_CustomAliasFile_%" (
  DOSKEY customAlias=notepad.exe %_CustomAliasFile_%>%_CustomAliasFile_%
)
CALL %_CustomAliasFile_%
::Set Command Window Background and Text Color
CALL:-BestColor
GOTO :DONE

:-BestColor
::Yellow Text Purple Background 
:: Use Random Color to try other color patterns out by typing "rc" in the comand window.  
Color 5E
GOTO:EOF
:DONE
