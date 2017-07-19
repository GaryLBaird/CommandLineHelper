@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
SET COUNT=0
SET ARG_wmicFunc=%1
IF /I "%1"=="Help" SET ARG_wmicFunc=--Help
SET ARG_wmicComputer=%2
SET ARG_wmicOutPut=%3
IF NOT DEFINED ARG_wmicOutPut SET ARG_wmicOutPut=/format:list
::ARG_wmicOutPut E.G. /format:textvaluelist.xsl
::ARG_wmicOutPut E.G. /output:e:\file1.htm
::ARG_wmicOutPut E.G. /format:[list/csv]
IF NOT DEFINED ARG_wmicComputer SET ARG_wmicComputer=%COMPUTERNAME%
IF DEFINED ARG_wmicFunc (
  CALL:%ARG_wmicFunc% "%ARG_wmicComputer%","%ARG_wmicFunc%","%ARG_wmicOutPut%"
) ELSE (
  CALL:--RUNALL %ARG_wmicComputer% %ARG_wmicFunc% %ARG_wmicOutPut%
)
GOTO :Done
:--RUNALL
SET ALL_WMIC_Func=baseboard,bios,bootconfig,cdrom,computersystem,cpu,datafile,dcomapp,desktop,desktopmonitor,diskdrive,diskquota,environment,fsdir,group,idecontroller,irq,job,loadorder,logicaldisk,memcache,memlogical,memphysical,netclient,netlogin,netprotocol,netuse,nic,nicconfigA,nicconfigB,nicconfigC,nicconfigD,ntdomain,nteventA,nteventB,nteventC,onboarddevice,operatingsystem,osstatus,pagefile,pagefileset,partition,printer,printjob,process,product,qfe,quotasetting,recoveros,Registry,scsicontroller,server,service,share,sounddev,startup,sysaccount,sysdriver,systemenclosure,systemslot,tapedrive,timezone,useraccount,memorychip
FOR /D %%A IN (%ALL_WMIC_Func%) DO (
  ECHO.
  CALL:%%A %~1 %%A %ARG_wmicOutPut%
  pause
)
GOTO:EOF

:baseboard
  ECHO %~1,%~2,%~3,%~4
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Manufacturer, Model, Name, PartNumber, slotlayout, serialnumber, poweredon %~3 %~3
  WMIC /NODE:%~1 %~2 get Manufacturer, Model, Name, PartNumber, slotlayout, serialnumber, poweredon %~3 %~3
GOTO:EOF
:bios
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get name, version, serialnumber %~3
  WMIC /NODE:%~1 %~2 get name, version, serialnumber %~3
GOTO:EOF
:bootconfig
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get BootDirectory, Caption, TempDirectory, Lastdrive %~3
  WMIC /NODE:%~1 %~2 get BootDirectory, Caption, TempDirectory, Lastdrive %~3
