function Export-HtmlKeywordSearchPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $KeywordListFile,
        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]
        $KeyWordsDriveList
    )


    $KeyWordsHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    # 10-001
    function Search-FilesByKeywords {

        $Name = "10-001_KeywordFileSearch"
        $FileName = "$Name.html"
        $KeywordDriveArray = ($KeyWordsDriveList -split "\s*,\s*")  # Split on commas with optional surrounding spaces
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            # Ensure the keyword file exists
            if (-Not (Test-Path $KeywordListFile)) {
                Write-Error "Keyword file not found: $KeywordListFile"
            }

            Show-Message -Message "Keyword file identified as '$KeywordListFile'" -Green
            # Read keywords from the file, removing empty lines and trimming whitespace
            $Keywords = Get-Content -Path $KeywordListFile

            if (-Not $Keywords) {
                Write-Error "No valid keywords found in file: $KeywordListFile"
            }

            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

            Add-Content -Path $OutputHtmlFilePath -Value "$HtmlHeader`n`n<table>" -Encoding UTF8

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
                    Add-Content -Path $OutputHtmlFilePath -Value "<tr><td>$($File)</td></tr>" -Encoding UTF8
                }
            }
            Add-Content -Path $OutputHtmlFilePath -Value "</table>`n`n`t</body>`n</html>" -Encoding UTF8
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    function Write-KeywordsSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\010\main.html' target='_blank'>BitLocker Data</a></h3>" -Encoding UTF8

        $SectionName = "Keywords Search Results"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $KeyWordsHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $KeyWordsHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $KeyWordsHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }
        Add-Content -Path $KeyWordsHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-FilesByKeywords


    Write-KeywordsSectionToMain
}


Export-ModuleMember -Function Export-HtmlKeywordSearchPage
