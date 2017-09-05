FROM ubuntu:16.04

LABEL maintainer="mobingi,Inc."

RUN apt-get update && apt-get install -y --no-install-recommends \
		nginx \
		software-properties-common \
		supervisor \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --no-install-recommends \
		php5.6 \
		php5.6-cli \
		php5.6-curl \
		php5.6-dev \
		php5.6-fpm \
		php5.6-gd \
		php5.6-imap \
		php5.6-mbstring \
		php5.6-mcrypt \
		php5.6-mysql \
		php5.6-pgsql \
		php5.6-pspell \
		php5.6-xml \
		php5.6-xmlrpc \
		php-apcu \
		php-memcached \
		php-pear \
		php-redis \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN sed -i \
	-e "s/keepalive_timeout 65;/keepalive_timeout 2;\n\tclient_max_body_size 100m;/" \
	/etc/nginx/nginx.conf &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf

RUN sed -i \
	-e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" \
	-e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" \
	-e "s/post_max_size = 8M/post_max_size = 100M/" \
	/etc/php/5.6/fpm/php.ini

RUN sed -i \
	-e "s/;daemonize = yes/daemonize = no/" \
	/etc/php/5.6/fpm/php-fpm.conf

RUN sed -i \
	-e "s/;catch_workers_output = yes/catch_workers_output = yes/" \
	/etc/php/5.6/fpm/pool.d/www.conf

RUN mkdir /run/php
RUN chown -R www-data:www-data /var/www/html

COPY config /config
COPY nginx.conf /etc/nginx/sites-available/default
COPY run.sh /run.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 755 /*sh

EXPOSE 80
CMD ["/run.sh"]
