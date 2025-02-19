function Export-FirewallHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    # Import the hashtables from the data files
    $FirewallPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\008A-FirewallDataArray.psd1"

    $FirewallHtmlMainFile = New-Item -Path "$OutputFolder\008_main.html" -ItemType File -Force

    # 8-000
    function Get-FirewallData {

        foreach ($item in $FirewallPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

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

        Add-Content -Path $HtmlReportFile -Value "<h4><a href='results\008\008_main.html' target='_blank'>Firewall Data</a></h4>"

        $SectionName = "Firewall Information Section"

        $SectionHeader = "
        <h4 class='section_header'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $FirewallHtmlMainFile -Value $HtmlHeader
        Add-Content -Path $FirewallHtmlMainFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "008") {
                continue
            }
            else {
                $FileNameEntry = "<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $FirewallHtmlMainFile -Value $FileNameEntry
            }
        }

        Add-Content -Path $FirewallHtmlMainFile -Value "</div>`n</body>`n</html>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallData


    Write-FirewallSectionToMain
}


Export-ModuleMember -Function Export-FirewallHtmlPage
