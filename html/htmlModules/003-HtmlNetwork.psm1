function Export-NetworkHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    # 3-001
    function Get-NetworkConfig {
        param ([string]$FilePath)
        $Name = "3-001 Win32_NetworkAdapterConfiguration"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = "IpAddress"; E = { $_.IpAddress -join "; " } }, @{ N = "DefaultIPgateway"; E = { $_.DefaultIPgateway -join "; " } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Format-List
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-002
    function Get-OpenNetworkConnections {
        param ([string]$FilePath)
        $Name = "3-002 Established Network Connections"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetTCPConnection -State Established
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-003
    function Get-NetstatBasic {
        param ([string]$FilePath)
        $Name = "3-003 Netstat Connections (Basic)"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = netstat -nao | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-004
    function Get-NetstatDetailed {
        param ([string]$FilePath)
        $Name = "3-004 Netstat Connections (Detailed)"
        Show-Message("Running '$Name' command") -Header -Gray
        $TempFile = "$FilesFolder\3-004 DetailedNetworkConnections_TEMP.html"
        $FileName = "3-004 DetailedNetworkConnections.html"
        try {
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
            } | Set-Content -Path "$FilesFolder\$FileName" -Force
            # Delete the temp .html file
            Remove-Item -Path $TempFile -Force

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-005
    function Get-NetTcpConnectionsAsTxt {
        param ([string]$FilePath)
        $Name = "3-005 Net TCP Connections (as Txt)"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Format-List
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-006
    function Get-NetTcpConnectionsAsCsv {
        $Name = "3-006 Net TCP Connection (as Csv)"
        Show-Message("Running '$Name' command") -Header -Gray
        $FileName = "3-006_NetTcpConnections.csv"
        try {
            Get-NetTCPConnection | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-007
    function Get-NetworkAdapters {
        param ([string]$FilePath)
        $Name = " 3-007 Get-NetAdapter"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetAdapter | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-008
    function Get-NetIPConfig {
        param ([string]$FilePath)
        $Name = "3-008 Get-NetIPConfiguration"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetIPConfiguration | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-009
    function Get-RouteData {
        param ([string]$FilePath)
        $Name = "3-009 route PRINT"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = route PRINT | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-010
    function Get-IPConfig {
        param ([string]$FilePath)
        $Name = "3-010 ipconfig /all"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = ipconfig /all | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-011
    function Get-ARPData {
        param ([string]$FilePath)
        $Name = "3-011 Get-NetNeighbor"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-012
    function Get-NetIPAddrs {
        param ([string]$FilePath)
        $Name = "3-012 Get-NetIPAddress"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetIPAddress | Sort-Object -Property IPAddress
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-013
    function Get-HostsFile {
        param ([string]$FilePath)
        $Name = "3-013 Get-HostsFile"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-Content "$Env:windir\system32\drivers\etc\hosts" -Raw
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-014
    function Get-NetworksFile {
        param ([string]$FilePath)
        $Name = "3-014 Get-NetworksFile"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-Content "$Env:windir\system32\drivers\etc\networks" -Raw
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-015
    function Get-ProtocolFile {
        param ([string]$FilePath)
        $Name = "3-015 Get-ProtocolFile"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-Content "$Env:windir\system32\drivers\etc\protocol" -Raw
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 3-016
    function Get-ServicesFile {
        param ([string]$FilePath)
        $Name = "3-016 Get-servicesFile"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-Content "$Env:windir\system32\drivers\etc\services" -Raw
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-017
    function Get-SmbShares {
        param ([string]$FilePath)
        $Name = "3-017 Get-SmbShare"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-SmbShare
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-018
    function Get-WifiPasswords {
        param ([string]$FilePath)
        $Name = "3-018 Get-WifiPasswords"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } }
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-019
    function Get-NetInterfaces {
        param ([string]$FilePath)
        $Name = "3-019 Get-NetIPInterface"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetIPInterface | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-020
    function Get-NetRouteData {
        param ([string]$FilePath)
        $Name = "3-020 Get-NetRoute"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-NetRoute | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-021
    function Get-DnsCacheDataAsTxt {
        param ([string]$FilePath)
        $Name = "3-021 DNS Cache (as Txt)"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = ipconfig /displaydns | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-022
    function Get-DnsCacheDataAsCsv {
        $Name = "3-022 Dns Cache (as Csv)"
        Show-Message("Running '$Name' command") -Header -Gray
        $FileName = "3-022_DnsClientCache.csv"
        try {
            Get-DnsClientCache | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-NetworkConfig $FilePath
    Get-OpenNetworkConnections $FilePath
    Get-NetstatBasic $FilePath
    Get-NetstatDetailed $FilePath
    Get-NetTcpConnectionsAsTxt $FilePath
    Get-NetTcpConnectionsAsCsv  # Do not pass $FilePath variable to function
    Get-NetworkAdapters $FilePath
    Get-NetIPConfig $FilePath
    Get-RouteData $FilePath
    Get-IPConfig $FilePath
    Get-ARPData $FilePath
    Get-NetIPAddrs $FilePath
    Get-HostsFile $FilePath
    Get-NetworksFile $FilePath
    Get-ProtocolFile $FilePath
    Get-ServicesFile $FilePath
    Get-SmbShares $FilePath
    Get-WifiPasswords $FilePath
    Get-NetInterfaces $FilePath
    Get-NetRouteData $FilePath
    Get-DnsCacheDataAsTxt $FilePath
    Get-DnsCacheDataAsCsv  # Do not pass $FilePath variable to function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-NetworkHtmlPage
