$EventLogArray = [ordered]@{

    "7-001_ApplicationLogEventID1002"    = ("Application Log Event ID 1002", "Application", 1002, "TimeCreated, ID, Message")
    "7-002_SystemLogEventID1014"         = ("System Log Event ID 1014", "System", 1014, "TimeCreated, ID, Message")
    "7-003_ApplicationLogEventID1102"    = ("Application LogEvent ID 1102", "Application", 1102, "TimeCreated, ID, Message")
    "7-004_SecurityLogEventID4616"       = ("Security Log Event ID 4616", "Security", 4616, "TimeCreated, ID, Message")
    "7-005_SecurityLogEventID4624"       = ("Security Log Event ID 4624", "Security", 4624,
                                           "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-006_SecurityLogEventID4625"       = ("Security Log Event ID 4625", "Security", 4625, "TimeCreated, ID, Message")
    "7-007_SecurityLogEventID4648"       = ("Security Log Event ID 4648", "Security", 4648, "TimeCreated, ID, Message")
    "7-008_SecurityLogEventID4656"       = ("Security Log Event ID 4656", "Security", 4656, "TimeCreated, ID, Message")
    "7-009_SecurityLogEventID4663"       = ("Security Log Event ID 4663", "Security", 4663, "TimeCreated, ID, Message")
    "7-010_SecurityLogEventID4672"       = ("Security Log Event ID 4672", "Security", 4672,
                                           "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-011_SecurityLogEventID4673"       = ("Security Log Event ID 4673", "Security", 4673, "TimeCreated, ID, Message")
    "7-012_SecurityLogEventID4674"       = ("Security Log Event ID 4674", "Security", 4674, "TimeCreated, ID, Message")
    "7-013_SecurityLogEventID4688"       = ("Security Log Event ID 4688", "Security", 4688, "TimeCreated, ID, Message")
    "7-014_SecurityLogEventID4720"       = ("Security Log Event ID 4720", "Security", 4720, "TimeCreated, ID, Message")
    "7-015_SystemLogEventID7036"         = ("System Log Event ID 7036", "System", 7036, "TimeCreated, ID, Message")
    "7-016_SystemLogEventID7045"         = ("System Log Event ID 7045", "System", 7045, "TimeCreated, ID, Message")
    "7-017_SystemLogEventID64001"        = ("System Log Event ID 64001", "System", 64001, "TimeCreated, ID, Message")
    "7-018_PSOperationalLogEventID4104"  = ("PS Operational LogEvent ID 4104",
                                           "Microsoft-Windows-PowerShell/Operational", 4104, "TimeCreated, ID, Message")
    "7-019_DiagnosticLogEventID1006"     = ("Diagnostic Log Event ID 1006",
                                           "Microsoft-Windows-Partition/Diagnostic", 1006, "TimeCreated, ID, Message")
}


$OtherEventLogPropertyArray = [ordered]@{

    "7-020_BasicListOfEventLogs"     = ("Basic List Of Event Logs",
                                       "Get-WinEvent -ListLog * | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount | Out-String",
                                       "String")
    "7-021_EventLogEnabledList"      = ("Event Log Enabled List",
                                       "Get-WinEvent -ListLog * | Where-Object -Property IsEnabled -eq 'True' | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending | Out-String", "String")
    "7-022_SecurityEventLogCounts"   = ("Security Event Log Counts",
                                       "Get-EventLog -LogName Security | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending | Out-String",
                                       "String")
    "7-023_SecurityEventsLast30Days" = ("Security Events Last 30 Days",
                                       "Get-EventLog -LogName Security -After $((Get-Date).AddDays(-[int]30)) | Out-String", "String")
    "7-024_AppInventoryEvents"       = ("App Inventory Events",
                                       "Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Out-String",
                                       "String")
    "7-025_TerminalServiceEvents"    = ("Terminal Service Events",
                                       "Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Out-String",
                                       "String")
}

function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder,
        [string]$FilesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    #7-000A
    function Get-EventLogData {

        param (
            [string]$FilePath,
            [string]$PagesFolder,
            [int]$MaxRecords = 50
        )

        foreach ($item in $EventLogArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $LogName = $item.value[1]
            $EventID = $item.value[2]
            $Properties = $item.value[3]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                Show-Message("Searching for $LogName Log (Event ID: $EventID)") -DarkGray
                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties) | Out-String"
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0) {
                    $msg = "The LogFile $LogName exists, but contains no Events that match the EventID of $EventID"
                    Show-Message("[INFO] $msg") -Yellow
                    Write-HtmlLogEntry("$msg")
                    Add-Content -Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_text'>$($msg)</div>`n</button>`n"
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                    Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch [System.Exception] {
                Show-Message("$NoMatchingEventsMsg") -Yellow
                Write-HtmlLogEntry("$NoMatchingEventsMsg") -WarningMessage
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    # 7-000B
    function Get-OtherEventLogData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $OtherEventLogPropertyArray.GetEnumerator()) {
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


    #! 7-026 (Csv Output)
    function Get-SecurityEventsLast30DaysCsv {

        param (
            [string]$FilePath,
            [int]$DaysBack = 30
        )

        $Name = "7-026_SecurityEventsLast30DaysAsCsv"
        $Title = "Security Events Last 30 Days (as Csv)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
            Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack)) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8
            Add-Content -Path $FilePath -Value "<a href='..\files\$FileName' target='_blank'>`n<button class='file_btn'>`n<div class='file_btn_text'>$($Title)</div>`n</button>`n</a>"
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-OtherEventLogData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-SecurityEventsLast30DaysCsv -FilePath $FilePath


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-EventLogHtmlPage
