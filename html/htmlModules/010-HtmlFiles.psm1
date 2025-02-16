function Export-FilesHtmlPage {

    [CmdletBinding()]

    param (
        [string]$KeywordsHtmlOutputFolder,
        [string]$HtmlReportFile,
        [string]$KeywordFile
    )

    # 10-001
    function Search-FilesByKeywords {

        param (
            [string]$SearchDirectory = "D:\"
        )

        $Name = "10-001_KeywordFileSearch"
        $FileName = "$Name.html"
        $OutputHtmlFilePath = New-Item -Path "$KeywordsHtmlOutputFolder\$FileName" -ItemType File -Force
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            # Ensure the keyword file exists
            if (-Not (Test-Path $KeywordFile)) {
                Write-Error "Keyword file not found: $KeywordFile"
            }

            # Ensure the directory to be searched exists
            if (-Not (Test-Path $SearchDirectory -PathType Container)) {
                Write-Error "Search directory not found: $SearchDirectory"
            }

            Show-Message("Keyword file identified as '$keywordFile'") -Green
            # Read keywords from the file, removing empty lines and trimming whitespace
            $keywords = Get-Content -Path $KeywordFile

            if (-Not $keywords) {
                Write-Error "No valid keywords found in file: $KeywordFile"
            }

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            Add-Content -Path $OutputHtmlFilePath -Value "$HtmlHeader`n`n<table>"

            # Stream through files and search for matches
            $Data = @()
            Get-ChildItem -Path $SearchDirectory -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                foreach ($string in $keywords) {
                    if ($_.FullName -like "*$string*") {
                        if ($Data -notcontains $_.FullName) {
                            $Data += $_.FullName
                        }
                    }
                }
            }

            foreach ($file in $Data ) {
                Add-Content -Path $OutputHtmlFilePath -Value "<tr><td>$($file)</td></tr>"
            }

            Add-Content -Path $OutputHtmlFilePath -Value "</table>`n`n$HtmlFooter"

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    function Write-KeywordsSectionToMain {

        $KeywordsSectionHeader = "
        <h4 class='section_header'>Keywords Search Results</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $KeywordsSectionHeader

        $FileList = Get-ChildItem -Path $KeywordsHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\010\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-FilesByKeywords


    Write-KeywordsSectionToMain
}


Export-ModuleMember -Function Export-FilesHtmlPage
