FROM docker.io/library/debian:11

COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get -y install \
                    wget curl tree procps gnupg ca-certificates \
                    net-tools inetutils-ping telnet dnsutils; \
            \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;
