#!/bin/sh

set -e

# 用于 CMD 直接传递 -c 做配置检查
if [ "${1#-}" != "${1}" ]; then
    set -- haproxy "$@"
fi
if [ "${1}" = 'haproxy' ]; then
    shift
    set -- haproxy -W -db "$@"
fi

exec "$@"