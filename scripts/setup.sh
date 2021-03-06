#!/bin/bash

MAGENTODB_PASSWORD='StRoNg_PaSsWoRd'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo 'y' | apt update
echo 'y' | apt upgrade
SEPARATOR='---------------------'

echo $SEPARATOR ' Installing prequisites ' $SEPARATOR
echo 'y' | apt-get install nginx mariadb-server git curl software-properties-common

echo $SEPARATOR ' Installing php ' $SEPARATOR
echo 'y' | apt-get install php7.2 php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-ldap php7.2-zip php7.2-curl php7.2-bcmath php7.2-imagick php7.2-xsl php7.2-intl

echo $SEPARATOR ' Installing composer ' $SEPARATOR
bash /vagrant/scripts/setup_composer.sh

echo $SEPARATOR ' Setting up database ' $SEPARATOR
# Create root user with $PASSWORD
# Disallow root remote login
# Remove anonymous user and test table
# Reload privilege tables
# LOGIN: sudo mysql -u root -p $PASSWORD
# (ne vem zakaj moraš s sudo?):
mysql_secure_installation

# --- CREATING TABLES ---
echo $SEPARATOR 'Creating database user: magentouser' $SEPARATOR
echo $SEPARATOR 'You will be prompted for root password' $SEPARATOR
mysql -u root -p -e"
CREATE DATABASE magentodb;
CREATE USER magentouser@localhost;
SET PASSWORD FOR magentouser@localhost = PASSWORD('$MAGENTODB_PASSWORD');
GRANT ALL ON magentodb.* TO 'magentouser'@'localhost' IDENTIFIED BY '$MAGENTODB_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;"

echo $SEPARATOR ' Downloading Magento ' $SEPARATOR
cd /var/www/html
git clone https://github.com/magento/magento2.git
cd magento2/
git checkout 2.3.5
echo $SEPARATOR ' Installing Magento 2.3.5 ' $SEPARATOR
composer install

echo $SEPARATOR ' Finishing up ' $SEPARATOR
chown -R www-data:www-data /var/www/html/magento2/
cd /var/www/html/magento2
#sudo -u www-data php bin/magento cron:install
sudo -u www-data crontab /vagrant/crontab-file

cp /vagrant/magento-nginx.conf /etc/nginx/sites-enabled/magento.conf
service nginx restart
service php7.2-fpm restart


# NOTE: http://127.0.0.1:8080/admin_1r8pn8
