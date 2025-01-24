# Date Last Updated
[String]$Dlu = "2025-01-23"


# Time the script started
[DateTime]$startTime = Get-Date


function Get-TimeStamp {
<#
.SYNOPSIS
    This function returns the current time in the format of YYYY-MM-dd HH:mm:ss
#>
    return "[{0:yyyy-MM-dd} {0:HH:mm:ss.ffff}]" -f (Get-Date)
}


# Get date and time values to use in the naming of the output directory and the output .html file
[String]$RunDate = (Get-Date).ToString("yyyyMMdd_HHmmss")


# Get the current IP addresses of the machine from on this script is run
[String]$Ipv4 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV4Address | Select-Object -ExpandProperty IPAddressToString
[String]$Ipv6 = (Test-Connection $Env:COMPUTERNAME -TimeToLive 2 -Count 1).IPV6Address | Select-Object -ExpandProperty IPAddressToString


# Getting the computer name
[String]$ComputerName = $Env:COMPUTERNAME


$Cwd = Get-Location


$CaseFolder = New-Item -ItemType Directory -Path $Cwd -Name "$($RunDate)_$($Ipv4)_$($ComputerName)" -Force


function Get-LineNum {
    return $MyInvocation.ScriptLineNumber
}


function Save-Output {
    param (
        [Parameter(Mandatory, Position = 0)]
        [Object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [String]$File
    )

    process { $Data | Out-File -FilePath $File -Encoding UTF8 }
}


function Save-OutputAppend {
    param (
        [Parameter(Mandatory ,Position = 0)]
        [Object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [String]$File
    )

    process { $Data | Out-File -Append -FilePath $File -Encoding UTF8 }
}


function Save-OutputAsCsv {
    param (
        [Parameter(Mandatory, Position = 0)]
        [Object]$Data,
        [Parameter(Mandatory, Position = 1)]
        [String]$File
    )

    process { $Data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8 }
}


function Set-CaseFolder {

    $setCaseFuncName = $MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
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
                New-Item -ItemType Directory -Path $CaseFolder -Name $Folder -Force
            }
            $global:deviceFolder = "$CaseFolder\$($Folders[0])"
            $global:userFolder = "$CaseFolder\$($Folders[1])"
            $global:networkFolder = "$CaseFolder\$($Folders[2])"
            $global:processFolder = "$CaseFolder\$($Folders[3])"
            $global:systemFolder = "$CaseFolder\$($Folders[4])"
            $global:prefetchFolder = "$CaseFolder\$($Folders[5])"
            $global:eventLogFolder = "$CaseFolder\$($Folders[6])"
            $global:firewallFolder = "$CaseFolder\$($Folders[7])"
            $global:bitlockerFolder = "$CaseFolder\$($Folders[8])"
            $global:logFolder = "$CaseFolder\$($Folders[9])"
        }
        Show-FinishMessage $setCaseFuncName $ExecutionTime
        Write-LogFinishedMessage $setCaseFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}


