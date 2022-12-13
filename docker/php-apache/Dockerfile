FROM php:8.0-apache

RUN apt-get update && \
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev zip libicu-dev \
    \
    # https://github.com/Yoast/plugin-development-docker/pull/52
    default-mysql-client && \
    \
    docker-php-ext-install pdo pdo_mysql mysqli iconv gd && \
    \
    a2enmod rewrite && \
    sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
