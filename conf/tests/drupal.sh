#!/bin/bash

testDrupal()
{
  if [ -z "${TEST_DRUPAL}" ]; then
    startSkipping
  else
    cd /app/drupal/sites/${DRUPAL_SUBDIR}
    drush en simpletest -y
    drush cr
    cd /app/drupal
    if [ "$(drush st | grep 'Drupal version' | grep '8.' | wc -l)" = "1" ]; then
      php ./core/scripts/run-tests.sh --url http://localhost/ --all
    else
      php ./scripts/run-tests.sh --url http://localhost/ --all
    fi
  fi
  assertEquals "Drupal test failed" 0 ?$
}

. shunit2
