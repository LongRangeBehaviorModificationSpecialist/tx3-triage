$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-HtmlSruDb {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        [string]
        $FileNamePath = "$Env:windir\System32\sru\SRUDB.dat",
        [string]
        $OutputFileName = "SRUDB_$($ComputerName).dat",
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )


    $SruDbHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    function Copy-SruDBFile {

        $Name = "Copy_SRUDB.dat_File"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            $BeginMessage = "Beginning capture of SRUDB.dat file from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage -DarkGray
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            try {
                $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$FileNamePath /OutputPath:"$OutputFolder" /OutputName:$OutputFileName }

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

            $FileHashingMsg = "Calculating the original hash value of $FileNamePath"
            Show-Message -Message $FileHashingMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileHashingMsg"

            # Calculate the value of the hash value of the SRUDB.dat file before it is copied
            $OriginalFileHash = (Get-FileHash -Path $FileNamePath -Algorithm SHA256).Hash
            $OrigFileHashMsg = "Hash value of original SRUDB.dat file -> $OriginalFileHash"
            Show-Message -Message $OrigFileHashMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $OrigFileHashMsg"

            $CopiedFile = Join-Path -Path $OutputFolder -ChildPath $OutputFileName

            # Get hash value of copied file
            $CopiedFileHash = (Get-FileHash -Path $CopiedFile -Algorithm SHA256).Hash
            $CopiedFileHashMsg = "Hash value of copied SRUDB.dat file -> $CopiedFileHash"
            Show-Message -Message $CopiedFileHashMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopiedFileHashMsg"

            # Compare the hashes
            if ($OriginalFileHash -eq $CopiedFileHash) {
                $HashMatchMsg = "Hashes match! The file was copied successfully."
                Show-Message -Message $HashMatchMsg -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashMatchMsg"

                # Show & log $SuccessMsg message
                $SuccessMsg = "SRUDB.dat file copied successfully from computer: $ComputerName"
                Show-Message -Message $SuccessMsg -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"

                # Show & log $FileSavTitle message
                $FileSavName = "Copied file saved as -> $OutputFileName"
                Show-Message -Message $FileSavName -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileSavName"
            }
            else {
                $HashNotMatchMsg = "Hashes do not match! There was an error in copying the file."
                Show-Message -Message $HashNotMatchMsg -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashNotMatchMsg" -ErrorMessage
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    function Write-SruDbSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\SruDb\main.html' target='_blank'>SRUDB.dat File</a></h3>" -Encoding UTF8

        $SectionName = "SRUDB.dat File"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $SruDbHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $SruDbHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $SruDbHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $SruDbHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Copy-SruDBFile


    Write-SruDbSectionToMain
}


Export-ModuleMember -Function Get-HtmlSruDb
