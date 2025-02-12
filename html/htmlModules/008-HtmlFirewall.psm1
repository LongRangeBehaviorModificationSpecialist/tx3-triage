$FirewallPropertyArray = [ordered]@{

    "8-001_FirewallRules"         = ("Net Firewall Rules",
                                    "Get-NetFirewallRule -all | Out-String",
                                    "String")
    "8-002_AdvancedFirewallRules" = ("Advanced Firewall Rules",
                                    "netsh advfirewall firewall show rule name=all verbose | Out-String",
                                    "String")
    "8-003_DefenderExclusions"    = ("Defender Exclusions",
                                    "Get-MpPreference | Out-String",
                                    "String")
}


function Export-FirewallHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    # 8-000
    function Get-FirewallData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $FirewallPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"

                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallData -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-FirewallHtmlPage
