#! ======================================
#!
#! (1) GET DEVICE INFORMATION
#!
#! ======================================

$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf

# $DeviceFolder = "$CaseFolderName\001_DeviceInfo"

# 1-001
function Get-VariousData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-001",
        [string]$FileName = "VariousData.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-ComputerDetails

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

# 1-002
function Get-TPMData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-002",
        [string]$FileName = "TPMDetails.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-TPMDetails

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

# 1-003
function Get-PSInfo {
    [CmdletBinding()]
    param (
        [string]$Num = "1-003",
        [string]$FileName = "PSInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Measure the time it takes to run the PsInfo command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            # Run the PsInfo command
            $Data = .\bin\PsInfo.exe -accepteula -s -h -d

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

# 1-004
function Get-PSDriveData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-004",
        [string]$FileName = "PSDriveInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-PSDrive -PSProvider FileSystem | Select-Object -Property *

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

# 1-005
function Get-LogicalDiskData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-005",
        [string]$FileName = "LogicalDisks.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property *

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

# 1-006
function Get-ComputerData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-006",
        [string]$FileName = "ComputerInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-ComputerInfo

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

# 1-007
function Get-SystemDataCMD {
    [CmdletBinding()]
    param (
        [string]$Num = "1-007",
        [string]$FileName = "SystemInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = systeminfo /FO LIST

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

# 1-008
function Get-SystemDataPS {
    [CmdletBinding()]
    param (
        [string]$Num = "1-008",
        [string]$FileName = "ComputerSystem.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *

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

# 1-009
function Get-OperatingSystemData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-009",
        [string]$FileName = "OSInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the first command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *

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

# 1-010
function Get-PhysicalMemory {
    [CmdletBinding()]
    param (
        [string]$Num = "1-010",
        [string]$FileName = "PhysicalMemory.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property *

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

# 1-011
function Get-EnvVars {
    [CmdletBinding()]
    param (
        [string]$Num = "1-011",
        [string]$FileName = "EnvVars.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-ChildItem -Path env: | Format-List

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

# 1-012
function Get-PhysicalDiskData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-012",
        [string]$FileName = "PhysicalDisks.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Disk | Select-Object -Property * | Sort-Object DiskNumber

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

# 1-013
function Get-DiskPartitions {
    [CmdletBinding()]
    param (
        [string]$Num = "1-013",
        [string]$FileName = "DiskPartitions.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber

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

# 1-014
function Get-Win32DiskParts {
    [CmdletBinding()]
    param (
        [string]$Num = "1-014",
        [string]$FileName = "Win32DiskPartitions.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name | Format-List

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

# 1-015
function Get-Win32StartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-015",
        [string]$FileName = "Win32StartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property *

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

# 1-016
function Get-HKLMSoftwareCVRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-016",
        [string]$FileName = "HKLMSoftwareCVRunStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-017
function Get-HKLMSoftwareCVPoliciesExpRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-017",
        [string]$FileName = "HKLMSoftwareCVPoliciesExpRunStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        #Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-018
function Get-HKLMSoftwareCVRunOnceStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-018",
        [string]$FileName = "HKLMSoftwareCVRunOnceStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-019
function Get-HKCUSoftwareCVRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-019",
        [string]$FileName = "HKCUSoftwareCVRunStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-020
function Get-HKCUSoftwareCVPoliciesExpRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-020",
        [string]$FileName = "HKCUSoftwareCVPoliciesExpRunStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-021
function Get-HKCUSoftwareCVRunOnceStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-021",
        [string]$FileName = "HKCUSoftwareCVRunOnceStartupApps.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            try {

                $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce | Select-Object * -ExcludeProperty PS*

            }
            catch [PathNotFound] {
                Show-Message("$KeyNotFoundMsg") -Red
                Write-LogEntry("$KeyNotFoundMsg") -WarningMessage
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 1-022
function Get-SoftwareLicenseData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-022",
        [string]$FileName = "SoftwareLicense.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-WmiObject -ClassName SoftwareLicensingService

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

# 1-023
function Get-AutoRunsData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-023",
        [string]$FileName = "AutoRuns.csv"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = .\bin\autorunsc64.exe -a * -c -nobanner

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

# 1-024
function Get-BiosData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-024",
        [string]$FileName = "BiosInfo.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *

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

# 1-025
function Get-ConnectedDevices {
    [CmdletBinding()]
    param (
        [string]$Num = "1-025",
        [string]$FileName = "ConnectedDevices.csv"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-PnpDevice

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                $Data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
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

# 1-026
function Get-HardwareInfo {
    [CmdletBinding()]
    param (
        [string]$Num = "1-026",
        [string]$FileName = "Hardware.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance Win32_PnPEntity

            foreach ($Item in $Data) {
                $Item | Add-Member -MemberType NoteProperty -Name "Host" -Value $Env:COMPUTERNAME
                $Item | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
            }
            $Data | Select-Object Host, DateScanned, PnPClass, Caption, Description, DeviceID | Out-String
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

# 1-027
function Get-Win32Products {
<#
.SYNOPSIS
    `Get-Win32Products` returns data about products that were installed via the Windows installer.
#>
    [CmdletBinding()]
    param (
        [string]$Num = "1-027",
        [string]$FileName = "Win32Products.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-WmiObject Win32_Product

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

# 1-028
function Get-OpenWindowTitles {
<#
.SYNOPSIS
    `Get-OpenWindowTitles` queries all main window titles and lists them as a table.
#>
    [CmdletBinding()]
    param (
        [string]$Num = "1-028",
        [string]$FileName = "OpenWindowTitles.txt"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Format-Table ID, ProcessName, MainWindowTitle -AutoSize

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


Export-ModuleMember -Function Get-VariousData, Get-TPMData, Get-PSInfo, Get-PSDriveData, Get-LogicalDiskData, Get-ComputerData, Get-SystemDataCMD, Get-SystemDataPS, Get-OperatingSystemData, Get-PhysicalMemory, Get-EnvVars, Get-PhysicalDiskData, Get-DiskPartitions, Get-Win32DiskParts, Get-Win32StartupApps, Get-HKLMSoftwareCVRunStartupApps, Get-HKLMSoftwareCVPoliciesExpRunStartupApps, Get-HKLMSoftwareCVRunOnceStartupApps, Get-HKCUSoftwareCVRunStartupApps, Get-HKCUSoftwareCVPoliciesExpRunStartupApps, Get-HKCUSoftwareCVRunOnceStartupApps, Get-SoftwareLicenseData, Get-AutoRunsData, Get-BiosData, Get-ConnectedDevices, Get-HardwareInfo, Get-Win32Products, Get-OpenWindowTitles
