#!/bin/sh

chown -R www-data:www-data /app/drupal/sites/${DRUPAL_SUBDIR}/files > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set ownership'
  exit 1;
fi
echo "===> /app/drupal ownership has been changed"

find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type d -exec chmod ug=rwx,o= '{}' \; > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set file permission'
  exit 1;
fi

find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type f -exec chmod ug=rw,o= '{}' \; > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set file permission'
  exit 1;
fi

echo "===> Permission to /app/drupal/sites/${DRUPAL_SUBDIR}/files has been changed"
