#!/bin/bash

handleSigTerm()
{
    echo SIGTERM
}

oneTimeSetUp()
{
    trap "handleSigTerm" TERM
}

testNginxAccessibleOnPort80() 
{
  
  curl -I http://localhost:80
  
  assertEquals "NGINX should be accessible on port 80" 0 $?
}

testXGenerator() 
{

  rows=$(curl -I http://localhost:80 | grep 'Drupal' | wc -l)

  assertEquals "X-Generator is not a Drupal" 1 $rows
}

. shunit2
