#!/bin/sh

chmod -R u+x /root/conf/tests > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Access to test files could not be granted'
  exit 1;
fi
