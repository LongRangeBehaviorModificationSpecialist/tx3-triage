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
                    Show-Message("No data found for ``$Name``") -Yellow
                    Write-HtmlLogEntry("No data found for ``$Name``")
                }
                else
                {
                    Show-Message("[INFO] Saving output from ``$Name``") -Blue
                    Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

                    Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='.\$FileName'>$FileName</a></p></div>"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath
                    }
                }
            }
            catch
            {
                $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
                Show-Message("[ERROR] $ErrorMessage") -Red
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from ``$Name``") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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

            Show-Message("[INFO] Saving output from ``$Name``") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
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
            Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from ``$Name``") -Blue
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from ``$($Name)`` saved to $FileName")

            Add-Content -Path $FilePath -Value "`n<button type='button' class='collapsible'>$($Name)</button><div class='content'>FILE: <a href='../files/$FileName'>$FileName</a></p></div>"
        }
        catch
        {
            $ErrorMessage = "In Module: $(Split-Path -Path $MyInvocation.ScriptName -Leaf), Ln: $($PSItem.InvocationInfo.ScriptLineNumber), MESSAGE: $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ProcessesData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-RunningProcessesAsCsv  # Do not pass $FilePath variable to function
    Get-UniqueProcessHashAsCsv  # Do not pass $FilePath variable to function
    Get-RunningServicesAsCsv  # Do not pass $FilePath variable to function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-ProcessHtmlPage
