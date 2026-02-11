#!/bin/ash
rm -rf /home/container/tmp/*

echo "Starting CRON..."
crontab /home/container/crontab
crond -L /home/container/logs/cron.log

echo "Starting PHP-FPM..."
/usr/sbin/php-fpm84 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "Starting Nginx..."
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/