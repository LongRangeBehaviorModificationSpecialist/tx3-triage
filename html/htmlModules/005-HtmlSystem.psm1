$PropertiesArray = [ordered]@{

    "5-014-A Map Network Drive MRU"                = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-B Installed Apps From Registry"         = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, Comments | Sort-Object InstallDate -Descending | Format-List")

    "5-014-C Typed URLs"                           = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-D Internet Settings"                    = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-E Trusted Internet Domains"             = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains", "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property * | Format-List")

    "5-014-F App Init Dll Keys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property * | Format-List")

    "5-014-G Trusted Internet Domains"             = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-H Active Setup Installs"                = ("HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property * | Format-List")

    "5-014-I App Path Reg Keys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)' | Format-List")

    "5-014-J Dlls Loaded by Explorer"              = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property * | Format-List")

    "5-014-K Shell User Init Values"               = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-L Security Center Svc Values"           = ("HKLM:\SOFTWARE\Microsoft\Security Center\Svc", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-M Desktop Address Bar History"          = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-N Run MRU Key Data"                     = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-O Start Menu Data"                      = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-P Programs Executed by Session Manager" = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-Q Shell Folder Data"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-R User Startup Shell Folder"            = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object 'Startup' | Format-List")

    "5-014-S Approved Shell Extensions"            = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-T App Cert Dlls"                        = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-U Exe File Shell Commands"              = ("HKLM:\SOFTWARE\Classes\exefile\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-V Shell Open Commands"                  = ("HKLM:\SOFTWARE\Classes\http\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\http\shell\open\command' | Select-Object '(Default)' | Format-List")

    "5-014-W BCD Data"                             = ("HKLM:\BCD00000000\*\*\*\*", "Get-ItemProperty 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line | Format-List")

    "5-014-X LSA Data"                             = ("HKLM:\SYSTEM\CurrentControlSet\Control\Lsa", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property * -ExcludeProperty PS* | Format-List")

    "5-014-Y Browser Helper File"                  = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)' | Format-List")

    "5-014-Z Browser Helper x64 File"              = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)' | Format-List")

    "5-014-AA IE Extensions"                       = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon | Format-List")

    "5-014-AB IE Extensions"                       = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon | Format-List")

    "5-014-AC USB Devices"                          = ("HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*", "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID | Format-List")
}


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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-004
    function Get-Win32ScheduledJobs {
        param ([string]$FilePath)
        $Name = "5-004 Win32_ScheduledJob"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-005
    function Get-ScheduledTasks {
        param ([string]$FilePath)
        $Name = "5-005 Get-ScheduledTask"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-006
    function Get-ScheduledTasksRunInfo {
        param ([string]$FilePath)
        $Name = "5-006 Get-ScheduledTaskInfo"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-007
    function Get-HotFixesData {
        param ([string]$FilePath)
        $Name = "5-007 Get-HotFix"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-008
    function Get-InstalledAppsFromAppx {
        param ([string]$FilePath)
        $Name = "5-008 Installed Apps From Appx"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-009
    function Get-VolumeShadowsData {
        param ([string]$FilePath)
        $Name = "5-009 Volume Shadow Copies"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-010
    function Get-TempInternetFiles {
        param ([string]$FilePath)
        $Name = "5-010 Temporary Internet Files"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-011
    function Get-StoredCookiesData {
        param ([string]$FilePath)
        $Name = "5-011 Stored Cookies Data"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 5-012
    function Get-GroupPolicy {
        param ([string]$FilePath)
        $Name = "5-012 Group Policies"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-013
    function Get-AuditPolicy {
        param ([string]$FilePath)
        $Name = "5-013 Audit Policy"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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

        foreach ($item in $PropertiesArray.GetEnumerator()) {

            $Name = $item.Key
            $RegKey = $item.value[0]
            $Command = $item.value[1]

            Show-Message("Running '$Name'") -Header -Gray

            try {

                Show-Message("Searching for key [$RegKey]") -Gray

                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Show-Message("[INFO] No data found for '$Name'") -Yellow
                }
                else {
                    $Data = Invoke-Expression $Command | Out-String
                    if (-not $Data) {
                        Show-Message("[INFO] The registry key [$RegKey] exists, but contains no data") -Yellow
                    }
                    else {
                        Show-Message("[INFO] Saving output from '$Name'") -Green
                        Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "[ERROR] Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
        $Name = "5-015 Hidden Files"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # 5-016
    function Get-RecentAddedExeFiles {
        param (
            [string]$FilePath,
            [int]$NumberOfRecords = 5
        )
        $Name = "5-014 Recently Added EXE files"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 5-017
    function Get-ExecutableFiles {
        param (
            [string]$FilePath,
            [string]$Path = "C:\"
        )
        $Name = "5-016 Executable File List"
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
            # Write-LogEntry("[$FunctionName, Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ADS $FilePath  #5-001
    Get-OpenFiles $FilePath  #5-002
    Get-OpenShares $FilePath  #5-003
    Get-Win32ScheduledJobs $FilePath  #5-004
    Get-ScheduledTasks $FilePath  #5-005
    Get-ScheduledTasksRunInfo $FilePath  #5-006
    Get-HotFixesData $FilePath  #5-007
    Get-InstalledAppsFromAppx $FilePath  #5-008
    Get-VolumeShadowsData $FilePath  #5-009
    Get-TempInternetFiles $FilePath  #5-010
    Get-StoredCookiesData $FilePath  #5-011
    Get-GroupPolicy $FilePath  #5-012
    Get-AuditPolicy $FilePath  #5-013
    Get-RegistryValues $FilePath  #5-014
    Get-HiddenFiles $FilePath  #5-015


    # ----------------------------------
    # Function that need work
    # ----------------------------------
    # Get-RecentAddedExeFiles $FilePath  #5-016
    # Get-ExecutableFiles $FilePath  #5-017


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-SystemHtmlPage
