$UserPropertyArray = [ordered]@{

    "2-001_WhoAmI"                          = ("Who Am I",
                                              "whoami /ALL /FO LIST | Out-String",
                                              "String")
    "2-002_Win32_User_Profile"              = ("Win32_UserProfile",
                                              "Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property * | Out-String",
                                              "String")
    "2-003_Win32_User_Account"              = ("Win32_UserAccount",
                                              "Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property * | Out-String",
                                              "String")
    "2-004_Local_User_Data"                 = ("LocalUser",
                                              "Get-LocalUser | Out-String",
                                              "String")
    "2-005_Win32_LogonSession"              = ("Win32_LogonSession",
                                              "Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property * | Out-String",
                                              "String")
    # "2-006_Win_Event_Security_4624_or_4648" = ("Security Events (4624 or 4648)",
    #                                           "Get-WinEvent -LogName 'Security' -FilterXPath '*[System[EventID=4624 or EventID=4648]]' | Out-String",
    #                                           "String")
}


function Export-UserHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader
    Add-content -Path $FilePath -Value "<div class='itemTable'>`n"  # Add this to display the results in a flexbox

    $FunctionName = $MyInvocation.MyCommand.Name


    # 2-000
    function Get-UserData {

        param (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $UserPropertyArray.GetEnumerator()) {
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
                    Add-Content -Path $FilePath -Value "<a href='.\$FileName' target='_blank'>`n<button class='item_btn'>`n<div class='item_btn_text'>$($Title)</div>`n</button>`n</a>"
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
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-UserData -FilePath $FilePath -PagesFolder $PagesFolder


    Add-content -Path $FilePath -Value "</div>"  # To close the `itemTable` div

    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-UserHtmlPage
