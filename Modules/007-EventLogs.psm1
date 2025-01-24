#! ======================================
#!
#! (7) GET WINDOWS EVENT LOG INFORMATION
#!
#! ======================================


# 7-001
function Get-EventLogListBasic {
    [CmdletBinding()]
    param ([string]$Num = "7-001")

    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_ListOfEventLogs.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -ListLog * | Sort-Object -Property RecordCount -Descending
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-002
function Get-EventLogListDetailed {
    [CmdletBinding()]
    param ([string]$Num = "7-002")

    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_ListOfEventLogsDetailed.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -ListLog * | Where-Object { $_.IsEnabled -eq "True" } |
            Select-Object LogName, RecordCount, FileSize, LogMode, LogFilePath, LastWriteTime, IsEnabled |
            Sort-Object -Property RecordCount -Descending | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-003
function Get-SecurityEventCount {
    [CmdletBinding()]
    param (
        [string]$Num = "7-003",
        [int]$DaysBack = 30
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityEventCount.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog -LogName security -After $CutoffDate |
            Group-Object -Property EventID -NoElement |
            Sort-Object -Property Count -Descending
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-004
function Get-SecurityEventsLast30DaysTxt {
    [CmdletBinding()]
    param (
        [string]$Num = "7-004",
        [int]$DaysBack = 30
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityEvents.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog Security -After $CutoffDate | Format-List *
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-005
function Get-SecurityEventsLast30DaysCsv {
    [CmdletBinding()]
    param (
        [string]$Num = "7-005",
        [int]$DaysBack = 30
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityEvents.csv"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog Security -After $CutoffDate | ConvertTo-Csv -NoTypeInformation
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-006
function Get-Application1002Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-006",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_ApplicationLogId1002AppCrashes.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1002 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-007
function Get-System1014Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-007",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SystemLogId1014FailedDnsResolution.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 1014 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-008
function Get-Application1102Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-008",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_ApplicationLogId1102AuditLogCleared.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1102 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-009
function Get-Security4616Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-009",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4616ChangedSystemTime.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4616 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-010
function Get-Security4624Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-010",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4624AccountLogons.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4624 } |
            Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-011
function Get-Security4625Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-011",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4625FailedAccountLogons.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4625 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-012
function Get-Security4648Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-012",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4648LogonUsingExplicitCreds.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4648 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-013
function Get-Security4672Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-013",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4672PrivilegeUse.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4672 } |
            Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-014
function Get-Security4673Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-014",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4673PrivilegeUse.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4673 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-015
function Get-Security4674Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-015",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4674PrivilegeUse.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4674 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-016
function Get-Security4688Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-016",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4688ProcessExecution.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4688 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-017
function Get-Security4720Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-017",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SecurityLogId4720UserAccountCreated.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4720 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-018
function Get-System7036Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-018",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SystemLogId7036ServiceControlManagerEvents.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7036 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-019
function Get-System7045Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-019",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SystemLogId7045ServiceCreation.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7045 } |
            Select-Object TimeCreated, ID, Message, UserId, ProcessId, ThreadId, MachineName | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-020
function Get-System64001Events {
    [CmdletBinding()]
    param (
        [string]$Num = "7-020",
        [int]$NumberOfEntries = 50
    )
    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_SystemLogId64001WfpEvent.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 64001 } |
            Select-Object TimeCreated, ID, Message | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-021
function Get-AppInvEvts {
    [CmdletBinding()]
    param ([string]$Num = "7-021")

    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_AppInventoryEvents.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory |
            Select-Object TimeCreated, ID, Message |
            Sort-Object -Property TimeCreated -Descending | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-022
function Get-TerminalServiceEvents {
    [CmdletBinding()]
    param ([string]$Num = "7-022")

    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_TerminalServiceEvents.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational |
            Select-Object TimeCreated, ID, Message |
            Sort-Object -Property TimeCreated -Descending | Format-List
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 7-023
function Get-PSOperational4104Events {
    [CmdletBinding()]
    param ([string]$Num = "7-023")

    $File = Join-Path -Path $EventLogFolder -ChildPath "$($Num)_PSOperational4104Event.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-WinEvent -FilterHashtable @{ LogName = "Microsoft-Windows-PowerShell/Operational"; ID = 4104 } |
            Format-Table TimeCreated, Message -AutoSize
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}


Export-ModuleMember -Function Get-EventLogListBasic, Get-EventLogListDetailed, Get-SecurityEventCount, Get-SecurityEventsLast30DaysTxt, Get-SecurityEventsLast30DaysCsv, Get-Application1002Events, Get-System1014Events, Get-Application1102Events, Get-Security4616Events, Get-Security4624Events, Get-Security4625Events, Get-Security4648Events, Get-Security4672Events, Get-Security4673Events, Get-Security4674Events, Get-Security4688Events, Get-Security4720Events, Get-System7036Events, Get-System7045Events, Get-System64001Events, Get-AppInvEvts, Get-TerminalServiceEvents, Get-PSOperational4104Events