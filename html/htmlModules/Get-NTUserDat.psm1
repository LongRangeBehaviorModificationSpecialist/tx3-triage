$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

function Invoke-HtmlNTUserDatFiles {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        [string]
        $RawCopyPath = ".\bin\RawCopy.exe"
    )

    $NTUserHtmlMainFile = New-Item -Path "$OutputFolder\NTUser_main.html" -ItemType File -Force

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
                        Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$OutputFolder" /OutputName:"$OutputFileName" }

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
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        finally {
            # Show & log $SuccessMsg message
            $SuccessMsg = "NTUSER.DAT files copied from computer: $ComputerName"
            Show-Message("[INFO] $SuccessMsg") -Blue
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")
        }
    }

    function Write-NTUserSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\NTUser\NTUser_main.html' target='_blank'>NTUSER.DAT Files</a></h3>" -Encoding UTF8

        $SectionName = "NTUSER.DAT Files"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $NTUserHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $NTUserHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 6)) -eq "NTUser") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $NTUserHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $NTUserHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlNTUserDatFiles


    Write-NTUserSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlNTUserDatFiles
