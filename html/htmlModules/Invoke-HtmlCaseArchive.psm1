$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlCaseArchive {

    [CmdletBinding()]

    $FunctionName = $MyInvocation.MyCommand.Name

    try {
        # Show beginning message
        Show-Message("[INFO] Creating Case Archive file -> '$($CaseFolderName.Name).zip'") -Header -Green
        $CaseFolderParent = Split-Path -Path $CaseFolderName -Parent
        $CaseFolderTitle = (Get-Item -Path $CaseFolderName).Name
        Compress-Archive -Path $CaseFolderName -DestinationPath "$CaseFolderParent\$CaseFolderTitle.zip" -Force
        Show-Message("[INFO] Case Archive file -> '$($CaseFolderName.Name).zip' created successfully") -Green
    }
    catch {
        Invoke-ShowErrorMessage $($FunctionName) $(Get-LineNum) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-HtmlCaseArchive
