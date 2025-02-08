function Export-PrefetchHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    #6-001
    function Get-DetailedPrefetchData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        $Name = "6-001_DetailedPrefetchFileData"
        $FileName = "$Name.html"
        Show-Message("Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime
            if ($Data.Count -eq 0)
            {
                Invoke-NoDataFoundMessage $Name
            }
            else
            {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath

                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DetailedPrefetchData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-PrefetchHtmlPage
