import sys
import subprocess
from PyQt5.QtWidgets import QApplication, QMainWindow, QComboBox, QLineEdit, QGridLayout, QLabel, QPushButton, QVBoxLayout, QWidget, QMessageBox
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QCursor

class SharedriveAccessTool(QMainWindow):
    def __init__(self):
        super().__init__()
        self.delete_network_drives()
        self.setWindowTitle("Sharedrive Access Tool")
        screen_geometry = QApplication.desktop().availableGeometry()
        self.resize(500, 300)
        self.move(screen_geometry.center() - self.rect().center())
        self.setMinimumSize(500, 300)
        self.setMaximumSize(500, 300)

        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)

        self.layout = QGridLayout()
        self.central_widget.setLayout(self.layout)

        self.title_label = QLabel("<h4 align='center'>Sharedrive Access Tool</h4>")
        self.title_label.setStyleSheet("font-size: 16pt; font-weight: bold;")
        self.layout.addWidget(self.title_label, 0, 0, 1, 2)

        self.combo_box_label = QLabel("<b>Select Department:</b>")
        self.combo_box_label.setStyleSheet("font-size: 9pt; font-weight: bold;")
        self.layout.addWidget(self.combo_box_label, 1, 0)
        self.combo_box = QComboBox()
        self.combo_box.addItems(['HR', 'ERP', 'Sales'])
        self.combo_box.setCurrentIndex(0)
        self.combo_box.setMinimumWidth(200) 
        self.combo_box.setMaximumWidth(200) # Set minimum width for combo box
        self.combo_box.setStyleSheet("""
                                        QComboBox {
                                            font-size: 9pt;
                                        }
                                        QComboBox QAbstractItemView::item:selected {
                                            background-color: #4CAF50;
                                            color: #fff;
                                        }
                                        """)
        self.layout.addWidget(self.combo_box, 1, 1)

        self.username_label = QLabel("<b>Username:</b>")
        self.username_label.setStyleSheet("font-size: 9pt; font-weight: bold;")
        self.layout.addWidget(self.username_label, 2, 0)
        self.username_text_box = QLineEdit()
        self.username_text_box.setMinimumWidth(200)
        self.username_text_box.setMaximumWidth(200)# Set minimum width for username text box
        self.layout.addWidget(self.username_text_box, 2, 1)

        self.password_label = QLabel("<b>Password:</b>")
        self.password_label.setStyleSheet("font-size: 9pt; font-weight: bold;")
        self.layout.addWidget(self.password_label, 3, 0)
        self.password_text_box = QLineEdit()
        self.password_text_box.setEchoMode(QLineEdit.Password)
        self.password_text_box.setMinimumWidth(200)
        self.password_text_box.setMaximumWidth(200)# Set minimum width for password text box
        self.layout.addWidget(self.password_text_box, 3, 1)

        self.drive_letter_label = QLabel("<b>Drive Letter:</b>")
        self.drive_letter_label.setStyleSheet("font-size: 9pt; font-weight: bold;")
        self.layout.addWidget(self.drive_letter_label, 4, 0)
        self.drive_letter_text_box = QLineEdit()
        self.drive_letter_text_box.setMinimumWidth(50)
        self.drive_letter_text_box.setMaximumWidth(50)# Set minimum width for drive letter text box
        self.layout.addWidget(self.drive_letter_text_box, 4, 1)

        self.connect_button = QPushButton("Connect")
        self.connect_button.setStyleSheet("background-color: #4CAF50; color: #fff;")
        self.connect_button.clicked.connect(self.connect)
        self.connect_button.setMinimumWidth(75)
        self.connect_button.setMaximumWidth(75)
        self.layout.addWidget(self.connect_button, 5, 0, 1, 2, Qt.AlignCenter)

        self.status_label = QLabel("")
        self.status_label.setStyleSheet("color: #ff0000;")
        self.layout.addWidget(self.status_label, 6, 0, 1, 2, Qt.AlignCenter)

        self.menu_bar = self.menuBar()
        self.file_menu = self.menu_bar.addMenu("Help")
        self.about_action = self.file_menu.addAction("About")
        self.about_action.triggered.connect(self.about)
    def delete_network_drives(self):
        try:
            command = "net use * /delete /y"
            subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
            print("Deleted all network shared drives or folders")
        except subprocess.CalledProcessError as e:
            print(f"Error deleting network shared drives or folders: {e}")

    def about(self):
        """Displays an informative 'About' dialog for the Sharedrive Access Tool."""

        about_dialog = QMessageBox()
        about_dialog.setWindowTitle("About Info")

        # Create a rich text label for HTML content
        about_text = """
        <p>Version 3.2.6</p>
        <p>Developed by: <a href="https://www.smartinfosec.in" style="text-decoration: none; color: #0000ff;">www.smartinfosec.in</a></p>
        <p>Special Credits: <span style="font-weight: bold;">Sathishkumar MR</span> and <span style="font-weight: bold;">Karthik</span></p>
        """

        # Set the HTML text to the QMessageBox
        about_dialog.setText(about_text)

        # Set a fixed width and height for the dialog
        about_dialog.setFixedSize(600, 300)  # Adjust the size as needed

        # Set standard buttons and execute the dialog
        about_dialog.setStandardButtons(QMessageBox.Ok)
        about_dialog.exec_()

    def connect(self):
        try:
            drive_letter = self.drive_letter_text_box.text()
            username = self.username_text_box.text()
            password = self.password_text_box.text()

            if not drive_letter or not username or not password:
                error_dialog = QMessageBox()
                error_dialog.setWindowTitle("Error")
                error_dialog.setText("Please fill all the fields!")
                error_dialog.exec_()
                return
            
            server_ip = "SATHISH-LENOVO"  # replace with your server IP

            if self.combo_box.currentText() == "HR":
                share_path = f"\\\\{server_ip}\\FileServer_Cyber"
            elif self.combo_box.currentText() == "ERP":
                share_path = f"\\\\{server_ip}\\Option2"
            elif self.combo_box.currentText() == "Sales":
                share_path = f"\\\\{server_ip}\\Option3"
            else:
                raise ValueError("Invalid combobox selection")

            net_use_command = f"net use {drive_letter}: {share_path} /user:{username} {password}"
            print(f"Debug: Command - {net_use_command}")

            output = subprocess.check_output(net_use_command, shell=True, stderr=subprocess.STDOUT)
            if output.decode().strip() == "The command completed successfully.":
                self.status_label.setText("Status: Success")
                self.status_label.setStyleSheet("color: #008000;")
            else:
                 raise subprocess.CalledProcessError(output.returncode, net_use_command, output.stdout + output.stderr)
        except subprocess.CalledProcessError as e:
            error_message = f"Error connecting to server - Return code {e.returncode}\n{e.output.decode().strip()}"
            self.status_label.setText("Status: Fail")
            self.status_label.setStyleSheet("color: #ff0000;")
            error_dialog = QMessageBox()
            error_dialog.setWindowTitle("Error")
            error_dialog.setText(error_message)
            error_dialog.exec_()
            print(f"Debug: {error_message}")
        except Exception as e:
            error_message = f"An error occurred - {str(e)}"
            self.status_label.setText("Status: Fail")
            self.status_label.setStyleSheet("color: #ff0000;")
            error_dialog = QMessageBox()
            error_dialog.setWindowTitle("Error")
            error_dialog.setText(error_message)
            error_dialog.exec_()
            print(f"Debug: {error_message}")

def main():
    app = QApplication(sys.argv)
    window = SharedriveAccessTool()
    window.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()