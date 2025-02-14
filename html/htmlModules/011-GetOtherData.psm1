$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Add-OtherData {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$FilesFolder,
        [string]$PagesFolder,
        [string]$ComputerName,
        [bool]$Edd,
        [bool]$GetNTUserDat
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='item_table'>"  # Add this to display the results in a flexbox


    if ($Edd) {
        Invoke-HtmlEncryptedDiskDetector -FilePath $FilePath -FilesFolder $FilesFolder -PagesFolder $PagesFolder
    }

    if ($GetNTUserDat) {
        # No need to pass the $PagesFolder to this function.  Not saving any files to that folder
        Get-HtmlNTUserDatFiles -FilePath $FilePath -FilesFolder $FilesFolder -ComputerName $ComputerName
    }

    function Invoke-HtmlEncryptedDiskDetector {

        [CmdletBinding()]

        param (
            [string]$FilePath,
            [string]$FilesFolder,
            [string]$PagesFolder,
            [string]$EddExeFilePath = ".\bin\EDDv310.exe"
        )

        $FunctionName = $MyInvocation.MyCommand.Name

        $Name = "Encrypted_Disk_Detector"
        $Title = "Encrypted Disk Detector"
        $FileName = "$Name.html"
        Show-Message("Running '$Name'") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            # Name the file to save the results of the scan to
            $EddTxtFile = New-Item -Path "$FilesFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddTxtFile

            # Show & log $SuccessMsg message
            $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message("[INFO] $SuccessMsg") -Green
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $SuccessMsg")

            Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"

            # Read the contents of the EDD text file and show the results on the screen
            $Data = Get-Content -Path $EddTxtFile -Force -Raw | Out-String
            Save-OutputToSingleHtmlFile -FromString $Name $(Get-Content -Path $EddTxtFile -Force -Raw) $OutputHtmlFilePath $Title
            Write-Host $Data

            Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Yellow
            Write-Host ""
            Read-Host -Prompt "Press [ENTER] to continue data collection -> "

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish

            Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div
        }
        catch {
            Invoke-ShowErrorMessage $($FunctionName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Get-HtmlNTUserDatFiles {

        [CmdletBinding()]

        param (
            [string]$FilePath,
            [string]$FilesFolder,
            [string]$ComputerName,
            # Path to the RawCopy executable
            [string]$RawCopyPath = ".\bin\RawCopy.exe"
        )

        $FunctionName = $MyInvocation.MyCommand.Name

        Show-Message("Running '$Name'") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            if (-not (Test-Path $RawCopyPath)) {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                Show-Message("[ERROR] $NoRawCopyWarnMsg") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg") -ErrorMessage
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
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $CopyMsg")
                        Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$FilesFolder" /OutputName:"$OutputFileName" }

                        Add-Content -Path $FilePath -Value "<a href='..\files\$OutputFileName' target='_blank'>`n<button class='file_btn'>`n<div class='file_btn_text'>$($OutputFileName)</div>`n</button>`n</a>`n"

                        if ($LASTEXITCODE -ne 0) {
                            $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                            Show-Message("[ERROR] $NoProperExitMsg") -Red
                            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $NoProperExitMsg") -ErrorMessage
                        }
                    }
                }
            }
            catch {
                $RawCopyOtherMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $RawCopyOtherMsg") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $RawCopyOtherMsg") -ErrorMessage
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "NTUSER.DAT files copied from computer: $ComputerName"
            Show-Message("[INFO] $SuccessMsg") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        catch {
            Invoke-ShowErrorMessage $($FunctionName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Add-OtherData
