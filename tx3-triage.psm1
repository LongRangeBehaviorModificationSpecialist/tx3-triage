# EDITED BY : mikespon

#Requires -RunAsAdministrator


# CHECK THESE FUNCTIONS TO SEE IF THEY SHOULD BE INCLUDED

#TODO -- "E:\DFIR-SCRIPTS\__OTHER_REPOS\Meerkat\Modules\Get-DomainInfo.psm1"
#TODO -- "E:\DFIR-SCRIPTS\__OTHER_REPOS\Meerkat\Modules\Get-ADS.psm1"


<#

function Get-RecentlyInstalledSoftwareEventLogs {
    Write-Host "Collecting Recently Installed Software EventLogs..."
    $ApplicationFolder = "$FolderCreation\Applications"
    mkdir -Force $ApplicationFolder | Out-Null
    $ProcessOutput = "$ApplicationFolder\RecentlyInstalledSoftwareEventLogs.txt"
    Get-WinEvent -ProviderName msiinstaller | where id -eq 1033 | select timecreated, message | FL * | Out-File -Force -FilePath $ProcessOutput
    $CSVExportLocation = "$CSVOutputFolder\InstalledSoftware.csv"
    Get-WinEvent -ProviderName msiinstaller | where id -eq 1033 | select timecreated, message | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $CSVExportLocation -Encoding UTF8
}

#>

<#

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 99-99999 -HashResults -AllDrives -ListDrives -DriveList @("J")

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 99-99999 -Edd -HashResults -Srum -Prefetch -EventLogs -Archive -NTUser -AllDrives -ListDrives -DriveList @("G","K","J")

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 24-21445 -Edd -Process -Ram -NTUser -Registry -Prefetch -EventLogs -ListDrives @(all) -Srum -HashResults -Archive

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 24-21445 -Edd -Process -Ram -NTUser -Registry -PFFiles -EventLogs -AllDrives -NoListDrives -DriveList @("C","F") -Srum -HashResults -Archive

#>


<#
.SYNOPSIS
    Obtains information from a computer running the Windows OS that may prove useful with DFIR triage tasks.

.DESCRIPTION
    In addition to collecting basic information about the computer, the user has the option to collect the following data:

    (1)  Running Processes
    (2)  RAM
    (3)  NTUSER.DAT Files
    (4)  Registry Hives (from the `C:\Windows\System32\config` directory)
    (5)  Prefetch Files
    (6)  Windows Event Logs
    (7)  Copy the SRUMDB.DAT database from the examined device
    (8)  Names of all files from all connected devices (selected by user)

    Further, the user can choose the options to:

    (9)  Hash the files that are created as a result of running this script
    (10) Create an archive file (.zip format) of the results

    The order that the switches are listed on the command line does not matter.

.PARAMETER User
    Name of the user or person conducting the triage of the device. If there are spaces in the name, enclose the value in double quotes (i.e. "FirstName LastName").

.PARAMETER Agency
    Name of the agency conducting the investigation. If there are spaces in the name, enclose the value in double quotes (i.e. "VIRGINIA STATE POLICE").

.PARAMETER CaseNumber
    Case number of the investigation. If there are spaces in this value, enclose the entire value in double quotes.

.PARAMETER Edd
    Run Encrypted Disk Detection on the examined machine and save the output to a text file.

.PARAMETER Process
    Collect information on the currently running processes to the collection device. Each process will be saved as a `.dmp` file. Processes will be collected using Magnet Process Capture.

.PARAMETER Ram
    Collect the computer's RAM to the collection device? RAM will be collected using Magnet RAM Capture.

.PARAMETER NTUser
    Copy all of the NTUSER.DAT files from the system to the collection device?

.PARAMETER Registry
    Copy the common registry hives to the collection device? The hives that will be copied are the SAM, SECURITY, SYSTEM, SOFTWARE, and the current user's NTUSER.DAT file.

.PARAMETER PFFiles
    Copy the prefetch files from the operating system to the collection device?

.PARAMETER EventLogs
    Copy the Event Log files fom the operating system to the collection device? This will recursively copy all of the Windows Event Logs.

.PARAMETER Srum
    Include this switch if you want to copy the SRUM.DAT database file from the machine being examined.

