#!/bin/sh
/usr/bin/redis-server /etc/redis.conf
/usr/sbin/php-fpm 
/usr/sbin/nginx
while :
do
    sleep 3600
done