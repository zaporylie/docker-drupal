#!/bin/sh

# Try to log in as user.
mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "status;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "===> DB user already exists"
  # If login try was successful try to show database
  mysql -h${DB_HOSTNAME} -u${DB_USER} -p${DB_PASSWORD} -e "use ${DB_NAME}; SELECT 0 FROM node LIMIT 1;"  > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "===> Database already exists, making copy..."
    # Make mysqldump
    mysqldump -h${DB_HOSTNAME} -uroot -p${DB_ENV_MYSQL_ROOT_PASSWORD} ${DB_NAME} > /tmp/local.sql 2>&1
    if [ $? -ne 0 ]; then
      echo "[error] Database backup could not be performed."
      exit 1
    fi
    echo "===> Database backup has been stored in /tmp/local.sql"
  fi
fi

cd /app/drupal > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal folder does not exists'
  exit 1;
fi

drush si ${DRUPAL_PROFILE} --db-url=mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOSTNAME}/${DB_NAME} --sites-subdir=${DRUPAL_SUBDIR} --db-su=root --db-su-pw=${DB_ENV_MYSQL_ROOT_PASSWORD} -y > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal could not be installed'
  exit 1;
fi

echo "===> New Drupal site has been installed."
