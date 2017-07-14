@ECHO OFF
CALL:FORMATOUT 20,50,":append"," appends a string to a specific line in a text file"
CALL:FORMATOUT 20,50,":bannerPingPong"," moves text in varref one step left or right and updates title"
CALL:FORMATOUT 20,50,":bannerRotate"," rotates text in varref one step and updates title"
CALL:FORMATOUT 20,50,":choiceListInput"," lets the user choose from list of last entered values"
CALL:FORMATOUT 20,50,":CmpFTime"," compares the time of two files, succeeds if condition is met, fails otherwise"
CALL:FORMATOUT 20,50,":date2jdate"," converts a gregorian calender date to julian day format"
CALL:FORMATOUT 20,50,":dayOfYear"," returns the day of the year, i.e. 1 for 1/1/2008, 266 for 12/31/2008"
CALL:FORMATOUT 20,50,":DeleteIfOld"," deletes file or directory if older than given number of days"
CALL:FORMATOUT 20,50,":doProgress"," displays the next progress tick"
CALL:FORMATOUT 20,50,":dumpArr"," dumps the array content / under construction"
CALL:FORMATOUT 20,50,":echo"," echoes text in a specific color"
CALL:FORMATOUT 20,50,":echoLine"," outputs a formatted string, substitutes file name and line number"
CALL:FORMATOUT 20,50,":extractFileSection"," extracts a section of file that is defined by a start and end mark"
CALL:FORMATOUT 20,50,":ExtractFunction"," extracts a function by label"
CALL:FORMATOUT 20,50,":ExtractSimple"," extracts a marked section from batch file, sustitutes variables during extraction"
CALL:FORMATOUT 20,50,":false"," returns failure"
CALL:FORMATOUT 20,50,":Format"," outputs columns of strings right or left aligned"
CALL:FORMATOUT 20,50,":fprop"," returns a file property"
CALL:FORMATOUT 20,50,":ftime"," returns the file time in julian days"
CALL:FORMATOUT 20,50,":getColorCode"," converts color text to color code"
CALL:FORMATOUT 20,50,":getDriveInfo"," returns array of fsutil drive information"
CALL:FORMATOUT 20,50,":getDrives"," This function has been replaced by :getDriveInfo"
CALL:FORMATOUT 20,50,":getFunctions"," returns a comma separated list of all functions"
CALL:FORMATOUT 20,50,":getHostName"," resolves IP address to computer name"
CALL:FORMATOUT 20,50,":getIP"," return THIS computers IP address"
CALL:FORMATOUT 20,50,":getIPConfig"," return IPCONFIG /ALL data in array variable"
CALL:FORMATOUT 20,50,":getNextInList"," return next value in list"
CALL:FORMATOUT 20,50,":getRandomColor"," returns a random color"
CALL:FORMATOUT 20,50,":GetRegKeys"," returns all registry syb keys of a given registry key"
CALL:FORMATOUT 20,50,":GetRegValue"," returns a registry value"
CALL:FORMATOUT 20,50,":GetRegValues"," returns all registry values of a given registry key"
CALL:FORMATOUT 20,50,":getServices"," returns array of service information"
CALL:FORMATOUT 20,50,":getVarsByAttr"," returns a comma separated list of variables based on an attribute name"
CALL:FORMATOUT 20,50,":htmlhelp"," dumps html help to console"
CALL:FORMATOUT 20,50,":Init"," initializes the environment for this command library"
CALL:FORMATOUT 20,50,":initProgress"," initializes an internal progress counter and display the progress in percent"
CALL:FORMATOUT 20,50,":initVarsByAttr"," restores the values of the persistent variables to defaults"
CALL:FORMATOUT 20,50,":IsFileOpen"," succeeds if file in use, fails otherwise"
CALL:FORMATOUT 20,50,":IsRegKey"," succeeds if Key exists"
CALL:FORMATOUT 20,50,":IsRegValue"," succeeds if Key and Value exists"
CALL:FORMATOUT 20,50,":IsServiceRunning"," returns success if service is running, otherwise failure"
CALL:FORMATOUT 20,50,":jdate"," converts a date string to julian day number with respect to regional date format"
CALL:FORMATOUT 20,50,":jdate2date"," converts julian days to gregorian date format"
CALL:FORMATOUT 20,50,":kBytesFree"," returns the free space of a drive in kilobytes"
CALL:FORMATOUT 20,50,":l2a"," converts a list to an array"
CALL:FORMATOUT 20,50,":loadPersistentVars"," loads the values of the persistent variables"
CALL:FORMATOUT 20,50,":loadRegVars"," loads the values of the persistent variables"
CALL:FORMATOUT 20,50,":lookup"," returns the value associated with a key in a map of key-value pairs"
CALL:FORMATOUT 20,50,":lTrim"," strips white spaces (or other characters) from the beginning of a string"
CALL:FORMATOUT 20,50,":MakeAbsolute"," makes a file name absolute considering a base path"
CALL:FORMATOUT 20,50,":MakeRelative"," makes a file name relative to a base path"
CALL:FORMATOUT 20,50,":NetworkDeviceGuid2Name"," gets a Network Device Name from its coresponding GUID"
CALL:FORMATOUT 20,50,":NetworkDeviceName2Guid"," gets a Network Device GUID from its corresponding Name"
CALL:FORMATOUT 20,50,":parse"," parses a string matching a formatter"
CALL:FORMATOUT 20,50,":pwd"," shows a password dialog box"
CALL:FORMATOUT 20,50,":regedit"," opens regedit at predefined location"
CALL:FORMATOUT 20,50,":removeArr"," removes an array"
CALL:FORMATOUT 20,50,":rTrim"," strips white spaces (or other characters) from the end of a string"
CALL:FORMATOUT 20,50,":savePersistentVars"," save values of persistent variables into a file"
CALL:FORMATOUT 20,50,":saveRegVars"," save values of persistent variables into a file"
CALL:FORMATOUT 20,50,":set"," sets var[] to output of command / under construction"
CALL:FORMATOUT 20,50,":SetRegValue"," sets a registry value"
CALL:FORMATOUT 20,50,":sleep"," waits some seconds before returning"
CALL:FORMATOUT 20,50,":StartsWith"," Tests if a text starts with a given string"
CALL:FORMATOUT 20,50,":strLen"," returns the length of a string"
CALL:FORMATOUT 20,50,":substitute"," substitutes a string in a text file"
CALL:FORMATOUT 20,50,":ToANSI"," converts a file to ANSI"
CALL:FORMATOUT 20,50,":toCamelCase"," converts a string to camel case"
CALL:FORMATOUT 20,50,":toDec"," convert a hexadecimal number to decimal"
CALL:FORMATOUT 20,50,":toHex"," convert a decimal number to hexadecimal, i.e. -20 to FFFFFFEC or 26 to 0000001A"
CALL:FORMATOUT 20,50,":toLower"," converts uppercase character to lowercase"
CALL:FORMATOUT 20,50,":ToUNICODE"," converts a file to UNICODE"
CALL:FORMATOUT 20,50,":toUpper"," converts lowercase character to uppercase"
CALL:FORMATOUT 20,50,":Trim"," strip white spaces (or other characters) from the beginning and end of a string"
CALL:FORMATOUT 20,50,":trimSpaces"," trims spaces around string variable"
CALL:FORMATOUT 20,50,":trimSpaces2"," trims spaces around string and assigns result to variable"
CALL:FORMATOUT 20,50,":true"," returns success"
CALL:FORMATOUT 20,50,":Unique"," returns a unique string based on a date-time-stamp, YYYYMMDDhhmmsscc"
GOTO :Done

:FORMATOUT
SETLOCAL ENABLEDELAYEDEXPANSION
  SET __Left__=%~1
  SET __RIGHT__=%~2
  SET "__TEXT__=%~3"
  SET "__OTHER__=%~4 %~5 %~6"
  SET "spaces=                                                                                                                    "
  SET /A __SIZE__=10
  CALL:padright __TEXT__ %__Left__%
  CALL:padleft __SIZE__ %__RIGHT__%
  REM ECHO %__TEXT__%+%__SIZE__%+%__OTHER__%
  ECHO. %__TEXT__% %__OTHER__%
ENDLOCAL
GOTO:eof

:padright
CALL SET padded=%%%1%%%spaces%
CALL SET %1=%%padded:~0,%2%%
GOTO:eof

:padleft
CALL SET padded=%spaces%%%%1%%
CALL SET %1=%%padded:~-%2%%
GOTO:EOF

:Done