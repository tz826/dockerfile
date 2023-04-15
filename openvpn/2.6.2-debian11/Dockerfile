FROM docker.io/library/debian:11

COPY sources.list /etc/apt/sources.list
COPY docker-entrypoint.sh /
COPY scripts /scripts

RUN set -eux; \
        ### 初始环境整理阶段
        # 创建 openvpn 运行用户
        useradd -M -s /usr/sbin/nologin openvpn; \
        chmod a+x /docker-entrypoint.sh; \
        mv /docker-entrypoint.sh /usr/local/bin; \
            \
        ### 依赖及编译环境安装阶段
        apt-get update; \
        # 安装编译工具
        apt-get -y install \
            gcc g++ make automake pkg-config; \
        # 安装常用工具
        apt-get -y install \
            wget curl vim tree procps gnupg ca-certificates \
            net-tools inetutils-ping telnet dnsutils; \
        # 安装 openvpn 编译依赖包
        apt-get -y install \
            libnl-genl-3-dev libcap-ng-dev \
            libssl-dev liblz4-dev liblzo2-dev libpam0g-dev; \
        # 安装 openvpn 运行依赖包
        apt-get -y install \
            liblzo2-2 libnl-genl-3-200 libcap-ng0 libssl1.1 \
            liblz4-1 libpam0g iptables openssl; \
            \
        ### 编译安装阶段
        wget "https://swupdate.openvpn.org/community/releases/openvpn-2.6.2.tar.gz"; \
        tar -xvf openvpn*.tar.gz; \
        rm -rf *.tar.gz; \
        cd openvpn-*; \
        ./configure; \
        make -j "$(nproc)"; \
        make install -j "$(nproc)"; \
            \
        ### 下载证书生成工具
        cd /; \
        wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.2/EasyRSA-3.1.2.tgz; \
        tar -xvf EasyRSA*; \
        rm -rf *.tgz; \
        cd EasyRSA*; \
            \
        ### 环境清理阶段
        apt-get -y remove \
            gcc g++ make automake pkg-config; \
        apt-get -y remove \
            wget curl vim tree procps gnupg ca-certificates \
            net-tools inetutils-ping telnet dnsutils; \
        apt-get -y remove \
            libnl-genl-3-dev libcap-ng-dev \
            libssl-dev liblz4-dev liblzo2-dev libpam0g-dev; \
        apt-get -y autoremove; \
        apt-get clean; \
        rm -rf /openvpn*; \
        rm -rf /var/lib/apt/lists/*;

WORKDIR /etc/openvpn/

VOLUME [ "/etc/openvpn/" ]

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "openvpn", "--cd", "/etc/openvpn/server", "--config", "server.conf" ]

###
# 构建命令
#   docker build -f Dockerfile --no-cache --network=host -t noi1031/openvpn:2.6.2-debian11 ./
###
# 临时运行命令 ( server.conf 文件使用 demo 目录中的模板即可 ), 特权模式和共享主机网络是必须的
#   docker run -it --rm --network=host --privileged=true -v $(pwd)/openvpn:/etc/openvpn noi1031/openvpn:2.6.2-debian11
###