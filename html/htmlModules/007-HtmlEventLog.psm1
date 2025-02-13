function Export-EventLogHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder,
        [string]$FilesFolder
    )

    # Import the hashtables from the data files
    $EventLogArray = Import-PowerShellDataFile -Path "$PSScriptRoot\007-EventLogArray.psd1"
    $OtherEventLogPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\007-EventLogOtherArray.psd1"

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='item_table'>"  # Add this to display the results in a flexbox

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
                $Command = "Get-WinEvent -Max $MaxRecords -FilterHashtable @{ Logname = '$($LogName)'; ID = $($EventID) } | Select-Object -Property $($Properties) | Format-List | Out-String"
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0) {
                    $msg = "The LogFile $LogName exists, but contains no Events that match the EventID of $EventID"
                    Show-Message("[INFO] $msg") -Yellow
                    Write-HtmlLogEntry("$msg")
                    Add-Content -Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_text'>$($msg)</div>`n</button>`n"
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
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
            Show-FinishedHtmlMessage $Name
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
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
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
            Show-FinishedHtmlMessage $Name
        }
    }


    #! 7-025 (Csv Output)
    function Get-SecurityEventsLast30DaysCsv {

        param (
            [string]$FilePath,
            [int]$DaysBack = 30
        )

        $Name = "7-025_SecurityEventsLast30DaysAsCsv"
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
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-EventLogData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-OtherEventLogData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-SecurityEventsLast30DaysCsv -FilePath $FilePath


    Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-EventLogHtmlPage
