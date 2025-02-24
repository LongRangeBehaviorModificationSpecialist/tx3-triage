$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-ComputerRam {

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
        $RamFolder,
        # Relative path to the RAM Capture executable file
        [string]
        $RamCaptureExeFilePath = ".\bin\MRCv120.exe"
    )

    try {
        $ExecutionTime = Measure-Command {
            $BeginMessage = "Starting RAM capture from computer: $ComputerName. Please wait..."
            Show-Message -Message "$BeginMessage"
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $RamFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$RamFolder'"
            }

            # Start the RAM acquisition from the current machine
            Start-Process -NoNewWindow -FilePath $RamCaptureExeFilePath -ArgumentList "/accepteula /go /silent" -Wait

            # Once the RAM has been acquired, move the file to the 'RAM' folder
            Move-Item -Path .\bin\*.raw -Destination $RamFolder -Force

            $SuccessMsg = "RAM capture completed successfully from computer: $ComputerName"
            Show-Message -Message "$SuccessMsg"
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SuccessMsg"
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-ComputerRam
