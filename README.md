# CommaneLineHelper
*Basic command line helper utilities for software developers.*

The intended usage for *CommandLineHelper* is to provide a user a more linux like command line experience. We will eventually provide most of the linux utilitie.

Start by downloading the repo. Run the Start.bat to begin.
Start.bat --help will display the command line options. 
  i.e. start.bat --Install
  Result: Will prompt the user for information needed before creating an alias.cmd. If the directories are missing they will be automatically generated. An alias.cmd link location will be associated with the HKCU\Software\Microsoft\Command Processor AutoRun REG_SZ key. This will cause the alias.cmd to be loaded every time a new command window is crated. You can manually edit the alias.cmd file anytime.
  If you like what you see you can make it perminent by first setting the variable ADD_REG to true from the command line. i.e. "SET ADD_REG=True"
  The power of having an alias.cmd is that you can specify aliases. Lets say you hate to type cd c:\dev\. Using a doskey command like: 
DOSKEY dev=CD /D c:\dev
Now every time you type dev in the command window the cd /d c:\dev will run. having them in the alias.cmd will make sure that all your favorite shortcuts are available every time you open a command window.
  
The start.bat file will be used to further install any other future utilities, software and features. 

Functions:
READWRITEINI   Will read and write to ini files within batches for configuration purposes.

# Installation

setup.bat --install

# UnInstall

setup.bat --Alias-Remove

*NOTE*: This essentially only removes the registry key. All files will remain untouched. You can run --install to re-install the registry key. 

# Dependencies (TBD)


# Using username and password (TBD)

Username and password can be stored and retrieved from an ini file and accessed via the command line. 

*NOTE*: This stores a clear text password in a local ini file. 

# Helpful Typical Functions (TBD)

# TodoItems (TBD)

# Project Parents and Resource Utilities (TBD)

# Contributors

GaryLBaird
