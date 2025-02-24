$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-EventLogs {

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
        $EventLogFolder,
        # Set variable for Event Logs folder on the examined machine
        [string]
        $EventLogDir = "$Env:HOMEDRIVE\Windows\System32\winevt\Logs",
        [int]
        $NumOfEventLogs = 5,
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Event Logs from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $EventLogFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$EventLogFolder'"
            }

            # If no number is passed for the number of event logs to copy then copy all of the files
            if (-not $NumOfEventLogs) {
                Write-Information "No value passed for the ``NumOfEventLogs`` value."
                $Files = Get-ChildItem -Path $EventLogDir -Recurse -Force -File
            }
            else {
                # Set variables for the files in the prefetch folder of the examined device
                $Files = Get-ChildItem -Path $EventLogDir -Recurse -Force -File | Select-Object -First $NumOfEventLogs
            }

            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: '$RawCopyPath'"
                Show-Message -Message $NoRawCopyWarnMsg -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg" -WarningMessage
            }

            foreach ($File in $Files) {
                try {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$EventLogDir\$File" /OutputPath:"$EventLogFolder" /OutputName:"$File" }

                    if ($LASTEXITCODE -ne 0) {
                        $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        Show-Message -Message $NoProperExitMsg -Red
                        Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoProperExitMsg" -WarningMessage
                    }
                }
                catch {
                    $RawCopyOtherErrorMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    Show-Message -Message $RawCopyOtherErrorMsg -Red
                    Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $RawCopyOtherErrorMsg" -WarningMessage
                }

                # Show & log $CopyMsg messages of each file copied
                $CopyMsg = "Copied file -> '$($File.Name)'"
                Show-Message -Message $CopyMsg -Green
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMsg"
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "Event Log files copied successfully from computer: '$ComputerName'"
            Show-Message -Message $SuccessMsg
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-EventLogs
