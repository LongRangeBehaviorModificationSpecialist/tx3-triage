$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


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

    $RamHtmlMainFile = New-Item -Path "$OutputFolder\RAM_main.html" -ItemType File -Force

    function Get-ComputerRam {

        $Name = "Get_Computer_RAM"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {

            # Show & log $BeginMessage message
            $BeginMessage = "Starting RAM capture from computer: $ComputerName. Please wait..."
            Show-Message("[INFO] $BeginMessage")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

            $RamOutputFileName = "$($RunDate)_$($ComputerName)_RAM_Capture.raw"

            # Start the RAM acquisition from the current machine
            Start-Process -NoNewWindow -FilePath $RamCaptureExeFilePath -ArgumentList "/accepteula /go "$OutputFolder\$RamOutputFileName" /silent" -Wait

            # Once the RAM has been acquired, move the file to the 'RAM' folder
            Move-Item -Path .\bin\*.raw -Destination $OutputFolder -Force

            # Show & log $SuccessMsg message
            $SuccessMsg = "RAM capture from $ComputerName completed"
            Show-Message("[INFO] $SuccessMsg")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Path) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Write-RamSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "<h3><a href='results\RAM\RAM_main.html' target='_blank'>Computer RAM</a></h4>"

        $SectionName = "Computer Ram Capture"

        $SectionHeader = "
        <h3 class='section_header'>$($SectionName)</h3>
        <div class='number_list'>"

        Add-Content -Path $RamHtmlMainFile -Value $HtmlHeader
        Add-Content -Path $RamHtmlMainFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "RAM") {
                continue
            }
            else {
                $FileNameEntry = "<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $RamHtmlMainFile -Value $FileNameEntry
            }
        }

        Add-Content -Path $RamHtmlMainFile -Value "</div>`n</body>`n</html>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ComputerRam


    Write-RamSectionToMain
}


Export-ModuleMember -Function Get-HtmlComputerRam