.PARAMETER AllDrives
    Create lists of each file, from each mounted drive, that is currently connected to the examined machine? This option will recursively search each connected storage device and create a list of each file that is stored on that device. This may take some time to complete, depending on the size and useage of the connected devices.

    To include all drives connected to the examined machine, use the `-AllDrives` switch

    PS C:\> .\tx3-triage.ps1 -AllDrives

    To only INCLUDE CERTAIN drives in the scan, list the drives using the `DriveList` switch and include the `-ListDrives` switch. [This command will only scan the C:\ and D:\ drives]

    PS C:\> .\tx3-triage.ps1 -AllDives -ListDrives -DriveList @("C","D")

    To EXCLUDE CERTAIN drives from the scan, list the drives using the `DriveList` switch and include the `-ExcludeDrives` switch. [This command will scan all drives EXCEPT the F:\ and Z:\ drives]

    PS C:\> .\tx3-triage.ps1 -AllDives -NoListDrives -DriveList @("F","Z")

.PARAMETER HashResults
    Hash each of the files output from this script? It will create a .CSV file in the `HashResults` directory documenting the hash value of each file created by this script.

.PARAMETER Archive
    Create an archive (.zip) file of the results folder.

.INPUTS
    None

.OUTPUTS
    This script will create a new directory in the directory from which this script is launched.
    The new directory will have the following naming convention:
    <yyyymmdd_hhmmss>_<ComputerIpAddress>_<ComputerName>, i.e. `20250113_102532_192.168.101.28_BAD-GUYS-COMPUTER`.

.EXAMPLE
    .\tx3-triage.ps1 [[-User] <UserName>] [[-Agency] <AgencyName>] [[-CaseNumber] <CaseNumber>]

    Basic Usage -> NO file hashing, NO case archive creation

.EXAMPLE
    .\tx3-triage.ps1 [[-User] <UserName>] [[-Agency] <AgencyName>] [[-CaseNumber] <CaseNumber>] [-HashResults] [-Archive]

    Basic Usage -> including hashing all the output/copied files) and creating a case archive (.zip) folder

.EXAMPLE
    .\tx3-triage.ps1 [[-User] <UserName>] [[-Agency] <AgencyName>] [[-CaseNumber] <CaseNumber>] [-HashResults] [-Archive] [-Yolo]

    Collect all information (the `-HashResults` and `-Archive` switches are not included within the `-Yolo` switch command; they must be listed seperately).

.EXAMPLE
    .\tx3-triage.ps1 [[-User] <UserName>] [[-Agency] <AgencyName>] [[-CaseNumber] <CaseNumber>] [-HashResults] [-Archive]

.LINK
    https://github.com/LongRangeBehaviorModificationSpecialist/tx3/tree/main

.NOTES
    Author: Michael A Sponheimer
    Date:   2025-01-22
#>


param
(
    [Parameter(Mandatory = $True)]
    [string]$User,

    [Parameter(Mandatory = $True)]
    [string]$Agency,

    [Parameter(Mandatory = $True)]
    [string]$CaseNumber,

    [switch]$Edd,
    [switch]$Process,
    [switch]$Ram,
    [switch]$NTUser,
    [switch]$Registry,
    [switch]$Prefetch,
    [switch]$EventLogs,
    [switch]$AllDrives,
    # If set, only include specific drives
    [switch]$ListDrives,
    # If set, exclude specific drives
    [switch]$NoListDrives,
    [string[]]$DriveList,
    [switch]$Srum,
    [switch]$HashResults,
    [switch]$Archive,
    [switch]$Yolo
)


Importing the required module(s)
$psm1Files = Get-ChildItem -Path .\tx3-triage -Filter *.psm1
Write-Host ""
foreach ($file in $psm1Files ) {
    Import-Module -Name $file.FullName -Force -Global
    Show-Message("Module file: $($file.Name) was imported successfully`n") -NoTime -Blue
}
# Import-Module .\tx3-triage\Get-ComputerDetails.psm1 -Force -Global
# Import-Module .\tx3-triage\Get-TPMDetails.psm1 -Force -Global
# Import-Module .\tx3-triage\tx3-triage.psm1 -Force -Global

# Show-Message("`nModule file `"tx3-triage.psm1`" was imported successfully`n") -NoTime -Blue


# Create the required directories to store the results with no output printed to the terminal
Set-CaseFolder


