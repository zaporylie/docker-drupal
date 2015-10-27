#!/bin/sh

chgrp -R www-data /app/drupal > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set ownership'
  exit 1;
fi
echo "===> /app/drupal ownership has been changed"

find /app/drupal -type d -exec chmod u=rwx,g=rx,o= '{}' \; > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set file permission'
  exit 1;
fi

find /app/drupal -type f -exec chmod u=rw,g=r,o= '{}' \; > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Unable to set file permission'
  exit 1;
fi

echo "===> Permission to /app/drupal has been changed"
