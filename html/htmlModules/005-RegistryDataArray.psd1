
[ordered]@{

    "5-001_MapNetworkDriveMRU"        = ("Map Network Drive MRU",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property *");
    "5-002_InstalledApps"             = ("Installed Apps (System-Wide installs)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-003_InstalledApps"             = ("Installed Apps (32-bit on 64-bit OS)",
                                        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
                                        "Get-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-004_InstalledApps"             = ("Installed Apps (User-specific)",
                                        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                        "Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-005_TypedURLs"                 = ("Typed URLs",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property *");
    "5-006_InternetSettings"          = ("Internet Settings",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property *");
    "5-007_TrustedInternetDomains"    = ("Trusted Internet Domains (HKCU)",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains",
                                        "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property *");
    "5-008_TrustedInternetDomains"    = ("Trusted Internet Domains (HKLM)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object '(Default)'");
    "5-008_AppInitDllKeys"            = ("App Init Dll Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property *");
    "5-010_ActiveSetupInstalls"       = ("Active Setup Installs",
                                        "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property *");
    "5-011_AppPathRegKeys"            = ("App Path Reg Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)'");
    "5-012_DllsLoadedByExplorer"      = ("Dlls Loaded By Explorer",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property *");
    "5-013_ShellUserInitValues"       = ("Shell User Init Values",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property *");
    "5-014_SecurityCenterSvcValues"   = ("Security Center Svc Values",
                                        "HKLM:\SOFTWARE\Microsoft\Security Center\Svc",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property *");
    "5-015_DesktopAddressBarHistory"  = ("Desktop Address Bar History",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property *");
    "5-016_RunMRUKeyData"             = ("Run MRU Key Data",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' | Select-Object -Property *");
    "5-017_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run' | Select-Object -Property *");
    "5-018_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run' | Select-Object -Property *");
    "5-019_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property *");
    "5-020_StartupApplicationsForx64" = ("Startup Applications - Additional For x64",
                                        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
                                        "Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property *");
    "5-021_StartMenuData"             = ("Start Menu Data",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * | Format-List");
    "5-022_ProgramsExeSessionManager" = ("Programs Executed By Session Manager",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property *");
    "5-023_ShellFolderData"           = ("Shell Folder Data (HKLM)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property *");
    "5-024_UserStartupShellFolder"    = ("Shell Folder Data (HKCU)",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'");
    "5-025_ApprovedShellExtensions"   = ("Approved Shell Extensions",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property *");
    "5-026_AppCertDlls"               = ("App Cert Dlls",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property *");
    "5-027_ExeFileShellCommands"      = ("Exe File Shell Commands",
                                        "HKLM:\SOFTWARE\Classes\exefile\shell\open\command",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property *");
    "5-028_ShellOpenCommands"         = ("Shell Open Commands",
                                        "HKLM:\SOFTWARE\Classes\http\shell\open\command",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\http\shell\open\command'");
    "5-029_BCDData"                   = ("BCD Data",
                                        "HKLM:\BCD00000000\*\*\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line");
    "5-030_LSAData"                   = ("LSA Data",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property *");
    "5-031_BrowserHelperFile"         = ("Browser Helper File",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'");
    "5-032_BrowserHelperx64File"      = ("Browser Helper x64 File",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*'");
    "5-033_IEExtensions"              = ("IE Extensions",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon");
    "5-034_IEExtensionsWow64"         = ("IE Extensions Wow64",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon | Format-List");
    "5-035_USBDevices"                = ("**USB Devices",
                                        "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID | Format-List | Out-String");
}