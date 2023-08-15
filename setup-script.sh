#!/bin/bash

# Update and upgrade
sudo apt update
sudo apt upgrade -y

# Install necessary software
sudo apt install -y nginx mysql-server php-fpm

# Secure MySQL installation
sudo mysql_secure_installation

# Install PHP and necessary modules
sudo apt install -y php php-mysql php-cli php-fpm

# Install WordPress
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rm latest.tar.gz
sudo mv wordpress/* .
sudo rm -r wordpress

# Configure WordPress
sudo mv wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/wordpress/" wp-config.php
sudo sed -i "s/username_here/wordpressuser/" wp-config.php
sudo sed -i "s/password_here/$MYSQL_WORDPRESS_PASSWORD/" wp-config.php

# Configure Nginx for WordPress
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
sudo cp /path/to/your/nginx-config.conf /etc/nginx/sites-available/default
sudo systemctl restart nginx

# Set up WordPress database and user
sudo mysql -u root -p <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY '$MYSQL_WORDPRESS_PASSWORD';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
