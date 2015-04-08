#!/bin/sh
# Bash hasn't been initialized yet so add path to composer manually.
export PATH="$HOME/.composer/vendor/bin:$PATH"

if [[ -f /root/conf/before-start.sh ]]; then
  source /root/conf/before-start.sh
fi

source /root/conf/start.sh

if [[ -f /root/conf/after-start.sh ]]; then
  source /root/conf/after-start.sh
fi

# Run tests or supervisor
if [[ "$(BUILD_TEST)" = 1 ]]; then

  # Start nginx and php-fpm
  /usr/bin/supervisord &
  sleep 8s

  # Take all tests and run it one by one
  FILES=/root/conf/tests/*
  for f in $FILES
  do 
    echo "Running: $f"
    source $f
  done

else 
  /usr/bin/supervisord
fi
