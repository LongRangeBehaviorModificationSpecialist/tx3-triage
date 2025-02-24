$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-EncryptedDiskDetector {

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
        $EddFolder,
        # Name of the results file that will store the results of the scan
        [string]$EddResultsFileName = "EncryptedDiskDetector.txt",
        # Relative path to the Encrypted Disk Detector executable file
        [string]$EddExeFilePath = ".\bin\EDDv310.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting Encrypted Disk Detector on: $ComputerName"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $EddFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$EddFolder'"
            }

            # Name the file to save the results of the scan to
            $EddFilePath = Join-Path -Path $EddFolder -ChildPath $EddResultsFileName

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddFilePath

            # Show & log $SuccessMsg message
            $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message -Message $SuccessMsg -Green
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"

            # Show & log file location message
            Show-OutputSavedToFile -File $EddFilePath
            Write-LogOutputSaved -File $EddFilePath
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-EncryptedDiskDetector
