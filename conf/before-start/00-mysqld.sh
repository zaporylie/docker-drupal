#!/bin/bash

export DB_LOG="/var/log/mysql/error.log"

WaitForMySQL ()
{
  LOOP_LIMIT=30
  for (( i=0 ; ; i++ )); do
    if [ ${i} -eq ${LOOP_LIMIT} ]; then
      echo "Time out."
      # tail -n 100 ${DB_LOG}
      exit 1
    fi
    echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
    sleep 1
    if [ "$(cat /etc/hosts | grep ${DB_HOSTNAME} | wc -l)" == "0" ] || [ "${DB_HOSTNAME}" == "localhost" ]; then
      echo "==> Internal";
      mysql -uroot -e ";" > /dev/null 2>&1 && break
    else
      echo "=> External";
      mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD}  -e ";" > /dev/null 2>&1 && break
    fi
  done
}

StartMySQL ()
{
  /usr/bin/mysqld_safe ${MYSQL_EXTRA_OPTS} > /dev/null 2>&1 &
}

# Check first if user linked mysql container, if not - run mysql here.
if [ "$(cat /etc/hosts | grep ${DB_HOSTNAME} | wc -l)" == "0" ] || [ "${DB_HOSTNAME}" == "localhost" ]; then

  echo "=> No mysql container has been linked"
  echo "=> Starting MySQL ..."
  StartMySQL
  tail -F ${DB_LOG} &
  WaitForMySQL

  echo "=> Setting environmental variables"
  export DB_HOSTNAME="localhost"
  export DB_PORT_3306_TCP_PROTO="tcp"
  export DB_PORT_3306_TCP_PORT="3306"
  export DB_PORT_3306_TCP_ADDR="127.0.0.1"
  export DB_PORT="tcp://127.0.0.1:3306"

  if [ -z "${DB_ENV_MYSQL_ROOT_PASSWORD}" ]; then
    echo "=> Changing password"
    export DB_ENV_MYSQL_ROOT_PASSWORD="`pwgen -c -n -1 12`"
    mysqladmin -u root password ${DB_ENV_MYSQL_ROOT_PASSWORD}
  fi
else
  WaitForMySQL
fi
