FROM alpine:3.16 as build

ENV VERSION 2.5.0
ENV REPO_URL='mirrors.tuna.tsinghua.edu.cn'
# ENV REPO_URL='mirrors.aliyun.com'
# ENV HAPROXY_URL https://www.haproxy.org/download/2.5/src/haproxy-2.5.0.tar.gz
# ENV HAPROXY_URL https://www.haproxy.org/download/2.5/src/haproxy-${VERSION}.tar.gz

# 使用 COPY 包方式需要使用多级构建去除源码包所占空间
COPY haproxy-${VERSION}.tar.gz /haproxy.tar.gz

RUN set -eux; \
        sed -r -e "s@(^.*//).*org(.*$)@\1${REPO_URL}\2@g" -i /etc/apk/repositories; \
        apk update --no-cache; \
        apk add --no-cache --virtual .build-deps \
            gcc \
            libc-dev \
            linux-headers \
            make \
            openssl \
            openssl-dev \
            pcre2-dev \ 
            scanelf \
            tzdata; \
            \
        # wget -O haproxy.tar.gz "$HAPROXY_URL"; \
        tar -xvf haproxy.tar.gz; \
        cd haproxy-${VERSION}; \
        make -j $(nproc) TARGET=linux-musl USE_OPENSSL=1 USE_PCRE2=1 USE_PCRE2_JIT=1; \
        make install PREFIX=/usr/local/haproxy; \
        \
        adduser -D -H -s /sbin/nologin haproxy; \
        mkdir -p /usr/local/haproxy/run; \
        chown -R haproxy.haproxy /usr/local/haproxy; \
        ln -s /usr/local/haproxy/sbin/haproxy /usr/sbin/haproxy; \
        haproxy -v



FROM alpine:3.16

ENV REPO_URL='mirrors.tuna.tsinghua.edu.cn'

COPY --from=build /usr/local/haproxy /usr/local/haproxy
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY haproxy.cfg /
COPY docker-entrypoint.sh /usr/bin

RUN set -eux; \
        sed -r -e "s@(^.*//).*org(.*$)@\1${REPO_URL}\2@g" -i /etc/apk/repositories; \
        apk update --no-cache; \
        run_deps="$( \
            scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/haproxy/sbin/haproxy \
                | tr ',' '\n' \
                | sort -u \
                | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
            )"; \
        apk add --no-cache --virtual .run-deps ${run_deps}; \
        \
        mkdir /etc/haproxy; \
        mv /haproxy.cfg /etc/haproxy; \
        adduser -D -H -s /sbin/nologin haproxy; \
        chmod +x /usr/bin/docker-entrypoint.sh; \
        # chown -R haproxy.haproxy /usr/local/haproxy; \
        \
        ln -s /usr/local/haproxy/sbin/haproxy /usr/sbin/haproxy; \
        haproxy -v

EXPOSE 9999

USER haproxy

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]