function Get-ParameterValues {
<#
.SYNOPSIS
    Get the actual values of parameters which have manually set (non-null) default values or values passed in the call

.DESCRIPTION
    Unlike $PSBoundParameters, the hashtable returned from Get-ParameterValues includes non-empty default parameter values.
    NOTE: Default values that are the same as the implied values are ignored (e.g.: empty strings, zero numbers, nulls).

.EXAMPLE
    function Test-Parameters {
        [CmdletBinding()]
        param(
            $Name = $Env:UserName,
            $Age
        )
        $Parameters = . Get-ParameterValues
        # This WILL ALWAYS have a value...
        Write-Host $Parameters["Name"]
        # But this will NOT always have a value...
        Write-Host $PSBoundParameters["Name"]
    }
#>
    [CmdletBinding()]
    param(
        # The $MyInvocation for the caller -- DO NOT pass this (dot-source Get-ParameterValues instead)
        $Invocation = $MyInvocation,
        # The $PSBoundParameters for the caller -- DO NOT pass this (dot-source Get-ParameterValues instead)
        $BoundParameters = $PSBoundParameters
    )

    if ($MyInvocation.Line[($MyInvocation.OffsetInLine - 1)] -ne '.') {
        throw "Get-ParameterValues must be dot-sourced, like this: . Get-ParameterValues"
    }

    if ($PSBoundParameters.Count -gt 0) {
        throw "You should not pass parameters to Get-ParameterValues, just dot-source it like this: `". Get-ParameterValues`""
    }

    [Hashtable]$ParameterValues = @{}
    foreach ($Parameter in $Invocation.MyCommand.Parameters.GetEnumerator()) {
        try {
            $Key = $Parameter.Key
            if ($Null -ne ($Value = Get-Variable -Name $Key -ValueOnly -ErrorAction Ignore)) {
                if ($Value -ne ($Null -as $Parameter.Value.ParameterType)) {
                    $ParameterValues[$Key] = $Value
                }
            }
            if ($BoundParameters.ContainsKey($Key)) {
                $ParameterValues[$Key] = $BoundParameters[$Key]
            }
        }
        finally {}
    }
    $ParameterValues
}


$ErrorActionPreference = "SilentlyContinue"


# Get Name of .ps1 file
$ScriptName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


[String]$Banner = "
******************************************************************
*   ____  _____ ___ ____      ____   ____ ____  ___ ____ _____   *
*  |  _ \|  ___|_ _|  _ \    / ___| / ___|  _ \|_ _|  _ \_   _|  *
*  | | | | |_   | || |_) |   \___ \| |   | |_) || || |_) || |    *
*  | |_| |  _|  | ||  _ <     ___) | |___|  _ < | ||  __/ | |    *
*  |____/|_|   |___|_| \_\   |____/ \____|_| \_\___|_|    |_|    *
*                                                                *
******************************************************************
[$ScriptName]
"

# Display the DFIR banner and instructions to the user
Show-Message("$Banner") -NoTime -Red
Write-LogMessage("$Banner") -NoTime -NoLevel


# Write the data to the log file and display start time message on the screen
Write-LogMessage("-----------------------------------------------") -NoTime  -NoLevel
Write-LogMessage("    Script Log for tX3 DFIR Script Usage") -NoTime -NoLevel
Write-LogMessage("-----------------------------------------------`n") -NoTime -NoLevel

[String]$StartMessage = "$ScriptName execution started"
Show-Message("$StartMessage") -Blue
# Write-Host ""
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $StartMessage")


# Write script parameters to the log file
$ParamHashTable = . Get-ParameterValues
Write-LogMessage("$ScriptName Script Parameter Values:")
$ParamHashTable.GetEnumerator() | ForEach-Object { Write-LogMessage("$($_.Key): $($_.Value)") -NoTime -NoLevel }


# List of file types to use in some commands
$ExecutableFileTypes = @(
    "*.BAT", "*.BIN", "*.CGI", "*.CMD", "*.COM", "*.DLL",
    "*.EXE", "*.JAR", "*.JOB", "*.JSE", "*.MSI", "*.PAF",
    "*.PS1", "*.SCR", "*.SCRIPT", "*.VB", "*.VBE", "*.VBS",
    "*.VBSCRIPT", "*.WS", "*.WSF"
)

# Configure the powershell policy to run unsigned scripts
$OriginalExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force


# # Clear the terminal screen before displaying the DFIR banner and instructions
# Clear-Host


Show-Message("
--------------------------------------
Script Compiled by: Michael Sponheimer
Last Updated: $Dlu
--------------------------------------") -NoTime

Show-Message("
=============
INSTRUCTIONS
=============

[A] You are about to run the VECTOR DFIR Powershell Script.
[B] PURPOSE: Gather information from the target machine and
    save the data to text files.
[C] The results will be stored in a directory that is automatically
    created in the same directory from where this script is run.
[D] **DO NOT** close any pop-up windows that may appear.
[E] To get help for this script, run `Get-Help .\tx3-triage.ps1`
    from a PowerShell command line prompt.
[F] To exit this script at anytime, press 'Ctrl + C'.") -NoTime -Blue


Show-Message("
Please read the instructions before executing the script!") -NoTime -Red
Write-Host ""


# Show message that the case folder has been created and the directory name
$CaseDirMadeMsg = "Case directory created -> `"\$(Split-Path -Path $CaseFolder -Leaf)\`""
Show-Message("$CaseDirMadeMsg`n") -Magenta
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $CaseDirMadeMsg")


# Stops the script until the user presses the ENTER key so the script does not begin before the user is ready
Read-Host -Prompt "Press ENTER to begin data collection ->"


# Start transcript to record all of the screen output
Write-Host ""
Start-Transcript -OutputDirectory $LogFolder -IncludeInvocationHeader -NoClobber
Write-Host ""

Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] PowerShell transcript started") -DebugMesssage



# Get the names of the folders in the $CaseFolder and write them to the .log file and output names to the screen
Get-ChildItem -Path $CaseFolder -Directory | ForEach-Object {
    Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Created sub-folder `"$($_.Name)`" in the case directory")
    Show-Message("Created `"$($_.Name)`" folder")
}


if ($Null -eq $User) {
    [String]$User = Read-Host -Prompt "[*] Enter user's name ->"
}

if ($Null -eq $Agency) {
    [String]$Agency = Read-Host -Prompt "`n[*] Enter agency name ->"
}

if ($Null -eq $CaseNumber) {
    [String]$CaseNumber = Read-Host -Prompt "`n[*] Enter case number ->"
}

Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Operator Name Entered: $User")
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Agency Name Entered: $Agency")
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Case Number Entered: $CaseNumber")

Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Computer Name: $ComputerName")

# Write device IP information to the log file
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Device IPv4 address: $Ipv4")
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Device IPv6 address: $Ipv6")


Show-Message("Data acquisition started. This may take a hot minute...`n")


function Invoke-Edd {
    # Running Encrypted Disk Detector
    if ($Edd) {
        Get-EncryptedDiskDetector $CaseFolder $ComputerName

        # Read the contents of the EDD text file and show the results on the screen
        Get-Content -Path "$CaseFolder\000A_EncryptedDiskDetector\EncryptedDiskDetector.txt" -Force

        Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Red
        Write-Host ""
        Read-Host -Prompt "Press ENTER to continue data collection ->"
    }
    else {
        # If the user does not want to execute EDD
        Show-Message("[WARNING] Encrypted Disk Detector will NOT be run`n") -Red
        # Write message that EDD was not run to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Encrypted Disk Detector option was not enabled")
    }
}
Invoke-Edd


function Invoke-ProcessCapture {
    # Run the scripts that collect the optional data that was included in the command line switches
    if ($Process) {
        Get-RunningProcesses $CaseFolder $ComputerName
    }
    else {
        # If the user does not want to execute ProcessCapture
        Show-Message("[WARNING] Process Capture will NOT be run`n") -Red
        # Write message that Processes Capture was not collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Process Capture option was not enabled") -WarningMessage
    }
}
Invoke-ProcessCapture


function Invoke-RamCapture {
    if ($Ram) {
        Get-ComputerRam $CaseFolder $ComputerName
    }
    else {
        # Display message that the RAM was not collected
        Show-Message("[WARNING] RAM will NOT be collected`n") -Red
        # Write message that RAM was not collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The RAM Capture option was not enabled") -WarningMessage
    }
}
Invoke-RamCapture


function Invoke-RegistryCopy {
    if ($Registry) {
        Get-RegistryHives $CaseFolder $ComputerName
    }
    else {
        # Display message that Registry Hive files will not be collected
        Show-Message("[WARNING] Registry Hive files will NOT be collected`n") -Red
        # Write message that Registry Hive files will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Registry Hive file collection option was not enabled") -WarningMessage
    }
}
Invoke-RegistryCopy


function Invoke-EventLogCopy {
    if ($EventLogs) {
        Get-EventLogs $CaseFolder $ComputerName
    }
    else {
        # Display message that event logs will not be collected
        Show-Message("[WARNING] Windows Event Logs will NOT be collected`n") -Red
        # Write message that event logs will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Windows Event Log collection option was not enabled") -WarningMessage
    }
}
Invoke-EventLogCopy


function Invoke-CopyNTUserFiles {
    if ($NTUser) {
        Get-NTUserDatFiles $CaseFolder $ComputerName
    }
    else {
        # Display message that NTUSER.DAT file will not be collected
        Show-Message("[WARNING] NTUSER.DAT files will NOT be collected`n") -Red
        # Write message that NTUSER.DAT files will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The NTUSER.DAT file collection option was not enabled") -WarningMessage
    }
}
Invoke-CopyNTUserFiles


function Invoke-PrefetchCopy {
    if ($Prefetch) {
        Get-PrefetchFiles $CaseFolder $ComputerName
    }
    else {
        # Display message that prefetch files will not be collected
        Show-Message("[WARNING] Windows Prefetch files will NOT be collected`n") -Red
        # Write message that prefetch files will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Windows Prefetch file collection option was not enabled") -WarningMessage
    }
}
Invoke-PrefetchCopy


function Invoke-SrumDBCopy {
    if ($Srum) {
        Get-SrumDB $CaseFolder $ComputerName
    }
    else {
        # Display message that file lists will not be collected
        Show-Message("[WARNING] SRUM.dat database will NOT be collected`n") -Red
        # Write message that file lists will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The SRUM database collection option was not enabled") -WarningMessage
    }
}
Invoke-SrumDBCopy


function Invoke-ListAllFiles {
    # If -AllDrives is used, invoke Get-AllFilesList with additional parameters
    if ($AllDrives) {
        # Validate conflicting switches
        if ($ListDrives -and $NoListDrives) {
            Show-Message("[WARNING] You cannot use both ``-IncludeDrives`` and ``-ExcludeDrives`` together") -Red
            return
        }

        # Get a list of available drives on the examined machine
        $AvailableDrives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name

        # Determine drives to scan based on user input
        $DrivesToScan = switch ($true) {
            $ListDrives {
                if (-not $DriveList) {
                    Show-Message "[ERROR] ``-IncludeDrives`` requires a valid drive list [example `"-IncludeDrives @(C,D,F)`"" -Red
                    return
                }
                $DriveList | Where-Object { $AvailableDrives -contains $_ } | ForEach-Object {
                    if ($_ -notin $AvailableDrives) {
                        Show-Message "[WARNING] Drive `"$($_):\`" is not available and will be skipped." -Yellow
                    }
                    $_
                }
            }
            $NoListDrives {
                if (-not $DriveList) {
                    Show-Message "[ERROR] ``-ExcludeDrives`` requires a valid drive list (e.g., C, D, etc.)" -Red
                    return
                }
                $AvailableDrives | Where-Object { $_ -notin $DriveList }
            }
            default {
                $AvailableDrives
            }
        }

        # Log selected drives and run the function
        if ($DrivesToScan) {
            Show-Message "Scanning the following drives: $($DrivesToScan -join ', ')" -Green
            Get-AllFilesList $CaseFolder $ComputerName -DriveList $DrivesToScan
        }
        else {
            Show-Message "[ERROR] No valid drives selected for scanning." -Red
        }
    }
    else {
        # Display message that file lists will not be collected
        Show-Message("[WARNING] All file listings will NOT be collected`n") -Red
        # Write message that file lists will not be collected to the .log file
        Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The All File Listings collection option was not enabled") -WarningMessage
    }
}
Invoke-ListAllFiles


function Invoke-Yolo {
# Run all the collection options
    if ($Yolo) {
        Get-EncryptedDiskDetector $CaseFolder $ComputerName
        Get-RunningProcesses $CaseFolder $ComputerName
        Get-ComputerRam $CaseFolder $ComputerName
        Get-RegistryHives $CaseFolder $ComputerName
        Get-EventLogs $CaseFolder $ComputerName
        Get-NTUserDatFiles $CaseFolder $ComputerName
        Get-PrefetchFiles $CaseFolder $ComputerName
        Get-SrumDB $CaseFolder $ComputerName
        Get-AllFilesList $CaseFolder $ComputerName -DriveList $DrivesToScan
    }
}
Invoke-Yolo


<#
    Beginning the main routine
#>













#* ======================================
#*
#* RUNNING ALL THE COMMANDS
#*
#* ======================================


#! -------------------------------
#! (1) Run the DEVICE commands
#! -------------------------------
Get-VariousData
Get-TPMData
Get-PSInfo
Get-PSDriveData
Get-LogicalDiskData
Get-ComputerData
Get-SystemDataCMD
Get-SystemDataPS
Get-OperatingSystemData
Get-PhysicalMemory
Get-EnvVars
Get-PhysicalDiskData
Get-DiskPartitions
Get-Win32DiskParts
Get-Win32StartupApps
Get-HKLMSoftwareCVRunStartupApps
Get-HKLMSoftwareCVPoliciesExpRunStartupApps
Get-HKLMSoftwareCVRunOnceStartupApps
Get-HKCUSoftwareCVRunStartupApps
Get-HKCUSoftwareCVPoliciesExpRunStartupApps
Get-HKCUSoftwareCVRunOnceStartupApps
Get-SoftwareLicenseData
Get-AutoRunsData
Get-BiosData
Get-ConnectedDevices
Get-HardwareInfo
Get-Win32Products
Get-OpenWindowTitles


#! -------------------------------
#! (2) Run the USER commands
#! -------------------------------
Get-WhoAmI
Get-UserProfile
Get-UserInfo
Get-LocalUserData
Get-LogonSession
Get-PowershellConsoleHistoryAllUsers
Get-LastLogons


#! -------------------------------
#! (3) Run the NETWORK commands
#! -------------------------------
Get-NetworkConfig
Get-OpenNetworkConnections
Get-NetstatDetailed
Get-NetstatBasic
Get-NetTcpConnectionsAllTxt
Get-NetTcpConnectionsAllCsv
Get-NetworkAdapters
Get-NetIPConfig
Get-RouteData
Get-IPConfig
Get-ARPData
Get-NetIPAddrs
Get-HostsFile
Get-NetworksFile
Get-ProtocolFile
Get-ServicesFile
Get-SmbShares
Get-WifiPasswords
Get-NetInterfaces
Get-NetRouteData


#! -------------------------------
#! (4) Run the PROCESS commands
#! -------------------------------
Get-RunningProcessesAll
Get-RunningProcessesCsv
Get-UniqueProcessHash
Get-SvcHostsAndProcesses
Get-RunningServices
Get-InstalledDrivers


#! -------------------------------
#! (5) Run the SYSTEM commands
#! -------------------------------
Get-OpenFiles
Get-OpenShares
Get-MappedNetworkDriveMRU
Get-ScheduledJobs
Get-ScheduledTasks
Get-ScheduledTasksRunInfo
Get-HotFixesData
Get-InstalledAppsFromReg
Get-InstalledAppsFromAppx
Get-VolumeShadowsData
Get-DnsCacheDataTxt
Get-DnsCacheDataCsv
Get-TempInternetFiles
Get-StoredCookiesData
Get-TypedUrls
Get-InternetSettings
Get-TrustedInternetDomains
Get-AppInitDllKeys
Get-UacGroupPolicy
Get-GroupPolicy
Get-ActiveSetupInstalls
Get-AppPathRegKeys
Get-DllsLoadedByExplorer
Get-ShellUserInitValues
Get-SecurityCenterSvcValuesData
Get-DesktopAddressBarHst
Get-RunMruKeyData
Get-StartMenuData
Get-ProgramsExeBySessionManager
Get-ShellFoldersData
Get-UserStartupShellFolders
Get-ApprovedShellExts
Get-AppCertDlls
Get-ExeFileShellCommands
Get-ShellOpenCommands
Get-BcdRelatedData
Get-LsaData
Get-BrowserHelperFile
Get-BrowserHelperx64File
Get-IeExtensions
Get-UsbDevices
Get-AuditPolicy
Get-RecentAddedExeFiles
Get-HiddenFiles
Get-ExecutableFiles
# -------------------------------
Get-RecentDllFiles
Get-RecentLinkFiles
Get-CompressedFiles
Get-EncryptedFiles
Get-ExeTimeline
Get-DownloadedExecutables


#! -------------------------------
#! (6) Running PREFETCH command
#! -------------------------------
Get-PrefetchFilesList
Get-DetailedPrefetchData


#! -------------------------------
#! # (7) Running EVENT LOG commands
#! -------------------------------
Get-EventLogListBasic
Get-EventLogListDetailed
Get-SecurityEventCount
Get-SecurityEventsLast30DaysTxt
Get-SecurityEventsLast30DaysCsv
Get-Application1002Events
Get-System1014Events
Get-Application1102Events
Get-Security4616Events
Get-Security4624Events
Get-Security4625Events
Get-Security4648Events
Get-Security4672Events
Get-Security4673Events
Get-Security4674Events
Get-Security4688Events
Get-Security4720Events
Get-System7036Events
Get-System7045Events
Get-System64001Events
Get-AppInvEvts
Get-TerminalServiceEvents
Get-PSOperational4104Events


#! -------------------------------
#! (8) Running FIREWALL command
#! -------------------------------
Get-FirewallRules
Get-AdvFirewallRules
Get-DefenderExclusions


#! -------------------------------
#! (9) Running BITLOCKER command
#! -------------------------------
Get-BitlockerRecoveryKeys


# Get the time the script was completed
[datetime]$EndTimeForLog = Get-Date
[timespan]$DurationForLog = New-TimeSpan -Start $StartTime -End $EndTimeForLog
# Calculate the total run time of the script and formats the results
[string]$DiffForLog = "$($DurationForLog.Days) days $($DurationForLog.Hours) hours $($DurationForLog.Minutes) minutes $($DurationForLog.Seconds) seconds"
# Display a message that the script has completed and list the total time run time on the screen
Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] Script execution completed in: $DiffForLog")


Write-LogMessage("
===========================
Hashing result files...
===========================`n") -NoTime -NoLevel


# If the user wanted to get hash values for the saved output files
if ($HashResults) {
    Get-FileHashes $CaseFolder $ComputerName
}
else {
    # Display message that output files will not be hashed
    Show-Message("WARNING: Saved files will NOT be hashed`n") -Red
    # Write message that output files will not be hashed to the .log file
    Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The Hash Results Files option was not enabled") -WarningMessage
}


# Stop the transcript
Show-Message("`n$(Stop-Transcript)`n") -NoTime -Magenta


# Ask the user if they wish to make a .zip file of the results folder when script is complete
if ($Archive) {
    Get-CaseArchive
}
else {
    # Display message that prefetch files will not be collected
    Show-Message("WARNING: Case archive (.zip) file will NOT be created`n") -Red
    # Write message that prefetch files will not be collected to the .log file
    Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] The create Case Archive file option was not enabled") -WarningMessage
}


[DateTime]$EndTimeForShow = Get-Date
[TimeSpan]$DurationForShow = New-TimeSpan -Start $StartTime -End $EndTimeForShow
[String]$DiffForShow = "$($DurationForShow.Days) days $($DurationForShow.Hours) hours $($DurationForShow.Minutes) minutes $($DurationForShow.Seconds) seconds"
Show-Message("Script execution completed in: $DiffForShow") -Header -Blue
Show-Message("The results are available in the `"\$(($CaseFolder).Name)\`" directory") -Header -Magenta


# Clearing all tbe assigned variables
Clear-Variable * -Force


# Set the Powershell signed scripts policy back to default
Set-ExecutionPolicy -ExecutionPolicy $OriginalExecutionPolicy -Force


# Show a popup message when script is complete
(New-Object -ComObject Wscript.Shell).popup("The Script has finished running", 0, "Done", 0x1) | Out-Null


<# TO ADD TO SCRIPT
--> Check system directories for executables not signed as part of an operating system release
    Get-ChildItem -Path "C:\Windows\*\*.exe" -File -Force | Get-AuthenticodeSignature | ? {$_.IsOSBinary -notmatch 'True'}
    ANOTHER VERSION OF THE ABOVE COMMAND:
    Get-ChildItem -Force -Recurse -Path "C:\Windows\*\*.exe" -File | Get-AuthenticodeSignature | Where-Object {$_.status -eq "Valid"}

    get-childitem -Recurse -include *.exe | Select-Object -Property Name, Directory, @{ N = 'FileHash'; E = { (Get-FileHash $_.FullName).Hash } }, CreationTimeUtc, LastAccessTimeUtc | ConvertTo-Html | Out-File -FilePath "C:\Users\VSP\Desktop\EXETestdoc.html"

    --> something to document the start time and end time
    --> get-transcript to document list of commands run
#>

