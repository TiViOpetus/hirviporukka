# APPLICATON FOR SHOWING SUMMARY DATA ABOUT MEAT GIVEN TO SHARE GROUP
# ====================================================================

# LIBRARIES AND MODULES
# ---------------------

import sys # Needed for starting the application
from PyQt5.QtWidgets import * # All widgets
from PyQt5.uic import loadUi
from PyQt5.QtCore import * # FIXME: Everything,  change to individual components
import pgModule
import prepareData

# CLASS DEFINITIONS FOR THE APP
# -----------------------------

class MultiPageMainWindow(QMainWindow):
    
    # Constructor, a method for creating objects from this class
    def __init__(self):
        QMainWindow.__init__(self)

        # Create an UI from the ui file
        loadUi('MultiPageMainWindow.ui', self)

        # UI ELEMENTS TO PROPERTIES
        # -------------------------

        # Summary page (Yhteenveto)
        self.summaryRefreshBtn = self.summaryRefreshPushButton
        self.summaryMeatSharedTW = self.meatSharedTableWidget
        self.summaryGroupSummaryTW = self.groupSummaryTableWidget
        
        # Kill page (Kaato)
        
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
        self.refreshBtn.clicked.connect(self.agentRefreshData)

    # SLOTS

    # Agent method is used for receiving a signal from an UI element
    def agentRefreshData(self):

        # Read data from view jaetut_lihat
        databaseOperation1 = pgModule.DatabaseOperation()
        connectionArguments = databaseOperation1.readDatabaseSettingsFromFile('settings.dat')
        databaseOperation1.getAllRowsFromTable(connectionArguments, 'public.jaetut_lihat')
        print(databaseOperation1.detailedMessage)
        
        # Read data from view jakoryhma_yhteenveto, no need to read connection args twice
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(connectionArguments, 'public.jakoryhma_yhteenveto')
        print(databaseOperation2.detailedMessage)
        
        # Let's call the real method which updates the widget
        self.refreshData(databaseOperation1, self.sharedMeatInfo)
        self.refreshData(databaseOperation2, self.groupInfo)

    # This is a function that updates table widgets in the UI
    # because it does not receive signals; it's not a slot
    def refreshData(self, databaseOperation, widget):
        prepareData.prepareTable(databaseOperation, widget)
        
        

# APPLICATION CREATION AND STARTING
# ----------------------------------

# Check if app will be created and started directly from this file
if __name__ == "__main__":

    # Create an application object
    app = QApplication(sys.argv)
    app.setStyle('Fusion')

    # Create the Main Window object from FormWithTable Class and show it on the screen
    appWindow = MultiPageMainWindow()
    appWindow.show()  # This can also be included in the FormWithTable class
    sys.exit(app.exec_())
        
    

    
