$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-BitLockerFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 9-001
    function Get-BitlockerRecoveryKeys {

        param (
            [string]
            $Num = "9-001",
            [string]
            $FileName = "BitlockerRecoveryKeys.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data1 = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint

                if ($Data1.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data1 -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
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
                            Save-OutputAppend -Data $Message -File $File
                            Show-Message -Message $Message -NoTime -Magenta
                        }
                        elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                            $Message = "    [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted"
                            Save-OutputAppend -Data $Message -File $File
                            Show-Message -Message $Message -NoTime -Magenta
                        }
                        else {
                            $Message = "    [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker"
                            Save-OutputAppend -Data $Message -File $File
                            Show-Message -Message $Message -NoTime -Magenta
                        }
                    }
                }
                Search-BitlockerVolumes
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-BitlockerRecoveryKeys
}


Export-ModuleMember -Function Export-BitLockerFilesPage
