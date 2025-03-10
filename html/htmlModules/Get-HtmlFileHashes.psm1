$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-HtmlFileHashes {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $ResultsFolder,
        [string]
        $ComputerName,
        [string[]]
        $ExcludedFiles = @('*PowerShell_transcript*')
    )

    try {
        $BeginMessage = "Hashing report files for computer: $ComputerName"
        Show-Message -Message "[INFO] $BeginMessage" -Header -DarkGray
        Write-HtmlLogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

        if (-not (Test-Path $OutputFolder)) {
            throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
        }

        # Add the filename and filetype to the end
        $HashOutputFilePath = Join-Path -Path $OutputFolder -ChildPath "$((Get-Item -Path $CaseFolderName).Name)_HashValues.csv"

        # Return the full name of the CSV file
        $HashOutputFileName = [System.IO.Path]::GetFileName($HashOutputFilePath)

        # Get the hash values of all the saved files in the output directory
        $Results = @()

        # Exclude the PowerShell transcript file from being included in the file that are hashed
        $Results = Get-ChildItem -Path $ResultsFolder -Recurse -Force -File | Where-Object { $_.Name -notlike $ExcludedFiles } | ForEach-Object {
            $FileHash = (Get-FileHash -Algorithm SHA256 -Path $_.FullName).Hash
            [PSCustomObject]@{
                DirectoryName      = $_.DirectoryName
                BaseName           = $_.BaseName
                Extension          = $_.Extension
                PSIsContainer      = $_.PSIsContainer
                SizeInKB           = [math]::Round(($_.Length / 1KB), 2)
                Mode               = $_.Mode
                "FileHash(Sha256)" = $FileHash
                Attributes         = $_.Attributes
                IsReadOnly         = $_.IsReadOnly
                CreationTimeUTC    = $_.CreationTimeUtc
                LastAccessTimeUTC  = $_.LastAccessTimeUtc
                LastWriteTimeUTC   = $_.LastWriteTimeUtc
            }

            # Show & log $ProgressMsg message
            $ProgressMsg = "Hashing file: $($_.Name)"
            Show-Message -Message "$ProgressMsg"

            # Show & log $HashMsgFileName and hashMsgHashValue messages for each file
            $HashMsgFileName = "Completed hashing file: '$($_.Name)'"
            $HashValueMsg = "[SHA256] -> $($FileHash)`n"
            Show-Message -Message "$HashMsgFileName" -Blue
            Show-Message -Message "$HashValueMsg" -Blue
            Write-HtmlLogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashMsgFileName"
            Write-HtmlLogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashValueMsg"
        }

        # Export the results to the CSV file
        $Results | Export-Csv -Path $HashOutputFilePath -NoTypeInformation -Encoding UTF8

        # Show & log $FileMsg message
        $FileMsg = "Hash values saved to -> '$HashOutputFileName'`n"
        Show-Message -Message "$FileMsg" -Blue
        Write-HtmlLogEntry -Message "[$($FunctionName), Ln: $(Get-LineNum)] $FileMsg"
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-HtmlFileHashes
