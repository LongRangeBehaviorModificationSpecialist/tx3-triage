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
        $Title = "Prefetch File Data (Detailed)"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime | Out-String
            if ($Data.Count -eq 0)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                Save-OutputToSingleHtmlFile -FromString -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-DetailedPrefetchData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-PrefetchHtmlPage
