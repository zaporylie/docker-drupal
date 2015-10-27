#!/bin/sh

cd /app/drupal > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal folder does not exists'
  exit 1;
fi

drush sql-sync ${DB_SYNC_DRUSH_FROM} self -y  > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal could not be synced'
  exit 1;
fi

echo "==> Database has been restored using drush sql-sync."
