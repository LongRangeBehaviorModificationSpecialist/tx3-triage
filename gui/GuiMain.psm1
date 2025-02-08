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
    $LabelUserName = New-Object System.Windows.Forms.Label
    $LabelUserName.Text = "User Name:"
    $LabelUserName.Font = New-Object System.Drawing.Font("Arial", 12)  # , [System.Drawing.FontStyle]::Bold
    $LabelUserName.ForeColor = [System.Drawing.Color]::Black
    $LabelUserName.Width = 120
    $LabelUserName.Location = New-Object System.Drawing.Point(10, 20)
    $Form.Controls.Add($LabelUserName)


    $TextBoxUserName = New-Object System.Windows.Forms.TextBox
    $TextBoxUserName.Width = 250
    $TextBoxUserName.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxUserName.Location = New-Object System.Drawing.Point(130, 20)
    $Form.Controls.Add($TextBoxUserName)


    $LabelAgency = New-Object System.Windows.Forms.Label
    $LabelAgency.Text = "Agency:"
    $LabelAgency.Font = New-Object System.Drawing.Font("Arial", 12)
    $LabelUserName.ForeColor = [System.Drawing.Color]::Black
    $LabelAgency.Width = 120
    $LabelAgency.Location = New-Object System.Drawing.Point(10, 55)
    $Form.Controls.Add($LabelAgency)


    $TextBoxAgency = New-Object System.Windows.Forms.TextBox
    $TextBoxAgency.Width = 250
    $TextBoxAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxAgency.Location = New-Object System.Drawing.Point(130, 55)
    $Form.Controls.Add($TextBoxAgency)


    $LabelCaseNumber = New-Object Windows.Forms.Label
    $LabelCaseNumber.Text = "Case Number:"
    $LabelCaseNumber.Font = New-Object System.Drawing.Font("Arial", 12)
    $LabelUserName.ForeColor = [System.Drawing.Color]::Black
    $LabelCaseNumber.Width = 120
    $LabelCaseNumber.Location = New-Object Drawing.Point(10, 90)
    $Form.Controls.Add($LabelCaseNumber)


    $TextBoxCaseNumber = New-Object Windows.Forms.TextBox
    $TextBoxCaseNumber.Width = 250
    $TextBoxCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $TextBoxCaseNumber.Location = New-Object Drawing.Point(130, 90)
    $Form.Controls.Add($TextBoxCaseNumber)


    # Radio button group
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Text = "Select an Output Format"
    $groupBox.Font = New-Object System.Drawing.Font("Arial", 11)
    $groupBox.Location = New-Object System.Drawing.Point(10, 125)
    $groupBox.Size = New-Object System.Drawing.Size(370, 65)
    $form.Controls.Add($groupBox)


    $htmlButton = New-Object System.Windows.Forms.RadioButton
    $htmlButton.Text = "Html Output"
    $htmlButton.Width = 185
    $htmlButton.Location = New-Object System.Drawing.Point(10, 25)
    $groupBox.Controls.Add($htmlButton)


    $filesButton = New-Object System.Windows.Forms.RadioButton
    $filesButton.Text = "Files Output"
    $filesButton.Width = 185
    $filesButton.Location = New-Object System.Drawing.Point(195, 25)
    $groupBox.Controls.Add($filesButton)


    # Define a button for initiating the copy and hash verification
    $ButtonCopy = New-Object Windows.Forms.Button
    $ButtonCopy.Text = "Run Function"
    $ButtonCopy.Font = New-Object System.Drawing.Font("Arial", 11)
    $ButtonCopy.Width = 150
    $ButtonCopy.Height = 50
    $ButtonCopy.Padding = New-Object System.Windows.Forms.Padding(10)
    $ButtonCopy.Location = New-Object Drawing.Point(10, 220)
    $ButtonCopy.Add_Click({

        $User = $TextBoxUserName.Text
        $Agency = $TextBoxAgency.Text
        $CaseNumber = $TextBoxCaseNumber.Text

        if ($htmlButton)
        {
            Export-HtmlReport $CaseFolderName $ComputerName $Date $Time $Ipv4 $Ipv6 $User $Agency $CaseNumber
            $Form.Close()
        }

        if ($filesButton)
        {
            Get-TriageData
            $Form.Close()
        }
    })
    # Add the button
    $Form.Controls.Add($ButtonCopy)

    # Display the form
    [void]$Form.ShowDialog()
}


Export-ModuleMember -Function Get-Gui
