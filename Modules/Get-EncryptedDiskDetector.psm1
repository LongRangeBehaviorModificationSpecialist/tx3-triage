$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-EncryptedDiskDetector {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]
        [string]$ComputerName,
        # Name of the directory to store the results of the scan
        [string]$EddFolderName = "00A_EncryptedDiskDetector",
        # Name of the results file that will store the results of the scan
        [string]$EddResultsFileName = "EncryptedDiskDetector.txt",
        # Relative path to the Encrypted Disk Detector executable file
        [string]$EddExeFilePath = ".\bin\EDDv310.exe"
    )

    $EddFuncName = $MyInvocation.MyCommand.Name

    # If the user chooses the `-Edd` switch
    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting Encrypted Disk Detector on: $ComputerName"
            Show-Message("$BeginMessage")
            Write-LogEntry("[$($EddFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the scan results
            $EddFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $EddFolderName

            if (-not (Test-Path $EddFolder)) {
                throw "[ERROR] The necessary folder does not exist -> ``$EddFolder``"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created ``$($EddFolder.Name)`` folder in the case directory"
            Show-Message("$CreateDirMsg") -Green
            Write-LogEntry("[$($EddFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Name the file to save the results of the scan to
            $EddFilePath = Join-Path -Path $EddFolder -ChildPath $EddResultsFileName

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddFilePath

            # Show & log $SuccessMsg message
            $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message("$SuccessMsg") -Green
            Write-LogEntry("[$($EddFuncName), Ln: $(Get-LineNum)] $SuccessMsg")

            # Show & log file location message
            Show-OutputSavedToFile $EddFilePath
            Write-LogOutputSaved $EddFilePath
        }

        # Show & log finish messages
        Show-FinishMessage $EddFuncName $ExecutionTime
        Write-LogFinishedMessage $EddFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message -Message "$ErrorMessage" -Red
        Write-LogEntry("[$($EddFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-EncryptedDiskDetector
