function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    # Import the hashtables from the data files
    $RegistryDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005A-RegistryDataArray.psd1"
    $SystemDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005B-SystemDataArray.psd1"

    $SystemHtmlMainFile = New-Item -Path "$OutputFolder\005_main.html" -ItemType File -Force

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
                        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force
                        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                    }
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
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
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    function Write-SystemSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\005\005_main.html' target='_blank'>System Info</a></h3>" -Encoding UTF8

        $SectionName = "System Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $SystemHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $SystemHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "005") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $SystemHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $SystemHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-SelectRegistryValues
    Get-SystemData


    Write-SystemSectionToMain
}


Export-ModuleMember -Function Export-SystemHtmlPage
