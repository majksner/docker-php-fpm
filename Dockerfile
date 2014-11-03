FROM debian:wheezy

MAINTAINER Nikola Majksner <majksner@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget

RUN echo "deb http://packages.dotdeb.org wheezy all\ndeb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list && \
	 wget -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
	 apt-get update

RUN apt-get install --no-install-recommends -y \
	curl ca-certificates \
	php5-fpm \
	php5-cli \
	php5-dev \
	php5-xdebug \
	php5-json \
	php5-memcached \
	php5-mysql php5-pgsql \
	php5-mcrypt \
	php5-gd \
	php5-imap \
	php5-curl \
	php5-redis \
	php5-xsl \
	php5-xmlrpc \
	php5-recode \
	php5-readline \
	php5-pspell \
	php-pear

ADD ./php-fpm/app.conf /etc/php5/fpm/pool.d/app.conf

RUN sed -i -e "s/^post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/expose_php = On/expose_php = Off/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;date.timezone =.*/date.timezone = UTC/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php-fpm.conf

RUN sed -i '/daemonize /c \
	daemonize = no' /etc/php5/fpm/php-fpm.conf

# Removing default pool
RUN rm -Rf /etc/php5/fpm/pool.d/www.conf

# Cleaning Up
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose
EXPOSE 9000

# Allow mounting files
VOLUME ["/data"]

# PHP is our entry point
ENTRYPOINT ["php5-fpm", "-F"]
