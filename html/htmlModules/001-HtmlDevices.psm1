
function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param (
        [string]$DeviceHtmlOutputFolder,
        [string]$HtmlReportFile,
        [string]$FilesFolder
    )

    # Import the hashtables from the data files
    $DevicePropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\001-DeviceDataArray.psd1"

    # 1-000
    function Get-DeviceData {

        foreach ($item in $DevicePropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force

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
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    #! 1-022 (Keep as seperate function)
    function Get-PnpEnumDevices {

        # param (
        #     [string]$DeviceHtmlOutputFolder,
        #     [string]$PagesFolder
        # )

        $Name = "1-022_PnpEnumDevices"
        $Title = "PnP Enum Devices"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }



    # 1-023
    function Get-TimeZoneInfo {

        $Name = "1-023_TimeZoneInfo"
        $Title = "Time Zone Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running ``$Name``") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force
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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-024 (Keep as seperate function)
    function Get-AutoRunsData {

        $Name = "1-024_AutoRuns"
        $Title = "AutoRuns Data"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force

        try {
            $TempCsvFile = "$FilesFolder\1-024_AutoRuns-TEMP.csv"
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

        # param  (
        #     [string]$DeviceHtmlOutputFolder,
        #     [string]$PagesFolder
        # )

        $Name = "1-025_OpenWindowTitles"
        $Title = "Open Window Titles"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force

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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    #! 1-026 (Keep as seperate function)
    function Get-FullSystemInfo {

        $Name = "1-026_FullSystemInfo"
        $Title = "Full System Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $tempFile = "$FilesFolder\$Name-TEMP.txt"
        $OutputHtmlFilePath = New-Item -Path "$DeviceHtmlOutputFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
            Start-Process -DeviceHtmlOutputFolder "msinfo32.exe" -ArgumentList "/report $tempFile" -NoNewWindow -Wait
            $Data = Get-Content -Path $tempFile -Raw
            Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
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

    function Write-DeviceSectionToMain {

        $DeviceSectionHeader = "
        <h4 class='section_header'>Device Information Section</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $DeviceSectionHeader

        $FileList = Get-ChildItem -Path $DeviceHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\webpages\001\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DeviceData
    Get-PnpEnumDevices
    Get-TimeZoneInfo
    Get-AutoRunsData
    Get-OpenWindowTitles
    # Get-FullSystemInfo


    Write-DeviceSectionToMain
}


Export-ModuleMember -Function Export-DeviceHtmlPage
