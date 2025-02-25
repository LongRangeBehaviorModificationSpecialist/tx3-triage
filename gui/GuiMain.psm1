$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-Gui {

    # Load Windows Forms for GUI
    Add-Type -AssemblyName System.Windows.Forms

    # Define the form
    $Form = New-Object Windows.Forms.Form


    # Add title to the form window
    $Form.Text = "tx3-triage"
    $Form.Size = New-Object System.Drawing.Size(450, 775)  # width x height
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = "Sizable"
    $Form.TopMost = $false


    # Define label and text boxes for source and destination directories
    $lblUserName = New-Object System.Windows.Forms.Label
    $lblUserName.Text = "User Name:"
    $lblUserName.Font = New-Object System.Drawing.Font("Arial", 10)  # , [System.Drawing.FontStyle]::Bold
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
    $tbAgency.Multiline = $false
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
    $tbCaseNumber.Multiline = $false
    $tbCaseNumber.Font = New-Object System.Drawing.Font("Arial", 10)
    $tbCaseNumber.Width = 250
    $tbCaseNumber.Location = New-Object System.Drawing.Point(150, 90)  # (x, y) position
    $Form.Controls.Add($tbCaseNumber)


    $cbModuleBox = New-Object System.Windows.Forms.GroupBox
    $cbModuleBox.Text = "Select Modules"
    $cbModuleBox.Location = New-Object System.Drawing.Point(10, 125)  # (x, y) position
    $cbModuleBox.Size = New-Object System.Drawing.Size(410, 60)  # width x height
    $Form.Controls.Add($cbModuleBox)


    $cbOne = New-Object System.Windows.Forms.CheckBox
    $cbOne.Text = "1"
    $cbOne.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbOne.Width = 30
    $cbOne.Location = New-Object System.Drawing.Point(10, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbOne)


    $cbTwo = New-Object System.Windows.Forms.CheckBox
    $cbTwo.Text = "2"
    $cbTwo.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbTwo.Width = 30
    $cbTwo.Location = New-Object System.Drawing.Point(55, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbTwo)


    $cbThree = New-Object System.Windows.Forms.CheckBox
    $cbThree.Text = "3"
    $cbThree.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbThree.Width = 30
    $cbThree.Location = New-Object System.Drawing.Point(100, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbThree)


    $cbFour = New-Object System.Windows.Forms.CheckBox
    $cbFour.Text = "4"
    $cbFour.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbFour.Width = 30
    $cbFour.Location = New-Object System.Drawing.Point(145, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbFour)


    $cbFive = New-Object System.Windows.Forms.CheckBox
    $cbFive.Text = "5"
    $cbFive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbFive.Width = 30
    $cbFive.Location = New-Object System.Drawing.Point(190, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbFive)


    $cbSix = New-Object System.Windows.Forms.CheckBox
    $cbSix.Text = "6"
    $cbSix.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSix.Width = 30
    $cbSix.Location = New-Object System.Drawing.Point(235, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbSix)


    $cbSeven = New-Object System.Windows.Forms.CheckBox
    $cbSeven.Text = "7"
    $cbSeven.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSeven.Width = 30
    $cbSeven.Location = New-Object System.Drawing.Point(280, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbSeven)


    $cbEight = New-Object System.Windows.Forms.CheckBox
    $cbEight.Text = "8"
    $cbEight.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbEight.Width = 30
    $cbEight.Location = New-Object System.Drawing.Point(325, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbEight)


    $cbNine = New-Object System.Windows.Forms.CheckBox
    $cbNine.Text = "9"
    $cbNine.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbNine.Width = 30
    $cbNine.Location = New-Object System.Drawing.Point(370, 20)  # (x, y) position
    $cbModuleBox.Controls.Add($cbNine)


    $btnSelectAll = [System.Windows.Forms.Button]::new()
    $btnSelectAll = New-Object System.Windows.Forms.Button
    $btnSelectAll.Text = "Select All Modules"
    $btnSelectAll.Font = New-Object System.Drawing.Font("Arial", 11)  # , [System.Drawing.FontStyle]::Bold
    $btnSelectAll.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnSelectAll.Width = 200
    $btnSelectAll.Height = 30
    $btnSelectAll.Padding = New-Object System.Windows.Forms.Padding(3)
    $btnSelectAll.Location = New-Object Drawing.Point(115, 190)  # (x, y) position
    $btnSelectAll.FlatAppearance.BorderSize = 1
    $btnSelectAll.FlatAppearance.BorderColor = [System.Drawing.Color]::Black
    $btnSelectAll.BackColor = "#555555"
    $btnSelectAll.Forecolor = "#eeeeee"
    $btnSelectAll.Add_Click({

            $cbOne.Checked = $true
            $cbTwo.Checked = $true
            $cbThree.Checked = $true
            $cbFour.Checked = $true
            $cbFive.Checked = $true
            $cbSix.Checked = $true
            $cbSeven.Checked = $true
            $cbEight.Checked = $true
            $cbNine.Checked = $true

        })
    $Form.Controls.Add($btnSelectAll)


    $lblDeviceDesc = New-Object System.Windows.Forms.Label
    $lblDeviceDesc.Text = "1 = Device Info  |  2 = User Info`n3 = Network Data  |  4 = Processes`n5 = System Data  |  6 = Prefetch Data`n7 = Event Log Data  |  8 = Firewall Data`n9 = BitLocker Data"
    $lblDeviceDesc.Font = New-Object System.Drawing.Font("Arial", 10)
    $lblDeviceDesc.ForeColor = [System.Drawing.Color]::Black
    $lblDeviceDesc.BackColor = "#cccccc"
    $lblDeviceDesc.Location = New-Object System.Drawing.Point(10, 225)  # (x, y) position
    $lblDeviceDesc.Size = New-Object System.Drawing.Size(410, 100)  # width x height
    $lblDeviceDesc.TextAlign = "MiddleCenter"
    $Form.Controls.Add($lblDeviceDesc)


    $gbOptionBox = New-Object System.Windows.Forms.GroupBox
    $gbOptionBox.Text = "Select Options"
    $gbOptionBox.Location = New-Object System.Drawing.Point(10, 330)  # (x, y) position
    $gbOptionBox.Size = New-Object System.Drawing.Size(410, 325)  # width x height
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
    $lblDrivesList.Text = "[Enter Drive Letter(s)]"
    $lblDrivesList.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblDrivesList.ForeColor = [System.Drawing.Color]::Blue
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
    $lblKeyWords.Text = "[Enter Drive Letter(s)]"
    $lblKeyWords.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblKeyWords.ForeColor = [System.Drawing.Color]::Blue
    $lblKeyWords.Width = 185
    $lblKeyWords.Location = New-Object System.Drawing.Point(205, 210)  # (x, y) position
    $lblKeyWords.TextAlign = "MiddleLeft"
    $gbOptionBox.Controls.Add($lblKeyWords)


    $cbSruDb = New-Object System.Windows.Forms.CheckBox
    $cbSruDb.Text = "Copy SRUDB.dat File"
    $cbSruDb.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSruDb.Width = 250
    $cbSruDb.Location = New-Object System.Drawing.Point(10, 235)  # (x, y) position
    $gbOptionBox.Controls.Add($cbSruDb)


    $cbHashFiles = New-Object System.Windows.Forms.CheckBox
    $cbHashFiles.Text = "Hash Results Files"
    $cbHashFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbHashFiles.Width = 250
    $cbHashFiles.Location = New-Object System.Drawing.Point(10, 260)  # (x, y) position
    $gbOptionBox.Controls.Add($cbHashFiles)


    $cbArchive = New-Object System.Windows.Forms.CheckBox
    $cbArchive.Text = "Create Case Archive"
    $cbArchive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbArchive.Width = 250
    $cbArchive.Location = New-Object System.Drawing.Point(10, 285)  # (x, y) position
    $gbOptionBox.Controls.Add($cbArchive)


    # Define a button for initiating the html report
    $btnHtmlReport           = [System.Windows.Forms.Button]::new()
    $btnHtmlReport.Name      = "btnHtmlReport"
    $btnHtmlReport.Text      = "Html Output"
    $btnHtmlReport.Font      = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnHtmlReport.Width     = 124
    $btnHtmlReport.Height    = 40
    $btnHtmlReport.Padding   = New-Object System.Windows.Forms.Padding(5)
    $btnHtmlReport.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnHtmlReport.Location  = New-Object System.Drawing.Point(10, 665)  # (x, y) position -> Down 50 from last checkbox
    $btnHtmlReport.FlatAppearance.BorderSize = 1
    $btnHtmlReport.FlatAppearance.BorderColor = [System.Drawing.Color]::black
    $btnHtmlReport.BackColor = "#1f618d"
    $btnHtmlReport.Forecolor = "#dddddd"
    # $btnHtmlReport.Add_MouseEnter({

    #         $this.BackColor = [System.Drawing.Color]::CadetBlue
    #         $this.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Underline)
    #         $this.FlatAppearance.BorderSize = 1
    #         $this.FlatAppearance.BorderColor = [System.Drawing.Color]::black

    # })

    # $btnHtmlReport.Add_MouseLeave({

    #         $this.ForeColor = "#dddddd"
    #         $this.BackColor = "#1f618d"
    #         $this.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    #         $this.FlatAppearance.BorderSize = 1
    #         $this.FlatAppearance.BorderColor = [System.Drawing.Color]::black

    #     })
    $btnHtmlReport.Add_Click({

        $User = $tbUserName.Text
        $Agency = $tbAgency.Text
        $CaseNumber = $tbCaseNumber.Text
        $DriveList = $tbDrivesList.Text
        $KeyWordsDrivesList = $tbKeyWordsDrivesList.Text

            Export-HtmlReport -CaseFolderName $CaseFolderName -User $User -Agency $Agency -CaseNumber $CaseNumber -ComputerName $ComputerName -Ipv4 $Ipv4 -Ipv6 $Ipv6 -Device $cbOne.Checked -UserData $cbTwo.Checked -Network $cbThree.Checked -Process $cbFour.Checked -System $cbFive.Checked -Prefetch $cbSix.Checked -EventLogs $cbSeven.Checked -Firewall $cbEight.Checked -BitLocker $cbNine.Checked -CaptureProcesses $cbGetProcesses.Checked -GetRam $cbGetRam.Checked -Edd $cbEdd.Checked -Hives $cbRegHives.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -CopySrum $cbSruDb.Checked -GetFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

        $Form.Close()
        return

    })
    # Add the button
    $Form.Controls.Add($btnHtmlReport)



    # Define a button for initiating the files only report
    $btnFilesReport = [System.Windows.Forms.Button]::new()
    $btnFilesReport.Name = "btnFilesReport"
    $btnFilesReport.Text = "Files Output"
    $btnFilesReport.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnFilesReport.Width = 124
    $btnFilesReport.Height = 40
    $btnFilesReport.Padding = New-Object System.Windows.Forms.Padding(5)
    $btnFilesReport.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnFilesReport.Location = New-Object System.Drawing.Point(153, 665)  # (x, y) position -> Down 50 from last checkbox
    $btnFilesReport.FlatAppearance.BorderSize = 1
    $btnFilesReport.FlatAppearance.BorderColor = [System.Drawing.Color]::Black
    $btnFilesReport.BackColor = "#17a589"
    $btnFilesReport.Forecolor = "#dddddd"
    $btnFilesReport.Add_Click({

            $User = $tbUserName.Text
            $Agency = $tbAgency.Text
            $CaseNumber = $tbCaseNumber.Text
            $DriveList = $tbDrivesList.Text
            $KeyWordsDrivesList = $tbKeyWordsDrivesList.Text

            Export-FilesReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -Device $cbOne.Checked -UserData $cbTwo.Checked -Network $cbThree.Checked -Process $cbFour.Checked -System $cbFive.Checked -Prefetch $cbSix.Checked -EventLogs $cbSeven.Checked -Firewall $cbEight.Checked -BitLocker $cbNine.Checked -CaptureProcesses $cbGetProcesses.Checked -GetRam $cbGetRam.Checked -Edd $cbEdd.Checked -Hives $cbRegHives.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -GetFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

            $Form.Close()
            return

    })
    # Add the button
    $Form.Controls.Add($btnFilesReport)


    # Define a button for initiating the files report
    $btnQuit = New-Object Windows.Forms.Button
    $btnQuit.Text = "Quit"
    $btnQuit.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnQuit.Width = 124
    $btnQuit.Height = 40
    $btnQuit.Padding = New-Object System.Windows.Forms.Padding(5)
    $btnQuit.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnQuit.Location = New-Object Drawing.Point(296, 665)  # (x, y) position
    $btnQuit.FlatAppearance.BorderSize = 1
    $btnQuit.FlatAppearance.BorderColor = [System.Drawing.Color]::Black
    $btnQuit.BackColor = "#c0392b"
    $btnQuit.Forecolor = "#dddddd"
    $btnQuit.Add_Click({

        $Form.Close()
        return

    })
    # Add the button
    $Form.Controls.Add($btnQuit)

    $Form.Add_Shown({$Form.Activate()})

    # Display the form
    [void]$Form.ShowDialog()
}


Export-ModuleMember -Function Get-Gui
