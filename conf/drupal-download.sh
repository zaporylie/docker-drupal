drush dl drupal-${DRUPAL_MAJOR_VERSION} --destination=/tmp -y \
  && rsync -av /tmp/drupal*/ /application/drupal