function Show-FinishMessage {
    param(
        [Parameter(Mandatory, Position = 0)]
        [String]$FunctionName,
        [Parameter(Mandatory, Position = 1)]
        [TimeSpan]$ExecutionTime
    )

    Show-Message("`"$($FunctionName)`" function finished in $($ExecutionTime.TotalSeconds) seconds") -Blue
}


function Show-Message {
<#
.SYNOPSIS
    Write-Host wrapper to standardize messages to the console
#>
    param(
        [Parameter(Mandatory)]
        [String]$Message,

        [Switch]$Header,
        [Switch]$NoTime,

        [Switch]$Blue,
        [Switch]$Green,
        [Switch]$White,
        [Switch]$Magenta,
        [Switch]$Red,
        [Switch]$Yellow
    )

    # Determine the color based on the switches
    $Color = if ($Blue) { "Blue" }
    elseif ($White) { "White" }
    elseif ($Green) { "Green" }
    elseif ($Magenta) { "Magenta" }
    elseif ($Red) { "Red" }
    elseif ($Yellow) { "Yellow" }
    else { "Gray" }

    # Generate timestamp if -NoTime is not provided
    $DisplayTimeStamp = if (-not $NoTime) { $(Get-TimeStamp) } else { "" }

    # If the -header switch is used, prepend a newline and header text
    $HeaderText = if ($Header) { "`n" } else { "" }

    # Format the full message
    $FormattedMessage = $HeaderText + "$DisplayTimeStamp $Message"

    # Display the message with the appropriate color
    switch ($Color) {
        "Blue" { Write-Host $FormattedMessage -ForegroundColor Blue }
        "White" { Write-Host $FormattedMessage -ForegroundColor White }
        "Green" { Write-Host $FormattedMessage -ForegroundColor DarkGreen }
        "Magenta" { Write-Host $FormattedMessage -ForegroundColor DarkMagenta }
        "Red" { Write-Host $FormattedMessage -ForegroundColor DarkRed }
        "Yellow" { Write-Host $FormattedMessage -ForegroundColor DarkYellow }
        "Gray" { Write-Host $FormattedMessage -ForegroundColor Gray }
    }
}


function Show-OutputSavedToFile {
    param(
        [Parameter(Mandatory, Position = 0)]
        [String]$File,

        [Switch]$NoTime
    )

    if ($NoTime) {
        Show-Message("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"") -NoTime -Green
    }
    else {
        Show-Message("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"") -Green
    }
}


function Write-LogMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$Message,

        [Switch]$NoLevel,
        [Switch]$DebugMessage,
        [Switch]$WarningMessage,
        [Switch]$ErrorMessage,
        [Switch]$NoTime,
        [Switch]$Header
    )

    # Set the name of the .log file
    $logFile = "$logFolder\$($RunDate)_$($Ipv4)_$($ComputerName)_Log.log"

    if (-not (Test-Path $logFolder)) {
        throw "Log folder '$logFolder' does not exist"
    }
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

    $FormattedMessage | Out-File -FilePath $logFile -Append -Encoding UTF8
}


function Write-LogFinishedMessage {
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String]$FunctionName,
        [Parameter(Mandatory = $True, Position = 1)]
        [TimeSpan]$ExecutionTime
    )

    Write-LogMessage("Function `"$FunctionName`" finished in $($ExecutionTime.TotalSeconds) seconds`n")
}


function Write-LogOutputAppended {
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String]$File
    )

    Write-LogMessage("Output appended to -> `"$([System.IO.Path]::GetFileName($File))`"")
}


function Write-LogOutputSaved {
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String]$File
    )

    Write-LogMessage("Output saved to -> `"$([System.IO.Path]::GetFileName($File))`"")
}


function Write-NoDataFound {
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String]$FunctionName
    )

    $NoDataMsg = "No data found for `"$($FunctionName)`""
    Show-Message("$NoDataMsg") -Yellow
    Write-LogMessage("$NoDataMsg")

}

# 00A
function Get-EncryptedDiskDetector {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Relative path to the Encrypted Disk Detector executable file
        [string]$EddExeFilePath = ".\bin\EDDv310.exe",

        # Name of the directory to store the results of the scan
        [string]$EddFolderName = "00A_EncryptedDiskDetector",
        # Name of the results file that will store the results of the scan
        [string]$EddResultsFileName = "EncryptedDiskDetector.txt"
    )

    $EddFuncName = $MyInvocation.MyCommand.Name

    # If the user chooses the `-Edd` switch
    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting Encrypted Disk Detector on: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($EddFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the scan results
            $EddFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $EddFolderName

            if (-not (Test-Path $EddFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$EddFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($EddFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($EddFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Name the file to save the results of the scan to
            $EddFilePath = Join-Path -Path $EddFolder -ChildPath $EddResultsFileName

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddFilePath

            # Show & log $SuccessMsg message
            $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($EddFuncName), Ln: $(Get-LineNum)] $SuccessMsg")

            # Show & log file location message
            Show-OutputSavedToFile $EddFilePath
            Write-LogOutputSaved $EddFilePath
        }
        # Show & log finish messages
        Show-FinishMessage $EddFuncName $ExecutionTime
        Write-LogFinishedMessage $EddFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00B
function Get-RunningProcesses {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Relative path to the ProcessCapture executable file
        [string]$ProcessCaptureExeFilePath = ".\bin\MagnetProcessCapture.exe",

        # Name of the directory to store the extracted process files
        [string]$ProcessesFolderName = "00B_Processes"
    )

    $ProcessFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    # If the user wants to execute the ProcessCapture
    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting Process Capture from: $ComputerName.  Please wait..."
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($ProcessFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the files list
            $ProcessesFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $ProcessesFolderName

            if (-not (Test-Path $ProcessesFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$ProcessesFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($ProcessesFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($ProcessFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Run MAGNETProcessCapture.exe from the \bin directory and save the output to the results folder.
            # The program will create its own directory to save the results with the following naming convention:
            # 'MagnetProcessCapture-YYYYMMDD-HHMMSS'
            Start-Process -NoNewWindow -FilePath $ProcessCaptureExeFilePath -ArgumentList "/saveall `"$ProcessesFolder`"" -Wait

            # Show & log $SuccessMsg message
            $SuccessMsg = "Process Capture completed successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($ProcessFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $ProcessFuncName $ExecutionTime
        Write-LogFinishedMessage $ProcessFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00C
