
[ordered]@{

    "5-001_Map_Network_Drive_MRU"     = ("Map Network Drive MRU",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property *");
    "5-002_Installed_Apps"            = ("Installed Apps (System-Wide installs)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-003_Installed_Apps"            = ("Installed Apps (32-bit on 64-bit OS)",
                                        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
                                        "Get-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-004_Installed_Apps"            = ("Installed Apps (User-specific)",
                                        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                        "Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, UninstallString, Comments | Sort-Object InstallDate -Descending");
    "5-005_Typed_URLs"                = ("Typed URLs",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property *");
    "5-006_Internet_Settings"         = ("Internet Settings",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property *");
    "5-007_Trusted_Internet_Domains"  = ("Trusted Internet Domains (HKCU)",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains",
                                        "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property *");
    "5-008_Trusted_Internet_Domains"  = ("Trusted Internet Domains (HKLM)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object '(Default)'");
    "5-008_App_Init_Dll_Keys"         = ("App Init Dll Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property *");
    "5-010_Active_Setup_Installs"     = ("Active Setup Installs",
                                        "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property *");
    "5-011_App_Path_Reg_Keys"         = ("App Path Reg Keys",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)'");
    "5-012_Dlls_Loaded_By_Explorer"   = ("Dlls Loaded By Explorer",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property *");
    "5-013_Shell_User_Init_Values"    = ("Shell User Init Values",
                                        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property *");
    "5-014_Security_Center_Svc_Values" = ("Security Center Svc Values",
                                        "HKLM:\SOFTWARE\Microsoft\Security Center\Svc",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property *");
    "5-015_Desktop_Address_Bar_History" = ("Desktop Address Bar History",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property *");
    "5-016_Run_MRU_Key_Data"          = ("Run MRU Key Data",
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
    "5-021_Start_Menu_Data"           = ("Start Menu Data",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * | Format-List");
    "5-022_ProgramsExeSessionManager" = ("Programs Executed By Session Manager",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property *");
    "5-023_Shell_Folder_Data"         = ("Shell Folder Data (HKLM)",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property *");
    "5-024_UserStartupShellFolder"    = ("Shell Folder Data (HKCU)",
                                        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'");
    "5-025_ApprovedShellExtensions"   = ("Approved Shell Extensions",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property *");
    "5-026_App_Cert_Dlls"             = ("App Cert Dlls",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property *");
    "5-027_ExeFileShellCommands"      = ("Exe File Shell Commands",
                                        "HKLM:\SOFTWARE\Classes\exefile\shell\open\command",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property *");
    "5-028_Shell_Open_Commands"       = ("Shell Open Commands",
                                        "HKLM:\SOFTWARE\Classes\http\shell\open\command",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\http\shell\open\command'");
    "5-029_BCD_Data"                  = ("BCD Data",
                                        "HKLM:\BCD00000000\*\*\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line");
    "5-030_LSA_Data"                  = ("LSA Data",
                                        "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property *");
    "5-031_Browser_Helper_File"       = ("Browser Helper File",
                                        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'");
    "5-032_Browser_Helper_x64_File"   = ("Browser Helper x64 File",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*'");
    "5-033_IE_Extensions"             = ("IE Extensions",
                                        "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon");
    "5-034_IE_Extensions_Wow64"       = ("IE Extensions Wow64",
                                        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*",
                                        "Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon | Format-List");
    "5-035_USB_Devices"               = ("**USB Devices",
                                        "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*",
                                        "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID | Format-List | Out-String");
}