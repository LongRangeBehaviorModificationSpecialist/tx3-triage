$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlListAllFiles {

    [CmdletBinding()]

    param (
        [string]
        $FilesListHtmlOutputFolder,
        [string]
        $HtmlReportFile,
        [string]
        $ComputerName,
        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]
        $DriveList
    )

    function Get-HtmlListAllFiles {

        $Name = "List_Attached_Files"
        $DriveArray = ($DriveList -split "\s*,\s*")  # Split on commas with optional surrounding spaces
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
        Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

        try {
            # Show & log BeginMessage message
            $BeginMessage = "Collecting list of all files from computer: $($ComputerName)"
            Show-Message("$BeginMessage") -DarkGray
            Write-HtmlLogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $BeginMessage")

            if (-not (Test-Path $FilesListHtmlOutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$FilesListHtmlOutputFolder'"
            }

            # Iterate over filtered drives
            foreach ($DriveName in $DriveArray) {
                $FileListingSaveFile = "$FilesListHtmlOutputFolder\$($RunDate)_$($ComputerName)_Files_$($DriveName).csv"

                $ScanMessage = "Scanning files on the $($DriveName):\ drive"
                Show-Message("$ScanMessage") -Blue
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
                Show-Message("$DoneMessage") -Blue
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $DoneMessage")

                # Show & log $FileTitle message
                $FileTitle = "Output saved to -> '$([System.IO.Path]::GetFileName($FileListingSaveFile))'`n"
                Show-Message("$FileTitle") -Green
                Write-LogEntry("[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $FileTitle")
            }
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $($PSItem.Exception.Message)
        }
    }

    function Write-FilesListSectionToMain {

        $SectionName = "Files List Results"

        $SectionHeader = "
        <h4 class='section_header' id='file_lists'>$($SectionName)</h4>
        <div class='number_list'>"

        Add-Content -Path $HtmlReportFile -Value $SectionHeader

        $FileList = Get-ChildItem -Path $FilesListHtmlOutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            $FileNameEntry = "<a class='file_link' href='results\FilesList\$File' target='_blank'>$File</a>"
            Add-Content -Path $HtmlReportFile -Value $FileNameEntry
        }

        Add-Content -Path $HtmlReportFile -Value "</div>"
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlListAllFiles


    Write-FilesListSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlListAllFiles
