$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Export-DeviceFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 1-001
    function Get-VariousData {

        param (
            [string]
            $Num = "1-001",
            [string]
            $FileName = "VariousData.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-ComputerDetails

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-002
    function Get-TPMData {

        param (
            [string]
            $Num = "1-002",
            [string]
            $FileName = "TPMDetails.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-TPMDetails

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-003
    function Get-PSInfo {

        param (
            [string]
            $Num = "1-003",
            [string]
            $FileName = "PSInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = .\bin\PsInfo.exe -accepteula -s -h -d

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-004
    function Get-PSDriveData {

        param (
            [string]
            $Num = "1-004",
            [string]
            $FileName = "PSDriveInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-PSDrive -PSProvider FileSystem | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-005
    function Get-LogicalDiskData {

        param (
            [string]
            $Num = "1-005",
            [string]
            $FileName = "LogicalDisks.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-006
    function Get-ComputerData {

        param (
            [string]
            $Num = "1-006",
            [string]
            $FileName = "ComputerInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-ComputerInfo

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-007
    function Get-SystemDataCMD {

        param (
            [string]
            $Num = "1-007",
            [string]
            $FileName = "SystemInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = systeminfo /FO LIST

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-008
    function Get-SystemDataPS {

        param (
            [string]
            $Num = "1-008",
            [string]
            $FileName = "ComputerSystem.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-009
    function Get-OperatingSystemData {

        param (
            [string]
            $Num = "1-009",
            [string]
            $FileName = "OSInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-010
    function Get-PhysicalMemory {

        param (
            [string]
            $Num = "1-010",
            [string]
            $FileName = "PhysicalMemory.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-011
    function Get-EnvVars {

        param (
            [string]
            $Num = "1-011",
            [string]
            $FileName = "EnvVars.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-ChildItem -Path env: | Format-List

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-012
    function Get-PhysicalDiskData {

        param (
            [string]
            $Num = "1-012",
            [string]
            $FileName = "PhysicalDisks.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-Disk | Select-Object -Property * | Sort-Object DiskNumber

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-013
    function Get-DiskPartitions {

        param (
            [string]
            $Num = "1-013",
            [string]
            $FileName = "DiskPartitions.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-014
    function Get-Win32DiskParts {

        param (
            [string]
            $Num = "1-014",
            [string]
            $FileName = "Win32DiskPartitions.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name | Format-List

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-015
    function Get-Win32StartupApps {

        param (
            [string]
            $Num = "1-015",
            [string]
            $FileName = "Win32StartupApps.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-016
    function Get-DataFromReg {

        param (
            [string]
            $Num = "1-016",
            [string]
            $FileName = "StartUpDataFromRegistry.txt"
        )

        $RegistryPaths = @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
            "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
            "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
            "HKLM:\SOFTWARE\Wow6432Node\microsoft\windows\CurrentVersion\RunOnce"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")
                $Counter = 1

                foreach ($RegPath in $RegistryPaths) {
                    if (Test-Path -Path $RegPath) {
                        $Data = Get-ItemProperty $RegPath | Select-Object * -ExcludeProperty PS* | Format-List

                        if ($Data.Count -eq 0) {
                            $NoDataMsg = "[$Counter] No data found in [$RegPath] registry key"
                            Add-Content -Path $File -Value "[$Counter] No data found in [$RegPath] registry key`n" -Encoding UTF8
                            Show-Message($NoDataMsg) -Yellow
                            Write-LogEntry($NoDataMsg)
                        }
                        else {
                            $DataSavedMsg = "[$Counter] Data from [$RegPath] saved to $($FileName)"
                            Add-Content -Path $File -Value "[$Counter] Data from [$RegPath] Registry key" -Encoding UTF8
                            $Data | Out-File -Append -FilePath $File -Encoding UTF8
                            Show-Message($DataSavedMsg) -Green
                            Write-LogEntry($DataSavedMsg)
                        }
                    }
                    else {
                        $KeyDneMsg = "[$Counter] Cannot find key [$RegPath] because it does not exist"
                        Add-Content -Path $File -Value "[$Counter] Key [$RegPath] does not exist on this system`n" -Encoding UTF8
                        Show-Message($KeyDneMsg) -Yellow
                        Write-LogEntry($KeyDneMsg) -WarningMessage
                    }
                    $Counter++
                }
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-017
    function Get-SoftwareLicenseData {

        param (
            [string]
            $Num = "1-017",
            [string]
            $FileName = "SoftwareLicense.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-WmiObject -ClassName SoftwareLicensingService

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-018
    function Get-AutoRunsData {

        param (
            [string]
            $Num = "1-018",
            [string]
            $FileName = "AutoRuns.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = .\bin\autorunsc64.exe -a * -c -nobanner

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-019
    function Get-BiosData {

        param (
            [string]
            $Num = "1-019",
            [string]
            $FileName = "BiosInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-020
    function Get-ConnectedDevices {

        param (
            [string]
            $Num = "1-020",
            [string]
            $FileName = "ConnectedDevices.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-PnpDevice

                if ($Data.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    $Data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-021
    function Get-HardwareInfo {

        param (
            [string]
            $Num = "1-021",
            [string]
            $FileName = "Hardware.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-CimInstance Win32_PnPEntity

                foreach ($Item in $Data) {
                    $Item | Add-Member -MemberType NoteProperty -Name "Host" -Value $Env:COMPUTERNAME
                    $Item | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
                }

                $Data | Select-Object Host, DateScanned, PnPClass, Caption, Description, DeviceID | Out-String

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-022
    function Get-Win32Products {
    <#
    .SYNOPSIS
        `Get-Win32Products` returns data about products that were installed via the Windows installer.
    #>

        param (
            [string]
            $Num = "1-022",
            [string]
            $FileName = "Win32Products.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-WmiObject Win32_Product

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 1-023
    function Get-OpenWindowTitles {
    <#
    .SYNOPSIS
        `Get-OpenWindowTitles` queries all main window titles and lists them as a table.
    #>

        param (
            [string]
            $Num = "1-023",
            [string]
            $FileName = "OpenWindowTitles.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")

                $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Format-Table ID, ProcessName, MainWindowTitle -AutoSize

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-VariousData
    Get-TPMData
    Get-PSInfo
    Get-PSDriveData
    Get-LogicalDiskData
    Get-ComputerData
    Get-SystemDataCMD
    Get-SystemDataPS
    Get-OperatingSystemData
    Get-PhysicalMemory
    Get-EnvVars
    Get-PhysicalDiskData
    Get-DiskPartitions
    Get-Win32DiskParts
    Get-Win32StartupApps
    Get-DataFromReg
    Get-SoftwareLicenseData
    Get-AutoRunsData
    Get-BiosData
    Get-ConnectedDevices
    Get-HardwareInfo
    Get-Win32Products
    Get-OpenWindowTitles
}


Export-ModuleMember -Function Export-DeviceFilesPage
