$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


function Invoke-HtmlListAllFiles {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile,
        # [string]
        # $ComputerName,
        # List of drives to be included or excluded depending on the switch value that is entered
        [string[]]
        $DriveList
    )

    $ListFilesHtmlMainFile = New-Item -Path "$OutputFolder\FilesList_main.html" -ItemType File -Force

    function Get-HtmlListAllFiles {

        $Name = "List_Attached_Files"
        $DriveArray = ($DriveList -split "\s*,\s*")  # Split on commas with optional surrounding spaces
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            if (-not (Test-Path $OutputFolder)) {
                throw "[ERROR] The necessary folder does not exist -> '$OutputFolder'"
            }

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
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
    }

    function Write-FilesListSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\FilesList\FilesList_main.html' target='_blank'>File List Results</a></h3>" -Encoding UTF8

        $SectionName = "Files List Results"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $ListFilesHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $ListFilesHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 9)) -eq "FilesList") {
                continue
            }
            else {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $ListFilesHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $ListFilesHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-HtmlListAllFiles


    Write-FilesListSectionToMain
}


Export-ModuleMember -Function Invoke-HtmlListAllFiles
