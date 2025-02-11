function Export-BitLockerHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 9-001
    function Search-BitlockerVolumes {

        param
        (
            [string]$FilePath
        )

        $Name = "9-001BitLockerVolumes"
        $Title = "BitLocker Volumes"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Data = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint | Out-String
            if (-not $Data)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                Save-OutputToSingleHtmlFile -FromString -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title

                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
            }
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    # 9-002
    function Get-BitlockerRecoveryKeys {

        param
        (
            [string]$FilePath
        )

        $Name = "9-002_BitLockerRecoveryKeys"
        $Title = "BitLocker Recovery Keys"
        $FileName = "$Name.html"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

        try
        {
            $Info = Get-BitLockerVolume | Select-Object -Property * | Sort-Object MountPoint
            if (-not $Info)
            {
                Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
            }
            else
            {
                Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start
                $Data = @()
                # Iterate through each drive
                foreach ($Vol in $Info)
                {
                    $DriveLetter = $Vol.MountPoint
                    $ProtectionStatus = $Vol.ProtectionStatus
                    $LockStatus = $Vol.LockStatus
                    $RecoveryKey = $Vol.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }

                    # Write output based on the protection status of each drive
                    if ($ProtectionStatus -eq "On" -and $Null -ne $RecoveryKey)
                    {
                        $Message = "[-] Drive $DriveLetter Recovery Key -> $($RecoveryKey.RecoveryPassword)`n`n"
                        $Data += $Message
                    }
                    elseif ($ProtectionStatus -eq "Unknown" -and $LockStatus -eq "Locked")
                    {
                        $Message = "[-] Drive $DriveLetter This drive is mounted on the system, but IT IS NOT decrypted`n`n"
                        $Data += $Message
                    }
                    else
                    {
                        $Message = "[-] Drive $DriveLetter Does not have a recovery key or is not protected by BitLocker`n`n"
                        $Data += $Message
                    }
                }
            }

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Save-OutputToSingleHtmlFile -FromString -Name $Name -Data $Data -OutputHtmlFilePath $OutputHtmlFilePath -Title $Title

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Search-BitlockerVolumes -FilePath $FilePath -PagesFolder $PagesFolder
    Get-BitlockerRecoveryKeys -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-BitLockerHtmlPage
