$FirewallPropertyArray = [ordered]@{

    "8-001_FirewallRules"         = ("Get-NetFirewallRule -all", "Pipe")
    "8-002_AdvancedFirewallRules" = ("netsh advfirewall firewall show rule name=all verbose | Out-String", "String")
    "8-003_DefenderExclusions"    = ("Get-MpPreference", "Pipe")
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


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-FirewallHtmlPage
