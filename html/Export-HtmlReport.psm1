$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


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
        [string]$User,
        [Parameter(Position = 5)]
        [ValidateNotNullOrEmpty()]
        [string]$Agency,
        [Parameter(Position = 6)]
        [ValidateNotNullOrEmpty()]
        [string]$CaseNumber
    )


    $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

    $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
    $OutputHtmlFile = Join-Path -Path $CaseFolderName -ChildPath "$($CaseFolderTitle)_Report.html"


    # Assigning variables to use in the script
    $Header = "<!DOCTYPE html>
<html lang='en'>
    <head>
        <meta charset='utf-8' />
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />
        <meta name='viewport' content='width=device-width, initial-scale=1' />
        <title>$ComputerName.$User Triage Data</title>
        <style>
            * { font-family:Arial, Helvetica, sans-serif; }
            body { margin-left:15%; margin-right:15%; }
            h1 { color:#e68a00; font-size:28px; }
            h2 { color:#000099; font-size:1.35em; }
            .data { font-family:'Helvetica'; font-weight:bold; color:#f00; font-size:1.15em; }
            table { font-size:0.85em; border:0px; }
            td { padding:4px; margin:0px; border:0; }
            th { background:#395870; background:linear-gradient(#49708f, #293f50); color:#fff; font-size:1.05em; text-transform:uppercase; padding:10px 15px; vertical-align:middle; }
            tbody tr:nth-child(even) { background:#f0f0f2; }
            .RunningStatus { color:#008000; font-weight:bold; }
            .StopStatus { color:#ff0000; font-weight:bold; }
            #CreationDate { color:#ff3300; font-size:12px; }
            .dropbtn { color:#fff; background-color:#007bff; border-color:#007bff; padding:16px; font-size:16px; border:none; width:auto; }
            .dropdown { position:relative; display:inline-block; width:auto; }
            .dropdown-content { display:none; width:auto; height:30rem; overflow-y:scroll; position:absolute; background-color:#f1f1f1; box-shadow:0px 8px 16px 0px rgba(0,0,0,0.2); z-index:1; white-space:nowrap; }
            .dropdown-content a { color:#212529; padding:12px 16px; text-decoration:none; display:block; }
            .dropdown-content a:hover { color:#fff; background-color:#3492d1; }
            .dropdown-content a:active { color:#fff; background-color:#007bff; }
            .dropdown:hover .dropdown-content { display:block; width:auto; }
            .dropdown:hover .dropbtn { background-color:#03366d }
            .dropdown-item { color:#212529; white-space:nowrap; background-color:transparent; border:0px; }
            .top { display:inline; font-size:12px; color:dodgerblue }
            /* Style the button that is used to open and close the collapsible content */
            .collapsible {background-color:#eee; color:#444; cursor:pointer; padding:18px; width:100%; border:none; text-align:left; outline:none; font-size:1.05em; font-weight:bold; }

            /* Add a background color to the button if it is clicked on (add the .active class with JS), and when you move the mouse over it (hover) */
            .active, .collapsible:hover { background-color:#ccc; }

            /* Style the collapsible content. Note: hidden by default */
            .content { padding:0 18px; display:none; overflow:hidden; background-color:#f1f1f1; }
        </style>
        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>
    </head>
    <body translate='no'>"


    $QuickLinks = "
<div class='dropdown'>
    <button class='dropbtn'>Jump to Section</button>
    <div class='dropdown-content'>
        <a href='#ComputerInfo'>Computer Information</a>
        <a href='#TPMDetails'>TPM Details</a>
        <a href='#PSDrive'>PS Drive Information</a>
        <a href='#Win32_LogicalDisk'>Win32_LogicalDisk</a>
        <a href='#ComputerInfo'>Computer Info</a>
        <a href='#SystemInfo'>System Info</a>
        <a href='#Win32_ComputerSystem'>Win32_ComputerSystem</a>
        <a href='#Win32_OperatingSystem'>Win32_OperatingSystem</a>
        <a href='#Win32_PhysicalMemory'>Win32_PhysicalMemory</a>






        <a href='#'></a>



        <a href='#RegActiveSetupInstalls'>Active Setup Installs</a>
        <a href='#RegAppPathKeys'>APP Paths Keys</a>
        <a href='#RegAppCertDLLs'>AppCert DLLs</a>
        <a href='#RegAppInit'>AppInit_DLLs</a>
        <a href='#AppInventoryEvents'>Application Inventory Events</a>
        <a href='#RegApprovedShellExts'>Approved Shell Extentions</a>
        <a href='#AuditPolicy'>Audit Policy</a>
        <a href='#RegBCDRelated'>BCD Related</a>
        <a href='#RegBrowserHelperObjects'>Browser Helper Objects</a>
        <a href='#RegBrowserHelperObjectsx64'>Browser Helper Objects 64 Bit</a>
        <a href='#CompressedFiles'>Compressed Files</a>
        <a href='#CompInfo'>Computer Information</a>
        <a href='#RegAddressBarHistory'>Desktop Address Bar History</a>
        <a href='#DiskPart'>Disk Partition Information</a>
        <a href='#Last50dlls'>.dll files (last 50 created)</a>
        <a href='#RegLoadedDLLs'>DLLs Loaded by Explorer.exe Shell</a>
        <a href='#DNSCache'>DNS Cache</a>
        <a href='#DownloadedExeFiles'>Downloaded Executable Files</a>
        <a href='#EncryptedFiles'>Encrypted Files</a>
        <a href='#EnvVars'>Environment Variables</a>
        <a href='#EventLog4625'>Event Log - Account Failed To Log On (ID: 4625)</a>
        <a href='#EventLog4624'>Event Log - Account Logon (ID: 4624)</a>
        <a href='#EventLog1002'>Event Log - Application Crashes (ID: 1002)</a>
        <a href='#EventLog1102'>Event Log - Audit Log was Cleared (ID: 1102)</a>
        <a href='#EventLog1014'>Event Log - DNS Failed Resolution Events (ID: 1014)</a>
        <a href='#EventLog4648'>Event Log - Logon Was Attempted Using Explicit Credentials (ID: 4648)</a>
        <a href='#EventLog4673'>Event Log - Privilege Use (ID: 4673)</a>
        <a href='#EventLog4674'>Event Log - Privilege Use (ID: 4674)</a>
        <a href='#EventLog4688'>Event Log - Process Execution (ID: 4688)</a>
        <a href='#EventLog7036'>Event Log - Service Control Manager Events (ID: 7036)</a>
        <a href='#EventLog7045'>Event Log - Service Creation (ID: 7045)</a>
        <a href='#EventLog4672'>Event Log - Special Logon (ID: 4672)</a>
        <a href='#EventLog4616'>Event Log - System Time Was Changed (ID: 4616)</a>
        <a href='#EventLog4720'>Event Log - User Account Was Created (ID: 4720)</a>
        <a href='#EventLog64001'>Event Log - WFP Events (ID: 64001)</a>
        <a href='#RegEXEFileShell'>EXE File Shell Command</a>
        <a href='#FileTimelineExeFiles'>File Timeline Executable Files (Past 30 Days)</a>
        <a href='#HotFixes'>Hot Fixes</a>
        <a href='#RegIEExtensionsFromHKCU'>IE Extensions from HKCU</a>
        <a href='#RegIEExtensionsFromHKLM'>IE Extensions from HKLM</a>
        <a href='#RegIEExtensionsFromWow'>IE Extensions from Wow6432Node</a>
        <a href='#InstalledApps'>Installed Applications</a>
        <a href='#Cookies'>Internet Cookies</a>
        <a href='#RegInternetSettings'>Internet Settings</a>
        <a href='#RegTrustedDomains'>Internet Trusted Domains</a>
        <a href='#LinkFiles'>Link File Analysis - Last 5 days</a>
        <a href='#RegLSAPackages'>LSA Packages Loaded</a>
        <a href='#Logs'>Log Files</a>
        <a href='#LogonSessions'>Logon Sessions</a>
        <a href='#MappedDrives'>Mapped Drives</a>
        <a href='#Netstat'>Netstat Innformation</a>
        <a href='#NetTCP'>NetTCP Connections</a>
        <a href='#NetworkConfig'>Network Configuration Info</a>
        <a href='#OpenShares'>Open Shares</a>
        <a href='#PhyMem'>Physical Memory Information</a>
        <a href='#Prefetch'>Prefetch List</a>
        <a href='#RegProgramExecuted'>Programs Executed By Session Manager</a>
        <a href='#RegRunMRUKeys'>RunMRU Keys</a>
        <a href='#Drivers'>Running Drivers</a>
        <a href='#RunningProcesses'>Running Processes</a>
        <a href='#RunningServices'>Running Services</a>
        <a href='#RunningSVCHOSTs'>Running SVCHOSTs</a>
        <a href='#ScheduledJobs'>Scheduled Jobs</a>
        <a href='#ScheduledTaskEvents'>Scheduled Task Events</a>
        <a href='#RegSVCValues'>Security Center SVC Values</a>
        <a href='#ShadowCopy'>Shadow Copy List</a>
        <a href='#RegShellUserInit'>Shell and UserInit Values</a>
        <a href='#RegShellCommands'>Shell Commands</a>
        <a href='#RegShellFolders'>Shell Folders</a>
        <a href='#RegStartMenu'>Start Menu</a>
        <a href='#StartupApps'>Startup Applications</a>
        <a href='#SystemInfo-1'>System Information</a>
        <a href='#SystemInfo-2'>System Information (Additional)</a>
        <a href='#TempInternetFiles'>Temporary Internet Files</a>
        <a href='#TerminalServiceEvents'>Terminal Services Events</a>
        <a href='#TypedURLs'>Typed URLs</a>
        <a href='#RegUAC'>UAC Group Policy Settings</a>
        <a href='#USBDevices'>USB Devices</a>
        <a href='#UserAccount'>User Account</a>
        <a href='#AllUsers'>User Accounts (All)</a>
        <a href='#RegUserShellFolders'>User Shell Folders (Startup)</a>
    </div>
</div>"


    # Variable to ass the "Return to Top" link next to each header
    $ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"


    # Information for the .html report header
    $TopSection = "
<h1 id='top'> Live Forensic Triage Script </h1>
<p>Computer Name: <span class='data'>$ComputerName</span>&nbsp;&nbsp;</p>
<p>Script Began Date and Time: <span class='data'>$Date at $Time</span></p>
<p>Script Run By: <span class='data'>$User</span>&nbsp;&nbsp;|&nbsp;&nbsp;Agency: <span class='data'>$Agency</span>&nbsp;&nbsp;|&nbsp;&nbsp;Case Number: <span class='data'>$CaseNumber</span></p>"

    # | &nbsp; &nbsp; User ID: <span class='data'>$User</span>



    # Setting HTML report headers
    ConvertTo-Html -Head $Header -PreContent $TopSection | Out-File -Append $OutputHtmlFile -Encoding UTF8
    ConvertTo-Html -Fragment -PreContent $QuickLinks | Out-File -Append $OutputHtmlFile -Encoding UTF8


    write-Host "Compiling the Triage Report in .html format. Please wait . . . "


    $PreContentBegin = "$ReturnHtmlSnippet </h4>
    <button type='button' class='collapsible'>"

    $PreContentEnd = '</button>
    <div class="content">
    <p>'

    $PostContent = "</p></div>"

    # 1-001
    Get-ComputerDetails | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='ComputerInfo'> Computer Information $PreContentBegin Get-ComputerDetails $PreContentEnd" -PostContent $PostContent | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-002
    Get-TPMDetails | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='TPMDetails'> TPM Details $PreContentBegin TPM Data $PreContentEnd" -PostContent $PostContent | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-003
    .\bin\PsInfo.exe -accepteula -s -h -d | Out-File -FilePath "$CaseFolderName\PSInfo.txt" -Encoding UTF8

    # 1-004
    Get-PSDrive -PSProvider FileSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='PSDrive'> PSDrive Information $PreContentBegin Get-PSDrive $PreContentEnd" -PostContent $PostContent | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-005
    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='Win32_LogicalDisk'> Win32_LogicalDisk Information $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-006
    Get-ComputerInfo | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='ComputerInfo'> Computer Info $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-007
    systeminfo /FO CSV | ConvertFrom-Csv | Select-Object * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='SystemInfo'> System Info $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-008
    Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='Win32_ComputerSystem'> Win32_ComputerSystem $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-009
    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='Win32_OperatingSystem'> Win32_OperatingSystem $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-010
    Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h4 id='Win32_PhysicalMemory'> Win32_PhysicalMemory $ReturnHtmlSnippet </h4>" | Out-File -Append $OutputHtmlFile -Encoding UTF8

    # 1-011


    # 1-012


    # 1-013


    # 1-014


    # 1-015


    # 1-016


    # 1-017


    # 1-018


    # 1-019


    # 1-020













    $EndingHtml = '<script>
    var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.display === "block") {
      content.style.display = "none";
    } else {
      content.style.display = "block";
    }
  });
}
        </script>
    </body>
</html>
'
    Add-Content -Path $OutputHtmlFile -Value $EndingHtml


}


Export-ModuleMember -Function Export-HtmlReport
