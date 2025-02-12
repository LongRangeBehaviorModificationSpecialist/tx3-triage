function Export-PrefetchHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    #6-001
    function Get-DetailedPrefetchData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "6-001_DetailedPrefetchFileData"
        $FileName = "$Name.html"
        $Title = "Prefetch File Data (Detailed)"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime | Out-String
            if ($Data.Count -eq 0) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DetailedPrefetchData -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-PrefetchHtmlPage
