function Export-PrefetchHtmlPage {

    [CmdletBinding()]

    param (
        [string]$PrefetchHtmlOutputFolder,
        [string]$HtmlReportFile
    )

    #6-001
    function Get-DetailedPrefetchData {

        $Name = "6-001_DetailedPrefetchFileData"
        $FileName = "$Name.html"
        $Title = "Prefetch File Data (Detailed)"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PrefetchHtmlOutputFolder\$FileName" -ItemType File -Force

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

        $PrefetchSectionHeader = "
        <h4 class='section_header'>Prefetch Information Section</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $PrefetchSectionHeader

        $FileList = Get-ChildItem -Path $PrefetchHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\webpages\006\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DetailedPrefetchData


    Write-PrefetchSectionToMain
}


Export-ModuleMember -Function Export-PrefetchHtmlPage