GOTO:EOF
:cdrom
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Drive, Volumename %~3
  WMIC /NODE:%~1 %~2 get Name, Drive, Volumename %~3
  ECHO %ERRORLEVEL%
  ECHO   USAGE:
  ECHO. 
  ECHO   GET [^<property list^>] [^<get switches^>]
  ECHO   NOTE: ^<property list^> ::= ^<property name^> ^| ^<property name^>,  ^<property list^>
  ECHO.
  ECHO   Since these devices are not all that common anymore here is the help.
  ECHO   The following properties are available:
  ECHO   Property                                Type                    Operation
  ECHO   ========                                ====                    =========
  ECHO   Availability                            N/A                     N/A
  ECHO   Capabilities                            N/A                     N/A
  ECHO   CapabilityDescriptions                  N/A                     N/A
  ECHO   CompressionMethod                       N/A                     N/A
  ECHO   ConfigManagerErrorCode                  N/A                     N/A
  ECHO   ConfigManagerUserConfig                 N/A                     N/A
  ECHO   DefaultBlockSize                        N/A                     N/A
  ECHO   Description                             N/A                     N/A
  ECHO   DeviceID                                N/A                     N/A
  ECHO   Drive                                   N/A                     N/A
  ECHO   DriveIntegrity                          N/A                     N/A
  ECHO   ErrorCleared                            N/A                     N/A
  ECHO   ErrorDescription                        N/A                     N/A
  ECHO   ErrorMethodology                        N/A                     N/A
  ECHO   FileSystemFlags                         N/A                     N/A
  ECHO   FileSystemFlagsEx                       N/A                     N/A
  ECHO   Id                                      N/A                     N/A
  ECHO   InstallDate                             N/A                     N/A
  ECHO   LastErrorCode                           N/A                     N/A
  ECHO   Manufacturer                            N/A                     N/A
  ECHO   MaxBlockSize                            N/A                     N/A
  ECHO   MaxMediaSize                            N/A                     N/A
  ECHO   MaximumComponentLength                  N/A                     N/A
  ECHO   MediaLoaded                             N/A                     N/A
  ECHO   MediaType                               N/A                     N/A
  ECHO   MfrAssignedRevisionLevel                N/A                     N/A
  ECHO   MinBlockSize                            N/A                     N/A
  ECHO   Name                                    N/A                     N/A
  ECHO   NeedsCleaning                           N/A                     N/A
  ECHO   NumberOfMediaSupported                  N/A                     N/A
  ECHO   PNPDeviceID                             N/A                     N/A
  ECHO   PowerManagementCapabilities             N/A                     N/A
  ECHO   PowerManagementSupported                N/A                     N/A
  ECHO   RevisionLevel                           N/A                     N/A
  ECHO   SCSIBus                                 N/A                     N/A
  ECHO   SCSILogicalUnit                         N/A                     N/A
  ECHO   SCSIPort                                N/A                     N/A
  ECHO   SCSITargetId                            N/A                     N/A
  ECHO   Size                                    N/A                     N/A
  ECHO   Status                                  N/A                     N/A
  ECHO   StatusInfo                              N/A                     N/A
  ECHO   SystemName                              N/A                     N/A
  ECHO   TransferRate                            N/A                     N/A
  ECHO   VolumeName                              N/A                     N/A
  ECHO   VolumeSerialNumber                      N/A                     N/A
  ECHO. 
  ECHO   The following GET switches are available:
  ECHO. 
  ECHO   /VALUE                       - Return value.
  ECHO   /ALL(default)                - Return the data and metadata for the attribute.
  ECHO   /TRANSLATE:^<table name^>      - Translate output via values from ^<table name^>.
  ECHO   /EVERY:^<interval^> [/REPEAT:^<repeat count^>] - Returns value every (X interval)
  ECHO   seconds, If /REPEAT specified the command is executed ^<repeat count^> times.
  ECHO   /FORMAT:^<format specifier^>   - Keyword/XSL filename to process the XML results.
  ECHO. 
  ECHO   NOTE: Order of /TRANSLATE and /FORMAT switches influences the appearance of output.
  ECHO   Case1: If /TRANSLATE precedes /FORMAT, then translation of results will be followed by formatting.
  ECHO   Case2: If /TRANSLATE succeeds /FORMAT, then translation of the formatted results will be done.
GOTO:EOF
:computersystem
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, domain, Manufacturer, Model, NumberofProcessors, PrimaryOwnerName,Username, Roles, totalphysicalmemory /format:list %~3
  WMIC /NODE:%~1 %~2 get Name, domain, Manufacturer, Model, NumberofProcessors, PrimaryOwnerName,Username, Roles, totalphysicalmemory /format:list %~3
GOTO:EOF
:cpu
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Caption, MaxClockSpeed, DeviceID, status %~3
  WMIC /NODE:%~1 %~2 get Name, Caption, MaxClockSpeed, DeviceID, status %~3
GOTO:EOF
:datafile
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 where name='c:\boot.ini' get Archive, FileSize, FileType, InstallDate, Readable, Writeable, System, Version %~3
  WMIC /NODE:%~1 %~2 where name='c:\boot.ini' get Archive, FileSize, FileType, InstallDate, Readable, Writeable, System, Version %~3
GOTO:EOF
:dcomapp
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, AppID /format:list %~3
  WMIC /NODE:%~1 %~2 get Name, AppID /format:list %~3
GOTO:EOF
:desktop
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, ScreenSaverExecutable, ScreenSaverActive, Wallpaper /format:list %~3
  WMIC /NODE:%~1 %~2 get Name, ScreenSaverExecutable, ScreenSaverActive, Wallpaper /format:list %~3
