#Requires -RunAsAdministrator

<#

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 99-99999 -HashResults -Srum -Edd -Prefetch -NumOfPFRecords 5 -AllDrives -ListDrives -DriveList @("J","N") -NTUser -Registry -EventLogs -Archive

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 99-99999 -Edd -HashResults -Srum -Prefetch -EventLogs -Archive -NTUser -AllDrives -ListDrives -DriveList @("G","K","J")

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 24-21445 -Edd -Process -Ram -NTUser -Registry -Prefetch -EventLogs -ListDrives @(all) -Srum -HashResults -Archive

.\tx3-triage.ps1 -User "Mike Spon" -Agency VSP -CaseNumber 24-21445 -Edd -Process -Ram -NTUser -Registry -Prefetch -EventLogs -AllDrives -NoListDrives -DriveList @("C","F") -Srum -HashResults -Archive

#>

param (
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
    [int]$NumOfPFRecords,

    [switch]$EventLogs,
    [int]$NumOfEventLogs,

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


# Configure the powershell policy to run unsigned scripts
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force


$ErrorActionPreference = "SilentlyContinue"


# Get Name of .ps1 file
$ScriptName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# Name of the folder containing the .psm1 files that are to be imported
$ModulesFolder = "modules"


Import-Module .\functions\functions.psm1 -Force -Global
Show-Message("Module file: ``functions.psm1`` was imported successfully") -NoTime -Blue


# # Get the directory of the current script
$ScriptDirectory = $(Get-Location)


# # Construct the path to the 'modules' directory
$ModulesDirectory = Join-Path -Path $ScriptDirectory -ChildPath $ModulesFolder


foreach ($file in (Get-ChildItem -Path $ModulesDirectory -Filter *.psm1 -Force)) {
    Import-Module -Name $file.FullName -Force -Global
    Show-Message("Module file: ``$($file.Name)`` was imported successfully") -NoTime -Blue
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Module file: ``$($file.Name)`` was imported successfully")
}

Write-Host "All modules from ``$ModulesDirectory`` have been imported successfully."


# Start transcript to record all of the screen output
$BeginRecord = Start-Transcript -OutputDirectory $LogFolder -IncludeInvocationHeader -NoClobber
Show-Message("$BeginRecord") -NoTime -Header
Write-LogEntry("$BeginRecord")
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] PowerShell transcript started") -DebugMessage
Write-Host ""


function Get-ParameterValues {
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
        throw "You should not pass parameters to Get-ParameterValues, just dot-source it like this: ``. Get-ParameterValues``"
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


# Write the data to the log file and display start time message on the screen
Write-LogEntry("`n-----------------------------------------------") -NoTime  -NoLevel
Write-LogEntry("    Script Log for tX3 DFIR Script Usage") -NoTime -NoLevel
Write-LogEntry("-----------------------------------------------") -NoTime -NoLevel


[string]$Banner = "
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
|                                     |
|   tx3-triage POWERSHELL SCRIPT      |
|   Compiled by: Michael Sponheimer   |
|   Last Updated: $Dlu          |
|                                     |
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
"


# Display the DFIR banner and instructions to the user
Show-Message("$Banner") -NoTime -Red
Write-LogEntry("$Banner") -NoTime -NoLevel


$StartMessage = "$ScriptName execution started"
Show-Message("$StartMessage") -Blue
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] $StartMessage")


# Write script parameters to the log file
$ParamHashTable = . Get-ParameterValues
Write-LogEntry("$ScriptName Script Parameter Values:")
$ParamHashTable.GetEnumerator() | ForEach-Object { Write-LogEntry("$($_.Key): $($_.Value)") -NoTime -NoLevel }


