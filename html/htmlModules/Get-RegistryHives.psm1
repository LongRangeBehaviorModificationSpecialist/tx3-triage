$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


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
        Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

        try {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Registry Hives from computer: '$ComputerName'"
            Show-Message -Message "[INFO] $BeginMessage" -Blue
            Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage"

            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

            try {
                $SoftwareMessage = "Copying the SOFTWARE Registry Hive"
                Show-Message -Message "[INFO] $SoftwareMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareMessage"
                cmd /r reg export HKLM\Software $OutputFolder\software.reg
            }
            catch {
                $SoftwareErrorMessage = "An error occurred while copying SOFTWARE Hive: $($PSItem.Exception.Message)"
                Show-Message -Message "ERROR] $SoftwareErrorMessage" -Red
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SoftwareErrorMessage" -ErrorMessage
            }

            try {
                $SamMessage = "Copying the SAM Registry Hive"
                Show-Message -Message "[INFO] $SamMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamMessage"
                cmd /r reg export HKLM\Sam $OutputFolder\sam.reg
            }
            catch {
                $SamErrorMessage = "An error occurred while copying SAM Hive: $($PSItem.Exception.Message)"
                Show-Message -Message "[ERROR] $SamErrorMessage" -Red
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SamErrorMessage" -ErrorMessage
            }

            try {
                $SystemMessage = "Copying the SYSTEM Registry Hive"
                Show-Message -Message "[INFO] $SystemMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SystemMessage"
                cmd /r reg export HKLM\System $OutputFolder\system.reg
            }
            catch {
                $SystemErrorMessage = "An error occurred while copying SYSTEM Hive: $($PSItem.Exception.Message)"
                Show-Message -Message "[ERROR] $SystemErrorMessage" -Red
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SystemErrorMessage" -ErrorMessage
            }

            # Show & log $SecMsg message
            try {
                $SecurityMessage = "Copying the SECURITY Registry Hive"
                Show-Message -Message "[INFO] $SecurityMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecurityMessage"
                cmd /r reg export HKLM\Security $OutputFolder\security.reg
            }
            catch {
                $SecurityErrorMessage = "An error occurred while copying SECURITY Hive: $($PSItem.Exception.Message)"
                Show-Message -Message "[ERROR] $SecurityErrorMessage" -Red
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $SecurityErrorMessage" -ErrorMessage
            }

            # Show & log $NtMsg message
            try {
                $NtUserMessage = "Copying the current user's NTUSER.DAT file"
                Show-Message -Message "[INFO] $NtUserMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NtUserMessage"
                cmd /r reg export HKCU $OutputFolder\current-ntuser.reg
            }
            catch {
                $NTUserErrorMessage = "An error occurred while copying the current user's NTUSER.DAT file: $($PSItem.Exception.Message)"
                Show-Message -Message "[ERROR] $NTUserErrorMessage" -Red
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $NTUserErrorMessage" -ErrorMessage
            }
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
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
