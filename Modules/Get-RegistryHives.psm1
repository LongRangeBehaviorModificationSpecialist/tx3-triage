$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Get-RegistryHives {

    [CmdletBinding()]

    param (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,
        # Name of the directory to store the copied registry hives
        [string]$RegHiveFolderName = "00D_Registry"
    )

    $RegistryFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        $ExecutionTime = Measure-Command {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: $ComputerName"
            Show-Message("$BeginMessage")
            Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the registry hives
            $RegHiveFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $RegHiveFolderName -Force

            if (-not (Test-Path $RegHiveFolder)) {
                throw "[ERROR] The necessary folder does not exist -> ``$RegHiveFolder``"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created ``$($RegHiveFolder.Name)`` folder in the case directory"
            Show-Message("$CreateDirMsg") -Green
            Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # Show & log $SoftwareMsg message
            try {
                $SoftwareMsg = "Copying the SOFTWARE Registry Hive"
                Show-Message("$SoftwareMsg")
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SoftwareMsg")
                cmd /r reg export HKLM\Software $RegHiveFolder\software.reg
            }
            catch {
                $SoftwareWarnMsg = "An error occurred while copying SOFTWARE Hive: $($PSItem.Exception.Message)"
                Show-Message("$SoftwareWarnMsg") -Red
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SoftwareWarnMsg") -WarningMessage
            }

            # Show & log $SamMsg message
            try {
                $SamMsg = "Copying the SAM Registry Hive"
                Show-Message("$SamMsg")
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SamMsg")
                cmd /r reg export HKLM\Sam $RegHiveFolder\sam.reg
            }
            catch {
                $SamWarnMsg = "An error occurred while copying SAM Hive: $($PSItem.Exception.Message)"
                Show-Message("$SamWarnMsg") -Red
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SamWarnMsg") -WarningMessage
            }

            # Show & log $SysMsg message
            try {
                $SysMsg = "Copying the SYSTEM Registry Hive"
                Show-Message("$SysMsg")
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SysMsg")
                cmd /r reg export HKLM\System $RegHiveFolder\system.reg
            }
            catch {
                $SystemWarnMsg = "An error occurred while copying SYSTEM Hive: $($PSItem.Exception.Message)"
                Show-Message("$SystemWarnMsg") -Red
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SystemWarnMsg") -WarningMessage
            }

            # Show & log $SecMsg message
            try {
                $SecMsg = "Copying the SECURITY Registry Hive"
                Show-Message("$SecMsg")
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SecMsg")
                cmd /r reg export HKLM\Security $RegHiveFolder\security.reg
            }
            catch {
                $SecurityWarnMsg = "An error occurred while copying SECURITY Hive: $($PSItem.Exception.Message)"
                Show-Message("$SecurityWarnMsg") -Red
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $SecurityWarnMsg") -WarningMessage
            }

            # Show & log $NtMsg message
            try {
                $NtMsg = "Copying the current user's NTUSER.DAT file"
                Show-Message("$NtMsg")
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $NtMsg")
                cmd /r reg export HKCU $RegHiveFolder\current-ntuser.reg
            }
            catch {
                $NTUserWarnMsg = "An error occurred while copying the current user's NTUSER.DAT file: $($PSItem.Exception.Message)"
                Show-Message("$NTUserWarnMsg") -Red
                Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $NTUserWarnMsg") -WarningMessage
            }
        }

        # Show & log finish messages
        Show-FinishMessage $RegistryFuncName $ExecutionTime
        Write-LogFinishedMessage $RegistryFuncName $ExecutionTime
    }

    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($RegistryFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-RegistryHives
