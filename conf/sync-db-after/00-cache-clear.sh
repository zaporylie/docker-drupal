#!/bin/sh

cd /app/drupal

if [ "$(drush st | grep 'Drupal version' | grep '8.' | wc -l)" = "1" ]; then
  drush cr
else
  drush cc all
fi
