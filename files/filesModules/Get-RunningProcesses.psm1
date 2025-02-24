$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-RunningProcesses {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]
        $CaseFolderName,
        [Parameter(Mandatory)]
        [string]
        $ComputerName,
        [Parameter(Mandatory)]
        [string]
        $ProcessesFolder,
        # Relative path to the ProcessCapture executable file
        [string]
        $ProcessCaptureExeFilePath = ".\bin\MagnetProcessCapture.exe"
    )

    # If the user wants to execute the ProcessCapture
    try {
        $ExecutionTime = Measure-Command {
            $BeginMessage = "Starting Process Capture from: $ComputerName.  Please wait..."
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $ProcessesFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$ProcessesFolder'"
            }

            # Run MAGNETProcessCapture.exe from the \bin directory and save the output to the results folder.
            # The program will create its own directory to save the results with the following naming convention:
            # 'MagnetProcessCapture-YYYYMMDD-HHMMSS'
            Start-Process -NoNewWindow -FilePath $ProcessCaptureExeFilePath -ArgumentList "/saveall '$ProcessesFolder'" -Wait

            # Show & log $SuccessMsg message
            $SuccessMsg = "Process Capture completed successfully from computer: $ComputerName"
            Show-Messag -Message $SuccessMsg
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-RunningProcesses
