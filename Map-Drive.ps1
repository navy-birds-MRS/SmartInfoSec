try {
  # Disconnect all network mapped drives
  net use * /delete /y
}
catch {
  $statusLabel.Text = "Status: Failed to disconnect network drives"
}

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Sharedrive Access'
$form.Size = New-Object System.Drawing.Size(400, 350)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true
$form.MinimizeBox = $true
$form.MaximizeBox = $true
$form.ControlBox = $true
$form.Font = New-Object System.Drawing.Font('Segoe UI', 10)

# Create a menu strip
$menuStrip = New-Object System.Windows.Forms.MenuStrip
$menuStrip.Location = New-Object System.Drawing.Point(0, 0)
$menuStrip.Size = New-Object System.Drawing.Size(400, 24)
$form.Controls.Add($menuStrip)

# Create a "Help" menu
$fileMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$fileMenu.Text = "Help"
$menuStrip.Items.Add($fileMenu)

# Create an "About" menu item
$aboutMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$aboutMenuItem.Text = "About"
$aboutMenuItem.Add_Click({
    $aboutForm = New-Object System.Windows.Forms.Form
    $aboutForm.Text = 'About Sharedrive Access Tool'
    $aboutForm.Size = New-Object System.Drawing.Size(350, 280)
    $aboutForm.StartPosition = 'CenterScreen'
    $aboutForm.Topmost = $true
    $aboutForm.MinimizeBox = $true
    $aboutForm.MaximizeBox = $true
    $aboutForm.ControlBox = $true
    $aboutForm.Font = New-Object System.Drawing.Font('Segoe UI', 10)

    $aboutLabel = New-Object System.Windows.Forms.Label
    $aboutLabel.Location = New-Object System.Drawing.Point(10, 20)
    $aboutLabel.Size = New-Object System.Drawing.Size(330, 20)
    $aboutLabel.Text = 'Sharedrive Access Tool'
    $aboutLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $aboutForm.Controls.Add($aboutLabel)

    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Location = New-Object System.Drawing.Point(10, 50)
    $versionLabel.Size = New-Object System.Drawing.Size(330, 20)
    $versionLabel.Text = 'Version 1.0'
    $versionLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $aboutForm.Controls.Add($versionLabel)

    $developerLabel = New-Object System.Windows.Forms.Label
    $developerLabel.Location = New-Object System.Drawing.Point(10, 80)
    $developerLabel.Size = New-Object System.Drawing.Size(95, 20)
    $developerLabel.Text = 'Developed by: '
    $developerLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $aboutForm.Controls.Add($developerLabel)

    $developerLinkLabel = New-Object System.Windows.Forms.LinkLabel
    $developerLinkLabel.Location = New-Object System.Drawing.Point(105, 80)
    $developerLinkLabel.Size = New-Object System.Drawing.Size(200, 20)
    $developerLinkLabel.Text = 'www.smartinfosec.in'
    $developerLinkLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $developerLinkLabel.LinkColor = 'Blue'
    $developerLinkLabel.ActiveLinkColor = 'Red'
    $developerLinkLabel.VisitedLinkColor = 'Purple'
    $developerLinkLabel.Add_Click({ Start-Process "https://www.smartinfosec.in" })
    $aboutForm.Controls.Add($developerLinkLabel)

    $creditsLabel = New-Object System.Windows.Forms.Label
    $creditsLabel.Location = New-Object System.Drawing.Point(10, 110)
    $creditsLabel.Size = New-Object System.Drawing.Size(330, 40)
    $creditsLabel.Text = "Special Credits: Sathishkumar MR and Karthik"
    $creditsLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $aboutForm.Controls.Add($creditsLabel)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(135, 160)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.Font = New-Object System.Drawing.Font('Segoe UI', 10)
    $okButton.Add_Click({ $aboutForm.Close() })
    $aboutForm.Controls.Add($okButton)

    $aboutForm.ShowDialog()
  })
$fileMenu.DropDownItems.Add($aboutMenuItem)

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 30)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Select an option:'
$label.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($label)

# Create a combo box
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10, 50)
$comboBox.Size = New-Object System.Drawing.Size(260, 20)
$comboBox.DropDownStyle = 'DropDownList'
$comboBox.Items.Add('HR')
$comboBox.Items.Add('ERP')
$comboBox.Items.Add('Sales')
$comboBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($comboBox)

