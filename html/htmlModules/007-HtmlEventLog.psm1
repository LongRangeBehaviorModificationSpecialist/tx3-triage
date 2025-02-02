$EventLogArray = [ordered]@{

    "7-000-A Application Log Event ID 1002"    = ("Application", 1002, "TimeCreated, ID, Message")
    "7-000-B System Log Event ID 1014"         = ("System", 1014, "TimeCreated, ID, Message")
    "7-000-C Application Log Event ID 1102"    = ("Application", 1102, "TimeCreated, ID, Message")
    "7-000-D Security Log Event ID 4616"       = ("Security", 4616, "TimeCreated, ID, Message")
    "7-000-E Security Log Event ID 4624"       = ("Security", 4624, "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-000-F Security Log Event ID 4625"       = ("Security", 4625, "TimeCreated, ID, Message")
    "7-000-G Security Log Event ID 4648"       = ("Security", 4648, "TimeCreated, ID, Message")
    "7-000-H Security Log Event ID 4672"       = ("Security", 4672, "TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName")
    "7-000-I Security Log Event ID 4673"       = ("Security", 4673, "TimeCreated, ID, Message")
    "7-000-J Security Log Event ID 4674"       = ("Security", 4674, "TimeCreated, ID, Message")
    "7-000-K Security Log Event ID 4688"       = ("Security", 4688, "TimeCreated, ID, Message")
    "7-000-L Security Log Event ID 4720"       = ("Security", 4720, "TimeCreated, ID, Message")
    "7-000-M System Log Event ID 7036"         = ("System", 7036, "TimeCreated, ID, Message")
    "7-000-N System Log Event ID 7045"         = ("System", 7045, "TimeCreated, ID, Message")
    "7-000-O System Log Event ID 64001"        = ("System", 64001, "TimeCreated, ID, Message")
    "7-000-P PS Operational Log Event ID 4104" = ("Microsoft-Windows-PowerShell/Operational", 4104, "TimeCreated, ID, Message")

}

$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf

function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    #7-000
    function Get-EventLogData {

        param (
            [string]$FilePath,
            [int]$MaxRecords = 50
        )

        foreach ($item in $EventLogArray.GetEnumerator()) {

            $Name = $item.Key
            $LogName = $item.value[0]
            $EventID = $item.value[1]
            $Properties = $item.value[2]

            Show-Message("Running '$Name'") -Header -Gray

            try {
                Show-Message("Searching for $LogName Log (Event ID: $EventID)") -Gray

                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties)"

                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Show-Message("[INFO] The LogFile $LogName exists, but contains no Events that match the EventID of $EventID") -Yellow
                }
                else {
                    Show-Message("[INFO] Saving output from '$Name'") -Blue
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch [System.Exception] {
                Show-Message("$NoMatchingEventsMsg") -Yellow
                # Write-LogEntry("$NoMatchingEventsMsg") -WarningMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 7-001
    function Get-EventLogListBasic {
        param ([string]$FilePath)
        $Name = "7-001 List of Event Logs"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -ListLog * | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Exception] {
                Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 7-002
    function Get-EventLogEnabledList {
        param ([string]$FilePath)
        $Name = "7-002 Event Log Enabled List"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -ListLog * | Where-Object { $_.IsEnabled -eq "True" } | Select-Object -Property LogName, LogType, LogIsolation, RecordCount, FileSize, LastAccessTime, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Exception] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 7-003
    function Get-SecurityEventCount {
        param (
            [string]$FilePath,
            [int]$DaysBack = 30
        )
        $Name = "7-003 Security Event Log Counts"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog -LogName Security -After $CutoffDate | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Exception] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 7-004
    function Get-SecurityEventsLast30DaysAsTxt {
        param (
            [string]$FilePath,
            [int]$DaysBack = 30
        )
        $Name = "7-004 Security Events (Last 30 Days)"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack))
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [System.Exception] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 7-005
    function Get-SecurityEventsLast30DaysCsv {
        param (
            # [string]$FilePath,
            [int]$DaysBack = 30
        )
        $Name = "7-005 Security Events Last 30 Days (as Csv)"
        Show-Message("Running '$Name' command") -Header -Gray
        $FileName = "7-005_SecurityEventsLast30Days.csv"
        try{
            # $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack)) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from '$Name'") -Blue

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # 7-006
    function Get-AppInvEvts {
        param ([string]$FilePath)
        $Name = "7-006 App Inventory Events"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending
            if (-not $Data) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 7-007
    function Get-TerminalServiceEvents {
        param ([string]$FilePath)
        $Name = "7-007 Terminal Service Events"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending
            if (-not $Data) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in Module ``$ModuleName`` [Ln: $($PSItem.InvocationInfo.ScriptLineNumber)] - $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogData $FilePath
    Get-EventLogListBasic $FilePath
    Get-EventLogEnabledList $FilePath
    Get-SecurityEventCount $FilePath
    Get-SecurityEventsLast30DaysAsTxt $FilePath
    Get-SecurityEventsLast30DaysCsv  # Do not pass $FilePath variable to function
    Get-AppInvEvts $FilePath
    Get-TerminalServiceEvents $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-EventLogHtmlPage
