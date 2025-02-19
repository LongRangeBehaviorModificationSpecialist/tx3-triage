function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    # Import the hashtables from the data files
    $EventLogArray = Import-PowerShellDataFile -Path "$PSScriptRoot\007A-EventLogArray.psd1"
    $OtherEventLogPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\007B-EventLogOtherArray.psd1"

    $EventLogHtmlMainFile = New-Item -Path "$OutputFolder\007_main.html" -ItemType File -Force

    #7-000A
    function Get-EventLogData {

        param (
            [int]
            $MaxRecords = 50
        )

        foreach ($item in $EventLogArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $LogName = $item.value[1]
            $EventID = $item.value[2]
            $Properties = $item.value[3]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                Show-Message("[INFO] Searching for $LogName Log (Event ID: $EventID)") -DarkGray

                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties) | Format-List | Out-String"

                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    $msg = "The LogFile $LogName exists, but contains no Events that match the EventID of $EventID"
                    Show-Message("[INFO] $msg") -Yellow
                    Write-HtmlLogEntry("$msg")
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                    Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch [System.Exception] {
                Show-Message("$NoMatchingEventsMsg") -Yellow
                Write-HtmlLogEntry("$NoMatchingEventsMsg") -WarningMessage
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Path) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    # 7-000B
    function Get-OtherEventLogData {

        foreach ($item in $OtherEventLogPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }

                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }

                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Path) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    #! 7-025 (Csv Output)
    function Get-SecurityEventsLast30DaysCsv {

        param (
            [int]$DaysBack = 30
        )

        $Name = "7-025_SecurityEventsLast30DaysAsCsv"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack)) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Path) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    function Write-EventLogSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "<h3><a href='results\007\007_main.html' target='_blank'>Event Log Info</a></h4>"

        $SectionName = "Event Log Information Section"

        $SectionHeader = "
        <h3 class='section_header'>$($SectionName)</h3>
        <div class='number_list'>"

        Add-Content -Path $EventLogHtmlMainFile -Value $HtmlHeader
        Add-Content -Path $EventLogHtmlMainFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "007") {
                continue
            }
            if ([System.IO.Path]::GetExtension($File) -eq ".csv") {
                $FileNameEntry = "<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $EventLogHtmlMainFile -Value $FileNameEntry
            }
            else {
                $FileNameEntry = "<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $EventLogHtmlMainFile -Value $FileNameEntry
            }
        }

        Add-Content -Path $EventLogHtmlMainFile -Value "</div>`n</body>`n</html>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogData
    Get-OtherEventLogData
    Get-SecurityEventsLast30DaysCsv


    Write-EventLogSectionToMain
}


Export-ModuleMember -Function Export-EventLogHtmlPage
