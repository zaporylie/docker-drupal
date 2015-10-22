#!/bin/sh


# - db sync (DB_SYNC_METHOD)
#   - if none, do nothing
#   - if auto:
#   - if file, check for .sql file in predefined location
#   - if drush, use sql-sync from one level above given level
#
if [ "${DB_SYNC_METHOD}" = "auto" ]; then
  if [ -f "/app/output/dump.sql" ]; then
    # Use file.
    DB_SYNC_METHOD = "file"
  elif [[ "$(drush @${DB_SYNC_DRUSH_FROM} st | grep 'Connected' | wc -l)" == "1" ]]; then
    # Use drush.
    DB_SYNC_METHOD = "drush"
  else
    # Do nothing.
    DB_SYNC_METHOD = ""
  fi
fi
if [ -z "${DB_SYNC_METHOD}"]; then
  source /root/conf/code_sync/${DB_SYNC}.sh
else
  echo "==> Skip db sync."
fi
