#!/bin/sh

# Bash hasn't been initialized yet so add path to composer manually.
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Run before-run scripts added by another containers.
if [[ -d /root/conf/before-start ]]; then
  echo "> BEFORE START"
  FILES=/root/conf/before-start/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi

# Run start script.
echo "> START DRUPAL"
source /root/conf/start.sh

# Run after-run scripts added by another containers.
if [[ -d /root/conf/after-start ]]; then
  echo "> AFTER START"
  FILES=/root/conf/after-start/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    source $f
  done
fi


if [[ ! -z "${TEST_BUILD}" ]]; then
  # Run tests.
  echo "> TESTS"
  REQUIREMENTS="/usr/bin/shunit2 /bin/nc"
  for R in $REQUIREMENTS; do
    if [ ! -x "$R" ]; then
      echo "Checking requirement $R... Not found. Aborting"
      exit 1
    fi
  done

  # Start nginx and php-fpm.
  /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &
  # And wait few seconds to be sure if it's running.
  sleep 8s

  # Take all tests and run it one by one.
  chmod -R u+x /root/conf/tests
  FILES=/root/conf/tests/*
  for f in $FILES
  do
    echo "=> Attaching: $f"
    $f
  done
else
  # Otherwise just use supervisord.
  /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
fi
