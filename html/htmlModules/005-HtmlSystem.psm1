$RegistryKeysArray = [ordered]@{

    "5-001_MapNetworkDriveMRU"                = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU",
                                                 "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU' | Select-Object -Property * -ExcludeProperty PS*")
    "5-002_InstalledAppsFromRegistry"         = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
                                                 "Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher, InstallDate, PSChildName, Comments | Sort-Object InstallDate -Descending")
    "5-003_TypedURLs"                           = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs",
                                                   "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs' | Select-Object -Property * -ExcludeProperty PS*")
    "5-004_InternetSettings"                    = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings",
                                                   "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object -Property * -ExcludeProperty PS*")
    "5-005_TrustedInternetDomains"             = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains",
                                                  "Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains' | Select-Object -Property *")
    "5-006_AppInitDllKeys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows",
                                                 "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows' | Select-Object -Property *")
    "5-007_TrustedInternetDomains"             = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' | Select-Object -Property * -ExcludeProperty PS*")
    "5-008_ActiveSetupInstalls"                = ("HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\*' | Select-Object -Property *")
    "5-009_AppPathRegKeys"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\*' | Select-Object -Property * | Sort-Object '(default)'")
    "5-010_DllsLoadedByExplorer"              = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\*\*' | Select-Object -Property *")
    "5-011_ShellUserInitValues"               = ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' | Select-Object -Property * -ExcludeProperty PS*")
    "5-012_SecurityCenterSvcValues"           = ("HKLM:\SOFTWARE\Microsoft\Security Center\Svc", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Security Center\Svc' | Select-Object -Property * -ExcludeProperty PS*")
    "5-013_DesktopAddressBarHistory"          = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' | Select-Object -Property * -ExcludeProperty PS*")
    "5-014_RunMRUKeyData"                     = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' | Select-Object -Property * -ExcludeProperty PS*")
    "5-015_StartupApplications-AdditionalForx64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run' | Select-Object -Property * -ExcludeProperty PS*")
    "5-016_StartupApplications-AdditionalForx64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run' | Select-Object -Property * -ExcludeProperty PS*")
    "5-017_StartupApplications-AdditionalForx64" = ("HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce", "Get-ItemProperty 'HKCU:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")
    "5-018_StartupApplications-AdditionalForx64" = ("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce", "Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce' | Select-Object -Property * -ExcludeProperty PS*")
    "5-019_StartMenuData"                      = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu' | Select-Object -Property * -ExcludeProperty PS*")
    "5-020_ProgramsExecutedBySessionManager" = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' | Select-Object -Property * -ExcludeProperty PS*")
    "5-021_ShellFolderData"                    = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object -Property * -ExcludeProperty PS*")
    "5-022_UserStartupShellFolder"            = ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' | Select-Object 'Startup'")
    "5-023_ApprovedShellExtensions"            = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved' | Select-Object -Property * -ExcludeProperty PS*")
    "5-024_AppCertDlls"                        = ("HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls' | Select-Object -Property * -ExcludeProperty PS*")
    "5-025_ExeFileShellCommands"              = ("HKLM:\SOFTWARE\Classes\exefile\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\exefile\shell\open\command' | Select-Object -Property * -ExcludeProperty PS*")
    "5-026_ShellOpenCommands"                  = ("HKLM:\SOFTWARE\Classes\http\shell\open\command", "Get-ItemProperty 'HKLM:\SOFTWARE\Classes\http\shell\open\command' | Select-Object '(Default)'")
    "5-027_BCDData"                             = ("HKLM:\BCD00000000\*\*\*\*", "Get-ItemProperty 'HKLM:\BCD00000000\*\*\*\*' | Select-Object Element | Select-String 'exe'| Select-Object Line")
    "5-028_LSAData"                             = ("HKLM:\SYSTEM\CurrentControlSet\Control\Lsa", "Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' | Select-Object -Property * -ExcludeProperty PS*")
    "5-029_BrowserHelperFile"                  = ("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")
    "5-030_BrowserHelperx64File"              = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\*' | Select-Object '(Default)'")
    "5-031_IEExtensions"                       = ("HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")
    "5-032_IEExtensionsWow64"                  = ("HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*", "Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Extensions\*' | Select-Object ButtonText, Icon")
    "5-033_USBDevices"                          = ("HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*", "Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*' | Select-Object FriendlyName, PSChildName, ContainerID")
}


