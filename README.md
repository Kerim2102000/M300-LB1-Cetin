
# **Modul 300 LB1 Dokumentation** 

# Inhaltsverzeichnis
  - [01 - Umgebung](#01---umgebung)
  - [02 - Verwendetet Tools](#02---verwendetet-tools)
  - [03 - Wissenstand](#03---wissenstand)
    - [03.1 - Linux](#03.1---linux)
    - [03.2 - Virtualisierung](#03.2---virtualisierung)
    - [03.3 - Vagrant](#03.3---vagrant)
    - [03.4 - Versionverwaltung/Git](#03.4---versionverwaltunggit)
    - [03.5 - Markdown](#03.5---markdown)
    - [03.6 - Systemsicherheit](#03.6---systemsicherheit)
  - [04 - Lernschritte](#04---lernschritte)
    - [04.1 - Vagrant](#04.1---Vagrant)
    - [04.2 - Netzwerkplan](#04.2---netzwerkplan)
    - [04.3 - Installation Webserver und Datenbank](#04.3---installation-Webserver-und-Datenbank)
  - [05 - Sicherheitsaspekte](#05---Sicherheitsaspekte)
    - [05.1 - UFW - Firwall](#05.1---UFW-Firewall)
    - [05.2 - SSH-Zugriff](#05.2---SSH-Zugriff)
    - [05.3 - Webserver per HTTPS sichern](#05.3---Webserver-per-HTTPS-sichern)
  - [06 - Testfälle](#06---Testfälle)
  - [07 - Wissenzuwachs](#07---Wissenzuwachs)
    - [07.1 - Linux](#07.1---Linux)
    - [07.2 - Virtualisierung](#07.2---Virtualisierung)
    - [07.3 - Vagrant](#07.3---Vagrant)
    - [07.4 - Versionverwaltung/Git](#07.4---Versionverwaltung/Git)
    - [07.5 - Markdown](#07.5---Markdown) 
    - [07.6 - Systemsicherheit](#07.6---Systemsicherheit)     
  - [08 - Reflektion](#08---Reflektion)

## 01 - Umgebung
* Vagrant
* Visual Studio
* Virtual Box 6.0
* Git-Client
* VM

## 02 - Verwendetet Tools
* Virtualbox 6.0
* Vagrant
* Visual Studio Code
* Git-Client (SSH-Key)

## 03 - Wissenstand
### 03.1 - Linux
Linux Grundkenntnisse sind vorhanden jedoch im Betrieb eher gelegentlich zu tun.

### 03.2 - Virtualisierung
Erfahrung in Virtualisierung mit ESXi, VMware und Virtual Box. Server Umgebungen Virtualisierung im Betrieb geplant und ausgeführt. 

### 03.3 - Vagrant
Noch keine Vorkenntnisse vorhanden.

### 03.4 - Versionverwaltung/Git
Erfahrung im Betrieb mit Versionverwaltung Document Management Systemen und Cloud. Mit GitHub noch wenige Erfahrungen gemacht. Grundsätzlich sollte es mir nicht schwer fallen mit GitHub zu arbeiten. 

### 03.5 - Markdown
Noch keine Vorkenntnisse vorhanden.

### 03.6 - Systemsicherheit
Firewalls im Betrieb konfiguriert Linux Basierend SonicWall, ZyWALL, Cisco. Planung von Sicherheitskonzepten schon in der TBZ realsiert. Diese Kenntnisse sollen für die LB1 ausreichen. 

## 04 - Lernschritte

### 04.1 - Vagrant

**Befehle**

  *vagrant init* - Damit wird im aktuellen Verzeichnis die Vagant-Umgebung initialisiert

  *vagrant up* - Das Vagrantfile wird gelesen und die VMs werden erstellt

  *vagrant ssh* - Baut eine SSH-Verbindung zur gewünschten VM auf

  *vagrant status* - Zeigt den aktuellen Status der VM an

  *vagrant port* - Zeigt die Weitergeleiteten Ports der VM an

  *vagrant halt* - Stoppt die laufende Virtuelle Maschine

  *vagrant destroy* - Stoppt die Virtuelle Maschine und zerstört sie.

  *vagrant destroy* - Stoppt die Virtuelle Maschine und zerstört sie

**Bestehende VM aus Vagrant Cloud erstellen (Webserver und Datenbank)**
1. Mit *vagrant init* Vagrantfile im gewünschten Verzeichnis erstellt.
2. OS auswhlen von der Cloud https://app.vagrantup.com/boxes/search Ubuntu/xenial64 für meine VM usgewählt.
3. Vagrantfile mit den entsprechenden Parameter erstellen
4. Mit dem Befehl *vagrant up* werden nun die Virtuellen Maschinen erstellt

### 04.2 - Netzwerkplan


    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x und Privates Netz 192.168.10.1  !                 
    ! Port: 443 (192.158.10.101:443)                                !	
    !                                                               !	
    !    +--------------------+          +---------------------+    !
    !    ! Web Server         !          ! Datenbank Server    !    !       
    !    ! Host: webserver01  !          ! Host: database01    !    !
    !    ! IP: 192.168.10.101 ! <------> ! IP: 192.168.10.100  !    !
    !    ! Port: 443          !          ! Port 3306           !    !
    !    ! Nat: -             !          ! Nat: -              !    !
    !    +--------------------+          +---------------------+    !
    !                                                               !	
    +---------------------------------------------------------------+


### 04.3 - Installation Webserver und Datenbank
Web Server mit Apache und MySQL User Interface Adminer und Datenbank Server mit MySQL.
Für die Installation der beiden VMs wurde ein Vagrantfile erstellt, in dem alle Angaben wie IP, Hostname, OS etc. befindet. Ausserdem befindet sich ein Shellscript das auf der Datenbankserver MySQL installiert. Auf dem Webserver wurde Apache installiert und auf dem Datenbankserver «Adminer SQL» um die Dantebank über das Web zu verwalten. 
Das Userinterface ist über https://192.168.10.101/adminer.php erreichbar mit dem User 'admin' anmelden. 

## 05 - Sicherheitsaspekte
Beim Sicherheitsaspekt wurde folgende Einstellungen gemacht.

### 05.1 - UFW Firewall

Ausgabe der offenen Ports
    $ netstat -tulpen

Installation
    $ sudo apt-get install ufw

Start / Stop
    $ sudo ufw status
    $ sudo ufw enable
    $ sudo ufw disable

Firewall-Regeln
    # Port 80 (HTTP) öffnen für alle
    vagrant ssh web
    sudo ufw allow 80/tcp
    exit

    # Port 443 (HTTPS) öffnen für alle
    vagrant ssh web
    sudo ufw allow 443/tcp
    exit

    # Port 22 (SSH) nur für den Host (wo die VM laufen) öffnen
    vagrant ssh web
    sudo ufw allow to any port 22
    exit

    # Port 3306 (MySQL) nur für den web Server öffnen
    vagrant ssh database
    sudo ufw allow from 192.168.10.100 to any port 3306
    exit

Zugriff testen
    $ curl -f 192.168.10.101
    $ curl -f 192.168.10.100:3306

### 05.2 - SSH-Zugriff

Auf eine VM wird mit folgendem Befehl per SSH zugegriffen: vagrant ssh webserver01 und vagrant ssh database01

### 05.3 - Webserver per HTTPS sichern

    # Default Konfiguration in /etc/apache2/sites-available freischalten (wird nach sites-enabled verlinkt
    sudo a2ensite default-ssl.conf

    # SSL Modul in Apache2 aktivieren
    sudo a2enmod ssl

    # Optional HTTP deaktivieren
    sudo a2dissite 000-default.conf 

    # Datei /etc/apache2/ports.conf editieren und <Listen 80> durch Voranstellen von # deaktivieren
    sudo nano /etc/apache2/ports.conf

    # Unter default-ssl.conf die Server IP eintragen 
    sudo nano /etc/apache2/sites-available/default-ssl.conf
    <IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerName 192.168.10.101

                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

        </VirtualHost>
  </IfModule>

    # Apache Server neustarten
    sudo service apache2 restart


## 06 - Testfälle

|   Test| Resultat  |
|---|:-:|
|Vom Client auf https://192.168.10.101/adminer.php zugreifen  | Funktioniert. Das MySQL Adminer Portal (192.168.10.100) wird angezeigt  |
|Vom Client auf den Webserver (192.168.10.101) zugreifen per SSH |Funktioniert, da eine SSH Verbindung vom Client her zugelassen wurde in der Firewall|
| Vom Client auf die Datenbank (192.168.10.100) zugreifen per SSH |Funktioniert, da eine SSH Verbindung vom Client her zugelassen wurde in der Firewall|
|Mit dem Admin User sich auf die Datenbank anmelden|Die Datenbank aktzeptiert den zugang des Webserver mit dem Admin User|


## 07 - Wissenszuwachs

### 07.1 - Linux
Meine Linux kenntnisse haben sich mit recherchen stark verbessert. 

### 07.2 - Virtualisierung
Bei der Virtualisierung war mein Vorwissen schon recht gut das konnte ich noch im Bericht Linux verbessern.

### 07.3 - Vagrant
Mit Vagrat zu arbeiten hat sehr viel spass gemacht, es hat mir aufgezeigt das es ein sehr mächtiges Programm ist das vieles bitet. 

### 07.4 - Versionverwaltung/Git
Die Versionsverwaltung hat sich sehr positiv bewährt, weil ich jede Veränderung im Vagrantfile sofort erkennen konnte. 

### 07.5 - Markdown
Mit den Erstellen von Markdown funktionierte es von Anfang an gut. Es brauchte eine gewisse zeit um ein schöne Darstellung mit den Grössen und Schriften
hinzubekommen. Doch am schluss ist mir auch dies gelungen. 

### 07.6 - Systemsicherheit
Bei implementieren der Sicherheitsaspekten verlief alles recht gut es gab keine schwierigkeiten. 

## 08 - Reflektion
Die LB01 verlief im Grossen ganzen recht gut. Das Erstellen der beiden VM mit Vagrant funktionierte ohne grosse Probleme. Am Anfang
hatte ich ein paar Probleme mit der Datenbank irgendwas funktionierte nich mit den Zugriffsrechten. Mit dieser LB habe ich Vagrant viel besser
kennen gelernt. Zeitlich bin ich gut mit der LB1 durchgekommen und bin mit meiner Arbeit zufrieden.  

