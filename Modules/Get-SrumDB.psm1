# function Get-SrumDB {

[CmdletBinding()]

param (

    [Parameter(Position = 0)]
    [ValidateScript({ Test-Path $_ })]
    [string]$CaseFolder,

    [Parameter(Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName,

    # Name of the directory to store the copied SRUM file
    [string]$SrumFolderName = "00H_SRUM",
    [string]$FileNamePath = "$Env:windir\System32\sru\SRUDB.dat",
    [string]$OutputFileName = "SRUDB_$($ComputerName).dat",
    # Path to the RawCopy executable
    [string]$RawCopyPath = ".\bin\RawCopy.exe"

)

$SrumFuncName = $PSCmdlet.MyInvocation.MyCommand.Name

try {

    $ExecutionTime = Measure-Command {

        # Show & log $BeginMessage message
        $BeginMessage = "Beginning capture of SRUMDB.dat files from computer: $ComputerName"
        Show-Message("$BeginMessage") -Header
        Write-LogEntry("[$($SrumFuncName), Ln: $(Get-LineNum)] $BeginMessage")

        $FileHashingMsg = "Calculating the original hash value of $FileNamePath"
        Show-Message("$FileHashingMsg")
        Write-LogEntry("$FileHashingMsg")

        # Calculate the value of the hash value of the SRUMDB.dat file before it is copied
        $OriginalFileHash = Get-FileHash -Path $FileNamePath -Algorithm SHA256
        $OrigFileHashMsg = "Hash value of original SRUMDB.dat file -> $OriginalFileHash"
        Show-Message("$OrigFileHashMsg")
        Write-LogEntry("$OrigFileHashMsg")

        # Make new directory to store the SRUM database
        $SrumFolder = New-Item -ItemType Directory -Path $CaseFolderName -Name $SrumFolderName

        if (-not (Test-Path $SrumFolder)) {

            throw "[ERROR] The necessary folder does not exist -> `"$SrumFolder`""

        }

        # Show & log $CreateDirMsg messages
        $CreateDirMsg = "Created `"$($SrumFolder.Name)`" folder in the case directory"
        Show-Message("$CreateDirMsg")
        Write-LogEntry("[$($SrumFuncName), Ln: $(Get-LineNum)] $CreateDirMsg")

        if (-not (Test-Path $RawCopyPath)) {

            Write-Error "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
            return

        }

        # Copy the original file
        try {

            $RawCopyResult = Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$FileNamePath /OutputPath:"$SrumFolder" /OutputName:$OutputFileName }

            if ($LASTEXITCODE -ne 0) {

                Write-Error "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                return

            }

        }

        catch {

            Write-Error "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
            return

        }

        $CopiedFile = Join-Path -Path $SrumFolder -ChildPath $OutputFileName

        # Get hash value of copied file
        $CopiedFileHash = Get-FileHash -Path $CopiedFile -Algorithm SHA256
        $CopiedFileHashMsg = "Hash value of original SRUMDB.dat file -> $CopiedFileHash"
        Show-Message("$CopiedFileHashMsg")
        Write-LogEntry("$CopiedFileHashMsg")

        # Compare the hashes
        if ($OriginalFileHash -eq $CopiedFileHash) {

            $HashMatchMsg = "Hashes match! The file was copied successfully."
            Show-Message("$HashMatchMsg")
            Write-LogEntry("[$($SrumFuncName), Ln: $(Get-LineNum)] $HashMatchMsg")

            # Show & log $SuccessMsg message
            $SuccessMsg = "SRUMDB.dat file copied successfully from computer: $ComputerName"
            Show-Message("$SuccessMsg")
            Write-LogEntry("[$($SrumFuncName), Ln: $(Get-LineNum)] $SuccessMsg")

            # Show & log $FileSavTitle message
            $FileSavName = "Copied file saved as -> $OutputFileName`n"
            Show-Message("$FileSavName") -Green
            Write-LogEntry("[$SrumFuncName, Ln: $(Get-LineNum)] $FileSavName")

        }

        else {

            $HashNotMatchMsg = "Hashes do not match! There was an error in copying the file."
            Show-Message("$HashNotMatchMsg") -Red
            Write-LogEntry("[$($HashNotMatchMsg), Ln: $(Get-LineNum)] $SuccessMsg") -WarningMessage

        }

    }

    # Show & log finish messages
    Show-FinishMessage $SrumFuncName $ExecutionTime
    Write-LogFinishedMessage $SrumFuncName $ExecutionTime

}

catch {

    # Error handling
    $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
    Show-Message("$ErrorMessage") -Red
    Write-LogEntry("$ErrorMessage") -ErrorMessage

}

# }