GOTO:EOF
:desktopmonitor
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get screenheight, screenwidth %~3
  WMIC /NODE:%~1 %~2 get screenheight, screenwidth %~3
GOTO:EOF
:diskdrive
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Manufacturer, Model, InterfaceType, MediaLoaded, MediaType %~3
  WMIC /NODE:%~1 %~2 get Name, Manufacturer, Model, InterfaceType, MediaLoaded, MediaType %~3
GOTO:EOF
:diskquota
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get User, Warninglimit, DiskSpaceUsed, QuotaVolume %~3
  WMIC /NODE:%~1 %~2 get User, Warninglimit, DiskSpaceUsed, QuotaVolume %~3
GOTO:EOF
:environment
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Description, VariableValue %~3
  WMIC /NODE:%~1 %~2 get Description, VariableValue %~3
GOTO:EOF
:fsdir
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO Checking_Directory=c:\\windows
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 where name='c:\\windows' get Archive, CreationDate, LastModified, Readable, Writeable, System, Hidden, Status %~3
  WMIC /NODE:%~1 %~2 where name='c:\\windows' get Archive, CreationDate, LastModified, Readable, Writeable, System, Hidden, Status %~3
  ECHO All Properties Example:
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 where name='c:\\windows' get * %~3
  WMIC /NODE:%~1 %~2 where name='c:\\windows' get * %~3
GOTO:EOF
:group
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, InstallDate, LocalAccount, Domain, SID, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, InstallDate, LocalAccount, Domain, SID, Status %~3
GOTO:EOF
:idecontroller
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Manufacturer, DeviceID, Status %~3
  WMIC /NODE:%~1 %~2 get Name, Manufacturer, DeviceID, Status %~3
GOTO:EOF
:irq
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Status %~3
  WMIC /NODE:%~1 %~2 get Name, Status %~3
GOTO:EOF
:job
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Owner, DaysOfMonth, DaysOfWeek, ElapsedTime, JobStatus, StartTime, Status %~3
  WMIC /NODE:%~1 %~2 get Name, Owner, DaysOfMonth, DaysOfWeek, ElapsedTime, JobStatus, StartTime, Status %~3
GOTO:EOF
:loadorder
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, DriverEnabled, GroupOrder, Status %~3
  WMIC /NODE:%~1 %~2 get Name, DriverEnabled, GroupOrder, Status %~3
GOTO:EOF
:logicaldisk
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Compressed, Description, DriveType, FileSystem, FreeSpace, SupportsDiskQuotas, VolumeDirty, VolumeName %~3
  WMIC /NODE:%~1 %~2 get Name, Compressed, Description, DriveType, FileSystem, FreeSpace, SupportsDiskQuotas, VolumeDirty, VolumeName %~3
GOTO:EOF
:memcache
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, BlockSize, Purpose, MaxCacheSize, Status %~3
  WMIC /NODE:%~1 %~2 get Name, BlockSize, Purpose, MaxCacheSize, Status %~3
GOTO:EOF
:memlogical
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get AvailableVirtualMemory, TotalPageFileSpace, TotalPhysicalMemory, TotalVirtualMemory %~3
  WMIC /NODE:%~1 %~2 get AvailableVirtualMemory, TotalPageFileSpace, TotalPhysicalMemory, TotalVirtualMemory %~3
GOTO:EOF
:memphysical
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Manufacturer, Model, SerialNumber, MaxCapacity, MemoryDevices %~3
  WMIC /NODE:%~1 %~2 get Manufacturer, Model, SerialNumber, MaxCapacity, MemoryDevices %~3
GOTO:EOF
:netclient
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Name, Manufacturer, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, Name, Manufacturer, Status %~3
GOTO:EOF
:netlogin
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Fullname, ScriptPath, Profile, UserID, NumberOfLogons, PasswordAge, LogonServer, HomeDirectory, PrimaryGroupID %~3
  WMIC /NODE:%~1 %~2 get Name, Fullname, ScriptPath, Profile, UserID, NumberOfLogons, PasswordAge, LogonServer, HomeDirectory, PrimaryGroupID %~3
