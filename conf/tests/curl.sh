#!/bin/bash

if [ ! "$(curl -I http://localhost:80)" ]; then
  echo "Server doesn't work"
  exit 1
fi

if [ "$(curl -I http://localhost:80 | grep 'Drupal' | wc -l)" = "0" ]; then 
  echo "Server is running but X-Generator is not a Drupal"
  exit 1
fi

echo "curl test passed"
