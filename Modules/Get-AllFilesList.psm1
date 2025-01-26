function Get-AllFilesList {

    [CmdletBinding()]

    param(
        [Parameter(Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$CaseFolderName,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]$DriveList,
        # Create folder to store the compiled file lists
        [string]$FilesListFolderName = "00I_FileLists"
    )

    $AllDrivesFuncName = $MyInvocation.MyCommand.Name

    try {
        if (-not (Test-Path $CaseFolderName)) {
            throw "Case folder ``$CaseFolderName`` does not exist"
        }

        $ExecutionTime = Measure-Command {
            # Show & log BeginMessage message
            $BeginMessage = "Collecting list of all files from computer: $($ComputerName)"
            Show-Message("$BeginMessage") -Header
            Write-LogEntry("[$($AllDrivesFuncName), Ln: $(Get-LineNum)] $BeginMessage")

            # Make new directory to store the scan results
            $FilesListsFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $FilesListFolderName

            if (-not (Test-Path $FilesListsFolder)) {
                throw "[ERROR] The necessary folder does not exist -> ``$FilesListsFolder``"
            }

            # Iterate over filtered drives
            foreach ($DriveName in $DriveList) {
                $FileListingSaveFile = "$FilesListsFolder\$RunDate`_$ComputerName`_Files_$DriveName.csv"

                $ScanMessage = "Scanning files on the $($DriveName):\ drive"
                Show-Message("$ScanMessage") -Magenta
                Write-LogEntry("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $ScanMessage")

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
                Show-Message("$DoneMessage") -Green
                Write-LogEntry("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $DoneMessage")

                # Show & log $FileTitle message
                $FileTitle = "Output saved to -> ``$([System.IO.Path]::GetFileName($FileListingSaveFile))```n"
                Show-Message("$FileTitle") -Green
                Write-LogEntry("[$AllDrivesFuncName, Ln: $(Get-LineNum)] $FileTitle")
            }
        }
        # Show & log finish messages
        Show-FinishMessage $AllDrivesFuncName $ExecutionTime
        Write-LogFinishedMessage $AllDrivesFuncName $ExecutionTime
    }
    catch {
        # Error handling
        $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
        Show-Message("$ErrorMessage") -Red
        Write-LogEntry("[$($AllDrivesFuncName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-AllFilesList
