$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlCaseArchive {

    try {
        # Show beginning message
        Show-Message("[INFO] Creating Case Archive file -> '$($CaseFolderName.Name).zip'") -Header -Blue
        $CaseFolderParent = Split-Path -Path $CaseFolderName -Parent
        $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
        Compress-Archive -Path $CaseFolderName -DestinationPath "$CaseFolderParent\$CaseFolderTitle.zip" -Force
        Show-Message("[INFO] Case archive file created successfully") -Header -Blue
    }
    catch {
        Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-HtmlCaseArchive
