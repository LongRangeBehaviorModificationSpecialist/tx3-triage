$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-HtmlComputerRam {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        [string]
        $RamCaptureExeFilePath = ".\bin\MRCv120.exe"
    )


    $RamHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force


    function Get-ComputerRam {

        $Name = "Get_Computer_RAM"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            $BeginMessage = "Starting RAM capture from computer: $ComputerName. Please wait..."
            Show-Message -Message "[INFO] $BeginMessage" -DarkGray
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            $RamOutputFileName = "$($RunDate)_$($ComputerName)_RAM_Capture.raw"

            # Start the RAM acquisition from the current machine
            Start-Process -NoNewWindow -FilePath $RamCaptureExeFilePath -ArgumentList "/accepteula /go "$OutputFolder\$RamOutputFileName" /silent" -Wait

            # Once the RAM has been acquired, move the file to the 'RAM' folder
            Move-Item -Path .\bin\*.raw -Destination $OutputFolder -Force

            # Show & log $SuccessMsg message
            $SuccessMsg = "RAM capture from $ComputerName completed"
            Show-Message -Message "[INFO] $SuccessMsg"
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    function Write-RamSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\RAM\main.html' target='_blank'>Computer RAM</a></h3>" -Encoding UTF8

        $SectionName = "Computer Ram Capture"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $RamHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $RamHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $RamHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $RamHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ComputerRam


    Write-RamSectionToMain
}


Export-ModuleMember -Function Get-HtmlComputerRam
