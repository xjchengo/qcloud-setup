#!/bin/bash
#同步本地环境与服务器环境下的代码
#本地环境代码同步到服务器环境下
#服务器Runtime同步到本地

delay=10
time_every_min=4

i=0
while [ $i -lt $time_every_min ]
do
    rsync -az --include-from="/vagrant/rsync_push.rule" /vagrant/wwwroot/ xjchen@203.195.158.252:/var/www/wwwroot
    rsync -az --include-from="/vagrant/rsync_get.rule" xjchen@203.195.158.252:/var/www/wwwroot/ /vagrant/wwwroot/
    sleep $delay
    i=$(($i + 1))
done