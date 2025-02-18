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

    function Get-RegistryHives {

        $Name = "Copy_Registry_Hives"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: $ComputerName"
            Show-Message("[INFO] $BeginMessage")
            Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

            # Show & log $SoftwareMsg message
            try {
                $SoftwareMsg = "Copying the SOFTWARE Registry Hive"
                Show-Message("[INFO] $SoftwareMsg")
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
                Show-Message("[INFO] $SamMsg")
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
                Show-Message("[INFO] $SysMsg")
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
                Show-Message("[INFO] $SecMsg")
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
                Show-Message("[INFO] $NtMsg")
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
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }


    function Write-RegistrySectionToMain {

        $SectionName = "Exported Registry Hives"

        $SectionHeader = "
        <h4 class='section_header' id='hives'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a class='file_link' href='results\RegistryHives\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-RegistryHives


    Write-RegistrySectionToMain
}


Export-ModuleMember -Function Invoke-HtmlCopyRegistryHives
