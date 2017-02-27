FROM ubuntu:14.04

ARG TEST_VALUE=7.0

RUN apt-get update
RUN apt-get install -y apache2
RUN touch /$TEST_VALUE-test

COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
