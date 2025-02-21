$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-NTUserDatFiles {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]

        [string]$ComputerName,
        # Name of the directory to store the copied NTUSER.DAT files
        [string]$NTUserFolderName = "00F_NTUserDATFiles",
        [string]$FilePathName = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT",
        [string]$OutputName = "$User-NTUSER.DAT",
        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe"
    )

    $NTUserFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of NTUSER.DAT files from computer: $ComputerName"
            Show-Message("$BeginMessage")
            Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the copied .DAT files
            $NTUserFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $NTUserFolderName

            if (-not (Test-Path $NTUserFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$NTUserFolder'"
            }

            # Show & log $CreateDirMsg messages
            $CreateDirMsg = "Created '$($NTUserFolder.Name)' folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                Show-Message("$NoRawCopyWarnMsg") -Red
                Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg") -WarningMessage
            }

            try {
                foreach ($User in Get-ChildItem($Env:HOMEDRIVE + "\Users\")) {
                    # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                    if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {
                        # Show & log the $CopyMsg message
                        $CopyMsg = "Copying NTUSER.DAT file from the $User profile from computer: $ComputerName"
                        Show-Message("$CopyMsg") -Magenta
                        Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $CopyMsg")
                        $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$FilePathName" /OutputPath:"$NTuserFolder" /OutputName:"$OutputName" }

                        if ($LASTEXITCODE -ne 0) {
                            $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            Show-Message("$NoProperExitMsg") -Red
                            Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $NoProperExitMsg") -WarningMessage
                        }
                    }
                }
            }
            catch {
                $RawCopyOtherMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                Show-Message("$RawCopyOtherMsg") -Red
                Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $RawCopyOtherMsg") -WarningMessage
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "NTUSER.DAT files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }

        # Show & log finish messages
        Show-FinishMessage $NTUserFuncName $ExecutionTime
        Write-LogFinishedMessage $NTUserFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($NTUserFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-NTUserDatFiles
