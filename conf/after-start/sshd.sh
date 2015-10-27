#!/bin/sh

if [ -z "${SSH_PASSWORD}" ]; then
  export SSH_PASSWORD=`pwgen -c -n -1 12`
  echo "==> SSH password: ${SSH_PASSWORD}"
fi

echo "root:${SSH_PASSWORD}" | chpasswd
