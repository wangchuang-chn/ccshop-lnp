#!/bin/sh
supervisord -c /etc/supervisord.conf
service redis start
/usr/sbin/php-fpm 
/usr/sbin/nginx
ping baidu.com