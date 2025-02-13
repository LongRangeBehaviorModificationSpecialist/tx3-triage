$RegistryKeysArray = [ordered]@{

    "5-001_MapNetworkDriveMRU"        = ("Map Network Drive MRU",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property * -ExcludeProperty PS*")
    "5-002_InstalledAppsFromRegistry" = ("Installed Apps From Registry",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, Comments | Sort-Object InstallDate -Descending")
    "5-003_TypedURLs"                 = ("Typed URLs",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property * -ExcludeProperty PS*")
    "5-004_InternetSettings"          = ("Internet Settings",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property * -ExcludeProperty PS*")
    "5-005_TrustedInternetDomains"    = ("Trusted Internet Domains (HKCU)",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains",
                                        "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property *")
    "5-006_AppInitDllKeys"            = ("App Init Dll Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property *")
    "5-007_TrustedInternetDomains"    = ("Trusted Internet Domains (HKLM)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object -Property * -ExcludeProperty PS*")
    "5-008_ActiveSetupInstalls"       = ("Active Setup Installs",
                                        "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property *")
    "5-009_AppPathRegKeys"            = ("App Path Reg Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)'")
    "5-010_DllsLoadedByExplorer"      = ("Dlls Loaded By Explorer",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property *")
    "5-011_ShellUserInitValues"       = ("Shell User Init Values",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property * -ExcludeProperty PS*")
    "5-012_SecurityCenterSvcValues"   = ("Security Center Svc Values",
                                        "HKLM:\SOFTWARE\Microsoft\Security Center\Svc",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property * -ExcludeProperty PS*")
    "5-013_DesktopAddressBarHistory"  = ("Desktop Address Bar History",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property * -ExcludeProperty PS*")
    "5-014_RunMRUKeyData"             = ("Run MRU Key Data",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' | Select-Object -Property * -ExcludeProperty PS*")
    "5-015_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run' | Select-Object -Property * -ExcludeProperty PS*")
    "5-016_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run' | Select-Object -Property * -ExcludeProperty PS*")
    "5-017_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")
    "5-018_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                         "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")
    "5-019_StartMenuData"             = ("Start Menu Data",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * -ExcludeProperty PS*")
    "5-020_ProgramsExeSessionManager" = ("Programs Executed By Session Manager",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager",
                                        "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property * -ExcludeProperty PS*")
    "5-021_ShellFolderData"           = ("Shell Folder Data",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property * -ExcludeProperty PS*")
    "5-022_UserStartupShellFolder"    = ("User Startup Shell Folder",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object 'Startup'")
    "5-023_ApprovedShellExtensions"   = ("Approved Shell Extensions",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property * -ExcludeProperty PS*")
    "5-024_AppCertDlls"               = ("App Cert Dlls",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls",
                                        "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property * -ExcludeProperty PS*")
    "5-025_ExeFileShellCommands"      = ("Exe File Shell Commands",
                                        "HKLM:\SOFTWARE\Classes\exefile\shell\open\command",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property * -ExcludeProperty PS*")
    "5-026_ShellOpenCommands"          = ("Shell Open Commands",
                                        "HKLM:\SOFTWARE\Classes\http\shell\open\command",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\http\shell\open\command' | Select-Object '(Default)'")
    "5-027_BCDData"                   = ("BCD Data", "HKLM:\BCD00000000\*\*\*\*",
                                        "Get-ItemProperty 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line")
    "5-028_LSAData"                   = ("LSA Data",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa",
                                        "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property * -ExcludeProperty PS*")
    "5-029_BrowserHelperFile"         = ("Browser Helper File",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")
    "5-030_BrowserHelperx64File"      = ("Browser Helper x64 File",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")
    "5-031_IEExtensions"              = ("IE Extensions",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")
    "5-032_IEExtensionsWow64"         = ("IE Extensions Wow64",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")
    "5-033_USBDevices"                = ("USB Devices",
                                        "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID")
}


$SystemPropertiesArray = [ordered]@{

    "5-034_OpenFiles"              = ("Open Files",
                                     "openfiles.exe /query /FO CSV /V | Out-String",
                                     "String")
    "5-035_Win32Share"             = ("Win32 Share",
                                     "Get-CimInstance -ClassName Win32_Share | Select-Object -Property * | Out-String", "String")
    "5-036_Win32ScheduledJobs"     = ("Win32 Scheduled Jobs",
                                     "Get-CimInstance -ClassName Win32_ScheduledJob | Out-String",
                                     "String")
    "5-037_ScheduledTasks"         = ("Scheduled Tasks",
                                     "Get-ScheduledTask | Select-Object -Property * | Where-Object -Property State -ne 'Disabled' | Out-String",
                                     "String")
    "5-038_ScheduledTaskRunInfo"   = ("Scheduled Task Run Info",
                                     "Get-ScheduledTask | Where-Object -Property State -ne 'Disabled' | Get-ScheduledTaskInfo | Select-Object -Property * | Out-String",
                                     "String")
    "5-039_HotFixes"               = ("Hot Fixes",
                                     "Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending | Out-String", "String")
    "5-040_InstalledAppsFromAppx"  = ("Installed Apps From Appx",
                                     "Get-AppxPackage | Out-String",
                                     "String")
    "5-041_VolumeShadowCopies"     = ("Volume Shadow Copies",
                                     "Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property * | Out-String",
                                     "String")
    "5-042_TemporaryInternetFiles" = ("Temporary Internet Files",
                                     "Get-ChildItem -Recurse -Force `"$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files`" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending | Out-String",
                                     "String")
    "5-043_StoredCookiesData"      = ("Stored Cookies",
                                     "Get-ChildItem -Recurse -Force `"$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies`" | Select-Object Name | ForEach-Object { $N = $_.Name; Get-Content `"$($AppData)\Microsoft\Windows\cookies\$N`" | Select-String '/' } | Out-String", "String")
    "5-044_GroupPolicies"          = ("Group Policies",
                                     "gpresult.exe /z | Out-String",
                                     "String")
    "5-045_AuditPolicy"            = ("Audit Policy",
                                     "auditpol /get /category:* | Out-String",
                                     "String")
    "5-046_HiddenFilesOnCDrive"    = ("Hidden Files On C:\ Drive",
                                     "Get-ChildItem -Path C:\ -Attributes Hidden -Recurse -Force | Out-String",
                                     "String")
    "5-047_Last30AddedExeFiles"    = ("Last 30 Added Exe Files",
                                     "Get-ChildItem -Path HKLM:\Software -Recurse -Force | Where-Object -Property Name -like '*.exe' | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 30 | Format-Table PSPath, LastWriteTime | Out-String",
                                     "String")
    "5-048_ExecutableFileList"     = ("Executable File List",
                                     "Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object -Property Extension -eq '.exe' | Out-String",
                                     "String")
}


function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    # 5-000A
    function Get-SelectRegistryValues {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $RegistryKeysArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $RegKey = $item.value[1]
            $Command = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                Show-Message("[INFO] Searching for key [$RegKey]") -DarkGray
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Registry Key [$RegKey] does not exist")
                    Add-Content-Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_btn_text'>$($Title)&ensp;Registry Key [$RegKey] does not exist on the examined machine</div>`n</button>"
                }
                else {
                    $Data = Invoke-Expression -Command $Command | Out-String
                    if (-not $Data) {
                        $msg = "The registry key [$RegKey] exists, but contains no data"
                        Show-Message("[INFO] $msg") -Yellow
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $msg")
                        Add-Content-Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_btn_text'>$($Title)&ensp;$($msg)</div>`n</button>`n"
                    }
                    else {
                        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                        Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                    }
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }

    # 5-000B
    function Get-SystemData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $SystemPropertiesArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-SelectRegistryValues -FilePath $FilePath -PagesFolder $PagesFolder
    Get-SystemData -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-SystemHtmlPage
