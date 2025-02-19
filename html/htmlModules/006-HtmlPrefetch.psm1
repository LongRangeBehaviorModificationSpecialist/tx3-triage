function Export-PrefetchHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    $PrefetchHtmlMainFile = New-Item -Path "$OutputFolder\006_main.html" -ItemType File -Force

    #6-001
    function Get-DetailedPrefetchData {

        $Name = "6-001_DetailedPrefetchFileData"
        $FileName = "$Name.html"
        $Title = "Prefetch File Data (Detailed)"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime | Out-String

            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    function Write-PrefetchSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "<h4><a href='results\006\006_main.html' target='_blank'>Prefetch Data</a></h4>"

        $SectionName = "Prefetch Information Section"

        $SectionHeader = "
        <h4 class='section_header'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $PrefetchHtmlMainFile -Value $HtmlHeader
        Add-Content -Path $PrefetchHtmlMainFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "006") {
                continue
            }
            else {
                $FileNameEntry = "<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $PrefetchHtmlMainFile -Value $FileNameEntry
            }
        }

        Add-Content -Path $PrefetchHtmlMainFile -Value "</div>`n</body>`n</html>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DetailedPrefetchData


    Write-PrefetchSectionToMain
}


Export-ModuleMember -Function Export-PrefetchHtmlPage