GOTO:EOF
:netprotocol
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Description, GuaranteesSequencing, SupportsBroadcasting, SupportsEncryption, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, Description, GuaranteesSequencing, SupportsBroadcasting, SupportsEncryption, Status %~3
GOTO:EOF
:netuse
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, DisplayType, LocalName, Name, ProviderName, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, DisplayType, LocalName, Name, ProviderName, Status %~3
GOTO:EOF
:nic
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get AdapterType, AutoSense, Name, Installed, MACAddress, PNPDeviceID,PowerManagementSupported, Speed, StatusInfo %~3
  WMIC /NODE:%~1 %~2 get AdapterType, AutoSense, Name, Installed, MACAddress, PNPDeviceID,PowerManagementSupported, Speed, StatusInfo %~3
GOTO:EOF
:nicconfigA
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 nicconfig get MACAddress, DefaultIPGateway, IPAddress, IPSubnet, DNSHostName, DNSDomain %~3
  WMIC /NODE:%~1 nicconfig get MACAddress, DefaultIPGateway, IPAddress, IPSubnet, DNSHostName, DNSDomain %~3
GOTO:EOF
:nicconfigB
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, DHCPEnabled, DHCPLeaseExpires, DHCPLeaseObtained, DHCPServer %~3
  WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, DHCPEnabled, DHCPLeaseExpires, DHCPLeaseObtained, DHCPServer %~3
GOTO:EOF
:nicconfigC
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, DNSHostName, DNSDomain, DNSDomainSuffixSearchOrder, DNSEnabledForWINSResolution, DNSServerSearchOrder %~3
  WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, DNSHostName, DNSDomain, DNSDomainSuffixSearchOrder, DNSEnabledForWINSResolution, DNSServerSearchOrder %~3
GOTO:EOF
:nicconfigD
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, WINSPrimaryServer, WINSSecondaryServer, WINSEnableLMHostsLookup, WINSHostLookupFile %~3
  WMIC /NODE:%~1 nicconfig get MACAddress, IPAddress, WINSPrimaryServer, WINSSecondaryServer, WINSEnableLMHostsLookup, WINSHostLookupFile %~3
GOTO:EOF
:ntdomain
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, ClientSiteName, DomainControllerAddress, DomainControllerName, Roles, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, ClientSiteName, DomainControllerAddress, DomainControllerName, Roles, Status %~3
GOTO:EOF
:nteventA
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 ntevent where (LogFile='system' and SourceName='W32Time') get Message, TimeGenerated %~3
  WMIC /NODE:%~1 ntevent where (LogFile='system' and SourceName='W32Time') get Message, TimeGenerated %~3
GOTO:EOF
:nteventB
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  SET Day=%date:~7,2%
  SET /A Day=%Day% -100
  SET nteventb=%date:~10,4%%date:~4,2%%Day%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 NTEVENT where (LogFile='system') get Message, TimeGenerated %~3
  WMIC /NODE:%~1 NTEVENT where (LogFile='system') get Message, TimeGenerated %~3
GOTO:EOF
:nteventC
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 ntevent where (LogFile='system' and SourceName='Service Control Manager') get Category, CategoryString, ComputerName, Data, EventCode, EventIdentifier, EventType, InsertionStrings, Logfile, Message, RecordNumber, SourceName, TimeGenerated, TimeWritten, Type, User %~3
  WMIC /NODE:%~1 ntevent where (LogFile='system' and SourceName='Service Control Manager') get Category, CategoryString, ComputerName, Data, EventCode, EventIdentifier, EventType, InsertionStrings, Logfile, Message, RecordNumber, SourceName, TimeGenerated, TimeWritten, Type, User %~3
GOTO:EOF
:onboarddevice
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Description, DeviceType, Enabled, Status %~3
  WMIC /NODE:%~1 %~2 get Description, DeviceType, Enabled, Status %~3
GOTO:EOF
:operatingsystem
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Version, Caption, CountryCode, CSName, Description, InstallDate, SerialNumber, ServicePackMajorVersion, WindowsDirectory /format:list %~3
  WMIC /NODE:%~1 %~2 get Version, Caption, CountryCode, CSName, Description, InstallDate, SerialNumber, ServicePackMajorVersion, WindowsDirectory /format:list %~3