$SystemPropertiesArray = [ordered]@{

    "5-034_OpenFiles" = ("openfiles.exe /query /FO CSV /V | Out-String", "String")
    "5-035_Win32Share" = ("Get-CimInstance -ClassName Win32_Share | Select-Object -Property *", "Pipe")
    "5-036_Win32ScheduledJobs" = ("Get-CimInstance -ClassName Win32_ScheduledJob", "Pipe")
    "5-037_ScheduledTasks"      = ("Get-ScheduledTask | Select-Object -Property * | Where-Object { ($_.State -ne 'Disabled') }", "Pipe")
    "5-038_ScheduledTaskRunInfo"  = ("Get-ScheduledTask | Where-Object { $_.State -ne 'Disabled' } | Get-ScheduledTaskInfo | Select-Object -Property *", "Pipe")
    "5-039_HotFixes"             = ("Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending", "Pipe")
    "5-040_InstalledAppsFromAppx" = ("Get-AppxPackage", "Pipe")
    "5-041_VolumeShadowCopies"    = ("Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property *", "Pipe")
    "5-042_TemporaryInternetFiles" = ("Get-ChildItem -Recurse -Force `"$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files`" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending", "Pipe")
    "5-043_StoredCookiesData"      = ("Get-ChildItem -Recurse -Force `"$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies`" | Select-Object Name | ForEach-Object { $N = $_.Name; Get-Content `"$($AppData)\Microsoft\Windows\cookies\$N`" | Select-String '/' }", "Pipe")
    "5-044_GroupPolicies"          = ("gpresult.exe /z | Out-String", "String")
    "5-045_AuditPolicy"            = ("auditpol /get /category:* | Out-String", "String")
    "5-046_HiddenFilesOnCDrive"    = ("Get-ChildItem -Path C:\ -Attributes Hidden -Recurse -Force", "Pipe")
    "5-047_Last30AddedExeFiles"    = ("Get-ChildItem -Path HKLM:\Software -Recurse -Force | Where-Object { $_.Name -like ' * .exe' } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 30 | Format-Table PSPath, LastWriteTime", "Pipe")
    "5-048_ExecutableFileList"     = ("Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq '.exe' }", "Pipe")
}


function Export-SystemHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 5-000A
    function Get-SelectRegistryValues {

        param
        (
            [string]$FilePath
        )

        foreach ($item in $RegistryKeysArray.GetEnumerator())
        {
            $Name = $item.Key
            $RegKey = $item.value[0]
            $Command = $item.value[1]

            Show-Message("Running ``$Name``") -Header -DarkGray

            try
            {
                Show-Message("[INFO] Searching for key [$RegKey]") -DarkGray
                if (-not (Test-Path -Path $RegKey))
                {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Registry Key [$RegKey] does not exist")
                }
                else
                {
                    $Data = Invoke-Expression -Command $Command | Out-String
                    if (-not $Data)
                    {
                        Show-Message("[INFO] The registry key [$RegKey] exists, but contains no data") -Yellow
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] The registry key [$RegKey] exists, but contains no data")
                    }
                    else
                    {
                        Show-Message("[INFO] Saving output from ``$Name``") -Blue
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                        Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                    }
                }
            }
            catch
            {
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 5-000B
    function Get-SystemData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $SystemPropertiesArray.GetEnumerator())
        {
            $Name = $item.Key
            $Command = $item.value[0]
            $Type = $item.value[1]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage $Name
                }
                else
                {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-SelectRegistryValues -FilePath $FilePath
    Get-SystemData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-SystemHtmlPage
