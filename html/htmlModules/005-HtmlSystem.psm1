$RegistryKeysArray = [ordered]@{

    "5-014-A Map Network Drive MRU"                = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-B Installed Apps From Registry"         = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, Comments | Sort-Object InstallDate -Descending")

    "5-014-C Typed URLs"                           = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-D Internet Settings"                    = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-E Trusted Internet Domains"             = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains", "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property *")

    "5-014-F App Init Dll Keys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property *")

    "5-014-G Trusted Internet Domains"             = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-H Active Setup Installs"                = ("HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property *")

    "5-014-I App Path Reg Keys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)'")

    "5-014-J Dlls Loaded by Explorer"              = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property *")

    "5-014-K Shell User Init Values"               = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-L Security Center Svc Values"           = ("HKLM:\SOFTWARE\Microsoft\Security Center\Svc", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-M Desktop Address Bar History"          = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-N Run MRU Key Data"                     = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-N1 Startup Applications - Additional for x64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-N2 Startup Applications - Additional for x64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-N3 Startup Applications - Additional for x64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-N4 Startup Applications - Additional for x64" = ("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce", "Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-O Start Menu Data"                      = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-P Programs Executed by Session Manager" = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-Q Shell Folder Data"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-R User Startup Shell Folder"            = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object 'Startup'")

    "5-014-S Approved Shell Extensions"            = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-T App Cert Dlls"                        = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-U Exe File Shell Commands"              = ("HKLM:\SOFTWARE\Classes\exefile\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-V Shell Open Commands"                  = ("HKLM:\SOFTWARE\Classes\http\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\http\shell\open\command' | Select-Object '(Default)'")

    "5-014-W BCD Data"                             = ("HKLM:\BCD00000000\*\*\*\*", "Get-ItemProperty 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line")

    "5-014-X LSA Data"                             = ("HKLM:\SYSTEM\CurrentControlSet\Control\Lsa", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property * -ExcludeProperty PS*")

    "5-014-Y Browser Helper File"                  = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")

    "5-014-Z Browser Helper x64 File"              = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")

    "5-014-AA IE Extensions"                       = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")

    "5-014-AB IE Extensions"                       = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")

    "5-014-AC USB Devices"                          = ("HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*", "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID")
}


function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    #TODO - Add a catch for the specific error that occured
    # 5-001
    function Get-ADS {
        param ([string]$FilePath)
        $Name = "5-001_ADS"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ADSData
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 5-002
    function Get-OpenFiles {
        param ([string]$FilePath)
        $Name = "5-002_Open_Files"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = openfiles.exe /query /FO CSV /V | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-003
    function Get-OpenShares {
        param ([string]$FilePath)
        $Name = "5-003_Win32_Share"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_Share | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-004
    function Get-Win32ScheduledJobs {
        param ([string]$FilePath)
        $Name = "5-004_Win32_Scheduled_Jobs"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_ScheduledJob
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-005
    function Get-ScheduledTasks {
        param ([string]$FilePath)
        $Name = "5-005_Scheduled_Tasks"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ScheduledTask | Select-Object -Property * | Where-Object { ($_.State -ne 'Disabled') }
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-006
    function Get-ScheduledTasksRunInfo {
        param ([string]$FilePath)
        $Name = "5-006_Scheduled_Task_Info"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Get-ScheduledTaskInfo | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-007
    function Get-HotFixesData {
        param ([string]$FilePath)
        $Name = "5-007_HotFixes"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-008
    function Get-InstalledAppsFromAppx {
        param ([string]$FilePath)
        $Name = "5-008_Installed_Apps_From_Appx"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-AppxPackage
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-009
    function Get-VolumeShadowsData {
        param ([string]$FilePath)
        $Name = "5-009_Volume_Shadow_Copies"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-010
    function Get-TempInternetFiles {
        param ([string]$FilePath)
        $Name = "5-010_Temporary_Internet_Files"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ChildItem -Recurse -Force "$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-011
    function Get-StoredCookiesData {
        param ([string]$FilePath)
        $Name = "5-011_Stored_Cookies_Data"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ChildItem -Recurse -Force "$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies" | Select-Object Name | ForEach-Object { $N = $_.Name; Get-Content "$($AppData)\Microsoft\Windows\cookies\$N" | Select-String "/" }
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 5-012
    function Get-GroupPolicy {
        param ([string]$FilePath)
        $Name = "5-012_Group_Policies"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = gpresult.exe /z | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-013
    function Get-AuditPolicy {
        param ([string]$FilePath)
        $Name = "5-013_Audit_Policy"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = auditpol /get /category:* | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # -------------------------------------
    # TEST FUNCTION FOR GETTING REG VALUES
    # -------------------------------------

    # 5-014
    function Get-RegistryValues {

        param (
            [string]$FilePath
        )

        foreach ($item in $RegistryKeysArray.GetEnumerator()) {

            $Name = $item.Key
            $RegKey = $item.value[0]
            $Command = $item.value[1]

            Show-Message("Running ``$Name``") -Header -DarkGray

            try {

                Show-Message("[INFO] Searching for key [$RegKey]") -DarkGray

                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Show-Message("[INFO] No data found for ``$Name``") -Yellow
                }
                else {
                    $Data = Invoke-Expression -Command $Command | Out-String
                    if (-not $Data) {
                        Show-Message("[INFO] The registry key [$RegKey] exists, but contains no data") -Yellow
                        Write-HtmlLogEntry("No data found for ``$Name``")
                    }
                    else {
                        Show-Message("[INFO] Saving output from ``$Name``") -Blue

                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                        Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                    }
                }
            }
            catch {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 5-015
    function Get-HiddenFiles {
        param (
            [string]$FilePath,
            [string]$Path = "C:\"
        )
        $Name = "5-015_Hidden_Files"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            if (-not (Test-Path $Path)) {
                Show-Message("[INFO] The specified path '$Path' does not exist") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            $Data = Get-ChildItem -Path $Path -Attributes Hidden -Recurse -Force
            $Count = $Data.Count
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Show-Message("Found $Count hidden files within $Path") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # 5-016
    function Get-RecentAddedExeFiles {
        param (
            [string]$FilePath,
            [int]$NumberOfRecords = 5
        )
        $Name = "5-014_Recently_Added_EXE_Files"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = Get-ChildItem -Path HKLM:\Software -Recurse -Force | Where-Object { $_.Name -like "*.exe" } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First $NumberOfRecords | Format-Table PSPath, LastWriteTime
            if ($Data.Count -eq 0) {
                    Show-Message("[INFO] No data found for ``$Name``") -Yellow
                    Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Security.SecurityException] {
            Show-Message("[WARNING] Requested registry access is not allowed") -Yellow
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-017
    function Get-ExecutableFiles {
        param (
            [string]$FilePath,
            [string]$Path = "C:\"
        )
        $Name = "5-016_Executable_File_List"
        Show-Message("Running ``$Name`` command") -Header -DarkGray

        try {
            if (-not (Test-Path $Path)) {
                Show-Message("[INFO] The specified path '$Path' does not exist") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            $Data = Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq ".exe" }
            $Count = $Data.Count
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Show-Message("Found $Count executable files within $Path") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ADS -FilePath $FilePath -PagesFolder $PagesFolder  #5-001
    Get-OpenFiles -FilePath $FilePath -PagesFolder $PagesFolder  #5-002
    Get-OpenShares -FilePath $FilePath -PagesFolder $PagesFolder  #5-003
    Get-Win32ScheduledJobs -FilePath $FilePath -PagesFolder $PagesFolder  #5-004
    Get-ScheduledTasks -FilePath $FilePath -PagesFolder $PagesFolder  #5-005
    Get-ScheduledTasksRunInfo -FilePath $FilePath -PagesFolder $PagesFolder  #5-006
    Get-HotFixesData -FilePath $FilePath -PagesFolder $PagesFolder  #5-007
    Get-InstalledAppsFromAppx -FilePath $FilePath -PagesFolder $PagesFolder  #5-008
    Get-VolumeShadowsData -FilePath $FilePath -PagesFolder $PagesFolder  #5-009
    Get-TempInternetFiles -FilePath $FilePath -PagesFolder $PagesFolder  #5-010
    Get-StoredCookiesData -FilePath $FilePath -PagesFolder $PagesFolder  #5-011
    Get-GroupPolicy -FilePath $FilePath -PagesFolder $PagesFolder  #5-012
    Get-AuditPolicy -FilePath $FilePath -PagesFolder $PagesFolder  #5-013
    Get-RegistryValues -FilePath $FilePath -PagesFolder $PagesFolder  #5-014
    Get-HiddenFiles -FilePath $FilePath -PagesFolder $PagesFolder  #5-015


    # ----------------------------------
    # Function that need work
    # ----------------------------------
    # Get-RecentAddedExeFiles $FilePath  #5-016
    # Get-ExecutableFiles $FilePath  #5-017


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-SystemHtmlPage
