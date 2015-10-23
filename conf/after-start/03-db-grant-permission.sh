#!/bin/sh

mysql -h${DB_HOSTNAME} -p${DB_ENV_MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_USER}@'%' IDENTIFIED BY '${DB_PASSWORD}';" \
  && echo "=> Permissions has been granted"
