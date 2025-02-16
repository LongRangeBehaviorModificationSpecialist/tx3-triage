function Export-HtmlKeywordSearchPage {

    [CmdletBinding()]

    param (
        [string]$KeywordsHtmlOutputFolder,
        [string]$HtmlReportFile,
        [string]$KeywordListFile,
        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]$KeyWordsDriveList
    )

    # 10-001
    function Search-FilesByKeywords {

        $Name = "10-001_KeywordFileSearch"
        $FileName = "$Name.html"
        $KeywordDriveArray = ($KeyWordsDriveList -split "\s*,\s*")  # Split on commas with optional surrounding spaces
        $OutputHtmlFilePath = New-Item -Path "$KeywordsHtmlOutputFolder\$FileName" -ItemType File -Force
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            # Ensure the keyword file exists
            if (-Not (Test-Path $KeywordListFile)) {
                Write-Error "Keyword file not found: $KeywordListFile"
            }

            Show-Message("Keyword file identified as '$KeywordListFile'") -Green
            # Read keywords from the file, removing empty lines and trimming whitespace
            $Keywords = Get-Content -Path $KeywordListFile

            if (-Not $Keywords) {
                Write-Error "No valid keywords found in file: $KeywordListFile"
            }

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            Add-Content -Path $OutputHtmlFilePath -Value "$HtmlHeader`n`n<table>"

            foreach ($DriveName in $KeywordDriveArray) {
                # Stream through files and search for matches
                $Data = @()
                Get-ChildItem -Path "$($DriveName):" -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                    foreach ($String in $Keywords) {
                        if ($_.FullName -like "*$String*") {
                            if ($Data -notcontains $_.FullName) {
                                $Data += $_.FullName
                            }
                        }
                    }
                }

                foreach ($File in $Data) {
                    Add-Content -Path $OutputHtmlFilePath -Value "<tr><td>$($File)</td></tr>"
                }
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

        $SectionName = "Keywords Search Results"

        $SectionHeader = "
        <h4 class='section_header' id='keywords'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

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


Export-ModuleMember -Function Export-HtmlKeywordSearchPage
