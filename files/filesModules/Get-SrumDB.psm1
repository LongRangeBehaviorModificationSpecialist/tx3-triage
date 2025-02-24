$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-SrumDB {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]
        $CaseFolderName,
        [Parameter(Mandatory)]
        [string]
        $ComputerName,
        # Name of the directory to store the copied SRUM file
        [Parameter(Mandatory)]
        [string]
        $SrumFolder,
        [string]
        $FileNamePath = "$Env:windir\System32\sru\SRUDB.dat",
        [string]
        $OutputFileName = "SRUDB_$($ComputerName).dat",
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning capture of SRUMDB.dat files from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $SrumFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$SrumFolder'"
            }

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            try {
                $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$FileNamePath /OutputPath:"$SrumFolder" /OutputName:$OutputFileName }
                if ($LASTEXITCODE -ne 0) {
                    Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                    return
                }
            }
            catch {
                Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                return
            }

            $FileHashingMsg = "Calculating the original hash value of $FileNamePath"
            Show-Message -Message $FileHashingMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileHashingMsg"

            # Calculate the value of the hash value of the SRUMDB.dat file before it is copied
            $OriginalFileHash = (Get-FileHash -Path $FileNamePath -Algorithm SHA256).Hash
            $OrigFileHashMsg = "Hash value of original SRUMDB.dat file -> $OriginalFileHash"
            Show-Message -Message $OrigFileHashMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $OrigFileHashMsg"

            $CopiedFile = Join-Path -Path $SrumFolder -ChildPath $OutputFileName

            # Get hash value of copied file
            $CopiedFileHash = (Get-FileHash -Path $CopiedFile -Algorithm SHA256).Hash
            $CopiedFileHashMsg = "Hash value of copied SRUMDB.dat file -> $CopiedFileHash"
            Show-Message -Message $CopiedFileHashMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopiedFileHashMsg"

            # Compare the hashes
            if ($OriginalFileHash -eq $CopiedFileHash) {
                $HashMatchMsg = "Hashes match! The file was copied successfully."
                Show-Message -Message $HashMatchMsg -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $HashMatchMsg"

                # Show & log $SuccessMsg message
                $SuccessMsg = "SRUMDB.dat file copied successfully from computer: $ComputerName"
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
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-SrumDB
