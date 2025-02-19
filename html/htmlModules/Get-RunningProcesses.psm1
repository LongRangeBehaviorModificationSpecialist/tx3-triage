$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-HtmlRunningProcesses {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        # Relative path to the ProcessCapture executable file
        [string]
        $ProcessCaptureExeFilePath = ".\bin\MagnetProcessCapture.exe"
    )

    $ProcessHtmlMainFile = New-Item -Path "$OutputFolder\Processes_main.html" -ItemType File -Force

    function Get-RunningProcesses {

        $Name = "Capture_Running_Processes"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting Process Capture from: $ComputerName.  Please wait..."
            Show-Message("[INFO] $BeginMessage")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$ProcessesFolder'"
            }

            # Run MAGNETProcessCapture.exe from the \bin directory and save the output to the results folder.
            # The program will create its own directory to save the results with the following naming convention:
            # 'MagnetProcessCapture-YYYYMMDD-HHMMSS'
            Start-Process -NoNewWindow -FilePath $ProcessCaptureExeFilePath -ArgumentList "/saveall $OutputFolder" -Wait
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Path) $($MyInvocation.MyCommand) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Show & log $SuccessMsg message
            $SuccessMsg = "Process Capture from $ComputerName completed successfully"
            Show-Message("[INFO] $SuccessMsg")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")
        }
    }


    function Write-ProcessSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "<h3><a href='results\Processes\Processes_main.html' target='_blank'>Captured Processes</a></h4>"

        $SectionName = "Captured Processes"

        $SectionHeader = "
        <h3 class='section_header'>$($SectionName)</h3>
        <div class='number_list'>"

        Add-Content -Path $ProcessHtmlMainFile -Value $HtmlHeader
        Add-Content -Path $ProcessHtmlMainFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 6)) -eq "NTUser") {
                continue
            }
            else {
                $FileNameEntry = "<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $ProcessHtmlMainFile -Value $FileNameEntry
            }
        }

        Add-Content -Path $ProcessHtmlMainFile -Value "</div>`n</body>`n</html>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-RunningProcesses


    Write-ProcessSectionToMain
}


Export-ModuleMember -Function Get-HtmlRunningProcesses
