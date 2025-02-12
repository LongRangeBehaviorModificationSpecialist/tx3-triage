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


    # Define label and text boxes for source and destination directories
    $lblUserName = New-Object System.Windows.Forms.Label
    $lblUserName.Text = "User Name:"
    $lblUserName.Font = New-Object System.Drawing.Font("Arial", 11)  # , [System.Drawing.FontStyle]::Bold
    $lblUserName.ForeColor = [System.Drawing.Color]::Black
    $lblUserName.Width = 120
    $lblUserName.Location = New-Object System.Drawing.Point(10, 20)
    $Form.Controls.Add($lblUserName)


    $TextBoxUserName = New-Object System.Windows.Forms.TextBox
    $TextBoxUserName.Width = 250
    $TextBoxUserName.BorderStyle = FixedSingle
    $TextBoxUserName.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxUserName.Location = New-Object System.Drawing.Point(130, 20)
    $Form.Controls.Add($TextBoxUserName)


    $lblAgency = New-Object System.Windows.Forms.Label
    $lblAgency.Text = "Agency:"
    $lblAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblAgency.ForeColor = [System.Drawing.Color]::Black
    $lblAgency.Width = 120
    $lblAgency.Location = New-Object System.Drawing.Point(10, 55)
    $Form.Controls.Add($lblAgency)


    $TextBoxAgency = New-Object System.Windows.Forms.TextBox
    $TextBoxAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxAgency.Width = 250
    $TextBoxAgency.Location = New-Object System.Drawing.Point(130, 55)
    $Form.Controls.Add($TextBoxAgency)


    $lblCaseNumber = New-Object System.Windows.Forms.Label
    $lblCaseNumber.Text = "Case Number:"
    $lblCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblCaseNumber.ForeColor = [System.Drawing.Color]::Black
    $lblCaseNumber.Width = 120
    $lblCaseNumber.Location = New-Object Drawing.Point(10, 90)
    $Form.Controls.Add($lblCaseNumber)


    $TextBoxCaseNumber = New-Object System.Windows.Forms.TextBox
    $TextBoxCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxCaseNumber.Width = 250
    $TextBoxCaseNumber.Location = New-Object Drawing.Point(130, 90)
    $Form.Controls.Add($TextBoxCaseNumber)


    $HashCheckBox = New-Object System.Windows.Forms.CheckBox
    $HashCheckBox.Text = "Hash Html Results Files?"
    $HashCheckBox.Font = New-Object System.Drawing.Font("Arial", 10)
    $HashCheckBox.Width = 250
    $HashCheckBox.Location = New-Object Drawing.Point(130, 120)
    $Form.Controls.Add($HashCheckBox)


    # Define a button for initiating the html report
    $btnHtmlReport = New-Object System.Windows.Forms.Button
    $btnHtmlReport.Text = "Html Output"
    $btnHtmlReport.Font = New-Object System.Drawing.Font("Arial", 11)
    $btnHtmlReport.Width = 150
    $btnHtmlReport.Height = 50
    $btnHtmlReport.Padding = New-Object System.Windows.Forms.Padding(10)
    $btnHtmlReport.Location = New-Object Drawing.Point(10, 160)
    $btnHtmlReport.Add_Click({

        $User = $TextBoxUserName.Text
        $Agency = $TextBoxAgency.Text
        $CaseNumber = $TextBoxCaseNumber.Text



        if ($HashCheckBox.Checked) {
            write-host "Hash box was checked in the GUI" -ForegroundColor Yellow
            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -GetHtmlFileHashes $HashCheckBox.Checked
        }
        else {
            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6
        }


        $Form.Close()

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
    $btnFilesOutput.Location = New-Object Drawing.Point(180, 160)
    $btnFilesOutput.Add_Click({

        $User = $TextBoxUserName.Text
        $Agency = $TextBoxAgency.Text
        $CaseNumber = $TextBoxCaseNumber.Text

        Get-TriageData -User $User -Agency $Agency -CaseNumber $CaseNumber

        $Form.Close()

    })
    # Add the button
    $Form.Controls.Add($btnFilesOutput)

    # Display the form
    [void]$Form.ShowDialog()

}


Export-ModuleMember -Function Get-Gui
