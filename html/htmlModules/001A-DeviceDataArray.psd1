[ordered]@{

    "1-001_ComputerDetails"          = ("Computer Details",
                                       "Get-ComputerDetails | Out-String",
                                       "String")
    "1-002_TPMDetails"               = ("TPM Details",
                                       "Get-TPMDetails | Out-String",
                                       "String")
    "1-003_PSInfo"                   = ("PS Info",
                                       ".\bin\PsInfo.exe -accepteula -s -h -d | Out-String",
                                       "String")
    "1-004_PSDrive"                  = ("PS Drive Info",
                                       "Get-PSDrive -PSProvider FileSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-005_Win32LogicalDisk"         = ("Win32_LogicalDisk",
                                       "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property * | Out-String",
                                       "String")
    "1-006_ComputerInfo"             = ("ComputerInfo",
                                       "Get-ComputerInfo | Out-String",
                                       "String")
    "1-007_SystemInfo"               = ("systeminfo",
                                       "systeminfo /FO CSV | ConvertFrom-Csv | Select-Object * | Out-String",
                                       "String")
    "1-008_Win32ComputerSystem"      = ("Win32_ComputerSystem",
                                       "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-009_Win32OperatingSystem"     = ("Win32_OperatingSystem",
                                       "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-010 Win32PhysicalMemory"      = ("Win32_PhysicalMemory",
                                       "Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property * | Out-String",
                                       "String")
    "1-011_EnvVars"                  = ("EnvVars",
                                       "Get-ChildItem -Path env: | Format-List | Out-String",
                                       "String")
    "1-012_DiskInfo"                 = ("Disk Info",
                                       "Get-Disk | Select-Object -Property * | Sort-Object -Property DiskNumber | Out-String",
                                       "String")
    "1-013_Partitions"               = ("Partitions",
                                       "Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber | Out-String",
                                       "String")
    "1-014_Win32DiskPartitions"      = ("Win32_DiskPartitions",
                                       "Get-CimInstance -ClassName Win32_DiskPartition | Select-Object -Property * | Sort-Object -Property Name | Format-List | Out-String",
                                       "String")
    "1-015_Win32StartupCommand"      = ("Win32_StartupCommand",
                                       "Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property * | Out-String",
                                       "String")
    "1-016_SoftwareLicensingService" = ("Software Licensing Service",
                                       "Get-WmiObject -ClassName SoftwareLicensingService | Select-Object -Property * | Out-String",
                                       "String")
    "1-017_Win32Bios"                = ("Win32_Bios",
                                       "Get-WmiObject -ClassName Win32_Bios | Select-Object -Property * | Out-String",
                                       "String")
    "1-018_Win32PnPEntity"           = ("Win32_PnPEntity",
                                       "Get-CimInstance Win32_PnPEntity | Select-Object -Property * | Out-String",
                                       "String")
    "1-019_Win32Product"             = ("Win32_Product",
                                       "Get-WmiObject Win32_Product | Select-Object -Property * | Out-String",
                                       "String")
    "1-020_DiskAllocation"           = ("FSUtil Volume",
                                       "fsutil volume allocationReport C: | Out-String",
                                       "String")
}