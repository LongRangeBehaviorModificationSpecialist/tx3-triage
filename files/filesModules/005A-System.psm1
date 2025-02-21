#? =+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
#? DISABLED DURING TESTING
#? WILL RE-ENABLE WHEN DONE
#?
#? Should test each function individually
#? =+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+


$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop


# 5-047
function Get-RecentDllFiles {

    [CmdletBinding()]

    param (
        [string]$Num = "5-047",
        [string]$FileName = "RecentDllFiles.csv",
        [string]$Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ChildItem -Path $Path -File -Recurse -Force | Where-Object { $_.Extension -eq ".dll" } | Select-Object Name, Directory, FullName, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save the data to CSV
                Save-OutputAsCsv $Data $File
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 5-048
function Get-RecentLinkFiles {

    [CmdletBinding()]

    param (
        [string]$Num = "5-048",
        [string]$FileName = "RecentLinkFiles.csv",
        [int]$DaysBack = 90
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            # Get Recent .lnk files
            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-CimInstance -ClassName Win32_ShortcutFile | Where-Object {
                $_.LastModified -gt $CutoffDate
            } | Select-Object FileName, Status, Caption, Compressed, Encrypted, FileSize, Hidden,
                @{ N = "CreationDate"; E = { $_.CreationDate } },
                @{ N = "LastAccessed"; E = { $_.LastAccessed } },
                @{ N = "LastModified"; E = { $_.LastModified } },
                Target | Sort-Object LastModified -Descending
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save output to CSV file
                Save-OutputAsCsv $Data $File
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 5-049
function Get-CompressedFiles {

    [CmdletBinding()]

    param (
        [string]$Num = "5-049",
        [string]$FileName = "CompressedFiles.csv",
        [string]$Path = "C:\",
        # Default file types to search
        [string[]]$FileTypes = @("*.exe", "*.dll", "*.zip")
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            # Get compressed files
            $Data = Get-ChildItem -Path $Path -Include $FileTypes -Recurse -Force | Where-Object { $_.Attributes -band [IO.FileAttributes]::Compressed }
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save data to a CSV file
                $Data | Select-Object FullName, Name, Attributes, Length, @{ N = "LastModified"; E = { $_.LastWriteTimeUtc } } | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 5-050
function Get-EncryptedFiles {

    [CmdletBinding()]

    param (
        [string]$Num = "5-050",
        [string]$FileName = "EncryptedFiles.csv",
        [string]$Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | Where-Object { $_.Attributes -band [IO.FileAttributes]::Encrypted }
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save data to a CSV file
                $Data | Select-Object FullName, Name, Attributes, Length, @{ N = "LastModified"; E = { $_.LastWriteTimeUtc } } | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 5-051
function Get-ExeTimeline {

    [CmdletBinding()]

    param (
        [string]$Num = "5-051",
        [string]$FileName = "TimelineOfExecutables.csv",
        [string]$Path = "C:\",
        [int]$DaysBack = 90
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")

            $CutoffDate = (Get-Date).AddDays(-$DaysBack)
            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | Where-Object { -Not $_.PSIsContainer -and $_.LastWriteTime -gt $CutoffDate } | Select-Object FullName, LastWriteTime, @{ N = "Owner"; E = { ($_ | Get-ACL).Owner } }
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save output to CSV file
                Save-OutputAsCsv $Data $File
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}

# 5-052
function Get-DownloadedExecutables {

    [CmdletBinding()]

    param (
        [string]$Num = "5-052",
        [string]$FileName = "DownloadedExecutables.csv",
        [string]$Path = "C:\"
    )

    $File = Join-Path -Path $SystemFolder -ChildPath "$($Num)_$FileName"
    $FunctionName = $MyInvocation.MyCommand.Name
    $Header = "$Num Running ``$FunctionName`` function"
    try {
        # Run the command
        $ExecutionTime = Measure-Command {
            Show-Message("$Header")
            Write-LogEntry("[$($ModuleName), Ln: $(Get-LineNum)] $Header")
            $Data = Get-ChildItem -Path $Path -Recurse -Force -Include $ExecutableFileTypes | ForEach-Object { Get-Item $_.FullName -Stream * } | Where-Object { $_.Stream -Match "Zone.Identifier" } | Select-Object Filename, Stream, @{ N = "LastWriteTime"; E = { (Get-Item $_.FileName).LastWriteTime } }
            if ($Data.Count -eq 0) {
                Write-NoDataFound $FunctionName
            }
            else {
                # Save output to CSV file
                Save-OutputAsCsv $Data $File
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
        Write-LogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-RecentDllFiles, Get-RecentLinkFiles, Get-CompressedFiles, Get-EncryptedFiles, Get-ExeTimeline, Get-DownloadedExecutables
