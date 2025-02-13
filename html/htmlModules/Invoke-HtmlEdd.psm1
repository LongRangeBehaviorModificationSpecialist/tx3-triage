$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlEncryptedDiskDetector {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$FilesFolder,
        [string]$PagesFolder,
        [string]$EddExeFilePath = ".\bin\EDDv310.exe"
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name

    $Name = "Encrypted_Disk_Detector"
    $Title = "Encrypted Disk Detector"
    $FileName = "$Name.html"
    Show-Message("Running ``$Name``") -Header -DarkGray
    $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

    try {
        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

        # Name the file to save the results of the scan to
        $EddTxtFile = New-Item -Path "$FilesFolder\Encrypted_Disk_Detector.txt" -ItemType File -Force

        # Start the encrypted disk detector executable
        Start-Process -NoNewWindow -FilePath $EddExeFilePath -ArgumentList "/batch" -Wait -RedirectStandardOutput $EddTxtFile

        # Show & log $SuccessMsg message
        $SuccessMsg = "Encrypted Disk Detector completed successfully on computer: $ComputerName"
        Show-Message("[INFO] $SuccessMsg") -Green
        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $SuccessMsg")

        Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"

        # Read the contents of the EDD text file and show the results on the screen
        $Data = Get-Content -Path $EddTxtFile -Force -Raw | Out-String
        Save-OutputToSingleHtmlFile -FromString $Name $(Get-Content -Path $EddTxtFile -Force -Raw) $OutputHtmlFilePath $Title
        Write-Host $Data

        Show-Message("`nEncrypted Disk Detector has finished - Review the results before proceeding") -NoTime -Yellow
        Write-Host ""
        Read-Host -Prompt "Press [ENTER] to continue data collection -> "

        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish

        Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

        # Add the closing text to the .html file
        Add-Content -Path $FilePath -Value $HtmlFooter
    }
    catch {
        Invoke-ShowErrorMessage $($FunctionName) $(Get-LineNum) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-HtmlEncryptedDiskDetector
