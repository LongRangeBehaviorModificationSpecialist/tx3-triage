function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    $BitLockerHtmlMainFile = New-Item -Path "$OutputFolder\main.html" -ItemType File -Force

    # 9-001
    function Search-BitlockerVolumes {

        $Name = "9-001_BitLockerVolumes"
        $Title = "BitLocker Volumes"
        $FileName = "$Name.html"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String

            if (-not $Data) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

                Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString

                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # 9-002
    function Get-BitlockerRecoveryKeys {

        $Name = "9-002_BitLockerRecoveryKeys"
        $Title = "BitLocker Recovery Keys"
        $FileName = "$Name.html"
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

        try {
            $Info = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint

            if (-not $Info) {
                Invoke-NoDataFoundMessage -Name $Name
            }
            else {
                Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -Start

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
            Save-OutputToSingleHtmlFile -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title -FromString
            Invoke-SaveOutputMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    function Write-BitLockerSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\009\main.html' target='_blank'>BitLocker Data</a></h3>" -Encoding UTF8

        $SectionName = "BitLocker Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $BitLockerHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $BitLockerHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 4)) -eq "main") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $BitLockerHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $BitLockerHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-BitlockerVolumes
    Get-BitlockerRecoveryKeys


    Write-BitLockerSectionToMain
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
