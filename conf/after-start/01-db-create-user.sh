#!/bin/sh

mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE USER ${DB_USER}@'%' IDENTIFIED BY '${DB_PASSWORD}';" \
  && echo "==> New user has been created"
