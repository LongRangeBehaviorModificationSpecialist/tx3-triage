$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-CaseArchive {

    [CmdletBinding()]

    $CaseArchiveFuncName = $MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show beginning message
            Show-Message("Creating Case Archive file -> '$($CaseFolderName.Name).zip'") -Green
            $CaseFolderParent = Split-Path -Path $CaseFolderName -Parent
            $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
            Compress-Archive -Path $CaseFolderName -DestinationPath "$CaseFolderParent\$CaseFolderTitle.zip" -Force
            Show-Message("Case Archive file -> '$($CaseFolderName.Name).zip' created successfully") -Green
        }

        # Finish logging
        Show-FinishMessage $CaseArchiveFuncName $ExecutionTime
        Write-LogFinishedMessage $CaseArchiveFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($CaseArchiveFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-CaseArchive
