#!/bin/sh
yum install -y httpd git
service httpd start
chkconfig httpd on
git clone https://github.com/andrealmeidaa/DSWeb.git
cp DSWeb/exemplo04-bulma/*.html /var/www/html