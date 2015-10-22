#!/bin/sh

mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS ${DB_NAME};" \
  && mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DB_NAME};" \
  && echo "New database has been created"
