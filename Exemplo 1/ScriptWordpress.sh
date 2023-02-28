#!/bin/bash
cd /etc/php/8.1/apache2
sudo rm.php.ini
sudo wget https://gitlab.com/czornoff1/desafiogrupo4/-/raw/main/php.ini

cd /var/www
sudo rm -r html
sudo mkdir html
sudo mount -t efs -o tls ${efs_id}:/ /var/www/html
cd /var/www/html

EC2AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo '<center><h1>Esta EC2 estah na Zona: AZID </h1></center>' | sudo tee /var/www/html/az.txt
sed "s/AZID/$EC2AZ/" /var/www/html/az.txt | sudo tee /var/www/html/az.html

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xf latest.tar.gz --strip-component 1

sudo chown -R www-data:www-data /var/www/html

sudo systemctl reload apache2