cd /application/drupal \
  && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DRUPAL_USER}:${DRUPAL_PASSWORD}@${MYSQL_PORT_3306_TCP_ADDR}/${DRUPAL_DB} --sites-subdir=${DRUPAL_SUBDIR} -y \
  && echo "Installed new site"
