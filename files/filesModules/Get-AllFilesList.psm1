$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Invoke-GetAllFilesList {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string[]]
        $DriveList
    )

    $Name = "List_Attached_Files"
    $DriveArray = ($DriveList -split "\s*,\s*")  # Split on commas with optional surrounding spaces
    Show-Message -Message "[INFO] Running '$Name' command" -Header -DarkGray

    try {
        if (-not (Test-Path $OutputFolder)) {
            throw "Case folder '$OutputFolder' does not exist"
        }

        $ExecutionTime = Measure-Command {
            # Iterate over filtered drives
            foreach ($DriveName in $DriveArray) {
                $FileListingSaveFile = "$OutputFolder\$($RunDate)_$($ComputerName)_Files_$($DriveName).csv"

                $ScanMessage = "Scanning files on the $($DriveName):\ drive"
                Show-Message -Message "[INFO] $ScanMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $ScanMessage"

                # Scan and save file details
                Get-ChildItem -Path "$($DriveName):\" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
                    [PSCustomObject]@{
                        Directory         = $_.DirectoryName
                        BaseName          = $_.BaseName
                        Extension         = $_.Extension
                        SizeInKB          = [math]::Round($_.Length / 1KB, 2)
                        Mode              = $_.Mode
                        Attributes        = $_.Attributes
                        CreationTimeUTC   = $_.CreationTimeUtc
                        LastAccessTimeUTC = $_.LastAccessTimeUtc
                        LastWriteTimeUTC  = $_.LastWriteTimeUtc
                    }
                } | Export-Csv -Path $FileListingSaveFile -NoTypeInformation -Append -Encoding UTF8

                # Show & log $DoneMessage message
                $DoneMessage = "Completed scanning of $($DriveName):\ drive"
                Show-Message -Message "[INFO] $DoneMessage" -Blue
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $DoneMessage"

                # Show & log $FileTitle message
                $FileTitle = "Output saved to -> '$([System.IO.Path]::GetFileName($FileListingSaveFile))'`n"
                Show-Message -Message "[INFO] $FileTitle" -Green
                Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileTitle"
            }
        }
        # Show & log finish messages
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-GetAllFilesList
