function Get-EventLogs
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # Name of the directory to store the copied Event Logs
        [string]$EventLogFolderName = "00E_EventLogs",
        # Set variable for Event Logs folder on the examined machine
        [string]$EventLogDir = "$Env:HOMEDRIVE\Windows\System32\winevt\Logs",
        [int]$NumOfEventLogs = 5,

        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe"
    )

    $EventLogFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

    try
    {
        $ExecutionTime = Measure-Command
        {
            # Show & log $BeginMessage message
            $BeginMessage = "Beginning collection of Windows Event Logs from computer: $ComputerName"
            Show-Message("$BeginMessage") -Header
            Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the Event Logs
            $EventLogFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $EventLogFolderName -Force

            if (-not (Test-Path $EventLogFolder))
            {
                throw "[ERROR] The necessary folder does not exist -> ``$EventLogFolder``"
            }

            # Show & log $CreateDirMsg message
            $CreateDirMsg = "Created ``$($EventLogFolder.Name)`` folder in the case directory"
            Show-Message("$CreateDirMsg")
            Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

            # If no number is passed for the number of event logs to copy then copy all of the files
            if (-not $NumOfEventLogs)
            {
                Write-Information "No value passed for the `$NumOfEventLogs value."
                $Files = Get-ChildItem -Path $EventLogDir -Recurse -Force -File
            }
            else
            {
                # Set variables for the files in the prefetch folder of the examined device
                $Files = Get-ChildItem -Path $EventLogDir -Recurse -Force -File | Select-Object -First $NumOfEventLogs
            }

            if (-not (Test-Path $RawCopyPath))
            {
                $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
                Show-Message("$NoRawCopyWarnMsg") -Red
                Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg") -WarningMessage
            }

            foreach ($File in $Files)
            {
                try
                {
                    $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:"$EventLogDir\$File" /OutputPath:"$EventLogFolder" /OutputName:"$File" }

                    if ($LASTEXITCODE -ne 0)
                    {
                        $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        Show-Message("$NoProperExitMsg") -Red
                        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $NoProperExitMsg") -WarningMessage
                    }
                }
                catch
                {
                    $RawCopyOtherMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
                    Show-Message("$RawCopyOtherMsg") -Red
                    Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $RawCopyOtherMsg") -WarningMessage
                }

                # Show & log $CopyMsg messages of each file copied
                $CopyMsg = "Copied file -> ``$($File.Name)``"
                Show-Message($CopyMsg) -Green
                Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $CopyMsg")
            }
            # Show & log $SuccessMsg message
            $SuccessMsg = "Event Log files copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $SuccessMsg")
        }
        # Show & log finish messages
        Show-FinishMessage $EventLogFuncName $ExecutionTime
        Write-LogFinishedMessage $EventLogFuncName $ExecutionTime
    }
    catch
    {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($EventLogFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-EventLogs
