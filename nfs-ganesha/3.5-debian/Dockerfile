FROM docker.io/library/debian:11

COPY sources.list-zkd /etc/apt/sources.list

RUN set -eux; \
            \
        apt-get update; \
            \
        apt-get -y install wget gnupg; \
            \
        wget -O - https://download.nfs-ganesha.org/3/rsa.pub | apt-key add -; \
            \
        DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"'); \
        DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+'); \
        DEBARCH=$(dpkg --print-architecture); \
        echo deb https://download.nfs-ganesha.org/3/3.5/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/nfs-ganesha.list; \
        apt-get update; \
            \
        apt-get -y install nfs-ganesha=3.5-1 nfs-ganesha-vfs=3.5-1 nfs-ganesha-gluster=3.5-1; \
        apt-get -y install glusterfs-common; \
        apt-get -y install inetutils-ping; \
            \
        apt-get -y remove gnupg wget; \
        apt-get -y clean; \
        rm -rf /var/lib/apt/lists/*;

VOLUME [ "/etc/ganesha" ]

ENTRYPOINT [ "/bin/bash", "-c", "/usr/bin/ganesha.nfsd -F -L /dev/stdout -f /etc/ganesha/ganesha.conf -N NIV_EVENT /bin/true" ]
