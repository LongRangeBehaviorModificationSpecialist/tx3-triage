$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-FileHashes {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $CaseFolderName,
        [string]
        $ComputerName,
        [string[]]
        $ExcludedFiles = @("*PowerShell_transcript*")
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $beginMessage message
            $BeginMessage = "Hashing files for computer: $ComputerName"
            Show-Message("[INFO] $BeginMessage")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

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
            $Results = Get-ChildItem -Path $CaseFolderName -Recurse -Force -File | Where-Object { $_.Name -notlike $ExcludedFiles } | ForEach-Object {
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
                Show-Message("[INFO] $ProgressMsg")

                # Show & log $HashMsgFileName and hashMsgHashValue messages for each file
                $HashMsgFileName = "Completed hashing file: '$($_.Name)'"
                $HashValueMsg = "[SHA256]: $($FileHash)`n"
                Show-Message("[INFO] $HashMsgFileName") -Blue
                Show-Message("[INFO] $HashValueMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashMsgFileName")
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashValueMsg`n")
            }

            # Export the results to the CSV file
            $Results | Export-Csv -Path $HashOutputFilePath -NoTypeInformation -Encoding UTF8

            $FileMsg = "Hash values saved to -> '$HashOutputFileName'`n"
            Show-Message("[INFO] $FileMsg") -Blue
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileMsg")
        }
        Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-FileHashes
