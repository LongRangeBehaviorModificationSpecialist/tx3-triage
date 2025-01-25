#! ======================================
#!
#! (6) GET PREFETCH INFORMATION
#!
#! ======================================


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


# 6-001
function Get-PrefetchFilesList {
    [CmdletBinding()]
    param (
        [string]$Num = "6-001",
        [string]$FileName = "PrefetchFilesList.txt"
    )

    $File = Join-Path -Path $PrefetchFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object Name, LastAccessTime, CreationTime | Sort-Object LastAccessTime | Format-List

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

# 6-002
function Get-DetailedPrefetchData {
    [CmdletBinding()]
    param (
        [string]$Num = "6-002",
        [string]$FileName = "PrefetchFilesDetailed.txt"
    )

    $File = Join-Path -Path $PrefetchFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running `"$FunctionName`" function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header") -Header
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime

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


Export-ModuleMember -Function Get-PrefetchFilesList, Get-DetailedPrefetchData
