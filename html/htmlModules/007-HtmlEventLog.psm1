$EventLogArray = [ordered]@{

    "7-006 Application Log Event ID 1002" = ("Application", 1002)
    "7-007 System Log Event ID 1014" = ("System", 1014)
    "7-008 Application Log Event ID 1102" = ("Application", 1102)
    "7-009 Security Log Event ID 4616" = ("Security", 4616)
    "7-010 Security Log Event ID 4624" = ("Security", 4624)
    "7-011 Security Log Event ID 4625" = ("Security", 4625)
    "7-012 Security Log Event ID 4648" = ("Security", 4648)
    "7-013 Security Log Event ID 4672" = ("Security", 4672)
    "7-014 Security Log Event ID 4672" = ("Security", 4673)
    "7-015 Security Log Event ID 4672"    = ("Security", 4674)
    "7-016 Security Log Event ID 4688" = ("Security", 4688)
    "7-017 Security Log Event ID 4720" = ("Security", 4720)
    "7-018 System Log Event ID 7036" = ("System", 7036)
    "7-019 System Log Event ID 7045" = ("System", 7045)
    "7-020 System Log Event ID 64001" = ("System", 64001)
    "7-023 PS Operational Log Event ID 4104" = ("Microsoft-Windows-PowerShell/Operational", 4104)

}


function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader


    #7-000
    function Get-EventLogData {

        param (
            [string]$FilePath
        )

        foreach ($item in $PropertiesArray.GetEnumerator()) {

            $Name = $item.Key
            $LogName = $item.value[0]
            $EventID = $item.value[1]

            Show-Message("Running '$Name'") -Header -Gray

            try {
                Show-Message("Searching for key [$RegKey]") -Gray

            }
            catch {

            }

        }
    }



    # 7-001
    function Get-EventLogListBasic {
        param ([string]$FilePath)
        $Name = "7-001 List of Event Logs"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -ListLog * | Sort-Object -Property RecordCount -Descending
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [NoMatchingEventsFound] {
                Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 7-002
    function Get-EventLogListDetailed {
        param ([string]$FilePath)
        $Name = "7-002 Event Log Detailed List"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-WinEvent -ListLog * | Where-Object { $_.IsEnabled -eq "True" } | Select-Object LogName, RecordCount, FileSize, LogMode, LogFilePath, LastWriteTime, IsEnabled | Sort-Object -Property RecordCount -Descending | Format-List
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [NoMatchingEventsFound] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
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
            $Data = Get-EventLog -LogName security -After $CutoffDate | Group-Object -Property EventID -NoElement | Sort-Object -Property Count -Descending
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [NoMatchingEventsFound] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
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
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog Security -After $CutoffDate | Format-List *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch [NoMatchingEventsFound] {
            Show-Message("$NoMatchingEventsMsg") -Yellow
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 7-005
    function Get-SecurityEventsLast30DaysCsv {
        param (
            [string]$FilePath,
            [int]$DaysBack = 30
        )
        $Name = "7-005 Security Events Last 30 Days (as Csv)"
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-EventLog Security -After $CutoffDate | ConvertTo-Csv -NoTypeInformation
    }

    #!@Array
    # 7-006
    function Get-Application1002Events {
        $Name = "7-006 Application Log Event ID 1002"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1002 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-007
    function Get-System1014Events {
        $Name = "7-007 System Log Event ID 1014"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 1014 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-008
    function Get-Application1102Events {
        $Name = "7-008 Application Log Event ID 1102"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Application"; ID = 1102 } | Select-Object TimeCreated, ID, Message | Format-List
    }

    #!@Array
    # 7-009
    function Get-Security4616Events {
        $Name = "7-009 Security Log Event ID 4616"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4616 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-010
    function Get-Security4624Events {
        $Name = "7-010 Security Log Event ID 4624"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4624 } | Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List

    }

    #!@Array
    # 7-011
    function Get-Security4625Events {
        $Name = "7-011 Security Log Event ID 4625"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4625 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-012
    function Get-Security4648Events {
        $Name = "7-012 Security Log Event ID 4648"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4648 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-013
    function Get-Security4672Events {
        $Name = "7-013 Security Log Event ID 4672"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4672 } | Select-Object TimeCreated, ID, TaskDisplayName, Message, UserId, ProcessId, ThreadId, MachineName | Format-List

    }

    #!@Array
    # 7-014
    function Get-Security4673Events {
        $Name = "7-014 Security Log Event ID 4673"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4673 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-015
    function Get-Security4674Events {
        $Name = "7-015 Security Log Event ID 4674"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4674 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-016
    function Get-Security4688Events {
        $Name = "7-016 Security Log Event ID 4688"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4688 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-017
    function Get-Security4720Events {
        $Name = "7-017 Security Log Event ID 4720"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "Security"; ID = 4720 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-018
    function Get-System7036Events {
        $Name = "7-018 System Log Event ID 7036"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7036 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    #!@Array
    # 7-019
    function Get-System7045Events {
        $Name = "7-019 System Log Event ID 7045"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 7045 } | Select-Object TimeCreated, ID, Message, UserId, ProcessId, ThreadId, MachineName | Format-List

    }

    #!@Array
    # 7-020
    function Get-System64001Events {
        $Name = "7-020 System Log Event ID 64001"
        $Data = Get-WinEvent -Max $NumberOfEntries -FilterHashtable @{ Logname = "System"; ID = 64001 } | Select-Object TimeCreated, ID, Message | Format-List

    }

    # 7-021
    function Get-AppInvEvts {
        $Name = "7-021 App Inventory Events"
        $Data = Get-WinEvent -LogName Microsoft-Windows-Application-Experience/Program-Inventory | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List

    }

    # 7-022
    function Get-TerminalServiceEvents {
        $Name = "7-022 Terminal Service Events"
        $Data = Get-WinEvent -LogName Microsoft-Windows-TerminalServices-LocalSessionManager/Operational | Select-Object TimeCreated, ID, Message | Sort-Object -Property TimeCreated -Descending | Format-List

    }

    #!@Array
    # 7-023
    function Get-PSOperational4104Events {
        $Name = "7-023 PS Operational Log Event ID 4104"
        $Data = Get-WinEvent -FilterHashtable @{ LogName = "Microsoft-Windows-PowerShell/Operational"; ID = 4104 } | Format-Table TimeCreated, Message -AutoSize

    }





    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogListBasic $FilePath
    Get-EventLogListDetailed
    Get-SecurityEventCount
    Get-SecurityEventsLast30DaysAsTxt
    Get-SecurityEventsLast30DaysCsv  # Do not pass $FilePath variable to function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-EventLogHtmlPage
