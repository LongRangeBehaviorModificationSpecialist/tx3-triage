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
        [string]$FirewallHtmlOutputFolder,
        [string]$HtmlReportFile
    )

    # 8-000
    function Get-FirewallData {

        foreach ($item in $FirewallPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$FirewallHtmlOutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }

                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }

                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    function Write-FirewallSectionToMain {

        $SectionName = "Firewall Information Section"

        $SectionHeader = "
        <h4 class='section_header' id='firewall'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $FirewallHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\008\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallData


    Write-FirewallSectionToMain
}


Export-ModuleMember -Function Export-FirewallHtmlPage
