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
            Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                Show-Message -Message "[INFO] Searching for $LogName Log (Event ID: $EventID)" -DarkGray

                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties) | Format-List | Out-String"

                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    $msg = "The LogFile $LogName exists, but contains no Events that match the EventID of $EventID"
                    Show-Message -Message "[INFO] $msg" -Yellow
                    Write-HtmlLogEntry -Message "$msg"
                }
                else {
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
                    Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch [System.Exception] {
                Show-Message -Message "$NoMatchingEventsMsg" -Yellow
                Write-HtmlLogEntry -Message "$NoMatchingEventsMsg" -WarningMessage
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
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
            Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromPipe
                    }

                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                    }

                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    #! 7-025 (Csv Output)
    function Get-SecurityEventsLast30DaysCsv {

        param (
            [int]$DaysBack = 30
        )

        $Name = "7-025_SecurityEventsLast30DaysAsCsv"
        $FileName = "$Name.csv"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

            Get-EventLog -LogName Security -After $((Get-Date).AddDays(-$DaysBack)) | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8

            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    function Write-EventLogSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\007\007_main.html' target='_blank'>Event Log Info</a></h3>" -Encoding UTF8

        $SectionName = "Event Log Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $EventLogHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $EventLogHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "007") {
                continue
            }
            if ([System.IO.Path]::GetExtension($File) -eq ".csv") {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $EventLogHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $EventLogHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $EventLogHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
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
