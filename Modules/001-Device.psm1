#! ======================================
#!
#! (1) GET DEVICE INFORMATION
#!
#! ======================================


# 1-000A
function Get-VariousData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-000A"
    )

    # if (-not $DeviceFolder) {
    #     Write-Error-Error "Global variable 'DeviceFolder' is not set."
    # }

    $File = "$DeviceFolder\$($Num)_VariousData.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-000B
function Get-TPMData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-000B"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_TPMDetails.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-001
function Get-PSInfo {
    [CmdletBinding()]
    param (
        [string]$Num = "1-001"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_PSInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Measure the time it takes to run the PsInfo command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-002
function Get-PSDriveData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-002"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_PSDriveInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-003
function Get-LogicalDiskData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-003"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_LogicalDisks.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-004
function Get-ComputerData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-004"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_ComputerInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-005A
function Get-SystemDataCMD {
    [CmdletBinding()]
    param (
        [string]$Num = "1-005A"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_SystemInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-005B
function Get-SystemDataPS {
    [CmdletBinding()]
    param (
        [string]$Num = "1-005B"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_ComputerSystem.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-006
function Get-OperatingSystemData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-006"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_OSInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the first command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-007
function Get-PhysicalMemory {
    [CmdletBinding()]
    param (
        [string]$Num = "1-007"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_PhysicalMemory.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-008
function Get-EnvVars {
    [CmdletBinding()]
    param (
        [string]$Num = "1-008"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_EnvVars.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-009
function Get-PhysicalDiskData {
    [CmdletBinding()]
    param (
        [string]$Num = "1-009"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_PhysicalDisks.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-010A
function Get-DiskPartitions {
    [CmdletBinding()]
    param (
        [string]$Num = "1-010A"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_DiskPartitions.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-010B
function Get-Win32DiskParts {
    [CmdletBinding()]
    param (
        [string]$Num = "1-010B"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_Win32DiskPartitions.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-011A
function Get-Win32StartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-011A"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_Win32StartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-011B
function Get-HKLMSoftwareCVRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-011B"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKLMSoftwareCVRunStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run |
            Select-Object * -ExcludeProperty PS*
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

# 1-011C
function Get-HKLMSoftwareCVPoliciesExpRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-011C"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKLMSoftwareCVPoliciesExpRunStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        #Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run |
            Select-Object * -ExcludeProperty PS*
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

# 1-011D
function Get-HKLMSoftwareCVRunOnceStartupApps {
    [CmdletBinding()]
    param ([string]$Num = "1-011D")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKLMSoftwareCVRunOnceStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce |
            Select-Object * -ExcludeProperty PS*
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

# 1-011E
function Get-HKCUSoftwareCVRunStartupApps {
    [CmdletBinding()]
    param (
        [string]$Num = "1-011E"
    )

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKCUSoftwareCVRunStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Select-Object * -ExcludeProperty PS*
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

# 1-011F
function Get-HKCUSoftwareCVPoliciesExpRunStartupApps {
    [CmdletBinding()]
    param ([string]$Num = "1-011F")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKCUSoftwareCVPoliciesExpRunStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run | Select-Object * -ExcludeProperty PS*
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

# 1-011G
function Get-HKCUSoftwareCVRunOnceStartupApps {
    [CmdletBinding()]
    param ([string]$Num = "1-011G")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_HKCUSoftwareCVRunOnceStartupApps.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce | Select-Object * -ExcludeProperty PS*
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

# 1-012
function Get-SoftwareLicenseData {
    [CmdletBinding()]
    param ([string]$Num = "1-012")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_SoftwareLicense.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-013
function Get-AutoRunsData {
    [CmdletBinding()]
    param ([string]$Num = "1-013")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_AutoRuns.csv"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-014
function Get-BiosData {
    [CmdletBinding()]
    param ([string]$Num = "1-014")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_BiosInfo.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-015
function Get-ConnectedDevices {
    [CmdletBinding()]
    param ([string]$Num = "1-015")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_ConnectedDevices.csv"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-PnpDevice
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-OutputAsCsv $Data $File
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

# 1-016
function Get-HardwareInfo {
    [CmdletBinding()]
    param ([string]$Num = "1-016")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_Hardware.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-017
function Get-Win32Products {
    <#
.SYNOPSIS
    `Get-Win32Products` returns data about products that were installed via the Windows installer.
#>
    [CmdletBinding()]
    param ([string]$Num = "1-017")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_Win32Products.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}

# 1-018
function Get-OpenWindowTitles {
    <#
    .SYNOPSIS
    `Get-OpenWindowTitles` queries all main window titles and lists them as a table.
#>
    [CmdletBinding()]
    param ([string]$Num = "1-018")

    $File = Join-Path -Path $DeviceFolder -ChildPath "$($Num)_OpenWindowTitles.txt"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogMessage("[$($ScriptName), Ln: $(Get-LineNum)] $Header")
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
        Write-LogMessage("$ErrorMessage") -ErrorMessage
        throw $PSItem
    }
}


Export-ModuleMember -Function Get-VariousData, Get-TPMData, Get-PSInfo, Get-PSDriveData, Get-LogicalDiskData, Get-ComputerData, Get-SystemDataCMD, Get-SystemDataPS, Get-OperatingSystemData, Get-PhysicalMemory, Get-EnvVars, Get-PhysicalDiskData, Get-DiskPartitions, Get-Win32DiskParts, Get-Win32StartupApps, Get-HKLMSoftwareCVRunStartupApps, Get-HKLMSoftwareCVPoliciesExpRunStartupApps, Get-HKLMSoftwareCVRunOnceStartupApps, Get-HKCUSoftwareCVRunStartupApps, Get-HKCUSoftwareCVPoliciesExpRunStartupApps, Get-HKCUSoftwareCVRunOnceStartupApps, Get-SoftwareLicenseData, Get-AutoRunsData, Get-BiosData, Get-ConnectedDevices, Get-HardwareInfo, Get-Win32Products, Get-OpenWindowTitles