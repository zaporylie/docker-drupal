#!/bin/sh

find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type d -exec chmod ug=rwx,o= '{}' \;
find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type f -exec chmod ug=rw,o= '{}' \;
