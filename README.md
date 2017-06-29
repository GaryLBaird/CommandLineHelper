# CommaneLineHelper
Basic command line helper utilities for software developers.

The intended usage for CommandLineHelper is to provide a user a more linux like command line experience.

Start by downloading the repo. Run the Start.bat to begin.
Start.bat --help will display the command line options. 
  i.e. start.bat --CreateAliasFile
  Result: Will prompt the user for information needed before creating an alias.cmd. If the directories are missing they will be automatically generated. An alias.cmd link location will be associated with the HKCU\Software\Microsoft\Command Processor AutoRun REG_SZ key. This will cause the alias.cmd to be loaded every time a new command window is crated. You can manually edit the alias.cmd file anytime.
  
The start.bat file will be used to further install any other future utilities, software and features. 
