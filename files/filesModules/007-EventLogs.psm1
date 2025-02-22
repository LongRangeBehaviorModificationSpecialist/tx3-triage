$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-EventLogFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 7-001
    function Get-EventLogListBasic {

        param (
            [string]
            $Num = "7-001",
            [string]
            $FileName = "ListOfEventLogs.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-WinEvent -ListLog * | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount | Format-List

                if (-not $Data) {
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

    # 7-002
    function Get-EventLogListDetailed {

        param (
            [string]
            $Num = "7-002",
            [string]
            $FileName = "ListOfEventLogsDetailed.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-WinEvent -ListLog * | Where-Object { $_.IsEnabled -eq "True" } | Select-Object LogName, RecordCount, FileSize, LogMode, LogFilePath, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending | Format-List

                if (-not $Data) {
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

    # 7-003
    function Get-SecurityEventCount {

        param (
            [string]
            $Num = "7-003",
            [string]
            $FileName = "SecurityEventCount.txt",
            [int]
            $DaysBack = 30
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $CutoffDate = (Get-Date).AddDays(-$DaysBack)
                $Data = Get-EventLog -LogName security -After $CutoffDate | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending

                if (-not $Data) {
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

    # 7-004
    function Get-SecurityEventsLast30DaysTxt {

        param (
            [string]
            $Num = "7-004",
            [string]
            $FileName = "SecurityEvents.txt",
            [int]
            $DaysBack = 30
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $CutoffDate = (Get-Date).AddDays(-$DaysBack)
                $Data = Get-EventLog Security -After $CutoffDate | Format-List *

                if (-not $Data) {
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

    # 7-005
    function Get-SecurityEventsLast30DaysCsv {

        param (
            [string]
            $Num = "7-005",
            [string]
            $FileName = "SecurityEvents.csv",
            [int]
            $DaysBack = 30
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $CutoffDate = (Get-Date).AddDays(-$DaysBack)
                $Data = Get-EventLog Security -After $CutoffDate | ConvertTo-Csv -NoTypeInformation

                if (-not $Data) {
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

    # 7-006
    function Get-Application1002Events {

        param (
            [string]
            $Num = "7-006",
            [string]
            $FileName = "ApplicationLogId1002AppCrashes.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {

                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1002 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-007
    function Get-System1014Events {

        param (
            [string]$Num = "7-007",
            [string]$FileName = "SystemLogId1014FailedDnsResolution.txt",
            [int]$NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 1014 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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
            throw $PSItem
        }
    }

    # 7-008
    function Get-Application1102Events {

        param (
            [string]
            $Num = "7-008",
            [string]
            $FileName = "ApplicationLogId1102AuditLogCleared.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1102 } |Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
                    Write-NoDataFound -FunctionName $($MyInvocation.MyCommand.Name)
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

    # 7-009
    function Get-Security4616Events {

        param (
            [string]
            $Num = "7-009",
            [string]
            $FileName = "SecurityLogId4616ChangedSystemTime.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4616 } |Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-010
    function Get-Security4624Events {

        param (
            [string]
            $Num = "7-010",
            [string]
            $FileName = "SecurityLogId4624AccountLogons.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4624 } | Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-011
    function Get-Security4625Events {

        param (
            [string]
            $Num = "7-011",
            [string]
            $FileName = "SecurityLogId4625FailedAccountLogons.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4625 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-012
    function Get-Security4648Events {

        [CmdletBinding()]

        param (
            [string]
            $Num = "7-012",
            [string]
            $FileName = "SecurityLogId4648LogonUsingExplicitCreds.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4648 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-013
    function Get-Security4672Events {

        param (
            [string]
            $Num = "7-013",
            [string]
            $FileName = "SecurityLogId4672PrivilegeUse.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4672 } | Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-014
    function Get-Security4673Events {

        param (
            [string]
            $Num = "7-014",
            [string]
            $FileName = "SecurityLogId4673PrivilegeUse.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4673 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-015
    function Get-Security4674Events {

        param (
            [string]
            $Num = "7-015",
            [string]
            $FileName = "SecurityLogId4674PrivilegeUse.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4674 } |Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-016
    function Get-Security4688Events {

        param (
            [string]
            $Num = "7-016",
            [string]
            $FileName = "SecurityLogId4688ProcessExecution.txt",
            [int]
            $NumberOfEntries = 50
        )
        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4688 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-017
    function Get-Security4720Events {

        param (
            [string]
            $Num = "7-017",
            [string]
            $FileName = "SecurityLogId4720UserAccountCreated.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4720 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-018
    function Get-System7036Events {

        param (
            [string]
            $Num = "7-018",
            [string]
            $FileName = "SystemLogId7036ServiceControlManagerEvents.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7036 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-019
    function Get-System7045Events {

        param (
            [string]
            $Num = "7-019",
            [string]
            $FileName = "SystemLogId7045ServiceCreation.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7045 } | Select-Object TimeCreated, ID, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-020
    function Get-System64001Events {

        param (
            [string]
            $Num = "7-020",
            [string]
            $FileName = "SystemLogId64001WfpEvent.txt",
            [int]
            $NumberOfEntries = 50
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 64001 } | Select-Object TimeCreated, ID, Message | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-021
    function Get-AppInvEvts {

        param (
            [string]
            $Num = "7-021",
            [string]
            $FileName = "AppInventoryEvents.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-022
    function Get-TerminalServiceEvents {

        param (
            [string]
            $Num = "7-022",
            [string]
            $FileName = "TerminalServiceEvents.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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

    # 7-023
    function Get-PSOperational4104Events {

        param (
            [string]
            $Num = "7-023",
            [string]
            $FileName = "PSOperational4104Event.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-WinEvent -FilterHashtable @{ LogName = "Microsoft-Windows-PowerShell/Operational"; ID = 4104 } | Format-Table TimeCreated, Message -AutoSize
                }
                catch [System.Exception] {
                    Show-Message("$NoMatchingEventsMsg") -Yellow
                    Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
                }

                if (-not $Data) {
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
}


Export-ModuleMember -Function Export-EventLogFilesPage
