#!/bin/bash

set -eux

# sysctl -w net.ipv4.ip_forward=1
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -P FORWARD ACCEPT
if ! iptables -t nat -L POSTROUTING -nv --line-number|grep -q "10.8.0.0"; then
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
fi

# 创建登录日志存储目录
mkdir -p /etc/openvpn/logs
chown -R openvpn:openvpn /etc/openvpn/logs

if [ ! -e "/etc/openvpn/server/pki" ]; then
    # mv /pki /etc/openvpn/server
    cd /EasyRSA*
    tee ./vars <<'EOF'
set_var EASYRSA_REQ_COUNTRY	"CN"
set_var EASYRSA_REQ_PROVINCE	"BeiJing"
set_var EASYRSA_REQ_CITY	"BeiJing"
set_var EASYRSA_REQ_ORG	"openvpn"
set_var EASYRSA_REQ_EMAIL	"test@test.com"
set_var EASYRSA_REQ_OU		"BeiJing"
set_var EASYRSA_CA_EXPIRE	36500
set_var EASYRSA_CERT_EXPIRE	36500
EOF
    # 初始化证书 pki 目录 ( 会在当前路径下创建 pki 目录，存储配置 )
    ./easyrsa init-pki
    # 创建 ca 证书
    ./easyrsa build-ca nopass <<'EOF'

EOF
    # 创建 server 证书申请文件和私钥
    ./easyrsa gen-req server nopass <<'EOF'

EOF
    # 签发 server 证书 ( 第二个 server 是创建证书申请文件时默认的 cn 名，因为从输入重定向输入了回车，使用了默认 cn 名 server )
    ./easyrsa sign server server <<'EOF'
yes
EOF
    # 创建 client 证书请求文件和私钥 ( 该步骤可以省略，客户端直接使用服务端证书也可以进行认证，没有严格验证机制只要是一个 ca 签发的就可以认证 )
    ./easyrsa gen-req client nopass <<'EOF'

EOF
    # 签发 client 证书
    ./easyrsa sign client client <<'EOF'
yes
EOF
    # 创建 Diffie Hellman 证书 ( dh 证书 )
    ./easyrsa gen-dh
    # 创建 ta.key 密钥 ( 用以防止对服务端 ddos 和泛洪攻击 )
    openvpn --genkey tls-auth ta.key
    # 密钥类型可以是 secret 或 tls-auth
    # 创建存储目录并移动证书
    mkdir -p /etc/openvpn/server/pki
    find /EasyRS* -iname "*.crt" -o -iname "*.key" -o -iname "dh.pem" |xargs \cp -v -a -t /etc/openvpn/server/pki/
fi

if [ ! -e "/etc/openvpn/scripts" ]; then
    mv /scripts /etc/openvpn/
    chmod +x /etc/openvpn/scripts/*.sh
fi

exec "$@"
