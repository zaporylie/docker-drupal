#!/bin/sh

mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "status;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  ERROR=$(mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "SHOW DATABASES LIKE ${DB_NAME};" | wc -l)
else
  ERROR=1;
fi
echo ${ERROR}
if [ "$ERROR" != "0" ]; then
  cd /app/drupal \
   && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOSTNAME}/${DB_NAME} --sites-subdir=${DRUPAL_SUBDIR} --db-su=root --db-su-pw=${DB_ENV_MYSQL_ROOT_PASSWORD} -y \
   && echo "==> New site installed."
fi
