FROM docker.io/library/debian:11

COPY sources.list /etc/apt/sources.list
COPY *.deb / 

RUN set -ux; \
            \
        apt-get update; \
            \
            dpkg -i /*.deb; \
            apt-get -f -y install; \
            dpkg -i /*.deb; \
            \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

CMD [ "/bin/bash" ]
