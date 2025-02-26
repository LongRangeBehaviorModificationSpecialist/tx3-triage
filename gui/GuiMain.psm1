$ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue


function Get-Gui {

    # Load Windows Forms for GUI
    Add-Type -AssemblyName System.Windows.Forms

    # Define the form
    $Form = New-Object Windows.Forms.Form


    # Add title to the form window
    $Form.Text = "tx3-triage"
    $Form.Size = New-Object System.Drawing.Size(880, 480)  # width x height
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = "Sizable"
    $Form.TopMost = $false


    # $redPen = New-Object System.Windows.Forms.Label
    # $redPen.BackColor = [System.Drawing.Color]::Red
    # $redPen.Location = New-Object System.Drawing.Point(440, 5)  # (x, y) position
    # $redPen.Size = New-Object System.Drawing.Size(410, 1)  # width x height
    # $Form.Controls.Add($redPen)

    # $orangePen = New-Object System.Windows.Forms.Label
    # $orangePen.BackColor = [System.Drawing.Color]::Orange
    # $orangePen.Location = New-Object System.Drawing.Point(10, 5)  # (x, y) position
    # $orangePen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($orangePen)

    # $greenPen = New-Object System.Windows.Forms.Label
    # $greenPen.BackColor = [System.Drawing.Color]::Green
    # $greenPen.Location = New-Object System.Drawing.Point(97.5, 10)  # (x, y) position
    # $greenPen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($greenPen)

    # $green2Pen = New-Object System.Windows.Forms.Label
    # $green2Pen.BackColor = [System.Drawing.Color]::Green
    # $green2Pen.Location = New-Object System.Drawing.Point(247.5, 10)  # (x, y) position
    # $green2Pen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($green2Pen)

    # $bluePen = New-Object System.Windows.Forms.Label
    # $bluePen.BackColor = [System.Drawing.Color]::Blue
    # $bluePen.Location = New-Object System.Drawing.Point(345, 10)  # (x, y) position
    # $bluePen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($bluePen)

    # $blue2Pen = New-Object System.Windows.Forms.Label
    # $blue2Pen.BackColor = [System.Drawing.Color]::Blue
    # $blue2Pen.Location = New-Object System.Drawing.Point(495, 10)  # (x, y) position
    # $blue2Pen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($blue2Pen)

    # $red2Pen = New-Object System.Windows.Forms.Label
    # $red2Pen.BackColor = [System.Drawing.Color]::Red
    # $red2Pen.Location = New-Object System.Drawing.Point(592.5, 5)  # (x, y) position
    # $red2Pen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($red2Pen)

    # $red3Pen = New-Object System.Windows.Forms.Label
    # $red3Pen.BackColor = [System.Drawing.Color]::Red
    # $red3Pen.Location = New-Object System.Drawing.Point(742.5, 5)  # (x, y) position
    # $red3Pen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($red3Pen)

    # $orange2Pen = New-Object System.Windows.Forms.Label
    # $orange2Pen.BackColor = [System.Drawing.Color]::Orange
    # $orange2Pen.Location = New-Object System.Drawing.Point(850, 5)  # (x, y) position
    # $orange2Pen.Size = New-Object System.Drawing.Size(1, 600)  # width x height
    # $Form.Controls.Add($orange2Pen)

    # $vline1 = New-Object System.Windows.Forms.Label
    # $vline1.BackColor = [System.Drawing.Color]::Black
    # $vline1.Location = New-Object System.Drawing.Point(10, 500)  # (x, y) position
    # $vline1.Size = New-Object System.Drawing.Size(840, 1)  # width x height
    # $Form.Controls.Add($vline1)


    # Define label and text boxes for source and destination directories
    $lblUserName = New-Object System.Windows.Forms.Label
    $lblUserName.Text = "User Name:"
    $lblUserName.Font = New-Object System.Drawing.Font("Arial", 11)  # , [System.Drawing.FontStyle]::Bold
    $lblUserName.ForeColor = [System.Drawing.Color]::Black
    $lblUserName.Location = New-Object System.Drawing.Point(10, 15)  # (x, y) position
    $lblUserName.Size = New-Object System.Drawing.Size(120, 25)  # width x height
    $lblUserName.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblUserName)

    $tbUserName = New-Object System.Windows.Forms.TextBox
    $tbUserName.Multiline = $false
    $tbUserName.Width = 290
    $tbUserName.BorderStyle = FixedSingle
    $tbUserName.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbUserName.Location = New-Object System.Drawing.Point(130, 15)  # (x, y) position
    $Form.Controls.Add($tbUserName)


    $lblAgency = New-Object System.Windows.Forms.Label
    $lblAgency.Text = "Agency:"
    $lblAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblAgency.ForeColor = [System.Drawing.Color]::Black
    $lblAgency.Location = New-Object System.Drawing.Point(10, 50)  # (x, y) position
    $lblAgency.Size = New-Object System.Drawing.Size(120, 25)  # width x height
    $lblAgency.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblAgency)

    $tbAgency = New-Object System.Windows.Forms.TextBox
    $tbAgency.Multiline = $false
    $tbAgency.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbAgency.Width = 290
    $tbAgency.Location = New-Object System.Drawing.Point(130, 50)  # (x, y) position
    $Form.Controls.Add($tbAgency)


    $lblCaseNumber = New-Object System.Windows.Forms.Label
    $lblCaseNumber.Text = "Case Number:"
    $lblCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $lblCaseNumber.ForeColor = [System.Drawing.Color]::Black
    $lblCaseNumber.Width = 120
    $lblCaseNumber.Location = New-Object System.Drawing.Point(10, 85)  # (x, y) position
    $lblCaseNumber.Size = New-Object System.Drawing.Size(120, 25)  # width x height
    $lblCaseNumber.TextAlign = "MiddleLeft"
    $Form.Controls.Add($lblCaseNumber)

    $tbCaseNumber = New-Object System.Windows.Forms.TextBox
    $tbCaseNumber.Multiline = $false
    $tbCaseNumber.Font = New-Object System.Drawing.Font("Arial", 11)
    $tbCaseNumber.Width = 290
    $tbCaseNumber.Location = New-Object System.Drawing.Point(130, 85)  # (x, y) position
    $Form.Controls.Add($tbCaseNumber)


    $cbModuleBox = New-Object System.Windows.Forms.GroupBox
    $cbModuleBox.Text = "SELECT MODULES TO RUN"
    $cbModuleBox.Location = New-Object System.Drawing.Point(10, 125)  # (x, y) position
    $cbModuleBox.Size = New-Object System.Drawing.Size(410, 235)  # width x height
    $Form.Controls.Add($cbModuleBox)


    $cbOne = New-Object System.Windows.Forms.CheckBox
    $cbOne.Text = "1"
    $cbOne.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbOne.Width = 30
    $cbOne.Location = New-Object System.Drawing.Point(10, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbOne)


    $cbTwo = New-Object System.Windows.Forms.CheckBox
    $cbTwo.Text = "2"
    $cbTwo.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbTwo.Width = 30
    $cbTwo.Location = New-Object System.Drawing.Point(55, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbTwo)


    $cbThree = New-Object System.Windows.Forms.CheckBox
    $cbThree.Text = "3"
    $cbThree.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbThree.Width = 30
    $cbThree.Location = New-Object System.Drawing.Point(100, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbThree)


    $cbFour = New-Object System.Windows.Forms.CheckBox
    $cbFour.Text = "4"
    $cbFour.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbFour.Width = 30
    $cbFour.Location = New-Object System.Drawing.Point(145, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbFour)


    $cbFive = New-Object System.Windows.Forms.CheckBox
    $cbFive.Text = "5"
    $cbFive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbFive.Width = 30
    $cbFive.Location = New-Object System.Drawing.Point(190, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbFive)


    $cbSix = New-Object System.Windows.Forms.CheckBox
    $cbSix.Text = "6"
    $cbSix.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSix.Width = 30
    $cbSix.Location = New-Object System.Drawing.Point(235, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbSix)


    $cbSeven = New-Object System.Windows.Forms.CheckBox
    $cbSeven.Text = "7"
    $cbSeven.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSeven.Width = 30
    $cbSeven.Location = New-Object System.Drawing.Point(280, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbSeven)


    $cbEight = New-Object System.Windows.Forms.CheckBox
    $cbEight.Text = "8"
    $cbEight.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbEight.Width = 30
    $cbEight.Location = New-Object System.Drawing.Point(325, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbEight)


    $cbNine = New-Object System.Windows.Forms.CheckBox
    $cbNine.Text = "9"
    $cbNine.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbNine.Width = 30
    $cbNine.Location = New-Object System.Drawing.Point(370, 25)  # (x, y) position
    $cbModuleBox.Controls.Add($cbNine)


    $btnSelectAll = [System.Windows.Forms.Button]::new()
    $btnSelectAll = New-Object System.Windows.Forms.Button
    $btnSelectAll.Text = "Select All Modules"
    $btnSelectAll.Font = New-Object System.Drawing.Font("Arial", 11)  # , [System.Drawing.FontStyle]::Bold
    $btnSelectAll.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnSelectAll.Width = 160
    $btnSelectAll.Height = 30
    $btnSelectAll.Padding = New-Object System.Windows.Forms.Padding(3)
    $btnSelectAll.Location = New-Object Drawing.Point(125, 65)  # (x, y) position
    $btnSelectAll.FlatAppearance.BorderSize = 1
    $btnSelectAll.FlatAppearance.BorderColor = [System.Drawing.Color]::Black
    $btnSelectAll.BackColor = "#555555"
    $btnSelectAll.Forecolor = "#EEEEEE"
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
    $cbModuleBox.Controls.Add($btnSelectAll)


    $lblDeviceDesc = New-Object System.Windows.Forms.Label
    $lblDeviceDesc.Text = "1 = Device Info  |  2 = User Info`n3 = Network Data  |  4 = Processes`n5 = System Data  |  6 = Prefetch Data`n7 = Event Log Data  |  8 = Firewall Data`n9 = BitLocker Data"
    $lblDeviceDesc.Font = New-Object System.Drawing.Font("Arial", 10)
    $lblDeviceDesc.ForeColor = [System.Drawing.Color]::Black
    $lblDeviceDesc.BackColor = "#CCCCCC"
    $lblDeviceDesc.Location = New-Object System.Drawing.Point(10, 110)  # (x, y) position
    $lblDeviceDesc.Size = New-Object System.Drawing.Size(390, 100)  # width x height
    $lblDeviceDesc.TextAlign = "MiddleCenter"
    $cbModuleBox.Controls.Add($lblDeviceDesc)


    $gbOptionBox = New-Object System.Windows.Forms.GroupBox
    $gbOptionBox.Text = "OTHER OPTIONS"
    $gbOptionBox.Location = New-Object System.Drawing.Point(440, 10)  # (x, y) position
    $gbOptionBox.Size = New-Object System.Drawing.Size(410, 350)  # width x height
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


    $cbPrefetch = New-Object System.Windows.Forms.CheckBox
    $cbPrefetch.Text = "Copy Prefetch files"
    $cbPrefetch.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbPrefetch.Width = 250
    $cbPrefetch.Location = New-Object System.Drawing.Point(10, 120)  # (x, y) position
    $gbOptionBox.Controls.Add($cbPrefetch)


    $cbNTUserDat = New-Object System.Windows.Forms.CheckBox
    $cbNTUserDat.Text = "Copy NTUSER.DAT file(s)"
    $cbNTUserDat.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbNTUserDat.Width = 250
    $cbNTUserDat.Location = New-Object System.Drawing.Point(10, 145)  # (x, y) position
    $gbOptionBox.Controls.Add($cbNTUserDat)


    $cbListFiles = New-Object System.Windows.Forms.CheckBox
    $cbListFiles.Text = "List ALL Files:"
    $cbListFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbListFiles.Width = 120
    $cbListFiles.Location = New-Object System.Drawing.Point(10, 170)  # (x, y) position
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
    $tbDrivesList.Location = New-Object System.Drawing.Point(130, 170)  # (x, y) position
    $tbDrivesList.Enabled = $false
    $gbOptionBox.Controls.Add($tbDrivesList)


    $lblDrivesList = New-Object System.Windows.Forms.Label
    $lblDrivesList.Text = "[Enter Drive Letter(s)]"
    $lblDrivesList.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblDrivesList.ForeColor = [System.Drawing.Color]::Blue
    $lblDrivesList.Width = 260
    $lblDrivesList.Location = New-Object System.Drawing.Point(130, 190)  # (x, y) position
    $lblDrivesList.TextAlign = "MiddleLeft"
    $gbOptionBox.Controls.Add($lblDrivesList)


    $cbKeyWordSearch = New-Object System.Windows.Forms.CheckBox
    $cbKeyWordSearch.Text = "Search by keyword(s):"
    $cbKeyWordSearch.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbKeyWordSearch.Width = 195
    $cbKeyWordSearch.Location = New-Object System.Drawing.Point(10, 215)  # (x, y) position
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
    $tbKeyWordsDrivesList.Location = New-Object System.Drawing.Point(205, 215)  # (x, y) position
    $tbKeyWordsDrivesList.Enabled = $false
    $gbOptionBox.Controls.Add($tbKeyWordsDrivesList)


    $lblKeyWords = New-Object System.Windows.Forms.Label
    $lblKeyWords.Text = "[Enter Drive Letter(s)]"
    $lblKeyWords.Font = New-Object System.Drawing.Font("Arial", 8)
    $lblKeyWords.ForeColor = [System.Drawing.Color]::Blue
    $lblKeyWords.Width = 185
    $lblKeyWords.Location = New-Object System.Drawing.Point(205, 235)  # (x, y) position
    $lblKeyWords.TextAlign = "MiddleLeft"
    $gbOptionBox.Controls.Add($lblKeyWords)


    $cbSruDb = New-Object System.Windows.Forms.CheckBox
    $cbSruDb.Text = "Copy SRUDB.dat file"
    $cbSruDb.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbSruDb.Width = 250
    $cbSruDb.Location = New-Object System.Drawing.Point(10, 260)  # (x, y) position
    $gbOptionBox.Controls.Add($cbSruDb)


    $cbHashFiles = New-Object System.Windows.Forms.CheckBox
    $cbHashFiles.Text = "Hash the output files"
    $cbHashFiles.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbHashFiles.Width = 250
    $cbHashFiles.Location = New-Object System.Drawing.Point(10, 285)  # (x, y) position
    $gbOptionBox.Controls.Add($cbHashFiles)


    $cbArchive = New-Object System.Windows.Forms.CheckBox
    $cbArchive.Text = "Create Case Archive"
    $cbArchive.Font = New-Object System.Drawing.Font("Arial", 10)
    $cbArchive.Width = 250
    $cbArchive.Location = New-Object System.Drawing.Point(10, 310)  # (x, y) position
    $gbOptionBox.Controls.Add($cbArchive)


    # Define a button for initiating the html report
    $btnHtmlReport = [System.Windows.Forms.Button]::new()
    $btnHtmlReport.Name = "btnHtmlReport"
    $btnHtmlReport.Text = "Html Output"
    $btnHtmlReport.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnHtmlReport.Width = 150
    $btnHtmlReport.Height = 40
    $btnHtmlReport.Padding = New-Object System.Windows.Forms.Padding(5)
    $btnHtmlReport.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnHtmlReport.Location  = New-Object System.Drawing.Point(97.5, 380)  # (x, y) position
    $btnHtmlReport.FlatAppearance.BorderSize = 1
    $btnHtmlReport.FlatAppearance.BorderColor = [System.Drawing.Color]::black
    $btnHtmlReport.BackColor = "#1f618d"
    $btnHtmlReport.Forecolor = "#dddddd"
    $btnHtmlReport.Add_Click({

        $User = $tbUserName.Text
        $Agency = $tbAgency.Text
        $CaseNumber = $tbCaseNumber.Text
        $DriveList = $tbDrivesList.Text
        $KeyWordsDrivesList = $tbKeyWordsDrivesList.Text

            Export-HtmlReport $CaseFolderName $User $Agency $CaseNumber $ComputerName $Ipv4 $Ipv6 -Device $cbOne.Checked -UserData $cbTwo.Checked -Network $cbThree.Checked -Process $cbFour.Checked -System $cbFive.Checked -Prefetch $cbSix.Checked -EventLogs $cbSeven.Checked -Firewall $cbEight.Checked -BitLocker $cbNine.Checked -CaptureProcesses $cbGetProcesses.Checked -GetRam $cbGetRam.Checked -Edd $cbEdd.Checked -Hives $cbRegHives.Checked -CopyPrefetch $cbPrefetch.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -CopySruDb $cbSruDb.Checked -GetFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

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
    $btnFilesReport.Width = 150
    $btnFilesReport.Height = 40
    $btnFilesReport.Padding = New-Object System.Windows.Forms.Padding(5)
    $btnFilesReport.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnFilesReport.Location = New-Object System.Drawing.Point(345, 380)  # (x, y) position
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

            Export-FilesReport -CaseFolderName $CaseFolderName -User $User -Agency $Agency -CaseNumber $CaseNumber -ComputerName $ComputerName -Ipv4 $Ipv4 -Ipv6 $Ipv6 -Device $cbOne.Checked -UserData $cbTwo.Checked -Network $cbThree.Checked -Process $cbFour.Checked -System $cbFive.Checked -Prefetch $cbSix.Checked -EventLogs $cbSeven.Checked -Firewall $cbEight.Checked -BitLocker $cbNine.Checked -CaptureProcesses $cbGetProcesses.Checked -GetRam $cbGetRam.Checked -Edd $cbEdd.Checked -Hives $cbRegHives.Checked -CopyPrefetch $cbPrefetch.Checked -GetNTUserDat $cbNTUserDat.Checked -ListFiles $cbListFiles.Checked -DriveList $DriveList -KeyWordSearch $cbKeyWordSearch.Checked -KeyWordsDriveList $KeyWordsDrivesList -CopySrum $cbSruDb.Checked -GetFileHashes $cbHashFiles.Checked -MakeArchive $cbArchive.Checked

            $Form.Close()
            return

    })
    # Add the button
    $Form.Controls.Add($btnFilesReport)


    # Define a button for initiating the files report
    $btnQuit = New-Object Windows.Forms.Button
    $btnQuit.Text = "Quit"
    $btnQuit.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $btnQuit.Width = 150
    $btnQuit.Height = 40
    $btnQuit.Padding = New-Object System.Windows.Forms.Padding(5)
    $btnQuit.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnQuit.Location = New-Object System.Drawing.Point(592.5, 380)  # (x, y) position
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
