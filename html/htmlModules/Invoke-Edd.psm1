$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue

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


    $EddHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    function Get-HtmlEncryptedDiskDetector {

        $Name = "Encrypted_Disk_Detector"
        $Title = "Encrypted Disk Detector"
        $FileName = "$Name.html"
        Show-Message -Message "[INFO] Running '$Name'" -Header -DarkGray
        Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            # Name the file to save the results of the scan to
            $EddTxtFile = New-Item -Path "$OutputFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

            # Start the encrypted disk detector executable
            Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddTxtFile

            # Show & log $SuccessMsg message
            $SuccessMessage = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
            Show-Message -Message "[INFO] $SuccessMessage" -Green
            Write-HtmlLogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMessage"

            # Read the contents of the EDD text file and show the results on the screen
            $Data = Get-Content -Path $EddTxtFile -Force -Raw | Out-String
            Save-OutputToSingleHtmlFile -Name $Name -Data $(Get-Content -Path $EddTxtFile -Force -Raw) -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
            Write-Host $Data

            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        finally {
            # Delete the Edd text file
            Remove-Item -Path $EddTxtFile -Force
        }
    }


    function Write-EddSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\Edd\main.html' target='_blank'>Encrypted Disk Detector Results</a></h3>" -Encoding UTF8

        $SectionName = "Encrypted Device Detector Results"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $EddHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $EddHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
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
