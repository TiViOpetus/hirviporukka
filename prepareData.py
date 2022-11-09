# MODULE FOR PREPARING DATA TO DISPLAY IT ON QT WIDGETS
# =====================================================

# LIBRARIES AND MODULES
# ---------------------
# import pgModule
# from PyQt5.QtWidgets import *  Remove this line when ready
from PyQt5.QtWidgets import QTableWidgetItem  # For handling a single table cell

'''
# Temporary object to get help about object properties
resultObject = pgModule.DatabaseOperation()
testConnectionArgs = resultObject.readDatabaseSettingsFromFile('settings.dat')
resultObject.getAllRowsFromTable(
    testConnectionArgs, 'public.jakoryhma_yhteenveto')

tableWidget = QTableWidget()
'''

# DATA PREPARATION FUNCTIONS
# ---------------------------


def prepareTable(resultObject, tableWidget):
    """Updates an existing TableWidget using an instance of DatabaseOperation class 
    defined in the pgModule

    Args:
        resultObject (DatabaseOperation): Instance of DatabaseOperation class -> errors and results
        tableWidget (QTableWidget): Table widget to be updated
    """
    
    # If there is no error start processing rows and columns of the result set
    if resultObject.errorCode == 0:
        tableWidget.setRowCount(resultObject.rows)
        tableWidget.setColumnCount(resultObject.columns)
        tableWidget.setHorizontalHeaderLabels(resultObject.columnHeaders)

        rowIndex = 0 # Initialize row index
        for tupleIx in resultObject.resultSet: # Cycle through list of tuples
            columnIndex = 0 # Init column index

            for cell in tupleIx: # Cycle through values in the tuple
                cellData = QTableWidgetItem(str(cell)) # Format cell data
                tableWidget.setItem(rowIndex, columnIndex, cellData) # Set cell

                columnIndex +=1

            rowIndex += 1        

       
