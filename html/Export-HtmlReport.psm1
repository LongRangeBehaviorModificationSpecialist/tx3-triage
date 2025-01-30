$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


Import-Module -Name .\html\vars.psm1 -Global -Force
Import-Module -Name .\html\HtmlReportStaticPages.psm1 -Global -Force





# $ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"

function Save-OutputToHtmlFile {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Mandatory, Position = 1)]
        [object]$Data,
        [Parameter(Mandatory, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputFilePath,
        [switch]$FromPipe,
        [switch]$FromString
    )

    process {
     $PreContent = "</h5>
<button type='button' class='collapsible'>$($Name)</button>
<div class='content'>
<pre>
<p>"

     $PostContent = "
</p>
</pre>
</div>"

        # $HeaderMsg = Show-Message("Running ``$Name`` command") -Header -Gray
        # $FooterMsg = Show-Message("``$Name`` done...") -Blue

        if ($FromPipe) {
            # $HeaderMsg
            $Data | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $Name $PreContent $Data" -PostContent $PostContent | Out-File -Append $OutputFilePath -Encoding UTF8
            # $FooterMsg
        }

        if ($FromString) {
            # $HeaderMsg
            Add-Content -Path $OutputFilePath -Value "<h5 class='info_header'> $Name $PreContent $Data $PostContent" -NoNewline
            # $FooterMsg
        }
    }
}



