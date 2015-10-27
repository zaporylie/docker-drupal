#!/bin/sh

# Try to log in as user.
mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "status;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  # If login try was successful try to show database
  mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "use ${DB_NAME}; SELECT 0 FROM system LIMIT 1;"  > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    mysqldump -uroot -p${DB_ENV_MYSQL_ROOT_PASSWORD}  > /tmp/existing_db.sql
  else
    ERROR=1
  fi
else
  ERROR=1;
fi

if [ ! -z "${ERROR}" ]; then
  cd /app/drupal \
   && drush si ${DRUPAL_PROFILE} --db-url=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOSTNAME}/${DB_NAME} --sites-subdir=${DRUPAL_SUBDIR} --db-su=root --db-su-pw=${DB_ENV_MYSQL_ROOT_PASSWORD} -y \
   && echo "==> New site installed."
fi
