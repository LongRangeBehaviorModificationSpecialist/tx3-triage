$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-NTUserDatFiles {

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
        [string]
        $NTUserFolder,
        [string]
        $FilePathName = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT",
        [string]
        $OutputName = "$User-NTUSER.DAT",
        # Path to the RawCopy executable
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of NTUSER.DAT files from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $NTUserFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$NTUserFolder'"
            }

            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: '$RawCopyPath'"
                Show-Message -Message "$NoRawCopyWarnMsg" -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg" -WarningMessage
            }

            try {
                foreach ($User in Get-ChildItem($Env:HOMEDRIVE + "\Users\")) {
                    # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                    if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {
                        # Show & log the $CopyMsg message
                        $CopyMsg = "Copying NTUSER.DAT file from the $User profile from computer: '$ComputerName'"
                        Show-Message -Message $CopyMsg -Magenta
                        Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMsg"
                        $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$FilePathName" /OutputPath:"$NTuserFolder" /OutputName:"$OutputName" }

                        if ($LASTEXITCODE -ne 0) {
                            $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            Show-Message -Message $NoProperExitMsg -Red
                            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoProperExitMsg" -WarningMessage
                        }
                    }
                }
            }
            catch {
                $RawCopyOtherErrorMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                Show-Message -Message $RawCopyOtherErrorMsg -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $RawCopyOtherErrorMsg" -WarningMessage
            }
            $SuccessMsg = "NTUSER.DAT file(s) copied successfully from computer: '$ComputerName'"
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


Export-ModuleMember -Function Get-NTUserDatFiles
