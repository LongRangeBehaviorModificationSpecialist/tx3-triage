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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Write-RamSectionToMain {

        $SectionName = "Computer Ram Capture"

        $SectionHeader = "
        <h4 class='section_header' id='ram_capture'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a class='file_link' href='results\RAM\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ComputerRam


    Write-RamSectionToMain
}


Export-ModuleMember -Function Get-HtmlComputerRam
