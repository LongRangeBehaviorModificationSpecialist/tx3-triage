$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-Gui {

    # Load Windows Forms for GUI
    Add-Type -AssemblyName System.Windows.Forms

    # Define the form
    $Form = New-Object Windows.Forms.Form


    # Add title to the form window
    $Form.Text = "tx3-triage"
    $Form.Size = New-Object System.Drawing.Size(410, 400)  # width x height
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


    $TextBoxUserName = New-Object System.Windows.Forms.TextBox
    $TextBoxUserName.Width = 250
    $TextBoxUserName.BorderStyle = FixedSingle
    $TextBoxUserName.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxUserName.Location = New-Object System.Drawing.Point(130, 20)  # (x, y) position
    $Form.Controls.Add($TextBoxUserName)


    $lblAgency = New-Object System.Windows.Forms.Label
    $lblAgency.Text = "Agency:"
    $lblAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblAgency.ForeColor = [System.Drawing.Color]::Black
    $lblAgency.Width = 120
    $lblAgency.Location = New-Object System.Drawing.Point(10, 55)  # (x, y) position
    $Form.Controls.Add($lblAgency)


    $TextBoxAgency = New-Object System.Windows.Forms.TextBox
    $TextBoxAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxAgency.Width = 250
    $TextBoxAgency.Location = New-Object System.Drawing.Point(130, 55)  # (x, y) position
    $Form.Controls.Add($TextBoxAgency)


    $lblCaseNumber = New-Object System.Windows.Forms.Label
    $lblCaseNumber.Text = "Case Number:"
    $lblCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblCaseNumber.ForeColor = [System.Drawing.Color]::Black
    $lblCaseNumber.Width = 120
    $lblCaseNumber.Location = New-Object Drawing.Point(10, 90)  # (x, y) position
    $Form.Controls.Add($lblCaseNumber)


    $TextBoxCaseNumber = New-Object System.Windows.Forms.TextBox
    $TextBoxCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxCaseNumber.Width = 250
    $TextBoxCaseNumber.Location = New-Object Drawing.Point(130, 90)  # (x, y) position
    $Form.Controls.Add($TextBoxCaseNumber)


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


    $cbHashFiles = New-Object System.Windows.Forms.CheckBox
    $cbHashFiles.Text = "Hash Html Results Files"
    $cbHashFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbHashFiles.Width = 250
    $cbHashFiles.Location = New-Object Drawing.Point(130, 180)  # (x, y) position
    $Form.Controls.Add($cbHashFiles)


    $cbArchive = New-Object System.Windows.Forms.CheckBox
    $cbArchive.Text = "Create Case Archive"
    $cbArchive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbArchive.Width = 250
    $cbArchive.Location = New-Object Drawing.Point(130, 210)  # (x, y) position
    $Form.Controls.Add($cbArchive)


    # Define a button for initiating the html report
    $btnHtmlReport = New-Object System.Windows.Forms.Button
    $btnHtmlReport.Text = "Html Output"
    $btnHtmlReport.Font = New-Object System.Drawing.Font("Arial", 11)
    $btnHtmlReport.Width = 150
    $btnHtmlReport.Height = 50
    $btnHtmlReport.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnHtmlReport.Location = New-Object Drawing.Point(10, 250)  # (x, y) position -- Down 40 from last checkbox
    $btnHtmlReport.Add_Click({

        $User = $TextBoxUserName.Text
        $Agency = $TextBoxAgency.Text
        $CaseNumber = $TextBoxCaseNumber.Text

            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -Edd $cbEdd.Checked -GetNTUserDat $cbNTUserDat.Checked -GetHtmlFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

    })
    # Add the button
    $Form.Controls.Add($btnHtmlReport)


    # Define a button for initiating the files report
    $btnFilesOutput = New-Object Windows.Forms.Button
    $btnFilesOutput.Text = "Files Output"
    $btnFilesOutput.Font = New-Object System.Drawing.Font("Arial", 11)
    $btnFilesOutput.Width = 150
    $btnFilesOutput.Height = 50
    $btnFilesOutput.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnFilesOutput.Location = New-Object Drawing.Point(180, 250)  # (x, y) position
    $btnFilesOutput.Add_Click({

        $User = $TextBoxUserName.Text
        $Agency = $TextBoxAgency.Text
        $CaseNumber = $TextBoxCaseNumber.Text

        Get-TriageData -User $User -Agency $Agency -CaseNumber $CaseNumber

    })
    # Add the button
    $Form.Controls.Add($btnFilesOutput)

    # Display the form
    [void]$Form.ShowDialog()

}


Export-ModuleMember -Function Get-Gui
