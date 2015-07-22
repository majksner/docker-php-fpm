FROM centos:centos7
MAINTAINER Nikola Majksner <majksner@gmail.com>

RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum --enablerepo=remi,remi-php56 install -y php-fpm php-common \
    php-pecl-amqp php-cli php-pear php-pdo php-pgsql php-pecl-xdebug  \
    php-opcache php-soap php-pecl-memcached php-gd \
    php-mbstring php-xml && \
    yum clean all

ADD ./php-fpm/app.conf /etc/php-fpm.d/app.conf

RUN sed -i -e "s/^post_max_size = 8M/post_max_size = 20M/g" /etc/php.ini && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php.ini && \
    sed -i -e "s/expose_php = On/expose_php = Off/g" /etc/php.ini && \
    sed -i -e "s/;date.timezone =.*/date.timezone = UTC/g" /etc/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php-fpm.conf && \
    sed -i -e "s/daemonize = yes/daemonize = no/g" /etc/php-fpm.conf && \
    rm -Rf /etc/php-fpm.d/www.conf

EXPOSE 9000

VOLUME ["/var/www/html"]

ENTRYPOINT ["php-fpm", "-F"]
