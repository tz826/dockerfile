FROM docker.io/library/debian:11

COPY sources.list-zkd /etc/apt/sources.list
# etcd_bin/ 目录中存放 etcd 二进制压缩包中解压出的两个 etcd 二进制文件 (etcd, etcdctl)
COPY etcd_bin/ /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin

# 默认 etcdctl api 版本
ENV ETCDCTL_API=3

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get -y install net-tools inetutils-ping procps gosu; \
            \
        groupadd -g 999 etcd; \
        useradd -M -s /usr/sbin/nologin -u 999 -g 999 etcd; \
            \
        chmod +x /usr/local/bin/etcd*; \
        chmod +x /usr/local/bin/docker-entrypoint.sh; \
            \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "etcd", "--logger=zap" ]
