# Date Last Updated
[string]$Dlu = "2025-02-03"


# [datetime]$StartTime = (Get-Date).ToUniversalTime()
[datetime]$StartTime = Get-Date
[string]$Date = ($StartTime).ToString("MM-dd-yyyy")
[string]$Time = ($StartTime).ToString("HH:mm:ss")
[string]$RunDate = ($StartTime).ToString("yyyyMMdd_HHmmss")


# Get the current IP addresses of the machine from on this script is run
[string]$Ipv4 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV4Address | Select-Object -ExpandProperty IPAddressToString
[string]$Ipv6 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV6Address | Select-Object -ExpandProperty IPAddressToString


# Getting the computer name
[string]$ComputerName = $Env:COMPUTERNAME


$Cwd = Get-Location


$CaseFolderName = New-Item -ItemType Directory -Path $($Cwd) -Name "$($RunDate)_$($Ipv4)_$($ComputerName)"
# $CaseFolderName = New-Item -ItemType Directory -Path "$([Environment]::GetFolderPath('Desktop'))\tempTest" -Name "$($RunDate)_$($Ipv4)_$($ComputerName)"


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
    return Get-Date -Format "[yyyy-MM-dd HH:mm:ss.ffff K]"
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
        [switch]$NoTime
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

    # Format the full message
    $FormattedMessage = $DisplayTimeStamp + $MsgLevel + $Message

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
        [switch]$Magenta,
        [switch]$Red,
        [switch]$Yellow,
        [switch]$DarkGray,
        [switch]$BlueOnGray,
        [switch]$YellowOnRed
    )

    # Determine the color based on the switches
    $Color = if ($Blue) { "Blue" }
    elseif ($White) { "White" }
    elseif ($Green) { "Green" }
    elseif ($Magenta) { "Magenta" }
    elseif ($Red) { "Red" }
    elseif ($Yellow) { "Yellow" }
    elseif ($DarkGray) { "DarkGray" }
    elseif ($BlueOnGray) { "BlueOnGray" }
    elseif ($YellowOnRed) { "YellowOnRed" }
    else { "White" }

    # Generate timestamp if -NoTime is not provided
    $DisplayTimeStamp = if (-not $NoTime) { $(Get-TimeStamp) } else { "" }

    $HeaderText = if ($Header) { "`n" } else { "" }

    # Format the full message
    $FormattedMessage = "$HeaderText$DisplayTimeStamp $Message"

    # Display the message with the appropriate color
    switch ($Color) {
        "Blue" { Write-Host $FormattedMessage -ForegroundColor Blue }
        "DarkGray" { Write-Host $FormattedMessage -ForegroundColor DarkGray }
        "Green" { Write-Host $FormattedMessage -ForegroundColor DarkGreen }
        "Magenta" { Write-Host $FormattedMessage -ForegroundColor DarkMagenta }
        "Red" { Write-Host $FormattedMessage -ForegroundColor DarkRed }
        "White" { Write-Host $FormattedMessage -ForegroundColor White }
        "Yellow" { Write-Host $FormattedMessage -ForegroundColor DarkYellow }

        "BlueOnGray" { Write-Host $FormattedMessage -ForegroundColor Blue -BackgroundColor Gray }
        "YellowOnRed" { Write-Host $FormattedMessage -ForegroundColor DarkYellow -BackgroundColor DarkRed }
    }
}


function Show-FinishMessage {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$FunctionName,
        [Parameter(Mandatory, Position = 1)]
        [timespan]$ExecutionTime
    )

        Show-Message("'$($FunctionName)' function finished in $($ExecutionTime.TotalSeconds) seconds`n") -Blue
}


function Write-LogFinishedMessage {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FunctionName,
        [Parameter(Mandatory = $True, Position = 1)]
        [timespan]$ExecutionTime
    )

    Write-LogEntry("Function '$FunctionName' finished in $($ExecutionTime.TotalSeconds) seconds`n")
}


function Set-CaseFolders {

    $Folders = @(
        "000_Testing",
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
        Write-Host "Created '$($Folder)' Folder" -ForegroundColor Green
    }


    $global:TestingFolder = "$CaseFolderName\$($Folders[0])"
    $global:DeviceFolder = "$CaseFolderName\$($Folders[1])"
    $global:UserFolder = "$CaseFolderName\$($Folders[2])"
    $global:NetworkFolder = "$CaseFolderName\$($Folders[3])"
    $global:ProcessFolder = "$CaseFolderName\$($Folders[4])"
    $global:SystemFolder = "$CaseFolderName\$($Folders[5])"
    $global:PrefetchFolder = "$CaseFolderName\$($Folders[6])"
    $global:EventLogFolder = "$CaseFolderName\$($Folders[7])"
    $global:FirewallFolder = "$CaseFolderName\$($Folders[8])"
    $global:BitlockerFolder = "$CaseFolderName\$($Folders[8])"
    $global:LogFolder = "$CaseFolderName\$($Folders[10])"
}


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
        Show-Message("Output saved to -> '$([System.IO.Path]::GetFileName($File))'") -NoTime -Green
    }
    else {
        Show-Message("Output saved to -> '$([System.IO.Path]::GetFileName($File))'") -Green
    }
}


function Write-LogOutputAppended {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$File
    )

    Write-LogEntry("Output appended to -> '$([System.IO.Path]::GetFileName($File))'")
}


function Write-LogOutputSaved {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$File
    )

    Write-LogEntry("Output saved to -> '$([System.IO.Path]::GetFileName($File))'")
}


function Write-NoDataFound {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FunctionName
    )

    $NoDataMsg = "No data found for '$($FunctionName)' function"
    Show-Message("$NoDataMsg") -Yellow
    Write-LogEntry("$NoDataMsg")
}


Export-ModuleMember -Function Get-TimeStamp, Write-LogEntry, Show-Message, Show-FinishMessage, Write-LogFinishedMessage, Set-CaseFolders, Get-LineNum, Save-Output, Save-OutputAppend, Save-OutputAsCsv, Show-OutputSavedToFile, Write-LogOutputAppended, Write-LogOutputSaved, Write-NoDataFound -Variable Dlu, StartTime, Date, Time, RunDate, Ipv4, Ipv6, ComputerName, Cwd, CaseFolderName, KeyNotFoundMsg, NoMatchingEventsMsg, ExecutableFileTypes
