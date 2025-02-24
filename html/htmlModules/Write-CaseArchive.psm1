$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Invoke-HtmlCaseArchive {

    try {
        # Show beginning message
        Show-Message -Message "[INFO] Creating Case Archive file -> '$($CaseFolderName.Name).zip'" -Header -Blue
        $CaseFolderParent = Split-Path -Path $CaseFolderName -Parent
        $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
        Compress-Archive -Path $CaseFolderName -DestinationPath "$CaseFolderParent\$CaseFolderTitle.zip" -Force
        Show-Message -Message "[INFO] Case archive file created successfully" -Header -Blue
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-HtmlCaseArchive
