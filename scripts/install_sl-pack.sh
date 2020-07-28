#!/bin/bash

cd /var/www/html/magento2

composer require symfonysi/magento2-sl-si
bin/magento setup:static-content:deploy sl_SI -f
bin/magento cache:clean
bin/magento setup:upgrade
bin/magento cache:flush
