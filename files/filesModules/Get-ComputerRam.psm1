$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-ComputerRam {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]

        [string]$ComputerName,
        # Name of the directory to store the extracted RAM image
        [string]$RamFolderName = "00C_RAM",
        # Relative path to the RAM Capture executable file
        [string]$RamCaptureExeFilePath = ".\bin\MRCv120.exe"
    )

    $RamFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Starting RAM capture from computer: $ComputerName. Please wait..."
            Show-Message("$BeginMessage")
            Write-LogEntry("[$($RamFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Create a folder called "RAM" to store the captured RAM file
            $RamFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $RamFolderName -Force

            if (-not (Test-Path $RamFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$RamFolder'"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created '$($RamFolder.Name)' folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($RamFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Start the RAM acquisition from the current machine
            Start-Process -NoNewWindow -FilePath $RamCaptureExeFilePath -ArgumentList "/accepteula /go /silent" -Wait

            # Once the RAM has been acquired, move the file to the 'RAM' folder
            Move-Item -Path .\bin\*.raw -Destination $RamFolder -Force

            # Show & log $SuccessMsg message
            $SuccessMsg = "RAM capture completed successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($RamFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }

        # Show & log finish messages
        Show-FinishMessage $RamFuncName $ExecutionTime
        Write-LogFinishedMessage $RamFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($RamFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-ComputerRam
