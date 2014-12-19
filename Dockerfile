FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN docker-php-ext-install mysqli

RUN apt-get update && apt-get install -y libxml2-dev  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install soap \
	&& apt-get purge --auto-remove -y libxml2-dev

RUN apt-get update && apt-get install -y re2c zlib1g-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install zip \
	&& apt-get purge --auto-remove -y re2c zlib1g-dev

RUN apt-get update && apt-get install -y libpng12-dev libfreetype6-dev libjpeg8-dev && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-jpeg-dir=/usr --with-freetype-dir=/usr \
	&& docker-php-ext-install gd \
	&& apt-get purge -y libpng12-dev libfreetype6-dev libjpeg8-dev


RUN docker-php-ext-install mbstring

RUN docker-php-ext-install opcache

RUN apt-get update && apt-get install -y graphicsmagick && rm -rf /var/lib/apt/lists/*

COPY etc/php.ini /usr/local/etc/php/conf.d/zzz-typo3.ini

VOLUME /var/www/html

# Shared volume writable on Boot2docker OSX
# https://github.com/boot2docker/boot2docker/issues/581#issuecomment-62491280
RUN usermod -u 1000 www-data
