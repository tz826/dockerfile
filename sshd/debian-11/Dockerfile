FROM docker.io/noi1031/debian:11

COPY docker-entrypoint.sh /

ENV ROOT_PASSWORD "root.123"
ENV SSHD_PORT "22"

USER root

RUN set -eux; \
        apt-get update; \
            \
        apt-get install -y openssh-server; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
            \
        sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config; \
        mkdir -p /run/sshd; \
            \
        chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
