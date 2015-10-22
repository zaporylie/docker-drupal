#!/bin/bash

StartMySQL ()
{
    /usr/bin/mysqld_safe ${MYSQL_EXTRA_OPTS} > /dev/null 2>&1 &
    # Time out in 1 minute
    LOOP_LIMIT=60
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "Time out. Error log is shown as below:"
            tail -n 100 ${LOG}
            exit 1
        fi
        echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
        sleep 1
        mysql -uroot -e "status" > /dev/null 2>&1 && break
    done
}

# Check first if user linked mysql container, if not - run mysql here.
if [ -z "${MYSQL_HOST_NAME}" ]; then

  MYSQL_LOG="/var/log/mysql/error.log"
  echo "Unable to find linked mysql container, running mysql on host"

  echo "=> Starting MySQL ..."
  StartMySQL
  tail -F $MYSQL_LOG & 
  echo "Setting environmental variables"
  MYSQL_HOST_NAME=localhost
  MYSQL_ENV_MYSQL_ROOT_PASSWORD=`pwgen -c -n -1 12`
  MYSQL_PORT_3306_TCP_PROTO=tcp
  MYSQL_PORT_3306_TCP_PORT=3306
  MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
  MYSQL_PORT=tcp://127.0.0.1:3306

  echo "Changing password"
  mysqladmin -u root password $MYSQL_ENV_MYSQL_ROOT_PASSWORD

fi