Show-Message("
=============
INSTRUCTIONS
=============

[A]  You are about to run the tx3-triage DFIR Powershell Script.
[B]  PURPOSE: TO gather information from the target machine and
     save the data to outside storage device.
[C]  The results will automatically be stored in a directory that
     is automatically created in the same directory from where this
     script is run.
[D]  **IMPORTANT** DO NOT VIEW THE RESULTS OF THE SCAN ON THE TARGET
     MACHINE. MOVE THE COLLECTION DEVICE TO A FORENSIC MACHINE BEFORE
     OPENING ANY FILES!
[E]  DO NOT close any pop-up windows that may appear.
[F]  To get help for this script, run ``Get-Help .\tx3-triage.ps1``
     command from a PowerShell CLI prompt.
[G]  To exit this script at anytime, press ``Ctrl + C``.`n"
) -NoTime -Yellow


Write-Host ""

Show-Message("--> Please read the instructions before executing the script! <--") -NoTime -RedOnGray


# Stops the script until the user presses the ENTER key so the script does not begin before the user is ready
Read-Host -Prompt "`nPress [ENTER] to begin data collection -> "


if ($Null -eq $User) {
    [String]$User = Read-Host -Prompt "[*] Enter user's name -> "
}


if ($Null -eq $Agency) {
    [String]$Agency = Read-Host -Prompt "`n[*] Enter agency name -> "
}


if ($Null -eq $CaseNumber) {
    [String]$CaseNumber = Read-Host -Prompt "`n[*] Enter case number -> "
}


Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Operator Name Entered: $User")
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Agency Name Entered: $Agency")
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Case Number Entered: $CaseNumber")
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Computer Name: $ComputerName")

# Write device IP information to the log file
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Device IPv4 address: $Ipv4")
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Device IPv6 address: $Ipv6")


Show-Message("Data acquisition started. This may take a hot minute...") -Header
Write-LogEntry("Data acquisition started. This may take a hot minute...`n") -Header


# Running Encrypted Disk Detector
if ($Edd) {
    Get-EncryptedDiskDetector $CaseFolderName $ComputerName

    # Read the contents of the EDD text file and show the results on the screen
    Get-Content -Path "$CaseFolderName\00A_EncryptedDiskDetector\EncryptedDiskDetector.txt" -Force

    Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Yellow
    Write-Host ""
    Read-Host -Prompt "Press ENTER to continue data collection -> "
}
else {
    # If the user does not want to execute EDD
    Show-Message("[WARNING] (A) Encrypted Disk Detector will NOT be run") -Yellow

    # Write message that EDD was not run to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Encrypted Disk Detector option was not enabled") -WarningMessage
}


# Run the scripts that collect the optional data that was included in the command line switches
if ($Process) {
    Get-RunningProcesses $CaseFolderName $ComputerName
}
else {
    # If the user does not want to execute ProcessCapture
    Show-Message("[WARNING] (B) Process Capture will NOT be run") -Yellow

    # Write message that Processes Capture was not collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Process Capture option was not enabled") -WarningMessage
}



if ($Ram) {
    Get-ComputerRam $CaseFolderName $ComputerName
}
else {
    # Display message that the RAM was not collected
    Show-Message("[WARNING] (C) RAM will NOT be collected") -Yellow

    # Write message that RAM was not collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The RAM Capture option was not enabled") -WarningMessage
}


if ($Registry) {
    Get-RegistryHives $CaseFolderName $ComputerName
}
else {
    # Display message that Registry Hive files will not be collected
    Show-Message("[WARNING] (D) Registry Hive files will NOT be collected") -Yellow

    # Write message that Registry Hive files will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Registry Hive file collection option was not enabled") -WarningMessage
}


if ($EventLogs) {
    Get-EventLogs $CaseFolderName $ComputerName -NumOfEventLogs $NumOfEventLogs
}
else {
    # Display message that event logs will not be collected
    Show-Message("[WARNING] (E) Windows Event Logs will NOT be collected") -Yellow

    # Write message that event logs will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Windows Event Log collection option was not enabled") -WarningMessage
}


if ($NTUser) {
    Get-NTUserDatFiles $CaseFolderName $ComputerName
}
else {
    # Display message that NTUSER.DAT file will not be collected
    Show-Message("[WARNING] (F) NTUSER.DAT files will NOT be collected") -Yellow

    # Write message that NTUSER.DAT files will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The NTUSER.DAT file collection option was not enabled") -WarningMessage
}


if ($Prefetch) {
    Get-PrefetchFiles $CaseFolderName $ComputerName -NumOfPFRecords $NumOfPFRecords
}
else {
    # Display message that prefetch files will not be collected
    Show-Message("[WARNING] (G) Windows Prefetch files will NOT be collected") -Yellow

    # Write message that prefetch files will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Windows Prefetch file collection option was not enabled") -WarningMessage
}


if ($Srum) {
    Get-SrumDB $CaseFolderName $ComputerName
}
else {
    # Display message that file lists will not be collected
    Show-Message("[WARNING] (H) SRUM.dat database will NOT be collected") -Yellow

    # Write message that file lists will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The SRUM database collection option was not enabled") -WarningMessage
}


function Invoke-ListAllFiles {

    # If -AllDrives is used, invoke Get-AllFilesList with additional parameters
    if ($AllDrives) {
        # Validate conflicting switches
        if ($ListDrives -and $NoListDrives) {
            Show-Message("[WARNING] (I) You cannot use both ``-IncludeDrives`` and ``-ExcludeDrives`` together") -Red
            return
        }
        # Get a list of available drives on the examined machine
        $AvailableDrives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name

        # Determine drives to scan based on user input
        $DrivesToScan = switch ($true) {
            $ListDrives {
                if (-not $DriveList) {
                    Show-Message "[ERROR] ``-IncludeDrives`` requires a valid drive list [example ``-IncludeDrives @(C,D,F)``" -Red
                    return
                }
                $DriveList | Where-Object { $AvailableDrives -contains $_ } | ForEach-Object {
                    if ($_ -notin $AvailableDrives) {
                        Show-Message "[WARNING] Drive ``$($_):\`` is not available and will be skipped." -Yellow
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
            Get-AllFilesList $CaseFolderName $ComputerName -DriveList $DrivesToScan
        }
        else {
            Show-Message "[ERROR] No valid drives selected for scanning." -Red
        }
    }
    else {
        # Display message that file lists will not be collected
        Show-Message("[WARNING] All file listings will NOT be collected") -Yellow

        # Write message that file lists will not be collected to the .log file
        Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The All File Listings collection option was not enabled") -WarningMessage
    }
}
Invoke-ListAllFiles


if (-not $HashResults) {
    # Display message that output files will not be hashed
    Show-Message("[WARNING] Saved files will NOT be hashed") -Yellow

    # Write message that output files will not be hashed to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The Hash Results Files option was not enabled") -WarningMessage
}


if (-not $Archive) {
    # Display message that prefetch files will not be collected
    Show-Message("[WARNING] Case archive (.zip) file will NOT be created") -Yellow

    # Write message that prefetch files will not be collected to the .log file
    Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] The create Case Archive file option was not enabled") -WarningMessage
}



function Invoke-Yolo {
    # Run all the collection options
    if ($Yolo) {
        Get-EncryptedDiskDetector $CaseFolderName $ComputerName
        Get-RunningProcesses $CaseFolderName $ComputerName
        Get-ComputerRam $CaseFolderName $ComputerName
        Get-RegistryHives $CaseFolderName $ComputerName
        Get-EventLogs $CaseFolderName $ComputerName
        Get-NTUserDatFiles $CaseFolderName $ComputerName
        Get-PrefetchFiles $CaseFolderName $ComputerName
        Get-SrumDB $CaseFolderName $ComputerName
        Get-AllFilesList $CaseFolderName $ComputerName -DriveList $DrivesToScan
    }
}
Invoke-Yolo


#* ======================================
#*
#* RUNNING ALL THE COMMANDS
#*
#* ======================================


#! -------------------------------
#! (0) Run the TESTING commands
#! -------------------------------

# Get-ForensicData
# Get-SuspiciousFiles
# Get-BrowserHistory
# Compare-FileHashes
Get-USBSTOR
# Get-RecentlyAccessedFiles
# Get-SuspiciousFilePermissions
# Get-PrefetchAnalysis
# Get-ThumbnailCache


#! -------------------------------
#! (1) Run the DEVICE commands
#! -------------------------------

# Get-VariousData
# Get-TPMData
# Get-PSInfo
# Get-PSDriveData
# Get-LogicalDiskData
# Get-ComputerData
# Get-SystemDataCMD
# Get-SystemDataPS
# Get-OperatingSystemData
# Get-PhysicalMemory
# Get-EnvVars
# Get-PhysicalDiskData
# Get-DiskPartitions
# Get-Win32DiskParts
# Get-Win32StartupApps
# Get-HKLMSoftwareCVRunStartupApps
# Get-HKLMSoftwareCVPoliciesExpRunStartupApps
# Get-HKLMSoftwareCVRunOnceStartupApps
# Get-HKCUSoftwareCVRunStartupApps
# Get-HKCUSoftwareCVPoliciesExpRunStartupApps
# Get-HKCUSoftwareCVRunOnceStartupApps
# Get-SoftwareLicenseData
# Get-AutoRunsData
# Get-BiosData
# Get-ConnectedDevices
# Get-HardwareInfo
# Get-Win32Products
# Get-OpenWindowTitles


#! -------------------------------
#! (2) Run the USER commands
#! -------------------------------

# Get-WhoAmI
# Get-UserProfile
# Get-UserInfo
# Get-LocalUserData
# Get-LogonSession
# Get-PowershellConsoleHistoryAllUsers
# Get-LastLogons


#! -------------------------------
#! (3) Run the NETWORK commands
#! -------------------------------

# Get-NetworkConfig
# Get-OpenNetworkConnections
# Get-NetstatDetailed
# Get-NetstatBasic
# Get-NetTcpConnectionsAllTxt
# Get-NetTcpConnectionsAllCsv
# Get-NetworkAdapters
# Get-NetIPConfig
# Get-RouteData
# Get-IPConfig
# Get-ARPData
# Get-NetIPAddrs
# Get-HostsFile
# Get-NetworksFile
# Get-ProtocolFile
# Get-ServicesFile
# Get-SmbShares
# Get-WifiPasswords
# Get-NetInterfaces
# Get-NetRouteData


#! -------------------------------
#! (4) Run the PROCESS commands
#! -------------------------------

# Get-RunningProcessesAll
# Get-RunningProcessesCsv
# Get-UniqueProcessHash
# Get-SvcHostsAndProcesses
# Get-RunningServices
# Get-InstalledDrivers


#! -------------------------------
#! (5) Run the SYSTEM commands
#! -------------------------------

# Get-ADS
# Get-OpenFiles
# Get-OpenShares
# Get-MappedNetworkDriveMRU
# Get-ScheduledJobs
# Get-ScheduledTasks
# Get-ScheduledTasksRunInfo
# Get-HotFixesData
# Get-InstalledAppsFromReg
# Get-InstalledAppsFromAppx
# Get-VolumeShadowsData
# Get-DnsCacheDataTxt
# Get-DnsCacheDataCsv
# Get-TempInternetFiles
# Get-StoredCookiesData
# Get-TypedUrls
# Get-InternetSettings
# Get-TrustedInternetDomains
# Get-AppInitDllKeys
# Get-UacGroupPolicy
# Get-GroupPolicy
# Get-ActiveSetupInstalls
# Get-AppPathRegKeys
# Get-DllsLoadedByExplorer
# Get-ShellUserInitValues
# Get-SecurityCenterSvcValuesData
# Get-DesktopAddressBarHst
# Get-RunMruKeyData
# Get-StartMenuData
# Get-ProgramsExeBySessionManager
# Get-ShellFoldersData
# Get-UserStartupShellFolders
# Get-ApprovedShellExts
# Get-AppCertDlls
# Get-ExeFileShellCommands
# Get-ShellOpenCommands
# Get-BcdRelatedData
# Get-LsaData
# Get-BrowserHelperFile
# Get-BrowserHelperx64File
# Get-IeExtensions
# Get-UsbDevices
# Get-AuditPolicy
# Get-RecentAddedExeFiles
# Get-HiddenFiles
# Get-ExecutableFiles

# -------------------------------

# Get-RecentDllFiles
# Get-RecentLinkFiles
# Get-CompressedFiles
# Get-EncryptedFiles
# Get-ExeTimeline
# Get-DownloadedExecutables


#! -------------------------------
#! (6) Running PREFETCH command
#! -------------------------------

# Get-PrefetchFilesList
# Get-DetailedPrefetchData


#! -------------------------------
#! # (7) Running EVENT LOG commands
#! -------------------------------

# Get-EventLogListBasic
# Get-EventLogListDetailed
# Get-SecurityEventCount
# Get-SecurityEventsLast30DaysTxt
# Get-SecurityEventsLast30DaysCsv
# Get-Application1002Events
# Get-System1014Events
# Get-Application1102Events
# Get-Security4616Events
# Get-Security4624Events
# Get-Security4625Events
# Get-Security4648Events
# Get-Security4672Events
# Get-Security4673Events
# Get-Security4674Events
# Get-Security4688Events
# Get-Security4720Events
# Get-System7036Events
# Get-System7045Events
# Get-System64001Events
# Get-AppInvEvts
# Get-TerminalServiceEvents
# Get-PSOperational4104Events


#! -------------------------------
#! (8) Running FIREWALL command
#! -------------------------------

# Get-FirewallRules
# Get-AdvFirewallRules
# Get-DefenderExclusions


#! -------------------------------
#! (9) Running BITLOCKER command
#! -------------------------------

# Get-BitlockerRecoveryKeys


# Get the time the script was completed

$EndTimeForLog = Get-Date
$DurationForLog = New-TimeSpan -Start $StartTime -End $EndTimeForLog

# Calculate the total run time of the script and formats the results
$DiffForLog = "$($DurationForLog.Days) days $($DurationForLog.Hours) hours $($DurationForLog.Minutes) minutes $($DurationForLog.Seconds) seconds"

# Display a message that the script has completed and list the total time run time on the screen
Write-LogEntry("[$($ScriptName), Ln: $(Get-LineNum)] Script execution completed in: $DiffForLog")


Write-LogEntry("
===========================
Hashing result files...
===========================`n") -NoTime -NoLevel


# If the user wanted to get hash values for the saved output files
if ($HashResults) {
    Get-FileHashes $CaseFolderName $ComputerName
}


# Ask the user if they wish to make a .zip file of the results folder when script is complete
if ($Archive) {
    Get-CaseArchive
}


$EndTimeForShow = Get-Date
$DurationForShow = New-TimeSpan -Start $StartTime -End $EndTimeForShow
$DiffForShow = "$($DurationForShow.Days) days $($DurationForShow.Hours) hours $($DurationForShow.Minutes) minutes $($DurationForShow.Seconds) seconds"

Show-Message("Script execution completed in: $DiffForShow") -Header -Green
Show-Message("The results are available in the ``\$(($CaseFolderName).Name)\`` directory") -Header -Green


# Stop the transcript
Show-Message("`n$(Stop-Transcript)") -NoTime


# Stop the keylogger job when the script is finished
# Ensures the keylogger process is terminated
try {
    Get-Job | Stop-Job
    Remove-Job *
    Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
}
catch {
    # Error handling
    $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
    Show-Message("$ErrorMessage") -Red
    Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
}


# Show a popup message when script is complete
(New-Object -ComObject Wscript.Shell).popup("The Script has finished running", 0, "Done", 0x1) | Out-Null

# SIG # Begin signature block
# MIIFZwYJKoZIhvcNAQcCoIIFWDCCBVQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU7/xjTL30K+3Or7UPK36EK2Kb
# D42gggMEMIIDADCCAeigAwIBAgIQGKLs86JnC6ZL8ZC0RGujlDANBgkqhkiG9w0B
# AQsFADAYMRYwFAYDVQQDDA10eDNUcmlhZ2VDZXJ0MB4XDTI1MDEyNjE1NDIzMFoX
# DTI2MDEyNjE2MDIzMFowGDEWMBQGA1UEAwwNdHgzVHJpYWdlQ2VydDCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBALTiMUg44inftEcjD6aEAeJ+5vOx7hZe
# ym1BhxGR+NgO7c90FZths+PW9YLoxCyZBrzL1n0GuoDcnwkfd8H0BFb/FWCvEj1W
# 9c0a5mTWlJ24v0xnwEM806s+MXVtEz8wvtb8ApIsizKzzIJtvjBA8ZRXGRwX4Hxj
# Lj5ZNoI3bc/ty5BiOSPDnwhzXm5/n7gF/qS3uPxFcPgL1vZ3W6zqNrKxC5wbxRAz
# f1JLPEIcet4uS6lHY2IIVOEkIioCBjS6A4bxw0mGHzWwtNRXX6lG17m6dR5NC0HB
# de+ug+EPNPrAu/K87SnYMXzT4PTAcMvMmF22F7hvbR9z7D+oCNR+4PUCAwEAAaNG
# MEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQW
# BBTqGt0uVBnBkXeqXuQbyfalOvfzSjANBgkqhkiG9w0BAQsFAAOCAQEAItBglcz1
# AIOph2OqhbF3hLGRTqRsTLLywUMaqm6aZEsOgvyCVwsWMh39PIrHJ4w+/rmrUUwJ
# 6gaWMPdan27xM5M84PJMU2DCVmBptUf5IJDUfbwanGKO+3sq153hFyGcm/+a5009
# yh2RDypQR6UfJm0iySwT8GbAJsPOOMX0X0qNEs4cUIys3UxEzygJw4Fp9cM/T99D
# XyHjbzrFrimOyW1qYDTfcZvhzW/wzJRqwP1xR+tFo9/k0UeGq//5aStEwEypNpf7
# M9hkxZnTn+AmTn3xLicMkCTXe24Kczt24xnSpMPJ36acd+vrTZsHsWOlzWbidbU1
# F1a/8Y+HaZTqJjGCAc0wggHJAgEBMCwwGDEWMBQGA1UEAwwNdHgzVHJpYWdlQ2Vy
# dAIQGKLs86JnC6ZL8ZC0RGujlDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEK
# MAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3
# AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUuBjqbXrDgdUSj813
# UAsGfIE1yg4wDQYJKoZIhvcNAQEBBQAEggEAhsbDbcfPEZYp+wlmZENVQNCt86Gp
# Iwi10d2lRyNnc8QxgcHd39QPbL4+9tfwgs8z71HoI5Cx1B172VwDQP4BWZkXtJT3
# vmQrHd1w+47CULK7RJ1WFT27P6nmJpEwQetbKnYO77/Ba0Ww8zve3ho49e3374Xf
# Fm6S19EV+Sb8So1ErPXxubHB+9k7oMHsw4MieCiPMztJtjkK9mTjFyW7/ryFsxzU
# gaBM80NTJXGLICTT56B2YP2jXAx2KlLAbAzwCPxspZ/NMqoubQGOh3r/Ph+cz38U
# biN06kbVTD449cgq3gYw9CkxUZZc0RoxrN4WSU0I050KGmqZrePBM8w+Pw==
# SIG # End signature block
