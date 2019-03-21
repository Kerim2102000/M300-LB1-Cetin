# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.define "database01" do |db|
    db.vm.box = "ubuntu/xenial64"
	db.vm.provider "virtualbox" do |vb|
	  vb.memory = "512"  
	end
    db.vm.hostname = "database01"
    db.vm.network "private_network", ip: "192.168.10.100"
    # MySQL Port nur im Private Network sichtbar
	# db.vm.network "forwarded_port", guest:3306, host:3306, auto_correct: false
  	db.vm.provision "shell", path: "db.sh"
  end
  
  config.vm.define "webserver01" do |web|
    web.vm.box = "ubuntu/xenial64"
    web.vm.hostname = "webserver01"
    web.vm.network "private_network", ip:"192.168.10.101" 
	web.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true
	web.vm.provider "virtualbox" do |vb|
	  vb.memory = "512"  
	end     
  	web.vm.synced_folder ".", "/var/www/html"  
	web.vm.provision "shell", inline: <<-SHELL
		sudo apt-get update
		sudo apt-get -y install debconf-utils apache2 nmap
		sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 1234'
		sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 1234'
		sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client  
		# Admininer SQL UI 
		sudo mkdir /usr/share/adminer
		sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
		sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
		echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
		sudo a2enconf adminer.conf 
		sudo service apache2 restart 
		echo '127.0.0.1 localhost webserver01\n192.168.10.100 database01' > /etc/hosts
		
		#Reverse Proxy installieren
		sudo apt-get -y install libapache2-mod-proxy-html
		sudo apt-get -y install libxml2-dev
		
		#Reverse Proxy module unter Apache aktivieren
		sudo a2enmod proxy
		sudo a2enmod proxy_html
		sudo a2enmod proxy_http

		#SSH port 22 für host Ip erlauben
			#sudo ufw allow from 10.71.10.xxx to any port 22
			#Port 3306 für MySQL für den Webserver öffnen
			sudo ufw allow from 192.168.10.101 to any port 3306

SHELL
	end  
 end
