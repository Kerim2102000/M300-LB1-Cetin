# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("1") do |config|

  config.vm.define "database01" do |db|
    db.vm.box = "ubuntu/xenial64"
	db.vm.provider "virtualbox" do |vb|
	  vb.memory = "512"  
	end
    db.vm.hostname = "database01"
    db.vm.network "private_network", ip: "192.168.10.100"
  	db.vm.provision "shell", path: "db.sh"
  end
  
  config.vm.define "webserver01" do |web|
    web.vm.box = "ubuntu/xenial64"
    web.vm.hostname = "webserver01"
    web.vm.network "private_network", ip:"192.168.10.101" 
	web.vm.network "forwarded_port", guest:443 host:8080, auto_correct: true
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
	
		#SSH port 22 für host Ip erlauben
			sudo ufw allow from 10.4.57.55 to any port 22
			#Port 3306 für MySQL für den Webserver öffnen
			sudo ufw allow from 192.168.10.101 to any port 3306

SHELL
	end  
 end
