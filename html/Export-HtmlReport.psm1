$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Save-OutputToSingleHtmlFile {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]
        $Name,
        [Parameter(Mandatory = $True, Position = 1)]
        [object]
        $Data,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]
        $OutputHtmlFilePath,
        [Parameter(Mandatory = $True, Position = 3)]
        [string]
        $Title,
        [switch]
        $FromPipe,
        [switch]
        $FromString
    )

    process {
        Add-Content -Path $OutputHtmlFilePath -Value $HtmlHeader -Encoding UTF8

        if ($FromPipe) {
            $Data | ConvertTo-Html -As List -Fragment -PreContent "`t`t`t<h3>$Title</h3>" | Out-File -Append $OutputHtmlFilePath -Encoding UTF8
        }

        if ($FromString) {
            Add-Content -Path $OutputHtmlFilePath -Value "`t`t`t<h3>$Title</h3>" -Encoding UTF8
            Add-Content -Path $OutputHtmlFilePath -Value "`t`t`t<pre>`n`t`t`t`t<p>`n$Data`n`t`t`t`t</p>`n`t`t`t</pre>`n`t`t</div>" -NoNewline -Encoding UTF8
        }
        Add-Content -Path $OutputHtmlFilePath -Value "`n`t</body>`n</html>" -Encoding UTF8
    }
}


function Write-HtmlLogEntry {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Message,
        [string]
        $LogFile = $LogFile,
        [switch]
        $NoLevel,
        [switch]
        $DebugMessage,
        [switch]
        $WarningMessage,
        [switch]
        $ErrorMessage,
        [switch]
        $NoTime
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
        [Parameter(Mandatory, Position = 0)]
        [string]
        $FunctionName,
        [Parameter(Mandatory, Position = 1)]
        [int]
        $LineNumber,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Message
    )

        $ErrorMessage = "In [Module: $ModuleName, Function: $FunctionName, Ln: $LineNumber]: MESSAGE: $Message"
        Show-Message("[ERROR] $ErrorMessage") -Red
        Write-HtmlLogEntry("$ErrorMessage") -ErrorMessage
}


Import-Module -Name .\html\HtmlSnippets.psm1 -Global -Force
# Import-Module -Name .\html\Get-HtmlFileHashes.psm1 -Global -Force


function Invoke-SaveOutputMessage {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $FunctionName,
        [Parameter(Mandatory, Position = 1)]
        [int]
        $LineNumber,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Name,
        [string]
        $FileName,
        [switch]
        $Start,
        [switch]
        $Finish
    )

    if ($Start) {
        $msg = "Saving output from '$($Name)'"
    }

    if ($Finish) {
        $msg = "Output saved to -> '$FileName'"
    }
    Show-Message("[INFO] $msg") -Blue
    Write-HtmlLogEntry("[$($FunctionName), Ln: $LineNumber] $msg")
}


function Invoke-NoDataFoundMessage {

    param (
        [string]
        $Name
    )

    $msg = "No data found for '$($Name)'"
    Show-Message("[WARNING] $msg") -Yellow
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $msg")
}


function Show-FinishedHtmlMessage {

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name
    )

    Show-Message("[INFO] '$Name' done.") -Blue
}


