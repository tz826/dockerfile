#!/bin/bash


scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/haproxy/sbin/haproxy  | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' |xargs -P 1

a=$(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/haproxy/sbin/haproxy  | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }')





apk add --no-cache --virtual build-deps gcc libc-dev linux-headers make openssl openssl-dev pcre2-dev scanelf

make -j $(nproc) TARGET=linux-glibc USE_OPENSSL=1 USE_PCRE2=1

make install PREFIX=/usr/local/haproxy













