FROM docker.io/library/alpine:3.15 as build

COPY rclone /usr/bin/
COPY .config/ /root/.config

ENTRYPOINT [ "/docker-entrypoint.sh" ]
