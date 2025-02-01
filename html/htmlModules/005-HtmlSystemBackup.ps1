function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader


    #TODO - Add a catch for the specific error that occured
    # 5-001
    function Get-ADS {
        param ([string]$FilePath)
        $Name = "5-001 Get-ADS"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ADSData
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 5-002
    function Get-OpenFiles {
        param ([string]$FilePath)
        $Name = "5-002 Get-OpenFiles"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = openfiles.exe /query /FO CSV /V | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-003
    function Get-OpenShares {
        param ([string]$FilePath)
        $Name = "5-003 Win32_Share"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-CimInstance -ClassName Win32_Share | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-004
    function Get-MappedNetworkDriveMRU {
        param ([string]$FilePath)
        $Name = "5-004 Map Network Drive MRU"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-005
    function Get-Win32ScheduledJobs {
        param ([string]$FilePath)
        $Name = "5-005 Win32_ScheduledJob"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-CimInstance -ClassName Win32_ScheduledJob
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-006
    function Get-ScheduledTasks {
        param ([string]$FilePath)
        $Name = "5-006 Get-ScheduledTask"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ScheduledTask | Select-Object -Property * | Where-Object { ($_.State -ne 'Disabled') }
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-007
    function Get-ScheduledTasksRunInfo {
        param ([string]$FilePath)
        $Name = "5-007 Get-ScheduledTaskInfo"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Get-ScheduledTaskInfo | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-008
    function Get-HotFixesData {
        param ([string]$FilePath)
        $Name = "5-008 Get-HotFix"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-009
    function Get-InstalledAppsFromReg {
        param ([string]$FilePath)
        $Name = "5-009 Installed Apps From Registry"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property * | Sort-Object InstallDate -Descending
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-010
    function Get-InstalledAppsFromAppx {
        param ([string]$FilePath)
        $Name = "5-010 Installed Apps From Appx"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-AppxPackage
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-011
    function Get-VolumeShadowsData {
        param ([string]$FilePath)
        $Name = "5-011 Volume Shadow Copies"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-012
    function Get-TempInternetFiles {
        param ([string]$FilePath)
        $Name = "5-012 Temporary Internet Files"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ChildItem -Recurse -Force "$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-013
    function Get-StoredCookiesData {
        param ([string]$FilePath)
        $Name = "5-013 Stored Cookies Data"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ChildItem -Recurse -Force "$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies" | Select-Object Name | ForEach-Object { $N = $_.Name; Get-Content "$($AppData)\Microsoft\Windows\cookies\$N" | Select-String "/" }
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-014
    function Get-TypedUrls {
        param ([string]$FilePath)
        $Name = "5-014 Typed URLs"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found for '$Name'") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-015
    function Get-InternetSettings {
        param ([string]$FilePath)
        $Name = "5-015 Internet Settings"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-016
    function Get-TrustedInternetDomains {
        param ([string]$FilePath)
        $Name = "5-016 Trusted Internet Domains"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ChildItem $RegKey | Select-Object PSChildName
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-017
    function Get-AppInitDllKeys {
        param ([string]$FilePath)
        $Name = "5-017 App Init Dll Keys"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-018
    function Get-UacGroupPolicy {
        param ([string]$FilePath)
        $Name = "5-018 UAC Group Policy"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 5-019
    function Get-GroupPolicy {
        param ([string]$FilePath)
        $Name = "5-019 Group Policies"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = gpresult.exe /z | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-020
    function Get-ActiveSetupInstalls {
        param ([string]$FilePath)
        $Name = "5-020 Active Setup Installs"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-021
    function Get-AppPathRegKeys {
        param ([string]$FilePath)
        $Name = "5-021 App Path Reg Keys"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property * | Sort-Object '(default)'
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name

    }

    #!@Array
    # 5-022
    function Get-DllsLoadedByExplorer {
        param ([string]$FilePath)
        $Name = "5-022 Dlls Loaded by Explorer"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-023
    function Get-ShellUserInitValues {
        param ([string]$FilePath)
        $Name = "5-023 Shell User Init Values"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-024
    function Get-SecurityCenterSvcValuesData {
        param ([string]$FilePath)
        $Name = "5-024 Security Center Svc Values"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Security Center\Svc"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-025
    function Get-DesktopAddressBarHst {
        param ([string]$FilePath)
        $Name = "5-025 Desktop Address Bar History"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-026
    function Get-RunMruKeyData {
        param ([string]$FilePath)
        $Name = "5-026 Run MRU Key Data"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-027
    function Get-StartMenuData {
        param ([string]$FilePath)
        $Name = "5-027 Start Menu Data"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-028
    function Get-ProgramsExeBySessionManager {
        param ([string]$FilePath)
        $Name = "5-028 Programs Executed by Session Manager"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-029
    function Get-ShellFoldersData {
        param ([string]$FilePath)
        $Name = "5-029 Shell Folder Data"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-030
    function Get-UserStartupShellFolders {
        param ([string]$FilePath)
        $Name = "5-030 User Startup Shell Folder"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object startup
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-031
    function Get-ApprovedShellExts {
        param ([string]$FilePath)
        $Name = "5-031 Approved Shell Extensions"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-032
    function Get-AppCertDlls {
        param ([string]$FilePath)
        $Name = "5-032 App Cert Dlls"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-033
    function Get-ExeFileShellCommands {
        param ([string]$FilePath)
        $Name = "5-033 Exe File Shell Commands"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Classes\exefile\shell\open\command"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-034
    function Get-ShellOpenCommands {
        param ([string]$FilePath)
        $Name = "5-034 Shell Open Commands"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Classes\http\shell\open\command"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object "(Default)"
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-035
    function Get-BcdRelatedData {
        param ([string]$FilePath)
        $Name = "5-035 BCD Data"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\BCD00000000\*\*\*\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object Element | Select-String "exe" | Select-Object Line
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-036
    function Get-LsaData {
        param ([string]$FilePath)
        $Name = "5-036 LSA Data"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-037
    function Get-BrowserHelperFile {
        param ([string]$FilePath)
        $Name = "5-037 Browser Helper File"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object "(Default)"
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-038
    function Get-BrowserHelperx64File {
        param ([string]$FilePath)
        $Name = "5-038 Browser Helper x64 File"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object "(Default)"
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    #* 5-039
    function Get-IeExtensions {
        param ([string]$FilePath)
        $Name = "5-039 IE Extensions"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKeys = @(
            "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*"
        )
        foreach ($RegKey in $RegKeys) {
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Show-Message("[INFO] No data found for '$Name'") -Yellow
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object ButtonText, Icon
                    if ($Data.Count -eq 0) {
                        Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
        }
        Show-FinishedHtmlMessage $Name
    }

    #!@Array
    # 5-040
    function Get-UsbDevices {
        param ([string]$FilePath)
        $Name = "5-040 USB Devices"
        Show-Message("Running '$Name' command") -Header -Gray
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*"
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = Get-ItemProperty -Path $RegKey | Select-Object FriendlyName, PSChildName, ContainerID
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-041
    function Get-AuditPolicy {
        param ([string]$FilePath)
        $Name = "5-041 Audit Policy"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = auditpol /get /category:* | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-042
    function Get-RecentAddedExeFiles {
        param (
            [string]$FilePath,
            [int]$NumberOfRecords = 5
        )
        $Name = "5-042 Recently Added EXE files"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-ChildItem -Path HKLM:\Software -Recurse -Force | Where-Object { $_.Name -like "*.exe" } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First $NumberOfRecords | Format-Table PSPath, LastWriteTime
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Security.SecurityException] {
            Show-Message("[WARNING] Requested registry access is not allowed") -Yellow
        }
        catch {
            # Error handling for other errors that may occur
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-043
    function Get-HiddenFiles {
        param (
            [string]$FilePath,
            [string]$Path = "C:\"
        )
        $Name = "5-043 Hidden Files"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            if (-not (Test-Path $Path)) {
                Show-Message("[INFO] The specified path '$Path' does not exist") -Yellow
            }
            $Data = Get-ChildItem -Path $Path -Attributes Hidden -Recurse -Force
            $Count = $Data.Count
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("Found $Count hidden files within $Path") -Green
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-044
    function Get-ExecutableFiles {
        param (
            [string]$FilePath,
            [string]$Path = "C:\"
        )
        $Name = "5-044 Executable File List"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            if (-not (Test-Path $Path)) {
                Show-Message("[INFO] The specified path '$Path' does not exist") -Yellow
            }
            $Data = Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq ".exe" }
            $Count = $Data.Count
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("Found $Count executable files within $Path") -Green
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # TEST FUNCTION FOR GETTING REG VALUES
    # ----------------------------------


    function Get-RegValues {

        param (
            [string]$FilePath,
            [string]$Name,
            [string]$RegKey,
            [string]$Command
        )

        Show-Message("Running '$Name' command") -Header -Gray
        try {
            if (-not (Test-Path -Path $RegKey)) {
                Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                Show-Message("[INFO] No data found for '$Name'") -Yellow
            }
            else {
                $Data = $Command
                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found in Registry Key [$RegKey]") -Yellow
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name

    }


    # Iterate over keys ("a" and "b") and pass their values to the function
    $keys = $array.Keys
    for ($i = 0; $i -lt $keys.Count; $i++) {
        $key = $keys[$i]
        $values = $array[$key]  # Get the corresponding values

        Write-Output "Running search for key: $key"
        SearchFiles @values   # Use splatting to pass each value to the function
    }



    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    # Get-ADS -FilePath $FilePath
    # Get-OpenFiles -FilePath $FilePath
    # Get-OpenShares -FilePath $FilePath
    # Get-MappedNetworkDriveMRU -FilePath $FilePath
    # Get-Win32ScheduledJobs -FilePath $FilePath
    # Get-ScheduledTasks -FilePath $FilePath
    # Get-ScheduledTasksRunInfo -FilePath $FilePath
    # Get-HotFixesData -FilePath $FilePath
    # Get-InstalledAppsFromReg -FilePath $FilePath
    # Get-InstalledAppsFromAppx -FilePath $FilePath
    # Get-VolumeShadowsData -FilePath $FilePath
    # Get-TempInternetFiles -FilePath $FilePath
    # Get-StoredCookiesData -FilePath $FilePath
    # Get-TypedUrls -FilePath $FilePath
    # Get-InternetSettings -FilePath $FilePath
    # Get-TrustedInternetDomains -FilePath $FilePath
    # Get-AppInitDllKeys -FilePath $FilePath
    # Get-UacGroupPolicy -FilePath $FilePath
    # Get-GroupPolicy -FilePath $FilePath
    # Get-ActiveSetupInstalls -FilePath $FilePath
    # Get-AppPathRegKeys -FilePath $FilePath
    # Get-DllsLoadedByExplorer -FilePath $FilePath
    # Get-ShellUserInitValues -FilePath $FilePath
    # Get-SecurityCenterSvcValuesData -FilePath $FilePath
    # Get-DesktopAddressBarHst -FilePath $FilePath
    # Get-RunMruKeyData -FilePath $FilePath
    # Get-StartMenuData -FilePath $FilePath
    # Get-ProgramsExeBySessionManager -FilePath $FilePath
    # Get-ShellFoldersData -FilePath $FilePath
    # Get-UserStartupShellFolders -FilePath $FilePath
    # Get-ApprovedShellExts -FilePath $FilePath
    # Get-AppCertDlls -FilePath $FilePath
    # Get-ExeFileShellCommands -FilePath $FilePath
    # Get-ShellOpenCommands -FilePath $FilePath
    # Get-BcdRelatedData -FilePatha $FilePath
    # Get-LsaData -FilePath $FilePath
    # Get-BrowserHelperFile -FilePath $FilePath
    # Get-BrowserHelperx64File -FilePath $FilePath
    # Get-IeExtensions -FilePath $FilePath
    # Get-UsbDevices -FilePath $FilePath
    # Get-AuditPolicy -FilePath $FilePath
    # Get-HiddenFiles -FilePath $FilePath


    # ----------------------------------
    # Function that need work
    # ----------------------------------
    # Get-RecentAddedExeFiles -FilePath $FilePath
    # Get-ExecutableFiles -FilePath $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


# Export-ModuleMember -Function Export-SystemHtmlPage