# Add some space
$emptySpace = New-Object System.Windows.Forms.Label
$emptySpace.Location = New-Object System.Drawing.Point(10, 70)
$emptySpace.Size = New-Object System.Drawing.Size(280, 10)
$form.Controls.Add($emptySpace)

# Create username label and text box
$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Location = New-Object System.Drawing.Point(10, 80)
$usernameLabel.Size = New-Object System.Drawing.Size(100, 20)
$usernameLabel.Text = 'Username:'
$usernameLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($usernameLabel)

$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Location = New-Object System.Drawing.Point(110, 80)
$usernameTextBox.Size = New-Object System.Drawing.Size(160, 20)
$usernameTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($usernameTextBox)

# Add some space
$emptySpace = New-Object System.Windows.Forms.Label
$emptySpace.Location = New-Object System.Drawing.Point(10, 100)
$emptySpace.Size = New-Object System.Drawing.Size(280, 10)
$form.Controls.Add($emptySpace)

# Create password label and text box
$passwordLabel = New-Object System.Windows.Forms.Label
$passwordLabel.Location = New-Object System.Drawing.Point(10, 110)
$passwordLabel.Size = New-Object System.Drawing.Size(100, 20)
$passwordLabel.Text = 'Password:'
$passwordLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($passwordLabel)

$passwordTextBox = New-Object System.Windows.Forms.TextBox
$passwordTextBox.Location = New-Object System.Drawing.Point(110, 110)
$passwordTextBox.Size = New-Object System.Drawing.Size(160, 20)
$passwordTextBox.PasswordChar = '*'
$passwordTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($passwordTextBox)

# Add some space
$emptySpace = New-Object System.Windows.Forms.Label
$emptySpace.Location = New-Object System.Drawing.Point(10, 130)
$emptySpace.Size = New-Object System.Drawing.Size(280, 10)
$form.Controls.Add($emptySpace)

# Create drive letter label and text box
$driveLetterLabel = New-Object System.Windows.Forms.Label
$driveLetterLabel.Location = New-Object System.Drawing.Point(10, 140)
$driveLetterLabel.Size = New-Object System.Drawing.Size(100, 20)
$driveLetterLabel.Text = 'Drive Letter:'
$driveLetterLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($driveLetterLabel)

$driveLetterTextBox = New-Object System.Windows.Forms.TextBox
$driveLetterTextBox.Location = New-Object System.Drawing.Point(110, 140)
$driveLetterTextBox.Size = New-Object System.Drawing.Size(20, 20)
$driveLetterTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($driveLetterTextBox)

# Add some space
$emptySpace = New-Object System.Windows.Forms.Label
$emptySpace.Location = New-Object System.Drawing.Point(10, 160)
$emptySpace.Size = New-Object System.Drawing.Size(280, 10)
$form.Controls.Add($emptySpace)

# Create connect button
$connectButton = New-Object System.Windows.Forms.Button
$connectButton.Location = New-Object System.Drawing.Point(135, 170)
$connectButton.Size = New-Object System.Drawing.Size(75, 23)
$connectButton.Text = 'Connect'
$connectButton.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$connectButton.Add_Click({
    try {
    # Get input values
    $driveLetter = $driveLetterTextBox.Text
    $username = $usernameTextBox.Text
    $password = $passwordTextBox.Text
    $serverIP = "SATHISH-LENOVO" # replace with your server IP

    # Determine share path based on combobox selection
    switch ($comboBox.SelectedItem) {
        'HR' { $sharePath = "\\$serverIP\FileServer_Cyber" }
        'ERP' { $sharePath = "\\$serverIP\Option2" }
        'Sales' { $sharePath = "\\$serverIP\Option3" }
        default { throw "Invalid combobox selection" }
    }

    # Construct net use command
    $netUseCommand = "net use $driveLetter`: $sharePath /user:$username $password"

    # Print debug information
    Write-Host "Debug: Command - $netUseCommand"

    # Execute net use command
    $commandOutput = & cmd /c $netUseCommand 2>&1

    # Check if command was successful
    if ($LASTEXITCODE -eq 0) {
        $statusLabel.Text = "Status: Successfully connected to server"
    } else {
        throw $commandOutput
    }
} catch {
    # Handle errors
    $statusLabel.Text = "Status: Failed to connect - Error: $_"
    Write-Host "Debug: Error connecting to server - $_"
}
})
$form.Controls.Add($connectButton)

# Create status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, ($form.ClientSize.Height - 30))
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($statusLabel)

$form.ShowDialog()