#!/bin/sh

if [[ -d /root/conf/before-install ]]; then
  echo "> BEFORE INSTALL"
  FILES=/root/conf/before-install/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

# Strategy:
# - file sync (CODE_SYNC_METHOD)
#   - if none, skip
#   - if auto, autoselect one of the following methods (in this order)
#   - if local, use /app/drupal folder
#   - if drush, download project with drush
#   - if git, download project with git

# Check which method could be used.
if [ "${CODE_SYNC_METHOD}" = "auto" ]; then
  if [ ! -d "/app/drupal" ] || [ "$(cd /app/drupal/ && drush st | grep 'Drupal version' | wc -l)" = "0" ]; then
    CODE_SYNC_METHOD="drush"
  else
    CODE_SYNC_METHOD=""
  fi
fi
if [ -z "${CODE_SYNC_METHOD}" ]; then
  # Return information that code sync has been skipped.
  echo "==> Skip file sync."
else
  # Sync code.
  if [ -f "/root/conf/code_sync/${CODE_SYNC_METHOD}.sh" ]; then
    echo "==> Attaching: /root/conf/code_sync/${CODE_SYNC_METHOD}.sh"
    source /root/conf/code_sync/${CODE_SYNC_METHOD}.sh
  else
    # If code cannot be synced, throw exit code.
    echo "==> [${CODE_SYNC_METHOD}] This code sync method has not been implemented yet"
    exit 1
  fi
fi





















# if [ "${METHOD}" = "nothing" ]; then

#   echo "Do nothing"

# elif [ "${METHOD}" = "new" ]; then

#   echo "Install new Drupal site"
#   source /root/conf/db-create.sh
#   source /root/conf/db-grant-permission.sh
#   source /root/conf/drupal-install.sh
#   export METHOD_AUTO_RESULT=new_install

# elif [ "${METHOD}" = "auto" ]; then
#   echo "Building..."
#   source /root/conf/db-wait.sh

#   if [ ! -d /app/drupal ] || [ "$(cd /app/drupal/ && drush st | grep 'Drupal version' | wc -l)" = "0"  ]; then
#     echo "Missing drupal"
#     source /root/conf/drupal-download.sh
#   fi

#   if [[ ! -f /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php ]]; then
#     echo "Missing settings file"
#     mkdir -p /app/drupal/sites/${DRUPAL_SUBDIR}

#     mysql -h${MYSQL_HOST_NAME} -u${DRUPAL_DB_USER} -p${DRUPAL_DB_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
#     if [ $? -eq 0 ]; then

#       echo "Create settings file for existing database"
#       cp /app/drupal/sites/default/default.settings.php /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php
#       cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
#       export METHOD_AUTO_RESULT=settings_updated

#     else

#       echo "Install brand new Drupal"
#       source /root/conf/db-create.sh
#       source /root/conf/db-grant-permission.sh
#       source /root/conf/drupal-install.sh
#       export METHOD_AUTO_RESULT=new_install
#     fi

#   else

#     echo "Settings file exist"
#     if [ "$(cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush st | grep 'Connected' | wc -l)" == "1" ]; then

#       echo "Already running"
#       export METHOD_AUTO_RESULT=enabled

#     else

#       echo "..but doesn't work"
#       mysql -h${MYSQL_HOST_NAME} -u${DRUPAL_DB_USER} -p${DRUPAL_DB_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
#       if [ $? -eq 0 ]; then

#         echo "Update settings file"
#         cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
#         export METHOD_AUTO_RESULT=settings_updated

#       else

#         echo "Install brand new Drupal"
#         cp -f /app/drupal/sites/${DRUPAL_SUBDIR}/default.settings.php /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php
#         source /root/conf/db-create.sh
#         source /root/conf/db-grant-permission.sh
#         source /root/conf/drupal-install.sh
#         export METHOD_AUTO_RESULT=new_install

#       fi
#     fi
#   fi
# fi



if [[ -d /root/conf/before-install ]]; then
  echo "> AFTER INSTALL"
  FILES=/root/conf/after-install/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

