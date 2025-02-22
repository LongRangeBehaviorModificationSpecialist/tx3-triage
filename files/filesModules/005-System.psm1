$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-SystemFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 5-001
    function Get-ADS {

        param (
            [string]
            $Num = "5-001",
            [string]
            $FileName = "ADSData.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ADSData

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

    # 5-002
    function Get-OpenFiles {

        param (
            [string]
            $Num = "5-002",
            [string]
            $FileName = "ListOfOpenFiles.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "`n$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                # Get list of open files with openfiles.exe, output it to CSV format
                $Data = openfiles.exe /query /FO CSV /V

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

    # 5-003
    function Get-OpenShares {

        param (
            [string]
            $Num = "5-003",
            [string]
            $FileName = "OpenShares.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_Share | Select-Object -Property *

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

    # 5-004
    function Get-MappedNetworkDriveMRU {

        param (
            [string]
            $Num = "5-004",
            [string]
            $FileName = "MappedNetworkDriveMRU.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object * -ExcludeProperty PS*

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

    # 5-005
    function Get-ScheduledJobs {

        param (
            [string]
            $Num = "5-005",
            [string]
            $FileName = "ScheduledJobs.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_ScheduledJob

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

    # 5-006
    function Get-ScheduledTasks {

        param (
            [string]
            $Num = "5-006",
            [string]
            $FileName = "ScheduledTasks.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ScheduledTask | Select-Object -Property * | Where-Object { ($_.State -ne 'Disabled') }

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

    # 5-007
    function Get-ScheduledTasksRunInfo {

        param (
            [string]
            $Num = "5-007",
            [string]
            $FileName = "ScheduledTasksRunInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Get-ScheduledTaskInfo | Select-Object -Property *

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

    # 5-008
    function Get-HotFixesData {

        param (
            [string]
            $Num = "5-008",
            [string]
            $FileName = "HotFixes.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending

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

    # 5-009
    function Get-InstalledAppsFromReg {

        param (
            [string]
            $Num = "5-009",
            [string]
            $FileName = "InstalledAppsFromReg.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object -Property * | Sort-Object InstallDate -Descending
                }
                catch [PathNotFound] {
                    Show-Message -Message "$KeyNotFoundMsg" -Yellow
                    Write-LogEntry -Message "$KeyNotFoundMsg" -WarningMessage
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

    # 5-010
    function Get-InstalledAppsFromAppx {

        param (
            [string]
            $Num = "5-010",
            [string]
            $FileName = "InstalledAppsFromAppx.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-AppxPackage | Format-List

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

    # 5-011
    function Get-VolumeShadowsData {

        param (
            [string]
            $Num = "5-011",
            [string]
            $FileName = "VolumeShadowCopies.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property *

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

    # TODO -- move this function to the networking section
    # 5-012
    function Get-DnsCacheDataTxt {

        param (
            [string]
            $Num = "5-012",
            [string]
            $FileName = "DnsCache.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = ipconfig /displaydns

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

    # TODO -- move this function to the networking section
    # 5-013
    function Get-DnsCacheDataCsv {

        param (
            [string]
            $Num = "5-013",
            [string]
            $FileName = "DnsClientCache.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-DnsClientCache | ConvertTo-Csv -NoTypeInformation

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

    # 5-014
    function Get-TempInternetFiles {

        param (
            [string]
            $Num = "5-014",
            [string]
            $FileName = "TempInternetFiles.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ChildItem -Recurse -Force "$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending

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

    # 5-015
    function Get-StoredCookiesData {

        param (
            [string]
            $Num = "5-015",
            [string]
            $FileName = "StoredCookies.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $AppData = $Env:LOCALAPPDATA
                $Data = Get-ChildItem -Recurse -Force "$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies" | Select-Object Name |ForEach-Object { $N = $_.Name; Get-Content "$($AppData)\Microsoft\Windows\cookies\$N" | Select-String "/" }

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

    # 5-016
    function Get-TypedUrls {

        param (
            [string]
            $Num = "5-016",
            [string]
            $FileName = "TypedUrls.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs" | Select-Object * -ExcludeProperty PS*

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

    # 5-017
    function Get-InternetSettings {

        param (
            [string]
            $Num = "5-017",
            [string]
            $FileName = "InternetSettings.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object * -ExcludeProperty PS*

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

    # 5-018
    function Get-TrustedInternetDomains {

        param (
            [string]
            $Num = "5-018",
            [string]
            $FileName = "TrustedInternetDomains.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains" | Select-Object PSChildName

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

    # 5-019
    function Get-AppInitDllKeys {

        param (
            [string]
            $Num = "5-019",
            [string]
            $FileName = "AppInitDllKey.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" | Select-Object -Property *

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

    # 5-020
    function Get-UacGroupPolicy {

        param (
            [string]
            $Num = "5-020",
            [string]
            $FileName = "UacGroupPolicy.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | Select-Object * -ExcludeProperty PS*

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

    # 5-021
    function Get-GroupPolicy {

        param (
            [string]
            $Num = "5-021",
            [string]
            $FileName = "GroupPolicy.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = gpresult.exe /z

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

    # 5-022
    function Get-ActiveSetupInstalls {

        param (
            [string]
            $Num = "5-022",
            [string]
            $FileName = "ActiveSetupInstalls.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*" | Select-Object -Property *

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

    # 5-023
    function Get-AppPathRegKeys {

        param (
            [string]
            $Num = "5-023",
            [string]
            $FileName = "AppPathRegKeys.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*" | Select-Object -Property * | Sort-Object '(default)'

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

    # 5-024
    function Get-DllsLoadedByExplorer {

        param (
            [string]
            $Num = "5-024",
            [string]
            $FileName = "DllsLoadedByExplorerShell.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*" | Select-Object -Property *

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

    # 5-025
    function Get-ShellUserInitValues {

        param (
            [string]
            $Num = "5-025",
            [string]
            $FileName = "ShellAndUserInitValues.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | Select-Object * -ExcludeProperty PS*

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

    # 5-026
    function Get-SecurityCenterSvcValuesData {

        param (
            [string]
            $Num = "5-026",
            [string]
            $FileName = "SvcValues.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Security Center\Svc" | Select-Object * -ExcludeProperty PS*

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

    # 5-027
    function Get-DesktopAddressBarHst {

        param (
            [string]
            $Num = "5-027",
            [string]
            $FileName = "DesktopAddressBar.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" | Select-Object * -ExcludeProperty PS*

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

    # 5-028
    function Get-RunMruKeyData {

        param (
            [string]
            $Num = "5-028",
            [string]$FielName = "RunMruKeyInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" | Select-Object * -ExcludeProperty PS*

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

    # 5-029
    function Get-StartMenuData {

        param (
            [string]
            $Num = "5-029",
            [string]
            $FileName = "StartMenuData.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu" | Select-Object * -ExcludeProperty PS*

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

    # 5-030
    function Get-ProgramsExeBySessionManager {

        param (
            [string]
            $Num = "5-030",
            [string]
            $FileName = "ProgExeBySessionManager.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" | Select-Object * -ExcludeProperty PS*

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

    # 5-031
    function Get-ShellFoldersData {

        param (
            [string]
            $Num = "5-031",
            [string]
            $FileName = "ShellFolderInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" | Select-Object * -ExcludeProperty PS*

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

    # 5-032
    function Get-UserStartupShellFolders {

        param (
            [string]
            $Num = "5-032",
            [string]
            $FileName = "StartUpShellFolderInfo.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" | Select-Object startup

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

    # 5-033
    function Get-ApprovedShellExts {

        param (
            [string]
            $Num = "5-033",
            [string]
            $FileName = "ApprovedShellExts.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved" | Select-Object * -ExcludeProperty PS*

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

    # 5-034
    function Get-AppCertDlls {

        param (
            [string]
            $Num = "5-034",
            [string]
            $FileName = "AppCertDlls.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls" | Select-Object * -ExcludeProperty PS*

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

    # 5-035
    function Get-ExeFileShellCommands {

        param (
            [string]
            $Num = "5-035",
            [string]
            $FileName = "ExeFileShellCommands.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Classes\exefile\shell\open\command" | Select-Object * -ExcludeProperty PS*

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

    # 5-036
    function Get-ShellOpenCommands {

        param (
            [string]
            $Num = "5-036",
            [string]
            $FileName = "ShellCommands.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Classes\http\shell\open\command" | Select-Object "(Default)"

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

    # 5-037
    function Get-BcdRelatedData {

        param (
            [string]
            $Num = "5-037",
            [string]
            $FileName = "BcdRelatedData.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\BCD00000000\*\*\*\*" | Select-Object Element | Select-String "exe" | Select-Object Line

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

    # 5-038
    function Get-LsaData {

        param (
            [string]
            $Num = "5-038",
            [string]
            $FileName = "LoadedLsaPackages.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" | Select-Object * -ExcludeProperty PS*

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

    # 5-039
    function Get-BrowserHelperFile {

        param (
            [string]
            $Num = "5-039",
            [string]
            $FileName = "BrowserHelperObjects.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*" | Select-Object "(Default)"

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
            throw $PSItem
        }
    }

    # 5-040
    function Get-BrowserHelperx64File {

        param (
            [string]
            $Num = "5-040",
            [string]
            $FileName = "BrowserHelperObjectsx64.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*" | Select-Object "(Default)"

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

    # 5-041
    function Get-IeExtensions {

        param (
            [string]
            $Num = "5-041",
            [string]
            $FileName = "IeExtensions.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data1 = Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon
                $Data2 = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon

                if (-not $Data1) {
                    Write-NoDataFound -FunctionName $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data1 $File
                    Show-OutputSavedToFile $File
                }

                if (-not $Data2) {
                    Write-NoDataFound -FunctionName $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-OutputAppend $Data2 $File
                    Show-OutputSavedToFile $File
                }
                Write-LogOutputSaved $File
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    # 5-042
    function Get-UsbDevices {

        param (
            [string]
            $Num = "5-042",
            [string]
            $FileName = "UsbDevices.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*" | Select-Object FriendlyName, PSChildName, ContainerID

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

    # 5-043
    function Get-AuditPolicy {

        param (
            [string]
            $Num = "5-043",
            [string]
            $FileName = "AuditPolicy.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = auditpol /get /category:*

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

    # 5-044
    function Get-RecentAddedExeFiles {

        param (
            [string]
            $Num = "5-044",
            [string]
            $FileName = "RecentSoftwareRegistryChanges.txt",
            [int]
            $NumberOfRecords = 25
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                try {
                    $Data = Get-ChildItem -Path HKLM:\Software -Recurse -Force | Where-Object { $_.Name -like "*.exe" } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First $NumberOfRecords | Format-Table PSPath, LastWriteTime
                }
                catch [System.Security.SecurityException] {
                    $ErrorMessage = "Requested registry access is not allowed"
                    Show-Message -Message "$ErrorMessage" -Red
                    Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $ErrorMessage" -ErrorMessage
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

    # 5-045
    function Get-HiddenFiles {

        param (
            [string]
            $Num = "5-045",
            [string]
            $FileName = "HiddenFiles.txt",
            [string]
            $Path = "C:\"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                # Validate the input path
                if (-not (Test-Path $Path)) {
                    throw "The specified path '$Path' does not exist"
                }

                $Data = Get-ChildItem -Path $Path -Attributes Hidden -Recurse -Force
                $Count = $Data.Count

                Show-Message -Message "Found $Count hidden files within $Path"

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

    # 5-046
    function Get-ExecutableFiles {

        param (
            [string]
            $Num = "5-046",
            [string]
            $FileName = "ExecutableFiles.txt",
            [string]
            $Path = "C:\"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                # Validate the input path
                if (-not (Test-Path $Path)) {
                    throw "The specified path '$Path' does not exist"
                }

                $Data = Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq ".exe" }
                $Count = $Data.Count

                Show-Message -Message "Found $Count executable files within $Path"

                if ($Count -eq 0) {
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


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ADS
    Get-OpenFiles
    Get-OpenShares
    Get-MappedNetworkDriveMRU
    Get-ScheduledJobs
    Get-ScheduledTasks
    Get-ScheduledTasksRunInfo
    Get-HotFixesData
    Get-InstalledAppsFromReg
    Get-InstalledAppsFromAppx
    Get-VolumeShadowsData
    Get-DnsCacheDataTxt
    Get-DnsCacheDataCsv
    Get-TempInternetFiles
    Get-StoredCookiesData
    Get-TypedUrls
    Get-InternetSettings
    Get-TrustedInternetDomains
    Get-AppInitDllKeys
    Get-UacGroupPolicy
    Get-GroupPolicy
    Get-ActiveSetupInstalls
    Get-AppPathRegKeys
    Get-DllsLoadedByExplorer
    Get-ShellUserInitValues
    Get-SecurityCenterSvcValuesData
    Get-DesktopAddressBarHst
    Get-RunMruKeyData
    Get-StartMenuData
    Get-ProgramsExeBySessionManager
    Get-ShellFoldersData
    Get-UserStartupShellFolders
    Get-ApprovedShellExts
    Get-AppCertDlls
    Get-ExeFileShellCommands
    Get-ShellOpenCommands
    Get-BcdRelatedData
    Get-LsaData
    Get-BrowserHelperFile
    Get-BrowserHelperx64File
    Get-IeExtensions
    Get-UsbDevices
    Get-AuditPolicy
    Get-RecentAddedExeFiles
    Get-HiddenFiles
    # Get-ExecutableFiles
}


Export-ModuleMember -Function Export-SystemFilesPage
