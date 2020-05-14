#!/bin/sh
supervisord -c /etc/supervisord.conf
/usr/bin/redis-server /etc/redis.conf
crond
while :
do
    sleep 60
done