function Export-UserHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name


    #* 2-001
    function Get-WhoAmI {
        param ([string]$FilePath)
        $Name = "2-001 WhoAmI"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = whoami /ALL /FO LIST | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 2-002
    function Get-UserProfile {
        param ([string]$FilePath)
        $Name = "2-002 Win32_UserProfile"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 2-003
    function Get-UserInfo {
        param ([string]$FilePath)
        $Name = "2-003 Win32_UserAccount"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 2-004
    function Get-LocalUserData {
        param ([string]$FilePath)
        $Name = "2-004 Get-LocalUser"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-LocalUser
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 2-005
    function Get-LogonSession {
        param ([string]$FilePath)
        $Name = "2-005 Win32_LogonSession"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property *
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 2-006
    # TODO -- SKIPPED for now.  Will come back and figure out how to code this function

    # 2-006
    function Get-LastLogons {
        param ([string]$FilePath)
        $Name = "2-006 WinEvent Security (4624 or 4648)"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Cmd = Get-WinEvent -LogName 'Security' -FilterXPath "*[System[EventID=4624 or EventID=4648]]"

            $Data = @()
            foreach ($LogonEvent in $Cmd) {
                $Data += [PSCustomObject]@{
                    Time      = $LogonEvent.TimeCreated
                    LogonType = if ($LogonEvent.Id -eq 4648) { "Explicit" } else { "Interactive" }
                    Message   = $LogonEvent.Message
                }
            }
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-WhoAmI $FilePath
    Get-UserProfile $FilePath
    Get-UserInfo $FilePath
    Get-LocalUserData $FilePath
    Get-LogonSession $FilePath
    Get-LastLogons $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-UserHtmlPage
