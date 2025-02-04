function Export-PrefetchHtmlPage {

    [CmdletBinding()]

    param (
        # [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath,
        [string]$PagesFolder
        # [Parameter(Mandatory = $True, Position = 1)]
        # [string]$DetailsFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    #6-001
    function Get-DetailedPrefetchData {
        param (
            [string]$FilePath,
            [string]$PagesFolder
        )
        $Name = "6-001 Prefetch Files"
        $FileName = "6-001_DetailedPrefetchData.html"
        Show-Message("Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force
        write-output "Created $($OutputHtmlFilePath) file"
        # $OutputHtmlFilePath = Join-Path -Path $PagesFolder -ChildPath $FileName
        write-host "`n`$OutputHtmlFile variable = $OutputHtmlFilePath`n"
        try {
            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")

                Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='.\$FileName'>$FileName</a></pre></p></div>"

                Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Module: ``$(Split-Path -Path $MyInvocation.ScriptName -Leaf)``, function: ``$($MyInvocation.MyCommand.Name)``, Ln: $($PSItem.InvocationInfo.ScriptLineNumber) - $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
