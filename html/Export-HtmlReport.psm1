$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Save-OutputToSingleHtmlFile {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Name,
        [Parameter(Mandatory = $True, Position = 1)]
        [object]$Data,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$OutputHtmlFilePath,
        [Parameter(Mandatory = $True, Position = 3)]
        [string]$Title,
        [switch]$FromPipe,
        [switch]$FromString
    )

    process {
        Add-Content -Path $OutputHtmlFilePath -Value $HtmlHeader

        if ($FromPipe) {
            $Data | ConvertTo-Html -As List -Fragment -PreContent "<h3>$Title</h3>" | Out-File -Append $OutputHtmlFilePath -Encoding UTF8
        }
        if ($FromString) {
            Add-Content -Path $OutputHtmlFilePath -Value "<h3>$Title</h3>"
            Add-Content -Path $OutputHtmlFilePath -Value "<pre>`n<p>`n$Data`n</p>`n</pre>" -NoNewline
        }
        Add-Content -Path $OutputHtmlFilePath -Value $HtmlFooter
    }
}


function Write-HtmlLogEntry {

    [CmdletBinding()]

    param (
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

    if (-not $Message) {
        throw "The message parameter cannot be empty."
    }

    $MsgLevel = switch ($True) {
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

function Invoke-ShowErrorMessage {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$ScriptName,
        [Parameter(Mandatory = $True, Position = 1)]
        [int]$LineNumber,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$Message
    )

        $ErrorMessage = "In Module: $ScriptName (Ln: $LineNumber), MESSAGE: $Message"
        Show-Message("[ERROR] $ErrorMessage") -Red
        Write-HtmlLogEntry("$ErrorMessage") -ErrorMessage
}


Import-Module -Name .\html\HtmlSnippets.psm1 -Global -Force
Import-Module -Name .\html\Get-HtmlFileHashes.psm1 -Global -Force


function Invoke-SaveOutputMessage {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FunctionName,
        [Parameter(Mandatory = $True, Position = 1)]
        [int]$LineNumber,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$Name,
        [string]$FileName,
        [switch]$Start,
        [switch]$Finish
    )

    if ($Start) {
        $msg = "Saving output from '$($Name)'"
    }
    if ($Finish) {
        $msg = "Output from '$($Name)' saved to '$FileName'"
    }
    Show-Message("[INFO] $msg") -Blue
    Write-HtmlLogEntry("[$($FunctionName), Ln: $LineNumber] $msg")
}


function Invoke-NoDataFoundMessage {

    param (
        [string]$Name,
        [string]$FilePath,
        [string]$Title
    )

    $msg = "No data found for '$($Name)'"
    Show-Message("[WARNING] $msg") -Yellow
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $msg")
    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<button type='button' class='collapsible'>$($FileName)<span class='bold_red'>[No data found]</span></button>`n"
}


function Show-FinishedHtmlMessage {

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Name
    )

    Show-Message("[INFO] '$Name' done.") -Blue
}


function Export-HtmlReport {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$User,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]$Agency,
        [Parameter(Mandatory = $True, Position = 3)]
        [string]$CaseNumber,
        [Parameter(Mandatory = $True, Position = 4)]
        [string]$ComputerName,
        [Parameter(Mandatory = $True, Position = 5)]
        [string]$Ipv4,
        [Parameter(Mandatory = $True, Position = 6)]
        [string]$Ipv6,
        [bool]$Edd,
        [bool]$GetNTUserDat,
        [bool]$GetHtmlFileHashes,
        [bool]$MakeArchive
    )


    $FunctionName = $MyInvocation.MyCommand.Name


    [datetime]$HtmlStartTime = (Get-Date).ToUniversalTime()


    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Operator Name Entered: $User")
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Agency Name Entered: $Agency")
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Case Number Entered: $CaseNumber")


    Show-Message("Module file: '.\html\HtmlSnippets.psm1' was imported successfully") -NoTime -Blue
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Module file '.\html\HtmlSnippets.psm1' was imported successfully")


    $HtmlModulesDirectory = "html\htmlModules"


    foreach ($file in (Get-ChildItem -Path $HtmlModulesDirectory -Filter *.psm1 -Force)) {
        Import-Module -Name $file.FullName -Force -Global
        Show-Message("Module file: '.\$($file.Name)' was imported successfully") -NoTime -Blue
        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Module file '.\$($file.Name)' was imported successfully")
    }

    Show-Message("[INFO] tx3-triage script execution began") -Header -Yellow
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Trige exam began")


    $Cwd = Get-Location


    # Create the `Resources` folder in the case folder
    $ResourcesFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "Resources" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$ResourcesFolder' directory was created")


    # Create the `results` folders that need to be made in the `Resources`
    $ResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "results" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$ResultsFolder' directory was created")

    $PagesFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "webpages" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$PagesFolder' directory was created")

    $FilesFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "files" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$FilesFolder' directory was created")


    # Create the folders that need to be made in the `Resources` parent folder
    $CssFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "css" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$CssFolder' directory was created")

    $ImgFolder = Join-Path -Path $ResourcesFolder -ChildPath "images"
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$ImgFolder' directory was created")

    $StaticFolder = New-Item -ItemType Directory -Path $ResourcesFolder -Name "static" -Force
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$StaticFolder' directory was created")

    # Copy the necessary folders to the new case directory
    $MasterImgFolder = Join-Path -Path $Cwd -ChildPath "html\Resources\images"
    Copy-Item  $MasterImgFolder -Destination $ImgFolder -Force -Recurse
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] images files were copied from the source directory to the $($ImgFolder) directory")


    # Create and write the encoded text to the `allstyle.css` file
    $AllStyleCssFile = Join-Path -Path $CssFolder -ChildPath "allstyle.css"
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$AllStyleCssFile' file was created")
    $AllStyleCssDecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($AllStyleCssEncodedText))
    Add-Content -Path $AllStyleCssFile -Value $AllStyleCssDecodedText
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Decoded text was written to '$(Split-Path -Path $AllStyleCssFile -Leaf)'")


    # Set and write the `TriageReport.html` homepage
    $HtmlReportFile = New-Item -Path "$CaseFolderName\main.html" -ItemType File
    Write-MainHtmlPage $HtmlReportFile $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$HtmlReportFile' file was created")


    # Set and write the `readme.html` file
    $ReadMeFile = New-Item -Path "$StaticFolder\readme.html" -ItemType File
    Write-HtmlReadMePage -FilePath $ReadMeFile
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$ReadMeFile' file was created")


    # Create `keywords.txt` file to use to search file names
    $KeywordListFile = "$(Split-Path -Path $PSScriptRoot -Parent)\static\HPFileSearchNames.txt"


    Show-Message("Compiling the tx3-triage report in .html format. Please wait. . . ") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Compiling the tx3-triage report in .html format")


    function Invoke-DeviceHtmlOutput {
        try {
            $DeviceHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "001_DeviceInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-DeviceHtmlPage -FilePath $DeviceHtmlOutputFile -PagesFolder $PagesFolder -FilesFolder $FilesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-UserHtmlOutput {
        try {
            $UserHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "002_UserInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-UserHtmlPage -FilePath $UserHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-NetworkHtmlOutput {
        try {
            $NetworkHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "003_NetworkInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-NetworkHtmlPage -FilePath $NetworkHtmlOutputFile -PagesFolder $PagesFolder -FilesFolder $FilesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-ProcessHtmlOutput {
        try {
            $ProcessHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "004_ProcessInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-ProcessHtmlPage -FilePath $ProcessHtmlOutputFile -PagesFolder $PagesFolder -FilesFolder $FilesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-SystemHtmlOutput {
        try {
            $SystemHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "005_SystemInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-SystemHtmlPage -FilePath $SystemHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-PrefetchHtmlOutput {
        try {
            $PrefetchHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "006_PrefetchInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-PrefetchHtmlPage -FilePath $PrefetchHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-EventLogHtmlOutput {
        try {
            $EventLogHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "007_EventLogInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-EventLogHtmlPage -FilePath $EventLogHtmlOutputFile -PagesFolder $PagesFolder -FilesFolder $FilesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-FirewallHtmlOutput {
        try {
            $FirewallHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "008_FirewallInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-FirewallHtmlPage -FilePath $FirewallHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-BitLockerHtmlOutput {
        try {
            $BitLockerHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "009_BitLockerInfo.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-BitLockerHtmlPage -FilePath $BitLockerHtmlOutputFile -PagesFolder $PagesFolder
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-KeywordSearch {
        try {
            $FilesHtmlOutputFile = Join-Path -Path $PagesFolder -ChildPath "010_FileKeywordMatches.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-FilesHtmlPage -FilePath $FilesHtmlOutputFile -PagesFolder $PagesFolder -KeywordFile $KeywordListFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Invoke-AddOtherData {
        try {
            $OtherDataOutputFile = Join-Path -Path $PagesFolder -ChildPath "011_OtherData.html"
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Add-OtherData -FilePath $OtherDataOutputFile -ComputerName $ComputerName -FilesFolder $FilesFolder -PagesFolder $PagesFolder -Edd $Edd -GetNTUserDat $GetNTUserDat
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    # Run the functions
    function Invoke-AllFunctions {
        try {
            Invoke-DeviceHtmlOutput
            Invoke-UserHtmlOutput
            # Invoke-NetworkHtmlOutput
            # Invoke-ProcessHtmlOutput
            # Invoke-SystemHtmlOutput
            # Invoke-PrefetchHtmlOutput
            # Invoke-EventLogHtmlOutput
            # Invoke-FirewallHtmlOutput
            Invoke-BitLockerHtmlOutput
            # Invoke-KeywordSearch
            Invoke-AddOtherData
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    Invoke-AllFunctions


    function Invoke-GetHtmlFileHashes {
        if ($GetHtmlFileHashes) {
            try {
                Get-HtmlFileHashes $ResultsFolder $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Hash Output Files' option was not selected by the user")
        }
    }

    Invoke-GetHtmlFileHashes


    if ($MakeArchive) {
        Invoke-HtmlCaseArchive
    }


    $FinishedMsg = "tx3-triage script has completed. . ."
    Show-Message("[INFO] $FinishedMsg") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $FinishedMsg")


    $HtmlEndTime = (Get-Date).ToUniversalTime()
    $HtmlDuration = New-TimeSpan -Start $HtmlStartTime -End $HtmlEndTime
    $HtmlExeTime = "$($HtmlDuration.Days) days $($HtmlDuration.Hours) hours $($HtmlDuration.Minutes) minutes $($HtmlDuration.Seconds) seconds"


    Show-Message("Html script execution completed in: $HtmlExeTime`n") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Html script execution completed in: $HtmlExeTime")


    Show-Message("
=========================

TRIAGE SCAN COMPLETED !

=========================") -NoTime -Yellow


    # Show a popup message when script is complete
    # (New-Object -ComObject Wscript.Shell).popup("Html script has finished running", 0, "Done", 0x1) | Out-Null
}


Export-ModuleMember -Function Export-HtmlReport, Save-OutputToSingleHtmlFile, Invoke-SaveOutputMessage, Invoke-NoDataFoundMessage, Show-FinishedHtmlMessage, Write-HtmlLogEntry, Invoke-ShowErrorMessage -Variable *
