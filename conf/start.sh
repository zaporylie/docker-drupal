#!/bin/sh

# Before code sync.
if [[ -d /root/conf/sync-code-before ]] && [ "$(ls -A /root/conf/sync-code-before)" ]; then
  echo "=> BEFORE CODE SYNC"
  FILES=/root/conf/sync-code-before/*
  for f in $FILES
  do
    echo "==> Attaching: $f"
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
echo "=> CODE SYNC"
if [ "${CODE_SYNC_METHOD}" = "auto" ]; then
  if [ ! -d "/app/drupal" ] || [ "$(cd /app/drupal/ && drush st | grep 'Drupal version' | wc -l)" = "0" ]; then
    CODE_SYNC_METHOD="drush"
  else
    CODE_SYNC_METHOD=""
  fi
fi
if [ -z "${CODE_SYNC_METHOD}" ]; then
  # Return information that code sync has been skipped.
  echo "==> Skip code sync."
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

# After code sync.
if [[ -d /root/conf/sync-code-after ]] && [ "$(ls -A /root/conf/sync-code-after)" ]; then
  echo "=> AFTER CODE SYNC"
  FILES=/root/conf/sync-code-after/*
  for f in $FILES
  do
    echo "==> Attaching: $f"
    source $f
  done
fi

# Before DB sync.
if [[ -d /root/conf/sync-db-before ]] && [ "$(ls -A /root/conf/sync-db-before)" ]; then
  echo "=> BEFORE DB SYNC"
  FILES=/root/conf/sync-db-before/*
  for f in $FILES
  do
    echo "==> Attaching: $f"
    source $f
  done
fi

# todo: Sync it if there is any existing datasource.
echo "=> DB SYNC"
# - db sync (DB_SYNC_METHOD)
#   - if none, do nothing
#   - if auto:
#   - if file, check for .sql file in predefined location
#   - if drush, use sql-sync from one level above given level
#
if [ "${DB_SYNC_METHOD}" = "auto" ]; then
  if [ -f "${DB_SYNC_FILE}" ]; then
    # Use file.
    DB_SYNC_METHOD="file"
  elif [ -f /tmp/local.sql ]; then
    # Use file.
    DB_SYNC_FILE="/tmp/local.sql"
    DB_SYNC_METHOD="file"
  elif [ ! -z "${DB_SYNC_DRUSH_FROM}" ] && [ "$(drush @${DB_SYNC_DRUSH_FROM} st | grep 'Connected' | wc -l)" == "1" ]]; then
    # Use drush.
    DB_SYNC_METHOD="drush"
  else
    # Do nothing.
    DB_SYNC_METHOD=""
  fi
fi
if [ -z "${DB_SYNC_METHOD}" ]; then
  echo "==> Skip db sync."
else
  if [ -f "/root/conf/db_sync/${DB_SYNC_METHOD}.sh" ]; then
    echo "==> Attaching: /root/conf/db_sync/${DB_SYNC_METHOD}.sh"
    source /root/conf/db_sync/${DB_SYNC_METHOD}.sh
  else
    # If code cannot be synced, throw exit code.
    echo "==> [${DB_SYNC_METHOD}] This db sync method has not been implemented yet"
    exit 1
  fi
fi

# After DB sync.
if [[ -d /root/conf/sync-db-after ]] && [ "$(ls -A /root/conf/sync-db-after)" ]; then
  echo "=> AFTER DB SYNC"
  FILES=/root/conf/sync-db-after/*
  for f in $FILES
  do
    echo "==> Attaching: $f"
    source $f
  done
fi

