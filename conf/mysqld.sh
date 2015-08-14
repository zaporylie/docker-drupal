#!/bin/bash

# Check first if user linked mysql container, if not - run mysql here.
if [ "$(cat /etc/hosts | grep ${MYSQL_HOST_NAME} | wc -l)" = "0" ]; then
  echo "Unable to find linked mysql container, running mysql on host"

  echo "Starting mysqld_safe" 
  /usr/bin/mysqld_safe --skip-syslog &
  echo "Waiting 10 s"
  sleep 10s
  echo "Setting environmental variables"
  export MYSQL_HOST_NAME=localhost
  export MYSQL_ENV_MYSQL_ROOT_PASSWORD=`pwgen -c -n -1 12`
  export MYSQL_PORT_3306_TCP_PROTO=tcp
  export MYSQL_PORT_3306_TCP_PORT=3306
  export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
  export MYSQL_PORT=tcp://127.0.0.1:3306

  echo "Changing password"
  mysqladmin -u root password $MYSQL_ENV_MYSQL_ROOT_PASSWORD
  echo "Killing mysql"
  killall mysqld

  echo "Waiting 6s for mysql to be dead"
  sleep 6s

  echo "Starting mysql in normal mode"
  /etc/init.d/mysql start
fi
