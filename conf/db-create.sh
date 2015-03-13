#!/bin/sh

mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS ${DRUPAL_DB};" \
  && mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DRUPAL_DB};" \
  && echo "New database has been created"
