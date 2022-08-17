FROM php:7.3.33-fpm-alpine3.14
ADD ldap-account-manager-8.0.1.tar.bz2 /www/
COPY lam.conf docker-entrypoint.sh /
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

ENV REPO_URL='mirrors.tuna.tsinghua.edu.cn'

RUN set -eux; \
        sed -r -e "s@(^.*//).*org(.*$)@\1${REPO_URL}\2@g" -i /etc/apk/repositories; \
        apk update --no-cache; \
        install-php-extensions bcmath bz2 calendar Core \
            ctype curl date dom exif fileinfo filter ftp \
            gd gettext gmp hash iconv json ldap libxml \
            mbstring openssl pcntl pcre PDO pdo_sqlite \
            Phar readline Reflection session SimpleXML \
            sockets SPL sqlite3 standard tokenizer wddx \
            xml xmlreader xmlwriter xsl "Zend OPcache" zip zlib
RUN apk add --no-cache nginx; \
        mv /www/ldap-account-manager*/ /www/lam; \
        rm -r /etc/nginx/http.d/default.conf; \
        cp /lam.conf /etc/nginx/http.d/; \
        ln -svf /dev/stdout /var/log/nginx/access.log; \
        ln -svf /dev/stderr /var/log/nginx/error.log; \
        nginx -t; \
        cd /www/lam/config; \
        \cp config.cfg.sample config.cfg; \
        \cp unix.sample.conf lam.conf; \
        chown -R nginx:nginx /www/; \
        cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
        sed -r \
            -e "s/www-data/nginx/g" \
            -i.bak /usr/local/etc/php-fpm.d/www.conf; \
        chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]
