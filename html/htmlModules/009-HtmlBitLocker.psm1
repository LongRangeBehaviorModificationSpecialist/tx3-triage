function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='item_table'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    # 9-001
    function Search-BitlockerVolumes {

        param (
            [string]$FilePath
        )

        $Name = "9-001_BitLockerVolumes"
        $Title = "BitLocker Volumes"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String
            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    # 9-002
    function Get-BitlockerRecoveryKeys {

        param (
            [string]$FilePath
        )

        $Name = "9-002_BitLockerRecoveryKeys"
        $Title = "BitLocker Recovery Keys"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try {
            $Info = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint

            if (-not $Info) {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else {
                Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                $Data = @()
                # Iterate through each drive
                foreach ($Vol in $Info) {
                    $DriveLetter = $Vol.MountPoint
                    $ProtectionStatus = $Vol.ProtectionStatus
                    $LockStatus = $Vol.LockStatus
                    $RecoveryKey = $Vol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

                    # Write output based on the protection status of each drive
                    if ($ProtectionStatus -eq "On" -and $Null -ne $RecoveryKey) {
                        $Message = "[-] Drive $DriveLetter Recovery Key -> $($RecoveryKey.RecoveryPassword)`n`n"
                        $Data += $Message
                    }
                    elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked") {
                        $Message = "[-] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted`n`n"
                        $Data += $Message
                    }
                    else {
                        $Message = "[-] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker`n`n"
                        $Data += $Message
                    }
                }
            }

            Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
            Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-BitlockerVolumes -FilePath $FilePath -PagesFolder $PagesFolder
    Get-BitlockerRecoveryKeys -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
