[ordered]@{

    "5-036_OpenFiles"              = ("Open Files",
                                     "openfiles.exe /query /FO CSV /V | Out-String",
                                     "String");
    "5-037_Win32Share"             = ("Win32 Share",
                                     "Get-CimInstance -ClassName Win32_Share | Select-Object -Property * | Format-List | Out-String",
                                     "String");
    "5-038_Win32ScheduledJobs"     = ("Win32 Scheduled Jobs",
                                     "Get-CimInstance -ClassName Win32_ScheduledJob | Format-List | Out-String",
                                     "String");
    "5-039_ScheduledTasks"         = ("Scheduled Tasks",
                                     "Get-ScheduledTask | Select-Object -Property * | Where-Object -Property State -ne 'Disabled' | Format-List | Out-String",
                                     "String");
    "5-040_ScheduledTaskRunInfo"   = ("Scheduled Task Run Info",
                                     "Get-ScheduledTask | Where-Object -Property State -ne 'Disabled' | Get-ScheduledTaskInfo | Select-Object -Property * | Format-List | Out-String",
                                     "String");
    "5-041_HotFixes"               = ("Hot Fixes",
                                     "Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending | Format-List | Out-String",
                                     "String");
    "5-042_InstalledAppsFromAppx"  = ("Installed Apps From Appx",
                                     "Get-AppxPackage | Format-List | Out-String",
                                     "String");
    "5-043_VolumeShadowCopies"     = ("Volume Shadow Copies",
                                     "Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property * | Format-List | Out-String",
                                     "String");
    "5-044_GroupPolicies"          = ("Group Policies",
                                     "gpresult.exe /z | Out-String",
                                     "String");
    "5-045_AuditPolicy"            = ("Audit Policy",
                                     "auditpol /get /category:* | Out-String",
                                     "String");
    "5-046_HiddenFilesOnCDrive"    = ("Hidden Files On C:\ Drive",
                                     "Get-ChildItem -Path C:\ -Attributes Hidden -Recurse -Force | Out-String",
                                     "String");
    # "5-047_Last30AddedExeFiles"    = ("Last 30 Added Exe Files",
    #                                  "Get-ChildItem -Path 'HKLM:\Software' -Recurse -Force | Where-Object -Property Name -like '*.exe' | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 30 | Format-Table PSPath, LastWriteTime | Out-String",
    #                                  "String");
    # "5-048_ExecutableFileList"     = ("Executable File List",
    #                                  "Get-ChildItem -Path C:\ -File -Recurse -Force | Where-Object -Property Extension -eq '.exe' | Out-String",
    #                                  "String")
}