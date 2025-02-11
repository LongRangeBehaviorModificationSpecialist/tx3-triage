$ProcessesPropertyArray = [ordered]@{

    "4-001_RunningProcessesAll"  = ("Win32_Process", "Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName | Out-String", "String")
    "4-002 SvcHostsAndProcesses" = ("Svc Hosts & Processes", "Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq 'svchost.exe' | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path | Out-String", "String")
    "4-003_DriverQuery"          = ("DriverQuery", "driverquery | Out-String", "String")
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
            $Title = $item.value[0]
            $Command = $item.value[1]
            $Type = $item.value[2]

            $FileName = "$Name.html"
            Show-Message("[INFO] Running '$Name' command") -Header -DarkGray
            $OutputHtmlFilePath = New-Item -Path "$PagesFolder\$FileName" -ItemType File -Force

            try
            {
                $Data = Invoke-Expression -Command $Command
                if ($Data.Count -eq 0)
                {
                    Invoke-NoDataFoundMessage -Name $Name -FilePath $FilePath -Title $Title
                }
                else
                {
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

                    Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='.\$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

                    if ($Type -eq "Pipe")
                    {
                        Save-OutputToSingleHtmlFile -FromPipe $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    if ($Type -eq "String")
                    {
                        Save-OutputToSingleHtmlFile -FromString $Name $Data $OutputHtmlFilePath -Title $Title
                    }
                    Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
                }
            }
            catch
            {
                Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
            }
            Show-FinishedHtmlMessage -Name $Name
        }
    }

    #! 4-004 (Csv Output)
    function Get-RunningProcessesAsCsv {

        $Name = "4-004_RunningProcessesAsCsv"
        $Title = "Running Processes (as Csv)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 4-005 (Csv Output)
    function Get-UniqueProcessHashAsCsv {

        $Name = "4-005_UniqueProcessHashesAsCsv"
        $Title = "Unique Processes Hashes (as Csv)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray


        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

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

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }

    #! 4-006 (Csv Output)
    function Get-RunningServicesAsCsv {

        $Name = "4-006_RunningServicesAsCsv"
        $Title = "Running Services (as Csv)"
        $FileName = "$Name.csv"
        Show-Message("[INFO] Running '$Name' command") -Header -DarkGray

        try
        {
            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -Start

            Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Add-Content -Path $FilePath -Value "<p class='btn_label'>$($Title)</p>`n<a href='../files/$FileName'><button type='button' class='collapsible'>$($FileName)</button></a>`n"

            Invoke-SaveOutputMessage -FunctionName $FunctionName -LineNumber $(Get-LineNum) -Name $Name -FileName $FileName -Finish
        }
        catch
        {
            Invoke-ShowErrorMessage -ScriptName $($MyInvocation.ScriptName) -LineNumber $(Get-LineNum) -Message $($PSItem.Exception.Message)
        }
        Show-FinishedHtmlMessage -Name $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-ProcessesData -FilePath $FilePath -PagesFolder $PagesFolder
    Get-RunningProcessesAsCsv  # No need to pass variables to this function
    Get-UniqueProcessHashAsCsv  # No need to pass variables to this function
    Get-RunningServicesAsCsv  # No need to pass variables to this function


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $HtmlFooter
}


Export-ModuleMember -Function Export-ProcessHtmlPage
