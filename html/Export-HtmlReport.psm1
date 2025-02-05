$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


# $ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"


function Save-OutputToHtmlFile {

    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [Parameter(Mandatory, Position = 1)]
        [object]$Data,
        [Parameter(Mandatory, Position = 2)]
        [string]$OutputFilePath,
        [switch]$FromPipe,
        [switch]$FromString
    )

    process {

        $PreContent = "
<button type='button' class='collapsible'>$($Name)</button>
<div class='content'>
<pre>
<p>"

        $PostContent = "
</p>
</pre>
</div>"

        if ($FromPipe)
        {
            $Data | ConvertTo-Html -As List -Fragment -Precontent $PreContent -PostContent $PostContent | Out-File -Append $OutputFilePath -Encoding UTF8
        }
        if ($FromString)
        {
            Add-Content -Path $OutputFilePath -Value "$PreContent $Data $PostContent" -NoNewline
        }
    }
}


function Save-OutputToSingleHtmlFile {

    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [Parameter(Mandatory, Position = 1)]
        [object]$Data,
        [Parameter(Mandatory, Position = 2)]
        [string]$OutputHtmlFilePath,
        [switch]$FromPipe,
        [switch]$FromString
    )

    process
    {
        Add-Content -Path $OutputHtmlFilePath -Value $HtmlDetailsHeader

        if ($FromPipe)
        {
                $Data | ConvertTo-Html -As List -Fragment | Out-File -Append $OutputHtmlFilePath -Encoding UTF8
        }
        if ($FromString)
        {
            Add-Content -Path $OutputHtmlFilePath -Value "<pre>`n$Data`n</pre>" -NoNewline
        }

        Add-Content -Path $OutputHtmlFilePath -Value $EndingHtml
    }
}




function Write-HtmlLogEntry {

    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory = $True)]
        [string]$Message,
        [string]$LogFile = $LogFile,
        [switch]$NoLevel,
        [switch]$DebugMessage,
        [switch]$WarningMessage,
        [switch]$ErrorMessage,
        [switch]$NoTime
    )

    $LogFolderPath = New-Item -ItemType Directory -Path $CaseFolderName -Name "Logs" -Force
    $LogFileName = "$($RunDate)_$($Ipv4)_$($ComputerName)_Log.log"

    $LogFile = "$LogFolderPath\$LogFileName"

    if (-not $Message)
    {
        throw "The message parameter cannot be empty."
    }

    $MsgLevel = switch ($True)
    {
        $DebugMessage { " [DEBUG] "; break }
        $WarningMessage { " [WARNING] "; break }
        $ErrorMessage { " [ERROR] "; break }
        default { " [INFO] " }
    }

    $MsgLevel = if (-not $NoLevel) { $MsgLevel } else { "" }

    # Generate timestamp if -NoTime is not provided
    $DisplayTimeStamp = if (-not $NoTime) { $(Get-TimeStamp) } else { "" }

    # Format the full message
    $FormattedMessage = $DisplayTimeStamp + $MsgLevel + $Message

    Add-Content -Path $LogFile -Value $FormattedMessage -Encoding UTF8
}


Import-Module -Name .\html\vars.psm1 -Global -Force
Show-Message("Module file '.\html\vars.psm1' was imported successfully") -NoTime -Blue
Write-HtmlLogEntry("[$($PSCommandPath), Ln: $(Get-LineNum)] Module file ``.\html\vars.psm1`` was imported successfully")

Import-Module -Name .\html\HtmlReportStaticPages.psm1 -Global -Force
Show-Message("Module file '.\html\HtmlReportStaticPages.psm1' was imported successfully") -NoTime -Blue
Write-HtmlLogEntry("[$($PSCommandPath), Ln: $(Get-LineNum)] Module file ``.\html\HtmlReportStaticPages.psm1`` was imported successfully")



function Show-FinishedHtmlMessage {

    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    Show-Message("[INFO] ``$Name`` done...") -Blue
}