GOTO:EOF
:osstatus
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get CurrentTimeZone, FreePhysicalMemory, FreeVirtualMemory, LastBootUpTime, NumberofProcesses, NumberofUsers, Organization, RegisteredUser, Status %~3
  WMIC /NODE:%~1 %~2 get CurrentTimeZone, FreePhysicalMemory, FreeVirtualMemory, LastBootUpTime, NumberofProcesses, NumberofUsers, Organization, RegisteredUser, Status %~3
GOTO:EOF
:pagefile
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, CurrentUsage, Status, TempPageFile %~3
  WMIC /NODE:%~1 %~2 get Caption, CurrentUsage, Status, TempPageFile %~3
GOTO:EOF
:pagefileset
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, InitialSize, MaximumSize %~3
  WMIC /NODE:%~1 %~2 get Name, InitialSize, MaximumSize %~3
GOTO:EOF
:partition
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Size, PrimaryPartition, Status, Type %~3
  WMIC /NODE:%~1 %~2 get Caption, Size, PrimaryPartition, Status, Type %~3
GOTO:EOF
:printer
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get DeviceID, DriverName, Hidden, Name, PortName, PowerManagementSupported, PrintJobDataType, VerticalResolution, Horizontalresolution %~3
  WMIC /NODE:%~1 %~2 get DeviceID, DriverName, Hidden, Name, PortName, PowerManagementSupported, PrintJobDataType, VerticalResolution, Horizontalresolution %~3
GOTO:EOF
:printjob
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Description, Document, ElapsedTime, HostPrintQueue, JobID, JobStatus, Name, Notify, Owner, TimeSubmitted, TotalPages %~3
  WMIC /NODE:%~1 %~2 get Description, Document, ElapsedTime, HostPrintQueue, JobID, JobStatus, Name, Notify, Owner, TimeSubmitted, TotalPages %~3
GOTO:EOF
:process
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, CommandLine, Handle, HandleCount, PageFaults, PageFileUsage, PArentProcessId, ProcessId, ThreadCount %~3
  WMIC /NODE:%~1 %~2 get Caption, CommandLine, Handle, HandleCount, PageFaults, PageFileUsage, PArentProcessId, ProcessId, ThreadCount %~3
GOTO:EOF
:product
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Description, InstallDate, Name, Vendor, Version %~3
  WMIC /NODE:%~1 %~2 get Description, InstallDate, Name, Vendor, Version %~3
GOTO:EOF
:qfe
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get description, FixComments, HotFixID, InstalledBy, InstalledOn, ServicePackInEffect %~3
  WMIC /NODE:%~1 %~2 get description, FixComments, HotFixID, InstalledBy, InstalledOn, ServicePackInEffect %~3
GOTO:EOF
:quotasetting
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, DefaultLimit, Description, DefaultWarningLimit, SettingID, State %~3
  WMIC /NODE:%~1 %~2 get Caption, DefaultLimit, Description, DefaultWarningLimit, SettingID, State %~3
GOTO:EOF
:recoveros
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get AutoReboot, DebugFilePath, WriteDebugInfo, WriteToSystemLog %~3
  WMIC /NODE:%~1 %~2 get AutoReboot, DebugFilePath, WriteDebugInfo, WriteToSystemLog %~3
GOTO:EOF
:Registry
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get CurrentSize, MaximumSize, ProposedSize, Status %~3
  WMIC /NODE:%~1 %~2 get CurrentSize, MaximumSize, ProposedSize, Status %~3
GOTO:EOF
:scsicontroller
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, DeviceID, Manufacturer, PNPDeviceID %~3
  WMIC /NODE:%~1 %~2 get Caption, DeviceID, Manufacturer, PNPDeviceID %~3
GOTO:EOF
:server
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get ErrorsAccessPermissions, ErrorsGrantedAccess, ErrorsLogon, ErrorsSystem, FilesOpen, FileDirectorySearches %~3
  WMIC /NODE:%~1 %~2 get ErrorsAccessPermissions, ErrorsGrantedAccess, ErrorsLogon, ErrorsSystem, FilesOpen, FileDirectorySearches %~3
GOTO:EOF
:service
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Caption, State, ServiceType, StartMode, pathname %~3
  WMIC /NODE:%~1 %~2 get Name, Caption, State, ServiceType, StartMode, pathname %~3
GOTO:EOF
:share
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get name, path, status %~3
  WMIC /NODE:%~1 %~2 get name, path, status %~3
