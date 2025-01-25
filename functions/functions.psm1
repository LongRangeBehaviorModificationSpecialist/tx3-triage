
# Date Last Updated
[string]$Dlu = "2025-01-25"

# Time the script started
[datetime]$StartTime = Get-Date

# Get date and time values to use in the naming of the output directory and the output .html file
[string]$RunDate = (Get-Date).ToString("yyyyMMdd_HHmmss")

# Get the current IP addresses of the machine from on this script is run
[string]$Ipv4 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV4Address | Select-Object -ExpandProperty IPAddressToString
[string]$Ipv6 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV6Address | Select-Object -ExpandProperty IPAddressToString

# Getting the computer name
[string]$ComputerName = $Env:COMPUTERNAME

$Cwd = Get-Location

$CaseFolderName = New-Item -ItemType Directory -Path $($Cwd) -Name "$($RunDate)_$($Ipv4)_$($ComputerName)"

# Error messages to use in the various functions
[string]$KeyNotFoundMsg = "Cannot find the listed registry key because it does not exist."
[string]$NoMatchingEventsMsg = "No events were found that match the specified selection criteria"

# List of file types to use in some commands
$ExecutableFileTypes = @(
    "*.BAT", "*.BIN", "*.CGI", "*.CMD", "*.COM", "*.DLL",
    "*.EXE", "*.JAR", "*.JOB", "*.JSE", "*.MSI", "*.PAF",
    "*.PS1", "*.SCR", "*.SCRIPT", "*.VB", "*.VBE", "*.VBS",
    "*.VBSCRIPT", "*.WS", "*.WSF"
)

function Get-TimeStamp {
    return "[{0:yyyy-MM-dd} {0:HH:mm:ss.ffff}]" -f (Get-Date)
}

function Write-LogEntry {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]$Message,
        [string]$LogFile = $LogFile,

        [switch]$NoLevel,
        [switch]$DebugMessage,
        [switch]$WarningMessage,
        [switch]$ErrorMessage,
        [switch]$NoTime,
        [switch]$Header
    )

    $LogFile = "$LogFolder\$($RunDate)_$($Ipv4)_$($ComputerName)_Log.log"

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

    # If the -header switch is used, prepend a newline and header text
    $HeaderText = if ($Header) { "`n" } else { "" }

    # Format the full message
    $FormattedMessage = $HeaderText + $DisplayTimeStamp + $MsgLevel + $Message

    Add-Content -Path $LogFile -Value $FormattedMessage -Encoding UTF8
}

function Show-Message {

    param (
        [Parameter(Mandatory)]
        [string]$Message,

        [switch]$Header,
        [switch]$NoTime,
        [switch]$Blue,
        [switch]$Green,
        [switch]$White,
        [switch]$Magenta,
        [switch]$Red,
        [switch]$Yellow,
        [switch]$RedOnGray,
        [switch]$YellowOnRed
    )

    # Determine the color based on the switches
    $Color = if ($Blue) { "Blue" }
    elseif ($White) { "White" }
    elseif ($Green) { "Green" }
    elseif ($Magenta) { "Magenta" }
    elseif ($Red) { "Red" }
    elseif ($Yellow) { "Yellow" }
    elseif ($RedOnGray) { "RedOnGray" }
    elseif ($YellowOnRed) { "YellowOnRed" }
    else { "Gray" }

    # Generate timestamp if -NoTime is not provided
    $DisplayTimeStamp = if (-not $NoTime) { $(Get-TimeStamp) } else { $Null }

    # If the -header switch is used, prepend a newline and header text
    $HeaderText = if ($Header) { "`n" } else { $Null }

    # Format the full message
    $FormattedMessage = "$HeaderText" + "$DisplayTimeStamp $Message"

    # Display the message with the appropriate color
    switch ($Color) {
        "Blue" { Write-Host $FormattedMessage -ForegroundColor Blue }
        "White" { Write-Host $FormattedMessage -ForegroundColor White }
        "Green" { Write-Host $FormattedMessage -ForegroundColor DarkGreen }
        "Magenta" { Write-Host $FormattedMessage -ForegroundColor DarkMagenta }
        "Red" { Write-Host $FormattedMessage -ForegroundColor DarkRed }
        "Yellow" { Write-Host $FormattedMessage -ForegroundColor DarkYellow }
        "RedOnGray" { Write-Host $FormattedMessage -ForegroundColor DarkRed -BackgroundColor Gray }
        "YellowOnRed" { Write-Host $FormattedMessage -ForegroundColor DarkYellow -BackgroundColor DarkRed }
        "Gray" { Write-Host $FormattedMessage -ForegroundColor Gray }
    }
}

