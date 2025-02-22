function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    # Import the hashtables from the data files
    $DevicePropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\001A-DeviceDataArray.psd1"

    $DeviceHtmlMainFile = New-Item -Path "$OutputFolder\001_main.html" -ItemType File -Force

    # 1-000
    function Get-DeviceData {

        foreach ($item in $DevicePropertyArray.GetEnumerator()) {
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
                }
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    #! 1-021 (Csv Output)
    function Get-PnpDevicesAsCsv {

        $Name = "1-021_PnpDevicesAsCsv"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
            Get-PnpDevice | Export-Csv -Path "$OutputFolder\$FileName" -NoTypeInformation -Encoding UTF8
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-022 (Keep as seperate function)
    function Get-PnpEnumDevices {

        $Name = "1-022_PnpEnumDevices"
        $Title = "PnP Enum Devices"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $data = pnputil /enum-devices | Out-String
            if (-not $data) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-023 (Keep as seperate function)
    function Get-TimeZoneInfo {

        $Name = "1-023_TimeZoneInfo"
        $Title = "Time Zone Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name'") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

        try {
            Show-Message("[INFO] Searching for key [$RegKey]") -Blue
            if (-not (Test-Path -Path $RegKey)) {
                $dneMsg = "Registry Key [$RegKey] does not exist"
                Show-Message("[WARNING] $dneMsg") -Yellow
                Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $dneMsg") -WarningMessage
            }
            else {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property * | Out-String

                if (-not $Data) {
                    $msg = "The registry key [$RegKey] exists, but contains no data"
                    Show-Message("[INFO] $msg") -Yellow
                    Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $msg")
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                    Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-024 (Keep as seperate function)
    function Get-AutoRunsData {

        $Name = "1-024_AutoRuns"
        $Title = "AutoRuns Data"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $TempCsvFile = "$OutputFolder\1-024_AutoRuns-TEMP.csv"
            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"
            $Data = Import-Csv -Path $TempCsvFile
            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temp csv file
            Remove-Item -Path $TempCsvFile -Force
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-025 (Keep as seperate function)
    function Get-OpenWindowTitles {

        $Name = "1-025_OpenWindowTitles"
        $Title = "Open Window Titles"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle | Out-String
            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-026 (Keep as seperate function)
    function Get-FullSystemInfo {

        $Name = "1-026_FullSystemInfo"
        $Title = "Full System Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $tempFile = "$OutputFolder\$Name-TEMP.txt"
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
            Start-Process -DeviceHtmlOutputFolder "msinfo32.exe" -ArgumentList "/report $tempFile" -NoNewWindow -Wait
            $Data = Get-Content -Path $tempFile -Raw
            Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temporary text file
            Remove-Item -Path $tempFile -Force
        }
        Show-FinishedHtmlMessage $Name
    }


    function Write-DeviceSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\001\001_main.html' target='_blank'>Device Info</a></h3>" -Encoding UTF8

        $SectionName = "Device Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $DeviceHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $DeviceHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "001") {
                continue
            }
            if ([System.IO.Path]::GetExtension($File) -eq ".csv") {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $DeviceHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $DeviceHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $DeviceHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DeviceData
    Get-PnpDevicesAsCsv
    Get-PnpEnumDevices
    Get-TimeZoneInfo
    Get-AutoRunsData
    Get-OpenWindowTitles
    Get-FullSystemInfo


    Write-DeviceSectionToMain
}


Export-ModuleMember -Function Export-DeviceHtmlPage
