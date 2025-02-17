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
        [Parameter(Mandatory = $True, Position = 0)]
        [string]
        $ScriptName,
        [Parameter(Mandatory = $True, Position = 1)]
        [int]
        $LineNumber,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]
        $Message
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
        [string]
        $FunctionName,
        [Parameter(Mandatory = $True, Position = 1)]
        [int]
        $LineNumber,
        [Parameter(Mandatory = $True, Position = 2)]
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
        [Parameter(Mandatory = $True, Position = 0)]
        [string]
        $Name
    )

    Show-Message("[INFO] '$Name' done.") -Blue
}


function Export-HtmlReport {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]
        $CaseFolderName,
        [Parameter(Mandatory = $True, Position = 1)]
        [string]
        $User,
        [Parameter(Mandatory = $True, Position = 2)]
        [string]
        $Agency,
        [Parameter(Mandatory = $True, Position = 3)]
        [string]
        $CaseNumber,
        [Parameter(Mandatory = $True, Position = 4)]
        [string]
        $ComputerName,
        [Parameter(Mandatory = $True, Position = 5)]
        [string]
        $Ipv4,
        [Parameter(Mandatory = $True, Position = 6)]
        [string]
        $Ipv6,
        [bool]
        $Processes,
        [bool]
        $GetRam,
        [bool]
        $Edd,
        [bool]
        $Hives,
        [bool]
        $GetNTUserDat,
        [bool]
        $ListFiles,
        [string]
        $DriveList,
        [bool]
        $KeyWordSearch,
        [string]
        $KeyWordsDriveList,
        [bool]
        $GetHtmlFileHashes,
        [bool]
        $MakeArchive
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
    Add-Content -Path $AllStyleCssFile -Value $AllStyleCssDecodedText
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
        if ($Processes) {
            try {
                $ProcessHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "Processes" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-HtmlRunningProcesses -ProcessHtmlOutputFolder $ProcessHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
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
                Get-HtmlComputerRam -RamHtmlOutputFolder $RamHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
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
                Invoke-HtmlEncryptedDiskDetector -EddHtmlOutputFolder $EddHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Run Encrypted Disk Detector' option was not selected by the user")
        }
    }
    Invoke-Edd


    function Invoke-CopyRegistryHives {
        if ($Hives) {
            try {
                $RegistryHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "RegistryHives" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlCopyRegistryHives -RegistryHtmlOutputFolder $RegistryHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Copy Registry Hives' option was not selected by the user")
        }
    }
    Invoke-CopyRegistryHives


    function Invoke-DeviceHtmlOutput {
        try {
            $DeviceHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "001" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-DeviceHtmlPage -DeviceHtmlOutputFolder $DeviceHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-UserHtmlOutput {
        try {
            $UserHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "002" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-UserHtmlPage -UserHtmlOutputFolder $UserHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-NetworkHtmlOutput {
        try {
            $NetworkHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "003" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-NetworkHtmlPage -NetworkHtmlOutputFolder $NetworkHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-ProcessHtmlOutput {
        try {
            $ProcessHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "004" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-ProcessHtmlPage -ProcessHtmlOutputFolder $ProcessHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-SystemHtmlOutput {
        try {
            $SystemHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "005" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-SystemHtmlPage -SystemHtmlOutputFolder $SystemHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-PrefetchHtmlOutput {
        try {
            $PrefetchHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "006" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-PrefetchHtmlPage -PrefetchHtmlOutputFolder $PrefetchHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-EventLogHtmlOutput {
        try {
            $EventLogHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "007" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-EventLogHtmlPage -EventLogHtmlOutputFolder $EventLogHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-FirewallHtmlOutput {
        try {
            $FirewallHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "008" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-FirewallHtmlPage -FirewallHtmlOutputFolder $FirewallHtmlOutputFolder -HtmlReportFile $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Invoke-BitLockerHtmlOutput {
        try {
            $BitLockerHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "009" -Force
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
            Export-BitLockerHtmlPage -BitLockerHtmlOutputFolder $BitLockerHtmlOutputFolder -HtmlReportFile $HtmlReportFile
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
            Invoke-NetworkHtmlOutput
            Invoke-ProcessHtmlOutput
            Invoke-SystemHtmlOutput
            Invoke-PrefetchHtmlOutput
            Invoke-EventLogHtmlOutput
            Invoke-FirewallHtmlOutput
            Invoke-BitLockerHtmlOutput

            #! Write the closing html text to the main file
            Write-MainHtmlPageEnd -FilePath $HtmlReportFile
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }
    Invoke-AllFunctions


    function Invoke-NTUser {
        if ($GetNTUserDat) {
            try {
                $NTUserHtmlOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name "NTUser" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlNTUserDatFiles -NTUserHtmlOutputFolder $NTUserHtmlOutputFolder -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
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
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Invoke-HtmlListAllFiles -FilesListHtmlOutputFolder $FilesListHtmlOutputFolder -DriveList $DriveList -HtmlReportFile $HtmlReportFile -ComputerName $ComputerName
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
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
                Export-HtmlKeywordSearchPage -KeywordsHtmlOutputFolder $KeywordsHtmlOutputFolder -KeywordListFile $KeywordListFile -HtmlReportFile $HtmlReportFile -KeyWordsDriveList $KeyWordsDriveList
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
        }
        else {
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] The 'Search for Keywords' option was not selected by the user")
        }
    }
    Invoke-KeywordSearch


    function Invoke-GetHtmlFileHashes {
        if ($GetHtmlFileHashes) {
            try {
                $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name "HashResults" -Force
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] '$($MyInvocation.MyCommand.Name)' function was run")
                Get-HtmlFileHashes -HashResultsFolder $HashResultsFolder -ResultsFolder $ResultsFolder -ComputerName $ComputerName
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


    function Invoke-GetHtmlCaseArchive {
        if ($MakeArchive) {
            try {
                Invoke-HtmlCaseArchive
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
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


    Show-Message("tx3-triage script execution completed in: $HtmlExeTime`n") -Header -Green
    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Html script execution completed in: $HtmlExeTime")


    Show-Message("
=========================

TRIAGE SCAN COMPLETED !

=========================") -NoTime -Yellow


    Show a popup message when script is complete
    (New-Object -ComObject Wscript.Shell).popup("Html script has finished running", 0, "Done", 0x1) | Out-Null
}


Export-ModuleMember -Function Export-HtmlReport, Save-OutputToSingleHtmlFile, Invoke-SaveOutputMessage, Invoke-NoDataFoundMessage, Show-FinishedHtmlMessage, Write-HtmlLogEntry, Invoke-ShowErrorMessage -Variable *
