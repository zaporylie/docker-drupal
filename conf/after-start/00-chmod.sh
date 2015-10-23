#!/bin/sh

chgrp -R www-data /app/drupal
find /app/drupal -type d -exec chmod u=rwx,g=rx,o= '{}' \;
find /app/drupal -type f -exec chmod u=rw,g=r,o= '{}' \;
find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type d -exec chmod ug=rwx,o= '{}' \;
find /app/drupal/sites/${DRUPAL_SUBDIR}/files -type f -exec chmod ug=rw,o= '{}' \;
