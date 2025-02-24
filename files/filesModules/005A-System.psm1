#? =+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
#? DISABLED DURING TESTING
#? WILL RE-ENABLE WHEN DONE
#?
#? Should test each function individually
#? =+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


# 5-047
function Get-RecentDllFiles {

    param (
        [string]
        $Num = "5-047",
        [string]
        $FileName = "RecentDllFiles.csv",
        [string]
        $Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            $Data = Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq ".dll" } | Select-Object Name, Directory, FullName, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                # Save the data to CSV
                Save-OutputAsCsv -Data $Data -File $File
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 5-048
function Get-RecentLinkFiles {

    param (
        [string]
        $Num = "5-048",
        [string]
        $FileName = "RecentLinkFiles.csv",
        [int]
        $DaysBack = 90
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            # Get Recent .lnk files
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-CimInstance -ClassName Win32_ShortcutFile | Where-Object {
                $_.LastModified -gt $CutoffDate
            } | Select-Object FileName, Status, Caption, Compressed, Encrypted, FileSize, Hidden,
                @{ N = "CreationDate"; E = { $_.CreationDate } },
                @{ N = "LastAccessed"; E = { $_.LastAccessed } },
                @{ N = "LastModified"; E = { $_.LastModified } },
                Target | Sort-Object LastModified -Descending

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                Save-OutputAsCsv -Data $Data -File $File
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 5-049
function Get-CompressedFiles {

    param (
        [string]
        $Num = "5-049",
        [string]
        $FileName = "CompressedFiles.csv",
        [string]
        $Path = "C:\",
        # Default file types to search
        [string[]]
        $FileTypes = @("*.exe", "*.dll", "*.zip")
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            # Get compressed files
            $Data = Get-ChildItem -Path $Path -Include $FileTypes -Recurse -Force | Where-Object { $_.Attributes -band [IO.FileAttributes]::Compressed }

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                $Data | Select-Object FullName, Name, Attributes, Length, @{ N = "LastModified"; E = { $_.LastWriteTimeUtc } } | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 5-050
function Get-EncryptedFiles {

    param (
        [string]
        $Num = "5-050",
        [string]
        $FileName = "EncryptedFiles.csv",
        [string]
        $Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | Where-Object { $_.Attributes -band [IO.FileAttributes]::Encrypted }

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                $Data | Select-Object FullName, Name, Attributes, Length, @{ N = "LastModified"; E = { $_.LastWriteTimeUtc } } | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 5-051
function Get-ExeTimeline {

    param (
        [string]$Num = "5-051",
        [string]$FileName = "TimelineOfExecutables.csv",
        [string]$Path = "C:\",
        [int]$DaysBack = 90
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | Where-Object { -Not $_.PSIsContainer -and $_.LastWriteTime -gt $CutoffDate } | Select-Object FullName, LastWriteTime, @{ N = "Owner"; E = { ($_ | Get-ACL).Owner } }

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                Save-OutputAsCsv -Data $Data -File $File
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 5-052
function Get-DownloadedExecutables {

    param (
        [string]$Num = "5-052",
        [string]$FileName = "DownloadedExecutables.csv",
        [string]$Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | ForEach-Object { Get-Item $_.FullName -Stream * } | Where-Object { $_.Stream -Match "Zone.Identifier" } | Select-Object Filename, Stream, @{ N = "LastWriteTime"; E = { (Get-Item $_.FileName).LastWriteTime } }

            if (-not $Data) {
                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
            }
            else {
                # Save output to CSV file
                Save-OutputAsCsv -Data $Data -File $File
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-RecentDllFiles, Get-RecentLinkFiles, Get-CompressedFiles, Get-EncryptedFiles, Get-ExeTimeline, Get-DownloadedExecutables
