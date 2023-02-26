#!/bin/bash

set -e

if [ "${1}" != 'etcd' ]; then
    exec "$@"
fi

test -f /etc/etcd/etcd.conf || ( echo "etcd config file not found !" && echo 1 )

if [ -z "${ETCD_DATA_DIR}" ];then
    DATA_DIR=$( sed -nr "/^ETCD_DATA_DIR/ s/^.*\"(.*)\".*$/\1/g p" /etc/etcd/etcd.conf )
    mkdir -p "${DATA_DIR%/*}"
    chown -R etcd:etcd "${DATA_DIR%/*}"
fi

if [ "$(id -u)" -eq 0 ]; then
    exec gosu etcd "$0" "$@"
fi

ETCD_CONFIG=$( grep -vE "^\s*#|^\s*$" /etc/etcd/etcd.conf |awk 'BEGIN{ i=0 } { array[i]=$0; i++ } END{ for (y=0;y<=i;y++){ printf "%s ",array[y]; } }' )
CMD="${ETCD_CONFIG} $*"
bash -c "$CMD"