function Show-FinishMessage {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$FunctionName,
        [Parameter(Mandatory, Position = 1)]
        [timespan]$ExecutionTime,

        [switch]$Header
    )

    if ($Header) {
        Show-Message("`"$($FunctionName)`" function finished in $($ExecutionTime.TotalSeconds) seconds") -Header -Blue
    }
    else {
        Show-Message("`"$($FunctionName)`" function finished in $($ExecutionTime.TotalSeconds) seconds") -Blue
    }
}

function Write-LogFinishedMessage {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FunctionName,
        [Parameter(Mandatory = $True, Position = 1)]
        [timespan]$ExecutionTime
    )

    Write-LogEntry("Function `"$FunctionName`" finished in $($ExecutionTime.TotalSeconds) seconds`n")
}

$Folders = @(
    "001_DeviceInfo",
    "002_UserInfo",
    "003_Network",
    "004_Processes",
    "005_System",
    "006_Prefetch",
    "007_EventLogFiles",
    "008_Firewall",
    "009_BitLocker",
    "Logs"
)

foreach ($Folder in $Folders) {
    New-Item -ItemType Directory -Path $CaseFolderName -Name $Folder -Force | Out-Null
    Write-Host "Created ``$($Folder)`` Folder" -ForegroundColor Green
}

$global:DeviceFolder = "$CaseFolderName\$($Folders[0])"
$global:UserFolder = "$CaseFolderName\$($Folders[1])"
$global:NetworkFolder = "$CaseFolderName\$($Folders[2])"
$global:ProcessFolder = "$CaseFolderName\$($Folders[3])"
$global:SystemFolder = "$CaseFolderName\$($Folders[4])"
$global:PrefetchFolder = "$CaseFolderName\$($Folders[5])"
$global:EventLogFolder = "$CaseFolderName\$($Folders[6])"
$global:FirewallFolder = "$CaseFolderName\$($Folders[7])"
$global:BitlockerFolder = "$CaseFolderName\$($Folders[8])"
$global:LogFolder = "$CaseFolderName\$($Folders[9])"

function Get-LineNum {
    return $MyInvocation.ScriptLineNumber
}

