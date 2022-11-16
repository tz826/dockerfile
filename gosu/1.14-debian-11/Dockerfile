FROM docker.io/library/debian:11

ENV GOSU_VERSION 1.14

COPY sources.list /etc/apt/sources.list
COPY gosu-${GOSU_VERSION}-amd64 /usr/bin/gosu

RUN set -eux; \
        chmod +x /usr/bin/gosu

ENTRYPOINT [ "/bin/bash" ]
