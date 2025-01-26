function Get-RunningProcesses {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Name of the directory to store the extracted process files
        [string]$ProcessesFolderName = "00B_Processes",
        # Relative path to the ProcessCapture executable file
        [string]$ProcessCaptureExeFilePath = ".\bin\MagnetProcessCapture.exe"
    )

    $ProcessFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    # If the user wants to execute the ProcessCapture
    try {
        $ExecutionTime = Measure-Command {

            # Show & log $BeginMessage message
            $BeginMessage = "Starting Process Capture from: $ComputerName.  Please wait..."
            Show-Message("$BeginMessage") -Header
            Write-LogEntry("[$($ProcessFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the files list
            $ProcessesFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $ProcessesFolderName

            if (-not (Test-Path $ProcessesFolder)) {
                throw "[ERROR] The necessary folder does not exist -> ``$ProcessesFolder``"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created ``$($ProcessesFolder.Name)`` folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($ProcessFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Run MAGNETProcessCapture.exe from the \bin directory and save the output to the results folder.
            # The program will create its own directory to save the results with the following naming convention:
            # 'MagnetProcessCapture-YYYYMMDD-HHMMSS'
            Start-Process -NoNewWindow -FilePath $ProcessCaptureExeFilePath -ArgumentList "/saveall ``$ProcessesFolder``" -Wait

            # Show & log $SuccessMsg message
            $SuccessMsg = "Process Capture completed successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($ProcessFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $ProcessFuncName $ExecutionTime
        Write-LogFinishedMessage $ProcessFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($ProcessFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-RunningProcesses
