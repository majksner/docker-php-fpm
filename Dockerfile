FROM ubuntu

MAINTAINER Nikola Majksner <majksner@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN apt-get -y dist-upgrade && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:ondrej/php-7.0 && \
    apt-get update && \
    apt-get install -y php7.0-fpm php-curl \
        php-pgsql php-xdebug php-memcached && \
    sed -i "s/date.timezone=.*/date.timezone=UTC/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/date.timezone=.*/date.timezone=UTC/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/expose_php=.*/expose_php=Off/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/post_max_size = 2M/post_max_size = 20M/" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
    rm -Rf /etc/php/7.0/fpm/pool.d/www.conf && \
    mkdir -p /run/php && \
    apt-get -y autoremove && apt-get clean

ADD ./php-fpm/app.conf /etc/php/7.0/fpm/pool.d/app.conf

EXPOSE 9000

VOLUME ["/srv"]

CMD ["/usr/sbin/php-fpm7.0"]
