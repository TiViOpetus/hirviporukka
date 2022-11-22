# APPLICATON FOR SHOWING SUMMARY DATA ABOUT MEAT GIVEN TO SHARE GROUP
# ====================================================================

# LIBRARIES AND MODULES
# ---------------------

import sys  # Needed for starting the application
from PyQt5.QtWidgets import *  # All widgets
from PyQt5.uic import loadUi
from PyQt5.QtCore import *  # FIXME: Everything,  change to individual components
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

        # Read database connection arguments from the settings file
        databaseOperation = pgModule.DatabaseOperation()
        self.connectionArguments = databaseOperation.readDatabaseSettingsFromFile('settings.dat')
        

        # UI ELEMENTS TO PROPERTIES
        # -------------------------

        # Summary page (Yhteenveto)
        self.summaryRefreshBtn = self.summaryRefreshPushButton
        self.summaryRefreshBtn.clicked.connect(
            self.populateSummaryPage)  # Signal
        self.summaryMeatSharedTW = self.meatSharedTableWidget
        self.summaryGroupSummaryTW = self.groupSummaryTableWidget

        # Kill page (Kaato)
        self.shotByCB = self.shotByComboBox
        self.shotDateDE = self.shotDateEdit
        self.shotLocationLE = self.locationLineEdit
        self.shotAnimalCB = self.animalComboBox
        self.shotAgeGroupCB = self.ageGroupComboBox
        self.shotGenderCB = self.genderComboBox
        self.shotWeightLE = self.weightLineEdit
        self.shotUsageCB = self.usageComboBox
        self.shotAddInfoTE = self.additionalInfoTextEdit
        self.shotSavePushBtn = self.saveShotPushButton
        self.shotSavePushBtn.clicked.connect(self.saveShot)
        self.shotKillsTW = self.killsKillsTableWidget

        # Share page (Lihanjako)
        self.shareKillsTW = self.shareKillsTableWidget
        self.shareDE = self.shareDateEdit
        self.sharePortionCB = self.portionComboBox
        self.shareAmountLE = self.amountLineEdit
        self.shareGroupCB = self.groupComboBox
        self.shareSavePushBtn = self.shareSavePushButton

        # License page (Luvat)
        self.licenseYearLE = self.licenseYearLineEdit
        self.licenseAnimalCB = self.licenseAnimalComboBox
        self.licenseAgeGroupCB = self.licenseAgeGroupComboBox
        self.licenseGenderCB = self.licenseGenderComboBox
        self.licenseAmountLE = self.licenseAmountLineEdit
        self.licenseSavePushBtn = self.licenseSavePushButton
        self.licenseSummaryTW = self.licenseSummaryTableWidget

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
        
        databaseOperation1.getAllRowsFromTable(
            self.connectionArguments, 'public.jaetut_lihat')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(databaseOperation1, self.summaryMeatSharedTW)

        # Read data from view jakoryhma_yhteenveto, no need to read connection args twice
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(
            self.connectionArguments, 'public.jakoryhma_yhteenveto')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(
            databaseOperation2, self.summaryGroupSummaryTW)

    def populateKillPage(self):
        # Read data from view kaatoluettelo
        databaseOperation1 = pgModule.DatabaseOperation()
        databaseOperation1.getAllRowsFromTable(
            self.connectionArguments, 'public.kaatoluettelo')
        # TODO: MessageBox if an error occured
        prepareData.prepareTable(databaseOperation1, self.shotKillsTW)

        # Read data from view nimivalinta
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(
            self.connectionArguments, 'public.nimivalinta')
        self.shotByIdList = prepareData.prepareComboBox(
            databaseOperation2, self.shotByCB, 1, 0)

        # Read data from table elain and populate the combo box
        databaseOperation3 = pgModule.DatabaseOperation()
        databaseOperation3.getAllRowsFromTable(
            self.connectionArguments, 'public.elain')
        self.shotAnimalText = prepareData.prepareComboBox(
            databaseOperation3, self.shotAnimalCB, 0, 0)

        # Read data from table aikuinenvasa and populate the combo box
        databaseOperation4 = pgModule.DatabaseOperation()
        databaseOperation4.getAllRowsFromTable(
            self.connectionArguments, 'public.aikuinenvasa')
        self.shotAgeGroupText = prepareData.prepareComboBox(
            databaseOperation4, self.shotAgeGroupCB, 0, 0)

        # Read data from table sukupuoli and populate the combo box
        databaseOperation5 = pgModule.DatabaseOperation()
        databaseOperation5.getAllRowsFromTable(
            self.connectionArguments, 'public.sukupuoli')
        self.shotGenderText = prepareData.prepareComboBox(
            databaseOperation5, self.shotGenderCB, 0, 0)

        # Read data from table kasittely
        databaseOperation6 = pgModule.DatabaseOperation()
        databaseOperation6.getAllRowsFromTable(
            self.connectionArguments, 'public.kasittely')
        self.shotUsageIdList = prepareData.prepareComboBox(
            databaseOperation6, self.shotUsageCB, 1, 0)

    def populateAllPages(self):
        self.populateSummaryPage()
        self.populateKillPage()

    def saveShot(self):
        # TODO: Add error handling and msg box when an error occurs
        shotByChosenItemIx = self.shotByCB.currentIndex() # Row index of the selected row
        shotById = self.shotByIdList[shotByChosenItemIx] # Id value of the selected row
        shootingDay = self.shotDateDE.date().toPyDate() # Python date is in ISO format
        shootingPlace = self.shotLocationLE.text() # Text value of line edit
        animal = self.shotAnimalCB.currentText() # Selected value of the combo box 
        ageGroup = self.shotAgeGroupCB.currentText() # Selected value of the combo box
        gender = self.shotGenderCB.currentText() # Selected value of the combo box
        weight = float(self.shotWeightLE.text()) # Convert line edit value into float (real in the DB)
        useIx = self.shotUsageCB.currentIndex() # Row index of the selected row
        use = self.shotUsageIdList[useIx] # Id value of the selected row
        additionalInfo = self.shotAddInfoTE.toPlainText() # Convert multiline text edit into plain text

        # Insert data into kaato table
        # Create a SQL clause to insert element values to the DB
        sqlClauseBeginning = "INSERT INTO public.kaato(jasen_id, kaatopaiva, ruhopaino, paikka_teksti, kasittelyid, elaimen_nimi, sukupuoli, ikaluokka, lisatieto) VALUES("
        sqlClauseValues = f"{shotById}, '{shootingDay}', {weight}, '{shootingPlace}', {use}, '{animal}', '{gender}', '{ageGroup}', '{additionalInfo}'"
        sqlClauseEnd = ");"
        sqlClause = sqlClauseBeginning + sqlClauseValues + sqlClauseEnd
        print(sqlClause) # FIXME: Remove this line in pruduction

        # create DatabaseOperation object to execute the SQL clause
        databaseOperation = pgModule.DatabaseOperation()
        databaseOperation.insertRowToTable(self.connectionArguments, sqlClause)

        # TODO: Add refresh method to update kaadot table widget
        

# APPLICATION CREATION AND STARTING
# ----------------------------------


# Check if app will be created and started directly from this file
if __name__ == "__main__":

    # Create an application object
    app = QApplication(sys.argv)
    app.setStyle('Fusion')

    # Create the Main Window object from MultiPageMainWindowe Class and show it on the screen
    appWindow = MultiPageMainWindow()
    appWindow.show()  # This can also be included in the MultiPageMainWindow class
    sys.exit(app.exec_())
