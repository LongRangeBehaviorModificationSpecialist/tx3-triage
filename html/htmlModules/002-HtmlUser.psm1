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
                                              "Get-LocalUser | Format-List | Out-String",
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
        [string]$UserHtmlOutputFolder,
        [string]$HtmlReportFile
    )

    # 2-000
    function Get-UserData {

        foreach ($item in $UserPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$UserHtmlOutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command

                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    function Write-UserSectionToMain {

        $UserSectionHeader = "
        <h4 class='section_header'>User Information Section</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $UserSectionHeader

        $FileList = Get-ChildItem -Path $UserHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a href='results\002\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-UserData


    Write-UserSectionToMain
}


Export-ModuleMember -Function Export-UserHtmlPage
