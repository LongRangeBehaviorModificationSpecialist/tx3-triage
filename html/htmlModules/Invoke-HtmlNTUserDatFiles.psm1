
function Get-HtmlNTUserDatFiles {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateScript({ Test-Path $_ })]
        [string]$ResultsFolder,
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$ComputerName,
        [string]$FilePath,
        # Name of the directory to store the copied NTUSER.DAT files
        [string]$OutputFolderName = "NTUserDatFiles",
        # Path to the RawCopy executable
        [string]$RawCopyPath = ".\bin\RawCopy.exe"
    )

    $FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name

    try {
        Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

        # Make new directory to store the copied .DAT files
        $NTUserOutputFolder = New-Item -ItemType Directory -Path $ResultsFolder -Name $OutputFolderName

        if (-not (Test-Path $NTUserOutputFolder)) {
            throw "[ERROR] The necessary folder does not exist -> '$NTUserOutputFolder'"
        }

        # Show & log $CreateDirMsg messages
        $CreateDirMsg = "Created '$($NTUserOutputFolder.Name)' folder in the results directory"
        Show-Message("[INFO] $CreateDirMsg") -Green -Header
        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $CreateDirMsg")

        if (-not (Test-Path $RawCopyPath)) {
            $NoRawCopyWarnMsg = "The required RawCopy.exe binary is missing. Please ensure it is located at: $RawCopyPath"
            Show-Message("[ERROR] $NoRawCopyWarnMsg") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $NoRawCopyWarnMsg") -ErrorMessage
        }

        try {
            foreach ($User in Get-ChildItem(Join-Path -Path $Env:HOMEDRIVE -ChildPath "Users")) {
                # Do not collect the NTUSER.DAT files from the `default` or `public` user accounts
                if ((-not ($User -contains "default")) -and (-not ($User -match "public"))) {
                    # Show & log the $CopyMsg message
                    $NTUserFilePath = "$Env:HOMEDRIVE\Users\$User\NTUSER.DAT"
                    $OutputFileName = "$User-NTUSER.DAT"
                    $CopyMsg = "Copying NTUSER.DAT file from the $User profile from computer: $ComputerName"
                    Show-Message("[INFO] $CopyMsg") -Magenta
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $CopyMsg")
                    Invoke-Command -ScriptBlock { .\bin\RawCopy.exe /FileNamePath:$NTUserFilePath /OutputPath:"$NTUserOutputFolder" /OutputName:"$OutputFileName" }

                    if ($LASTEXITCODE -ne 0) {
                        $NoProperExitMsg = "RawCopy.exe failed with exit code $($LASTEXITCODE). Output: $RawCopyResult"
                        Show-Message("[ERROR] $NoProperExitMsg") -Red
                        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $NoProperExitMsg") -ErrorMessage
                    }
                }
            }
        }
        catch {
            $RawCopyOtherMsg = "An error occurred while executing RawCopy.exe: $($PSItem.Exception.Message)"
            Show-Message("[ERROR] $RawCopyOtherMsg") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $RawCopyOtherMsg") -ErrorMessage
        }
        # Show & log $SuccessMsg message
        $SuccessMsg = "NTUSER.DAT files copied from computer: $ComputerName"
        Show-Message("[INFO] $SuccessMsg") -Blue
        Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $SuccessMsg")
    }
    catch {
        Invoke-ShowErrorMessage $($FunctionName) $(Get-LineNum) $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-HtmlNTUserDatFiles
