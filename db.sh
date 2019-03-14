#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#

# root Password setzen, damit kein Dialog erscheint und die Installation haengt!
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root4me'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root4me'

# Installation
sudo apt-get install -y mysql-server

# MySQL Port oeffnen
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# User fuer Remote Zugriff einrichten - aber nur fuer Host web 192.168.10.101
mysql -uroot -root4me <<%EOF%
	CREATE USER 'root'@'192.168.10.101' IDENTIFIED BY 'root4me';
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.10.101';
	FLUSH PRIVILEGES;
%EOF%

# Restart fuer Konfigurationsaenderung
sudo service mysql restart