#!/bin/sh

cd /app/drupal \
  && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOSTNAME}/${DB_NAME} --sites-subdir=${DRUPAL_SUBDIR} --db-su=root --db-su-pw=${DB_ENV_MYSQL_ROOT_PASSWORD} -y \
  && echo "==> New site installed."
