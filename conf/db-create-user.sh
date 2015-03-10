mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE USER ${DRUPAL_USER}@'%' IDENTIFIED BY '${DRUPAL_PASSWORD}';" \
  && echo "New user has been created"
