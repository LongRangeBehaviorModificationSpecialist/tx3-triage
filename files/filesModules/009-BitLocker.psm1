$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Export-BitLockerFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 9-001
    function Get-BitlockerRecoveryKeys {

        [CmdletBinding()]

        param (
            [string]
            $Num = "9-001",
            [string]
            $FileName = "BitlockerRecoveryKeys.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            # Run the command
            $ExecutionTime = Measure-Command {
                Show-Message("$Header")
                Write-LogEntry("[$($MyInvocation.MyCommand.ModuleName), Ln: $(Get-LineNum)] $Header")
                $Data1 = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint
                if ($Data1.Count -eq 0) {
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data1 $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }

                function Search-BitlockerVolumes {
                    # Get all BitLocker-protected drives on the computer
                    $BitlockerVolumes = $Data1

                    # Iterate through each drive
                    foreach ($Vol in $BitlockerVolumes) {
                        $DriveLetter = $Vol.MountPoint
                        $ProtectionStatus = $Vol.ProtectionStatus
                        $LockStatus = $Vol.LockStatus
                        $RecoveryKey = $Vol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

                        # Write output based on the protection status of each drive
                        if ($ProtectionStatus -eq "On" -and $Null -ne $RecoveryKey) {
                            $Message = "    [*] Drive $DriveLetter Recovery Key -> $($RecoveryKey.RecoveryPassword)"
                            Save-OutputAppend $Message $File
                            Show-Message("$Message") -NoTime -Magenta
                        }
                        elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                            $Message = "    [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted"
                            Save-OutputAppend $Message $File
                            Show-Message("$Message") -NoTime -Magenta
                        }
                        else {
                            $Message = "    [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker"
                            Save-OutputAppend $Message $File
                            Show-Message("$Message") -NoTime -Magenta
                        }
                    }
                }
                Search-BitlockerVolumes
            }
            # Finish logging
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-BitlockerRecoveryKeys
}


Export-ModuleMember -Function Export-BitLockerFilesPage
