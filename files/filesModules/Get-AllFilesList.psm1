$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


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
    Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

    try {
        if (-not (Test-Path $OutputFolder)) {
            throw "Case folder '$OutputFolder' does not exist"
        }

        $ExecutionTime = Measure-Command {
            # Iterate over filtered drives
            foreach ($DriveName in $DriveArray) {
                $FileListingSaveFile = "$OutputFolder\$($RunDate)_$($ComputerName)_Files_$($DriveName).csv"

                $ScanMessage = "Scanning files on the $($DriveName):\ drive"
                Show-Message("[INFO] $ScanMessage") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $ScanMessage")

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
                Show-Message("[INFO] $DoneMessage") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $DoneMessage")

                # Show & log $FileTitle message
                $FileTitle = "Output saved to -> '$([System.IO.Path]::GetFileName($FileListingSaveFile))'`n"
                Show-Message("[INFO] $FileTitle") -Green
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileTitle")
            }
        }
        # Show & log finish messages
        Show-FinishMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
        Write-LogFinishedMessage $($MyInvocation.MyCommand.Name) $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Invoke-GetAllFilesList
