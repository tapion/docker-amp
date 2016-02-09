FROM centos:centos7
MAINTAINER Amparador

RUN yum -y update; yum clean all
#Repo con nginx
RUN yum -y install epel-release; yum clean all
RUN yum -y install  tar \
            vim \
            nginx \
            php \
            php-fpm \
            php-common \
            php-pdo \
            php-devel \
            gcc \
            libtool \
            git \
            make \
            php-pgsql \
            python-setuptools; yum clean all
RUN yum -y nginx; yum clean all
# Installing supervisor
RUN easy_install pip
RUN pip install supervisor

WORKDIR /tmp
##install phalcon php
RUN git clone git://github.com/phalcon/cphalcon.git && \
    cd cphalcon/build && \
    ./install && \
    rm -rf /tmp/cphalcon && \
	  echo 'extension=phalcon.so' >> /etc/php.d/phalcon.ini

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

RUN echo '<?php phpinfo();' > /var/www/index.php

EXPOSE 80

# Executing supervisord
CMD ["supervisord", "-n"]
