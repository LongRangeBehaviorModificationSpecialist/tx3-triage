$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-RegistryHives {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]
        $CaseFolderName,
        [Parameter(Mandatory)]
        [string]
        $ComputerName,
        # Name of the directory to store the copied registry hives
        [Parameter(Mandatory)]
        [string]
        $RegHiveFolder
    )

    try {
        $ExecutionTime = Measure-Command {
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: '$ComputerName'"
            Show-Message -Message $BeginMessage
            Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $RegHiveFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$RegHiveFolder'"
            }

            try {
                $SoftwareMessage = "Copying the SOFTWARE Registry Hive from $($ComputerName)"
                Show-Message -Message $SoftwareMessage
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareMessage"
                cmd /r reg export HKLM\Software $RegHiveFolder\software.reg
            }
            catch {
                $SoftwareErrorMessage = "An error occurred while copying SOFTWARE Hive: $($PSItem.Exception.Message)"
                Show-Message -Message $SoftwareErrorMessage -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareErrorMessage" -ErrorMessage
            }

            try {
                $SamMessage = "Copying the SAM Registry Hive from $($ComputerName)"
                Show-Message -Message $SamMessage
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamMessage"
                cmd /r reg export HKLM\Sam $RegHiveFolder\sam.reg
            }
            catch {
                $SamErrorMessage = "An error occurred while copying SAM Hive: $($PSItem.Exception.Message)"
                Show-Message -Message $SamErrorMessage -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamErrorMessage" -ErrorMessage
            }

            try {
                $SystemMessage = "Copying the SYSTEM Registry Hive from $($ComputerName)"
                Show-Message -Message $SystemMessage
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SystemMessage"
                cmd /r reg export HKLM\System $RegHiveFolder\system.reg
            }
            catch {
                $SystemErrorMessage = "An error occurred while copying SYSTEM Hive: $($PSItem.Exception.Message)"
                Show-Message -Message $SystemErrorMessage -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SystemErrorMessage" -ErrorMessage
            }

            try {
                $SecurityMessage = "Copying the SECURITY Registry Hive from $($ComputerName)"
                Show-Message -Message $SecurityMessage
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecurityMessage"
                cmd /r reg export HKLM\Security $RegHiveFolder\security.reg
            }
            catch {
                $SecurityErrorMessage = "An error occurred while copying SECURITY Hive: $($PSItem.Exception.Message)"
                Show-Message -Message $SecurityErrorMessage -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecurityErrorMessage" -ErrorMessage
            }

            try {
                $NtUserMessage = "Copying the current user's NTUSER.DAT file from $($ComputerName)"
                Show-Message -Message $NtUserMessage
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NtUserMessage"
                cmd /r reg export HKCU $RegHiveFolder\current-ntuser.reg
            }
            catch {
                $NTUserErrorMessage = "An error occurred while copying the current user's NTUSER.DAT file: $($PSItem.Exception.Message)"
                Show-Message -Message $NTUserErrorMessage -Red
                Write-LogEntry -Message "[$($PSCmdlet.MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NTUserErrorMessage" -ErrorMessage
            }
        }
        Show-FinishMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($PSCmdlet.MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-RegistryHives
