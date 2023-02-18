#!/bin/bash
# file representasi proses deploy aplikasi serta mysql
# mulai dari isntalasi hingga setting yang diperlukan

sudo apt-get update -y

# Set firewall
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 443
sudo ufw allow 80
sudo ufw allow 22

# install dependencies
sudo apt-get install apt-transport-https unzip -y
sudo apt-get install debconf-utils -y

# install nginx
sudo apt-get install nginx -y

# clone repo for web
cd /var/www
git clone https://gitlab.com/kuuhaku86/web-penugasan-individu.git

# install php
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get install php8.0-common php8.0-cli -y

#install php package
sudo apt-get install php8.0-mbstring php8.0-xml -y
sudo apt-get install php8.0-curl php8.0-mysql php8.0-fpm -y

# install composer
cd web-penugasan-individu
sudo apt-get install composer -y
sudo composer install
sudo composer update
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer

# Nginx config
sudo touch /etc/nginx/sites-available/config.conf
sudo nano /etc/nginx/sites-available/config.conf
server {
        listen 80;
        root /var/www/web-penugasan-individu/public;
        index index.php index.html index.htm index.nginx-debian.html;

        server_name my-zienzdn.site;

        location / {
                try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}

# asymlink to sites-enabled directory
sudo ln -s /etc/nginx/sites-available/example.conf /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-enabled/default

# install MYSQL
sudo apt-get install mysql-server -y

# Set MYSQL password
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password kelompok2"

# deploy mysql
sudo mysql -u kelompok2 -p
CREATE DATABASE KELOMPOK2;
CREATE USER 'kelompok2'@'%' IDENTIFIED BY 'kelompok2';
GRANT ALL PRIVILEGES ON KELOMPOK2.* TO 'kelompok2'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# app env setting
sudo cp .env.example .env
sudo nano /var/www/project/.env
# hal yang perlu diganti / dilengkapi
DB_DATABASE=KELOMPOK2
DB_USERNAME=kelompok2
DB_PASSWORD=kelompok2

# generate key dan migrate
sudo php artisan key:generate
sudo php artisan migrate

# apply setting
sudo service nginx restart
