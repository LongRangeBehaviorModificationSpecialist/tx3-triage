$NetworkPropertyArray = [ordered]@{

    "3-001_Win32_Network_Adapter_Configuration" = ("Win32 Network Adapter Configuration",
                                                  "Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = 'IpAddress'; E = { $_.IpAddress -join '; ' } }, @{ N = 'DefaultIPgateway'; E = { $_.DefaultIPgateway -join '; ' } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Out-String", "String")
    "3-002_Established_Network_Connections"     = ("Established NetTCPConnection", "Get-NetTCPConnection -State Established | Format-List | Out-String", "String")
    "3-003_Netstat_Connections_Basic"           = ("netstat (Basic)", "netstat -nao | Out-String", "String")
    "3-004_Net_TCP_Connections_Txt"             = ("Net TCP Connection (as Txt)", "Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Out-String", "String")
    "3-005_Network_Adapter"                     = ("Net Adapter", "Get-NetAdapter | Select-Object -Property * | Out-String", "String")
    "3-006_NetIP_Configuration"                 = ("Net IP Configuration", "Get-NetIPConfiguration | Select-Object -Property * | Out-String", "String")
    "3-007_route_PRINT"                         = ("route Info", "route PRINT | Out-String", "String")
    "3-008_ipconfig_all"                        = ("ipconfig /all", "ipconfig /all | Out-String", "String")
    "3-009_Dns_Cache_Txt"                       = ("ipconfig /displaydns", "ipconfig /displaydns | Out-String", "String")
    "3-010_NetNeighbor"                         = ("Net Neighbor", "Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | Out-String", "String")
    "3-011_NetIP_Address"                       = ("Net IP Address", "Get-NetIPAddress | Sort-Object -Property IPAddress | Out-String", "String")
    "3-012_HostsFile"                           = ("hosts File", "Get-Content `"$Env:windir\system32\drivers\etc\hosts`" -Raw", "String")
    "3-013_NetworksFile"                        = ("networks File", "Get-Content `"$Env:windir\system32\drivers\etc\networks`" -Raw", "String")
    "3-014_ProtocolFile"                        = ("protocol File", "Get-Content `"$Env:windir\system32\drivers\etc\protocol`" -Raw", "String")
    "3-015_ServicesFile"                        = ("services File", "Get-Content `"$Env:windir\system32\drivers\etc\services`" -Raw", "String")
    "3-016_SmbShare"                            = ("SmbShare", "Get-SmbShare | Out-String", "String")
    "3-017_NetIP_Interface"                     = ("Net IP Interface", "Get-NetIPInterface | Select-Object -Property * | Out-String", "String")
    "3-018_NetRoute_All"                        = ("Net Route", "Get-NetRoute | Select-Object -Property * | Out-String", "String")
    "3-019_IPInfo"                              = ("IP Address", "powershell -nop irm ipinfo.io | Out-String", "String")
    "3-020_IPInfo_Cont"                         = ("IP Address (2)", "nslookup myip.opendns.com resolver1.opendns.com", "String")
}


function Export-NetworkHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    # 3-000
    function Get-NetworkData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $NetworkPropertyArray.GetEnumerator())
        {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else
                {
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                    # Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }

    #! 3-021 (Html Output)
    function Get-NetstatDetailed {

        param
        (
            [string]$FilePath
        )

        $Name = "3-021_NetstatConnectionsDetailed"
        $Title = "Detailed Netstat Connections"
        $FileName = "$Name.html"
        $TempFile = "$FilesFolder\$Name-TEMP.html"
        Show-Message("[INFO] Running ``$Name`` command") -Header -DarkGray

        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

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
            foreach ($Element in $NetstatOutput)
            {
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

            # Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-022 (Csv Output)
    function Get-NetTcpConnectionsAsCsv {

        $Name = "3-022_NetTcpConnectionsAsCsv"
        $Title = "Net TCP Connections (as Csv)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running ``$Name`` command") -Header -DarkGray

        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Get-NetTCPConnection | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            # Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-023 (Keep function seperate)
    function Get-WifiPasswords {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "3-023_WifiPasswords"
        $Title = "Wifi Passwords"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running ``$Name`` command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } } | Out-String
            if ($Data.Count -eq 0)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>"

                Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-024 (Csv Output)
    function Get-DnsCacheDataAsCsv {

        $Name = "3-024_DnsCacheAsCsv"
        $Title = "DNS Cache (as Csv file)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running ``$Name`` command") -Header -DarkGray


        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Get-DnsClientCache | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            # Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------

    Get-NetworkData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-NetstatDetailed -FilePath $FilePath -PagesFolder $PagesFolder
    Get-NetTcpConnectionsAsCsv  # No need to pass variables to this function
    Get-WifiPasswords -FilePath $FilePath -PagesFolder $PagesFolder
    Get-DnsCacheDataAsCsv  # No need to pass variables to this function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-NetworkHtmlPage
