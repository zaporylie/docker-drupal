#!/bin/sh

chgrp -R www-data /app/drupal
find /app/drupal -type d -exec chmod u=rwx,g=rx,o= '{}' \;
find /app/drupal -type f -exec chmod u=rw,g=r,o= '{}' \;
