





function Export-SystemHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    # Import the hashtables from the data files
    $RegistryDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005-RegistryDataArray.psd1"
    $SystemDataArray = Import-PowerShellDataFile -Path "$PSScriptRoot\005-SystemDataArray.psd1"


    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='item_table'>"  # Add this to display the results in a flexbox


    $FunctionName = $MyInvocation.MyCommand.Name


    # 5-000A
    function Get-SelectRegistryValues {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $RegistryDataArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $RegKey = $item.value[1]
            $Command = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                Show-Message("[INFO] Searching for key [$RegKey]") -DarkGray
                if (-not (Test-Path -Path $RegKey)) {
                    Show-Message("[INFO] Registry Key [$RegKey] does not exist") -Yellow
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Registry Key [$RegKey] does not exist")
                    # Add-Content -Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_btn_text'>$($Title)&ensp;Registry Key [$RegKey] does not exist on the examined machine</div>`n</button>"
                }
                else {
                    $Data = Invoke-Expression -Command $Command | Out-String
                    if (-not $Data) {
                        $msg = "The registry key [$RegKey] exists, but contains no data"
                        Show-Message("[INFO] $msg") -Yellow
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $msg")
                        # Add-Content -Path $FilePath -Value "<button class='no_info_btn'>`n<div class='no_info_btn_text'>$($Title)&ensp;$($msg)</div>`n</button>`n"
                    }
                    else {
                        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                        Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                    }
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    # 5-000B
    function Get-SystemData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $SystemDataArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>`n"
                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-SelectRegistryValues -FilePath $FilePath -PagesFolder $PagesFolder
    Get-SystemData -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `item_table` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-SystemHtmlPage
