$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


# 4-001
function Get-RunningProcessesAll {

    [CmdletBinding()]

    param (
        [string]$Num = "4-001",
        [string]$FileName = "RunningProcesses.txt"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName

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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 4-002
function Get-RunningProcessesCsv {

    [CmdletBinding()]

    param (
        [string]$Num = "4-002",
        [string]$FileName = "RunningProcesses.csv"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation

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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 4-003
function Get-UniqueProcessHash {

    [CmdletBinding()]

    param (
        [string]$Num = "4-003",
        [string]$FileName = "UniqueProcessHash.csv"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = @()
            foreach ($P in (Get-WmiObject Win32_Process | Select-Object Name, ExecutablePath, CommandLine, ParentProcessId, ProcessId)) {
                $ProcessObj = New-Object PSCustomObject
                if ($Null -ne $P.ExecutablePath) {
                    $Hash = (Get-FileHash -Algorithm SHA256 -Path $P.ExecutablePath).Hash
                    $ProcessObj | Add-Member -NotePropertyName Proc_Hash -NotePropertyValue $Hash
                    $ProcessObj | Add-Member -NotePropertyName Proc_Name -NotePropertyValue $P.Name
                    $ProcessObj | Add-Member -NotePropertyName Proc_Path -NotePropertyValue $P.ExecutablePath
                    $ProcessObj | Add-Member -NotePropertyName Proc_CommandLine -NotePropertyValue $P.CommandLine
                    $ProcessObj | Add-Member -NotePropertyName Proc_ParentProcessId -NotePropertyValue $P.ParentProcessId
                    $ProcessObj | Add-Member -NotePropertyName Proc_ProcessId -NotePropertyValue $P.ProcessId
                    $Data += $ProcessObj
                }
            }

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() |
                Export-Csv -NoTypeInformation -Path  $File -Encoding UTF8
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 4-004
function Get-SvcHostsAndProcesses {

    [CmdletBinding()]

    param (
        [string]$Num = "4-004",
        [string]$FileName = "SvcHostAndProcesses.txt"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq "svchost.exe" | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path

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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 4-005
function Get-RunningServices {

    [CmdletBinding()]

    param (
        [string]$Num = "4-005",
        [string]$FileName = "RunningServices.csv"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation

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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 4-006
function Get-InstalledDrivers {

    [CmdletBinding()]

    param (
        [string]$Num = "4-006",
        [string]$FileName = "InstalledDrivers.txt"
    )

    $File = Join-Path -Path $ProcessFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = driverquery

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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-RunningProcessesAll, Get-RunningProcessesCsv, Get-UniqueProcessHash, Get-SvcHostsAndProcesses, Get-RunningServices, Get-InstalledDrivers
