FROM ubuntu:trusty

MAINTAINER Nikola Majksner <majksner@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV COMPOSER_VERSION 1.0.0-beta1

RUN echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/ondrej.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get update && \
    apt-get install -y ca-certificates libxrender1 libxext6 php7.0-fpm \
        php7.0-xml php7.0-curl php7.0-json php7.0-cgi php7.0-soap php7.0-mbstring \
        php7.0-zip php7.0-pgsql php-xdebug php-memcached && \
    sed -i "s/date.timezone=.*/date.timezone=UTC/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/date.timezone=.*/date.timezone=UTC/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/expose_php=.*/expose_php=Off/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/post_max_size = 2M/post_max_size = 20M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
        --filename=composer --version=${COMPOSER_VERSION} && \
    rm -Rf /etc/php/7.0/fpm/pool.d/www.conf && \
    mkdir -p /run/php && \
    apt-get -y remove software-properties-common && \
    apt-get -y autoremove && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /dev/stdout /var/log/php7.0-fpm.log

ADD ./php-fpm/app.conf /etc/php/7.0/fpm/pool.d/app.conf
EXPOSE 9000
USER www-data
WORKDIR /var/www/html
CMD ["/usr/sbin/php-fpm7.0"]