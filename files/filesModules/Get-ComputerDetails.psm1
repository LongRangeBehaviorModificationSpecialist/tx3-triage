$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-ComputerDetails {
<#
.SYNOPSIS
    Collects multiple points of information from the system from various Windows Management Instrumentation (WMI) classes.

.DESCRIPTION
    Collects multiple points of information from the system from various Windows Management Instrumentation (WMI) classes.

.EXAMPLE
    Get-ComputerDetails

.EXAMPLE
    Get-ComputerDetails |
    Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID |
    Export-Csv -NoTypeInformation ("c:\temp\ComputerDetails.csv")

.EXAMPLE
    Invoke-Command -ComputerName remoteHost -ScriptBlock ${Function:Get-Computer} |
    Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID |
    Export-Csv -NoTypeInformation ("c:\temp\Computer.csv")

.EXAMPLE
    $Targets = Get-ADComputer -filter * | Select -ExpandProperty Name
    ForEach ($Target in $Targets) {
        Invoke-Command -ComputerName $Target -ScriptBlock ${Function:Get-ComputerDetails} |
        Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID |
        Export-Csv -NoTypeInformation ("c:\temp\" + $Target + "_Computer.csv")
    }

.NOTES
    Updated: 2024-10-02

    Contributing Authors:
        Anthony Phipps

    LEGAL: Copyright (C) 2024
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

.LINK
    https://github.com/TonyPhipps/Meerkat
    https://github.com/TonyPhipps/Meerkat/wiki/Computer

#>

    [CmdletBinding()]

    param()

    Enum DomainRole {
        StandaloneWorkstation = 0
        MemberWorkstation = 1
        StandaloneServer = 2
        MemberServer = 3
        BackupDomainController = 4
        PrimaryDomainController = 5
    }

    Enum LicenseStatus {
        Unlicensed = 0
        Licensed = 1
        OOBGrace = 2
        OOTGrace = 3
        NonGenuineGrace = 4
        Notification = 5
        ExtendedGrace = 6
    }

    try {
        $Win32_OperatingSystem = Get-CIMinstance -class Win32_OperatingSystem
        $Win32_ComputerSystem = Get-CIMInstance -class Win32_ComputerSystem
        $Win32_BIOS = Get-CIMinstance -class Win32_BIOS
        $Win32_Processor = Get-CIMinstance -class Win32_Processor
        $SoftwareLicensingProduct = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey }
        $Result = New-Object -TypeName PSObject

        foreach ($Property in $Win32_OperatingSystem.PSObject.Properties) {
            $Result | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value -ErrorAction SilentlyContinue | Out-Null
        }

        $Result.CurrentTimeZone = $Result.CurrentTimeZone / 60

        foreach ($Property in $Win32_ComputerSystem.PSObject.Properties) {
            $Result | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value -ErrorAction SilentlyContinue | Out-Null
        }

        $Result.DomainRole = ([DomainRole]$Result.DomainRole).ToString()
        $UpTime = (Get-Date) - $Result.LastBootUpTime

        foreach ($Property in $Win32_Processor.PSObject.Properties) {
            $Result | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value -ErrorAction SilentlyContinue | Out-Null
        }

        foreach ($Property in $Win32_BIOS.PSObject.Properties) {
            $Result | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value -ErrorAction SilentlyContinue | Out-Null
        }

        $Result.BiosVersion = $Result.BiosVersion -join " | "

        $UpTime = (Get-Date) - $Win32_OperatingSystem.LastBootUpTime

        $Result.DomainRole = ([DomainRole]$Result.DomainRole).ToString()

        $Result | Add-Member -MemberType NoteProperty -Name MinimumPasswordLength -Value (net accounts | Select-String -Pattern "Minimum password length").ToString().Split()[-1]

        $Result | Add-Member -MemberType NoteProperty -Name UpTime -Value ("{0}:{1}:{2}:{3}" -f $Uptime.Days, $UpTime.Hours, $UpTime.Minutes, $UpTime.Seconds)

        $Result | Add-Member -MemberType NoteProperty -Name USBStorageLock -Value (Get-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Services\USBStor" -Name "Start" -ErrorAction Stop).Start

        $Result | Add-Member -MemberType NoteProperty -Name LicenseType -Value ($SoftwareLicensingProduct.Description).Split(",")[1].Trim()

        $Result | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value ([LicenseStatus]$SoftwareLicensingProduct.LicenseStatus).ToString()

        # Resolves conflict with Win32_OperatingSystem
        $Result | Add-Member -MemberType NoteProperty -Name BIOSInstallDate -Value $Win32_BIOS.InstallDate -ErrorAction SilentlyContinue

        # Resolves conflict with Win32_ComputerSystem
        $Result | Add-Member -MemberType NoteProperty -Name BIOSManufacturer -Value $Win32_BIOS.Manufacturer -ErrorAction SilentlyContinue

        # Resolves conflict with Win32_OperatingSystem
        $Result | Add-Member -MemberType NoteProperty -Name BIOSSerialNumber -Value $Win32_BIOS.SerialNumber -ErrorAction SilentlyContinue

        $Result | Add-Member -MemberType NoteProperty -Name "Host" -Value $env:COMPUTERNAME

        $Result | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned

        return $Result | Select-Object Host, DateScanned, CurrentTimeZone, InstallDate, LastBootUpTime, UpTime, LocalDateTime, BootDevice, BootROMSupported, BootupState, ChassisBootupState, DataExecutionPrevention_32BitApplications, DataExecutionPrevention_Available, DataExecutionPrevention_Drivers, DataExecutionPrevention_SupportPolicy, MinimumPasswordLength, USBStorageLock, Debug, EncryptionLevel, AdminPasswordStatus, Description, Distributed, OSArchitecture, OSProductSuite, OSType, OperatingSystemSKU, Organization, OtherTypeDescription, PortableOperatingSystem, ProductType, RegisteredUser, ServicePackMajorVersion, ServicePackMinorVersion, Status, SuiteMask, BuildNumber, Caption, LicenseType, LicenseStatus, SystemDevice, SystemDirectory, SystemDrive, MUILanguages, Version, WindowsDirectory, DNSHostName, DaylightInEffect, Domain, DomainRole, EnableDaylightSavingsTime, PrimaryOwnerContact, PrimaryOwnerName, SupportContactDescription, UserName, Manufacturer, Model, NetworkServerModeEnabled, HypervisorPresent, SystemSKUNumber, ThermalState, BIOSVersion, BIOSInstallDate, BIOSManufacturer, PrimaryBIOS, BIOSReleaseDate, SMBIOSBIOSVersion, SMBIOSMajorVersion, SMBIOSMinorVersion, SMBIOSPresent, BIOSSerialNumber, SystemBiosMajorVersion, SystemBiosMinorVersion, VirtualizationFirmwareEnabled
    }

    catch {
        Invoke-ShowErrorMessage -Function $($MyInvocation.MyCommand.Name) -LineNumber $($PSItem.InvocationInfo.ScriptLineNumber) -Message $($PSItem.Exception.Message)
    }
}


Export-ModuleMember -Function Get-ComputerDetails
