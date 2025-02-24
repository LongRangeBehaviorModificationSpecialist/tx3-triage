$ModuleName = Split-Path $($MyInvocation.MyCommand.Path) -Leaf


$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


# 0-001
function Get-ForensicData {
<#
.SYNOPSIS
    Collects forensic identification data about the examined computer and saves it to a text or CSV file.

.DESCRIPTION
    This script gathers key forensic data, including system, network, user account, and hardware information, and stores the results in a file.

.PARAMETER OutputFile
    The path where the output file will be saved.

.PARAMETER Format
    The format of the output file: 'Text' or 'CSV'.

.EXAMPLE
    .\Collect-SystemForensicInfo.ps1 -OutputFile "C:\Forensics\SystemInfo.txt" -Format "Text"
#>

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-001",
        [string]
        $FileName = "SystemInfo.txt"
    )

    $File = Join-Path -Path $TestingFolder -ChildPath "$($Num)_$FileName"
    $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"

    try {
        $ExecutionTime = Measure-Command {
            Show-Message -Message "[INFO] $Header" -Header -DarkGray
            Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

            # Create a hashtable to store all forensic data
            $ForensicData = @{}

            # Collect Hostname and Domain Information
            $ForensicData["Hostname"] = $env:COMPUTERNAME
            $ForensicData["Domain"] = $env:USERDOMAIN

            # Collect Operating System Information
            $OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
            $ForensicData["OSName"] = $OSInfo.Caption
            $ForensicData["OSVersion"] = $OSInfo.Version
            $ForensicData["OSArchitecture"] = $OSInfo.OSArchitecture
            $ForensicData["LastBootTime"] = $OSInfo.LastBootUpTime

            # Collect BIOS Information
            $BIOSInfo = Get-CimInstance -ClassName Win32_BIOS
            $ForensicData["BIOSVersion"] = $BIOSInfo.SMBIOSBIOSVersion
            $ForensicData["BIOSManufacturer"] = $BIOSInfo.Manufacturer
            $ForensicData["BIOSSerialNumber"] = $BIOSInfo.SerialNumber

            # Collect Network Configuration
            $NetworkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
            $NetworkConfig = $NetworkAdapters | ForEach-Object {
                @{
                    AdapterName = $_.Name
                    MACAddress  = $_.MacAddress
                    IPAddresses = (Get-NetIPAddress -InterfaceIndex $_.IfIndex | ForEach-Object { $_.IPAddress }) -join ", "
                }
            }
            $ForensicData["NetworkAdapters"] = $NetworkConfig

            # Collect User Accounts
            $UserAccounts = Get-LocalUser | Select-Object Name, Enabled, LastLogon
            $ForensicData["UserAccounts"] = $UserAccounts

            # Collect Installed Software
            $InstalledSoftware = Get-CimInstance -ClassName Win32_Product | Select-Object Name, Version, InstallDate
            $ForensicData["InstalledSoftware"] = $InstalledSoftware

            # Collect Attached USB Devices
            $USBDevices = Get-PnpDevice -Class USB | Where-Object { $_.Status -eq "OK" } | Select-Object FriendlyName, Manufacturer
            $ForensicData["USBDevices"] = $USBDevices

            # Output the data to the specified file format

            $Output = @()

            $Output += "=== Forensic System Information ===`n"
            $Output += "Hostname: $($ForensicData.Hostname)"
            $Output += "Domain: $($ForensicData.Domain)"
            $Output += "OS Name: $($ForensicData.OSName)"
            $Output += "OS Version: $($ForensicData.OSVersion)"
            $Output += "OS Architecture: $($ForensicData.OSArchitecture)"
            $Output += "Last Boot Time: $($ForensicData.LastBootTime)"
            $Output += "BIOS Version: $($ForensicData.BIOSVersion)"
            $Output += "BIOS Manufacturer: $($ForensicData.BIOSManufacturer)"
            $Output += "BIOS Serial Number: $($ForensicData.BIOSSerialNumber)"

            $Output += "`n`n=== Network Configuration ===`n"
            $ForensicData.NetworkAdapters | ForEach-Object {
                $Output += "Adapter: $($_.AdapterName), MAC: $($_.MACAddress), IP: $($_.IPAddresses)"
            }

            $Output += "`n`n=== User Accounts ===`n"
            $ForensicData.UserAccounts | ForEach-Object {
                $Output += "User: $($_.Name), Enabled: $($_.Enabled), Last Logon: $($_.LastLogon)"
            }

            $Output += "`n`n=== Installed Software ===`n"
            $ForensicData.InstalledSoftware | ForEach-Object {
                $Output += "Software: $($_.Name), Version: $($_.Version), Install Date: $($_.InstallDate)"
            }

            $Output += "`n`n=== USB Devices ===`n"
            $ForensicData.USBDevices | ForEach-Object {
                $Output += "Device: $($_.FriendlyName), Manufacturer: $($_.Manufacturer)"
            }

            Save-Output -Data $Output -File $File
            Show-OutputSavedToFile -File $File
            Write-LogOutputSaved -File $File
        }
        Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
    }
    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}

