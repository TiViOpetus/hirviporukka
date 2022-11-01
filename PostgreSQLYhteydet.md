# PostgreSQL-palvelimen ulkoiset yhteydet
Oletuksena PostgreSQL-palvelimeen voi muodostaa yhteyden vain paikallisesta koneesta. Jos halutaan, että yhteyden voi muodostaa toisesta koneesta tai virtuaalikoneesta tai oikeasta koneesta virtuaalikoneeseen, on tehtävä joitakin muutoksia palvelimen konfiguraatioon.

## postgresql.conf-tiedosto
PostgreSQL-palvelimen `data`-hakemistosta löytyvään `postgresql.conf`-tiedostoon tehdään muutos, jolla se saadaan kuuntelemaan kaikkia verkkokortteja. `*`-merkintä tarkoittaa kaikkia verkkokortteja (loopback-osoite, fyysiset ja virtuaaliset verkkokortit)

```
# - Connection Settings -

listen_addresses = '*'		# what IP address(es) to listen on;
					# comma-separated list of addresses;
					# defaults to 'localhost'; use '*' for all
					# (change requires restart)
port = 5432				# (change requires restart)
max_connections = 100			# (change requires restart)
```
## pg_hba.conf-tiedosto
Tämä tiedosto määrittelee, mihin tietokantaan, millä käyttäjätunnuksella, mistä ip-osoitteista ja mitä autentikaatiota käyttämällä saa muodostaa yhteyksiä palvelimeen:

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     scram-sha-256
# IPv4 local connections (loopback IPv4):
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections (loopback IPv6):
host    all             all             ::1/128                 scram-sha-256
# Allow connections from local network VMNet 8 (NAT)
host    all             all             192.168.196.0/24        scram-sha-256
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     scram-sha-256
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256

```
Tiedostoon lisätään rivi, jossa on oman lähiverkon tiedot, meillä `VMNet 8`. Luokissa NAT-verkon osoite on määritelty keskitetysti olemaan `192.168.196.0/24`. Todellinen tietokone käyttää NAT-verkossa IP-osoitetta `192.168.196.1`. Kotona VMWare arpoo aina verkon osoitealueen. Se kannattaa tarkistaa joko oikean tietokoneen asetuksista tai käyttämällä VMWare Network Editor -työkalua. Sen avula voi halutessaan muuttaa osoitesarjan samaksi kuin koulussa. Silloin koneiden siirto kodin ja koulun välillä ei vaadi asetusmuutoksia. Windows-koneessa oikean koneen osoitteet saa tarkistettua komennolla `ipconfig /all`. Luokkien Alma Linux -koneissa osoitteet selviävät `ifconfig`-komennolla.
