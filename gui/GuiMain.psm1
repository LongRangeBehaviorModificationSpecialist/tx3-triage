$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-Gui {

    # Load Windows Forms for GUI
    Add-Type -AssemblyName System.Windows.Forms

    # Define the form
    $Form = New-Object Windows.Forms.Form


    # Add title to the form window
    $Form.Text = "tx3-triage"
    $Form.Size = New-Object System.Drawing.Size(450, 570)  # width x height
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = "Sizable"
    $Form.TopMost = $false


    # Define label and text boxes for source and destination directories
    $lblUserName = New-Object System.Windows.Forms.Label
    $lblUserName.Text = "User Name:"
    $lblUserName.Font = New-Object System.Drawing.Font("Courier New", 10)  # , [System.Drawing.FontStyle]::Bold
    $lblUserName.ForeColor = [System.Drawing.Color]::Black
    $lblUserName.Width = 120
    $lblUserName.Location = New-Object System.Drawing.Point(10, 20)  # (x, y) position
    $lblUserName.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblUserName)

    $tbUserName = New-Object System.Windows.Forms.TextBox
    $tbUserName.Multiline = $false
    $tbUserName.Width = 250
    $tbUserName.BorderStyle = FixedSingle
    $tbUserName.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbUserName.Location = New-Object System.Drawing.Point(150, 20)  # (x, y) position
    $Form.Controls.Add($tbUserName)


    $lblAgency = New-Object System.Windows.Forms.Label
    $lblAgency.Text = "Agency:"
    $lblAgency.Font = New-Object System.Drawing.Font("Arial", 10)
    $lblAgency.ForeColor = [System.Drawing.Color]::Black
    $lblAgency.Width = 120
    $lblAgency.Location = New-Object System.Drawing.Point(10, 55)  # (x, y) position
    $lblAgency.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblAgency)

    $tbAgency = New-Object System.Windows.Forms.TextBox
    $tbAgency.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbAgency.Width = 250
    $tbAgency.Location = New-Object System.Drawing.Point(150, 55)  # (x, y) position
    $Form.Controls.Add($tbAgency)


    $lblCaseNumber = New-Object System.Windows.Forms.Label
    $lblCaseNumber.Text = "Case Number:"
    $lblCaseNumber.Font = New-Object System.Drawing.Font("Arial", 10)
    $lblCaseNumber.ForeColor = [System.Drawing.Color]::Black
    $lblCaseNumber.Width = 120
    $lblCaseNumber.Location = New-Object System.Drawing.Point(10, 90)  # (x, y) position
    $lblCaseNumber.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblCaseNumber)

    $tbCaseNumber = New-Object System.Windows.Forms.TextBox
    $tbCaseNumber.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbCaseNumber.Width = 250
    $tbCaseNumber.Location = New-Object System.Drawing.Point(150, 90)  # (x, y) position
    $Form.Controls.Add($tbCaseNumber)


    $gbOptionBox = New-Object System.Windows.Forms.GroupBox
    $gbOptionBox.Text = "Select Options"
    $gbOptionBox.Location = New-Object System.Drawing.Point(10, 120)  # (x, y) position
    $gbOptionBox.Size = New-Object System.Drawing.Size(410, 300)  # width x height
    $Form.Controls.Add($gbOptionBox)


    $cbGetProcesses = New-Object System.Windows.Forms.CheckBox
    $cbGetProcesses.Text = "Collect Running Processes"
    $cbGetProcesses.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbGetProcesses.Width = 250
    $cbGetProcesses.Location = New-Object System.Drawing.Point(10, 20)  # (x, y) position
    $gbOptionBox.Controls.Add($cbGetProcesses)


    $cbGetRam = New-Object System.Windows.Forms.CheckBox
    $cbGetRam.Text = "Collect Computer RAM"
    $cbGetRam.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbGetRam.Width = 250
    $cbGetRam.Location = New-Object System.Drawing.Point(10, 45)  # (x, y) position
    $gbOptionBox.Controls.Add($cbGetRam)


    $cbEdd = New-Object System.Windows.Forms.CheckBox
    $cbEdd.Text = "Run Encrypted Disk Detector"
    $cbEdd.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbEdd.Width = 250
    $cbEdd.Location = New-Object System.Drawing.Point(10, 70)  # (x, y) position
    $gbOptionBox.Controls.Add($cbEdd)


    $cbRegHives = New-Object System.Windows.Forms.CheckBox
    $cbRegHives.Text = "Copy Registry Hives"
    $cbRegHives.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbRegHives.Width = 250
    $cbRegHives.Location = New-Object System.Drawing.Point(10, 95)  # (x, y) position
    $gbOptionBox.Controls.Add($cbRegHives)


    $cbNTUserDat = New-Object System.Windows.Forms.CheckBox
    $cbNTUserDat.Text = "Copy NTUSER.DAT files"
    $cbNTUserDat.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbNTUserDat.Width = 250
    $cbNTUserDat.Location = New-Object System.Drawing.Point(10, 120)  # (x, y) position
    $gbOptionBox.Controls.Add($cbNTUserDat)


    $cbListFiles = New-Object System.Windows.Forms.CheckBox
    $cbListFiles.Text = "List ALL Files"
    $cbListFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbListFiles.Width = 120
    $cbListFiles.Location = New-Object System.Drawing.Point(10, 145)  # (x, y) position
    $gbOptionBox.Controls.Add($cbListFiles)

    $cbListFiles.Add_CheckedChanged({
            if ($cbListFiles.Checked) {
                $tbDrivesList.Enabled = $true
            }
            else {
                $tbDrivesList.Enabled = $false
            }
        })


    $tbDrivesList = New-Object System.Windows.Forms.TextBox
    $tbDrivesList.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbDrivesList.Width = 260
    $tbDrivesList.Location = New-Object System.Drawing.Point(130, 145)  # (x, y) position
    $tbDrivesList.Enabled = $false
    $gbOptionBox.Controls.Add($tbDrivesList)


    $lblDrivesList = New-Object System.Windows.Forms.Label
    $lblDrivesList.Text = "[Enter Drive Letters]"
    $lblDrivesList.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblDrivesList.ForeColor = [System.Drawing.Color]::Black
    $lblDrivesList.Width = 260
    $lblDrivesList.Location = New-Object System.Drawing.Point(130, 165)  # (x, y) position -> 25 pt down
    $lblDrivesList.TextAlign = "MiddleLeft"
    $gbOptionBox.Controls.Add($lblDrivesList)


    $cbKeyWordSearch = New-Object System.Windows.Forms.CheckBox
    $cbKeyWordSearch.Text = "Search Files by Keyword(s)"
    $cbKeyWordSearch.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbKeyWordSearch.Width = 195
    $cbKeyWordSearch.Location = New-Object System.Drawing.Point(10, 190)  # (x, y) position
    $gbOptionBox.Controls.Add($cbKeyWordSearch)

    $cbKeyWordSearch.Add_CheckedChanged({
            if ($cbKeyWordSearch.Checked) {
                $tbKeyWordsDrivesList.Enabled = $true
            }
            else {
                $tbKeyWordsDrivesList.Enabled = $false
            }
    })


    $tbKeyWordsDrivesList = New-Object System.Windows.Forms.TextBox
    $tbKeyWordsDrivesList.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbKeyWordsDrivesList.Width = 185
    $tbKeyWordsDrivesList.Location = New-Object System.Drawing.Point(205, 190)  # (x, y) position
    $tbKeyWordsDrivesList.Enabled = $false
    $gbOptionBox.Controls.Add($tbKeyWordsDrivesList)


    $lblKeyWords = New-Object System.Windows.Forms.Label
    $lblKeyWords.Text = "[Enter Drive Letters]"
    $lblKeyWords.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblKeyWords.ForeColor = [System.Drawing.Color]::Black
    $lblKeyWords.Width = 185
    $lblKeyWords.Location = New-Object System.Drawing.Point(205, 210)  # (x, y) position
    $lblKeyWords.TextAlign = "MiddleLeft"
    $gbOptionBox.Controls.Add($lblKeyWords)


    $cbHashFiles = New-Object System.Windows.Forms.CheckBox
    $cbHashFiles.Text = "Hash Results Files"
    $cbHashFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbHashFiles.Width = 250
    $cbHashFiles.Location = New-Object System.Drawing.Point(10, 235)  # (x, y) position
    $gbOptionBox.Controls.Add($cbHashFiles)


    $cbArchive = New-Object System.Windows.Forms.CheckBox
    $cbArchive.Text = "Create Case Archive"
    $cbArchive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbArchive.Width = 250
    $cbArchive.Location = New-Object System.Drawing.Point(10, 260)  # (x, y) position
    $gbOptionBox.Controls.Add($cbArchive)


    # Define a button for initiating the html report
    $btnHtmlReport = New-Object System.Windows.Forms.Button
    $btnHtmlReport.Text = "Html Output"
    $btnHtmlReport.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnHtmlReport.Width = 150
    $btnHtmlReport.Height = 50
    $btnHtmlReport.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnHtmlReport.Location = New-Object System.Drawing.Point(60, 460)  # (x, y) position -> Down 50 from last checkbox
    $btnHtmlReport.BackColor = "#1f618d"
    $btnHtmlReport.Forecolor = "#dddddd"
    $btnHtmlReport.Add_Click({

        $User = $tbUserName.Text
        $Agency = $tbAgency.Text
        $CaseNumber = $tbCaseNumber.Text
        $DriveList = $tbDrivesList.Text
        $KeyWordsDrivesList = $tbKeyWordsDrivesList.Text

            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -Processes $cbGetProcesses.Checked -GetRam $cbGetRam.Checked -Edd $cbEdd.Checked -Hives $cbRegHives.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -GetHtmlFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

        $Form.Close()
        return

    })
    # Add the button
    $Form.Controls.Add($btnHtmlReport)


    # Define a button for initiating the files report
    $btnCloseForm = New-Object Windows.Forms.Button
    $btnCloseForm.Text = "Close Form"
    $btnCloseForm.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnCloseForm.Width = 150
    $btnCloseForm.Height = 50
    $btnCloseForm.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnCloseForm.Location = New-Object Drawing.Point(240, 460)  # (x, y) position
    $btnCloseForm.BackColor = "#c0392b"
    $btnCloseForm.Forecolor = "#dddddd"
    $btnCloseForm.Add_Click({

        $Form.Close()
        return

        # $User = $tbUserName.Text
        # $Agency = $tbAgency.Text
        # $CaseNumber = $tbCaseNumber.Text

        # Get-TriageData -User $User -Agency $Agency -CaseNumber $CaseNumber

    })
    # Add the button
    $Form.Controls.Add($btnCloseForm)

    $Form.Add_Shown({$Form.Activate()})

    # Display the form
    [void]$Form.ShowDialog()
}


Export-ModuleMember -Function Get-Gui
