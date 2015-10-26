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

if [[ -d /root/conf/before-install ]]; then
  echo "> AFTER INSTALL"
  FILES=/root/conf/after-install/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

