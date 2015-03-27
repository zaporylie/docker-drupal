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

/usr/bin/supervisord
