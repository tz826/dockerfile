FROM docker.io/library/debian:11 as build

ENV NGX_VERSION "1.22.1"

COPY sources.list /etc/apt/sources.list
ADD nginx-${NGX_VERSION}.tar.gz /

RUN set -eux; \
        apt-get update; \
        apt-get install -y gcc g++ make libpcre3-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev; \
        apt-get install -y pax-utils; \
            \
        groupadd --system --gid 999 nginx; \
        adduser --system --shell /usr/sbin/nologin --no-create-home --uid 999 --gid 999 --disabled-login nginx; \
            \
        cd nginx-${NGX_VERSION}; \
        ./configure \
            --prefix=/usr/local/nginx \
            --modules-path=/usr/local/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --with-compat \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-pcre \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module; \
        make; \
        make install


FROM docker.io/library/debian:11 as running

COPY --from=build /usr/local/nginx /usr/local/nginx
COPY --from=build /etc/nginx /etc/nginx
COPY sources.list /etc/apt/sources.list
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d
COPY docker-entrypoint.sh /

RUN set -eux; \
            \
        groupadd --system --gid 999 nginx; \
        adduser --system --shell /usr/sbin/nologin --no-create-home --uid 999 --gid 999 --disabled-login nginx; \
            \
        mkdir -p /var/log/nginx; \
        ln -svf /dev/stdout /var/log/nginx/access.log; \
        ln -svf /dev/stderr /var/log/nginx/error.log; \
        ln -sv /usr/local/nginx/sbin/nginx /usr/sbin; \
            \
        apt-get update; \
            \
        apt-get -y install curl iputils-ping net-tools procps; \
            \
        rm -rf /var/lib/apt/lists/*; \
            \
        chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]
