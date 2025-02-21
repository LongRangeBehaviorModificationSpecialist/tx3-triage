function Export-UserHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    $UserPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\002A-UserDataArray.psd1"

    $UserHtmlMainFile = New-Item -Path "$OutputFolder\002_main.html" -ItemType File -Force

    # 2-000
    function Get-UserData {

        foreach ($item in $UserPropertyArray.GetEnumerator()) {
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


    function Write-UserSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\002\002_main.html' target='_blank'>User Info</a></h3>" -Encoding UTF8

        $SectionName = "User Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $UserHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $UserHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "002") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $UserHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $UserHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-UserData


    Write-UserSectionToMain
}


Export-ModuleMember -Function Export-UserHtmlPage
