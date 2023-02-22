FROM docker.io/library/debian:11

COPY sources.list /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get -y install \
                wget curl tree gnupg \
                net-tools inetutils-ping telnet; \
            \
        wget -O - https://download.gluster.org/pub/gluster/glusterfs/9/rsa.pub | apt-key add -; \
            \
        DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"'); \
        DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+'); \
        DEBARCH=$(dpkg --print-architecture); \
        echo deb https://download.gluster.org/pub/gluster/glusterfs/9/9.3/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/gluster.list; \
            \
        apt-get update; \
        apt-get -y install glusterfs-server; \
            \
        apt-get -y remove gnupg; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*;

VOLUME [ "/var/lib/glusterd" ]

ENTRYPOINT [ "/usr/sbin/glusterd", "-N", "-p", "/var/run/glusterd.pid", "--log-level", "INFO", "-l", "/dev/stdout" ]
