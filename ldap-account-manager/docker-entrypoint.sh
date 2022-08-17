#!/bin/sh

set -eux
# LDAP_URL='ldap://10.0.0.11'
# INITIAL_DN='dc=noise131,dc=com'
# ADMIN_USER='admin'

sed -r \
    -e "s#ldap://localhost:389$#${LDAP_URL}#g" \
    -e "s/,dc=my-domain,dc=com$/,${INITIAL_DN}/g" \
    -e "s/dc=yourdomain,dc=org$/${INITIAL_DN}/g" \
    -e "s/cn=Manager/cn=${ADMIN_USER}/g" \
    -i.bak /www/lam/config/lam.conf

php-fpm -D

exec "$@"
