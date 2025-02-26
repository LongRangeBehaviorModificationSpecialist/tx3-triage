$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Write-LogEntry {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]
        $Message,
        [string]
        $LogFile = $LogFile,
        [switch]
        $NoLevel,
        [switch]
        $DebugMessage,
        [switch]
        $WarningMessage,
        [switch]
        $ErrorMessage,
        [switch]
        $NoTime
    )

    $LogFileName = "$($RunDate)_$($Ipv4)_$($ComputerName)_Log.log"

    $LogFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Logs" -Force

    $LogFile = "$LogFolder\$LogFileName"

    if (-not $Message) {
        throw "The message parameter cannot be empty."
    }

    $MsgLevel = switch ($True) {
        $DebugMessage { " [DEBUG] "; break }
        $WarningMessage { " [WARNING] "; break }
        $ErrorMessage { " [ERROR] "; break }
        default { " [INFO] " }
    }

    $MsgLevel = if (-not $NoLevel) { $MsgLevel } else { "" }

    # Generate timestamp if -NoTime is not provided
    $DisplayTimeStamp = if (-not $NoTime) { $(Get-TimeStamp) } else { "" }

    # Format the full message
    $FormattedMessage = $DisplayTimeStamp + $MsgLevel + $Message

    Add-Content -Path $LogFile -Value $FormattedMessage -Encoding UTF8
}


