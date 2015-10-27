#!/bin/sh

cd /app/drupal  > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal folder could not be found'
  exit 1;
fi

echo "===> Loading ${DB_SYNC_FILE} file"
drush sql-cli -y < ${DB_SYNC_FILE} 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Database could not be restored'
  exit 1;
fi

echo "===> Database has been restored from backup file."
