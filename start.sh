#!/bin/sh
/usr/bin/redis-server /etc/redis.conf
/usr/sbin/php-fpm 
/usr/sbin/nginx
while :
do
    sleep 60
    /usr/bin/php /usr/share/nginx/html/artisan ccshop:clear-tags-cache
done