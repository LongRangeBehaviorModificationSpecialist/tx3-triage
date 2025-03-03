function Export-NetworkHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    # Import the hashtables from the data files
    $NetworkPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\003A-NetworkDataArray.psd1"

    $NetworkHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    # 3-000
    function Get-NetworkData {

        foreach ($item in $NetworkPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromPipe

                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                    }

                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }

    #! 3-021 (Keep function seperate)
    function Get-Win32NetwortAdapterConfig {

        $Name = "3-021_Win32NetwortAdapterConfig"
        $Title = "Win32 Network Adapter Configuration"
        $FileName = "$Name.html"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = 'IpAddress'; E = { $_.IpAddress -join '; ' } }, @{ N = 'DefaultIPgateway'; E = { $_.DefaultIPgateway -join '; ' } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Out-String

            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
                Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-022 (Html Output)
    function Get-NetstatDetailed {

        $Name = "3-022_NetstatConnectionsDetailed"
        $FileName = "$Name.html"
        $TempFile = "$OutputFolder\$Name-TEMP.html"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

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
            } | Set-Content -Path "$OutputFolder\$FileName" -Force

            # Delete the temp .html file
            Remove-Item -Path $TempFile -Force

            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-023 (Csv Output)
    function Get-NetTcpConnectionsAsCsv {

        $Name = "3-023_NetTcpConnectionsAsCsv"
        $FileName = "$Name.csv"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
            Get-NetTCPConnection | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-024 (Keep function seperate)
    function Get-WifiPasswords {

        $Name = "3-024_WifiPasswords"
        $Title = "Wifi Passwords"
        $FileName = "$Name.html"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } } | Out-String

            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
                Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 3-025 (Csv Output)
    function Get-DnsCacheDataAsCsv {

        $Name = "3-025_DnsCacheAsCsv"
        $FileName = "$Name.csv"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
            Get-DnsClientCache | Select-Object -Property * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    function Write-NetworkSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\003\main.html' target='_blank'>Network Info</a></h3>" -Encoding UTF8

        $SectionName = "Network Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $NetworkHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $NetworkHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            if ([System.IO.Path]::GetExtension($File) -eq ".csv") {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $NetworkHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $NetworkHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $NetworkHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-NetworkData
    Get-Win32NetwortAdapterConfig
    Get-NetstatDetailed
    Get-NetTcpConnectionsAsCsv
    Get-WifiPasswords
    Get-DnsCacheDataAsCsv


    Write-NetworkSectionToMain
}


Export-ModuleMember -Function Export-NetworkHtmlPage
