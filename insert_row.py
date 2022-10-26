# TEST INSERT OPERATION

# LIBRARIES AND MODULES
import psycopg2  # For PostgreSQL

# Properties of the connection string
database = "metsastys"
user = "postgres"
password = "Q2werty"
host = "localhost"
port = "5432"

# Try to establish a connection to DB server
try:
    # Create a connection object
    dbaseconnetion = psycopg2.connect(database=database, user=user, password=password,
                                      host=host, port=port)
    
    # Create a cursor to execute commands and retrieve the result set
    cursor = dbaseconnetion.cursor()
    
    # Execute a SQL command to add a new group
    command = "INSERT INTO public.jakoryhma (seurue_id, ryhman_nimi) VALUES (1, 'Testiryhmä');"
    cursor.execute(command)

    # Commit the transaction
    dbaseconnetion.commit()
    print("Uusi tietue lisättiin")

   
# Throw an error if connection or cursor creation fails                                     
except(Exception, psycopg2.Error) as e:
    print("Tietokantayhteydessä tapahtui virhe", e)

# If or if not successfull close the cursor and the connection   
finally:
    if (dbaseconnetion):
        cursor.close()
        dbaseconnetion.close()
        print("Yhteys tietokantaan katkaistiin")
