function Export-ProcessHtmlPage {

    [CmdletBinding()]

    param (
        [string]
        $OutputFolder,
        [string]
        $HtmlReportFile
    )

    $ProcessesPropertyArray = Import-PowerShellDataFile -Path "$PSScriptRoot\004A-ProcessDataArray.psd1"

    $ProcessHtmlMainFile = New-Item -Path "$OutputFolder\004_main.html" -ItemType File -Force

    # 4-000
    function Get-ProcessesData {

        foreach ($item in $ProcessesPropertyArray.GetEnumerator()) {
            $Name = $item.Key
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$OutputFolder\$FileName" -ItemType File -Force

            try {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0) {
                    Invoke-NoDataFoundMessage -Name $Name
                }
                else {
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
                    if ($Type -eq "Pipe") {
                        Save-OutputToSingleHtmlFile  $Name $Data $OutputHtmlFilePath $Title -FromPipe
                    }
                    if ($Type -eq "String") {
                        Save-OutputToSingleHtmlFile $Name $Data $OutputHtmlFilePath $Title -FromString
                    }
                    Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch {
                Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    #! 4-007 (Csv Output)
    function Get-RunningProcessesAsCsv {

        $Name = "4-007_RunningProcessesAsCsv"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
            Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-008 (Csv Output)
    function Get-UniqueProcessHashAsCsv {

        $Name = "4-008_UniqueProcessHashesAsCsv"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start

            $Data = @()
            foreach ($P in (Get-WmiObject Win32_Process | Select-Object Name, ExecutablePath, CommandLine, ParentProcessId, ProcessId)) {
                $ProcessObj = New-Object PSCustomObject
                if ($Null -ne $P.ExecutablePath) {
                    $Hash = (Get-FileHash -Algorithm SHA256 -Path $P.ExecutablePath).Hash
                    $ProcessObj | Add-Member -NotePropertyName Proc_Hash -NotePropertyValue $Hash
                    $ProcessObj | Add-Member -NotePropertyName Proc_Name -NotePropertyValue $P.Name
                    $ProcessObj | Add-Member -NotePropertyName Proc_Path -NotePropertyValue $P.ExecutablePath
                    $ProcessObj | Add-Member -NotePropertyName Proc_CommandLine -NotePropertyValue $P.CommandLine
                    $ProcessObj | Add-Member -NotePropertyName Proc_ParentProcessId -NotePropertyValue $P.ParentProcessId
                    $ProcessObj | Add-Member -NotePropertyName Proc_ProcessId -NotePropertyValue $P.ProcessId
                    $Data += $ProcessObj
                }
            }
            ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() | Export-Csv -NoTypeInformation -Path "$OutputFolder\$FileName" -Encoding UTF8
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-009 (Csv Output)
    function Get-RunningServicesAsCsv {

        $Name = "4-009_RunningServicesAsCsv"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try {
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -Start
            Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$OutputFolder\$FileName" -Encoding UTF8
            Invoke-SaveOutputMessage $($MyInvocation.MyCommand.Name) $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch {
            Invoke-ShowErrorMessage $($MyInvocation.MyCommand.ModuleName) $($MyInvocation.MyCommand.Name) $($PSItem.InvocationInfo.ScriptLineNumber) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    function Write-ProcessSectionToMain {

        Add-Content -Path $HtmlReportFile -Value "`t`t`t`t<h3><a href='results\004\004_main.html' target='_blank'>Processes Info</a></h3>" -Encoding UTF8

        $SectionName = "Process Information Section"

        $SectionHeader = "`t`t`t<h3 class='section_header'>$($SectionName)</h3>
            <div class='number_list'>"

        Add-Content -Path $ProcessHtmlMainFile -Value $HtmlHeader -Encoding UTF8
        Add-Content -Path $ProcessHtmlMainFile -Value $SectionHeader -Encoding UTF8

        $FileList = Get-ChildItem -Path $OutputFolder | Sort-Object Name | Select-Object -ExpandProperty Name

        foreach ($File in $FileList) {
            if ($($File.SubString(0, 3)) -eq "004") {
                continue
            }
            if ([System.IO.Path]::GetExtension($File) -eq ".csv") {
                $FileNameEntry = "`t`t`t`t<a class='file_link' href='$File' target='_blank'>$File</a>"
                Add-Content -Path $ProcessHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
            else {
                $FileNameEntry = "`t`t`t`t<a href='$File' target='_blank'>$File</a>"
                Add-Content -Path $ProcessHtmlMainFile -Value $FileNameEntry -Encoding UTF8
            }
        }

        Add-Content -Path $ProcessHtmlMainFile -Value "`t`t`t</div>`n`t`t</div>`n`t</body>`n</html>" -Encoding UTF8
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ProcessesData
    Get-RunningProcessesAsCsv
    Get-UniqueProcessHashAsCsv
    Get-RunningServicesAsCsv


    Write-ProcessSectionToMain
}


Export-ModuleMember -Function Export-ProcessHtmlPage
