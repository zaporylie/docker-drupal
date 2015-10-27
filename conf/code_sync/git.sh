#!/bin/sh

if [ -z "${CODE_GIT_CLONE_URL}" ]; then
  echo "===> [error] Missing Clone URL";
  exit 1;
elif [ -z "${CODE_SYNC_FOLDER}" ]; then
  echo "===> [error] Missing code sync folder";
  exit 1;
elif [ -z "${CODE_GIT_SHA}" ]; then
  echo "===> [error] Missing SHA";
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
  echo "===> git clone ${OPTIONS} ${CODE_SYNC_FOLDER}"
  git clone ${OPTIONS} ${CODE_SYNC_FOLDER} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo '[error] Remote repository could not be cloned.'
    exit 1;
  fi

  # Go to directory with repo.
  cd ${CODE_SYNC_FOLDER} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo '[error] App folder does not exists.'
    exit 1;
  fi

  # Checkout to given SHA.
  git checkout ${CODE_GIT_SHA} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "[error] Unable to checkout repo with given SHA ${CODE_GIT_SHA}."
    exit 1;
  fi

  echo "===> Remote repo has been cloned."
fi