function Export-FilesReport {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Mandatory)]
        [string]$User,
        [Parameter(Mandatory)]
        [string]$Agency,
        [Parameter(Mandatory)]
        [string]$CaseNumber,
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [Parameter(Mandatory)]
        [string]$Ipv4,
        [Parameter(Mandatory)]
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
        [bool]$CopyPrefetch,
        [bool]$GetNTUserDat,
        [bool]$ListFiles,
        [string]$DriveList,
        [bool]$KeyWordSearch,
        [string]$KeyWordsDriveList,
        [bool]$CopySruDB,
        # [bool]$GetEventLogs,
        [bool]$GetFileHashes,
        [bool]$MakeArchive
    )


    $LogFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Logs" -Force


    # Name of the folder containing the .psm1 files that are to be imported
    $FilesModulesDirectory = "files\filesModules"


    foreach ($file in (Get-ChildItem -Path $FilesModulesDirectory -Filter *.psm1 -Force)) {
        Import-Module -Name $file.FullName -Force -Global
        # Show-Message -Message "Module file: '.\$($file.Name)' was imported successfully" -NoTime -Blue
        Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Module file '.\$($file.Name)' was imported successfully"
    }


    # Start transcript to record all of the screen output
    $TranscriptBeginMessage = "Powershell Transcript started"
    Start-Transcript -OutputDirectory $LogFolder -IncludeInvocationHeader -NoClobber
    Show-Message -Message $TranscriptBeginMessage -Blue
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $TranscriptBeginMessage" -DebugMessage


    # Write the data to the log file and display start time message on the screen
    Write-LogEntry -Message "`n-----------------------------------------------" -NoTime  -NoLevel
    Write-LogEntry -Message "    Script Log for tX3 DFIR Script Usage" -NoTime -NoLevel
    Write-LogEntry -Message "-----------------------------------------------" -NoTime -NoLevel


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
    Show-Message -Message $Banner -NoTime -Red
    Write-LogEntry -Message $Banner -NoTime -NoLevel


    $StartMessage = "$($MyInvocation.MyCommand.ModuleName) execution started"
    Show-Message -Message "[INFO] $StartMessage" -Blue
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $StartMessage"


    Show-Message -Message "

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
[G]  To exit this script at anytime, press ``Ctrl + C``.`n" -NoTime -Yellow


    Write-Host ""
    Show-Message -Message "--> Please read the instructions before executing the script! <--" -NoTime -BlueOnGray


    # Stops the script until the user presses the ENTER key so the script does not begin before the user is ready
    Read-Host -Prompt "`nPress [ENTER] to begin data collection -> "


    if (-not $User) {
        [string]$User = Read-Host -Prompt "[*] Enter user's name -> "
    }


    if (-not $Agency) {
        [string]$Agency = Read-Host -Prompt "`n[*] Enter agency name -> "
    }


    if (-not $CaseNumber) {
        [string]$CaseNumber = Read-Host -Prompt "`n[*] Enter case number -> "
    }


    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Operator Name Entered: '$User'"
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Agency Name Entered: '$Agency'"
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Case Number Entered: '$CaseNumber'"
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Computer Name: '$ComputerName'"

    # Write device IP information to the log file
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Device IPv4 address: '$Ipv4'"
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Device IPv6 address: '$Ipv6'"


    Show-Message -Message "Data acquisition started. This may take a hot minute...`n"
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Data acquisition started`n"


    # Running Encrypted Disk Detector
    function Invoke-Edd {
        if ($Edd) {
            try {
                $EddFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "EncryptedDiskDetector" -Force
                Get-EncryptedDiskDetector -CaseFolderName $CaseFolderName -ComputerName $ComputerName -EddFolder $EddFolder
                # Read the contents of the EDD text file and show the results on the screen
                Get-Content -Path "$CaseFolderName\00A_EncryptedDiskDetector\EncryptedDiskDetector.txt" -Force
                Show-Message -Message "`nEncrypted Disk Detector has finished" -NoTime -Yellow
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Run Encrypted Disk Detector' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-Edd


    function Invoke-Processes {
        if ($CaptureProcesses) {
            try {
                # Make new directory to store the process .dmp files
                $ProcessesFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Processes" -Force
                Get-RunningProcesses -CaseFolderName $CaseFolderName -ComputerName $ComputerName -ProcessesFolder $ProcessesFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Process Capture' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-Processes


    function Invoke-Ram {
        if ($GetRam) {
            try {
                # Create a folder called "RAM" to store the captured RAM file
                $RamFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "RAM" -Force
                Get-ComputerRam -CaseFolderName $CaseFolderName -ComputerName $ComputerName -RamFolder $RamFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'RAM Capture' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-Ram


    function Invoke-DeviceFilesOutput {
        if ($Device) {
            try {
                $DeviceOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "001_Device_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-DeviceFilesPage -OutputFolder $DeviceOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Device Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-DeviceFilesOutput


    function Invoke-UserFilesOutput {
        if ($UserData) {
            try {
                $UserOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "002_User_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-UserFilesPage -OutputFolder $UserOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get User Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-UserFilesOutput


    function Invoke-NetworkFilesOutput {
        if ($Network) {
            try {
                $NetworkOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "003_Network_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-NetworkFilesPage -OutputFolder $NetworkOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Network Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-NetworkFilesOutput


    function Invoke-ProcessFilesOutput {
        if ($Process) {
            try {
                $ProcessOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "004_Process_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-ProcessFilesPage -OutputFolder $ProcessOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Process Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-ProcessFilesOutput


    function Invoke-SystemFilesOutput {
        if ($System) {
            try {
                $SystemOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "005_System_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-SystemFilesPage -OutputFolder $SystemOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Prefetch Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-SystemFilesOutput


    function Invoke-PrefetchFilesOutput {
        if ($Prefetch) {
            try {
                $PrefetchOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "006_Prefetch_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-PrefetchFilesPage -OutputFolder $PrefetchOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Prefetch Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-PrefetchFilesOutput


    function Invoke-EventLogFilesOutput {
        if ($EventLogs) {
            try {
                $EventLogOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "007_EventLog_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-EventLogFilesPage -OutputFolder $EventLogOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Event Log Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-EventLogFilesOutput


    function Invoke-FirewallFilesOutput {
        if ($Firewall) {
            try {
                $FirewallOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "008_Firewall_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-FirewallFilesPage -OutputFolder $FirewallOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get Firewall Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-FirewallFilesOutput


    function Invoke-BitLockerFilesOutput {
        if ($BitLocker) {
            try {
                $BitLockerOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "009_BitLocker_Info" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Export-BitLockerFilesPage -OutputFolder $BitLockerOutputFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Get BitLocker Data' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-BitLockerFilesOutput


    function Invoke-Registry {
        if ($Hives) {
            try {
                $RegHiveFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Registry_Hives" -Force
                Get-RegistryHives -CaseFolderName $CaseFolderName -ComputerName $ComputerName -RegHiveFolder $RegHiveFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Collect Registry Hive' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-Registry


    #! NEED TO ADD OPTION TO GUI
    function Invoke-EventLogs {
        if ($GetEventLogs) {
            try {
                $EventLogFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Event_Logs" -Force
                Get-EventLogs -CaseFolderName $CaseFolderName -ComputerName $ComputerName -EventLogFolder $EventLogFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Copy Windows Event Logs' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-EventLogs


    function Invoke-Prefetch {
        if ($CopyPrefetch) {
            try {
                $PFFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Prefetch_Files" -Force
                Get-PrefetchFiles -CaseFolderName $CaseFolderName -ComputerName $ComputerName -PFFolder $PFFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Copy Prefetch Files' option was not enabled by the user" -WarningMessage
        }
    }
    Invoke-Prefetch


    function Invoke-NTUser {
        if ($GetNTUserDat) {
            try {
                $NTUserFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "NTUser_Files" -Force
                Get-NTUserDatFiles -CaseFolderName $CaseFolderName -ComputerName $ComputerName -NTUserFolder $NTUserFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Copy NTUSER.DAT files' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-NTUser


    function Invoke-SruDb {
        if ($CopySruDb) {
            try {
                $SruDbFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "SRUDB" -Force
                Get-SruDb -CaseFolderName $CaseFolderName -ComputerName $ComputerName -SruDbFolder $SruDbFolder
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Copy SRUDB.dat File' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-SruDb


    function Invoke-ListAllFiles {
        if ($ListFiles) {
            try {
                $FilesListOutputFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "FilesList" -Force
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Invoke-GetAllFilesList -OutputFolder $FilesListOutputFolder -DriveList $DriveList
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'List All Files' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-ListAllFiles


    function Invoke-GetFileHashes {
        if ($GetFileHashes) {
            try {
                $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "HashResults" -Force
                Write-LogEntry -Message "[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run"
                Get-FileHashes -OutputFolder $HashResultsFolder -CaseFolderName $CaseFolderName -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Hash Output Files' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-GetFileHashes


    function Invoke-CaseArchive {
        if ($MakeArchive) {
            try {
                # Stop the transcript before the .zip file is made
                $StopTranscript = "`n$(Stop-Transcript)"
                Show-Message -Message "$StopTranscript" -NoTime -Green
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $StopTranscript"

                # Call the function
                Get-CaseArchive
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        else {
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] The 'Save Case Archive' option was not selected by the user" -WarningMessage
        }
    }
    Invoke-CaseArchive


    # Get the time the script was completed
    $EndTimeForLog = Get-Date
    $DurationForLog = New-TimeSpan -Start $StartTime -End $EndTimeForLog


    # Calculate the total run time of the script and formats the results
    $DiffForLog = "$($DurationForLog.Days) days $($DurationForLog.Hours) hours $($DurationForLog.Minutes) minutes $($DurationForLog.Seconds) seconds"


    # Display a message that the script has completed and list the total time run time on the screen
    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Script execution completed in: $DiffForLog"


    $EndTimeForShow = Get-Date
    $DurationForShow = New-TimeSpan -Start $StartTime -End $EndTimeForShow
    $DiffForShow = "$($DurationForShow.Days) days $($DurationForShow.Hours) hours $($DurationForShow.Minutes) minutes $($DurationForShow.Seconds) seconds"


    Show-Message -Message "[INFO] Script execution completed in: $DiffForShow`n" -Header -Green
    Show-Message -Message "[INFO] The results are available in the '$CaseFolderName' directory" -Header -Green


    # Stop the transcript
    Stop-Transcript
    Show-Message -Message "Transcript ended" -Header


    # Show a popup message when script is complete
    (New-Object -ComObject Wscript.Shell).popup("The Script has finished running", 0, "Done", 0x1) | Out-Null

}


Export-ModuleMember -Function Export-FilesReport, Write-LogEntry -Variable *
