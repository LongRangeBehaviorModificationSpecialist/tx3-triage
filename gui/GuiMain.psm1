$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-Gui {

    # Load Windows Forms for GUI
    Add-Type -AssemblyName System.Windows.Forms

    # Define the form
    $Form = New-Object Windows.Forms.Form


    # Add title to the form window
    $Form.Text = "tx3-triage"
    $Form.Size = New-Object System.Drawing.Size(410, 490)  # width x height
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = "Sizable"


    # Define label and text boxes for source and destination directories
    $lblUserName = New-Object System.Windows.Forms.Label
    $lblUserName.Text = "User Name:"
    $lblUserName.Font = New-Object System.Drawing.Font("Arial", 11)  # , [System.Drawing.FontStyle]::Bold
    $lblUserName.ForeColor = [System.Drawing.Color]::Black
    $lblUserName.Width = 120
    $lblUserName.Location = New-Object System.Drawing.Point(10, 20)  # (x, y) position
    $Form.Controls.Add($lblUserName)


    $tbUserName = New-Object System.Windows.Forms.TextBox
    $tbUserName.Width = 250
    $tbUserName.BorderStyle = FixedSingle
    $tbUserName.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbUserName.Location = New-Object System.Drawing.Point(130, 20)  # (x, y) position
    $Form.Controls.Add($tbUserName)


    $lblAgency = New-Object System.Windows.Forms.Label
    $lblAgency.Text = "Agency:"
    $lblAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblAgency.ForeColor = [System.Drawing.Color]::Black
    $lblAgency.Width = 120
    $lblAgency.Location = New-Object System.Drawing.Point(10, 55)  # (x, y) position
    $Form.Controls.Add($lblAgency)


    $tbAgency = New-Object System.Windows.Forms.TextBox
    $tbAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbAgency.Width = 250
    $tbAgency.Location = New-Object System.Drawing.Point(130, 55)  # (x, y) position
    $Form.Controls.Add($tbAgency)


    $lblCaseNumber = New-Object System.Windows.Forms.Label
    $lblCaseNumber.Text = "Case Number:"
    $lblCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblCaseNumber.ForeColor = [System.Drawing.Color]::Black
    $lblCaseNumber.Width = 120
    $lblCaseNumber.Location = New-Object Drawing.Point(10, 90)  # (x, y) position
    $Form.Controls.Add($lblCaseNumber)


    $tbCaseNumber = New-Object System.Windows.Forms.TextBox
    $tbCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbCaseNumber.Width = 250
    $tbCaseNumber.Location = New-Object Drawing.Point(130, 90)  # (x, y) position
    $Form.Controls.Add($tbCaseNumber)


    $cbEdd = New-Object System.Windows.Forms.CheckBox
    $cbEdd.Text = "Run Encrypted Disk Detector"
    $cbEdd.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbEdd.Width = 250
    $cbEdd.Location = New-Object Drawing.Point(130, 120)  # (x, y) position
    $Form.Controls.Add($cbEdd)


    $cbNTUserDat = New-Object System.Windows.Forms.CheckBox
    $cbNTUserDat.Text = "Copy NTUSER.DAT files"
    $cbNTUserDat.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbNTUserDat.Width = 250
    $cbNTUserDat.Location = New-Object Drawing.Point(130, 150)  # (x, y) position
    $Form.Controls.Add($cbNTUserDat)


    $cbListFiles = New-Object System.Windows.Forms.CheckBox
    $cbListFiles.Text = "List ALL Files"
    $cbListFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbListFiles.Width = 250
    $cbListFiles.Location = New-Object Drawing.Point(130, 180)  # (x, y) position
    $Form.Controls.Add($cbListFiles)


    $tbDrivesList = New-Object System.Windows.Forms.TextBox
    $tbDrivesList.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbDrivesList.Width = 250
    $tbDrivesList.Location = New-Object Drawing.Point(130, 205)  # (x, y) position
    $Form.Controls.Add($tbDrivesList)


    $cbKeyWordSearch = New-Object System.Windows.Forms.CheckBox
    $cbKeyWordSearch.Text = "Search Files by Keyword(s)"
    $cbKeyWordSearch.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbKeyWordSearch.Width = 250
    $cbKeyWordSearch.Location = New-Object Drawing.Point(130, 235)  # (x, y) position
    $Form.Controls.Add($cbKeyWordSearch)


    $tbKeyWordsDrivesList = New-Object System.Windows.Forms.TextBox
    $tbKeyWordsDrivesList.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbKeyWordsDrivesList.Width = 250
    $tbKeyWordsDrivesList.Location = New-Object Drawing.Point(130, 260)  # (x, y) position
    $Form.Controls.Add($tbKeyWordsDrivesList)


    $cbHashFiles = New-Object System.Windows.Forms.CheckBox
    $cbHashFiles.Text = "Hash Html Results Files"
    $cbHashFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbHashFiles.Width = 250
    $cbHashFiles.Location = New-Object Drawing.Point(130, 290)  # (x, y) position
    $Form.Controls.Add($cbHashFiles)


    $cbArchive = New-Object System.Windows.Forms.CheckBox
    $cbArchive.Text = "Create Case Archive"
    $cbArchive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbArchive.Width = 250
    $cbArchive.Location = New-Object Drawing.Point(130, 320)  # (x, y) position
    $Form.Controls.Add($cbArchive)


    # Define a button for initiating the html report
    $btnHtmlReport = New-Object System.Windows.Forms.Button
    $btnHtmlReport.Text = "Html Output"
    $btnHtmlReport.Font = New-Object System.Drawing.Font("Arial", 11)
    $btnHtmlReport.Width = 150
    $btnHtmlReport.Height = 50
    $btnHtmlReport.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnHtmlReport.Location = New-Object Drawing.Point(130, 370)  # (x, y) position -> Down 40 from last checkbox
    $btnHtmlReport.Add_Click({

        $User = $tbUserName.Text
        $Agency = $tbAgency.Text
        $CaseNumber = $tbCaseNumber.Text
        $DriveList = $tbDrivesList.Text
        $KeyWordsDrivesList = $tbKeyWordsDrivesList.Text

            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -Edd $cbEdd.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -GetHtmlFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

        $Form.Close()
        return

    })
    # Add the button
    $Form.Controls.Add($btnHtmlReport)


    # # Define a button for initiating the files report
    # $btnFilesOutput = New-Object Windows.Forms.Button
    # $btnFilesOutput.Text = "Files Output"
    # $btnFilesOutput.Font = New-Object System.Drawing.Font("Arial", 11)
    # $btnFilesOutput.Width = 150
    # $btnFilesOutput.Height = 50
    # $btnFilesOutput.Padding = New-Object System.Windows.Forms.Padding(10)
    # $btnFilesOutput.Location = New-Object Drawing.Point(180, 250)  # (x, y) position
    # $btnFilesOutput.Add_Click({

    #     $User = $tbUserName.Text
    #     $Agency = $tbAgency.Text
    #     $CaseNumber = $tbCaseNumber.Text

    #     Get-TriageData -User $User -Agency $Agency -CaseNumber $CaseNumber

    # })
    # # Add the button
    # $Form.Controls.Add($btnFilesOutput)

    # Display the form
    [void]$Form.ShowDialog()
}


Export-ModuleMember -Function Get-Gui
