#!/bin/sh

if [ -z "${CODE_GIT_CLONE_URL}" ]; then
  echo "==> [error] Missing Clone URL";
  exit 1;
else
  OPTIONS=

  if [ ! -z "${CODE_GIT_CLONE_BRANCH}" ]; then
    OPTIONS="${OPTIONS} --branch=${CODE_GIT_CLONE_BRANCH}"
  fi

  if [ ! -z "${CODE_GIT_CLONE_DEPTH}" ]; then
    OPTIONS="${OPTIONS} --depth=${CODE_GIT_CLONE_DEPTH}"
  fi

  OPTIONS="${OPTIONS} ${CODE_GIT_CLONE_URL}"

  # Clone repository
  echo "==> git clone ${OPTIONS} ${CODE_SYNC_FOLDER}"
  git clone ${OPTIONS} ${CODE_SYNC_FOLDER}

  # Go to directory with repo.
  cd ${CODE_SYNC_FOLDER}

  # Checkout to given SHA.
  git checkout ${CODE_GIT_CLONE_SHA}
fi
