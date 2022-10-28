FROM docker.io/library/debian:11

COPY sources.list /etc/apt/sources.list

RUN set -eux; \
        apt-get update; \
        # ......
        rm -rf /var/lib/apt/lists/*
