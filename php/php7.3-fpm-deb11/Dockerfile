FROM docker.io/library/debian:11

COPY sources.list-zkd /etc/apt/sources.list
COPY docker-entrypoint.sh /usr/local/bin

ENV PHP_VER 7.3

RUN set -eux; \
            \
        chmod +x /usr/local/bin/docker-entrypoint.sh; \ 
            \
        apt-get update; \
        apt-get -y install \
            curl \
            lsb-release \
            ca-certificates; \
            \
        curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg; \
        echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" >/etc/apt/sources.list.d/php.list; \
        apt-get update; \
            \
        apt-get -y install \
            php${PHP_VER} \
            php${PHP_VER}-fpm \
            php${PHP_VER}-gd \
            php${PHP_VER}-curl \
            php${PHP_VER}-mbstring \
            php${PHP_VER}-mysql; \
            \
        ln -sv /usr/sbin/php-fpm${PHP_VER} /usr/sbin/php-fpm; \
        mkdir -p /run/php/; \
            \
        usermod -u 1000 www-data; \
        groupmod -g 1000 www-data; \
            \
        sed -i.bak -r \
            -e "/^listen\s*=/s/^.*$/;&/g" \
            -e "/^;listen\s*=/i listen = 0.0.0.0:9000" \
            /etc/php/${PHP_VER}/fpm/pool.d/www.conf; \
        sed -i.bak -r \
            -e "/;daemonize\s*=/i daemonize = no" \
            /etc/php/${PHP_VER}/fpm/php-fpm.conf; \
            \
        apt-get -y remove \
            curl \
            lsb-release \
            ca-certificates; \
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "php-fpm" ]


###
# 构建命令
#   docker build --network=host -t noi1031/php:7.3-fpm-deb11 ./
###
# 运行命令
#   docker run -it --rm --network=host --name=php-fpm -v /www/service/:/www/service noi1031/php:7.3-fpm-deb11
###
# 可控环境变量
#           SHORT_OPEN_TAG : 是否启用短标签。可选值 : <On | off>, 默认 : Off
#       MAX_EXECUTION_TIME : 脚本最大运行时间。可选值 : <int_v>, 默认值 30
#           MAX_INPUT_TIME : 最大输入时间。默认值 60
#             MEMORY_LIMIT : 脚本内存限制。默认值 128M
#            POST_MAX_SIZE : post 的数据最大大小。默认值 8M
#             FILE_UPLOADS : 是否允许文件上传。默认值 On
#      UPLOAD_MAX_FILESIZE : 允许上传文件的最大尺寸。默认值 2M
#         MAX_FILE_UPLOADS : 允许同时上传文件的个数。默认值 20
#   DEFAULT_SOCKET_TIMEOUT : socket 超时时间。默认值 60
#          ERROR_REPORTING : 记录的错误日志级别。默认值 E_ALL & ~E_DEPRECATED & ~E_STRICT
#           DISPLAY_ERRORS : 是否输出详细错误信息。默认值 Off
#         CGI_FIX_PATHINFO : 是否开启 pathinfo。默认值 1 (1 为开启，0 为关闭)
#            DATE_TIMEZONE : 设置 php 时区。默认值 UTC (PRC 或 Asia/Shanghai 为中国时区)
###
