FROM docker.io/library/mongo:6.0.1

COPY docker-entrypoint.sh /usr/local/bin

RUN set -eux; \
        chmod +x /usr/local/bin/docker-entrypoint.sh


# 构建命令
# docker build -t mongo:6.0.1-keyfile ./
