#! /bin/bash

set -e

AUTH_DIR='/etc/nginx/auth'

[ -n "$DEL_DEFAULT_CONF" ] && rm -rf /etc/nginx/conf.d/default.conf
[ -n "$DIR_PURVIEW" ] && [ -d "$WWW_DIR" ] && chown -R nginx:nginx "$WWW_DIR"
[ -d "${AUTH_DIR}" ] && chown -R nginx:nginx "${AUTH_DIR}" && chmod 600 "${AUTH_DIR}"

exec "$@"
