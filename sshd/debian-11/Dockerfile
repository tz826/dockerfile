FROM docker.io/noi1031/debian:11

ENV ROOT_PASSWORD "root.123"

USER root

RUN set -eux; \
        apt-get update; \
            \
        apt-get install -y openssh-server; \
            \
        sed -i "/PermitRootLogin/aPermitRootLogin yes" /etc/ssh/sshd_config; \
        echo "root:${ROOT_PASSWORD}" |chpasswd; \
        mkdir -p /run/sshd; \
            \
        rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
