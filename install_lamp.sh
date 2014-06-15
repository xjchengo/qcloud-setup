#!/bin/bash
#install lamp-server and phpmyadmin
#-u mysql用户名 -p mysql密码 -d 数据库名 -r root密码

ROOT_UID=0
E_NOTROOT=87
MYSQL=`which mysql`
# Run as root
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script" >&2
    exit $E_NOTROOT
fi

# Check parameters, need mysql root password
# if [ "$#" -eq '1' ];then
#     password=$1
# else
#     echo "usage: install_lamp password" >&2
#     exit 1
# fi

while test $# -gt 0; do
    case "$1" in
        -u)
            mysql_user=$2
            shift 2
        ;;
        -p)
            mysql_password=$2
            shift 2
        ;;
        -d)
            database=$2
            shift 2
        ;;
        -r)
            root_password=$2
            shift 2
        ;;
        *)
            break
        ;;
    esac
done;

if [ -z "$mysql_user" ] || [ -z "$mysql_password" ] || [ -z "$database" ] || [ -z "$root_password" ]
then
    echo "Usage: $0 -r root_password -u mysql_user -p mysql_password -d database" >&2
    exit 1
fi

apt-get install -y debconf-utils

echo mysql-server-5.5 mysql-server/root_password_again password $root_password | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password password $root_password | debconf-set-selections
apt-get install -y lamp-server^

sleep 20 #等该mysqld服务开启
#create database  
Q1="CREATE DATABASE IF NOT EXISTS $database;"
Q2="CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password';"
Q3="GRANT ALL PRIVILEGES ON $database.* TO $mysql_user@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
$MYSQL -uroot -p$root_password -e "$SQL"

echo phpmyadmin phpmyadmin/dbconfig-install boolean true | debconf-set-selections
echo phpmyadmin phpmyadmin/app-password-confirm password $root_password | debconf-set-selections
echo phpmyadmin phpmyadmin/mysql/admin-pass password $root_password | debconf-set-selections
echo phpmyadmin phpmyadmin/mysql/app-pass password $root_password | debconf-set-selections
echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2 | debconf-set-selections
apt-get install -y phpmyadmin

apt-get install -y php5-curl