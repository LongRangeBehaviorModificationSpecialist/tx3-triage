[ordered]@{

    "4-001_RunningProcessesAll"  = ("Win32_Process",
                                   "Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName | Out-String",
                                   "String");
    "4-002 SvcHostsAndProcesses" = ("Svc Hosts & Processes",
                                   "Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq 'svchost.exe' | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path | Out-String",
                                   "String");
    "4-003_DriverQuery"          = ("DriverQuery",
                                   "driverquery | Out-String",
                                   "String");
    "4-004_WMICProcessListFull"  = ("Full Process List (wmic)",
                                   "wmic process list full | Out-String",
                                   "String");
    "4-005_ActiveServices"       = ("Active Windows Services",
                                   "net start | Out-String",
                                   "String")
    "4-006_TaskList"             = ("Services & Assoc Processes",
                                   "tasklist /svc | Out-String",
                                   "String")
}