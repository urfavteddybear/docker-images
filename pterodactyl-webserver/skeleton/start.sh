#!/bin/bash
set -e

cd /home/container

mkdir -p tmp logs

chmod -R 755 tmp logs webroot || true

rm -rf tmp/* || true

echo "Starting PHP-FPM..."
php-fpm8.2 --fpm-config /home/container/php-fpm/php-fpm.conf

echo "Starting Nginx..."
exec nginx -c /home/container/nginx/nginx.conf -p /home/container/ -g "daemon off;"