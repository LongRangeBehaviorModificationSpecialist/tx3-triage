$ProcessesPropertyArray = [ordered]@{

    "4-001_RunningProcessesAll"  = ("Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName", "Pipe")
    "4-002 SvcHostsAndProcesses" = ("Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq 'svchost.exe' | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path", "Pipe")
    "4-003_DriverQuery"          = ("driverquery | Out-String", "String")
}


function Export-ProcessHtmlPage {

    [CmdletBinding()]

    param
    (
        [string]$FilePath,
        [string]$PagesFolder
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    # 4-000
    function Get-ProcessesData {

        param
        (
            [string]$FilePath,
            [string]$PagesFolder
        )

        foreach ($item in $ProcessesPropertyArray.GetEnumerator())
        {
            $Name = $item.Key
            $Command = $item.value[0]
            $Type = $item.value[1]

            $FileName = "$Name.html"
            Show-Message("Running ``$Name`` command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage $Name
                }
                else
                {
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                    Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage $Name
        }
    }

    #! 4-004 (Csv Output)
    function Get-RunningProcessesAsCsv {

        $Name = "4-004_RunningProcessesAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-005 (Csv Output)
    function Get-UniqueProcessHashAsCsv {

        $Name = "4-005_UniqueProcessHashesAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            $Data = @()
            foreach ($P in (Get-WmiObject Win32_Process | Select-Object Name, ExecutablePath, CommandLine, ParentProcessId, ProcessId))
            {
                $ProcessObj = New-Object PSCustomObject
                if ($Null -ne $P.ExecutablePath)
                {
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
            ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() | Export-Csv -NoTypeInformation -Path "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-006 (Csv Output)
    function Get-RunningServicesAsCsv {

        $Name = "4-006_RunningServicesAsCsv"
        Show-Message("Running ``$Name`` command") -Header -DarkGray
        $FileName = "$Name.csv"

        try
        {
            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -Start

            Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"

            Invoke-SaveOutputMessage $FunctionName $(Get-LineNum) $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage $($MyInvocation.ScriptName) $(Get-LineNum) $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ProcessesData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-RunningProcessesAsCsv  # No need to pass variables to this function
    Get-UniqueProcessHashAsCsv  # No need to pass variables to this function
    Get-RunningServicesAsCsv  # No need to pass variables to this function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-ProcessHtmlPage
