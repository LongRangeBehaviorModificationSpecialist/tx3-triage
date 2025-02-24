$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-PrefetchFiles {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]
        $CaseFolderName,
        [Parameter(Mandatory)]
        [string]
        $ComputerName,
        [Parameter(Mandatory)]
        [string]
        $PFFolder,
        # Variable for Windows Prefetch folder location
        [string]
        $WinPrefetchDir = "$Env:HOMEDRIVE\Windows\Prefetch",
        [int]
        $NumOfPFRecords = 5,
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Prefetch files from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $PFFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$PFFolder'"
            }

            # If no number is passed for the number of prefetch records to copy then copy all of the files
            if (-not $NumOfPFRecords) {
                Write-Information "No value passed for the ``NumOfPFRecords`` value."
                $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File
            }
            else {
                # Set variables for the files in the prefetch folder of the examined device
                $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File | Select-Object -First $NumOfPFRecords
            }

            if (-not (Test-Path $RawCopyPath)) {
                Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                return
            }

            foreach ($File in $Files) {
                try {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$WinPrefetchDir\$File" /OutputPath:"$PFFolder" /OutputName:"$File" }

                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        return
                    }
                }
                catch {
                    Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    return
                }
                $CopyMsg = "Copied file -> '$($File.Name)'"
                Show-Message -Message $CopyMsg -Magenta
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMsg"
            }
            $SuccessMsg = "Prefetch files copied successfully from computer: '$ComputerName'"
            Show-Message -Message $SuccessMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-PrefetchFiles
