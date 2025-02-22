$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Export-UserFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 2-001
    function Get-WhoAmI {

        param (
            [string]
            $Num = "2-001",
            [string]
            $FileName = "WhoAmI.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = whoami /ALL /FO LIST

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-002
    function Get-UserProfile {

        param (
            [string]
            $Num = "2-002",
            [string]
            $FileName = "UserProfile.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-003
    function Get-UserInfo {

        param (
            [string]
            $Num = "2-003",
            [string]
            $FileName = "UserAccounts.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-004
    function Get-LocalUserData {

        param (
            [string]
            $Num = "2-004",
            [string]
            $FileName = "LocalUsers.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-LocalUser | Format-Table

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-005
    function Get-LogonSession {

        param (
            [string]
            $Num = "2-005",
            [string]
            $FileName = "LogonSessions.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-006
    function Get-PowershellConsoleHistoryAllUsers {

        param (
            [string]
            $Num = "2-006",
            [string]
            $FileName = "PowerShellHistory.txt",
            # Specify the directory where user profiles are stored
            [string]
            $UserPath = "C:\Users"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                # Get a list of all user directories in C:\Users
                $UserDirs = Get-ChildItem -Path $UserPath -Directory

                foreach ($UserDir in $UserDirs) {
                    if ($UserDir.Count -eq 0) {
                        Write-NoDataFound $($MyInvocation.MyCommand.Name)
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
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 2-007
    function Get-LastLogons {

        param (
            [string]
            $Num = "2-007",
            [string]
            $FileName = "LastLogons.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            if (-not (Test-Path $OutputFolder)) {
                throw "The user folder '$OutputFolder' does not exist."
            }

            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header
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
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-WhoAmI
    Get-UserProfile
    Get-UserInfo
    Get-LocalUserData
    Get-LogonSession
    Get-PowershellConsoleHistoryAllUsers
    Get-LastLogons
}


Export-ModuleMember -Function Export-UserFilesPage
