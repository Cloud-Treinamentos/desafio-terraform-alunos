#!/bin/bash
sudo apt update
sudo apt install apache2 apache2-utils libapache2-mod-php php php-mysql php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip mysql-client-core-8.0 stress  -y
sudo systemctl restart apache2
sudo wget -c https://wordpress.org/wordpress-6.1.1.tar.gz
sudo tar -xzvf wordpress-6.1.1.tar.gz

sleep 15

sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html

sleep 10

sudo chmod -R 777 /var/www/html/

cat /var/www/html/wp-config-sample.php \
| sed 's/database_name_here/wordpress/' \
| sed 's/username_here/adminadmin/' \
| sed 's/password_here/adminadmin/' \
| sed 's/localhost/${rds_endpoint}/' \
> /var/www/html/wp-config.php

sudo rm -rf /var/www/html/index.html
sudo systemctl restart apache2