FROM php:8.2-apache

#Most of this comes directly from the WordPress docker image
RUN set -eux
RUN apt-get update
RUN apt-get install -y --no-install-recommends ghostscript git less ssh-client mariadb-client
RUN apt-get install -y --no-install-recommends libjpeg-dev libjpeg62-turbo-dev libpng-dev libfreetype6-dev libzip-dev libmagickwand-dev
RUN rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j "$(nproc)" bcmath
RUN docker-php-ext-install -j "$(nproc)" exif
RUN docker-php-ext-install -j "$(nproc)" gd
RUN docker-php-ext-install -j "$(nproc)" mysqli
RUN docker-php-ext-install -j "$(nproc)" opcache
RUN docker-php-ext-install -j "$(nproc)" zip

RUN pecl install -o -f imagick
RUN pecl install -o -f xdebug
RUN docker-php-ext-enable imagick
RUN docker-php-ext-enable xdebug

#XDebug settings
RUN echo "[XDebug]\nxdebug.remote_enable = 1\nxdebug.remote_autostart = 1" > $PHP_INI_DIR/conf.d/xdebug.ini

#WP recommended PHP settings
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=2'; \
	echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini


# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN rm -rf /var/lib/apt/lists/*

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

ENV ERROR_REPORTING="E_ALL \& \~E_NOTICE \& \~E_STRICT \& \~E_DEPRECATED"
RUN sed -i "s/error_reporting = .*/error_reporting = ${ERROR_REPORTING}/" $PHP_INI_DIR/php.ini

# Enable .htaccess files & mod_rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Install Composer
WORKDIR /tmp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# add vscode user
RUN useradd -ms /bin/bash vscode
RUN usermod -aG www-data vscode

USER www-data
COPY .env .env
COPY utilities/wp-setup.sh wp-setup.sh
COPY utilities/plugins/mailhog-dev.php mailhog-dev.php

#Download WP
WORKDIR /var/www/html
RUN wp core download

USER root
RUN chown -R www-data:www-data /var/www/html/
RUN chmod g+w -R /var/www/html/
RUN find /var/www/html/ -type d -exec chmod g+s {} \;



