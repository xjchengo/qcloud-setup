#!/bin/bash

MYSQL=`which mysql`
database="test2"
mysql_user="test2"
mysql_password="123456"
root_password="8653125"
Q1="CREATE DATABASE IF NOT EXISTS $database;"
Q2="CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password';"
Q3="GRANT ALL PRIVILEGES ON $database.* TO $mysql_user@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
$MYSQL -uroot -p$root_password -e "$SQL"

if [ $? -ne 0 ];then
    echo "initialize failed"
    exit 1
fi