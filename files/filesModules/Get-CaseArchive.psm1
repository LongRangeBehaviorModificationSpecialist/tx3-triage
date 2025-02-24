$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-CaseArchive {

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "Creating Case Archive file -> '$($CaseFolderName.Name).zip'" -Header -Green
            $CaseFolderParent = Split-Path -Path $CaseFolderName -Parent
            $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
            Compress-Archive -Path $CaseFolderName -DestinationPath "$CaseFolderParent\$CaseFolderTitle.zip" -Force
            Show-Message -Message "Case archive file created successfully" -Header -Green
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-CaseArchive
