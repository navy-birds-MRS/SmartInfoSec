try {
  # Disconnect all network mapped drives
  net use * /delete /y
} catch {
  $statusLabel.Text = "Status: Failed to disconnect network drives"
}

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Sharedrive Access'
$form.Size = New-Object System.Drawing.Size(400,350)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true
$form.MinimizeBox = $true
$form.MaximizeBox = $true
$form.ControlBox = $true
$form.Font = New-Object System.Drawing.Font('Segoe UI', 10)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Select an option:'
$label.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($label)

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10,40)
$comboBox.Size = New-Object System.Drawing.Size(260,20)
$comboBox.DropDownStyle = 'DropDownList'
$comboBox.Items.Add('HR')
$comboBox.Items.Add('ERP')
$comboBox.Items.Add('sales')
$comboBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($comboBox)

$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Location = New-Object System.Drawing.Point(10,70)
$usernameLabel.Size = New-Object System.Drawing.Size(100,20)
$usernameLabel.Text = 'Username:'
$usernameLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($usernameLabel)

$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Location = New-Object System.Drawing.Point(110,70)
$usernameTextBox.Size = New-Object System.Drawing.Size(160,20)
$usernameTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($usernameTextBox)

$passwordLabel = New-Object System.Windows.Forms.Label
$passwordLabel.Location = New-Object System.Drawing.Point(10,100)
$passwordLabel.Size = New-Object System.Drawing.Size(100,20)
$passwordLabel.Text = 'Password:'
$passwordLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($passwordLabel)

$passwordTextBox = New-Object System.Windows.Forms.TextBox
$passwordTextBox.Location = New-Object System.Drawing.Point(110,100)
$passwordTextBox.Size = New-Object System.Drawing.Size(160,20)
$passwordTextBox.PasswordChar = '*'
$passwordTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($passwordTextBox)

# Add some space between password and drive letter fields
$emptySpace = New-Object System.Windows.Forms.Label
$emptySpace.Location = New-Object System.Drawing.Point(10,130)
$emptySpace.Size = New-Object System.Drawing.Size(280,10)
$form.Controls.Add($emptySpace)

$driveLetterLabel = New-Object System.Windows.Forms.Label
$driveLetterLabel.Location = New-Object System.Drawing.Point(10,140)
$driveLetterLabel.Size = New-Object System.Drawing.Size(100,20)
$driveLetterLabel.Text = 'Drive Letter:'
$driveLetterLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($driveLetterLabel)

$driveLetterTextBox = New-Object System.Windows.Forms.TextBox
$driveLetterTextBox.Location = New-Object System.Drawing.Point(110,140)
$driveLetterTextBox.Size = New-Object System.Drawing.Size(20,20)
$driveLetterTextBox.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($driveLetterTextBox)

$connectButton = New-Object System.Windows.Forms.Button
$connectButton.Location = New-Object System.Drawing.Point(10,170)
$connectButton.Size = New-Object System.Drawing.Size(75,23)
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

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 200)
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$form.Controls.Add($statusLabel)

$form.ShowDialog()