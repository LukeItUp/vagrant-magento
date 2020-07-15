CREATE DATABASE magentodb
CREATE USER 'magentouser'@'localhost'
SET PASSWORD FOR 'magentouser'@'localhost' = PASSWORD('StRoNg_PaSsWoRd');
GRANT ALL ON magentodb.* TO 'magentouser'@'localhost' IDENTIFIED BY 'StRoNg_PaSsWoRd' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT
