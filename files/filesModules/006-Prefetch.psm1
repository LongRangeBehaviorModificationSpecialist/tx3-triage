$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Export-PrefetchFilesPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder
    )

    # 6-001
    function Get-DetailedPrefetchData {

        param (
            [string]
            $Num = "6-001",
            [string]
            $FileName = "PrefetchFilesDetailed.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
        try {

            # Run the command
            $ExecutionTime = Measure-Command {

                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header


                $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object -Property * | Sort-Object LastAccessTime

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

    # 6-002
    function Get-PrefetchFilesList {

        param (
            [string]
            $Num = "6-002",
            [string]
            $FileName = "PrefetchFilesList.txt"
        )

        $File = Join-Path -Path $OutputFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message $Header

                $Data = Get-ChildItem -Path "C:\Windows\Prefetch\*.pf" | Select-Object Name, LastAccessTime, CreationTime | Sort-Object LastAccessTime | Format-List

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
    Get-DetailedPrefetchData
    Get-PrefetchFilesList
}


Export-ModuleMember -Function Export-PrefetchFilesPage
