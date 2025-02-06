$UserPropertyArray = [ordered]@{

    "2-001_WhoAmI"                          = ("whoami /ALL /FO LIST | Out-String", "String")
    "2-002_Win32_User_Profile"              = ("Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property *", "Pipe")
    "2-003_Win32_User_Account"              = ("Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property *", "Pipe")
    "2-004_Local_User_Data"                 = ("Get-LocalUser", "Pipe")
    "2-005_Win32_LogonSession"              = ("Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property *", "Pipe")
    "2-006_Win_Event_Security_4624_or_4648" = ("Get-WinEvent -LogName 'Security' -FilterXPath '*[System[EventID=4624 or EventID=4648]]'", "Pipe")
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
            $Command = $item.value[0]
            $Type = $item.value[1]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage $Name
                }
                else
                {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $ErrorMessage") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
            }
            Show-FinishedHtmlMessage $Name
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-UserData -FilePath $FilePath -PagesFolder $PagesFolder


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-UserHtmlPage
