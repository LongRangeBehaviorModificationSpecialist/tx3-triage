$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

function Invoke-HtmlNTUserDatFiles {

    [CmdletBinding()]

    param (
        [string]
        $NTUserHtmlOutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    function Get-HtmlNTUserDatFiles {

        $Name = "Copy_NTUSER.DAT_Files"
        Show-Message("[INFO] Running '$Name'") -Header -DarkGray
        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

        try {
            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                Show-Message("[ERROR] $NoRawCopyWarnMsg") -Red
                Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg") -ErrorMessage
            }

            try {
                foreach ($User in Get-ChildItem(Join-Path -Path $Env:HOMEDRIVE -ChildPath "Users")) {

                    # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                    if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {

                        # Show & log the $CopyMsg message
                        $NTUserFilePath = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT"
                        $OutputFileName = "$User-NTUSER.DAT"
                        $CopyMsg = "Copying NTUSER.DAT file from the $User profile from computer: $ComputerName"

                        Show-Message("[INFO] $CopyMsg") -Magenta
                        Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMsg")
                        Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$NTUserHtmlOutputFolder" /OutputName:"$OutputFileName" }

                        if ($LASTEXITCODE -ne 0) {
                            $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            Show-Message("[ERROR] $NoProperExitMsg") -Red
                            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoProperExitMsg") -ErrorMessage
                        }
                    }
                }
            }
            catch {
                $RawCopyOtherMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $RawCopyOtherMsg") -Red
                Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $RawCopyOtherMsg") -ErrorMessage
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "NTUSER.DAT files copied from computer: $ComputerName"
            Show-Message("[INFO] $SuccessMsg") -Blue
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Write-NTUserSectionToMain {

        $SectionName = "NTUSER.DAT Files"

        $NTUserSectionHeader = "
        <h4 class='section_header' id='ntuser'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $NTUserSectionHeader

        $FileList = Get-ChildItem -Path $NTUserHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\NTUser\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlNTUserDatFiles


    Write-NTUserSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlNTUserDatFiles
