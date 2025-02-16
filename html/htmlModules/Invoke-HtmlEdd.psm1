$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

function Invoke-HtmlEncryptedDiskDetector {

    [CmdletBinding()]

    param (
        [string]$EddHtmlOutputFolder,
        [string]$HtmlReportFile,
        [string]$ComputerName,
        [string]$EddExeFilePath = ".\bin\EDDv310.exe"
    )

    function Get-HtmlEncryptedDiskDetector {

        $Name = "Encrypted_Disk_Detector"
        $Title = "Encrypted Disk Detector"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name'") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$EddHtmlOutputFolder\$FileName" -ItemType File -Force

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            # Name the file to save the results of the scan to
            $EddTxtFile = New-Item -Path "$EddHtmlOutputFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

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

            # Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Delete the Edd text file
            Remove-Item -Path $EddTxtFile -Force
        }
    }


    function Write-EddSectionToMain {

        $SectionName = "Encrypted Device Detector Results"

        $EddSectionHeader = "
        <h4 class='section_header'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $EddSectionHeader

        $FileList = Get-ChildItem -Path $EddHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\Edd\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlEncryptedDiskDetector


    Write-EddSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlEncryptedDiskDetector
