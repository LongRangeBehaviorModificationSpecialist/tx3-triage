function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader


    #* 9-001
    function Get-BitlockerRecoveryKeys {
        param ([string]$FilePath)
        $Name = "9-001 BitLocker Data"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
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
                        Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                    elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                        $Message = "    [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted"
                        Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                    else {
                        $Message = "    [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker"
                        Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                }
            }
            Search-BitlockerVolumes
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Add-Content -Path $FilePath -Value "</p></div>"

        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-BitlockerRecoveryKeys $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