# 0-002
function Get-SuspiciousFiles {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-002",
        [string]
        $FileName = "SuspiciousFiles.txt",
        [string]
        $Path = "C:\",
        [string[]]
        $Keywords = @("child", "porn", "csam", "abuse"),
        [string[]]
        $Extensions = @("jpg", "png", "mp4", "mov")
    )

    begin {
        $File = Join-Path -Path $TestingFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
    }
    process {
        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

                $Data = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Where-Object {
                    ($_.Extension -replace "\.", "") -in $Extensions -and
                    ($_.Name -match ($Keywords -join "|"))
                } | Select-Object FullName, Name, Extension, CreationTime, LastWriteTime, Length

                if ($Data.Count -eq 0) {
                    Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                }
                else {
                    Save-Output -Data $Data -File $File
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
}

# 0-003
function Get-BrowserHistory {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-003",
        [string]
        $FileName = "SuspiciousFiles.txt",
        [string[]]
        $Keywords = @("child", "porn", "csam", "abuse")
    )

    begin {
        $File = Join-Path -Path $TestingFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
    }
    process {
        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

                $BrowserPaths = @(
                    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History",
                    "$env:APPDATA\Mozilla\Firefox\Profiles",
                    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History"
                )

                foreach ($Path in $BrowserPaths) {
                    if (Test-Path $Path) {
                        # Adjust based on browser structure; example uses SQLite for Chrome/Edge
                        try {
                            $SqlitePath = "$env:TEMP\history.db"
                            Copy-Item $Path $SqlitePath -Force
                            $Query = "SELECT url, title, last_visit_time FROM urls"
                            $Data = & sqlite3 $SqlitePath $Query
                            $Data | Where-Object { $_ -match ($Keywords -join "|") }

                            if ($Data.Count -eq 0) {
                                Write-NoDataFound -Function $($MyInvocation.MyCommand.Name)
                            }
                            else {
                                Save-Output -Data $Data -File $File
                                Show-OutputSavedToFile -File $File
                                Write-LogOutputSaved -File $File
                            }
                        }
                        catch {
                            Write-Warning "Failed to parse browser history at $Path -> $($_)"
                        }
                    }
                    else {
                        $PathDNEMsg = "The following path does not exist -> ``$Path``"
                        Show-Message -Message $PathDNEMsg
                        Write-LogEntry -Message "[$($MyInvocation.MyCommand.Name), Ln: $(Get-LineNum)] $PathDNEMsg"
                    }
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }
}

# TODO -- Add hashset database to the module (as a .json file)
# TODO -- Will need to change this function to search the .json file for the hash values rather than searching the text file
# 0-004
function Compare-FileHashes {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-004",
        [string]
        $FileName = "CompareHashes.txt",
        [string]
        $Path = "C:\",
        [string]
        $HashDatabase = "C:\hashes.txt"
    )

    begin {
        $File = Join-Path -Path $TestingFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
    }
    process {
        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

                $KnownHashes = Get-Content $HashDatabase
                Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Where-Object {
                    $_.Extension -match "jpg|png|gif|mp4|avi|mov"
                } | ForEach-Object {
                    $Hash = Get-FileHash -Path $_.FullName -Algorithm SHA256
                    if ($KnownHashes -contains $Hash.Hash) {
                        [PSCustomObject]@{
                            FileName     = $_.FullName
                            Hash         = $Hash.Hash
                            Size         = $_.Length
                            LastModified = $_.LastWriteTime
                        }
                    }
                }
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }
}

