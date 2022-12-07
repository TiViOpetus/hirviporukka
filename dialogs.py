# MODULE FOR DIALOG WINDOWS USED IN MultipageMainWindow
# ---------------------------------------------------

# LIBRARIES AND MODULES TO IMPORT
import sys
from PyQt5.QtWidgets import *  # TODO: Clean this when finished creating classes
from PyQt5.QtGui import QDesktopServices # Needed for showing web pages on the default web browser
from PyQt5.QtCore import QUrl # For defining the URL of web page to show 
from PyQt5.uic import loadUi  # For loading the UI from a .ui file
import pgModule  # For creating and savig the DB settings

# CLASS DEFINITIONS
# -----------------

# Create a dummy Main Window because dialogs can not be started as standalone objects


class TestMainWindow(QMainWindow):
    """Main Window for testing dialogs."""

    def __init__(self):
        super().__init__()

        self.setWindowTitle('Pääikkuna dialogien testaukseen')

        # Add a dialogs to be tested here and run them as follows:
        saveDBSettings = SaveDBSettingsDialog()
        saveDBSettings.exec()
        
        # Opens RASEKO's home page in the default browser
        url = QUrl('https://www.raseko.fi')
        QDesktopServices.openUrl(url)   

# A class for the dialog to save the database settings
class SaveDBSettingsDialog(QDialog):
    """Creates a dialog to save database settings"""

    # Constructor
    def __init__(self):
        super().__init__()

        loadUi("saveDBSettingsDialog.ui", self)

        self.setWindowTitle('Tietokantapalvelimen asetukset')

        # Elements
        self.hostLE = self.hostLineEdit
        self.portSB = self.portSpinBox
        self.cancelPB = self.cancelPushButton
        self.savePB = self.savePushButton

        # Set values of elements according to the current settings
        # Create a object to use setting methods
        self.databaseOperation = pgModule.DatabaseOperation() # Needed in slots -> self
        currentSettings = self.databaseOperation.readDbSettingsFromJsonFile(
            'connectionSettings.dat')  # Read current settings, needed only in the constructor
        self.hostLE.setText(currentSettings['server'])  # Servers host name
        # Port number, spin box uses integer values
        self.portSB.setValue(int(currentSettings['port']))

        # Signals
        self.cancelPB.clicked.connect(self.closeDialog)
        self.savePB.clicked.connect(self.saveSettings)

    # Slots

    # Peru button closes the dialog
    def closeDialog(self):
        self.close()

    # Tallenna button saves modified settings to a file and closes the dialog
    def saveSettings(self):
        server = self.hostLE.text()
        # Port is string in the settings file, integer in spin box
        port = str(self.portSB.value())

        # Build new connection arguments
        newSettings = self.databaseOperation.createConnectionArgs(
            'psycotesti', 'sovellus', 'Q2werty', server, port)
        
        # Save arguments to a json file
        self.databaseOperation.saveDbSettingsToJsonFile(
            'connectionSettings.dat', newSettings)
        self.close()     

      
# Some tests
if __name__ == "__main__":

    # Create a testing application
    testApp = QApplication(sys.argv)

    # Create a main window for testing a dialog
    testMainWindow = TestMainWindow()
    testMainWindow.show()

    # Run the testing application
    testApp.exec()