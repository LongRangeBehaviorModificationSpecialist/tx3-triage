$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


Import-Module -Name .\html\vars.psm1 -Global -Force
Import-Module -Name .\html\HtmlReportStaticPages.psm1 -Global -Force


# $ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"



function Save-OutputToHtmlFile {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [Parameter(Mandatory, Position = 1)]
        [object]$Data,
        [Parameter(Mandatory, Position = 2)]
        [string]$OutputFilePath,
        [switch]$FromPipe,
        [switch]$FromString
        # [switch]$BitLocker
    )

    process {

#         $PreContent = "`n</h5>
# <button type='button' class='collapsible'>$($Name)</button>
# <div class='content'>
# <pre>
# <p>"

        $PreContentEdit = "
<button type='button' class='collapsible'>$($Name)</button>
<div class='content'>
<pre>
<p>"

        $PostContent = "
</p>
</pre>
</div>"

        if ($FromPipe) {
            # $Data | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $Name $PreContentEdit" -PostContent $PostContent | Out-File -Append $OutputFilePath -Encoding UTF8
            $Data | ConvertTo-Html -As List -Fragment -Precontent $PreContentEdit -PostContent $PostContent | Out-File -Append $OutputFilePath -Encoding UTF8
        }

        if ($FromString) {
            # Add-Content -Path $OutputFilePath -Value "<h5 class='info_header'> $Name $PreContent $Data $PostContent" -NoNewline
            Add-Content -Path $OutputFilePath -Value "$PreContentEdit $Data $PostContent" -NoNewline
        }

        # if ($BitLocker)
    }
}


function Show-FinishedHtmlMessage {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    Show-Message("'$Name' done...") -Green
}


function Export-HtmlReport {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]
        [string]$ComputerName,
        [Parameter(Position = 2)]
        [string]$Date,
        [Parameter(Position = 3)]
        [string]$Time,
        [Parameter(Position = 4)]
        [string]$Ipv4,
        [Parameter(Position = 5)]
        [string]$Ipv6,
        [Parameter(Position = 6)]
        [string]$User,
        [Parameter(Position = 7)]
        [string]$Agency,
        [Parameter(Position = 8)]
        [string]$CaseNumber
    )


    [datetime]$HtmlStartTime = (Get-Date).ToUniversalTime()
    [datetime]$StartTimeString = Get-Date -UFormat "%A %B %d, %Y %H:%M:%S %Z"


    $HtmlModulesDirectory = "html\htmlModules"


    foreach ($file in (Get-ChildItem -Path $HtmlModulesDirectory -Filter *.psm1 -Force)) {
        Import-Module -Name $file.FullName -Force -Global
        write-host "Module: '$($file.Name)' was imported successfully"
    }

    Show-Message("Triage Exam Began at $StartTimeString") -NoTime -Header -Yellow


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


    # Create the `readme.css` file
    $ReadMeCssFile = New-Item -Path "$CssFolder\readme.css" -ItemType File
    Add-Content -Path $ReadmeCssFile -Value $ReadMeHtmlFileCss

    # Create the `nav.css` file
    $NavCssFile = New-Item -Path "$CssFolder\nav.css" -ItemType File
    Add-Content -Path $NavCssFile -Value $NavHtmlFileCss

    # Create the `front.css` file
    $FrontCssFile = New-Item -Path "$CssFolder\front.css" -ItemType File
    Add-Content -Path $FrontCssFile -Value $FrontHtmlFileCss

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


    function Invoke-DeviceOutput {
        $DeviceHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "001_DeviceInfo.html"
        Export-DeviceHtmlPage -FilePath $DeviceHtmlOutputFile
    }

    function Invoke-UserOutput {
        $UserHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "002_UserInfo.html"
        Export-UserHtmlPage -FilePath $UserHtmlOutputFile
    }

    function Invoke-NetworkOutput {
        $NetworkHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "003_NetworkInfo.html"
        Export-NetworkHtmlPage -FilePath $NetworkHtmlOutputFile
    }

    function Invoke-ProcessOutput {
        $ProcessHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "004_ProcessInfo.html"
        Export-ProcessHtmlPage -FilePath $ProcessHtmlOutputFile
    }

    function Invoke-SystemOutput {
        $SystemHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "005_SystemInfo.html"
        Export-SystemHtmlPage -FilePath $SystemHtmlOutputFile
    }

    function Invoke-PrefetchOutput {
        $PrefetchHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "006_PrefetchInfo.html"
        Export-PrefetchHtmlPage -FilePath $PrefetchHtmlOutputFile
    }

    function Invoke-EventLogOutput {
        $EventLogHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "007_EventLogInfo.html"
        Export-EventLogHtmlPage -FilePath $EventLogHtmlOutputFile
    }

    function Invoke-FirewallOutput {
        $FirewallHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "008_FirewallInfo.html"
        Export-FirewallHtmlPage -FilePath $FirewallHtmlOutputFile
    }

    function Invoke-BitLockerOutput {
        $BitLockerHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "009_BitLockerInfo.html"
        Export-BitLockerHtmlPage -FilePath $BitLockerHtmlOutputFile
    }


    # Run the functions
    try {
        Invoke-DeviceOutput
        Invoke-UserOutput
        Invoke-NetworkOutput
        Invoke-ProcessOutput
        Invoke-SystemOutput
        Invoke-PrefetchOutput
        # Invoke-EventLogOutput
        Invoke-FirewallOutput
        Invoke-BitLockerOutput
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
    }


    Show-Message("tx3-triage script has completed successfully. . .") -Header -Green

    $HtmlEndTime = (Get-Date).ToUniversalTime()
    $HtmlDuration = New-TimeSpan -Start $HtmlStartTime -End $HtmlEndTime
    $HtmlExeTime = "$($HtmlDuration.Days) days $($HtmlDuration.Hours) hours $($HtmlDuration.Minutes) minutes $($HtmlDuration.Seconds) seconds"

    Show-Message("Script execution completed in: $HtmlExeTime`n") -Header -Green
}


Export-ModuleMember -Function Export-HtmlReport, Save-OutputToHtmlFile, Show-FinishedHtmlMessage -Variable *
