#!/bin/sh

drush dl drupal-${CODE_DRUSH_MAJOR_VERSION} --destination=/tmp -y > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal could not be downloaded'
  exit 1;
fi

mv /tmp/drupal*/ ${CODE_SYNC_FOLDER} > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal could not be moved to final destination'
  exit 1;
fi

echo "===> Drupal has been download into ${CODE_SYNC_FOLDER} folder"
