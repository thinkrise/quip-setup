#!/usr/bin/env bash

source ./privileges.sh

function install_packages () 
{
    apt-get update
    install_httpd
    install_database
    install_php
}

function install_httpd() 
{
    apt-get install apache2 
}

function install_database()
{
    apt-get install mysql-server php5-mysql
    mysql_install_db
    mysql_secure_installation 
}

function install_php() 
{
    apt-get install php5 libapache2-mod-php5 php5-mcrypt
}

function install_wordpress() 
{
    curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -zxvf /tmp/wordpress.tar.gz -C /tmp/wordpress
    cd /tmp/wordpress
    mkdir -P /var/www
    cp wp-config-sample.php wp-config.php
    mkdir wp-content/uploads
    chmod 777 wp-content/uploads
    mv -R /tmp/wordpress /var/www/wordpress
    rm /tmp/wordpress.tar.gz
}

if has_root_permissions; then
    install_packages
    install_wordpress
    service apache2 restart
else
    exit 1
fi
