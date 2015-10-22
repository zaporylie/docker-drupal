#!/bin/bash

export DB_LOG="/var/log/mysql/error.log"

WaitForMySQL ()
{
  LOOP_LIMIT=60
  for (( i=0 ; ; i++ )); do
    if [ ${i} -eq ${LOOP_LIMIT} ]; then
      echo "Time out."
      tail -n 100 ${DB_LOG}
      exit 1
    fi
    echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
    sleep 1
    if [ -z "${DB_HOSTNAME}"]; then
      mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD}  -e ";" > /dev/null 2>&1 && break
    else
      mysql -p${DB_ENV_MYSQL_ROOT_PASSWORD}  -e ";" > /dev/null 2>&1 && break
    fi
  done
}

StartMySQL ()
{
    /usr/bin/mysqld_safe ${MYSQL_EXTRA_OPTS} > /dev/null 2>&1 &
}

# Check first if user linked mysql container, if not - run mysql here.
if [ -z "${DB_HOSTNAME}" ]; then

  echo "=> No mysql container has been linked"
  echo "=> Starting MySQL ..."
  StartMySQL
  WaitForMySQL
  tail -F ${DB_LOG} &

  echo "=> Setting environmental variables"
  DB_ENV_MYSQL_ROOT_PASSWORD=`pwgen -c -n -1 12`
  DB_PORT_3306_TCP_PROTO=tcp
  DB_PORT_3306_TCP_PORT=3306
  DB_PORT_3306_TCP_ADDR=127.0.0.1
  DB_PORT=tcp://127.0.0.1:3306

  echo "=> Changing password"
  mysqladmin -u root password ${DB_ENV_MYSQL_ROOT_PASSWORD}
fi
