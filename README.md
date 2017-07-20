# CommandLineHelper
*Basic command line helper utilities for software developers.*

The intended usage for *CommandLineHelper* is to provide a user a more linux like command line experience. We will eventually provide most of the linux utilitie. It's useful, but can also be a great way to learn batch scripting.

Start by downloading the repo. Run the Start.bat to begin.
Start.bat --help will display the command line options.

  i.e. 
  ```start.bat --Install
  ```
  Result: Will prompt the user for information needed before creating an alias.cmd. If the directories are missing they will be automatically generated. An alias.cmd link location will be associated with the HKCU\Software\Microsoft\Command Processor AutoRun REG_SZ key. This will cause the alias.cmd to be loaded every time a new command window is crated. You can manually edit the alias.cmd file anytime.

The power of having an alias.cmd is that you can specify aliases that apply to future command window sessions rather than having to reset variables all the time. Lets say you hate to type cd c:\dev\. 
Using a doskey command like the one below will make it so every time you type "dev" the CD /D C:\Dev command will run. 
  i.e. *DOSKEY dev=CD /D c:\dev*
It's very powerfull to use aliases in your command window and having them in the alias.cmd will make sure that all your favorite shortcuts are available every time you open a command window.

The start.bat file will be used to install any the clhelper command further enhances your automated command structure without the need to install anything. It's the basis of any good relationship with windows.

# Things You Can Do with CommandLineHelper you can't do without:
The READWRITEINI function will read and write to ini files within batches for configuration purposes. When reading something from an INI  file specify the key and a temporary environment variable name you would like to set as the output. If you were to type: ECHO %variable% your command window will display the value of the key you specified.

*Example:*
INIFile Structure:
```
[section]
key=value
```

READWRITEINI "Section" "key" "variable"
ECHO %variable%

*results in*
value

# Default Alias Options Available from the Command Line:

*These settings don't stop working just because you open another command window.* Once CommandLineHelper is installed you can edit them and continue improve upon them. Please contribute to the CommandLineHelper either your suggestions or add your own changes to the source repository here. 
```
"FindString YourRegularExpression Text"
"desktop"     Changes directory to your desktop "%userprofile%\Desktop directory.
"dev"         Changes directory to your dev directory.
"Download"    Changes directory to your "%USERPROFILE%\Downloads" directory.
"pictures"    Changes directory to your "%USERPROFILE%\Pictures" directory.
"videos"      Changes directory to your "%USERPROFILE%\Videos" directory.
"OneDrive"    Changes directory to your "%USERPROFILE%\onedrive" directory.
"Documents"   Changes directory to your "%USERPROFILE%\Documents"
"iCloudDrive" Changes directory to your "%USERPROFILE%\iCloudDrive"
"Searches"    Changes directory to your "%USERPROFILE%\Searches"
"clh"         Runs "c:\CommandLineHelper\Scripts\CLHelper.bat $*"
"logout"      Logs off the machine from the command line. Runs Shutdown -l
"logoff"      Logs off the machine from the command line. Shutdown -l
"restart"     Restarts the computer from the command line. Shutdown -g -t 30 -f
"forceoff"    Forces all users off the machine from the command line. Shutdown /p
"shutoff"     Shuts off the machine from the command line. Shutdown -s -t 30
"Hibernate"   Puts the computer in hibernation mode from the command line. Shutdown -h
"rshutdown"   Displays the graphical user interface (GUI) for Shutdown. shutdown -i
"abort"       Aborts a shutdown. Shutdown -a
"lock"        Locks the workstation similar to {WinKEY + L}. rundll32.exe user32.dll, LockWorkStation
"word"        Opens Microsoft Word from the command line.
"mspub"       Opens Microsoft Publisher.
"outlook"     Opens Microsoft Outlook.
"ppt"         Opens Microsoft PowerPoint
"excel"       Opens Microsoft Excel
"xls"         Opens Microsoft Excel
"xlsx"        Opens Microsoft Excel
"np"          Opens notepad++.exe and supports np filename options for quick editing.
"GitForce"    Cleans and removes all changes in git repo and pulls latest code.
"GitCommit"   Pulls latest code and prompts for commit message before commiting changes.
"explorer"    Opens Windows Explorer to current location.
"CLCopy"      Copies a file and prompts user for overwrite while creating directories in the destination if they do not exist.
"rc"          Random color for command window background and text. You can also specify a color like "rc lightblue black".
"commit"      Same as "GitCommit", pulls latest code and prompts for commit message before commiting changes.
"custom"      Loads your own custom alias settings.
"ls"          Linux list command i.e. ls
"vjson"       Verifies a json file (requires ruby)
"rdp"         Starts a remote desktop connection automatically passing in your username and credentials as well as adding the fully qualified computer name.
```

# Installation
Open a command window and change to the directory where you downloaded the CommandLineHelper source.
Run:
```setup.bat --install
```

# Manual Installation

Unpack the source folder to *c:\CommandLineHelper*
Open the command prompt and run the following commands:
```
REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d C:\CommandLineHelper\Scripts\cmd\alias.cmd /f
REG ADD "HKCU\Software\Microsoft\Command Processor" /v CommandLineHelper /t REG_SZ /d C:\CommandLineHelper /f
c:\CommandLineHelper\Scripts\alias.cmd
clhelper.bat --SetupUserIniSettings
```

# UnInstall

setup.bat --Alias-Remove

*NOTE*: This essentially only removes the registry key. All files will remain untouched. You can run --install to re-install the registry key. 

# clhelper.ini
After the setup is complete you can edit the \CommandLineHelper\scripts\clhelper.ini to customize and automate features.
```
[Local]
CLHelper_Dir=c:\CommandLineHelper

[Mike]
MyPassword=MyUniquePassword
MyUserName=Mike
MY_Scripts_Dir=c:\dev\scripts
My_Dev_Env_Dir=c:\dev
MyDomainOrWorkgroup=BobsDomain.dom
LastName=Mike
FirstName=Boxer

[RemoteConnections]
TargetServers=
WindowsServers=winserver1,winserver2
LinuxServers=linserver1,linserver2
```
# Options:
<href>https://github.com/GaryLBaird/CommandLineHelper/blob/master/scripts/cmd/libs/clhHelp.cmd</href>


# Using username and password (TBD)

Username and password can be stored and retrieved from an ini file and accessed via the command line. 

*NOTE*: This stores a clear text password in a local ini file. 

# Helpful Typical Functions (TBD)

# TodoItems (TBD)
* *Installer Section*: for performing installs where files are downloaded from the internet and installed.
* *Customization*: Customizations are not currently stored in the ini file. One should be generated if it is missing and when questions are answered you should put them in the ini so that they are found in the future.
* *Curl Support*:
  - Support Curl directly and conversion to ruby
* *Ruby Gem*: Support
* *PowerShell*: Support for standard tasks using PowerShell.
* *PowerShell*: Launcher*: that enables and disables security automaticall while running script.


# Project Parents and Resource Utilities (TBD)

# Contributors

GaryLBaird
