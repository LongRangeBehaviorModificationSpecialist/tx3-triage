#! ======================================
#!
#! (2) GET USER INFORMATION
#!
#! ======================================


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# 2-001
function Get-WhoAmI {
    [CmdletBinding()]
    param (
        [string]$Num = "2-001",
        [string]$FileName = "WhoAmI.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = whoami /ALL /FO LIST

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-002
function Get-UserProfile {
    [CmdletBinding()]
    param (
        [string]$Num = "2-002",
        [string]$FileName = "UserProfile.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-003
function Get-UserInfo {
    [CmdletBinding()]
    param (
        [string]$Num = "2-003",
        [string]$FileName = "UserAccounts.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-004
function Get-LocalUserData {
    [CmdletBinding()]
    param (
        [string]$Num = "2-004",
        [string]$FileName = "LocalUsers.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-LocalUser | Format-Table

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-005
function Get-LogonSession {
    [CmdletBinding()]
    param (
        [string]$Num = "2-005",
        [string]$FileName = "LogonSessions.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-006
function Get-PowershellConsoleHistoryAllUsers {
    [CmdletBinding()]
    param (
        [string]$Num = "2-006",
        [string]$FileName = "PowerShellHistory.txt",
        # Specify the directory where user profiles are stored
        [string]$UserDirs = "C:\Users"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            # Get a list of all user directories in C:\Users
            $UserDirs = Get-ChildItem -Path $UsersDir -Directory
            foreach ($UserDir in $UserDirs) {
                if ($UserDir.Count -eq 0) {
                    Write-NoDataFound $FunctionName
                }
                else {
                    $UserName = "User.$UserDir"
                    $HistoryFilePath = Join-Path -Path $UserDir.FullName -ChildPath "AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
                    $PsHistoryFileName = [System.IO.Path]::GetFileName($HistoryFilePath)
                    if (Test-Path -Path $HistoryFilePath -PathType Leaf) {
                        $OutputDir = New-Item -ItemType Directory -Path $File -Name $UserName
                        Copy-Item -Path $HistoryFilePath -Destination $OutputDir -Force
                        $File = "$(Split-Path $OutputDir -Leaf)\$PsHistoryFileName"
                        Show-OutputSavedToFile $File
                        Write-LogOutputSaved $File
                    }
                }
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 2-007
function Get-LastLogons {
    [CmdletBinding()]
    param (
        [string]$Num = "2-007",
        [string]$FileName = "LastLogons.txt"
    )

    $File = Join-Path -Path $UserFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        if (-not (Test-Path $UserFolder)) {
            throw "The user folder `"$UserFolder`" does not exist."
        }
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            $LogonEvents = Get-WinEvent -LogName 'Security' -FilterXPath "*[System[EventID=4624 or EventID=4648]]"

            $Data = @()
            foreach ($LogonEvent in $LogonEvents) {
                $Data += [PSCustomObject]@{
                    Time      = $LogonEvent.TimeCreated
                    LogonType = if ($LogonEvent.Id -eq 4648) { "Explicit" } else { "Interactive" }
                    Message   = $LogonEvent.Message
                }
            }

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-WhoAmI, Get-UserProfile, Get-UserInfo, Get-LocalUserData, Get-LogonSession, Get-PowershellConsoleHistoryAllUsers, Get-LastLogons
