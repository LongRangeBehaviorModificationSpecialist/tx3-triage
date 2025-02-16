
function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [string]$SystemHtmlOutputFolder,
        [string]$HtmlReportFile
    )

    # Import the hashtables from the data files
    $RegistryDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005-RegistryDataArray.psd1"
    $SystemDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005-SystemDataArray.psd1"

    # 5-000A
    function Get-SelectRegistryValues {

        foreach ($item in $RegistryDataArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $RegKey = $item.value[1]
            $Command = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

            try {
                Show-Message("[INFO] Searching for key [$RegKey]") -DarkGray

                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] Registry Key [$RegKey] does not exist")
                }
                else {
                    $Data = Invoke-Expression -Command $Command | Out-String

                    if (-not $Data) {
                        $msg = "The registry key [$RegKey] exists, but contains no data"
                        Show-Message("[INFO] $msg") -Yellow
                        Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $msg")
                    }
                    else {
                        $OutputHtmlFilePath = New-Item -Path "$SystemHtmlOutputFolder\$FileName" -ItemType File -Force
                        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                    }
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 5-000B
    function Get-SystemData {

        foreach ($item in $SystemDataArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$SystemHtmlOutputFolder\$FileName" -ItemType File -Force

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

    function Write-SystemSectionToMain {

        $SectionName = "System Information Section"

        $SectionHeader = "
        <h4 class='section_header' id='system'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $SystemHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\005\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-SelectRegistryValues
    Get-SystemData


    Write-SystemSectionToMain
}


Export-ModuleMember -Function Export-SystemHtmlPage