function Export-HtmlReport {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Mandatory, Position = 1)]
        [string]$User,
        [Parameter(Mandatory, Position = 2)]
        [string]$Agency,
        [Parameter(Mandatory, Position = 3)]
        [string]$CaseNumber,
        [Parameter(Mandatory, Position = 4)]
        [string]$ComputerName,
        [Parameter(Mandatory, Position = 5)]
        [string]$Ipv4,
        [Parameter(Mandatory, Position = 6)]
        [string]$Ipv6,
        [bool]$Device,
        [bool]$UserData,
        [bool]$Network,
        [bool]$Process,
        [bool]$System,
        [bool]$Prefetch,
        [bool]$EventLogs,
        [bool]$Firewall,
        [bool]$BitLocker,
        [bool]$CaptureProcesses,
        [bool]$GetRam,
        [bool]$Edd,
        [bool]$Hives,
        [bool]$GetNTUserDat,
        [bool]$ListFiles,
        [string]$DriveList,
        [bool]$KeyWordSearch,
        [string]$KeyWordsDriveList,
        [bool]$GetFileHashes,
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
    Add-Content -Path $AllStyleCssFile -Value $AllStyleCssDecodedText -Encoding UTF8
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Decoded text was written to '$(Split-Path -Path $AllStyleCssFile -Leaf)'")


    # Set and write the `TriageReport.html` homepage
    $HtmlReportFile = Join-Path -Path $CaseFolderName -ChildPath "main.html"
    Write-MainHtmlPage $HtmlReportFile $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$HtmlReportFile' file was created")


    # Set and write the `readme.html` file
    $ReadMeFile = New-Item -Path "$StaticFolder\readme.html" -ItemType File
    Write-HtmlReadMePage -FilePath $ReadMeFile
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$ReadMeFile' file was created")


    # Create `keywords.txt` file to use to search file names
    $KeywordListFile = "$(Split-Path -Path $PSScriptRoot -Parent)\static\HPFileSearchNames2.txt"


    Show-Message("Compiling the tx3-triage report in .html format. Please wait. . . ") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Compiling the tx3-triage report in .html format")


    function Invoke-GetHtmlProcesses {
        if ($CaptureProcesses) {
            try {
                $ProcessHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "Processes" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-HtmlRunningProcesses -OutputFolder $ProcessHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Collect Running Processes' option was not selected by the user")
        }
    }
    Invoke-GetHtmlProcesses


    function Invoke-GetHtmlMachineRam {
        if ($GetRam) {
            try {
                $RamHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "RAM" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-HtmlComputerRam -OutputFolder $RamHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Collect RAM' option was not selected by the user")
        }
    }
    Invoke-GetHtmlMachineRam


    function Invoke-Edd {
        if ($Edd) {
            try {
                $EddHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "Edd" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlEncryptedDiskDetector -OutputFolder $EddHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Run Encrypted Disk Detector' option was not selected by the user")
        }
    }
    Invoke-Edd


    function Invoke-CopyRegistryHives  {
        if ($Hives) {
            try {
                $RegistryHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "RegHives" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlCopyRegistryHives -OutputFolder $RegistryHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Copy Registry Hives' option was not selected by the user")
        }
    }
    Invoke-CopyRegistryHives


    function Invoke-DeviceHtmlOutput {
        if ($Device) {
            try {
                $DeviceHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "001" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-DeviceHtmlPage -OutputFolder $DeviceHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Device Data' option was not selected by the user")
        }
    }
    Invoke-DeviceHtmlOutput


    function Invoke-UserHtmlOutput {
        if ($UserData) {
            try {
                $UserHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "002" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-UserHtmlPage -OutputFolder $UserHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get User Data' option was not selected by the user")
        }
    }
    Invoke-UserHtmlOutput


    function Invoke-NetworkHtmlOutput {
        if ($Network) {
            try {
                $NetworkHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "003" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-NetworkHtmlPage -OutputFolder $NetworkHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Network Data' option was not selected by the user")
        }
    }
    Invoke-NetworkHtmlOutput


    function Invoke-ProcessHtmlOutput {
        if ($Process) {
            try {
                $ProcessHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "004" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-ProcessHtmlPage -OutputFolder $ProcessHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Process Data' option was not selected by the user")
        }
    }
    Invoke-ProcessHtmlOutput


    function Invoke-SystemHtmlOutput {
        if ($System) {
            try {
                $SystemHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "005" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-SystemHtmlPage -OutputFolder $SystemHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get System Data' option was not selected by the user")
        }
    }
    Invoke-SystemHtmlOutput


    function Invoke-PrefetchHtmlOutput {
        if ($Prefetch) {
            try {
                $PrefetchHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "006" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-PrefetchHtmlPage -OutputFolder $PrefetchHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Prefetch Data' option was not selected by the user")
        }
    }
    Invoke-PrefetchHtmlOutput


    function Invoke-EventLogHtmlOutput {
        if ($EventLogs) {
            try {
                $EventLogHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "007" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-EventLogHtmlPage -OutputFolder $EventLogHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Event Log Data' option was not selected by the user")
        }
    }
    Invoke-EventLogHtmlOutput


    function Invoke-FirewallHtmlOutput {
        if ($Firewall) {
            try {
                $FirewallHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "008" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-FirewallHtmlPage -OutputFolder $FirewallHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get Firewall Data' option was not selected by the user")
        }
    }
    Invoke-FirewallHtmlOutput


    function Invoke-BitLockerHtmlOutput {
        if ($BitLocker) {
            try {
                $BitLockerHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "009" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-BitLockerHtmlPage -OutputFolder $BitLockerHtmlOutputFolder -HtmlReportFile $HtmlReportFile
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Get BitLocker Data' option was not selected by the user")
        }
    }
    Invoke-BitLockerHtmlOutput


    function Invoke-NTUser {
        if ($GetNTUserDat) {
            try {
                $NTUserHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "NTUser" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlNTUserDatFiles -OutputFolder $NTUserHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Copy NTUSER.DAT Files' option was not selected by the user")
        }
    }
    Invoke-NTUser


    function Invoke-ListFiles {
        if ($ListFiles) {
            try {
                $FilesListHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "FilesList" -Force
                Write-HtmlLogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlListAllFiles -OutputFolder $FilesListHtmlOutputFolder -DriveList $DriveList -HtmlReportFile $HtmlReportFile
                # -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
                Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'List All Files' option was not selected by the user")
        }
    }
    Invoke-ListFiles


    function Invoke-KeywordSearch {
        if ($KeyWordSearch) {
            try {
                $KeywordsHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "010" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Export-HtmlKeywordSearchPage -OutputFolder $KeywordsHtmlOutputFolder -KeywordListFile $KeywordListFile -HtmlReportFile $HtmlReportFile -KeyWordsDriveList $KeyWordsDriveList
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Search for Keywords' option was not selected by the user")
        }
    }
    Invoke-KeywordSearch


    #! Write the closing html text to the main file
    Add-Content -Path $HtmlReportFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8


    function Invoke-GetFileHashes {
        if ($GetFileHashes) {
            try {
                $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "HashResults" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-HtmlFileHashes -OutputFolder $HashResultsFolder -ResultsFolder $ResultsFolder -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Hash Output Files' option was not selected by the user")
        }
    }
    Invoke-GetFileHashes


    function Invoke-GetHtmlCaseArchive {
        if ($MakeArchive) {
            try {
                Invoke-HtmlCaseArchive
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Make Case Archive' option was not selected by the user")
        }
    }
    Invoke-GetHtmlCaseArchive


    $HtmlEndTime = (Get-Date).ToUniversalTime()
    $HtmlDuration = New-TimeSpan -Start $HtmlStartTime -End $HtmlEndTime
    $HtmlExeTime = "$($HtmlDuration.Days) days $($HtmlDuration.Hours) hours $($HtmlDuration.Minutes) minutes $($HtmlDuration.Seconds) seconds"


    # Show-Message("tx3-triage script execution completed in: $HtmlExeTime`n") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Html script execution completed in: $HtmlExeTime")


    Show-Message("
===========================================================

TRIAGE SCAN COMPLETED in $HtmlExeTime

===========================================================") -NoTime -Yellow


    Show a popup message when script is complete
    (New-Object -ComObject Wscript.Shell).popup("Html script has finished running", 0, "Done", 0x1) | Out-Null
}


Export-ModuleMember -Function Export-HtmlReport, Save-OutputToSingleHtmlFile, Invoke-SaveOutputMessage, Invoke-NoDataFoundMessage, Show-FinishedHtmlMessage, Write-HtmlLogEntry, Invoke-ShowErrorMessage -Variable *
