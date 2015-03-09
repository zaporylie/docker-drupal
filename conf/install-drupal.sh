mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS ${DRUPAL_DB};" \
  && mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DRUPAL_DB};" \
  && mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "CREATE USER ${DRUPAL_USER}@'%' IDENTIFIED BY '${DRUPAL_PASSWORD}';" \
  && mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DRUPAL_DB}.* TO ${DRUPAL_USER}@'%';"

drush dl drupal --destination=/tmp -y \
  && mv -f /tmp/drupal*/ /application/drupal

cd /application/drupal && drush si --db-url=mysql://${DRUPAL_USER}:${DRUPAL_PASSWORD}@${MYSQL_PORT_3306_TCP_ADDR}/${DRUPAL_DB} -y

