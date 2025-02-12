$DevicePropertyArray = [ordered]@{

    "1-001_ComputerDetails"          = ("Computer Details",
                                       "Get-ComputerDetails | Out-String",
                                       "String")
    "1-002_TPMDetails"               = ("TPM Details",
                                       "Get-TPMDetails | Out-String",
                                       "String")
    "1-003_PSInfo"                   = ("PS Info",
                                       ".\bin\PsInfo.exe -accepteula -s -h -d | Out-String",
                                       "String")
    "1-004_PSDrive"                  = ("PS Drive Info",
                                       "Get-PSDrive -PSProvider FileSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-005_Win32LogicalDisk"         = ("Win32_LogicalDisk",
                                       "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property * | Out-String",
                                       "String")
    "1-006_ComputerInfo"             = ("ComputerInfo",
                                       "Get-ComputerInfo | Out-String",
                                       "String")
    "1-007_SystemInfo"               = ("systeminfo",
                                       "systeminfo /FO CSV | ConvertFrom-Csv | Select-Object * | Out-String",
                                       "String")
    "1-008_Win32ComputerSystem"      = ("Win32_ComputerSystem",
                                       "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-009_Win32OperatingSystem"     = ("Win32_OperatingSystem",
                                       "Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property * | Out-String",
                                       "String")
    "1-010 Win32PhysicalMemory"      = ("Win32_PhysicalMemory",
                                       "Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property * | Out-String",
                                       "String")
    "1-011_EnvVars"                  = ("EnvVars",
                                       "Get-ChildItem -Path env: | Out-String",
                                       "String")
    "1-012_DiskInfo"                 = ("Disk Info",
                                       "Get-Disk | Select-Object -Property * | Sort-Object DiskNumber | Out-String",
                                       "String")
    "1-013_Partitions"               = ("Partitions",
                                       "Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber | Out-String",
                                       "String")
    "1-014_Win32DiskPartitions"      = ("Win32_DiskPartitions",
                                       "Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name | Out-String",
                                       "String")
    "1-015_Win32StartupCommand"      = ("Win32_StartupCommand",
                                       "Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property * | Out-String",
                                       "String")
    "1-016_SoftwareLicensingService" = ("Software Licensing Service",
                                       "Get-WmiObject -ClassName SoftwareLicensingService | Out-String",
                                       "String")
    "1-017_Win32Bios"                = ("Win32_Bios",
                                       "Get-WmiObject -ClassName Win32_Bios | Select-Object -Property * | Out-String", "String")
    "1-018_PnpDevice"                = ("PnP Devices",
                                       "Get-PnpDevice | Out-String",
                                       "String")
    "1-019_Win32PnPEntity"           = ("Win32_PnPEntity",
                                       "Get-CimInstance Win32_PnPEntity | Select-Object -Property * | Out-String",
                                       "String")
    "1-020_Win32Product"             = ("Win32_Product",
                                       "Get-WmiObject Win32_Product | Out-String",
                                       "String")
    "1-021_DiskAllocation"           = ("FSUtil Volume",
                                       "fsutil volume allocationReport C: | Out-String",
                                       "String")
}


function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\results\files"


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
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
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
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
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
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
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
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                    Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
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
            $TempCsvFile = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\results\files\1-024_AutoRuns-TEMP.csv"
            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"
            $Data = Import-Csv -Path $TempCsvFile
            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temp csv file
            Remove-Item -Path $TempCsvFile -Force
        }
        Show-FinishedHtmlMessage -Name $Name
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
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
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
            Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Remove the temporary text file
            Remove-Item -Path $tempFile -Force
        }
        Show-FinishedHtmlMessage -Name $Name
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


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-DeviceHtmlPage
