function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader


    #* 9-001
    function Search-BitlockerVolumes {
        param ([string]$FilePath)
        $Name = "9-001 BitLocker Data"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint
            if (-not $Data) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #9-002
    function Get-BitlockerRecoveryKeys {
        param ([string]$FilePath)
        $Name = "9-002 BitLocker Recovery Keys"
        Show-Message("Running '$Name' command") -Header -Gray
        try {
            $Info = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint
            if (-not $Info) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                $Data = @()
                # Iterate through each drive
                foreach ($Vol in $Info) {
                    $DriveLetter = $Vol.MountPoint
                    $ProtectionStatus = $Vol.ProtectionStatus
                    $LockStatus = $Vol.LockStatus
                    $RecoveryKey = $Vol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

                    # Write output based on the protection status of each drive
                    if ($ProtectionStatus -eq "On" -and $Null -ne $RecoveryKey) {
                        $Message = "     <pre> [*] Drive $DriveLetter Recovery Key -> $($RecoveryKey.RecoveryPassword) </pre>"
                        $Data += $Message
                        # Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                    elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                        $Message = "    <pre> [*] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted </pre>"
                        $Data += $Message
                        # Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                    else {
                        $Message = "    <pre> [*] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker </pre>"
                        $Data += $Message
                        # Add-Content -Path $FilePath -Value "<pre> $Message </pre>" -NoNewline
                    }
                }
            }
            Show-Message("[INFO] Saving output from '$Name'") -Blue
            Save-OutputToHtmlFile -FromString $Name $Data $FilePath
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            # Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-BitlockerVolumes $FilePath
    Get-BitlockerRecoveryKeys $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
