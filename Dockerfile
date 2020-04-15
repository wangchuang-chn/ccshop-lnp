FROM centos:centos7

MAINTAINER wangchuang<mail.wangchuang@gmail.com>

EXPOSE 80 443

ADD nginx.repo /etc/yum.repos.d/

RUN yum-config-manager --enable nginx-stable \
    && yum -y install nginx \
    && sed -i 's@worker_processes.*@worker_processes  auto;@g' /etc/nginx/nginx.conf \
    && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php71 \
    && yum -y install php  php-mysqlnd php-devel php-pear php-opcache php-pdo php-pecl-apcu php-fpm git php-mbstring php-gd php-pecl-zip \
    && sed -i 's@memory_limit.*@memory_limit = 1024M@g' /etc/php.ini \
    && sed -i 's@apache@nginx@g' /etc/php-fpm.d/www.conf \
    && sed -i 's@listen = 127.0.0.1:9000@listen = /var/run/php-fpm.sock@g' /etc/php-fpm.d/www.conf \
    && mkdir /run/php-fpm \
    && curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer \
    && yum clean all 


ADD nginx-site.conf /usr/local/nginx/conf.d/default.conf
ADD cloudflare.pem /usr/local/nginx/conf/ssl/cloudflare.pem
ADD cloudflare.key /usr/local/nginx/conf/ssl/cloudflare.key


COPY start.sh /start.sh

CMD ["/bin/sh", "/start.sh"]