
function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder,
        [string]$FilesFolder
    )

    $DevicePropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\001-DeviceDataArray.psd1"

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='item_table'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    # 1-000
    function Get-DeviceData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $DevicePropertyArray.GetEnumerator()) {
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
                }
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    #! 1-022 (Keep as seperate function)
    function Get-PnpEnumDevices {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-022_PnpEnumDevices"
        $Title = "PnP Enum Devices"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $data = pnputil /enum-devices | Out-String
            if (-not $data) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }



    # 1-023
    function Get-TimeZoneInfo {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-023_TimeZoneInfo"
        $Title = "Time Zone Info"
        $FileName = "$Name.html"
        Show-Message("Running ``$Name``") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

        try {
            Show-Message("[INFO] Searching for key [$RegKey]") -Blue
            if (-not (Test-Path -Path $RegKey)) {
                $dneMsg = "Registry Key [$RegKey] does not exist"
                Show-Message("[WARNING] $dneMsg") -Yellow
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $dneMsg") -WarningMessage
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property * | Out-String

                if (-not $Data) {
                    $msg = "The registry key [$RegKey] exists, but contains no data"
                    Show-Message("[INFO] $msg") -Yellow
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $msg")
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                    Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-024 (Keep as seperate function)
    function Get-AutoRunsData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-024_AutoRuns"
        $Title = "AutoRuns Data"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $TempCsvFile = "$FilesFolder\1-024_AutoRuns-TEMP.csv"
            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"
            $Data = Import-Csv -Path $TempCsvFile
            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temp csv file
            Remove-Item -Path $TempCsvFile -Force
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-025 (Keep as seperate function)
    function Get-OpenWindowTitles {

        param  (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-025_OpenWindowTitles"
        $Title = "Open Window Titles"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle | Out-String
            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-026 (Keep as seperate function)
    function Get-FullSystemInfo {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-026_FullSystemInfo"
        $Title = "Full System Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $tempFile = "$FilesFolder\$Name-TEMP.txt"
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
            Start-Process -FilePath "msinfo32.exe" -ArgumentList "/report $tempFile" -NoNewWindow -Wait
            $Data = Get-Content -Path $tempFile -Raw
            Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
            Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temporary text file
            Remove-Item -Path $tempFile -Force
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DeviceData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-PnpEnumDevices -FilePath $FilePath -PagesFolder $PagesFolder
    Get-TimeZoneInfo -FilePath $FilePath -PagesFolder $PagesFolder
    Get-AutoRunsData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-OpenWindowTitles -FilePath $FilePath -PagesFolder $PagesFolder
    # Get-FullSystemInfo -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-DeviceHtmlPage