function Export-HtmlReport {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,
        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]$Date,
        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Time,
        [Parameter(Position = 4)]
        [ValidateNotNullOrEmpty()]
        [string]$Ipv4,
        [Parameter(Position = 5)]
        [ValidateNotNullOrEmpty()]
        [string]$Ipv6,
        [Parameter(Position = 6)]
        [ValidateNotNullOrEmpty()]
        [string]$User,
        [Parameter(Position = 7)]
        [ValidateNotNullOrEmpty()]
        [string]$Agency,
        [Parameter(Position = 8)]
        [ValidateNotNullOrEmpty()]
        [string]$CaseNumber
    )




    # $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

    $Cwd = Get-Location


    # Create the `Resources` folder in the case folder
    $ResourcesFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Resources" -Force


    # Create the folder that need to be made in the `Resources` parent folder
    $CssFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "css" -Force
    $PagesFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "pages" -Force
    $StaticFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "static" -Force
    $FilesFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "files" -Force


    $CssStyleFileName = Join-Path -Path $CssFolder -ChildPath "style.css"
    $ImgFolder = Join-Path -Path $ResourcesFolder -ChildPath "images"


    # Copy files from the `css` folder
    $MasterImgFolder = Join-Path -Path $Cwd -ChildPath "html\Resources\images"

    $CssDecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($CssEncodedFileText))
    Add-Content -Path $CssStyleFileName -Value $CssDecodedText


    # Copy the necessary folders to the new case directory
    Copy-Item  $MasterImgFolder -Destination $ImgFolder -Force -Recurse


    # Set and write the `TriageReport.html` homepage
    $HtmlReportFile = New-Item -Path "$CaseFolderName\TriageReport.html" -ItemType File
    Write-HtmlHomePage -FilePath $HtmlReportFile


    # Set and write the `nav.html` file to be displayed in the `TriageReport.html` page
    $NavReportFile = New-Item -Path "$StaticFolder\nav.html" -ItemType File
    Write-HtmlNavPage -FilePath $NavReportFile


    # Set and write the `front.html` file to be displayed in the `TriageReport.html` page
    $FrontReportFile = New-Item -Path "$StaticFolder\front.html" -ItemType File
    Write-HtmlFrontPage -FilePath $FrontReportFile -User $User -ComputerName $ComputerName -Ipv4 $Ipv4 -Ipv6 $Ipv6


    # Set and write the `readme.html` file
    $ReadMeFile = New-Item -Path "$StaticFolder\readme.html" -ItemType File
    Write-HtmlReadMePage -FilePath $ReadMeFile


    Show-Message("Compiling the tx3-triage report in .html format. Please wait. . . ") -Header -Green


    $DeviceHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "001_DeviceInfo.html"
    $UserHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "002_UserInfo.html"
    $NetworkHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "003_NetworkInfo.html"
    $ProcessHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "004_ProcessInfo.html"
    $SystemHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "005_SystemInfo.html"
    $PrefetchHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "006_PrefetchInfo.html"
    $EventLogHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "007_EventLogInfo.html"
    $FirewallHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "008_FirewallInfo.html"
    $BitLockerHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "009_BitLockerInfo.html"

    # (1)
    function Export-DeviceHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        # 1-001
        function Get-VariousData {
            param ([string]$FilePath)
            $Name = "1-001 Get-ComputerDetails"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ComputerDetails
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-VariousData -FilePath $FilePath


        # 1-002
        function Get-TPMData {
            param ([string]$FilePath)
            $Name = "1-002 Get-TPMDetails"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-TPMDetails
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-TPMData -FilePath $FilePath


        #* 1-003
        function Get-PSInfo {
            param ([string]$FilePath)
            $Name = "1-003 PSInfo.exe"
            Show-Message("Running ``$1003Name`` command") -Header -Gray
            try {
                $Data = .\bin\PsInfo.exe -accepteula -s -h -d | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$1003Name`` done...") -Blue
        }
        Get-PSInfo -FilePath $FilePath


        # 1-004
        function Get-PSDriveData {
            param ([string]$FilePath)
            $Name = "1-004 Get-PSDrive"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-PSDrive -PSProvider FileSystem | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-PSDriveData -FilePath $FilePath


        # 1-005
        function Get-LogicalDiskData {
            param ([string]$FilePath)
            $Name = "1-005 Win32_LogicalDisk"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-LogicalDiskData -FilePath $FilePath


        # 1-006
        function Get-ComputerData {
            param ([string]$FilePath)
            $Name = "1-006 Get-ComputerInfo"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ComputerInfo
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ComputerData -FilePath $FilePath


        # 1-007
        function Get-SystemDataCMD {
            param ([string]$FilePath)
            $Name = "1-007 systeminfo"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = systeminfo /FO CSV | ConvertFrom-Csv | Select-Object *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-SystemDataCMD -FilePath $FilePath


        # 1-008
        function Get-SystemDataPS {
            param ([string]$FilePath)
            $Name = "1-008 Win32_ComputerSystem"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-SystemDataPS -FilePath $FilePath


        # 1-009
        function Get-OperatingSystemData {
            param ([string]$FilePath)
            $Name = "1-009 Win32_OperatingSystem"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-OperatingSystemData -FilePath $FilePath


        # 1-010
        function Get-PhysicalMemory {
            param ([string]$FilePath)
            $Name = "1-010 Win32_PhysicalMemory"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-PhysicalMemory -FilePath $FilePath


        # 1-011
        function Get-EnvVars {
            param ([string]$FilePath)
            $Name = "1-011 Get-EnvVars"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ChildItem -Path env:
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-EnvVars -FilePath $FilePath


        # 1-012
        function Get-PhysicalDiskData {
            param ([string]$FilePath)
            $Name = "1-012 Get-Disk"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Disk | Select-Object -Property * | Sort-Object DiskNumber
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-PhysicalDiskData -FilePath $FilePath


        # 1-013
        function Get-DiskPartitions {
            param ([string]$FilePath)
            $Name = "1-013 Get-Partition"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-DiskPartitions -FilePath $FilePath


        # 1-014
        function Get-Win32DiskParts {
            param ([string]$FilePath)
            $Name = "1-014 Win32_DiskPartition"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-Win32DiskParts -FilePath $FilePath


        # 1-015
        function Get-Win32StartupApps {
            param ([string]$FilePath)
            $Name = "1-015 Win32_StartupCommand"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-Win32StartupApps -FilePath $FilePath


        # 1-016
        # SKIPPING


        # 1-017
        function Get-SoftwareLicenseData {
            param ([string]$FilePath)
            $Name = "1-017 SoftwareLicensingService"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-WmiObject -ClassName SoftwareLicensingService
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-SoftwareLicenseData -FilePath $FilePath


        #* 1-018
        function Get-AutoRunsData {
            param ([string]$FilePath)
            $Name = "1-018 AutoRuns.exe"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = .\bin\autorunsc64.exe -a * -c -nobanner | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-AutoRunsData -FilePath $FilePath


        # 1-019
        function Get-BiosData {
            param ([string]$FilePath)
            $Name = "1-019 Win32_Bios"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-WmiObject -ClassName Win32_Bios | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-BiosData -FilePath $FilePath


        # 1-020
        function Get-ConnectedDevices {
            param ([string]$FilePath)
            $Name = "1-020 Get-PnpDevice"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-PnpDevice
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ConnectedDevices -FilePath $FilePath


        # 1-021
        function Get-HardwareInfo {
            param ([string]$FilePath)
            $Name = "1-021 Win32_PnPEntity"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance Win32_PnPEntity

                foreach ($Item in $Data) {
                    $Item | Add-Member -MemberType NoteProperty -Name "Host" -Value $Env:COMPUTERNAME
                    $Item | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
                }

                $Data | Select-Object Host, DateScanned, PnPClass, Caption, Description, DeviceID
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-HardwareInfo -FilePath $FilePath


        # 1-022
        function Get-Win32Products {
            param ([string]$FilePath)
            $Name = "1-022 Win32_Product"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-WmiObject Win32_Product
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-Win32Products -FilePath $FilePath


        # 1-023
        function Get-OpenWindowTitles {
            param ([string]$FilePath)
            $Name = "1-023 Get-OpenWindowTitles"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-OpenWindowTitles -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-DeviceHtmlPage` function

    # (2)
    function Export-UserHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        #* 2-001
        function Get-WhoAmI {
            param ([string]$FilePath)
            $Name = "2-001 WhoAmI"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = whoami /ALL /FO LIST | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-WhoAmI -FilePath $FilePath


        # 2-002
        function Get-UserProfile {
            param ([string]$FilePath)
            $Name = "2-002 Win32_UserProfile"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-UserProfile -FilePath $FilePath


        # 2-003
        function Get-UserInfo {
            param ([string]$FilePath)
            $Name = "2-003 Win32_UserAccount"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-UserInfo -FilePath $FilePath


        # 2-004
        function Get-LocalUserData {
            param ([string]$FilePath)
            $Name = "2-004 Get-LocalUser"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-LocalUser
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-LocalUserData -FilePath $FilePath


        # 2-005
        function Get-LogonSession {
            param ([string]$FilePath)
            $Name = "2-005 Win32_LogonSession"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-LogonSession -FilePath $FilePath


        # 2-006
        # TODO -- SKIPPED for now.  Will come back and figure out how to code this function


        # 2-007
        function Get-LastLogons {
            param ([string]$FilePath)
            $Name = "2-007 WinEvent Security (4624 or 4648)"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Cmd = Get-WinEvent -LogName 'Security' -FilterXPath "*[System[EventID=4624 or EventID=4648]]"

                $Data = @()
                foreach ($LogonEvent in $Cmd) {
                    $Data += [PSCustomObject]@{
                        Time      = $LogonEvent.TimeCreated
                        LogonType = if ($LogonEvent.Id -eq 4648) { "Explicit" } else { "Interactive" }
                        Message   = $LogonEvent.Message
                    }
                }
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-LastLogons -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-UserHtmlPage` function

    # (3)
    function Export-NetworkHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        # 3-001
        function Get-NetworkConfig {
            param ([string]$FilePath)
            $Name = "3-001 Win32_NetworkAdapterConfiguration"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = "IpAddress"; E = { $_.IpAddress -join "; " } }, @{ N = "DefaultIPgateway"; E = { $_.DefaultIPgateway -join "; " } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Format-List
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetworkConfig -FilePath $FilePath


        # 3-002
        # TODO -- Check status of the `Get-NetTCPConnection` function // Not working on forensic machine
        function Get-OpenNetworkConnections {
            param ([string]$FilePath)
        }


        # 3-003
        # TODO -- SKIPPED temp
        function Get-NetstatDetailed {
            param ([string]$FilePath)
        }


        #* 3-004
        function Get-NetstatBasic {
            param ([string]$FilePath)
            $Name = "3-004 netstat -nao"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = netstat -nao | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetstatBasic -FilePath $FilePath


        # 3-005
        # function Get-NetTcpConnectionsAllTxt {
        #     param ([string]$FilePath)
        #     $Name = "3-005 Get-NetTCPConnection"
        #     Show-Message("Running ``$Name`` command") -Header -Gray
        #     try {

        #     }
        #     catch {

        #     }
        #     Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $Name $PreContentBegin Get-NetTCPConnection $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        #     Show-Message("``$Name`` done...") -Blue
        # }


        #! 3-006
        # function Get-NetTcpConnectionsAllCsv {
        #     param ([string]$FilePath)
        #     $Name = "3-006 Get-NetTCPConnection (as CSV)"
        #     Show-Message("Running ``$Name`` command") -Header -Gray
        #     $FileName = "3-006_NetTcpConnections.csv"
        #     try {

        #     }
        #     catch {

        #     }
        #     Get-NetTcpConnection | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8
        #     Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $Name $PreContentBegin Get-NetTCPConnection (as CSV) $PrecontentEnd <a href='../files/$FileName'>$FileName</a> $PostContent" -NoNewline
        #     Show-Message("``$Name`` done...") -Blue
        # }


        # 3-007
        function Get-NetworkAdapters {
            param ([string]$FilePath)
            $Name = " 3-007 Get-NetAdapter"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetAdapter | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetworkAdapters -FilePath $FilePath


        # 3-008
        function Get-NetIPConfig {
            param ([string]$FilePath)
            $Name = "3-008 Get-NetIPConfiguration"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetIPConfiguration | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetIPConfig -FilePath $FilePath


        #* 3-009
        function Get-RouteData {
            param ([string]$FilePath)
            $Name = "3-009 route PRINT"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = route PRINT | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-RouteData -FilePath $FilePath


        #* 3-010
        function Get-IPConfig {
            param ([string]$FilePath)
            $Name = "3-010 ipconfig /all"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = ipconfig /all | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-IPConfig -FilePath $FilePath


        # 3-011
        function Get-ARPData {
            param ([string]$FilePath)
            $Name = "3-011 Get-NetNeighbor"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ARPData -FilePath $FilePath


        # 3-012
        function Get-NetIPAddrs {
            param ([string]$FilePath)
            $Name = "3-012 Get-NetIPAddress"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetIPAddress | Sort-Object -Property IPAddress
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetIPAddrs -FilePath $FilePath


        #* 3-013
        function Get-HostsFile {
            param ([string]$FilePath)
            $Name = "3-013 Get-HostsFile"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Content "$Env:windir\system32\drivers\etc\hosts" -Raw
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-HostsFile -FilePath $FilePath


        #* 3-014
        function Get-NetworksFile {
            param ([string]$FilePath)
            $Name = "3-014 Get-NetworksFile"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Content "$Env:windir\system32\drivers\etc\networks" -Raw
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetworksFile -FilePath $FilePath


        #* 3-015
        function Get-ProtocolFile {
            param ([string]$FilePath)
            $Name = "3-015 Get-ProtocolFile"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Content "$Env:windir\system32\drivers\etc\protocol" -Raw
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $Name $PreContentBegin Get-protocolFile $PrecontentEnd <pre> $Data $PostContent </pre>" -NoNewline
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ProtocolFile -FilePath $FilePath


        #* 3-016
        function Get-ServicesFile {
            param ([string]$FilePath)
            $Name = "3-016 Get-servicesFile"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-Content "$Env:windir\system32\drivers\etc\services" -Raw
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ServicesFile -FilePath $FilePath


        # 3-017
        function Get-SmbShares {
            param ([string]$FilePath)
            $Name = "3-017 Get-SmbShare"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-SmbShare
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-SmbShares -FilePath $FilePath


        # 3-018
        function Get-WifiPasswords {
            param ([string]$FilePath)
            $Name = "3-018 Get-WifiPasswords"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } }
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-WifiPasswords -FilePath $FilePath


        # 3-019
        function Get-NetInterfaces {
            param ([string]$FilePath)
            $Name = "3-019 Get-NetIPInterface"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetIPInterface | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetInterfaces -FilePath $FilePath


        # 3-020
        function Get-NetRouteData {
            param ([string]$FilePath)
            $Name = "3-020 Get-NetRoute"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetRoute | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-NetRouteData -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-NetworkHtmlPage` function

    # (4)
    function Export-ProcessHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        # 4-001
        function Get-RunningProcessesAll {
            param ([string]$FilePath)
            $Name = "4-001 Running Processes (All)"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-RunningProcessesAll -FilePath $FilePath


        #! 4-002
        function Get-RunningProcessesAsCsv {
            $Name = "4-002 Running Processes (as Csv)"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $FileName = "4-002_RunningProcesses.csv"
            try {
                Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8
                Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $Name $PreContentBegin Running Processes (as Csv) $PrecontentEnd <a href='../files/$FileName'>$FileName</a> $PostContent"
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-RunningProcessesAsCsv


        #! 4-003
        function Get-UniqueProcessHashAsCsv {
            $Name = "4-003 Unique Process Hashes (as Csv)"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $FileName = "4-003_UniqueProcessHash.csv"
            try {
                $Data = @()
                foreach ($P in (Get-WmiObject Win32_Process | Select-Object Name, ExecutablePath, CommandLine, ParentProcessId, ProcessId)) {
                    $ProcessObj = New-Object PSCustomObject
                    if ($Null -ne $P.ExecutablePath) {
                        $Hash = (Get-FileHash -Algorithm SHA256 -Path $P.ExecutablePath).Hash
                        $ProcessObj | Add-Member -NotePropertyName Proc_Hash -NotePropertyValue $Hash
                        $ProcessObj | Add-Member -NotePropertyName Proc_Name -NotePropertyValue $P.Name
                        $ProcessObj | Add-Member -NotePropertyName Proc_Path -NotePropertyValue $P.ExecutablePath
                        $ProcessObj | Add-Member -NotePropertyName Proc_CommandLine -NotePropertyValue $P.CommandLine
                        $ProcessObj | Add-Member -NotePropertyName Proc_ParentProcessId -NotePropertyValue $P.ParentProcessId
                        $ProcessObj | Add-Member -NotePropertyName Proc_ProcessId -NotePropertyValue $P.ProcessId
                        $Data += $ProcessObj
                    }
                }
                ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() | Export-Csv -NoTypeInformation -Path $FileName -Encoding UTF8
                Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $Name $PreContentBegin Unique Process Hashes (as Csv) $PrecontentEnd <a href='../files/$FileName'>$FileName</a> $PostContent"
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-UniqueProcessHashAsCsv


        # 4-004
        function Get-SvcHostsAndProcesses {
            param ([string]$FilePath)
            $Name = "4-004 SvcHostsAndProcesses"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq "svchost.exe" | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-SvcHostsAndProcesses -FilePath $FilePath


        #! 4-005
        function Get-RunningServicesAsCsv {
            $Name = "4-005 Running Services (as Csv)"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $FileName = "4-005_RunningServices.csv"
            try {
                Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8
                Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $Name $PreContentBegin Running Services (as Csv) $PrecontentEnd <a href='../files/$FileName'>$FileName</a> $PostContent"
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-RunningServicesAsCsv


        #* 4-006
        function Get-InstalledDrivers {
            param ([string]$FilePath)
            $Name = "4-006 driverquery"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = driverquery | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-InstalledDrivers -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-ProcessHtmlPage` function

    # (5)
    function Export-SystemHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        # 5-001
        function Get-ADS {
            param ([string]$FilePath)
            $Name = "5-001 Get-ADS"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ADSData
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
        }
        Get-ADS -FilePath $FilePath


        #! 5-002
        function Get-OpenFiles {
            param ([string]$FilePath)
            $Name = "5-002 Get-OpenFiles"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = openfiles.exe /query /FO CSV /V | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-OpenFiles -FilePath $FilePath


        # 5-003
        function Get-OpenShares {
            param ([string]$FilePath)
            $Name = "5-003 Win32_Share"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_Share | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-OpenShares -FilePath $FilePath


        # 5-004
        function Get-MappedNetworkDriveMRU {
            param ([string]$FilePath)
            $Name = "5-004 Map Network Drive MRU"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found in Registry Key [$($RegKey)]")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-MappedNetworkDriveMRU -FilePath $FilePath


        # 5-005
        function Get-Win32ScheduledJobs {
            param ([string]$FilePath)
            $Name = "5-005 Win32_ScheduledJob"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_ScheduledJob
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-Win32ScheduledJobs -FilePath $FilePath


        # 5-006
        function Get-ScheduledTasks {
            param ([string]$FilePath)
            $Name = "5-006 Get-ScheduledTask"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ScheduledTask | Select-Object -Property * | Where-Object { ($_.State -ne 'Disabled') }
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for $($Name)")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ScheduledTasks -FilePath $FilePath


        # 5-007
        function Get-ScheduledTasksRunInfo {
            param ([string]$FilePath)
            $Name = "5-007 Get-ScheduledTaskInfo"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Get-ScheduledTaskInfo | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for $($Name)")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-ScheduledTasksRunInfo -FilePath $FilePath


        # 5-008
        function Get-HotFixesData {
            param ([string]$FilePath)
            $Name = "5-008 Get-HotFix"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-HotFix | Select-Object HotfixID, Description, InstalledBy, InstalledOn | Sort-Object InstalledOn -Descending
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for $($Name)")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-HotFixesData -FilePath $FilePath


        # 5-009
        function Get-InstalledAppsFromReg {
            param ([string]$FilePath)
            $Name = "5-009 Installed Apps From Registry"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object -Property * | Sort-Object InstallDate -Descending
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found in Registry Key [$($RegKey)]")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-InstalledAppsFromReg -FilePath $FilePath


        # 5-010
        function Get-InstalledAppsFromAppx {
            param ([string]$FilePath)
            $Name = "5-010 Installed Apps From Appx"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-AppxPackage
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-InstalledAppsFromAppx -FilePath $FilePath


        # 5-011
        function Get-VolumeShadowsData {
            param ([string]$FilePath)
            $Name = "5-011 Volume Shadow Copies"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-CimInstance -ClassName Win32_ShadowCopy | Select-Object -Property *
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-VolumeShadowsData -FilePath $FilePath


        # TODO -- move this function to the networking section
        #! 5-012
        function Get-DnsCacheDataTxt {
            param ([string]$FilePath)
            $Name = "5-012 DNS Cache"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = ipconfig /displaydns | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-DnsCacheDataTxt -FilePath $FilePath


        # # TODO -- move this function to the networking section
        #! 5-013
        #! SKIPPED MAKING THE .CSV FILE


        # 5-014
        function Get-TempInternetFiles {
            param ([string]$FilePath)
            $Name = "5-014 Temporary Internet Files"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ChildItem -Recurse -Force "$Env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files" | Select-Object Name, LastWriteTime, CreationTime, Directory | Sort-Object CreationTime -Descending
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-TempInternetFiles -FilePath $FilePath


        # 5-015
        function Get-StoredCookiesData {
            param ([string]$FilePath)
            $Name = "5-015 Stored Cookies Data"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ChildItem -Recurse -Force "$($Env:LOCALAPPDATA)\Microsoft\Windows\cookies" | Select-Object Name | ForEach-Object { $N = $_.Name; Get-Content "$($AppData)\Microsoft\Windows\cookies\$N" | Select-String "/" }
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-StoredCookiesData -FilePath $FilePath


        # 5-016
        function Get-TypedUrls {
            param ([string]$FilePath)
            $Name = "5-016 Typed URLs"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKCU:\SOFTWARE\Microsoft\Internet Explorer\TypedURLs"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found for ``$Name``")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-TypedUrls -FilePath $FilePath


        # 5-017
        function Get-InternetSettings {
            param ([string]$FilePath)
            $Name = "5-017 Internet Settings"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object * -ExcludeProperty PS*
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found in Registry Key [$($RegKey)]")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-InternetSettings -FilePath $FilePath


        # 5-018
        function Get-TrustedInternetDomains {
            param ([string]$FilePath)
            $Name = "5-018 Trusted Internet Domains"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ChildItem $RegKey | Select-Object PSChildName
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found in Registry Key [$($RegKey)]")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-TrustedInternetDomains -FilePath $FilePath


        # 5-019
        function Get-AppInitDllKeys {
            param ([string]$FilePath)
            $Name = "5-019 App Init Dll Keys"
            Show-Message("Running ``$Name`` command") -Header -Gray
            $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"
            try {
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[WARNING] Registry Key [$($RegKey)] does not exist") -Yellow
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    $Data = Get-ItemProperty $RegKey | Select-Object -Property *
                    if ($Data.Count -eq 0) {
                        Show-Message("No data found in Registry Key [$($RegKey)]")
                    }
                    else {
                        Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                    }
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-AppInitDllKeys -FilePath $FilePath

        # # 5-020
        # Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | Select-Object * -ExcludeProperty PS*

        # #! 5-021
        # gpresult.exe /z






        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-SystemHtmlPage` function

    # (6)
    function Export-PrefetchHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        #6-001
        function Get-DetailedPrefetchData {
            param ([string]$FilePath)
            $Name = "6-001 Prefetch Files"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-DetailedPrefetchData -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-PrefetchHtmlPage` function

    #(8)
    function Export-FirewallHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        # 8-001
        function Get-FirewallRules {
            param ([string]$FilePath)
            $Name = "8-001 Firewall Rules"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-NetFirewallRule
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-FirewallRules -FilePath $FilePath


        #* 8-002
        function Get-AdvFirewallRules {
            param ([string]$FilePath)
            $Name = "8-002 Advanced Firewall Rules"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = netsh advfirewall firewall show rule name=all verbose | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-AdvFirewallRules -FilePath $FilePath


        # 8-003
        function Get-DefenderExclusions {
            param ([string]$FilePath)
            $Name = "8-003 Defender Exclusions"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-MpPreference
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
                }
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-Message("``$Name`` done...") -Blue
        }
        Get-DefenderExclusions -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-FirewallHtmlPage` function

    # (9)
    function Export-BitLockerHtmlPage {
        [CmdletBinding()]
        param (
            [string]$FilePath
        )
        Add-Content -Path $FilePath -Value $HtmlHeader


        #* 9-001
        function Get-BitlockerRecoveryKeys {
            param ([string]$FilePath)
            $Name = "9-001 BitLocker Data"
            Show-Message("Running ``$Name`` command") -Header -Gray
            try {
                $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String
                if ($Data.Count -eq 0) {
                    Show-Message("No data found for ``$Name``")
                }
                else {
                    Save-OutputToHtmlFile -FromString $Name $Data $FilePath
                }
                function Search-BitlockerVolumes {
                    # Get all BitLocker-protected drives on the computer
                    $BitlockerVolumes = $Data1

                    # Iterate through each drive
                    foreach ($Vol in $BitlockerVolumes) {
                        $DriveLetter = $Vol.MountPoint
                        $ProtectionStatus = $Vol.ProtectionStatus
                        $LockStatus = $Vol.LockStatus
                        $RecoveryKey = $Vol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

                        # Write output based on the protection status of each drive
                        if ($ProtectionStatus -eq "On" -and $Null -ne $RecoveryKey) {
                            $Message = "    [*] Drive $DriveLetter Recovery Key -> $($RecoveryKey.RecoveryPassword)"
                            Add-Content -Path $BitLockerHtmlOutputFile -Value "<pre> $Message </pre>" -NoNewline
                        }
                        elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                            $Message = "    [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted"
                            Add-Content -Path $BitLockerHtmlOutputFile -Value "<pre> $Message </pre>" -NoNewline
                        }
                        else {
                            $Message = "    [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker"
                            Add-Content -Path $BitLockerHtmlOutputFile -Value "<pre> $Message </pre>" -NoNewline
                        }
                    }
                }
                Search-BitlockerVolumes
            }
            catch {
                # Error handling
                $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
                Show-Message("$ErrorMessage") -Red
                Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Add-Content -Path $BitLockerHtmlOutputFile -Value "</p></div>"

            Show-Message("``$Name`` done...") -Blue
        }
        Get-BitlockerRecoveryKeys -FilePath $FilePath


        Add-Content -Path $FilePath -Value $EndingHtml
    }  # End of `Export-BitLockerHtmlPage` function









    # Export-DeviceHtmlPage -FilePath $DeviceHtmlOutputFile        #1
    # Export-UserHtmlPage -FilePath $UserHtmlOutputFile            #2
    # Export-NetworkHtmlPage -FilePath $NetworkHtmlOutputFile      #3
    # Export-ProcessHtmlPage -FilePath $ProcessHtmlOutputFile      #4
    Export-SystemHtmlPage -FilePath $SystemHtmlOutputFile        #5
    # Export-PrefetchHtmlPage -FilePath $PrefetchHtmlOutputFile    #6

    # Export-FirewallHtmlPage -FilePath $FirewallHtmlOutputFile    #8
    # Export-BitLockerHtmlPage -FilePath $BitLockerHtmlOutputFile  #9


    Show-Message("tx3-triage script has completed successfully. . .") -Header -Green

}


Export-ModuleMember -Function Export-HtmlReport
