#!/bin/sh
cd /app/drupal \
  && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB} --sites-subdir=${DRUPAL_SUBDIR} -y \
  && echo "Installed new site"