function Get-ComputerRam {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Relative path to the RAM Capture executable file
        [string]$RamCaptureExeFilePath = ".\bin\MRCv120.exe",

        # Name of the directory to store the extracted RAM image
        [string]$RamFolderName = "00C_RAM"
    )

    $RamFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    # If the user wants to collect the RAM
    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting RAM capture from computer: $ComputerName. Please wait..."
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($RamFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Create a folder called "RAM" to store the captured RAM file
            $RamFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $RamFolderName -Force

            if (-not (Test-Path $RamFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$RamFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($RamFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($RamFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Start the RAM acquisition from the current machine
            Start-Process -NoNewWindow -FilePath $RamCaptureExeFilePath -ArgumentList "/accepteula /go /silent" -Wait
            # Once the RAM has been acquired, move the file to the 'RAM' folder
            Move-Item -Path .\bin\*.raw -Destination $RamFolder -Force

            # Show & log $SuccessMsg message
            $SuccessMsg = "RAM capture completed successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($RamFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $RamFuncName $ExecutionTime
        Write-LogFinishedMessage $RamFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00D
function Get-RegistryHives {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Name of the directory to store the copied registry hives
        [string]$RegHiveFolderName = "00D_Registry"
    )

    $RegistryFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the registry hives
            $RegHiveFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $RegHiveFolderName -Force

            if (-not (Test-Path $RegHiveFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$RegHiveFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($RegHiveFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Show & log $softwareMsg message
            try {
                $softwareMsg = "Copying the SOFTWARE Registry Hive"
                Show-Message("$softwareMsg")
                Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $softwareMsg")
                cmd /r reg export HKLM\Software $RegHiveFolder\software.reg
            }
            catch {
                Write-Error "An error occurred while copying SOFTWARE Hive: $($PSItem.Exception.Message)"
                return
            }

            # Show & log $samMsg message
            try {
                $samMsg = "Copying the SAM Registry Hive"
                Show-Message("$samMsg")
                Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $samMsg")
                cmd /r reg export HKLM\Sam $RegHiveFolder\sam.reg
            }
            catch {
                Write-Error "An error occurred while copying SAM Hive: $($PSItem.Exception.Message)"
                return
            }

            # Show & log $sysMsg message
            try {
                $sysMsg = "Copying the SYSTEM Registry Hive"
                Show-Message("$sysMsg")
                Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $sysMsg")
                cmd /r reg export HKLM\System $RegHiveFolder\system.reg
            }
            catch {
                Write-Error "An error occurred while copying SYSTEM Hive: $($PSItem.Exception.Message)"
                return
            }

            # Show & log $secMsg message
            try {
                $secMsg = "Copying the SECURITY Registry Hive"
                Show-Message("$secMsg")
                Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $secMsg")
                cmd /r reg export HKLM\Security $RegHiveFolder\security.reg
            }
            catch {
                Write-Error "An error occurred while copying SECURITY Hive: $($PSItem.Exception.Message)"
                return
            }

            # Show & log $NtMsg message
            try {
                $NtMsg = "Copying the current user's NTUSER.DAT file"
                Show-Message("$NtMsg")
                Write-LogMessage("[$($RegistryFuncName), Ln: $(Get-LineNum)] $NtMsg")
                cmd /r reg export HKCU $RegHiveFolder\current-ntuser.reg
            }
            catch {
                Write-Error "An error occurred while copying the current user's NTUSER.DAT file: $($PSItem.Exception.Message)"
                return
            }
        }
        # Show & log finish messages
        Show-FinishMessage $RegistryFuncName $ExecutionTime
        Write-LogFinishedMessage $RegistryFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00E
function Get-EventLogs {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe",

        # Name of the directory to store the copied Event Logs
        [string]$EventLogFolderName = "00E_EventLogs",

        # Set variable for Event Logs folder on the examined machine
        [string]$EventLogDir = "$Env:HOMEDRIVE\Windows\System32\winevt\Logs",
        [int]$NumberOfRecords = 5
    )

    $EventLogFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Event Logs from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($EventLogFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the Event Logs
            $EventLogFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $EventLogFolderName -Force

            if (-not (Test-Path $EventLogFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$EventLogFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($EventLogFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($EventLogFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            $Files = Get-ChildItem -Path $EventLogDir -Recurse -Force -File | Select-Object -First $NumberOfRecords

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            foreach ($File in $Files) {
                try {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$EventLogDir\$File" /OutputPath:"$EventLogFolder" /OutputName:"$File" }
                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        return
                    }
                }
                catch {
                    Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    return
                }
                # Show & log $CopyMsg messages of each file copied
                $CopyMsg = "Copied file -> `"$($File.Name)`""
                Show-Message($CopyMsg) -Magenta
                Write-LogMessage("[$($EventLogFuncName), Ln: $(Get-LineNum)] $CopyMsg")
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "Event Log files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($EventLogFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $EventLogFuncName $ExecutionTime
        Write-LogFinishedMessage $EventLogFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00F
function Get-NTUserDatFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe",

        # Name of the directory to store the copied NTUSER.DAT files
        [string]$NTUserFolderName = "00F_NTUserDATFiles",

        [string]$FilePathName = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT",
        [string]$OutputName = "$User-NTUSER.DAT"
    )

    $NTUserFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of NTUSER.DAT files from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($NTUserFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the copied .DAT files
            $NTUserFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $NTUserFolderName

            if (-not (Test-Path $NTUserFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$NTUserFolder`""
            }

            # Show & log $CreateDirMsg messages
            $CreateDirMsg = "Created `"$($NTUserFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($NTUserFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            try {
                foreach ($User in Get-ChildItem($Env:HOMEDRIVE + "\Users\")) {
                    # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                    if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {
                        # Show & log the $CopyMsg message
                        $CopyMsg = "Copying NTUSER.DAT file from the $User profile from computer: $ComputerName"
                        Show-Message("$CopyMsg") -Magenta
                        Write-LogMessage("[$($NTUserFuncName), Ln: $(Get-LineNum)] $CopyMsg")
                        $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$FilePathName" /OutputPath:"$NTuserFolder" /OutputName:"$OutputName" }
                        if ($LASTEXITCODE -ne 0) {
                            Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            return
                        }
                    }
                }
            }
            catch {
                Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                return
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "NTUSER.DAT files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($NTUserFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $NTUserFuncName $ExecutionTime
        Write-LogFinishedMessage $NTUserFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00G
function Get-PrefetchFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe",

        # Name of the directory to store the copied prefetch files
        [string]$PFFolderName = "00G_PrefetchFiles",
        # Variable for Windows Prefetch folder location
        [string]$WinPrefetchDir = "$Env:HOMEDRIVE\Windows\Prefetch",
        [int]$NumberOfRecords = 5
    )

    $PFCopyFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Prefetch files from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the prefetch files
            $PFFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $PFFolderName

            if (-not (Test-Path $NTUserFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$NTUserFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($PFFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Set variables for the files in the prefetch folder of the examined device
            $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File | Select-Object -First $NumberOfRecords

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            foreach ($File in $Files) {
                try {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$WinPrefetchDir\$File" /OutputPath:"$PFFolder" /OutputName:"$File" }
                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        return
                    }
                }
                catch {
                    Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    return
                }
                # Show & log $CopyMsg messages of each file copied
                $CopyMsg = "Copied file -> `"$($File.Name)`""
                Show-Message($CopyMsg) -Magenta
                Write-LogMessage("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $CopyMsg")
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "Prefetch files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $PFCopyFuncName $ExecutionTime
        Write-LogFinishedMessage $PFCopyFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00H
function Get-SrumDB {
<#
.SYNOPSIS
    Copies the SRUM database to the case folder
.LINK
    https://github.com/kaanyeniyol/PS-TRIAGE/blob/main/ps-triage.ps1
#>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe",

        # Name of the directory to store the copied SRUM file
        [string]$SrumFolderName = "00H_SRUM",

        [string]$FileNamePath = "$Env:windir\System32\sru\SRUDB.dat",
        [string]$OutputName = "SRUDB_$($ComputerName).dat"
    )

    $SrumFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning capture of SRUMDB.dat files from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($SrumFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the SRUM database
            $SrumFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $SrumFolderName

            if (-not (Test-Path $SrumFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$SrumFolder`""
            }

            # Show & log $CreateDirMsg messages
            $CreateDirMsg = "Created `"$($SrumFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($SrumFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            # Run the command
            try {
                $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$FileNamePath /OutputPath:"$SrumFolder" /OutputName:$OutputName }
                if ($LASTEXITCODE -ne 0) {
                    Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                    return
                }
            }
            catch {
                Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                return
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "SRUMDB.dat file copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogMessage("[$($SrumFuncName), Ln: $(Get-LineNum)] $SuccessMsg")

            # Show & log $FileSavTitle message
            $FileSavName = "Copied file saved as -> $OutputName`n"
            Show-Message("$FileSavName") -Green
            Write-LogMessage("[$SrumFuncName, Ln: $(Get-LineNum)] $FileSavName")
        }
        # Show & log finish messages
        Show-FinishMessage $SrumFuncName $ExecutionTime
        Write-LogFinishedMessage $SrumFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 00I
function Get-AllFilesList {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]$DriveList,

        # Create folder to store the compiled file lists
        [string]$FilesListFolderName = "00I_FileLists"
    )

    $AllDrivesFuncName = $MyInvocation.MyCommand.Name

    try {
        if (-not (Test-Path $CaseFolder)) {
            throw "Case folder `"$CaseFolder`" does not exist"
        }

        $ExecutionTime = Measure-Command {
            # Show & log BeginMessage message
            $BeginMessage = "Collecting list of all files from computer: $($ComputerName)"
            Show-Message("$BeginMessage") -Header
            Write-LogMessage("[$($AllDrivesFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the scan results
            $FilesListsFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $FilesListFolderName

            if (-not (Test-Path $FilesListsFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$FilesListsFolder`""
            }

            # Iterate over filtered drives
            foreach ($DriveName in $DriveList) {

                $FileListingSaveFile = "$FilesListsFolder\$RunDate`_$ComputerName`_Files_$DriveName.csv"

                $ScanMessage = "Scanning files on the $($DriveName):\ drive"
                Show-Message("$ScanMessage") -Magenta
                Write-LogMessage("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $ScanMessage")

                # Scan and save file details
                Get-ChildItem -Path "$($DriveName):\" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {
                    -not $_.PSIsContainer
                } | ForEach-Object {
                    [PSCustomObject]@{
                        Directory         = $_.DirectoryName
                        BaseName          = $_.BaseName
                        Extension         = $_.Extension
                        SizeInKB          = [math]::Round($_.Length / 1KB, 2)
                        Mode              = $_.Mode
                        Attributes        = $_.Attributes
                        CreationTimeUTC   = $_.CreationTimeUtc
                        LastAccessTimeUTC = $_.LastAccessTimeUtc
                        LastWriteTimeUTC  = $_.LastWriteTimeUtc
                    }
                } | Export-Csv -Path $FileListingSaveFile -NoTypeInformation -Append -Encoding UTF8

                # Show & log $DoneMessage message
                $DoneMessage = "Completed scanning of $($DriveName):\ drive"
                Show-Message("$DoneMessage") -Green
                Write-LogMessage("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $DoneMessage")

                # Show & log $FileTitle message
                $FileTitle = "Output saved to -> `"$([System.IO.Path]::GetFileName($FileListingSaveFile))`"`n"
                Show-Message("$FileTitle") -Green
                Write-LogMessage("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $FileTitle")
            }
        }
        # Show & log finish messages
        Show-FinishMessage $AllDrivesFuncName $ExecutionTime
        Write-LogFinishedMessage $AllDrivesFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

function Get-FileHashes {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolder,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        [string[]]$ExcludedFiles = @('*PowerShell_transcript*'),

        # Name of the directory to store the hash results .CSV file
        [string]$HashResultsFolderName = "HashResults"
    )

    $FileHashFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {

        # [string[]]$ExcludedFiles = @('*PowerShell_transcript*')

        $ExecutionTime = Measure-Command {
            # Show & log $beginMessage message
            $beginMessage = "Hashing files for computer: $ComputerName"
            Show-Message("$beginMessage") -Header
            Write-LogMessage("[$($FileHashFuncName), Ln: $(Get-LineNum)] $beginMessage")

            # Make new directory to store the prefetch files
            $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolder -Name $HashResultsFolderName

            if (-not (Test-Path $HashResultsFolder)) {
                throw "[ERROR] The necessary folder does not exist -> `"$HashResultsFolder`""
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created `"$($HashResultsFolder.Name)`" folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogMessage("[$($FileHashFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

<#
            # Set the beginning of the hash CSV filename to the same as the case directory name
            $HashOutputFilePrefix = (Get-Item -Path $CaseFolder).Name
            # Add the filename and filetype to the end
            $HashOutputFilePath = Join-Path -Path $HashResultsFolder -ChildPath "$($HashOutputFilePrefix)_HashValues.csv"
 #>

            # Add the filename and filetype to the end
            $HashOutputFilePath = Join-Path -Path $HashResultsFolder -ChildPath "$((Get-Item -Path $CaseFolder).Name)_HashValues.csv"

            # Return the full name of the CSV file
            $HashOutputFileName = [System.IO.Path]::GetFileName($HashOutputFilePath)

            # Get the hash values of all the saved files in the output directory
            $Results = @()

            # Exclude the PowerShell transcript file from being included in the file that are hashed
            $Results = Get-ChildItem -Path $CaseFolder -Recurse -Force -File | Where-Object {
                $_.Name -notlike $ExcludedFiles
                } | ForEach-Object {
                    $FileHash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
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
                Write-LogMessage("[$($FileHashFuncName), Ln: $(Get-LineNum)] $HashMsgFileName`n")
            }
            # Export the results to the CSV file
            $Results | Export-Csv -Path $HashOutputFilePath -NoTypeInformation -Encoding UTF8

            # Show & log $FileMsg message
            $FileMsg = "Hash values saved to -> `"$HashOutputFileName`""
            Show-Message("$FileMsg") -Header -Magenta
            Write-LogMessage("[$($FileHashFuncName), Ln: $(Get-LineNum)] $FileMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $FileHashFuncName $ExecutionTime
        Write-LogFinishedMessage $FileHashFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}


function Get-CaseArchive {

    [CmdletBinding()]

    $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show beginning message
            Show-Message("Creating Case Archive file -> `"$($CaseFolder.Name).zip`"") -Header
            $CaseFolderParent = Split-Path -Path $CaseFolder -Parent
            $CaseFolderName = (Get-Item -Path $CaseFolder).Name
            Compress-Archive -Path $CaseFolder -DestinationPath "$CaseFolderParent\$CaseFolderName.zip" -Force
            Show-Message("Case Archive file -> `"$($CaseFolder.Name).zip`" created successfully`n") -Magenta
        }
        # Finish logging
        Show-FinishMessage $CaseArchiveFuncName $ExecutionTime
        Write-LogFinishedMessage $CaseArchiveFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}


Export-ModuleMember -Function Set-CaseFolder, Show-Message, Show-FinishMessage, Show-OutputSavedToFile, Get-LineNum, Save-Output, Save-OutputAppend, Write-LogMessage, Write-LogFinishedMessage, Write-LogOutputAppended, Write-LogOutputSaved, Write-NoDataFound, Get-AllFilesList, Get-CaseArchive, Get-ComputerRam, Get-EncryptedDiskDetector, Get-EventLogs, Get-FileHashes, Get-NTUserDatFiles, Get-PrefetchFiles, Get-RegistryHives, Get-RunningProcesses, Get-SrumDB -Variable dlu, startTime, RunDate, ipv4, ipv6, ComputerName, caseFolder, logFile
