#! /bin/bash

set -e

PROXY_CONFIG='/etc/nginx/conf.d/proxy-connect.conf'
ALLOW_CONFIG='/etc/nginx/conf.d/proxy-connect_allow.conf'
ORIGIN_DNS_ADDR='114.114.114.119'

[ -n "$DEL_DEFAULT_CONF" ] && rm -rf /etc/nginx/conf.d/default.conf
[ -n "$DIR_PURVIEW" ] && [ -d "$WWW_DIR" ] && chown -R nginx:nginx "$WWW_DIR"
[ -n "$DNS_ADDR" ] && sed -i "s/${ORIGIN_DNS_ADDR}/${DNS_ADDR}/g" "${PROXY_CONFIG}" && echo -e "dns addr :\n${DNS_ADDR}\n"

if [ -n "$ALLOW_ADDR" ]; then
    > "${ALLOW_CONFIG}"
    allow_addr_array=( ${ALLOW_ADDR//,/ } )
    echo "allow host :"
    for i in "${allow_addr_array[@]}"; do
        echo "allow $i;" |tee -a "${ALLOW_CONFIG}"
    done
    echo
fi

exec "$@"
