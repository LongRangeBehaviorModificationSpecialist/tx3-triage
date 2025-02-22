$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlCopyRegistryHives {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName
    )

    $RegHivesHtmlMainFile = New-Item -Path "$OutputFolder\RegHives_main.html" -ItemType File -Force

    function Get-RegistryHives {

        $Name = "Copy_Registry_Hives"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: $ComputerName"
            Show-Message("[INFO] $BeginMessage") -Blue
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

            # Show & log $SoftwareMsg message
            try {
                $SoftwareMsg = "Copying the SOFTWARE Registry Hive"
                Show-Message("[INFO] $SoftwareMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareMsg")
                cmd /r reg export HKLM\Software $OutputFolder\software.reg
            }
            catch {
                $SoftwareWarnMsg = "An error occurred while copying SOFTWARE Hive: $($PSItem.Exception.Message)"
                Show-Message("ERROR] $SoftwareWarnMsg") -Red
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareWarnMsg") -WarningMessage
            }

            # Show & log $SamMsg message
            try {
                $SamMsg = "Copying the SAM Registry Hive"
                Show-Message("[INFO] $SamMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamMsg")
                cmd /r reg export HKLM\Sam $OutputFolder\sam.reg
            }
            catch {
                $SamWarnMsg = "An error occurred while copying SAM Hive: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $SamWarnMsg") -Red
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamWarnMsg") -WarningMessage
            }

            # Show & log $SysMsg message
            try {
                $SysMsg = "Copying the SYSTEM Registry Hive"
                Show-Message("[INFO] $SysMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SysMsg")
                cmd /r reg export HKLM\System $OutputFolder\system.reg
            }
            catch {
                $SystemWarnMsg = "An error occurred while copying SYSTEM Hive: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $SystemWarnMsg") -Red
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SystemWarnMsg") -WarningMessage
            }

            # Show & log $SecMsg message
            try {
                $SecMsg = "Copying the SECURITY Registry Hive"
                Show-Message("[INFO] $SecMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecMsg")
                cmd /r reg export HKLM\Security $OutputFolder\security.reg
            }
            catch {
                $SecurityWarnMsg = "An error occurred while copying SECURITY Hive: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $SecurityWarnMsg") -Red
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecurityWarnMsg") -WarningMessage
            }

            # Show & log $NtMsg message
            try {
                $NtMsg = "Copying the current user's NTUSER.DAT file"
                Show-Message("[INFO] $NtMsg") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NtMsg")
                cmd /r reg export HKCU $OutputFolder\current-ntuser.reg
            }
            catch {
                $NTUserWarnMsg = "An error occurred while copying the current user's NTUSER.DAT file: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $NTUserWarnMsg") -Red
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NTUserWarnMsg") -WarningMessage
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }


    function Write-RegistrySectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\RegHives\RegHives_main.html' target='_blank'>Exported Registry Hives</a></h3>" -Encoding UTF8

        $SectionName = "Exported Registry Hives"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $RegHivesHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $RegHivesHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "Reg") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $RegHivesHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $RegHivesHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-RegistryHives


    Write-RegistrySectionToMain
}


Export-ModuleMember -Function Invoke-HtmlCopyRegistryHives
