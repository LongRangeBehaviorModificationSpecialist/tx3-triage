$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-HtmlCopyPrefetchFiles {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        # Variable for Windows Prefetch folder location
        [string]
        $WinPrefetchDir = "$Env:HOMEDRIVE\Windows\Prefetch",
        [int]
        $NumOfPfRecords = 5,
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )


    $PrefetchHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    function Copy-Prefetch {

        $Name = "Copy_Prefetch_Files"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Prefetch files from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage -DarkGray
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            # If no number is passed for the number of prefetch records to copy then copy all of the files
            if (-not $NumOfPfRecords) {
                Write-Information "No value passed for the 'NumOfPfRecords' value."
                $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File
            }
            else {
                # Select only the number of records specified
                $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File | Select-Object -First $NumOfPfRecords
            }

            foreach ($File in $Files) {
                try {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$WinPrefetchDir\$File" /OutputPath:"$OutputFolder" /OutputName:"$File" }

                    if ($LASTEXITCODE -ne 0) {
                        $NoProperExitMessage = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        Show-Message -Message "[ERROR] $NoProperExitMessage" -Red
                        Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoProperExitMessage" -ErrorMessage
                    }
                }
                catch {
                    $RawCopyOtherMessage = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    Show-Message -Message "[ERROR] $RawCopyOtherMessage" -Red
                    Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $RawCopyOtherMessage" -ErrorMessage
                }

                $CopyMsg = "Copied file -> '$($File.Name)'"
                Show-Message -Message $CopyMsg -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMsg"
            }

            $SuccessMsg = "Prefetch files copied successfully from computer: '$ComputerName'"
            Show-Message -Message $SuccessMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    function Write-PrefetchSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\Prefetch\main.html' target='_blank'>Prefetch File</a></h3>" -Encoding UTF8

        $SectionName = "Prefetch Files"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $PrefetchHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $PrefetchHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $PrefetchHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $PrefetchHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8

    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Copy-Prefetch


    Write-PrefetchSectionToMain
}


Export-ModuleMember -Function Get-HtmlCopyPrefetchFiles
