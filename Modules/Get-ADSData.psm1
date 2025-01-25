function Get-ADSData {
<#
.SYNOPSIS
    Performs a search for alternate data streams (ADS) in a given folder.
.DESCRIPTION
    Performs a search for alternate data streams (ADS) in a given folder. Default starting directory is c:\users.
    To test, perform the following steps first:
    $file = "C:\temp\testfile.txt"
    Set-Content -Path $file -Value 'Nobody here but us chickens!'
    Add-Content -Path $file -Value 'Super secret squirrel stuff' -Stream 'secretStream'
.PARAMETER Path
    Specify a path to search for alternate data streams in. Default is c:\users
.EXAMPLE
    Get-ADS -Path "C:\Temp"
.NOTES
    Updated: 2024-06-03

    Contributing Authors:
        Anthony Phipps
.LINK
    https://github.com/TonyPhipps/Meerkat
#>

    [CmdletBinding()]
    param(
        [string]$Path = "C:\Users"
    )

    $ErrorActionPreference = "SilentlyContinue"

    try {
        $Files = Get-ChildItem -Path $Path -Recurse -Force -File

        $Results = @()

        foreach ($File in $Files) {

            $Streams = Get-Item -Path $File.FullName -Stream * | Where-Object { $_.Stream -notlike "*DATA" -and $_.Stream -ne "Zone.Identifier" }

            foreach ($Stream in $Streams) {
                $StreamContent = try {
                    Get-Content -Path $File.FullName -Stream $Stream.Stream
                }
                catch {
                    Show-Message("Error reading stream content: $($PSItem)") -Red
                }

                $Results += [PSCustomObject]@{
                    Host              = $env:COMPUTERNAME
                    DateScanned       = $DateScanned
                    FileName          = $File.FullName
                    Stream            = $Stream.Stream
                    StreamLength      = $Stream.Length
                    StreamContent     = $StreamContent
                    CreationTimeUtc   = $File.CreationTimeUtc
                    LastAccessTimeUtc = $File.LastAccessTimeUtc
                    LastWriteTimeUtc  = $File.LastWriteTimeUtc
                    Attributes        = $File.Attributes
                }
            }
        }

        return $Results | Select-Object Host, DateScanned, FileName, Stream, StreamLength, StreamContent, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, Attributes

    }
    catch {
    # Error handling
    $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
    Show-Message("$ErrorMessage") -Red
    Write-LogEntry("$ErrorMessage") -ErrorMessage
    }
}


Export-ModuleMember -Function Get-ADSData
