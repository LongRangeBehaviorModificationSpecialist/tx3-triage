function Export-UserHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )


    # Import the hashtables from the data files
    $UserPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\002A-UserDataArray.psd1"

    $UserHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    # 2-000
    function Get-UserData {

        foreach ($item in $UserPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
                    }
                    Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    function Write-UserSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\002\main.html' target='_blank'>User Info</a></h3>" -Encoding UTF8

        $SectionName = "User Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $UserHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $UserHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
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
