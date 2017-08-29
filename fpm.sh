#!/bin/bash

chown -R www-data:www-data /var/www/html
/usr/sbin/php-fpm5.6 -c /etc/php/5.6/fpm
