function Export-DeviceHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 1-001
    function Get-VariousData {
        param ([string]$FilePath)
        $Name = "1-001 Get-ComputerDetails"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-ComputerDetails
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-002
    function Get-TPMData {
        param ([string]$FilePath)
        $Name = "1-002 Get-TPMDetails"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-TPMDetails
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 1-003
    function Get-PSInfo {
        param ([string]$FilePath)
        $Name = "1-003 PSInfo.exe"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        try {
            $Data = .\bin\PsInfo.exe -accepteula -s -h -d | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-004
    function Get-PSDriveData {
        param ([string]$FilePath)
        $Name = "1-004 Get-PSDrive"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-PSDrive -PSProvider FileSystem | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-005
    function Get-LogicalDiskData {
        param ([string]$FilePath)
        $Name = "1-005 Win32_LogicalDisk"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-006
    function Get-ComputerData {
        param ([string]$FilePath)
        $Name = "1-006 Get-ComputerInfo"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-ComputerInfo
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-007
    function Get-SystemDataCMD {
        param ([string]$FilePath)
        $Name = "1-007 systeminfo"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = systeminfo /FO CSV | ConvertFrom-Csv | Select-Object *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-008
    function Get-SystemDataPS {
        param ([string]$FilePath)
        $Name = "1-008 Win32_ComputerSystem"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-009
    function Get-OperatingSystemData {
        param ([string]$FilePath)
        $Name = "1-009 Win32_OperatingSystem"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-010
    function Get-PhysicalMemory {
        param ([string]$FilePath)
        $Name = "1-010 Win32_PhysicalMemory"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-011
    function Get-EnvVars {
        param ([string]$FilePath)
        $Name = "1-011 Get-EnvVars"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-ChildItem -Path env:
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-012
    function Get-PhysicalDiskData {
        param ([string]$FilePath)
        $Name = "1-012 Get-Disk"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-Disk | Select-Object -Property * | Sort-Object DiskNumber
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-013
    function Get-DiskPartitions {
        param ([string]$FilePath)
        $Name = "1-013 Get-Partition"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-014
    function Get-Win32DiskParts {
        param ([string]$FilePath)
        $Name = "1-014 Win32_DiskPartition"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-015
    function Get-Win32StartupApps {
        param ([string]$FilePath)
        $Name = "1-015 Win32_StartupCommand"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-016
    # SKIPPING

    # 1-017
    function Get-SoftwareLicenseData {
        param ([string]$FilePath)
        $Name = "1-017 SoftwareLicensingService"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-WmiObject -ClassName SoftwareLicensingService
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-018
    function Get-AutoRunsData {
        param ([string]$FilePath)
        $Name = "1-018 AutoRuns.exe"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $TempCsvFile = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files\1-018_AutoRuns-TEMP.csv"

            Invoke-Expression ".\bin\autorunsc64.exe -a * -c -o $TempCsvFile -nobanner"

            $Data = Import-Csv -Path $TempCsvFile

            Show-Message("[INFO] Saving output from '$Name'") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
            Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            # Remove the temp csv file
            Remove-Item -Path $TempCsvFile -Force
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-019
    function Get-BiosData {
        param ([string]$FilePath)
        $Name = "1-019 Win32_Bios"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-020
    function Get-ConnectedDevices {
        param ([string]$FilePath)
        $Name = "1-020 Get-PnpDevice"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-PnpDevice
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-021
    function Get-HardwareInfo {
        param ([string]$FilePath)
        $Name = "1-021 Win32_PnPEntity"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance Win32_PnPEntity | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                # foreach ($Item in $Data) {
                #     $Item | Add-Member -MemberType NoteProperty -Name "Host" -Value $Env:COMPUTERNAME
                #     $Item | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
                # }

                # $Data | Select-Object Host, DateScanned, PnPClass, Caption, Description, DeviceID
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-022
    function Get-Win32Products {
        param ([string]$FilePath)
        $Name = "1-022 Win32_Product"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-WmiObject Win32_Product
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 1-023
    function Get-OpenWindowTitles {
        param ([string]$FilePath)
        $Name = "1-023 Get-OpenWindowTitles"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle
            if ($Data.Count -eq 0) {
                Show-Message("[INFO] No data found for '$Name'") -Yellow
                Write-HtmlLogEntry("No data found for '$Name'")
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-VariousData $FilePath
    Get-TPMData $FilePath
    Get-PSInfo $FilePath
    Get-PSDriveData $FilePath
    Get-LogicalDiskData $FilePath
    Get-ComputerData $FilePath
    Get-SystemDataCMD $FilePath
    Get-SystemDataPS $FilePath
    Get-OperatingSystemData $FilePath
    Get-PhysicalMemory $FilePath
    Get-EnvVars $FilePath
    Get-PhysicalDiskData $FilePath
    Get-DiskPartitions $FilePath
    Get-Win32DiskParts $FilePath
    Get-Win32StartupApps $FilePath
    Get-SoftwareLicenseData $FilePath
    Get-AutoRunsData -FilePath $FilePath
    Get-BiosData $FilePath
    Get-ConnectedDevices $FilePath
    Get-HardwareInfo $FilePath
    Get-Win32Products $FilePath
    Get-OpenWindowTitles $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-DeviceHtmlPage
