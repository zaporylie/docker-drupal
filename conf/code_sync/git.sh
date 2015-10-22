#!/bin/sh

if [ -z "${CODE_GIT_CLONE_URL}" ]; then

  OPTIONS = ${CODE_GIT_CLONE_URL}

  if [ -z "${CODE_GIT_CLONE_BRANCH}" ]; then
    OPTIONS= ${OPTIONS} + ' --branch ' + ${CODE_GIT_CLONE_BRANCH}
  fi

  if [ -z "${CODE_GIT_CLONE_DEPTH}" ]; then
    OPTIONS= ${OPTIONS} + ' --depth ' + ${CODE_GIT_CLONE_DEPTH}
  fi

  # Clone repository
  git clone ${OPTIONS} ${CODE_SYNC_FOLDER}

  # Go to directory with repo.
  cd ${CODE_SYNC_FOLDER}

  # Checkout to given SHA.
  git checkout ${CODE_GIT_CLONE_SHA}
fi
