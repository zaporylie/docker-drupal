drush dl drupal --destination=/tmp -y \
  && rsync -av /tmp/drupal*/ /application/drupal

