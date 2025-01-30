$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


Import-Module -Name .\html\vars.psm1 -Global -Force
Import-Module -Name .\html\HtmlReportVars.psm1 -Global -Force


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


    $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

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


    Show-Message("Compiling the Triage Report in .html format. Please wait. . . ") -Header -Green

    # $ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"

    $PreContentBegin = '</h5>
    <button type="button" class="collapsible">'

    $PreContentEnd = '</button>
    <div class="content">
    <p>'

    $PostContent = "</p></div>"

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

        Add-Content -Path $DeviceHtmlOutputFile -Value $HtmlHeader

        # 1-001
        Show-Message("Running ``Get-ComputerDetails`` command") -Header -Gray
        Get-ComputerDetails | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> Computer Information $PreContentBegin Get-ComputerDetails $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``Get-ComputerDetails`` done...") -Blue


        # 1-002
        Show-Message("Running ``Get-TPMDetails`` command") -Header -Gray
        Get-TPMDetails | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> TPM Details $PreContentBegin TPM Data $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``Get-TPMDetails`` done...") -Blue


        #! 1-003
        Show-Message("Running ``PsInfo.exe`` command") -Header -Gray
        .\bin\PsInfo.exe -accepteula -s -h -d | Out-File -FilePath "$FilesFolder\1-003_PSInfo.txt" -Encoding UTF8
        Add-Content -Path $DeviceHtmlOutputFile -Value "<h5 class='info_header'> PSInfo.exe $PreContentBegin PSInfo.exe $PrecontentEnd <a href='../files/PsInfo.txt'>PsInfo.txt</a> $PostContent"
        Show-Message("``PsInfo.exe`` done...") -Blue


        # 1-004
        Show-Message("Running ``Get-PSDrive`` command") -Header -Gray
        Get-PSDrive -PSProvider FileSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> PSDrive Information $PreContentBegin Get-PSDrive $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``Get-PSDrive`` done...") -Blue


        # 1-005
        Show-Message("Running ``Win32_LogicalDisk`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> Win32_LogicalDisk Information $PreContentBegin Win32_LogicalDisk $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``Win32_LogicalDisk`` done...") -Blue


        # 1-006
        Show-Message("Running ``Get-ComputerInfo`` command") -Header -Gray
        Get-ComputerInfo | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> Computer Info $PreContentBegin Get-ComputerInfo $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``Get-ComputerInfo`` done...") -Blue


        # 1-007
        Show-Message("Running ``systeminfo`` command") -Header -Gray
        systeminfo /FO CSV | ConvertFrom-Csv | Select-Object * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> System Info $PreContentBegin SystemInfo $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``systeminfo`` done...") -Blue


        # 1-008
        $1008Name = "1-008 Win32_ComputerSystem"
        Show-Message("Running ``$1008Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1008Name $PreContentBegin Win32_ComputerSystem $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1008Name`` done...") -Blue


        # 1-009
        $1009Name = "1-009 Win32_OperatingSystem"
        Show-Message("Running ``$1009Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1009Name $PreContentBegin Win32_OperatingSystem $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1009Name`` done...") -Blue


        # 1-010
        $1010Name = "1-010 Win32_PhysicalMemory"
        Show-Message("Running ``$1010Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1010Name $PreContentBegin Win32_PhysicalMemory $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1010Name`` done...") -Blue

        # 1-011
        $1011Name = "1-011 Get-EnvVars"
        Show-Message("Running ``$1011Name`` command") -Header -Gray
        Get-ChildItem -Path env: | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1011Name $PreContentBegin EnvVars $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1011Name`` done...") -Blue

        # 1-012
        $1012Name = "1-012 Get-Disk"
        Show-Message("Running ``$1012Name`` command") -Header -Gray
        Get-Disk | Select-Object -Property * | Sort-Object DiskNumber | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1012Name $PreContentBegin Get-Disk $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1012Name`` done...") -Blue

        # 1-013
        $1013Name = "1-013 Get-Partition"
        Show-Message("Running ``$1013Name`` command") -Header -Gray
        Get-Partition | Select-Object -Property * | Sort-Object -Property DiskNumber, PartitionNumber | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1013Name $PreContentBegin Get-Partition $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1013Name`` done...") -Blue

        # 1-014
        $1014Name = "1-014 Win32_DiskPartition"
        Show-Message("Running ``$1014Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property Name | Format-List | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1014Name $PreContentBegin Win32_DiskPartition $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1014Name`` done...") -Blue

        # 1-015
        $1015Name = "1-015 Win32_StartupCommand"
        Show-Message("Running ``$1015Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1015Name $PreContentBegin Win32_StartupCommand $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1015Name`` done...") -Blue

        # 1-016
        # SKIPPING

        # 1-017
        $1017Name = "1-017 SoftwareLicensingService"
        Show-Message("Running ``$1017Name`` command") -Header -Gray
        Get-WmiObject -ClassName SoftwareLicensingService | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1017Name $PreContentBegin SoftwareLicensingService $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1017Name`` done...") -Blue

        #! 1-018
        $1018Name = "1-018 AutoRuns.exe"
        $1018FileName = "1-018_AutoRuns.csv"
        Show-Message("Running ``$1018Name`` command") -Header -Gray
        .\bin\autorunsc64.exe -a * -c -nobanner  | Out-File -FilePath "$FilesFolder\$1018FileName" -Encoding UTF8
        Add-Content -Path $DeviceHtmlOutputFile -Value "<h5 class='info_header'> $1018Name $PreContentBegin AutoRuns.exe $PrecontentEnd <a href='../files/$1018FileName'>$1018FileName</a> $PostContent"
        Show-Message("``$1018Name`` done...") -Blue


        # 1-019
        $1019Name = "1-019 Win32_Bios"
        Show-Message("Running ``$1019Name`` command") -Header -Gray
        Get-WmiObject -ClassName Win32_Bios | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1019Name $PreContentBegin Win32_Bios $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1019Name`` done...") -Blue

        # 1-020
        $1020Name = "1-020 Get-PnpDevice"
        Show-Message("Running ``$1020Name`` command") -Header -Gray
        Get-PnpDevice | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1020Name $PreContentBegin Get-PnpDevice $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1020Name`` done...") -Blue

        # 1-021
        $1021Name = "1-021 Win32_PnPEntity"
        Show-Message("Running ``$1021Name`` command") -Header -Gray
        $One_021Data = Get-CimInstance Win32_PnPEntity

        foreach ($Item in $One_021Data) {
            $Item | Add-Member -MemberType NoteProperty -Name "Host" -Value $Env:COMPUTERNAME
            $Item | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
        }
        $One_021Data | Select-Object Host, DateScanned, PnPClass, Caption, Description, DeviceID | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1021Name $PreContentBegin Win32_PnPEntity $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1021Name`` done...") -Blue

        # 1-022
        $1022Name = "1-022 Win32_Product"
        Show-Message("Running ``$1022Name`` command") -Header -Gray
        Get-WmiObject Win32_Product | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1022Name $PreContentBegin Win32_Product $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1022Name`` done...") -Blue

        # 1-023
        $1023Name = "1-023 Get-OpenWindowTitles"
        Show-Message("Running ``$1023Name`` command") -Header -Gray
        Get-Process | Where-Object { $_.mainWindowTitle } | Select-Object -Property ProcessName, MainWindowTitle | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $1023Name $PreContentBegin Get-OpenWindowTitles $PreContentEnd" -PostContent $PostContent | Out-File -Append $DeviceHtmlOutputFile -Encoding UTF8
        Show-Message("``$1023Name`` done...") -Blue


        Add-Content -Path $DeviceHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-DeviceHtmlPage` function


    # (2)
    function Export-UserHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $UserHtmlOutputFile -Value $HtmlHeader

        #! 2-001
        $2001Name = "2-001 WhoAmI"
        Show-Message("Running ``$2001Name`` command") -Header -Gray
        $2001Data = whoami /ALL /FO LIST | Out-String
        Add-Content -Path $UserHtmlOutputFile -Value "<h5 class='info_header'> $2001Name $PreContentBegin WhoAmI $PrecontentEnd <div class='text'> $2001Data </div> $PostContent" -NoNewline
        Show-Message("``$2001Name`` done...") -Blue

        # 2-002
        $2002Name = "2-002 Win32_UserProfile"
        Show-Message("Running ``$2002Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $2002Name $PreContentBegin Win32_UserProfile $PreContentEnd" -PostContent $PostContent | Out-File -Append $UserHtmlOutputFile -Encoding UTF8
        Show-Message("``$2002Name`` done...") -Blue

        # 2-003
        $2003Name = "2-003 Win32_UserAccount"
        Show-Message("Running ``$2003Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $2003Name $PreContentBegin Win32_UserAccount $PreContentEnd" -PostContent $PostContent | Out-File -Append $UserHtmlOutputFile -Encoding UTF8
        Show-Message("``$2003Name`` done...") -Blue

        # 2-004
        $2004Name = "2-004 Get-LocalUser"
        Show-Message("Running ``$2004Name`` command") -Header -Gray
        Get-LocalUser | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $2004Name $PreContentBegin Get-LocalUser $PreContentEnd" -PostContent $PostContent | Out-File -Append $UserHtmlOutputFile -Encoding UTF8
        Show-Message("``$2004Name`` done...") -Blue

        # 2-005
        $2005Name = "2-005 Win32_LogonSession"
        Show-Message("Running ``$2005Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $2005Name $PreContentBegin Win32_LogonSession $PreContentEnd" -PostContent $PostContent | Out-File -Append $UserHtmlOutputFile -Encoding UTF8
        Show-Message("``$2005Name`` done...") -Blue

        # 2-006
        # TODO -- SKIPPED for now.  Will come back and figure out how to code this function

        # 2-007
        $2007Name = "2-007 WinEvent Security (4624 or 4648)"
        Show-Message("Running ``$2007Name`` command") -Header -Gray
        $Two_007Cmd = Get-WinEvent -LogName 'Security' -FilterXPath "*[System[EventID=4624 or EventID=4648]]"

        $Two_007Data = @()
        foreach ($LogonEvent in $Two_007Cmd) {
            $Two_007Data += [PSCustomObject]@{
                Time      = $LogonEvent.TimeCreated
                LogonType = if ($LogonEvent.Id -eq 4648) { "Explicit" } else { "Interactive" }
                Message   = $LogonEvent.Message
            }
        }
        $Two_007Data | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $2007Name $PreContentBegin WinEvent Security (4624 or 4648) $PreContentEnd" -PostContent $PostContent | Out-File -Append $UserHtmlOutputFile -Encoding UTF8
        Show-Message("``$2007Name`` done...") -Blue


        Add-Content -Path $UserHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-UserHtmlPage` function


    # (3)
    function Export-NetworkHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $NetworkHtmlOutputFile -Value $HtmlHeader

        # 3-001
        $3001Name = "3-001 Win32_NetworkAdapterConfiguration"
        Show-Message("Running ``$3001Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = "IpAddress"; E = { $_.IpAddress -join "; " } }, @{ N = "DefaultIPgateway"; E = { $_.DefaultIPgateway -join "; " } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Format-List | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3001Name $PreContentBegin Win32_NetworkAdapterConfiguration $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3001Name`` done...") -Blue

        # 3-002
        # TODO -- Check status of the `Get-NetTCPConnection` function // Not working on forensic machine

        # 3-003
        # TODO -- SKIPPED temp

        #! 3-004
        $3004Name = "3-004 netstat -nao"
        Show-Message("Running ``$3004Name`` command") -Header -Gray
        $3004Data = netstat -nao | Out-String
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3004Name $PreContentBegin netstat -nao $PrecontentEnd <div class='text'> $3004Data </div> $PostContent" -NoNewline
        Show-Message("``$3004Name`` done...") -Blue

        # 3-005
        # $3005Name = "3-005 Get-NetTCPConnection"
        # Show-Message("Running ``$3005Name`` command") -Header -Gray
        # Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3005Name $PreContentBegin Get-NetTCPConnection $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        # Show-Message("``$3005Name`` done...") -Blue

        # #! 3-006
        # $3006Name = "3-006 Get-NetTCPConnection (as CSV)"
        # Show-Message("Running ``$3006Name`` command") -Header -Gray
        # $3006FileName = "3-006_NetTcpConnections.csv"
        # Get-NetTcpConnection | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$3006FileName" -Encoding UTF8
        # Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3006Name $PreContentBegin Get-NetTCPConnection (as CSV) $PrecontentEnd <a href='../files/$3006FileName'>$3006FileName</a> $PostContent" -NoNewline
        # Show-Message("``$3006Name`` done...") -Blue

        # 3-007
        $3007Name = " 3-007 Get-NetAdapter"
        Show-Message("Running ``$3007Name`` command") -Header -Gray
        Get-NetAdapter | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3007Name $PreContentBegin Get-NetAdapter $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3007Name`` done...") -Blue

        # 3-008
        $3008Name = "3-008 Get-NetIPConfiguration"
        Show-Message("Running ``$3008Name`` command") -Header -Gray
        Get-NetIPConfiguration | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3008Name $PreContentBegin Get-NetIPConfiguration $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3008Name`` done...") -Blue

        #! 3-009
        $3009Name = "3-009 route PRINT"
        Show-Message("Running ``$3009Name`` command") -Header -Gray
        $3009Data = route PRINT | Out-String
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3009Name $PreContentBegin route PRINT $PrecontentEnd <div class='text'> $3009Data </div> $PostContent" -NoNewline
        Show-Message("``$3009Name`` done...") -Blue

        #! 3-010
        $3010Name = "3-010 ipconfig /all"
        Show-Message("Running ``$3010Name`` command") -Header -Gray
        $3010Data = ipconfig /all | Out-String
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3010Name $PreContentBegin ipconfig /all $PrecontentEnd <div class='text'> $3010Data </div> $PostContent" -NoNewline
        Show-Message("``$3010Name`` done...") -Blue

        # 3-011
        $3011Name = "3-011 Get-NetNeighbor"
        Show-Message("Running ``$3011Name`` command") -Header -Gray
        Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3011Name $PreContentBegin Get-NetNeighbor $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3011Name`` done...") -Blue

        # 3-012
        $3012Name = "3-012 Get-NetIPAddress"
        Show-Message("Running ``$3012Name`` command") -Header -Gray
        Get-NetIPAddress | Sort-Object -Property IPAddress | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3012Name $PreContentBegin Get-NetIPAddress $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3012Name`` done...") -Blue

        #! 3-013
        $3013Name = "3-013 Get-hostsFile"
        Show-Message("Running ``$3013Name`` command") -Header -Gray
        $3013Data = Get-Content "$Env:windir\system32\drivers\etc\hosts" -Raw
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3013Name $PreContentBegin Get-hostsFile $PrecontentEnd <div class='text'> $3013Data </div> $PostContent" -NoNewline
        Show-Message("``$3013Name`` done...") -Blue

        #! 3-014
        $3014Name = "3-014 Get-networksFile"
        Show-Message("Running ``$3014Name`` command") -Header -Gray
        $3014Data = Get-Content "$Env:windir\system32\drivers\etc\networks" -Raw
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3014Name $PreContentBegin Get-networksFile $PrecontentEnd <div class='text'> $3014Data </div> $PostContent" -NoNewline
        Show-Message("``$3014Name`` done...") -Blue

        #! 3-015
        $3015Name = "3-015 Get-protocolFile"
        Show-Message("Running ``$3015Name`` command") -Header -Gray
        $3015Data = Get-Content "$Env:windir\system32\drivers\etc\protocol" -Raw
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3015Name $PreContentBegin Get-protocolFile $PrecontentEnd <div class='text'> $3015Data </div> $PostContent" -NoNewline
        Show-Message("``$3015Name`` done...") -Blue

        #! 3-016
        $3016Name = "3-016 Get-servicesFile"
        Show-Message("Running ``$3016Name`` command") -Header -Gray
        $3016Data = Get-Content "$Env:windir\system32\drivers\etc\services" -Raw
        Add-Content -Path $NetworkHtmlOutputFile -Value "<h5 class='info_header'> $3016Name $PreContentBegin Get-servicesFile $PrecontentEnd <div class='text'> $3016Data </div> $PostContent" -NoNewline
        Show-Message("``$3016Name`` done...") -Blue

        # 3-017
        $3017Name = "3-017 Get-SmbShare"
        Show-Message("Running ``$3017Name`` command") -Header -Gray
        Get-SmbShare | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3017Name $PreContentBegin Get-SmbShare $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3017Name`` done...") -Blue

        # 3-018
        $3018Name = "3-018 Get-WifiPasswords"
        Show-Message("Running ``$3018Name`` command") -Header -Gray
        $Three_018Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } } | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3018Name $PreContentBegin Get-WifiPasswords $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3018Name`` done...") -Blue

        # 3-019
        $3019Name = "3-019 Get-NetIPInterface"
        Show-Message("Running ``$3019Name`` command") -Header -Gray
        Get-NetIPInterface | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3019Name $PreContentBegin Get-NetIPInterface $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3019Name`` done...") -Blue

        # 3-020
        $3020Name = "3-020 Get-NetRoute"
        Show-Message("Running ``$3020Name`` command") -Header -Gray
        Get-NetRoute | Select-Object -Property * | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $3020Name $PreContentBegin Get-NetRoute $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
        Show-Message("``$3020Name`` done...") -Blue

        Add-Content -Path $NetworkHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-NetworkHtmlPage` function


    # (4)
    function Export-ProcessHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $ProcessHtmlOutputFile -Value $HtmlHeader

        # 4-001
        $4001Name = "4-001 Running Processes (All)"
        Show-Message("Running ``$4001Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $4001Name $PreContentBegin Running Processes (All) $PreContentEnd" -PostContent $PostContent | Out-File -Append $ProcessHtmlOutputFile -Encoding UTF8
        Show-Message("``$4001Name`` done...") -Blue

        #! 4-002
        $4002Name = "4-002 Running Processes (as Csv)"
        Show-Message("Running ``$4002Name`` command") -Header -Gray
        $4002FileName = "4-002_RunningProcesses.csv"
        Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$4002FileName" -Encoding UTF8
        Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $4002Name $PreContentBegin Running Processes (as Csv) $PrecontentEnd <a href='../files/$4002FileName'>$4002FileName</a> $PostContent"
        Show-Message("``$4002Name`` done...") -Blue

        #! 4-003
        $4003Name = "4-003 Unique Process Hashes (as Csv)"
        Show-Message("Running ``$4003Name`` command") -Header -Gray
        $4003FileName = "4-003_UniqueProcessHash.csv"
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
        ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() |
                Export-Csv -NoTypeInformation -Path $4003FileName -Encoding UTF8
        Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $4003Name $PreContentBegin Unique Process Hashes (as Csv) $PrecontentEnd <a href='../files/$4003FileName'>$4003FileName</a> $PostContent"
        Show-Message("``$4003Name`` done...") -Blue

        # 4-004
        $4004Name = "4-004 SvcHostsAndProcesses"
        Show-Message("Running ``$4004Name`` command") -Header -Gray
        Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq "svchost.exe" | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $4004Name $PreContentBegin SvcHosts And Processes $PreContentEnd" -PostContent $PostContent | Out-File -Append $ProcessHtmlOutputFile -Encoding UTF8
        Show-Message("``$4004Name`` done...") -Blue

        #! 4-005
        $4005Name = "4-005 Running Services (as Csv)"
        Show-Message("Running ``$4005Name`` command") -Header -Gray
        $4005FileName = "4-005_RunningServices.csv"
        Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$4005FileName" -Encoding UTF8
        Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $4005Name $PreContentBegin Running Services (as Csv) $PrecontentEnd <a href='../files/$4005FileName'>$4005FileName</a> $PostContent"
        Show-Message("``$4005Name`` done...") -Blue

        #! 4-006
        $4006Name = "4-006 driverquery"
        Show-Message("Running ``$4006Name`` command") -Header -Gray
        $4006Data = driverquery | Out-String
        Add-Content -Path $ProcessHtmlOutputFile -Value "<h5 class='info_header'> $4006Name $PreContentBegin driverquery $PrecontentEnd <pre> $4006Data </pre> $PostContent" -NoNewline
        Show-Message("``$4006Name`` done...") -Blue


        Add-Content -Path $ProcessHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-ProcessHtmlPage` function


    # (6)
    function Export-PrefetchHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $PrefetchHtmlOutputFile -Value $HtmlHeader

        #6-001
        $6001Name = "6-001 Prefetch Files"
        Show-Message("Running ``$6001Name`` command") -Header -Gray
        Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $6001Name $PreContentBegin Prefetch Files $PreContentEnd" -PostContent $PostContent | Out-File -Append $PrefetchHtmlOutputFile -Encoding UTF8
        Show-Message("``$6001Name`` done...") -Blue

        Add-Content -Path $PrefetchHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-PrefetchHtmlPage` function


    #(8)
    function Export-FirewallHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $FirewallHtmlOutputFile -Value $HtmlHeader

        # 8-001
        $8001Name = "8-001 Firewall Rules"
        Show-Message("Running ``$8001Name`` command") -Header -Gray
        Get-NetFirewallRule | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $8001Name $PreContentBegin Firewall Rules $PreContentEnd" -PostContent $PostContent | Out-File -Append $FirewallHtmlOutputFile -Encoding UTF8
        Show-Message("``$8001Name`` done...") -Blue


        # 8-002
        $8002Name = "8-002 Advanced Firewall Rules"
        Show-Message("Running ``$8002Name`` command") -Header -Gray
        $8002Data = netsh advfirewall firewall show rule name=all verbose | Out-String
        Add-Content -Path $FirewallHtmlOutputFile -Value "<h5 class='info_header'> $8002Name $PreContentBegin Advanced Firewall Rules $PrecontentEnd <pre> $8002Data </pre> $PostContent" -NoNewline
        Show-Message("``$8002Name`` done...") -Blue


        # 8-003
        $8003Name = "8-003 Defender Exclusions"
        Show-Message("Running ``$8003Name`` command") -Header -Gray
        Get-MpPreference | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $8003Name $PreContentBegin Defender Exclusions $PreContentEnd" -PostContent $PostContent | Out-File -Append $FirewallHtmlOutputFile -Encoding UTF8
        Show-Message("``$8003Name`` done...") -Blue


        Add-Content -Path $FirewallHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-FirewallHtmlPage` function


    # (9)
    function Export-BitLockerHtmlPage {

        [CmdletBinding()]

        param (
            [string]$FilePath
        )

        Add-Content -Path $BitLockerHtmlOutputFile -Value $HtmlHeader

        #9-001
        $9001Name = "9-001 BitLocker Data"
        Show-Message("Running ``$9001Name`` command") -Header -Gray
        $9001Data1 = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint
        $9001Data1String = $9001Data1 | Out-String
        Add-Content -Path $BitLockerHtmlOutputFile -Value "<h5 class='info_header'> $9001Name $PreContentBegin BitLocker Data $PrecontentEnd <pre> $9001Data1String </pre>" -NoNewline
        # $PostContent

        function Search-BitlockerVolumes {
                # Get all BitLocker-protected drives on the computer
                $BitlockerVolumes = $9001Data1

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
                        # Save-OutputAppend $Message $File
                        # Show-Message("$Message") -NoTime -Magenta
                    }
                    elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                        $Message = "    [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted"
                        Add-Content -Path $BitLockerHtmlOutputFile -Value "<pre> $Message </pre>" -NoNewline
                        # Save-OutputAppend $Message $File
                        # Show-Message("$Message") -NoTime -Magenta
                    }
                    else {
                        $Message = "    [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker"
                        Add-Content -Path $BitLockerHtmlOutputFile -Value "<pre> $Message </pre>" -NoNewline
                        # Save-OutputAppend $Message $File
                        # Show-Message("$Message") -NoTime -Magenta
                    }
                }
            }
            Search-BitlockerVolumes

        Add-Content -Path $BitLockerHtmlOutputFile -Value "</p></div>"

        Show-Message("``$9001Name`` done...") -Blue

        Add-Content -Path $BitLockerHtmlOutputFile -Value $EndingHtml

    }  # End of `Export-BitLockerHtmlPage` function









    # Export-DeviceHtmlPage -FilePath $DeviceHtmlOutputFile      #1
    # Export-UserHtmlPage -FilePath $UserHtmlOutputFile          #2
    # Export-NetworkHtmlPage -FilePath $NetworkHtmlOutputFile    #3
    # Export-ProcessHtmlPage -FilePath $ProcessHtmlOutputFile    #4

    Export-PrefetchHtmlPage -FilePath $PrefetchHtmlOutputFile    #6

    Export-FirewallHtmlPage -FilePath $FirewallHtmlOutputFile    #8
    Export-BitLockerHtmlPage -FilePath $BitLockerHtmlOutputFile  #9


    Show-Message("tx3-triage script has completed successfully. . .") -Header -Green

}


Export-ModuleMember -Function Export-HtmlReport
