#!/bin/sh
if [ "${DRUPAL_DOWNLOAD_METHOD}" = "drush" ]; then

  echo "Downloading with drush"
  drush dl drupal-${DRUPAL_MAJOR_VERSION} --destination=/tmp -y \
    && rsync -a /tmp/drupal*/ /app/drupal

elif [ "${DRUPAL_DOWNLOAD_METHOD}" = "git" ]; then

  echo "Cloning..."
  cd /tmp \
    && git clone --branch ${DRUPAL_GIT_BRANCH} --depth=${DRUPAL_GIT_DEPTH} http://git.drupal.org/project/drupal.git drupal \
    && rsync -a /tmp/drupal/ /app/drupal

else

  echo "Missing download method or download method is incorrect"

fi
