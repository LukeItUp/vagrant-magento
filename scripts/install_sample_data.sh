#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


cd /var/www/html/

echo 'Cloning repository from github'
git clone https://github.com/magento/magento2-sample-data.git
cd magento2-sample-data
git checkout 2.3.5

echo 'Installing sample data for Magento v2.3.5'
cd ../magento2
php -f ../magento2-sample-data/dev/tools/build-sample-data.php -- --ce-source=.
chown -R :www-data .
find . -type d -exec chmod g+ws {} +
rm -r var/cache/* var/page_cache/*
bin/magento setup:upgrade

echo 'Finished'
