$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-FilesReport {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$User,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$Agency,
        [Parameter(Mandatory = $True, Position = 3)]
        [string]$CaseNumber,
        [Parameter(Mandatory = $True, Position = 4)]
        [string]$ComputerName,
        [Parameter(Mandatory = $True, Position = 5)]
        [string]$Ipv4,
        [Parameter(Mandatory = $True, Position = 6)]
        [string]$Ipv6,
        [bool]$Device,
        [bool]$UserData,
        [bool]$Network,
        [bool]$Process,
        [bool]$System,
        [bool]$Prefetch,
        [bool]$EventLogs,
        [bool]$Firewall,
        [bool]$BitLocker,
        [bool]$CaptureProcesses,
        [bool]$GetRam,
        [bool]$Edd,
        [bool]$Hives,
        [bool]$GetNTUserDat,
        [bool]$ListFiles,
        [string]$DriveList,
        [bool]$KeyWordSearch,
        [string]$KeyWordsDriveList,
        # [bool]$Srum,
        # [bool]$CopyPrefetch,
        # [bool]$GetEventLogs,
        [bool]$GetFileHashes,
        [bool]$MakeArchive
    )


    # Create the Logs directory
    # Set-LogFolder


    # Name of the folder containing the .psm1 files that are to be imported
    $FilesModulesDirectory = "files\filesModules"


    foreach ($file in (Get-ChildItem -Path $FilesModulesDirectory -Filter *.psm1 -Force)) {
        Import-Module -Name $file.FullName -Force -Global
        Show-Message("Module file: '.\$($file.Name)' was imported successfully") -NoTime -Blue
        Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Module file '.\$($file.Name)' was imported successfully")
    }


    # Start transcript to record all of the screen output
    $BeginRecord = Start-Transcript -OutputDirectory $LogFolder -IncludeInvocationHeader -NoClobber
    Show-Message("$BeginRecord") -NoTime
    Write-LogEntry("$BeginRecord")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] PowerShell transcript started") -DebugMessage
    Write-Host ""


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
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $StartMessage")


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
    Show-Message("--> Please read the instructions before executing the script! <--") -NoTime -BlueOnGray


    # Stops the script until the user presses the ENTER key so the script does not begin before the user is ready
    Read-Host -Prompt "`nPress [ENTER] to begin data collection -> "


    if (-not $User) {
        [String]$User = Read-Host -Prompt "[*] Enter user's name -> "
    }


    if (-not $Agency) {
        [String]$Agency = Read-Host -Prompt "`n[*] Enter agency name -> "
    }


    if (-not $CaseNumber) {
        [String]$CaseNumber = Read-Host -Prompt "`n[*] Enter case number -> "
    }


    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Operator Name Entered: $User")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Agency Name Entered: $Agency")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Case Number Entered: $CaseNumber")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Computer Name: $ComputerName")

    # Write device IP information to the log file
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Device IPv4 address: $Ipv4")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Device IPv6 address: $Ipv6")


    Show-Message("Data acquisition started. This may take a hot minute...`n")
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Data acquisition started`n")


    # Running Encrypted Disk Detector
    function Invoke-Edd {
        if ($Edd) {
            try {
                Get-EncryptedDiskDetector $CaseFolderName $ComputerName
                # Read the contents of the EDD text file and show the results on the screen
                Get-Content -Path "$CaseFolderName\00A_EncryptedDiskDetector\EncryptedDiskDetector.txt" -Force
                Show-Message("`nEncrypted Disk Detector has finished") -NoTime -Yellow
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # If the user does not want to execute EDD
            Show-Message("[WARNING] Encrypted Disk Detector will NOT be run`n") -Yellow
            # Write message that EDD was not run to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The Encrypted Disk Detector option was not enabled") -WarningMessage
        }
    }
    Invoke-Edd


    function Invoke-Processes {
        if ($CaptureProcesses) {
            try {
                Get-RunningProcesses $CaseFolderName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # If the user does not want to execute ProcessCapture
            Show-Message("[WARNING] Process Capture will NOT be run`n") -Yellow
            # Write message that Processes Capture was not collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The Process Capture option was not enabled") -WarningMessage
        }
    }
    Invoke-Processes


    function Invoke-Ram {
        if ($GetRam) {
            try {
                Get-ComputerRam $CaseFolderName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that the RAM was not collected
            Show-Message("[WARNING] RAM will NOT be collected`n") -Yellow
            # Write message that RAM was not collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The RAM Capture option was not enabled") -WarningMessage
        }
    }
    Invoke-Ram


    function Invoke-DeviceFilesOutput {
        if ($Device) {
            try {
                $DeviceOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "001_Device_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-DeviceFilesPage -OutputFolder $DeviceOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Device Data' option was not selected by the user")
        }
    }
    Invoke-DeviceFilesOutput


    function Invoke-UserFilesOutput {
        if ($UserData) {
            try {
                $UserOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "002_User_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-UserFilesPage -OutputFolder $UserOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get User Data' option was not selected by the user")
        }
    }
    Invoke-UserFilesOutput


    function Invoke-NetworkFilesOutput {
        if ($Network) {
            try {
                $NetworkOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "003_Network_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-NetworkFilesPage -OutputFolder $NetworkOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Network Data' option was not selected by the user")
        }
    }
    Invoke-NetworkFilesOutput


    function Invoke-ProcessFilesOutput {
        if ($Process) {
            try {
                $ProcessOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "004_Process_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-ProcessFilesPage -OutputFolder $ProcessOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Process Data' option was not selected by the user")
        }
    }
    Invoke-ProcessFilesOutput


    function Invoke-SystemFilesOutput {
        if ($System) {
            try {
                $SystemOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "005_System_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-SystemFilesPage -OutputFolder $SystemOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Prefetch Data' option was not selected by the user")
        }
    }
    Invoke-SystemFilesOutput


    function Invoke-PrefetchFilesOutput {
        if ($Prefetch) {
            try {
                $PrefetchOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "006_Prefetch_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-PrefetchFilesPage -OutputFolder $PrefetchOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Prefetch Data' option was not selected by the user")
        }
    }
    Invoke-PrefetchFilesOutput


    function Invoke-EventLogFilesOutput {
        if ($EventLogs) {
            try {
                $EventLogOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "007_EventLog_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-EventLogFilesPage -OutputFolder $EventLogOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Event Log Data' option was not selected by the user")
        }
    }
    Invoke-EventLogFilesOutput


    function Invoke-FirewallFilesOutput {
        if ($Firewall) {
            try {
                $FirewallOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "008_Firewall_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-FirewallFilesPage -OutputFolder $FirewallOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Firewall Data' option was not selected by the user")
        }
    }
    Invoke-FirewallFilesOutput


    function Invoke-BitLockerFilesOutput {
        if ($BitLocker) {
            try {
                $BitLockerOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "009_BitLocker_Info" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-BitLockerFilesPage -OutputFolder $BitLockerOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get BitLocker Data' option was not selected by the user")
        }
    }
    Invoke-BitLockerFilesOutput


    function Invoke-Registry {
        if ($Hives) {
            try {
                Get-RegistryHives $CaseFolderName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that Registry Hive files will not be collected
            Show-Message("[WARNING] Registry Hive files will NOT be collected`n") -Yellow
            # Write message that Registry Hive files will not be collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Collect Registry Hive' option was not enabled") -WarningMessage
        }
    }
    Invoke-Registry


    #! NEED TO ADD OPTION TO GUI
    function Invoke-EventLogs {
        if ($GetEventLogs) {
            try {
                Get-EventLogs $CaseFolderName $ComputerName -NumOfEventLogs $NumOfEventLogs
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that event logs will not be collected
            Show-Message("[WARNING] Windows Event Logs will NOT be collected`n") -Yellow
            # Write message that event logs will not be collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The Windows Event Log collection option was not enabled") -WarningMessage
        }
    }
    Invoke-EventLogs


    function Invoke-NTUser {
        if ($GetNTUserDat) {
            try {
                Get-NTUserDatFiles $CaseFolderName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that NTUSER.DAT file will not be collected
            Show-Message("[WARNING] NTUSER.DAT files will NOT be collected`n") -Yellow
            # Write message that NTUSER.DAT files will not be collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The NTUSER.DAT file collection option was not enabled") -WarningMessage
        }
    }
    Invoke-NTUser


    #! NEED TO ADD OPTION TO GUI
    function Invoke-Prefetch {
        if ($CopyPrefetch) {
            try {
                Get-PrefetchFiles $CaseFolderName $ComputerName -NumOfPFRecords $NumOfPFRecords
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that prefetch files will not be collected
            Show-Message("[WARNING] Windows Prefetch files will NOT be collected`n") -Yellow
            # Write message that prefetch files will not be collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The Windows Prefetch file collection option was not enabled") -WarningMessage
        }
    }
    Invoke-Prefetch


    #! NEED TO ADD OPTION TO GUI
    function Invoke-SrumDB {
        if ($Srum) {
            try {
                Get-SrumDB $CaseFolderName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            # Display message that file lists will not be collected
            Show-Message("[WARNING] SRUM.dat database will NOT be collected`n") -Yellow
            # Write message that file lists will not be collected to the .log file
            Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The SRUM database collection option was not enabled") -WarningMessage
        }
    }
    Invoke-SrumDB


    function Invoke-ListAllFiles {
        if ($ListFiles) {
            try {
                $FilesListOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "FilesList" -Force
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-GetAllFilesList -OutputFolder $FilesListOutputFolder -DriveList $DriveList
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'List All Files' option was not selected by the user")
        }
    }
    Invoke-ListAllFiles




    function Invoke-GetFileHashes {
        if ($GetFileHashes) {
            try {
                $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "HashResults" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-FileHashes -OutputFolder $HashResultsFolder -CaseFolderName $CaseFolderName -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Hash Output Files' option was not selected by the user")
        }
    }
    Invoke-GetFileHashes


    if (-not $Archive) {
        # Display message that prefetch files will not be collected
        Show-Message("[WARNING] Case archive (.zip) file will NOT be created`n") -Yellow

        # Write message that prefetch files will not be collected to the .log file
        Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The create Case Archive file option was not enabled") -WarningMessage
    }


    # Get the time the script was completed
    $EndTimeForLog = (Get-Date).ToUniversalTime()
    $DurationForLog = New-TimeSpan -Start $StartTime -End $EndTimeForLog


    # Calculate the total run time of the script and formats the results
    $DiffForLog = "$($DurationForLog.Days) days $($DurationForLog.Hours) hours $($DurationForLog.Minutes) minutes $($DurationForLog.Seconds) seconds"


    # Display a message that the script has completed and list the total time run time on the screen
    Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Script execution completed in: $DiffForLog")


    Write-LogEntry("
===========================
Hashing result files...
===========================`n") -NoTime -NoLevel


    # If the `-HashResults` switch was passed when the script was run
    if ($HashResults) {
        Get-FileHashes $CaseFolderName $ComputerName
    }


    # If the `-Archive` switch was passed when the script was run
    if ($Archive) {
        # Stop the transcript before the .zip file is made
        $StopTranscript = "`n$(Stop-Transcript)"
        Show-Message("$StopTranscript") -NoTime -Green
        Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $StopTranscript")

        # Call the function
        Get-CaseArchive
    }

    $EndTimeForShow = (Get-Date).ToUniversalTime()
    $DurationForShow = New-TimeSpan -Start $StartTime -End $EndTimeForShow
    $DiffForShow = "$($DurationForShow.Days) days $($DurationForShow.Hours) hours $($DurationForShow.Minutes) minutes $($DurationForShow.Seconds) seconds"


    Show-Message("Script execution completed in: $DiffForShow`n") -Green
    Show-Message("The results are available in the '\$(($CaseFolderName).Name)\' directory") -Green


    # Stop the transcript
    Show-Message("`n$(Stop-Transcript)") -NoTime


    # Show a popup message when script is complete
    (New-Object -ComObject Wscript.Shell).popup("The Script has finished running", 0, "Done", 0x1) | Out-Null

}  # End `Get-TriageData` function block



Export-ModuleMember -Function Export-FilesReport -Variable *
