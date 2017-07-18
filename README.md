# CommandLineHelper
*Basic command line helper utilities for software developers.*

The intended usage for *CommandLineHelper* is to provide a user a more linux like command line experience. We will eventually provide most of the linux utilitie. It's useful, but can also be a great way to learn batch scripting.

Start by downloading the repo. Run the Start.bat to begin.
Start.bat --help will display the command line options. 
  i.e. start.bat --Install
  Result: Will prompt the user for information needed before creating an alias.cmd. If the directories are missing they will be automatically generated. An alias.cmd link location will be associated with the HKCU\Software\Microsoft\Command Processor AutoRun REG_SZ key. This will cause the alias.cmd to be loaded every time a new command window is crated. You can manually edit the alias.cmd file anytime.
  If you like what you see you can make it perminent by first setting the variable ADD_REG to true from the command line. 
    i.e. *"SET ADD_REG=True"*

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

# Installation

setup.bat --install

*NOTE*: Use SET ADD_REG=True before running setup.bat --install or the alias registry key will not be set. This is on purpose so that custom keys are not overwritten.

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
