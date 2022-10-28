FROM docker.io/library/alpine:3.15 as build

ENV REPO_URL "mirrors.tuna.tsinghua.edu.cn"
ENV VERSION "1.91"

ADD s3fs-fuse-${VERSION}.tar.gz /

RUN set -eux; \
        sed -r -e "s@(^.*//).*org(.*$)@\1${REPO_URL}\2@g" -i /etc/apk/repositories; \
            \
        apk add --no-cache --virtual .build-deps \
            fuse libcurl libxml2 libstdc++ \
            libgcc alpine-sdk automake autoconf \
            libxml2-dev fuse-dev curl-dev tzdata
RUN set -eux; \
        cd /s3fs-fuse-${VERSION}; \
            \
        ./autogen.sh; \
            \
        ./configure --prefix=/usr; \
            \
        make && make install && make clean


FROM docker.io/library/alpine:3.15 as running

ENV REPO_URL "mirrors.tuna.tsinghua.edu.cn"
ENV VERSION "1.91"

COPY --from=build /usr/bin/s3fs /usr/bin/s3fs
COPY --from=build /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY docker-entrypoint.sh /

RUN set -eux; \
        sed -r -e "s@(^.*//).*org(.*$)@\1${REPO_URL}\2@g" -i /etc/apk/repositories; \
            \
        run_deps="$( \
            scanelf --needed --nobanner --format '%n#p' --recursive /usr/bin/s3fs \
                | tr ',' '\n' \
                | sort -u \
                | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
            )"; \
            \
        apk add --no-cache --virtual .run-deps ${run_deps}; \
            \
        chmod +x docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
