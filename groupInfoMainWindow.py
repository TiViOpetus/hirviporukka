# APPLICATON FOR SHOWING SUMMARY DATA ABOUT MEAT GIVEN TO SHARE GROUP
# ====================================================================

# LIBRARIES AND MODULES
# ---------------------

import sys # Needed for starting the application
from PyQt5.QtWidgets import * # All widgets
from PyQt5.uic import loadUi

# CLASS DEFINITIONS FOR THE APP
# -----------------------------

class GroupMainWindow(QMainWindow):
    
    # Constructor, a method for creating objects from this class
    def __init__(self):
        QMainWindow.__init__(self)

        # Create an UI from the ui file
        loadUi('groupInfoMainWindow.ui', self)

        # Define properties for ui elements
        self.refreshBtn = self.refreshPushButton
        self.groupInfo = self.groupSummaryTableWidget
        self.sharedMeatInfo = self.meatSharedTableWidget

        '''
        # Database connection parameters
        self.database = "metsastys"
        self.user = "sovellus"
        self.userPassword = "Q2werty"
        self.server = "localhost"
        self.port = "5432"
        '''
        # SIGNALS

        # Emit a signal when refresh push button is pressed
        self.refreshBtn.clicked.connect(self.refreshData)

    # SLOTS

    # This is an agent method to call real functions
    def refreshData(self):
        pass
        
        

# APPLICATION CREATION AND STARTING
# ----------------------------------

# Check if app will be created and started directly from this file
if __name__ == "__main__":

    # Create an application object
    app = QApplication(sys.argv)
    app.setStyle('Fusion')

    # Create the Main Window object from FormWithTable Class and show it on the screen
    appWindow = GroupMainWindow()
    appWindow.show()  # This can also be included in the FormWithTable class
    sys.exit(app.exec_())
        
    

    
