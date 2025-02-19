[ordered]@{

    "5-036_Open_Files"              = ("Open Files",
                                      "openfiles.exe /query /FO CSV /V | Out-String",
                                      "String");
    "5-037_Win32_Share"             = ("Win32 Share",
                                      "Get-CimInstance -ClassName Win32_Share | Select-Object -Property * | Format-List | Out-String",
                                      "String");
    "5-038_Win32_Scheduled_Jobs"    = ("Win32 Scheduled Jobs",
                                      "Get-CimInstance -ClassName Win32_ScheduledJob | Format-List | Out-String",
                                      "String");
    "5-039_Scheduled_Tasks"         = ("Scheduled Tasks",
                                      "Get-ScheduledTask | Select-Object -Property * | Where-Object -Property State -ne 'Disabled' | Format-List | Out-String",
                                      "String");
    "5-040_Scheduled_Task_Run"      = ("Scheduled Task Run Info",
                                      "Get-ScheduledTask | Where-Object -Property State -ne 'Disabled' | Get-ScheduledTaskInfo | Select-Object -Property * | Format-List | Out-String",
                                      "String");
    "5-041_Hot_Fixes"               = ("Hot Fixes",
                                      "Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending | Format-List | Out-String",
                                      "String");
    "5-042_Apps_From_Appx"          = ("Installed Apps From Appx",
                                      "Get-AppxPackage | Format-List | Out-String",
                                      "String");
    "5-043_Volume_Shadow_Copies"    = ("Volume Shadow Copies",
                                      "Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property * | Format-List | Out-String",
                                      "String");
    "5-044_Group_Policies"          = ("Group Policies",
                                      "gpresult.exe /z | Out-String",
                                      "String");
    "5-045_Audit_Policy"            = ("Audit Policy",
                                      "auditpol /get /category:* | Out-String",
                                      "String");
    "5-046_Hidden_Files_On_C_Drive" = ("Hidden Files On C:\ Drive",
                                      "Get-ChildItem -Path C:\ -Attributes Hidden -Recurse -Force | Out-String",
                                      "String");
    # "5-047_Last_30_Added_Exe_Files" = ("Last 30 Added Exe Files",
    #                                   "Get-ChildItem -Path 'HKLM:\Software' -Recurse -Force | Where-Object -Property Name -like '*.exe' | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 30 | Format-Table PSPath, LastWriteTime | Out-String",
    #                                   "String");
    # "5-048_Executable_File_List"    = ("Executable File List",
    #                                   "Get-ChildItem -Path C:\ -File -Recurse -Force | Where-Object -Property Extension -eq '.exe' | Out-String",
    #                                   "String")
}