#!/bin/bash

testNginxAccessibleOnPort80()
{
  curl -I http://localhost:80 > /dev/null 2>&1
  assertEquals "NGINX should be accessible on port 80" 0 $?
}

testXGenerator()
{
  rows=$(curl -IsS http://localhost:80 | grep "X-Generator" | grep "Drupal" | wc -l)
  assertEquals "X-Generator is not a Drupal" 1 $rows
}

. shunit2
