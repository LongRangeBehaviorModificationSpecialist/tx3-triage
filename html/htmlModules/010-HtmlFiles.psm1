function Export-FilesHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath,
        [string]$KeywordFile
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 10-001
    function Search-FilesByKeywords {
        # Get-ChildItem "C:\Users\" -Recurse -Include *passwords*.txt
        param (
            [string]$FilePath,
            [string]$KeywordFile,
            [string]$SearchDirectory = "C:"
        )
        $Name = "10-001 Search File Names With Keywords"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            # Ensure the keyword file exists
            if (-Not (Test-Path $KeywordFile)) {
                Write-Error "Keyword file not found: $KeywordFile"
                return
            }

            # Ensure the search directory exists
            if (-Not (Test-Path $SearchDirectory -PathType Container)) {
                Write-Error "Search directory not found: $SearchDirectory"
                return
            }

            # Read keywords from the file, removing empty lines and trimming whitespace
            $keywords = Get-Content $KeywordFile | Where-Object { $_.Trim() -ne "" }

            if (-Not $keywords) {
                Write-Error "No valid keywords found in file: $KeywordFile"
                return
            }

            # Convert keywords into a single regex pattern for efficiency
            $pattern = ($keywords | ForEach-Object { [regex]::Escape($_) }) -join "|"

            # Search for matching files using optimized regex
            $Results = Get-ChildItem -Path $SearchDirectory -Recurse -File | Where-Object { $_.Name -match $pattern }
            if (-not $Results) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                $Data = $Results | Select-Object -Property FullName, Name
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }



    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-FilesByKeywords $FilePath -KeywordFile $KeywordFile


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-FilesHtmlPage
