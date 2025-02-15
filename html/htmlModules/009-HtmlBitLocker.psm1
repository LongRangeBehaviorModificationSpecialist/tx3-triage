function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param (
        [string]$BitLockerHtmlOutputFolder,
        [string]$HtmlReportFile
    )

    # 9-001
    function Search-BitlockerVolumes {

        $Name = "9-001_BitLockerVolumes"
        $Title = "BitLocker Volumes"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$BitLockerHtmlOutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String

            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

                Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString

                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    # 9-002
    function Get-BitlockerRecoveryKeys {

        $Name = "9-002_BitLockerRecoveryKeys"
        $Title = "BitLocker Recovery Keys"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$BitLockerHtmlOutputFolder\$FileName" -ItemType File -Force

        try {
            $Info = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint

            if (-not $Info) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

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
            Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    function Write-BitLockerSectionToMain {

        $BitLockerSectionHeader = "
        <h4 class='section_header'>Firewall Information Section</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $BitLockerSectionHeader

        $FileList = Get-ChildItem -Path $BitLockerHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\009\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-BitlockerVolumes
    Get-BitlockerRecoveryKeys


    Write-BitLockerSectionToMain
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
