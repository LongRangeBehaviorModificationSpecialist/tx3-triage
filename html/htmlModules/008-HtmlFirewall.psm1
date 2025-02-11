$FirewallPropertyArray = [ordered]@{

    "8-001_FirewallRules"         = ("Net Firewall Rules", "Get-NetFirewallRule -all", "Pipe")
    "8-002_AdvancedFirewallRules" = ("Advanced Firewall Rules", "netsh advfirewall firewall show rule name=all verbose | Out-String", "String")
    "8-003_DefenderExclusions"    = ("Defender Exclusions", "Get-MpPreference", "Pipe")
}


function Export-FirewallHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 8-000
    function Get-FirewallData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $FirewallPropertyArray.GetEnumerator())
        {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
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

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

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


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-FirewallHtmlPage
