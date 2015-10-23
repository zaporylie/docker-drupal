#!/bin/sh

drush dl drupal-${CODE_DRUSH_MAJOR_VERSION} --destination=/tmp -y \
  && rsync -a /tmp/drupal*/ ${CODE_SYNC_FOLDER} \
  && echo "==> Drupal has been download into ${CODE_SYNC_FOLDER} folder"
