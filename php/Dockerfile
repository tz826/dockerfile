FROM php:7.3.33-fpm

RUN set -eux; \
            \
        apt-get update; \
            \
        curl -sSLf -o /usr/local/bin/install-php-extensions \
            https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions; \
        chmod +x /usr/local/bin/install-php-extensions; \
            \
        install-php-extensions \
            gd \
            pdo_mysql \
            curl \
            mbstring \
            pcntl \
            mysqli; \
            \
        usermod -u 1000 www-data; \
        groupmod -g 1000 www-data

###
# 构建命令
#   docker build --network=host -t php:7.3.33-fpm-build ./
###