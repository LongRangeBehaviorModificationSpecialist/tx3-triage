#! ======================================
#!
#! (8) GET WINDOWS FIREWALL INFORMATION
#!
#! ======================================


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# 8-001
function Get-FirewallRules {
    [CmdletBinding()]
    param (
        [string]$Num = "8-001",
        [string]$FileName = "FirewallRules.txt"
    )

    $File = Join-Path -Path $FirewallFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-NetFirewallRule

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("$ErrorMessage") -ErrorMessage
    }
}

# 8-002
function Get-AdvFirewallRules {
    [CmdletBinding()]
    param (
        [string]$Num = "8-002",
        [string]$FileName = "AdvFirewallRules.txt"
    )

    $File = Join-Path -Path $FirewallFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = netsh advfirewall firewall show rule name=all verbose

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("$ErrorMessage") -ErrorMessage
    }
}

# 8-003
function Get-DefenderExclusions {
    [CmdletBinding()]
    param (
        [string]$Num = "8-003",
        [string]$FileName = "DefenderPreferences.txt"
    )

    $File = Join-Path -Path $FirewallFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-MpPreference

            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                Save-Output $Data $File
                Show-OutputSavedToFile $File
                Write-LogOutputSaved $File
            }
        }
        # Finish logging
        Show-FinishMessage $FunctionName $ExecutionTime
        Write-LogFinishedMessage $FunctionName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("$ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-FirewallRules, Get-AdvFirewallRules, Get-DefenderExclusions
