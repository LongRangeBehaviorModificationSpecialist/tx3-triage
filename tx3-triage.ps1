#Requires -RunAsAdministrator


# Configure the powershell policy to run unsigned scripts
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force


$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue


# Import the functions.psm1 module so the functions are available for use
$FunctionsModule = ".\functions\Set-Functions.psm1"
Import-Module -Name $FunctionsModule -Force -Global
Show-Message("`nModule file: '$($FunctionsModule)' was imported successfully") -NoTime -Blue


$HtmlModule = ".\html\Export-HtmlReport.psm1"
Import-Module -Name $HtmlModule -Force -Global
Show-Message("Module file: '$($HtmlModule)' was imported successfully") -NoTime -Blue


$FilesModule = ".\files\Export-FilesReport.psm1"
Import-Module -Name $FilesModule -Force -Global
Show-Message("Module file: '$($FilesModule)' was imported successfully") -NoTime -Blue


$GuiModule = ".\gui\GuiMain.psm1"
Import-Module -Name $GuiModule -Force -Global
Show-Message("Module file: '$($GuiModule)' was imported successfully") -NoTime -Blue


Get-Gui
