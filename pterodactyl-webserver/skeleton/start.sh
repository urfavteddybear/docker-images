#!/bin/bash
set -e

cd /home/container


echo "Starting PHP-FPM..."
php-fpm8.2 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "Starting Nginx..."
exec nginx -c /home/container/nginx/nginx.conf -p /home/container/
