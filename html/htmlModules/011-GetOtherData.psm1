$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Add-OtherData {

    [CmdletBinding()]

    param (
        [string]$OtherDataOutputFolder,
        [string]$FilesFolder,
        [string]$PagesFolder,
        [string]$ComputerName,
        [bool]$Edd,
        [bool]$GetNTUserDat
    )

    if ($Edd) {
        Invoke-HtmlEncryptedDiskDetector
    }

    if ($GetNTUserDat) {
        Get-HtmlNTUserDatFiles -FilePath $FilePath -FilesFolder $FilesFolder -ComputerName $ComputerName
    }

    function Invoke-HtmlEncryptedDiskDetector {

        [CmdletBinding()]

        param (
            [string]$EddExeFilePath = ".\bin\EDDv310.exe"
        )

        $Name = "Encrypted_Disk_Detector"
        $Title = "Encrypted Disk Detector"
        $FileName = "$Name.html"
        Show-Message("Running '$Name'") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OtherDataOutputFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            # Name the file to save the results of the scan to
            $EddTxtFile = New-Item -Path "$OtherDataOutputFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddTxtFile

            # Show & log $SuccessMsg message
            $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message("[INFO] $SuccessMsg") -Green
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")

            # Read the contents of the EDD text file and show the results on the screen
            $Data = Get-Content -Path $EddTxtFile -Force -Raw | Out-String
            Save-OutputToSingleHtmlFile -FromString $Name $(Get-Content -Path $EddTxtFile -Force -Raw) $OutputHtmlFilePath $Title
            Write-Host $Data

            Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Yellow
            Write-Host ""
            Read-Host -Prompt "Press [ENTER] to continue data collection -> "

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish

            Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Get-HtmlNTUserDatFiles {

        [CmdletBinding()]

        param (
            [string]$FilePath,
            [string]$FilesFolder,
            [string]$ComputerName,
            [string]$RawCopyPath = ".\bin\RawCopy.exe"
        )

        Show-Message("Running '$Name'") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

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
                        Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$FilesFolder" /OutputName:"$OutputFileName" }

                        Add-Content -Path $FilePath -Value "<a href='..\files\$OutputFileName' target='_blank'>`n<button class='file_btn'>`n<div class='file_btn_text'>$($OutputFileName)</div>`n</button>`n</a>`n"

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




}


Export-ModuleMember -Function Add-OtherData
