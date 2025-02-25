$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue

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

    $NTUserHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force

    function Get-HtmlNTUserDatFiles {

        $Name = "Copy_NTUSER.DAT_Files"
        Show-Message -Message "[INFO] Running '$Name'" -Header -DarkGray
        Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

        try {
            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                Show-Message -Message "[ERROR] $NoRawCopyWarnMsg" -Red
                Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg" -ErrorMessage
            }

            try {
                foreach ($User in Get-ChildItem(Join-Path -Path $Env:HOMEDRIVE -ChildPath "Users")) {

                    # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                    if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {

                        # Show & log the $CopyMsg message
                        $NTUserFilePath = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT"
                        $OutputFileName = "$User-NTUSER.DAT"
                        $CopyMessage = "Copying NTUSER.DAT file from the '$User' profile from computer: '$ComputerName'"

                        Show-Message -Message "[INFO] $CopyMessage" -Magenta
                        Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $CopyMessage"
                        Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$OutputFolder" /OutputName:"$OutputFileName" }

                        if ($LASTEXITCODE -ne 0) {
                            $NoProperExitMessage = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            Show-Message -Message "[ERROR] $NoProperExitMessage" -Red
                            Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NoProperExitMessage" -ErrorMessage
                        }
                    }
                }
            }
            catch {
                $RawCopyOtherMessage = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                Show-Message -Message "[ERROR] $RawCopyOtherMessage" -Red
                Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $RawCopyOtherMessage" -ErrorMessage
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        finally {
            $SuccessMsg = "NTUSER.DAT files copied from computer: '$ComputerName'"
            Show-Message -Message "[INFO] $SuccessMsg" -Blue
            Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
    }

    function Write-NTUserSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\NTUser\main.html' target='_blank'>NTUSER.DAT Files</a></h3>" -Encoding UTF8

        $SectionName = "NTUSER.DAT Files"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $NTUserHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $NTUserHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
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
