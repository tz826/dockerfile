#!/bin/bash

set -e

echo "root:${ROOT_PASSWORD}" |chpasswd

sed -i "s/#Port 22/Port ${SSHD_PORT}/g" /etc/ssh/sshd_config

/usr/sbin/sshd -D
