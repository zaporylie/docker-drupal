#!/bin/sh

mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DRUPAL_DB}.* TO ${DRUPAL_DB_USER}@'%' IDENTIFIED BY '${DRUPAL_DB_PASSWORD}';" \
  && echo "Permissions has been granted"
