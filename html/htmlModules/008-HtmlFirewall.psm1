function Export-FirewallHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 8-001
    function Get-FirewallRules {
        param ([string]$FilePath)
        $Name = "8-001 Firewall Rules"
        Show-Message("Running ``$Name`` command") -Header -DarkGray

        try {
            $Data = Get-NetFirewallRule -all
            if ($Data.Count -eq 0) {
                Show-Message("No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 8-002
    function Get-AdvFirewallRules {
        param ([string]$FilePath)
        $Name = "8-002 Advanced Firewall Rules"
        Show-Message("Running ``$Name`` command") -Header -DarkGray

        try {
            $Data = netsh advfirewall firewall show rule name=all verbose | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 8-003
    function Get-DefenderExclusions {
        param ([string]$FilePath)
        $Name = "8-003 Defender Exclusions"
        Show-Message("Running ``$Name`` command") -Header -DarkGray

        try {
            $Data = Get-MpPreference
            if ($Data.Count -eq 0) {
                Show-Message("No data found for ``$Name``") -Yellow
                Write-HtmlLogEntry("No data found for ``$Name``")
            }
            else {
                Show-Message("[INFO] Saving output from ``$Name``") -Blue

                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallRules $FilePath
    Get-AdvFirewallRules $FilePath
    Get-DefenderExclusions $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-FirewallHtmlPage
