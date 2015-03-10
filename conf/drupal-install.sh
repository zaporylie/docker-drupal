cd /application/drupal \
  && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DRUPAL_USER}:${DRUPAL_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB} --sites-subdir=${DRUPAL_SUBDIR} -y \
  && echo "Installed new site"
