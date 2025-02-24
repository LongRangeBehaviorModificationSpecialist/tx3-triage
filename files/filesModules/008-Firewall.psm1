$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Export-FirewallFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 8-001
    function Get-FirewallRules {

        param (
            [string]
            $Num = "8-001",
            [string]
            $FileName = "FirewallRules.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-NetFirewallRule

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 8-002
    function Get-AdvFirewallRules {

        param (
            [string]
            $Num = "8-002",
            [string]
            $FileName = "AdvFirewallRules.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = netsh advfirewall firewall show rule name=all verbose

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }

    # 8-003
    function Get-DefenderExclusions {

        param (
            [string]
            $Num = "8-003",
            [string]
            $FileName = "DefenderPreferences.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-MpPreference

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
                    Show-OutputSavedToFile -File $File
                    Write-LogOutputSaved -File $File
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-FirewallRules
    Get-AdvFirewallRules
    Get-DefenderExclusions
}


Export-ModuleMember -Function Export-FirewallFilesPage
