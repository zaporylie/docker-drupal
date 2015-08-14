#!/bin/bash

# Check first if user linked mysql container, if not - run mysql here.
if [ "$(cat /etc/hosts | grep ${MYSQL_HOST_NAME} | wc -l)" = "0" ]; then
  echo "Unable to find linked mysql container, running mysql on host"

  /usr/bin/mysqld_safe --skip-syslog &
  sleep 3s
  export MYSQL_HOST_NAME=localhost
  export MYSQL_ENV_MYSQL_ROOT_PASSWORD=`pwgen -c -n -1 12`
  export MYSQL_PORT_3306_TCP_PROTO=tcp
  export MYSQL_PORT_3306_TCP_PORT=3306
  export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
  export MYSQL_PORT=tcp://127.0.0.1:3306
  mysqladmin -u root password $MYSQL_ENV_MYSQL_ROOT_PASSWORD
  killall mysqld
  sleep 3s

  /etc/init.d/mysql start
fi
