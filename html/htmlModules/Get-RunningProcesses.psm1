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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        finally {
            # Show & log $SuccessMsg message
            $SuccessMsg = "Process Capture from $ComputerName completed successfully"
            Show-Message("[INFO] $SuccessMsg")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg")
        }
    }


    function Write-ProcessSectionToMain {

        $SectionName = "Process Capture"

        $SectionHeader = "
        <h4 class='section_header' id='process_capture'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder -Recurse | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a class='file_link' href='results\Processes\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-RunningProcesses


    Write-ProcessSectionToMain
}


Export-ModuleMember -Function Get-HtmlRunningProcesses
