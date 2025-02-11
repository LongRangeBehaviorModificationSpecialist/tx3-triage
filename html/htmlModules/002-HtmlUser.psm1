$UserPropertyArray = [ordered]@{

    "2-001_WhoAmI"                          = ("Who Am I", "whoami /ALL /FO LIST | Out-String", "String")
    "2-002_Win32_User_Profile"              = ("Win32_UserProfile", "Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property * | Out-String", "String")
    "2-003_Win32_User_Account"              = ("Win32_UserAccount", "Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property * | Out-String", "String")
    "2-004_Local_User_Data"                 = ("LocalUser", "Get-LocalUser | Out-String", "String")
    "2-005_Win32_LogonSession"              = ("Win32_LogonSession", "Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property * | Out-String", "String")
    "2-006_Win_Event_Security_4624_or_4648" = ("Security Events (4624 or 4648)", "Get-WinEvent -LogName 'Security' -FilterXPath '*[System[EventID=4624 or EventID=4648]]' | Out-String", "String")
}


function Export-UserHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    # 2-000
    function Get-UserData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $UserPropertyArray.GetEnumerator())
        {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else
                {
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-UserData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-UserHtmlPage