GOTO:EOF
:sounddev
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, DeviceID, PNPDeviceID, Manufacturer, status %~3
  WMIC /NODE:%~1 %~2 get Caption, DeviceID, PNPDeviceID, Manufacturer, status %~3
GOTO:EOF
:startup
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Location, Command %~3
  WMIC /NODE:%~1 %~2 get Caption, Location, Command %~3
GOTO:EOF
:sysaccount
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Domain, Name, SID, SIDType, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, Domain, Name, SID, SIDType, Status %~3
GOTO:EOF
:sysdriver
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Name, PathName, ServiceType, State, Status %~3
  WMIC /NODE:%~1 %~2 get Caption, Name, PathName, ServiceType, State, Status %~3
GOTO:EOF
:systemenclosure
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Height, Depth, Manufacturer, Model, SMBIOSAssetTag, AudibleAlarm, SecurityStatus, SecurityBreach, PoweredOn, NumberOfPowerCords %~3
  WMIC /NODE:%~1 %~2 get Caption, Height, Depth, Manufacturer, Model, SMBIOSAssetTag, AudibleAlarm, SecurityStatus, SecurityBreach, PoweredOn, NumberOfPowerCords %~3
GOTO:EOF
:systemslot
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Number, SlotDesignation, Status, SupportsHotPlug, Version, CurrentUsage, ConnectorPinout %~3
  WMIC /NODE:%~1 %~2 get Number, SlotDesignation, Status, SupportsHotPlug, Version, CurrentUsage, ConnectorPinout %~3
GOTO:EOF
:tapedrive
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Name, Capabilities, Compression, Description, MediaType, NeedsCleaning, Status, StatusInfo %~3
  WMIC /NODE:%~1 %~2 get Name, Capabilities, Compression, Description, MediaType, NeedsCleaning, Status, StatusInfo %~3
GOTO:EOF
:timezone
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get Caption, Bias, DaylightBias, DaylightName, StandardName %~3
  WMIC /NODE:%~1 %~2 get Caption, Bias, DaylightBias, DaylightName, StandardName %~3
GOTO:EOF
:useraccount
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get AccountType, Description, Domain, Disabled, LocalAccount, Lockout, PasswordChangeable, PasswordExpires, PasswordRequired, SID %~3
  WMIC /NODE:%~1 %~2 get AccountType, Description, Domain, Disabled, LocalAccount, Lockout, PasswordChangeable, PasswordExpires, PasswordRequired, SID %~3
GOTO:EOF
:memorychip
  SET /A COUNT=%COUNT% +1
  ECHO [%~0]
  ECHO Function_Count=%COUNT%
  ECHO WMIC_COMMAND=WMIC /NODE:%~1 %~2 get BankLabel, Capacity, Caption, CreationClassName, DataWidth, Description, Devicelocator, FormFactor, HotSwappable, InstallDate, InterleaveDataDepth, InterleavePosition, Manufacturer, MemoryType, Model, Name, OtherIdentifyingInfo, PartNumber, PositionInRow, PoweredOn, Removable, Replaceable, SerialNumber, SKU, Speed, Status, Tag, TotalWidth, TypeDetail, Version %~3
  WMIC /NODE:%~1 %~2 get BankLabel, Capacity, Caption, CreationClassName, DataWidth, Description, Devicelocator, FormFactor, HotSwappable, InstallDate, InterleaveDataDepth, InterleavePosition, Manufacturer, MemoryType, Model, Name, OtherIdentifyingInfo, PartNumber, PositionInRow, PoweredOn, Removable, Replaceable, SerialNumber, SKU, Speed, Status, Tag, TotalWidth, TypeDetail, Version %~3
GOTO:EOF

