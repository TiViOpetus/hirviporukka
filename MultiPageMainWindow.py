# APPLICATON FOR SHOWING SUMMARY DATA ABOUT MEAT GIVEN TO SHARE GROUP
# ====================================================================

# LIBRARIES AND MODULES
# ---------------------

import sys  # Needed for starting the application
import plotly
from PyQt5.QtWidgets import *  # All widgets
from PyQt5 import QtWebEngineWidgets # For showing html content
from PyQt5.uic import loadUi
from PyQt5.QtCore import *  # FIXME: Everything,  change to individual components
from datetime import date
import pgModule
import prepareData
import figures

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
        self.connectionArguments = databaseOperation.readDatabaseSettingsFromFile(
            'settings.dat')

        # UI ELEMENTS TO PROPERTIES
        # -------------------------
        
        # Create a status bar to show informative messages (replaces print function used in previous exercises)
        self.statusBar = QStatusBar()  # Create a status bar object
        # Set it as the status bar for the main window
        self.setStatusBar(self.statusBar)
        self.statusBar.show()  # Make it visible

        # Set current date when the app starts
        self.currentDate = date.today()



        # Summary page (Yhteenveto)
        self.summaryRefreshBtn = self.summaryRefreshPushButton
        self.summaryRefreshBtn.clicked.connect(
            self.populateSummaryPage)  # Signal
        self.summaryMeatSharedTW = self.meatSharedTableWidget
        self.summaryGroupSummaryTW = self.groupSummaryTableWidget
        self.sankeyWebV = self.sankeyWebEngineView
        #TODO: Try to set column widths to fill the space available
        # meatSharedTWHeader = self.summaryMeatSharedTW.horizontalHeader()
        # meatSharedTWHeader.setSectionResizeMode(0, QHeaderView.Stretch)

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
        self.shotSavePushBtn.clicked.connect(self.saveShot)  # Signal
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

    # Create an alert dialog for critical failures, eg no database connection established
    def alert(self, windowTitle, alertMsg, additionalMsg, details):
        """Creates a message box for critical errors

        Args:
            windowTitle (str): Title of the message box
            alertMsg (str): Short description of the error in Finnish
            additionalMsg (str): Additional information in Finnish
            details (str): Details about the error in English
        """
        alertDialog = QMessageBox()  # Create a message box object
        # Add appropriate title to the message box
        alertDialog.setWindowTitle(windowTitle)
        alertDialog.setIcon(QMessageBox.Critical)  # Set icon to critical
        # Basic information about the error in Finnish
        alertDialog.setText(alertMsg)
        # Additional information about the error in Finnish
        alertDialog.setInformativeText(additionalMsg)
        # Technical details in English (from psycopg2)
        alertDialog.setDetailedText(details)
        # Only OK is needed to close the dialog
        alertDialog.setStandardButtons(QMessageBox.Ok)
        alertDialog.exec_()  # Open the message box

    # A method to populate summaryPage's table widgets

    def populateSummaryPage(self):

        # Read data from view jaetut_lihat
        databaseOperation1 = pgModule.DatabaseOperation()

        databaseOperation1.getAllRowsFromTable(
            self.connectionArguments, 'public.jaetut_lihat')

        # Check if error has occurred
        if databaseOperation1.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation1.errorMessage, databaseOperation1.detailedMessage)
        else:
            prepareData.prepareTable(
                databaseOperation1, self.summaryMeatSharedTW)

        # Read data from view jakoryhma_yhteenveto, no need to read connection args twice
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(
            self.connectionArguments, 'public.jakoryhma_yhteenveto')

        #figure = figures.createSankeyChart()
        figure = figures.testChart()
        plotly.offline.plot(figure, filename='meatstreams.html') # Write the chart to a html file
        url = QUrl('file:///meatstreams.html') # Create a relative url to the file
        self.sankeyWebV.load(url) # Load it into the web view element

        # Check if error has occurred
        if databaseOperation2.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation2.errorMessage, databaseOperation2.detailedMessage)
        else:
            prepareData.prepareTable(
                databaseOperation2, self.summaryGroupSummaryTW)

    def populateKillPage(self):
        # Set default date to current date
        self.shotDateDE.setDate(self.currentDate)
        # Read data from view kaatoluettelo
        databaseOperation1 = pgModule.DatabaseOperation()
        databaseOperation1.getAllRowsFromTable(
            self.connectionArguments, 'public.kaatoluettelo')

        # Check if error has occurred
        if databaseOperation1.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation1.errorMessage, databaseOperation1.detailedMessage)
        else:
            prepareData.prepareTable(databaseOperation1, self.shotKillsTW)

        # Read data from view nimivalinta
        databaseOperation2 = pgModule.DatabaseOperation()
        databaseOperation2.getAllRowsFromTable(
            self.connectionArguments, 'public.nimivalinta')

        # Check if error has occurred
        if databaseOperation2.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation2.errorMessage, databaseOperation2.detailedMessage)
        else:
            self.shotByIdList = prepareData.prepareComboBox(
                databaseOperation2, self.shotByCB, 1, 0)

        # Read data from table elain and populate the combo box
        databaseOperation3 = pgModule.DatabaseOperation()
        databaseOperation3.getAllRowsFromTable(
            self.connectionArguments, 'public.elain')

        # Check if error has occurred
        if databaseOperation3.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation3.errorMessage, databaseOperation3.detailedMessage)
        else:
            self.shotAnimalText = prepareData.prepareComboBox(
                databaseOperation3, self.shotAnimalCB, 0, 0)

        # Read data from table aikuinenvasa and populate the combo box
        databaseOperation4 = pgModule.DatabaseOperation()
        databaseOperation4.getAllRowsFromTable(
            self.connectionArguments, 'public.aikuinenvasa')
        
        # Check if error has occurred
        if databaseOperation4.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation4.errorMessage, databaseOperation4.detailedMessage)
        else:
            self.shotAgeGroupText = prepareData.prepareComboBox(
            databaseOperation4, self.shotAgeGroupCB, 0, 0)
        
        # Read data from table sukupuoli and populate the combo box
        databaseOperation5 = pgModule.DatabaseOperation()
        databaseOperation5.getAllRowsFromTable(
            self.connectionArguments, 'public.sukupuoli')

        if databaseOperation5.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation5.errorMessage, databaseOperation5.detailedMessage)
        else:
            self.shotGenderText = prepareData.prepareComboBox(
            databaseOperation5, self.shotGenderCB, 0, 0)

        # Read data from table kasittely
        databaseOperation6 = pgModule.DatabaseOperation()
        databaseOperation6.getAllRowsFromTable(
            self.connectionArguments, 'public.kasittely')
        
        if databaseOperation6.errorCode != 0:
            self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation6.errorMessage, databaseOperation6.detailedMessage)
        else:
            self.shotUsageIdList = prepareData.prepareComboBox(
            databaseOperation6, self.shotUsageCB, 1, 0)

    # TODO: Make populate share page method

    # TODO: Make populate license page method

    def populateAllPages(self):
        
        testDBConnection = pgModule.DatabaseOperation()
        connectionArgs = testDBConnection.readDatabaseSettingsFromFile('settings.dat')
        testDBConnection.testConnection(connectionArgs)
        if testDBConnection.errorCode == 0:
            self.populateSummaryPage()
            self.populateKillPage()
        else:
            self.alert('Tarkista tietokanta-asetukset', 'settings.dat-tiedostosta','no further information','no further information')
        
        

    def saveShot(self):
        errorOccurred = False
        try:
            shotByChosenItemIx = self.shotByCB.currentIndex()  # Row index of the selected row
            # Id value of the selected row
            shotById = self.shotByIdList[shotByChosenItemIx]
            shootingDay = self.shotDateDE.date().toPyDate()  # Python date is in ISO format
            shootingPlace = self.shotLocationLE.text()  # Text value of line edit
            animal = self.shotAnimalCB.currentText()  # Selected value of the combo box
            ageGroup = self.shotAgeGroupCB.currentText()  # Selected value of the combo box
            gender = self.shotGenderCB.currentText()  # Selected value of the combo box
            # Convert line edit value into float (real in the DB)
            weight = float(self.shotWeightLE.text())
            useIx = self.shotUsageCB.currentIndex()  # Row index of the selected row
            use = self.shotUsageIdList[useIx]  # Id value of the selected row
            # Convert multiline text edit into plain text
            additionalInfo = self.shotAddInfoTE.toPlainText()

            # Insert data into kaato table
            # Create a SQL clause to insert element values to the DB
            sqlClauseBeginning = """INSERT INTO public.kaato
            (jasen_id, kaatopaiva, ruhopaino, paikka_teksti, 
            kasittelyid, elaimen_nimi, sukupuoli, ikaluokka, lisatieto) VALUES("""
            sqlClauseValues = f"{shotById}, '{shootingDay}', {weight}, '{shootingPlace}', {use}, '{animal}', '{gender}', '{ageGroup}', '{additionalInfo}'"
            sqlClauseEnd = ");"
            sqlClause = sqlClauseBeginning + sqlClauseValues + sqlClauseEnd

        # Check for conversion errors
        except Exception as error:
            errorOccurred = True
            self.alert('Virheellinen syöte', 'Tarkista antamasi tiedot', 'Tyyppivirhe', str(error))
        
        finally:
            # Check if conversions from text are successful
            if errorOccurred == False:
                    
                # Create DatabaseOperation object to execute the SQL clause
                databaseOperation = pgModule.DatabaseOperation()
                databaseOperation.insertRowToTable(self.connectionArguments, sqlClause)

                # Check if there is any db related errors (error handling in pgMolule)
                if databaseOperation.errorCode != 0:
                    self.alert('Vakava virhe', 'Tietokantaoperaatio epäonnistui',
                       databaseOperation.errorMessage, databaseOperation.detailedMessage)
                
                # If no errors: update page and clear previous data data from elements
                else:
                    
                    self.populateKillPage()
                    self.shotLocationLE.clear()
                    self.shotWeightLE.clear()
                    self.shotAddInfoTE.clear()

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
