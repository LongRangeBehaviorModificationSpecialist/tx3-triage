#! ======================================
#!
#! (9) GET BITLOCKER RECOVERY KEYS
#!
#! ======================================


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# 9-001
function Get-BitlockerRecoveryKeys {
    [CmdletBinding()]
    param (
        [string]$Num = "9-001",
        [string]$FilePath = "BitlockerRecoveryKeys.txt"
    )

    $File = Join-Path -Path $BitlockerFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data1 = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint

            if ($Data1.Count -eq 0) {
                Write-NoDataFound $FunctionName
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
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("$ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-BitlockerRecoveryKeys
