FROM ubuntu:14.04
MAINTAINER david.siaw@mobingi.com

RUN apt-get update
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

RUN mkdir -p /var/run/sshd

RUN apt-get install -y nginx
# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN apt-get install -y software-properties-common python-software-properties
RUN LANG=C.UTF-8 add-apt-repository ppa:ondrej/php5-5.6
RUN apt-get update
RUN apt-get install -y php5-fpm php5-cli php5-dev php5-mysql php5-xmlrpc php5-curl php5-gd php-apc php-pear php5-imap php5-mcrypt php5-pspell
# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;clear_env\s*=\s*yes/clear_env = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
#RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;
RUN mkdir /usr/local/etc/conf.d/

ADD nginx.conf /etc/nginx/sites-available/default

ADD run.sh /run.sh
ADD fpm.sh /fpm.sh
RUN chmod 755 /*.sh

COPY php-fpm.conf /etc/php5/fpm/php-fpm.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config /config
COPY sudoers /etc/sudoers

EXPOSE 22 80
CMD ["/run.sh"]
