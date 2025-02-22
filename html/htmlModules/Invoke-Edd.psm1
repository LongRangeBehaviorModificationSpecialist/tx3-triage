$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

function Invoke-HtmlEncryptedDiskDetector {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        [string]
        $EddExeFilePath = ".\bin\EDDv310.exe"
    )

    $EddHtmlMainFile = New-Item -Path "$OutputFolder\Edd_main.html" -ItemType File -Force

    function Get-HtmlEncryptedDiskDetector {

        $Name = "Encrypted_Disk_Detector"
        $Title = "Encrypted Disk Detector"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name'") -Header -DarkGray
        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {

            # Name the file to save the results of the scan to
            $EddTxtFile = New-Item -Path "$OutputFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

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

            # Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Yellow
            # Write-Host ""
            # Read-Host -Prompt "Press [ENTER] to continue data collection -> "

            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        finally {
            # Delete the Edd text file
            Remove-Item -Path $EddTxtFile -Force
        }
    }


    function Write-EddSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\Edd\Edd_main.html' target='_blank'>Encrypted Disk Detector Results</a></h3>" -Encoding UTF8

        $SectionName = "Encrypted Device Detector Results"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $EddHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $EddHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "Edd") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $EddHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $EddHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlEncryptedDiskDetector


    Write-EddSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlEncryptedDiskDetector
