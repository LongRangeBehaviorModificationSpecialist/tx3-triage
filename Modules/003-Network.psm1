#! ======================================
#!
#! (3) GET NETWORK INFORMATION
#!
#! ======================================


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# 3-001
function Get-NetworkConfig {
    [CmdletBinding()]
    param (
        [string]$Num = "3-001",
        [string]$FileName = "NetworkConfig.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = "IpAddress"; E = { $_.IpAddress -join "; " } }, @{ N = "DefaultIPgateway"; E = { $_.DefaultIPgateway -join "; " } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Format-List

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-002
function Get-OpenNetworkConnections {
    [CmdletBinding()]
    param (
        [string]$Num = "3-002",
        [string]$FileName = "OpenConnections.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetTCPConnection -State Established

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-003
function Get-NetstatDetailed {
    [CmdletBinding()]
    param (
        [string]$Num = "3-003",
        [string]$FileName = "NetstatDetailed.html"
    )

    begin {
        $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
        $TempFile = "$NetworkFolder\$($Num)_NetstatDetailed-TEMP.html"
        $FunctionName = $MyInvocation.MyCommand.Name
        $Header = "$Num Running ``$FunctionName`` function"
    }
    process {
        try {
            # Run the command
            $ExecutionTime = Measure-Command {
                Show-Message("$Header") -Header
                Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

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
<p>User ID : $User</p>
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

                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
            Show-FinishMessage $FunctionName $ExecutionTime
            Write-LogFinishedMessage $FunctionName $ExecutionTime
        }
        catch {
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
    }
    end { }
}

# 3-004
function Get-NetstatBasic {
    [CmdletBinding()]
    param (
        [string]$Num = "3-004",
        [string]$FileName = "NetstatBasic.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = netstat -nao

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-005
function Get-NetTcpConnectionsAllTxt {
    [CmdletBinding()]
    param (
        [string]$Num = "3-005",
        [string]$FileName = "NetTcpConnections.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Format-List

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-006
function Get-NetTcpConnectionsAllCsv {
    [CmdletBinding()]
    param (
        [string]$Num = "3-006",
        [string]$FileName = "NetTcpConnections.csv"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command (to export as CSV)
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetTcpConnection | ConvertTo-Csv -NoTypeInformation

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-007
function Get-NetworkAdapters {
    [CmdletBinding()]
    param (
        [string]$Num = "3-007",
        [string]$FileNme = "NetworkAdapterList.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetAdapter | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-008
function Get-NetIPConfig {
    [CmdletBinding()]
    param (
        [string]$Num = "3-008",
        [string]$FileName = "NetIPConfiguration.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetIPConfiguration | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-009
function Get-RouteData {
    [CmdletBinding()]
    param (
        [string]$Num = "3-009",
        [string]$FileName = "Routes.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = route PRINT

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-010
function Get-IPConfig {
    [CmdletBinding()]
    param (
        [string]$Num = "3-010",
        [string]$FilePath = "IPConfig.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = ipconfig /all

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-011
function Get-ARPData {
    [CmdletBinding()]
    param (
        [string]$Num = "3-011",
        [string]$FileName = "ARPData.csv"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | ConvertTo-Csv -NoTypeInformation

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-012
function Get-NetIPAddrs {
    [CmdletBinding()]
    param (
        [string]$Num = "3-012",
        [string]$FileName = "NetIpAddresses.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetIPAddress | Sort-Object -Property IPAddress

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-013
function Get-HostsFile {
    [CmdletBinding()]
    param (
        [string]$Num = "3-013",
        [string]$FileName = "HostsFile.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Content "$Env:windir\system32\drivers\etc\hosts"

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-014
function Get-NetworksFile {
    [CmdletBinding()]
    param (
        [string]$Num = "3-014",
        [string]$FileName = "NetworksFile.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Content "$Env:windir\system32\drivers\etc\networks"

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-015
function Get-ProtocolFile {
    [CmdletBinding()]
    param (
        [string]$Num = "3-015",
        [string]$FileName = "ProtocolFile.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Content "$Env:windir\system32\drivers\etc\protocol"

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-016
function Get-ServicesFile {
    [CmdletBinding()]
    param (
        [string]$Num = "3-016",
        [string]$FileName = "ServiceFile.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-Content "$Env:windir\system32\drivers\etc\services"

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-017
function Get-SmbShares {
    [CmdletBinding()]
    param (
        [string]$Num = "3-017",
        [string]$FileName = "SmbShares.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-SmbShare

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-018
function Get-WifiPasswords {
    [CmdletBinding()]
    param (
        [string]$Num = "3-018",
        [string]$FileName = "WifiPasswords.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object { $Name = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { (netsh wlan show profile name="$Name" key=clear) } | Select-String "Key Content\W+\:(.+)$" | ForEach-Object { $Pass = $_.Matches.Groups[1].Value.Trim(); $_ } | ForEach-Object { [PSCustomObject]@{ PROFILE_NAME = $Name; PASSWORD = $Pass } }

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-019
function Get-NetInterfaces {
    [CmdletBinding()]
    param (
        [string]$Num = "3-019",
        [string]$FilePath = "NetIPInterfaces.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetIPInterface | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 3-020
function Get-NetRouteData {
    [CmdletBinding()]
    param (
        [string]$Num = "3-020",
        [string]$FileName = "NetRoute.txt"
    )

    $File = Join-Path -Path $NetworkFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetRoute | Select-Object -Property *

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-NetworkConfig, Get-OpenNetworkConnections, Get-NetstatDetailed, Get-NetstatBasic, Get-NetTcpConnectionsAllTxt, Get-NetTcpConnectionsAllCsv, Get-NetworkAdapters, Get-NetIPConfig, Get-RouteData, Get-IPConfig, Get-ARPData, Get-NetIPAddrs, Get-HostsFile, Get-NetworksFile, Get-ProtocolFile, Get-ServicesFile, Get-SmbShares, Get-WifiPasswords, Get-NetInterfaces, Get-NetRouteData
