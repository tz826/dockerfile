FROM ubuntu:22.04

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get -y install wget git; \
            \
        wget -4 "https://download.docker.com/linux/static/stable/x86_64/docker-20.10.17.tgz"; \
        tar -xvf docker-20.10.17.tgz; \
        mv docker/docker /usr/local/bin/; \
        rm -rf ./docker*; \
            \
        wget -4 -O /usr/bin/kubectl "https://dl.k8s.io/release/v1.26.3/bin/linux/amd64/kubectl"; \
        chmod 755 /usr/bin/kubectl; \
            \
        apt-get -y remove wget; \
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/bin/bash" ]