:--Help
CALL:FORMATOUT 50,20," %~0",""
CALL:FORMATOUT 50,20," _________________________________________________________",""
CALL:FORMATOUT 20,20," Function Parameter","Description:"
CALL:FORMATOUT 50,20," _________________________________________________________",""
CALL:FORMATOUT 20,20," Example:"," timezone %computername%"
CALL:FORMATOUT 20,20," baseboard","Executes 'WMIC /NODE:ComputerName baseboard get ...' and prints the results."
CALL:FORMATOUT 20,20," bios","Executes 'WMIC /NODE:ComputerName bios get ...' and prints the results."
CALL:FORMATOUT 20,20," bootconfig","Executes 'WMIC /NODE:ComputerName bootconfig get ...' and prints the results."
CALL:FORMATOUT 20,20," cdrom","Executes 'WMIC /NODE:ComputerName cdrom get ...' and prints the results."
CALL:FORMATOUT 20,20," computersystem","Executes 'WMIC /NODE:ComputerName computersystem get ...' and prints the results."
CALL:FORMATOUT 20,20," cpu","Executes 'WMIC /NODE:ComputerName cpu get ...' and prints the results."
CALL:FORMATOUT 20,20," datafile","Executes 'WMIC /NODE:ComputerName datafile get ...' and prints the results."
CALL:FORMATOUT 20,20," dcomapp","Executes 'WMIC /NODE:ComputerName dcomapp get ...' and prints the results."
CALL:FORMATOUT 20,20," desktop","Executes 'WMIC /NODE:ComputerName desktop get ...' and prints the results."
CALL:FORMATOUT 20,20," desktopmonitor","Executes 'WMIC /NODE:ComputerName desktopmonitor get ...' and prints the results."
CALL:FORMATOUT 20,20," diskdrive","Executes 'WMIC /NODE:ComputerName diskdrive get ...' and prints the results."
CALL:FORMATOUT 20,20," diskquota","Executes 'WMIC /NODE:ComputerName diskquota get ...' and prints the results."
CALL:FORMATOUT 20,20," environment","Executes 'WMIC /NODE:ComputerName environment get ...' and prints the results."
CALL:FORMATOUT 20,20," fsdir","Executes 'WMIC /NODE:ComputerName fsdir get ...' and prints the results."
CALL:FORMATOUT 20,20," group","Executes 'WMIC /NODE:ComputerName group get ...' and prints the results."
CALL:FORMATOUT 20,20," idecontroller","Executes 'WMIC /NODE:ComputerName idecontroller get ...' and prints the results."
CALL:FORMATOUT 20,20," irq","Executes 'WMIC /NODE:ComputerName irq get ...' and prints the results."
CALL:FORMATOUT 20,20," job","Executes 'WMIC /NODE:ComputerName job get ...' and prints the results."
CALL:FORMATOUT 20,20," loadorder","Executes 'WMIC /NODE:ComputerName loadorder get ...' and prints the results."
CALL:FORMATOUT 20,20," logicaldisk","Executes 'WMIC /NODE:ComputerName logicaldisk get ...' and prints the results."
CALL:FORMATOUT 20,20," memcache","Executes 'WMIC /NODE:ComputerName memcache get ...' and prints the results."
CALL:FORMATOUT 20,20," memlogical","Executes 'WMIC /NODE:ComputerName memlogical get ...' and prints the results."
CALL:FORMATOUT 20,20," memphysical","Executes 'WMIC /NODE:ComputerName memphysical get ...' and prints the results."
CALL:FORMATOUT 20,20," netclient","Executes 'WMIC /NODE:ComputerName netclient get ...' and prints the results."
CALL:FORMATOUT 20,20," netlogin","Executes 'WMIC /NODE:ComputerName netlogin get ...' and prints the results."
CALL:FORMATOUT 20,20," netprotocol","Executes 'WMIC /NODE:ComputerName netprotocol get ...' and prints the results."
CALL:FORMATOUT 20,20," netuse","Executes 'WMIC /NODE:ComputerName netuse get ...' and prints the results."
CALL:FORMATOUT 20,20," nic","Executes 'WMIC /NODE:ComputerName nic get ...' and prints the results."
CALL:FORMATOUT 20,20," nicconfigA","Executes 'WMIC /NODE:ComputerName nicconfig get ...' and prints the results."
CALL:FORMATOUT 20,20," nicconfigB","Executes 'WMIC /NODE:ComputerName nicconfig get ...' and prints the results."
CALL:FORMATOUT 20,20," nicconfigC","Executes 'WMIC /NODE:ComputerName nicconfig get ...' and prints the results."
CALL:FORMATOUT 20,20," nicconfigD","Executes 'WMIC /NODE:ComputerName nicconfig get ...' and prints the results."
CALL:FORMATOUT 20,20," ntdomain","Executes 'WMIC /NODE:ComputerName ntdomain get ...' and prints the results."
CALL:FORMATOUT 20,20," nteventA","Executes 'WMIC /NODE:ComputerName ntevent get ...' and prints the results."
CALL:FORMATOUT 20,20," nteventB","Executes 'WMIC /NODE:ComputerName ntevent get ...' and prints the results."
CALL:FORMATOUT 20,20," nteventC","Executes 'WMIC /NODE:ComputerName ntevent get ...' and prints the results."
CALL:FORMATOUT 20,20," onboarddevice","Executes 'WMIC /NODE:ComputerName onboarddevice get ...' and prints the results."
CALL:FORMATOUT 20,20," operatingsystem","Executes 'WMIC /NODE:ComputerName operatingsystem get ...' and prints the results."
CALL:FORMATOUT 20,20," osstatus","Executes 'WMIC /NODE:ComputerName osstatus get ...' and prints the results."
CALL:FORMATOUT 20,20," pagefile","Executes 'WMIC /NODE:ComputerName pagefile get ...' and prints the results."
CALL:FORMATOUT 20,20," pagefileset","Executes 'WMIC /NODE:ComputerName pagefileset get ...' and prints the results."
CALL:FORMATOUT 20,20," partition","Executes 'WMIC /NODE:ComputerName partition get ...' and prints the results."
CALL:FORMATOUT 20,20," printer","Executes 'WMIC /NODE:ComputerName printer get ...' and prints the results."
CALL:FORMATOUT 20,20," printjob","Executes 'WMIC /NODE:ComputerName printjob get ...' and prints the results."
CALL:FORMATOUT 20,20," process","Executes 'WMIC /NODE:ComputerName process get ...' and prints the results."
CALL:FORMATOUT 20,20," product","Executes 'WMIC /NODE:ComputerName product get ...' and prints the results."
CALL:FORMATOUT 20,20," qfe","Executes 'WMIC /NODE:ComputerName qfe get ...' and prints the results."
CALL:FORMATOUT 20,20," quotasetting","Executes 'WMIC /NODE:ComputerName quotasetting get ...' and prints the results."
CALL:FORMATOUT 20,20," recoveros","Executes 'WMIC /NODE:ComputerName recoveros get ...' and prints the results."
CALL:FORMATOUT 20,20," Registry","Executes 'WMIC /NODE:ComputerName Registry get ...' and prints the results."
CALL:FORMATOUT 20,20," scsicontroller","Executes 'WMIC /NODE:ComputerName scsicontroller get ...' and prints the results."
CALL:FORMATOUT 20,20," server","Executes 'WMIC /NODE:ComputerName server get ...' and prints the results."
CALL:FORMATOUT 20,20," service","Executes 'WMIC /NODE:ComputerName service get ...' and prints the results."
CALL:FORMATOUT 20,20," share","Executes 'WMIC /NODE:ComputerName share get ...' and prints the results."
CALL:FORMATOUT 20,20," sounddev","Executes 'WMIC /NODE:ComputerName sounddev get ...' and prints the results."
CALL:FORMATOUT 20,20," startup","Executes 'WMIC /NODE:ComputerName startup get ...' and prints the results."
CALL:FORMATOUT 20,20," sysaccount","Executes 'WMIC /NODE:ComputerName sysaccount get ...' and prints the results."
CALL:FORMATOUT 20,20," sysdriver","Executes 'WMIC /NODE:ComputerName sysdriver get ...' and prints the results."
CALL:FORMATOUT 20,20," systemenclosure","Executes 'WMIC /NODE:ComputerName systemenclosure get ...' and prints the results."
CALL:FORMATOUT 20,20," systemslot","Executes 'WMIC /NODE:ComputerName systemslot get ...' and prints the results."
CALL:FORMATOUT 20,20," tapedrive","Executes 'WMIC /NODE:ComputerName tapedrive get ...' and prints the results."
CALL:FORMATOUT 20,20," timezone","Executes 'WMIC /NODE:ComputerName timezone get ...' and prints the results."
CALL:FORMATOUT 20,20," useraccount","Executes 'WMIC /NODE:ComputerName useraccount get ...' and prints the results."
CALL:FORMATOUT 20,20," --Help"," Runs this help menu."
CALL:FORMATOUT 20,20," --RunAll"," Runs all the functions."
GOTO:EOF

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done