function Save-Output {

    param (
        [Parameter(Mandatory, Position = 0)]
        [object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [string]$File
    )

    process { $Data | Out-File -FilePath $File -Encoding UTF8 }
}

function Save-OutputAppend {

    param (
        [Parameter(Mandatory ,Position = 0)]
        [object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [string]$File
    )

    process { $Data | Out-File -Append -FilePath $File -Encoding UTF8 }
}

function Save-OutputAsCsv {

    param (
        [Parameter(Mandatory, Position = 0)]
        [object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [string]$File
    )

    process { $Data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8 }
}

function Show-OutputSavedToFile {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$File,

        [switch]$NoTime
    )

    if ($NoTime) {
        Show-Message("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"") -NoTime -Green
    }
    else {
        Show-Message("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"") -Green
    }
}

function Write-LogOutputAppended {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$File
    )

    Write-LogEntry("Output appended to -> `"$([System.IO.Path]::GetFileName($File))`"")
}

function Write-LogOutputSaved {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$File
    )

    Write-LogEntry("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"")
}

function Write-NoDataFound {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FunctionName
    )

    $NoDataMsg = "No data found for `"$($FunctionName)`" function"
    Show-Message("$NoDataMsg") -Yellow
    Write-LogEntry("$NoDataMsg")
}

function Get-FileHashes {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [string[]]$ExcludedFiles = @('*PowerShell_transcript*'),
        # Name of the directory to store the hash results .CSV file
        [string]$HashResultsFolderName = "HashResults"
    )

    $FileHashFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $beginMessage message
            $beginMessage = "Hashing files for computer: $ComputerName"
            Show-Message("$beginMessage") -Header
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $beginMessage")

            # Make new directory to store the prefetch files
            $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $HashResultsFolderName

            if (-not (Test-Path $HashResultsFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$HashResultsFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($HashResultsFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Add the filename and filetype to the end
            $HashOutputFilePath = Join-Path -Path $HashResultsFolder -ChildPath "$((Get-Item -Path $CaseFolderName).Name)_HashValues.csv"

            # Return the full name of the CSV file
            $HashOutputFileName = [System.IO.Path]::GetFileName($HashOutputFilePath)

            # Get the hash values of all the saved files in the output directory
            $Results = @()

            # Exclude the PowerShell transcript file from being included in the file that are hashed
            $Results = Get-ChildItem -Path $CaseFolderName -Recurse -Force -File | Where-Object { $_.Name -notlike $ExcludedFiles } | ForEach-Object { $FileHash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
                [PSCustomObject]@{
                    DirectoryName      = $_.DirectoryName
                    BaseName           = $_.BaseName
                    Extension          = $_.Extension
                    PSIsContainer      = $_.PSIsContainer
                    SizeInKB           = [math]::Round(($_.Length / 1KB), 2)
                    Mode               = $_.Mode
                    "FileHash(Sha256)" = $FileHash
                    Attributes         = $_.Attributes
                    IsReadOnly         = $_.IsReadOnly
                    CreationTimeUTC    = $_.CreationTimeUtc
                    LastAccessTimeUTC  = $_.LastAccessTimeUtc
                    LastWriteTimeUTC   = $_.LastWriteTimeUtc
                }

                # Show & log $ProgressMsg message
                $ProgressMsg = "Hashing file: $($_.Name)"
                Show-Message("$ProgressMsg") -Header

                # Show & log $HashMsgFileName and hashMsgHashValue messages for each file
                $HashMsgFileName = "Completed hashing file: `"$($_.Name)`" -> [SHA256] $($FileHash)"
                Show-Message("$HashMsgFileName") -Blue
                Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $HashMsgFileName`n")
            }

            # Export the results to the CSV file
            $Results | Export-Csv -Path $HashOutputFilePath -NoTypeInformation -Encoding UTF8

            # Show & log $FileMsg message
            $FileMsg = "Hash values saved to -> `"$HashOutputFileName`""
            Show-Message("$FileMsg") -Header -Blue
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $FileMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $FileHashFuncName $ExecutionTime
        Write-LogFinishedMessage $FileHashFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

Export-ModuleMember -Function Set-CaseFolders, Show-Message, Show-FinishMessage, Show-OutputSavedToFile, Get-LineNum, Save-Output, Save-OutputAppend, Write-LogEntry, Write-LogFinishedMessage, Write-LogOutputAppended, Write-LogOutputSaved, Write-NoDataFound, Get-EncryptedDiskDetector, Get-FileHashes -Variable Dlu, StartTime, RunDate, Ipv4, Ipv6, ComputerName, CaseFolderName, LogFile, NoMatchingEventsMsg, ExecutableFileTypes, DeviceFolder, UserFolder, NetworkFolder, ProcessFolder, SystemFolder, PrefetchFolder, EventLogFolder, FirewallFolder, BitLockerFolder, LogFolder