# 0-005
function Get-USBSTOR {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-005",
        [string]
        $FileName = "USBSTOR.txt"
    )

    begin {
        $File = Join-Path -Path $TestingFolder -ChildPath "$($Num)_$FileName"
        $Header = "$Num Running '$($MyInvocation.MyCommand.Name)' function"
    }
    process {
        try {
            $ExecutionTime = Measure-Command {
                Show-Message -Message "[INFO] $Header" -Header -DarkGray
                Write-LogEntry -Message "[$($ModuleName), Ln: $(Get-LineNum)] $Header"

                $DataKeys = @(
                    "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\*",
                    "HKLM:\SYSTEM\CurrentControlSet\Enum\USB\*\*"
                )

                $Data = @()
                $Counter = 0

                foreach($Key in $DataKeys) {
                    $Data += "=== Data from [$($DataKeys[$Counter])] ===`n"

                    $Data += Get-ItemProperty -Path $($DataKeys[$Counter]) | ForEach-Object {
                        $Serial = $_.PSChildName -replace '.*&'
                        [PSCustomObject]@{
                            Location         = $_.LocationInformation
                            DeviceDesc       = $_.DeviceDesc
                            SerialNumber     = $_.Serial
                            FriendlyName     = $_.FriendlyName
                            Manufacturer     = $_.Mfg
                            HardwareID       = $_.HardwareID
                            PSChildName      = $_.PSChildName
                            PSDrive          = $_.PSDrive
                            PSParentPath     = $_.PSParentPath
                            PSPath           = $_.PSPath
                            PSProvider       = $_.PSProvider
                            FirstInstallDate = $_.InstallDate
                        }
                    }
                    $Counter ++
                }
                Save-Output -Data $Data -File $File
                # $Data | Export-Csv -Path $File -NoTypeInformation -Encoding UTF8
                Show-OutputSavedToFile -File $File
                Write-LogOutputSaved -File $File
            }
            Show-FinishMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
            Write-LogFinishedMessage -Function $($MyInvocation.MyCommand.Name) -ExecutionTime $ExecutionTime
        }
        catch {
            Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
        }
    }
}

#0-006
function Get-RecentlyAccessedFiles {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-006",
        [string]
        $FileName = "RecentlyAccessedFiles.txt",
        [string]
        $Path = "C:\",
        [string[]]
        $Extensions = @("jpg", "png", "mp4", "mov", "avi", "mpeg"),
        [int]
        $Days = 7
    )

    process {
        Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Where-Object {
            ($_.Extension -replace "\.", "") -in $Extensions -and
            $_.LastAccessTime -gt (Get-Date).AddDays(-$Days)
        } | Select-Object FullName, Name, Extension, LastAccessTime, Length
    }
}


# 0-007
function Get-SuspiciousFilePermissions {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-007",
        [string]
        $FileName = "SuspiciousFilePermissions.txt",
        [string]
        $Path = "C:\",
        [string[]]
        $Extensions = @("jpg", "png", "mp4", "mov", "avi", "mpeg")
    )

    process {
        Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Where-Object {
            ($_.Extension -replace "\.", "") -in $Extensions
        } | ForEach-Object {
            $Acl = Get-Acl $_.FullName
            foreach ($Ace in $Acl.Access) {
                if ($Ace.FileSystemRights -match "FullControl|Modify" -and $Ace.IdentityReference -match "Everyone") {
                    [PSCustomObject]@{
                        FileName     = $_.FullName
                        Permissions  = $Ace.FileSystemRights
                        Identity     = $Ace.IdentityReference
                        LastModified = $_.LastWriteTime
                    }
                }
            }
        }
    }
}


# 0-008
function Get-PrefetchAnalysis {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-008",
        [string]
        $FileName = "PrefetchAnalysis.txt",
        [string]
        $Path = "C:\Windows\Prefetch"
    )

    process {
        Get-ChildItem -Path $Path -Filter "*.pf" -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject]@{
                FileName     = $_.FullName
                Application  = $_.BaseName
                LastAccessed = $_.LastWriteTime
            }
        }
    }
}


# TODO -- Add ThumbCacheViewer.exe to .bin directory.
# TODO -- Have this function only copy the thumbcache*.db files
# TODO -- Make seperate function to analyze the .db files on a seperate machine
# 0-009
function Get-ThumbnailCache {

    [CmdletBinding()]

    param (
        [string]
        $Num = "0-009",
        [string]
        $FileName = "RecentlyAccessedFiles.txt",
        [string]
        $CachePath = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
    )

    process {
        Get-ChildItem -Path $CachePath -Filter "thumbcache*.db" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $TempDir = "$env:TEMP\Thumbnails"
                New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
                $ThumbTool = "ThumbCacheViewer.exe" # Ensure the tool is available in $PATH
                & $ThumbTool -db $_.FullName -export $TempDir
            }
            catch {
                Write-Warning "Failed to process thumbnail cache at $_.FullName: $_"
            }
        }
    }
}


Export-ModuleMember -Function Get-ForensicData, Get-SuspiciousFiles, Get-BrowserHistory, Compare-FileHashes, Get-USBSTOR, Get-RecentlyAccessedFiles, Get-SuspiciousFilePermissions, Get-PrefetchAnalysis, Get-ThumbnailCache
