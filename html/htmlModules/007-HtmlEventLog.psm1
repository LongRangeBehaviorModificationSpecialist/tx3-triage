$EventLogArray = [ordered]@{

    "7-001_ApplicationLogEventID1002"    = ("Application", 1002, "TimeCreated, ID, Message")
    "7-002_SystemLogEventID1014"         = ("System", 1014, "TimeCreated, ID, Message")
    "7-003_ApplicationLogEventID1102"    = ("Application", 1102, "TimeCreated, ID, Message")
    "7-004_SecurityLogEventID4616"       = ("Security", 4616, "TimeCreated, ID, Message")
    "7-005_SecurityLogEventID4624"       = ("Security", 4624, "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-006_SecurityLogEventID4625"       = ("Security", 4625, "TimeCreated, ID, Message")
    "7-007_SecurityLogEventID4648"       = ("Security", 4648, "TimeCreated, ID, Message")
    "7-008_SecurityLogEventID4656"       = ("Security", 4656, "TimeCreated, ID, Message")
    "7-009_SecurityLogEventID4663"       = ("Security", 4663, "TimeCreated, ID, Message")
    "7-010_SecurityLogEventID4672"       = ("Security", 4672, "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-011_SecurityLogEventID4673"       = ("Security", 4673, "TimeCreated, ID, Message")
    "7-012_SecurityLogEventID4674"       = ("Security", 4674, "TimeCreated, ID, Message")
    "7-013_SecurityLogEventID4688"       = ("Security", 4688, "TimeCreated, ID, Message")
    "7-014_SecurityLogEventID4720"       = ("Security", 4720, "TimeCreated, ID, Message")
    "7-015_SystemLogEventID7036"         = ("System", 7036, "TimeCreated, ID, Message")
    "7-016_SystemLogEventID7045"         = ("System", 7045, "TimeCreated, ID, Message")
    "7-017_SystemLogEventID64001"        = ("System", 64001, "TimeCreated, ID, Message")
    "7-018_PS OperationalLogEventID4104" = ("Microsoft-Windows-PowerShell/Operational", 4104, "TimeCreated, ID, Message")
    "7-019_DiagnosticLogEventID1006"     = ("Microsoft-Windows-Partition/Diagnostic", 1006, "TimeCreated, ID, Message")
}


$OtherEventLogPropertyArray = [ordered]@{

    "7-020_BasicListOfEventLogs"     = ("Get-WinEvent -ListLog * | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending", "Pipe")
    "7-021_EventLogEnabledList"      = ("Get-WinEvent -ListLog * | Where-Object { $_.IsEnabled -eq 'True' } | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending", "Pipe")
    "7-022_SecurityEventLogCounts"   = ("Get-EventLog -LogName Security | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending", "Pipe")
    "7-023_SecurityEventsLast30Days" = ("Get-EventLog -LogName Security -After $((Get-Date).AddDays(-30))", "Pipe")
    "7-024_AppInventoryEvents"       = ("Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending", "Pipe")
    "7-025_TerminalServiceEvents"    = ("Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending", "Pipe")
}

function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    #7-000A
    function Get-EventLogData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder,
            [int]$MaxRecords = 50
        )

        foreach ($item in $EventLogArray.GetEnumerator())
        {
            $Name = $item.Key
            $LogName = $item.value[0]
            $EventID = $item.value[1]
            $Properties = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                Show-Message("Searching for $LogName Log (Event ID: $EventID)") -DarkGray
                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties)"
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Show-Message("[INFO] The LogFile $LogName exists, but contains no Events that match the EventID of $EventID") -Yellow
                }
                else
                {
                    Show-Message("[INFO] Saving output from ``$Name``") -Blue
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                }
            }
            catch [System.Exception]
            {
                Show-Message("$NoMatchingEventsMsg") -Yellow
                Write-HtmlLogEntry("$NoMatchingEventsMsg") -WarningMessage
            }
            catch
            {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $ErrorMessage") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 7-000B
    function Get-OtherEventLogData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $OtherEventLogPropertyArray.GetEnumerator())
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
                    Show-Message("No data found for ``$Name``") -Yellow
                    Write-HtmlLogEntry("No data found for ``$Name``")
                }
                else
                {
                    Show-Message("[INFO] Saving output from ``$Name``") -Blue
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                }
            }
            catch
            {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $ErrorMessage") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    #! 7-026 (Csv Output)
    function Get-SecurityEventsLast30DaysCsv {

        param
        (
            [string]$FilePath,
            [int]$DaysBack = 30
        )

        $Name = "7-005_SecurityEventsLast30DaysAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack)) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from ``$Name``") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-OtherEventLogData-FilePath $FilePath -PagesFolder $PagesFolder
    Get-SecurityEventsLast30DaysCsv  # Do not pass $FilePath variable to function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-EventLogHtmlPage
