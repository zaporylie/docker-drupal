#!/bin/sh
# Bash hasn't been initialized yet so add path to composer manually.
export PATH="$HOME/.composer/vendor/bin:$PATH"

if [[ -f /root/pre-install.sh ]]; then
  source /root/pre-install.sh
fi

if [ "${METHOD}" = "auto" ]; then

  echo "Method: auto"

  if [ ! -d /app/drupal ] || [ "$(cd /app/drupal/ && drush st | grep 'Drupal version' | wc -l)" = "0"  ]; then
    echo "Missing drupal"
    source /root/drupal-download.sh
  fi

  if [[ ! -f /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php ]]; then
    echo "Missing settings file"
    mkdir -p /app/drupal/sites/${DRUPAL_SUBDIR}

    mysql -h${MYSQL_HOST_NAME} -u${DRUPAL_DB_USER} -p${DRUPAL_DB_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
    if [ $? -eq 0 ]; then

      echo "Create settings file for existing database"
      cp /app/drupal/sites/default/default.settings.php /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php
      cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
      export METHOD_AUTO_RESULT=settings_updated
    
    else
      
      echo "Install brand new Drupal"
      source /root/db-create.sh
      source /root/db-grant-permission.sh
      source /root/drupal-install.sh
      export METHOD_AUTO_RESULT=new_install
    fi

  else

    echo "Settings file exist"
    if [ "$(cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush st | grep 'Connected' | wc -l)" == "1" ]; then

      echo "Already running"
      export METHOD_AUTO_RESULT=enabled

    else

      echo "..but doesn't work"
      mysql -h${MYSQL_HOST_NAME} -u${DRUPAL_DB_USER} -p${DRUPAL_DB_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
      if [ $? -eq 0 ]; then

        echo "Update settings file"
        cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${MYSQL_HOST_NAME}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
        export METHOD_AUTO_RESULT=settings_updated

      else

        echo "Install brand new Drupal"
        cp -f /app/drupal/sites/${DRUPAL_SUBDIR}/default.settings.php /app/drupal/sites/${DRUPAL_SUBDIR}/settings.php
        source /root/db-create.sh
        source /root/db-grant-permission.sh
        source /root/drupal-install.sh
        export METHOD_AUTO_RESULT=new_install

      fi
    fi
  fi
fi

chown -R www-data:www-data /app/drupal/sites/${DRUPAL_SUBDIR}/files

if [[ -f /root/post-install.sh ]]; then
  source /root/post-install.sh
fi

/usr/bin/supervisord
