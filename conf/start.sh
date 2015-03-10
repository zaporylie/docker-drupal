# Bash hasn't been initialized yet so add path to composer manually.
export PATH="$HOME/.composer/vendor/bin:$PATH"

if [[ -f /root/pre-install.sh ]]; then
  source /root/pre-install.sh
fi

if [ "${METHOD}" = "auto" ]; then

  echo "Method: auto"

  if [[ ! -f /application/drupal/index.php ]]; then
    echo "Missing drupal"
    source /root/drupal-download.sh
  fi

  if [[ ! -f /application/drupal/sites/${DRUPAL_SUBDIR}/settings.php ]]; then

    echo "Missing settings file"

    mysql -h${MYSQL_PORT_3306_TCP_ADDR} -u${DRUPAL_USER} -p${DRUPAL_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
    if [ $? -eq 0 ]; then

      echo "Create settings file for existing database"
      cp /application/drupal/sites/${DRUPAL_SUBDIR}/default.settings.php /application/drupal/sites/${DRUPAL_SUBDIR}/settings.php
      cd /application/drupal && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_USER}:${DRUPAL_PASSWORD}@${MYSQL_PORT_3306_TCP_ADDR}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
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
    if [ "drush st | grep 'Connected' | wc -l)" == 1 ]; then

      echo "Already running"
      export METHOD_AUTO_RESULT=enabled

    else

      echo "..but doesn't work"
      mysql -h${MYSQL_PORT_3306_TCP_ADDR} -u${DRUPAL_USER} -p${DRUPAL_PASSWORD} -e "use ${DRUPAL_DB}; SELECT 0 FROM ${DRUPAL_DB_PREFIX}node LIMIT 1;"
      if [ $? -eq 0 ]; then

        echo "Update settings file"
        cd /application/drupal && drush eval "include DRUPAL_ROOT.'/includes/install.inc'; include DRUPAL_ROOT.'/includes/update.inc'; \$db['databases']['value'] = update_parse_db_url('mysql://${DRUPAL_USER}:${DRUPAL_PASSWORD}@${MYSQL_PORT_3306_TCP_ADDR}/${DRUPAL_DB}', '${DRUPAL_DB_PREFIX}'); drupal_rewrite_settings(\$db, '${DRUPAL_DB_PREFIX}');"
        export METHOD_AUTO_RESULT=settings_updated

      else

        echo "Install brand new Drupal"
        cp -f /application/drupal/sites/${DRUPAL_SUBDIR}/default.settings.php /application/drupal/sites/${DRUPAL_SUBDIR}/settings.php
        source /root/db-create.sh
        source /root/db-grant-permission.sh
        source /root/drupal-install.sh
        export METHOD_AUTO_RESULT=new_install

      fi
    fi
  fi
fi

chown -R www-data:www-data /application/drupal/sites/${DRUPAL_SUBDIR}/files
drush cr all
if [[ -f /root/post-install.sh ]]; then
  source /root/post-install.sh
fi

/usr/bin/supervisord
