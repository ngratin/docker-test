#!/bin/bash

echo "installing" > /var/log/container_status

# setup webserver doc roots
DOCROOT=$(echo $WEBSERVER_DOCUMENT_ROOT | sed 's/[]\/$*.^|[]/\\&/g')
sed -i -- "s/##WEBSERVER_DOCUMENT_ROOT##/$DOCROOT/g" /etc/nginx/sites-available/default

# Clean double slashes
sed -i -- 's/www\/\//www\//g' /etc/nginx/sites-available/default

echo "Running init script"
bash /tmp/init/init.sh >> /var/log/startup.log 2>&1

echo "complete" > /var/log/container_status

mkdir /var/log/supervisor

/usr/bin/supervisord
