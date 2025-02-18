[ordered]@{

    "7-020_BasicListOfEventLogs"   = ("Basic List Of Event Logs",
                                     "Get-WinEvent -ListLog * | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount | Format-List | Out-String",
                                     "String")
    "7-021_EventLogEnabledList"    = ("Enabled Event Log List",
                                     "Get-WinEvent -ListLog * | Where-Object -Property IsEnabled -eq 'True' | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending | Format-List | Out-String",
                                     "String")
    "7-022_SecurityEventLogCounts" = ("Security Event Log Counts",
                                     "Get-EventLog -LogName Security | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending | Format-List | Out-String",
                                     "String")
    "7-023_AppInventoryEvents"     = ("App Inventory Events",
                                     "Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List | Out-String",
                                     "String")
    "7-024_TerminalServiceEvents"  = ("Terminal Service Events",
                                     "Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List | Out-String",
                                     "String")
}