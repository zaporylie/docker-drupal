# Bash hasn't been initialized yet so add path to composer manually.
export PATH="$HOME/.composer/vendor/bin:$PATH"

if [[ -f /root/pre-install.sh ]]; then
  source /root/pre-install.sh
fi

if [[ ${METHOD} == 'new' ]]; then
  source /root/install-fresh-drupal.sh
else
  source /root/install-existing-drupal.sh
  # Check if SYNC_SOURCE exists and if is accessible
  if [ "$(drush sa | grep "${SYNC_SOURCE}" | wc -l)" == 1 ]; then
    if [ "$(drush @"${SYNC_SOURCE}" st | grep 'Connected' | wc -l)" == 1 ]; then
      # Sync site here!
      drush sql-sync @${SYNC_SOURCE} @local -y
    else
      echo "Unable to sync: cannot connect to ${SYNC_SOURCE}"
    fi
  else
    echo "Unable to sync: ${SYNC_SOURCE} is not defined"
  fi
fi

if [[ -f /root/post-install.sh ]]; then
  source /root/post-install.sh
fi

/usr/bin/supervisord
