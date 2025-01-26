function Get-PrefetchFiles {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Name of the directory to store the copied prefetch files
        [string]$PFFolderName = "00G_PrefetchFiles",
        # Variable for Windows Prefetch folder location
        [string]$WinPrefetchDir = "$Env:HOMEDRIVE\Windows\Prefetch",
        [int]$NumberOfRecords = 5,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe"
    )

    $PFCopyFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Prefetch files from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogEntry("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the prefetch files
            $PFFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $PFFolderName

            if (-not (Test-Path $PFFolder)) {
                throw "[ERROR] The necessary folder does not exist -> ``$PFFolder``"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created ``$($PFFolder.Name)`` folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Set variables for the files in the prefetch folder of the examined device
            $Files = Get-ChildItem -Path $WinPrefetchDir -Recurse -Force -File | Select-Object -First $NumberOfRecords

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
                # Show & log $CopyMsg messages of each file copied
                $CopyMsg = "Copied file -> ``$($File.Name)``"
                Show-Message($CopyMsg) -Magenta
                Write-LogEntry("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $CopyMsg")
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "Prefetch files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $PFCopyFuncName $ExecutionTime
        Write-LogFinishedMessage $PFCopyFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($PFCopyFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-PrefetchFiles
