#!/bin/sh

# Before code sync.
if [[ -d /root/conf/sync-code-before ]]; then
  echo "> BEFORE CODE SYNC"
  FILES=/root/conf/sync-code-before/*
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
echo "> CODE SYNC"
if [ "${CODE_SYNC_METHOD}" = "auto" ]; then
  if [ ! -d "/app/drupal" ] || [ "$(cd /app/drupal/ && drush st | grep 'Drupal version' | wc -l)" = "0" ]; then
    CODE_SYNC_METHOD="drush"
  else
    CODE_SYNC_METHOD=""
  fi
fi
if [ -z "${CODE_SYNC_METHOD}" ]; then
  # Return information that code sync has been skipped.
  echo "=> Skip code sync."
else
  # Sync code.
  if [ -f "/root/conf/code_sync/${CODE_SYNC_METHOD}.sh" ]; then
    echo "=> Attaching: /root/conf/code_sync/${CODE_SYNC_METHOD}.sh"
    source /root/conf/code_sync/${CODE_SYNC_METHOD}.sh
  else
    # If code cannot be synced, throw exit code.
    echo "=> [${CODE_SYNC_METHOD}] This code sync method has not been implemented yet"
    exit 1
  fi
fi

# After code sync.
if [[ -d /root/conf/sync-code-after ]]; then
  echo "> AFTER CODE SYNC"
  FILES=/root/conf/sync-code-after/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

# Before DB sync.
if [[ -d /root/conf/sync-db-before ]]; then
  echo "> BEFORE DB SYNC"
  FILES=/root/conf/sync-db-before/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

# todo: Sync it if there is any existing datasource.
echo "> DB SYNC"


# After DB sync.
if [[ -d /root/conf/sync-db-after ]]; then
  echo "> AFTER DB SYNC"
  FILES=/root/conf/sync-db-after/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

