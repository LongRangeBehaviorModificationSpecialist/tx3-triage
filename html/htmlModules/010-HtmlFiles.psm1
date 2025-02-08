function Export-FilesHtmlPage {

    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath,
        [string]$PagesFolder,
        [string]$KeywordFile
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 10-001
    function Search-FilesByKeywords {

        param
        (
            [string]$FilePath,
            [string]$KeywordFile,
            [string]$PagesFolder,
            [string]$SearchDirectory = "D:\"
        )

        $Name = "10-001_KeywordFileSearch"
        $FileName = "$Name.html"
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force
        Show-Message("Running ``$Name`` command") -Header -DarkGray

        try
        {
            # Ensure the keyword file exists
            if (-Not (Test-Path $KeywordFile))
            {
                Write-Error "Keyword file not found: $KeywordFile"
            }

            # Ensure the directory to be searched exists
            if (-Not (Test-Path $SearchDirectory -PathType Container))
            {
                Write-Error "Search directory not found: $SearchDirectory"
            }

            Show-Message("Keyword file identified as ``$keywordFile``") -Green

            # Read keywords from the file, removing empty lines and trimming whitespace
            $keywords = Get-Content -Path $KeywordFile | Where-Object { $_ -ne "" }

            if (-Not $keywords)
            {
                Write-Error "No valid keywords found in file: $KeywordFile"
            }

            # Stream through files and search for matches
            $Results = Get-ChildItem -Path $SearchDirectory -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                foreach ($word in $keywords)
                {
                    if ($_.Name -like "*$word*")
                    {
                        # Write the matching file's full path to the output file
                        $_.FullName | Sort-Object -Property FullName -Unique | Out-File -FilePath $OutputHtmlFilePath -Append -Encoding UTF8
                    }
                }
            }

            if ($Results.Count -eq 0)
            {
                Invoke-NoDataFoundMessage $Name
            }
            else
            {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                $Data = $Results | Select-Object -Property FullName

                Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath

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
    Search-FilesByKeywords -FilePath $FilePath -PagesFolder $PagesFolder -KeywordFile $KeywordFile


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-FilesHtmlPage


#TODO - Test both functions and see which one return results faster
<# Another possible way to implement this function is listed below

# Stream through files and search for matches
Get-ChildItem -Path $searchDrive -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    foreach ($term in $searchTerms)
    {
        if ($file.Name -like "*$term*")
        {
            # Write the matching file's full path to the output file
            $file.FullName | Out-File -FilePath $outputFilePath -Append
        }
    }
}


#>