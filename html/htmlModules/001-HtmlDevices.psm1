$DevicePropertyArray = [ordered]@{

    "1-001_ComputerDetails"          = ("Computer Details", "Get-ComputerDetails", "Pipe")
    "1-002_TPMDetails"               = ("TPM Details", "Get-TPMDetails", "Pipe")
    "1-003_PSInfo"                   = ("PS Info", ".\bin\PsInfo.exe -accepteula -s -h -d | Out-String", "String")
    "1-004_PSDrive"                  = ("PS Drive Info", "Get-PSDrive -PSProvider FileSystem |
                                       Select-Object -Property *", "Pipe")
    "1-005_Win32LogicalDisk"         = ("Win32_LogicalDisk", "Get-CimInstance -ClassName Win32_LogicalDisk |
                                       Select-Object -Property *", "Pipe")
    "1-006_ComputerInfo"             = ("ComputerInfo", "Get-ComputerInfo", "Pipe")
    "1-007_SystemInfo"               = ("systeminfo", "systeminfo /FO CSV | ConvertFrom-Csv | Select-Object *", "Pipe")
    "1-008_Win32ComputerSystem"      = ("Win32_ComputerSystem", "Get-CimInstance -ClassName Win32_ComputerSystem |
                                       Select-Object -Property *", "Pipe")
    "1-009_Win32OperatingSystem"     = ("Win32_OperatingSystem", "Get-CimInstance -ClassName Win32_OperatingSystem |
                                       Select-Object -Property *", "Pipe")
    "1-010 Win32PhysicalMemory"      = ("Win32_PhysicalMemory", "Get-CimInstance -ClassName Win32_PhysicalMemory |
                                       Select-Object -Property *", "Pipe")
    "1-011_EnvVars"                  = ("EnvVars", "Get-ChildItem -Path env:", "Pipe")
    "1-012_DiskInfo"                 = ("Disk Info", "Get-Disk | Select-Object -Property * | Sort-Object DiskNumber", "Pipe")
    "1-013_Partitions"               = ("Partitions", "Get-Partition | Select-Object -Property * |
                                       Sort-Object -Property DiskNumber, PartitionNumber", "Pipe")
    "1-014_Win32DiskPartitions"      = ("Win32_DiskPartitions", "Get-CimInstance -ClassName Win32_DiskPartition |
                                       Sort-Object -Property Name", "Pipe")
    "1-015_Win32StartupCommand"      = ("Win32_StartupCommand", "Get-CimInstance -ClassName Win32_StartupCommand |
                                       Select-Object -Property *", "Pipe")
    "1-016_SoftwareLicensingService" = ("Software Licensing Service", "Get-WmiObject -ClassName SoftwareLicensingService",
                                       "Pipe")
    "1-017_Win32Bios"                = ("Win32_Bios", "Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *",
                                       "Pipe")
    "1-018_PnpDevice"                = ("PnP Devices", "Get-PnpDevice", "Pipe")
    "1-019_Win32PnPEntity"           = ("Win32_PnPEntity", "Get-CimInstance Win32_PnPEntity | Select-Object -Property *",
                                       "Pipe")
    "1-020_Win32Product"             = ("Win32_Product", "Get-WmiObject Win32_Product", "Pipe")
    "1-021_DiskAllocation"           = ("FSUtil Volume", "fsutil volume allocationReport C:", "String")
}


function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    # 1-000
    function Get-DeviceData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $DevicePropertyArray.GetEnumerator())
        {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]


            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else
                {
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                }
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
            catch
            {
                Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    #! 1-022 (Keep as seperate function)
    function Get-PnpEnumDevices {

        param
        (
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
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }



    # 1-023
    function Get-TimeZoneInfo {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-023_TimeZoneInfo"
        $Title = "Time Zone Info"
        $FileName = "$Name.html"
        Show-Message("Running ``$Name``") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force
        $RegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

        try
        {
            Show-Message("[INFO] Searching for key [$RegKey]") -Blue
            if (-not (Test-Path -Path $RegKey))
            {
                Show-Message("[WARNING] Registry Key [$RegKey] does not exist") -Yellow
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Registry Key [$RegKey] does not exist") -WarningMessage
            }
            else
            {
                $Data = Get-ItemProperty $RegKey | Select-Object -Property *

                if (-not $Data)
                {
                    Show-Message("[INFO] The registry key [$RegKey] exists, but contains no data") -Yellow
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] The registry key [$RegKey] exists, but contains no data")
                }
                else
                {
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                    Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title

                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    #! 1-024 (Keep as seperate function)
    function Get-AutoRunsData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-024_AutoRuns"
        $Title = "AutoRuns Data"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $TempCsvFile = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files\1-022_AutoRuns-TEMP.csv"
            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"
            $Data = Import-Csv -Path $TempCsvFile
            if (-not $Data)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title

                # Remove the temp csv file
                Remove-Item -Path $TempCsvFile -Force

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    #! 1-025 (Keep as seperate function)
    function Get-OpenWindowTitles {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-025_OpenWindowTitles"
        $Title = "Open Window Titles"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle
            if ($Data.Count -eq 0)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    #! 1-026 (Keep as seperate function)
    function Get-FullSystemInfo {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-026_FullSystemInfo"
        $Title = "Full System Info"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $tempFile = "$FilesFolder\$Name-TEMP.txt"
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Start-Process -FilePath "msinfo32.exe" -ArgumentList "/report $tempFile" -NoNewWindow -Wait

            $Data = Get-Content -Path $tempFile -Raw

            Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        finally
        {
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


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-DeviceHtmlPage
