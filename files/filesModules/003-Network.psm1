$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-NetworkFilesPage {


    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 3-001
    function Get-NetworkConfig {

        param (
            [string]
            $Num = "3-001",
            [string]
            $FileName = "NetworkConfig.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = "IpAddress"; E = { $_.IpAddress -join "; " } }, @{ N = "DefaultIPgateway"; E = { $_.DefaultIPgateway -join "; " } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Format-List

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-002
    function Get-OpenNetworkConnections {

        param (
            [string]
            $Num = "3-002",
            [string]
            $FileName = "OpenConnections.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetTCPConnection -State Established

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-003
    function Get-NetstatDetailed {

        param (
            [string]
            $Num = "3-003",
            [string]
            $FileName = "NetstatDetailed.html"
        )

        begin {
            $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
            $TempFile = "$OutputFolder\$($Num)_NetstatDetailed-TEMP.html"
            $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
        }
        process {
            try {
                $ExecutionTime = Measure-Command {
                    Show-Message -Message "[INFO] $Header" -Header -DarkGray
                    Write-LogEntry -Message $Header

                    [datetime]$DateTime = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')

                    $Head = "
    <style>
        body {
            font-family: caibri;
            background-color: Aliceblue;
            margin-left: 10pt;
            margin-right: 10pt;
        }
        table {
            border-width: 1px;
            border-style: solid;
            border-color: black;
            border-collapse: collapse;
            table-layout: fixed;
            width: 100%;
        }
        th {
            font-size: 0.9em;
            border-width: 1px;
            border: 1px solid black;
            background-color: dodgerblue;
            padding: 10px;
            word-wrap: break-word;
        }
        td {
            border-width: 1px;
            border-style: solid;
            border-color: black;
            padding: 10px;
            word-wrap: break-word;
        }
    </style>
    <title>Detailed Network Connections</title>"

                    ConvertTo-Html -Head $Head -Body "<h3>
    Active Connections, Associated Processes and DLLs
    <p>Computer Name : $ComputerName</p>
    <p>User ID : $((Get-Item env:\USERNAME).value)</p>
    </h3>

    <h4> Current Date and Time : $DateTime</h4>" | Out-File -FilePath $TempFile -Encoding UTF8

                    $NetstatOutput = netstat -nao | Select-String "ESTA"
                    foreach ($Element in $NetstatOutput) {
                        $Results = $Element -Split "\s+" | Where-Object { $_ -ne "" }

                        # Extract the associated DLLs and file paths
                        $AssociatedDLLs = ((Get-Process | Where-Object { $_.ID -eq $Results[4] })).Modules |
                        Select-Object -ExpandProperty FileName

                        # Add <p> and </p> to each line of associated DLLs
                        $FormattedDLLs = $AssociatedDLLs | ForEach-Object { "<p>$($_)</p>" }

                        # Join the formatted DLLs into a single string, with each wrapped in <p> tags
                        $FormattedDLLsString = $FormattedDLLs -join "`n"

                        $NetList = @{
                            "Local IP : Port#"              = $Results[1];
                            "Remote IP : Port#"             = $Results[2];
                            "Process ID"                    = $Results[4];
                            "Process Name"                  = ((Get-Process | Where-Object { $_.ID -eq $Results[4] })).Name
                            "Process File Path"             = ((Get-Process | Where-Object { $_.ID -eq $Results[4] })).Path
                            "Process Start Time"            = ((Get-Process | Where-Object { $_.ID -eq $Results[4] })).StartTime
                            "Associated DLLs and File Path" = $FormattedDLLsString
                        }
                        New-Object -TypeName PSObject -Property $NetList | ConvertTo-html -As Table -Fragment -Property 'Local IP : Port#', 'Remote IP : Port#', 'Process ID', 'Process Name', 'Process Start Time', 'Process File Path', 'Associated DLLs and File Path' | ForEach-Object {
                            $_ -replace '<colgroup><col/><col/><col/><col/><col/><col/><col/></colgroup>', `
                                "<colgroup>
        <col style='width:10%;' />
        <col style='width:10%;' />
        <col style='width:5%;' />
        <col style='width:5%;' />
        <col style='width:20%;' />
        <col style='width:20%;' />
        <col style='width:30%;' />
    </colgroup>"
                        } | Out-File -Append -FilePath $TempFile -Encoding UTF8
                    }
                    (Get-Content $TempFile) | ForEach-Object {
                        $_ -replace "&lt;p&gt;", "" `
                            -replace "&lt;/p&gt;", "<br />"
                    } | Set-Content -Path $File -Force
                    # Delete the temp .html file
                    Remove-Item -Path $TempFile -Force

                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
                Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
                Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
        }
        end { }
    }

    # 3-004
    function Get-NetstatBasic {

        param (
            [string]
            $Num = "3-004",
            [string]
            $FileName = "NetstatBasic.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = netstat -nao

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-005
    function Get-NetTcpConnectionsAllTxt {

        param (
            [string]
            $Num = "3-005",
            [string]
            $FileName = "NetTcpConnections.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Format-List

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-006
    function Get-NetTcpConnectionsAllCsv {

        param (
            [string]
            $Num = "3-006",
            [string]
            $FileName = "NetTcpConnections.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetTcpConnection | ConvertTo-Csv -NoTypeInformation

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-007
    function Get-NetworkAdapters {

        param (
            [string]
            $Num = "3-007",
            [string]
            $FileName = "NetworkAdapterList.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetAdapter | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-008
    function Get-NetIPConfig {

        param (
            [string]
            $Num = "3-008",
            [string]
            $FileName = "NetIPConfiguration.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetIPConfiguration | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-009
    function Get-RouteData {

        param (
            [string]
            $Num = "3-009",
            [string]
            $FileName = "Routes.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = route PRINT

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-010
    function Get-IPConfig {

        param (
            [string]
            $Num = "3-010",
            [string]
            $FileName = "IPConfig.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = ipconfig /all

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-011
    function Get-ARPData {

        param (
            [string]
            $Num = "3-011",
            [string]
            $FileName = "ARPData.csv"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | ConvertTo-Csv -NoTypeInformation

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-012
    function Get-NetIPAddrs {

        param (
            [string]
            $Num = "3-012",
            [string]
            $FileName = "NetIpAddresses.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetIPAddress | Sort-Object -Property IPAddress

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-013
    function Get-HostsFile {

        param (
            [string]
            $Num = "3-013",
            [string]
            $FileName = "HostsFile.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-Content "$Env:windir\system32\drivers\etc\hosts"

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-014
    function Get-NetworksFile {

        param (
            [string]
            $Num = "3-014",
            [string]
            $FileName = "NetworksFile.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-Content "$Env:windir\system32\drivers\etc\networks"

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-015
    function Get-ProtocolFile {

        param (
            [string]
            $Num = "3-015",
            [string]
            $FileName = "ProtocolFile.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-Content "$Env:windir\system32\drivers\etc\protocol"

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-016
    function Get-ServicesFile {

        param (
            [string]
            $Num = "3-016",
            [string]
            $FileName = "ServiceFile.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-Content "$Env:windir\system32\drivers\etc\services"

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-017
    function Get-SmbShares {

        param (
            [string]
            $Num = "3-017",
            [string]
            $FileName = "SmbShares.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-SmbShare

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-018
    function Get-WifiPasswords {

        param (
            [string]
            $Num = "3-018",
            [string]
            $FileName = "WifiPasswords.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } }

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-019
    function Get-NetInterfaces {

        param (
            [string]
            $Num = "3-019",
            [string]
            $FileName = "NetIPInterfaces.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetIPInterface | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 3-020
    function Get-NetRouteData {

        param (
            [string]
            $Num = "3-020",
            [string]
            $FileName = "NetRoute.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetRoute | Select-Object -Property *

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-NetworkConfig
    Get-OpenNetworkConnections
    Get-NetstatDetailed
    Get-NetstatBasic
    Get-NetTcpConnectionsAllTxt
    Get-NetTcpConnectionsAllCsv
    Get-NetworkAdapters
    Get-NetIPConfig
    Get-RouteData
    Get-IPConfig
    Get-ARPData
    Get-NetIPAddrs
    Get-HostsFile
    Get-NetworksFile
    Get-ProtocolFile
    Get-ServicesFile
    Get-SmbShares
    Get-WifiPasswords
    Get-NetInterfaces
    Get-NetRouteData
}


Export-ModuleMember -Function Export-NetworkFilesPage
