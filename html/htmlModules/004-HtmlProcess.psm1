function Export-ProcessHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$FilePath
    )

    Add-Content -Path $FilePath -Value $HtmlHeader

    $FunctionName = $MyInvocation.MyCommand.Name

    $FilesFolder = "$(Split-Path -Path (Split-Path -Path $FilePath -Parent) -Parent)\files"


    # 4-001
    function Get-RunningProcessesAll {
        param ([string]$FilePath)
        $Name = "4-001 Running Processes (All)"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_Process | Select-Object -Property * | Sort-Object ProcessName
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-002
    function Get-RunningProcessesAsCsv {
        $Name = "4-002 Running Processes (as Csv)"
        Show-Message("Running '$Name' command") -Header -DarkGray
        $FileName = "4-002_RunningProcesses.csv"
        try {
            Get-CimInstance -ClassName Win32_Process | Select-Object ProcessName, ExecutablePath, CreationDate, ProcessId, ParentProcessId, CommandLine, SessionID | Sort-Object -Property ParentProcessId | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from '$Name'") -Blue

            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-003
    function Get-UniqueProcessHashAsCsv {
        $Name = "4-003 Unique Process Hashes (as Csv)"
        Show-Message("Running '$Name' command") -Header -DarkGray
        $FileName = "4-003_UniqueProcessHash.csv"
        try {
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
            ($Data | Select-Object Proc_Path, Proc_ParentProcessId, Proc_ProcessId, Proc_Hash -Unique).GetEnumerator() | Export-Csv -NoTypeInformation -Path "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from '$Name'") -Blue

            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    # 4-004
    function Get-SvcHostsAndProcesses {
        param ([string]$FilePath)
        $Name = "4-004 SvcHostsAndProcesses"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = Get-CimInstance -ClassName Win32_Process | Where-Object Name -eq "svchost.exe" | Select-Object ProcessID, Name, Handle, HandleCount, WorkingSetSize, VirtualSize, SessionId, WriteOperationCount, Path
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromPipe $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #! 4-005
    function Get-RunningServicesAsCsv {
        $Name = "4-005 Running Services (as Csv)"
        Show-Message("Running '$Name' command") -Header -DarkGray
        $FileName = "4-005_RunningServices.csv"
        try {
            Get-CimInstance -ClassName Win32_Service | Select-Object * | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$FilesFolder\$FileName" -Encoding UTF8

            Show-Message("[INFO] Saving output from '$Name'") -Blue

            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")

            Add-Content -Path $FilePath -Value "`n<h5 class='info_header'> $Name </h5><button type='button' class='collapsible'>$($Name)</button><div class='content'><pre>FILE: <a href='../files/$FileName'>$FileName</a></pre></p></div>"
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }

    #* 4-006
    function Get-InstalledDrivers {
        param ([string]$FilePath)
        $Name = "4-006 driverquery"
        Show-Message("Running '$Name' command") -Header -DarkGray
        try {
            $Data = driverquery | Out-String
            if ($Data.Count -eq 0) {
                Show-Message("No data found for '$Name'") -Yellow
            }
            else {
                Show-Message("[INFO] Saving output from '$Name'") -Blue
                Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] Output from $($MyInvocation.MyCommand.Name) saved to $(Split-Path -Path $FilePath -Leaf)")
                Save-OutputToHtmlFile -FromString $Name $Data $FilePath
            }
        }
        catch {
            # Error handling
            $ErrorMessage = "Error in line $($PSItem.InvocationInfo.ScriptLineNumber): $($PSItem.Exception.Message)"
            Show-Message("$ErrorMessage") -Red
            Write-HtmlLogEntry("[$($FunctionName), Ln: $(Get-LineNum)] $ErrorMessage") -ErrorMessage
        }
        Show-FinishedHtmlMessage $Name
    }


    # ----------------------------------
    # Run the functions from the module
    # ----------------------------------
    Get-RunningProcessesAll $FilePath
    Get-RunningProcessesAsCsv  # Do not pass $FilePath variable to function
    Get-UniqueProcessHashAsCsv  # Do not pass $FilePath variable to function
    Get-SvcHostsAndProcesses $FilePath
    Get-RunningServicesAsCsv  # Do not pass $FilePath variable to function
    Get-InstalledDrivers $FilePath


    # Add the closing text to the .html file
    Add-Content -Path $FilePath -Value $EndingHtml
}


Export-ModuleMember -Function Export-ProcessHtmlPage
