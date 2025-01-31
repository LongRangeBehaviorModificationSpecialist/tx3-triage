function Export-NetworkHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader


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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 3-005
    # function Get-NetTcpConnectionsAllTxt {
    #     param ([string]$FilePath)
    #     $Name = "3-005 Get-NetTCPConnection"
    #     Show-Message("Running '$Name' command") -Header -Gray
    #     try {

    #     }
    #     catch {

    #     }
    #     Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | ConvertTo-Html -As List -Fragment -Precontent "<h5 class='info_header'> $Name $PreContentBegin Get-NetTCPConnection $PreContentEnd" -PostContent $PostContent | Out-File -Append $NetworkHtmlOutputFile -Encoding UTF8
    #     Show-FinishedHtmlMessage $Name
    # }

    #! 3-006
    # function Get-NetTcpConnectionsAllCsv {
    #     param ([string]$FilePath)
    #     $Name = "3-006 Get-NetTCPConnection (as CSV)"
    #     Show-Message("Running '$Name' command") -Header -Gray
    #     $FileName = "3-006_NetTcpConnections.csv"
    #     try {

    #     }
    #     catch {

    #     }
    #     Get-NetTcpConnection | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8
    #     Add-Content -Path $FilePath -Value "<h5 class='info_header'> $Name $PreContentBegin Get-NetTCPConnection (as CSV) $PrecontentEnd <a href='../files/$FileName'>$FileName</a> $PostContent" -NoNewline
    #     Show-FinishedHtmlMessage $Name
    # }

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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Add-Content -Path $FilePath -Value "<h5 class='info_header'> $Name $PreContentBegin Get-protocolFile $PrecontentEnd <pre> $Data $PostContent </pre>" -NoNewline
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-21
    function Get-DnsCacheDataTxt {
        param ([string]$FilePath)
        $Name = "5-012 DNS Cache"
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
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-Message("``$Name`` done...") -Blue
    }

    #! 3-22
    #! SKIPPED MAKING THE .CSV FILE


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-NetworkConfig $FilePath


    Get-NetstatBasic $FilePath


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
    Get-DnsCacheDataTxt $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-NetworkHtmlPage
