$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-FileHashes {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]

        [string]$ComputerName,
        [string[]]$ExcludedFiles = @('*PowerShell_transcript*'),
        # Name of the directory to store the hash results .CSV file
        [string]$HashResultsFolderName = "HashResults"
    )

    $FileHashFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $beginMessage message
            $BeginMessage = "Hashing files for computer: $ComputerName"
            Show-Message("$BeginMessage")
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the prefetch files
            $HashResultsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $HashResultsFolderName

            if (-not (Test-Path $HashResultsFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$HashResultsFolder'"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created '$($HashResultsFolder.Name)' folder in the case directory`n"
            Show-Message("$CreateDirMsg") -Green
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Add the filename and filetype to the end
            $HashOutputFilePath = Join-Path -Path $HashResultsFolder -ChildPath "$((Get-Item -Path $CaseFolderName).Name)_HashValues.csv"

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
                Show-Message("$ProgressMsg")

                # Show & log $HashMsgFileName and hashMsgHashValue messages for each file
                $HashMsgFileName = "Completed hashing file: '$($_.Name)'"
                $HashValueMsg = "[SHA256]: $($FileHash)`n"
                Show-Message("$HashMsgFileName") -Blue
                Show-Message("$HashValueMsg") -Blue
                Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $HashMsgFileName")
                Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $HashValueMsg`n")
            }

            # Export the results to the CSV file
            $Results | Export-Csv -Path $HashOutputFilePath -NoTypeInformation -Encoding UTF8

            # Show & log $FileMsg message
            $FileMsg = "Hash values saved to -> '$HashOutputFileName'`n"
            Show-Message("$FileMsg") -Blue
            Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $FileMsg")
        }

        # Show & log finish messages
        Show-FinishMessage $FileHashFuncName $ExecutionTime
        Write-LogFinishedMessage $FileHashFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($FileHashFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-FileHashes
