#!/bin/bash

testDrupal()
{
  if [ "${DRUPAL_TEST}" = 1 ]; then
    cd /app/drupal/sites/${DRUPAL_SUBDIR}
    drush en simpletest -y
    drush test-run --all
  else
    startSkipping
  fi
  assertEquals "Drupal test failed" 0 ?$
}

. shunit2
