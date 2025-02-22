$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


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
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
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
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
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
                    Write-NoDataFound $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output $Data $File
                    Show-OutputSavedToFile $File
                    Write-LogOutputSaved $File
                }
            }
            Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
            Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
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
