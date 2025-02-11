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
            $keywords = Get-Content -Path $KeywordFile

            if (-Not $keywords)
            {
                Write-Error "No valid keywords found in file: $KeywordFile"
            }

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

            Add-Content -Path $OutputHtmlFilePath -Value "$HtmlHeader`n`n<table>"
            # Stream through files and search for matches
            $Data = @()
            Get-ChildItem -Path $SearchDirectory -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                foreach ($string in $keywords)
                {
                    if ($_.FullName -like "*$string*")
                    {
                        if ($Data -notcontains $_.FullName)
                        {
                            $Data += $_.FullName
                        }
                    }
                }
            }
            foreach ($file in $Data )
            {
                Add-Content -Path $OutputHtmlFilePath -Value "<tr><td>$($file)</td></tr>"
            }

            Add-Content -Path $OutputHtmlFilePath -Value "</table>`n`n$HtmlFooter"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
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
    Search-FilesByKeywords -FilePath $FilePath -PagesFolder $PagesFolder -KeywordFile $KeywordFile


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-FilesHtmlPage
