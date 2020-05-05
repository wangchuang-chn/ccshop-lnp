#!/bin/sh
supervisord -c /etc/supervisord.conf
/usr/bin/redis-server /etc/redis.conf
/usr/sbin/php-fpm 
/usr/sbin/nginx
ping baidu.com