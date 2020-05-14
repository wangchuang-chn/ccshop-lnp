#!/bin/sh
supervisord -c /etc/supervisord.conf
crond
while :
do
    sleep 60
done