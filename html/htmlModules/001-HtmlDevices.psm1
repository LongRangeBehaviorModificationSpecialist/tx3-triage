$DevicePropertyArray = [ordered]@{

    "1-001_ComputerDetails" = ("Get-ComputerDetails", "Pipe")
    "1-002_TPMDetails"      = ("Get-TPMDetails", "Pipe")
    "1-003_PSInfo"           = (".\bin\PsInfo.exe -accepteula -s -h -d | Out-String", "String")
    "1-004_PSDrive"          = ("Get-PSDrive -PSProvider FileSystem | Select-Object -Property *", "Pipe")
    "1-005_Win32LogicalDisk" = ("Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property *", "Pipe")
    "1-006_ComputerInfo"      = ("Get-ComputerInfo", "Pipe")
    "1-007_SystemInfo"        = ("systeminfo /FO CSV | ConvertFrom-Csv | Select-Object *", "Pipe")
    "1-008_Win32ComputerSystem" = ("Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *", "Pipe")
    "1-009_Win32OperatingSystem" = ("Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *", "Pipe")
    "1-010 Win32PhysicalMemory"   = ("Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property *", "Pipe")
    "1-011_EnvVars"               = ("Get-ChildItem -Path env:", "Pipe")
    "1-012_DiskInfo"              = ("Get-Disk | Select-Object -Property * | Sort-Object DiskNumber", "Pipe")
    "1-013_Partitions"             = ("Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber", "Pipe")
    "1-014_Win32DiskPartitions"  = ("Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name", "Pipe")
    "1-015_Win32StartupCommand"  = ("Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property *", "Pipe")
    "1-016_SoftwareLicensingService" = ("Get-WmiObject -ClassName SoftwareLicensingService", "Pipe")
    "1-017_Win32Bios"                 = ("Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *", "Pipe")
    "1-018_PnpDevice"                 = ("Get-PnpDevice", "Pipe")
    "1-019_Win32PnPEntity"           = ("Get-CimInstance Win32_PnPEntity | Select-Object -Property *", "Pipe")
    "1-020_Win32Product"              = ("Get-WmiObject Win32_Product", "Pipe")
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
            $Command = $item.value[0]
            $Type = $item.value[1]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Show-Message("No data found for ``$Name``") -Yellow
                    Write-HtmlLogEntry("No data found for ``$Name``")
                }
                else
                {
                    Show-Message("[INFO] Saving output from ``$Name``") -Blue
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                }
            }
            catch
            {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $ErrorMessage") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 1-021
    function Get-AutoRunsData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-021_AutoRuns"
        $FileName = "$Name.html"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $TempCsvFile = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files\1-021_AutoRuns-TEMP.csv"

            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"

            $Data = Import-Csv -Path $TempCsvFile

            Show-Message("[INFO] Saving output from ``$Name``") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($MyInvocation.MyCommand.Name)`` saved to $FileName")

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

            Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath

            # Remove the temp csv file
            Remove-Item -Path $TempCsvFile -Force
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-022
    function Get-OpenWindowTitles {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "1-022_Open_Window_Titles"
        $FileName = "$Name.html"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle
            if ($Data.Count -eq 0)
            {
                Show-Message("[INFO] No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else
            {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($MyInvocation.MyCommand.Name)`` saved to $FileName")

                Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
            }
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DeviceData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-AutoRunsData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-OpenWindowTitles -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-DeviceHtmlPage