function Export-HtmlReport {

    [CmdletBinding()]

    param
    (
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


    $FunctionName = $MyInvocation.MyCommand.Name


    [datetime]$HtmlStartTime = (Get-Date).ToUniversalTime()
    # [datetime]$StartTimeString = Get-Date -UFormat "%A %B %d, %Y %H:%M:%S %Z"
    [string]$StartTimeString = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff K"

    $HtmlModulesDirectory = "html\htmlModules"


    foreach ($file in (Get-ChildItem -Path $HtmlModulesDirectory -Filter *.psm1 -Force))
    {
        Import-Module -Name $file.FullName -Force -Global
        Show-Message("Module file: ``.\$($file.Name)`` was imported successfully") -NoTime -Blue
        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Module file ``.\$($file.Name)`` was imported successfully")
    }

    Show-Message("Triage exam began at $StartTimeString") -NoTime -Header -Yellow
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Trige exam began at $StartTimeString")


    # $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

    $Cwd = Get-Location


    # Create the `Resources` folder in the case folder
    $ResourcesFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Resources" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$ResourcesFolder`` directory was created")

    # Create the folders that need to be made in the `Resources` parent folder
    $CssFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "css" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$CssFolder`` directory was created")

    $PagesFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "htmlpages" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$PagesFolder`` directory was created")

    $StaticFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "static" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$StaticFolder`` directory was created")

    $FilesFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "files" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$FilesFolder`` directory was created")

    $ImgFolder = Join-Path -Path $ResourcesFolder -ChildPath "images"
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$ImgFolder`` directory was created")


    $MasterImgFolder = Join-Path -Path $Cwd -ChildPath "html\Resources\images"
    # Copy the necessary folders to the new case directory
    Copy-Item  $MasterImgFolder -Destination $ImgFolder -Force -Recurse
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] images files were copied from the source directory to the $($ImgFolder) directory")


    # Write the encoded text to the `style.css` file
    $CssStyleFileName = Join-Path -Path $CssFolder -ChildPath "style.css"
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$CssStyleFileName`` file was created")
    $CssDecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($CssEncodedFileText))
    Add-Content -Path $CssStyleFileName -Value $CssDecodedText
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Decoded text was written to '$(Split-Path -Path $CssStyleFileName -Leaf)'")


    # Write the encoded text to the `styledetails.css` file
    $CssStyleDetailsFileName = Join-Path -Path $CssFolder -ChildPath "styledetails.css"
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$CssStyleDetailsFileName`` file was created")
    $CssDetailsDecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($CssDetailsEncodedFileText))
    Add-Content -Path $CssStyleDetailsFileName -Value $CssDetailsDecodedText
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Decoded text was written to '$(Split-Path -Path $CssStyleDetailsFileName -Leaf)'")


    # Create the `readme.css` file
    $ReadMeCssFile = New-Item -Path "$CssFolder\readme.css" -ItemType File
    Add-Content -Path $ReadmeCssFile -Value $ReadMeHtmlFileCss
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$ReadMeCssFile`` file was created")


    # Create the `nav.css` file
    $NavCssFile = New-Item -Path "$CssFolder\nav.css" -ItemType File
    Add-Content -Path $NavCssFile -Value $NavHtmlFileCss
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$NavCssFile`` file was created")


    # Create the `front.css` file
    $FrontCssFile = New-Item -Path "$CssFolder\front.css" -ItemType File
    Add-Content -Path $FrontCssFile -Value $FrontHtmlFileCss
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$FrontCssFile`` file was created")


    # Set and write the `TriageReport.html` homepage
    $HtmlReportFile = New-Item -Path "$CaseFolderName\TriageReport.html" -ItemType File
    Write-HtmlHomePage -FilePath $HtmlReportFile
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$HtmlReportFile`` file was created")


    # Set and write the `nav.html` file to be displayed in the `TriageReport.html` page
    $NavReportFile = New-Item -Path "$StaticFolder\nav.html" -ItemType File
    Write-HtmlNavPage -FilePath $NavReportFile
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$NavReportFile`` file was created")


    # Set and write the `front.html` file to be displayed in the `TriageReport.html` page
    $FrontReportFile = New-Item -Path "$StaticFolder\front.html" -ItemType File
    Write-HtmlFrontPage -FilePath $FrontReportFile -User $User -ComputerName $ComputerName -Ipv4 $Ipv4 -Ipv6 $Ipv6
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$FrontReportFile`` file was created")


    # Set and write the `readme.html` file
    $ReadMeFile = New-Item -Path "$StaticFolder\readme.html" -ItemType File
    Write-HtmlReadMePage -FilePath $ReadMeFile
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$ReadMeFile`` file was created")


    # Create `keywords.txt` file to use to search file names
    $KeywordListFile = "$($PSScriptRoot)\static\SearchTerms.txt"


    Show-Message("Compiling the tx3-triage report in .html format. Please wait. . . ") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Compiling the tx3-triage report in .html format")


    function Invoke-DeviceOutput {
        try
        {
            $DeviceHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "001_DeviceInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-DeviceHtmlPage -FilePath $DeviceHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-UserOutput {
        try
        {
            $UserHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "002_UserInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-UserHtmlPage -FilePath $UserHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"

            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-NetworkOutput {
        try
        {
            $NetworkHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "003_NetworkInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-NetworkHtmlPage -FilePath $NetworkHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-ProcessOutput {
        try
        {
            $ProcessHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "004_ProcessInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-ProcessHtmlPage -FilePath $ProcessHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-SystemOutput {
        try
        {
            $SystemHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "005_SystemInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-SystemHtmlPage -FilePath $SystemHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-PrefetchOutput {
        try
        {
            $PrefetchHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "006_PrefetchInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-PrefetchHtmlPage -FilePath $PrefetchHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-EventLogOutput {
        try
        {
            $EventLogHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "007_EventLogInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-EventLogHtmlPage -FilePath $EventLogHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    function Invoke-FirewallOutput {
        try
        {
            $FirewallHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "008_FirewallInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-FirewallHtmlPage -FilePath $FirewallHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }

    }

    function Invoke-BitLockerOutput {
        try
        {
            $BitLockerHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "009_BitLockerInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-BitLockerHtmlPage -FilePath $BitLockerHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }

    }

    function Invoke-FilesOutput {
        try
        {
            $FilesHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "010_FilesInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] ``$($MyInvocation.MyCommand.Name)`` function was run")
            Export-FilesHtmlPage -FilePath $FilesHtmlOutputFile -KeywordFile $KeywordListFile
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }


    # Run the functions
    function Invoke-AllFunctions
    {
        try
        {
            # Invoke-DeviceOutput
            # Invoke-UserOutput
            # Invoke-NetworkOutput
            # Invoke-ProcessOutput
            # Invoke-SystemOutput
            # Invoke-PrefetchOutput
            # Invoke-EventLogOutput
            # Invoke-FirewallOutput
            Invoke-BitLockerOutput
            # Invoke-FilesOutput
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            Write-HtmlLogEntry("[ERROR] $ErrorMessage")
        }
    }

    Invoke-AllFunctions


    Show-Message("tx3-triage script has completed successfully. . .") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] tx3-triage script has completed successfully")


    $HtmlEndTime = (Get-Date).ToUniversalTime()
    $HtmlDuration = New-TimeSpan -Start $HtmlStartTime -End $HtmlEndTime
    $HtmlExeTime = "$($HtmlDuration.Days) days $($HtmlDuration.Hours) hours $($HtmlDuration.Minutes) minutes $($HtmlDuration.Seconds) seconds"


    Show-Message("Script execution completed in: $HtmlExeTime`n") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Script execution completed in: $HtmlExeTime")

}


Export-ModuleMember -Function Export-HtmlReport, Save-OutputToHtmlFile, Save-OutputToSingleHtmlFile, Show-FinishedHtmlMessage, Write-HtmlLogEntry -Variable *
