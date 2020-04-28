FROM centos:centos7

MAINTAINER wangchuang<mail.wangchuang@gmail.com>

EXPOSE 80 443

ADD nginx.repo /etc/yum.repos.d/

RUN yum-config-manager --enable nginx-stable \
    && yum -y install nginx \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && sed -i 's@worker_processes.*@worker_processes  auto;@g' /etc/nginx/nginx.conf \
    && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php71 \
    && yum -y install php  php-mysqlnd php-devel php-pear php-opcache php-pdo php-pecl-apcu php-fpm git php-mbstring php-gd php-pecl-zip redis wget  python-setuptools\
    && echo "maxmemory-policy  allkeys-lru " > /etc/redis.conf \
    && echo "maxmemory 2147483648 " > /etc/redis.conf \
    && sed -i 's@memory_limit.*@memory_limit = 1024M@g' /etc/php.ini \
    && sed -i 's@apache@nginx@g' /etc/php-fpm.d/www.conf \
    && sed -i 's@listen = 127.0.0.1:9000@listen = /var/run/php-fpm.sock@g' /etc/php-fpm.d/www.conf \
    && mkdir /run/php-fpm \
    && rm -rf /usr/share/nginx/html \
    && curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer \
    && yum clean all  \
    && wget https://files.pythonhosted.org/packages/44/80/d28047d120bfcc8158b4e41127706731ee6a3419c661e0a858fb0e7c4b2d/supervisor-3.3.0.tar.gz \
    && tar xf supervisor-3.3.0.tar.gz \
    && cd supervisor-3.3.0/ \
    && python setup.py install \
    && echo_supervisord_conf > /etc/supervisord.conf \
    && sed -i '140 s/;//g' /etc/supervisord.conf \
    && sed -i '141 s/;//g' /etc/supervisord.conf \
    && sed -i 's@^files.*@files = /etc/supervisord/*.conf@g' /etc/supervisord.conf \
    && cd / \
    && rm -rf supervisor-3.3.0.tar.gz  supervisor-3.3.0 


ADD nginx-site.conf /usr/local/nginx/conf.d/default.conf
ADD cloudflare.pem /usr/local/nginx/conf/ssl/cloudflare.pem
ADD cloudflare.key /usr/local/nginx/conf/ssl/cloudflare.key
ADD ccshop.conf /etc/supervisord/


COPY start.sh /start.sh


CMD ["/bin/sh", "/start.sh"]