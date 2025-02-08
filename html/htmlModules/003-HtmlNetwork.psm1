$NetworkPropertyArray = [ordered]@{

    "3-001_Win32_Network_Adapter_Configuration" = ("Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = 'IpAddress'; E = { $_.IpAddress -join '; ' } }, @{ N = 'DefaultIPgateway'; E = { $_.DefaultIPgateway -join '; ' } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass", "Pipe")
    "3-002_Established_Network_Connections"     = ("Get-NetTCPConnection -State Established", "Pipe")
    "3-003_Netstat_Connections_Basic"           = ("netstat -nao | Out-String", "String")
    "3-004_Net_TCP_Connections_Txt"             = ("Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending", "Pipe")
    "3-005_Network_Adapter"                     = ("Get-NetAdapter | Select-Object -Property *", "Pipe")
    "3-006_NetIP_Configuration"                 = ("Get-NetIPConfiguration | Select-Object -Property *", "Pipe")
    "3-007_route_PRINT"                         = ("route PRINT | Out-String", "String")
    "3-008_ipconfig_all"                        = ("ipconfig /all | Out-String", "String")
    "3-009_NetNeighbor"                         = ("Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress", "Pipe")
    "3-010_NetIP_Address"                       = ("Get-NetIPAddress | Sort-Object -Property IPAddress", "Pipe")
    "3-011_HostsFile"                           = ("Get-Content `"$Env:windir\system32\drivers\etc\hosts`" -Raw", "String")
    "3-012_NetworksFile"                        = ("Get-Content `"$Env:windir\system32\drivers\etc\networks`" -Raw", "String")
    "3-013_ProtocolFile"                        = ("Get-Content `"$Env:windir\system32\drivers\etc\protocol`" -Raw", "String")
    "3-014_ServicesFile"                        = ("Get-Content `"$Env:windir\system32\drivers\etc\services`" -Raw", "String")
    "3-015_SmbShare"                            = ("Get-SmbShare", "Pipe")
    "3-016_NetIP_Interface"                     = ("Get-NetIPInterface | Select-Object -Property *", "Pipe")
    "3-017_NetRoute_All"                        = ("Get-NetRoute | Select-Object -Property *", "Pipe")
    "3-018_Dns_Cache_Txt"                       = ("ipconfig /displaydns | Out-String", "String")
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
            $Command = $item.value[0]
            $Type = $item.value[1]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage $Name
                }
                else
                {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    #! 3-019 (Html Output)
    function Get-NetstatDetailed {

        param
        (
            [string]$FilePath
        )

        $Name = "3-019_NetstatConnectionsDetailed"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $TempFile = "$FilesFolder\$Name-TEMP.html"
        $FileName = "$Name.html"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

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

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-020 (Csv Output)
    function Get-NetTcpConnectionsAsCsv {

        $Name = "3-020_NetTcpConnectionsAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            Get-NetTCPConnection | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-021 (Keep seperate)
    function Get-WifiPasswords {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "3-021_WifiPasswords"
        $FileName = "$Name.html"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } }
            if ($Data.Count -eq 0)
            {
                Invoke-NoDataFoundMessage $Name
            }
            else
            {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath

                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 3-022 (Csv Output)
    function Get-DnsCacheDataAsCsv {

        $Name = "3-022_DnsCacheAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            Get-DnsClientCache | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
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
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-NetworkHtmlPage
