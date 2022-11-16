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
        self.summaryRefreshBtn.clicked.connect(self.populateSummaryPage) # Signal
        self.summaryMeatSharedTW = self.meatSharedTableWidget
        self.summaryGroupSummaryTW = self.groupSummaryTableWidget
        
        # Kill page (Kaato)
        self.shotCB = self.shotByComboBox
        self.shotDate = self.shotDateEdit
        self.shotLocation = self.locationLineEdit
        self.shotAnimalCB = self.animalComboBox
        self.ageGroupCB = self.ageGroupComboBox
        self.genderCB = self.genderComboBox
        self.weightLE = self.weightLineEdit
        self.usageCB = self.usageComboBox
        self.addInfoTE = self.additionalInfoTextEdit
        self.saveShotPushBtn = self.saveShotPushButton
        self.killsKillsTW = self.killsKillsTableWidget
       
        # Share page (Lihanjako)
        self.shareKillsTW = self.shareKillsTableWidget
        self.shareDE = self.shareDateEdit
        self.portionCB = self.portionComboBox
        self.amountLE = self.amountLineEdit
        self.groupCB = self.groupComboBox
        self.shareSavePushBtn = self.shareSavePushButton

        # License page (Luvat)
        self.licenseYearLE = self.licenseYearLineEdit
        self.licenseAnimalCB = self.licenseAnimalComboBox
        self.licenseAgeGroupCB = self.licenseAgeGroupComboBox
        self.licenseGenderCB = self.licenseGenderComboBox
        self.licenseAmountLE = self.licenseAmountLineEdit
        self.licenseSavePushBtn = self.licenseSavePushButton
        self.summaryLicenseTW = self.licenseSummaryTableWidget
        
        # Signal when a page is opened
        self.pageTab = self.tabWidget 
        self.pageTab.currentChanged.connect(self.populateAllPages)

        # Signals other than emitted by UI elements
        self.populateAllPages()
        

    # SLOTS

    # A method to populate summaryPage's table widgets
    def populateSummaryPage(self):

        # Read data from view jaetut_lihat
        databaseOperation1 = pgModule.DatabaseOperation()
        connectionArguments = databaseOperation1.readDatabaseSettingsFromFile('settings.dat')
        databaseOperation1.getAllRowsFromTable(connectionArguments, 'public.jaetut_lihat')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(databaseOperation1, self.summaryMeatSharedTW)

        # Read data from view jakoryhma_yhteenveto, no need to read connection args twice
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(connectionArguments, 'public.jakoryhma_yhteenveto')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(databaseOperation2, self.summaryGroupSummaryTW) 
    
    def populateKillPage(self):
        # Read data from view kaatoluettelo
        databaseOperation1 = pgModule.DatabaseOperation()
        connectionArguments = databaseOperation1.readDatabaseSettingsFromFile('settings.dat')
        databaseOperation1.getAllRowsFromTable(connectionArguments, 'public.kaatoluettelo')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(databaseOperation1, self.killsKillsTW)

        # Read data from view nimivalinta
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(connectionArguments, 'public.nimivalinta')

    def populateAllPages(self):
        self.populateSummaryPage()
        self.populateKillPage()    
        

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
        
    

    
