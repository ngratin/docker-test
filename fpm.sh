#!/bin/bash

chown -R www-data /usr/share/nginx/www
chgrp -R www-data /usr/share/nginx/www

env | sed "s/\([^=]*\)=\(.*\)$/env[\1]='\2'/" > /usr/local/etc/conf.d/env.conf
/usr/sbin/php5-fpm -c /etc/php5/fpm
