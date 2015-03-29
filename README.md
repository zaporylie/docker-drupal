Drupal Docker Image [![Build Status](https://travis-ci.org/zaporylie/docker-drupal.svg?branch=master)](https://travis-ci.org/zaporylie/docker-drupal)
=============================

Simple docker image to build containers for your Drupal projects. If you are working on Drupal code you might be more interested in zaporylie/drupal-dev image which is just an extension for this module anyway.

It was created as a supporting container for zaporylie/drupal-boilerplate project.

Dockerfile is compatibile with Docker 1.2 (due to TravisCI).

## What you get?

* NGINX (thanks to [wiki.nginx.org](http://wiki.nginx.org/Drupal)
* php 5.6
* php-fpm (thanks to [ricardoarmado/docker-drupal-nginx](https://github.com/ricardoamaro/docker-drupal-nginx))
* all php libraries required by Drupal
* sshd
* drush

**MySQL service should be running in separate container!**

## Some features

* autodiscovery mode (by default) which will check if under database credits exists Drupal site OR if settings file exists but there is no DB OR if that's brand new container with nothing in it
* numbers of environmental variables which can be used to customize container (ex. select Drupal version)


## How to run this container

Please notice, that you have to already have mysql container to start this one. Read more how to run Mysql container below.

````
docker run \
  --name <drupal> \
  --link <mysql_container_name_or_id>:mysql \
  -d \
  -P \
  zaporylie/drupal
````

## Configuration

| ENNVIRONMENTAL VARIABLE  |  DEFAULT VALUE |
|:-:|:-:|
| DRUPAL_DB | drupal |
| DRUPAL_DB_USER | drupal |
| DRUPAL_DB_PASSWORD | drupal |
| DRUPAL_PROFILE | minimal |
| DRUPAL_SUBDIR | default |
| DRUPAL_MAJOR_VERSION | 7 |
| DRUPAL_DOWNLOAD_METHOD | drush |
| DRUPAL_GIT_BRANCH | 7.x |
| DRUPAL_GIT_DEPTH | 1 |
| METHOD | auto |
| MYSQL_HOST_NAME | mysql |
| DRUPAL_TEST (not implemented) | 0 |
| BUILD_TEST (not implemented) | 0 |

## Dependencies:

### Mysql

If you don't want to lose your data build data-only container first:

````
docker run \
  --name mysql_data \
  --entrypoint /bin/echo \
  mysql:5.5 \
  MYSQL data-only container
````

... then container with running mysqld process ...

````
docker run \
  --name mysql_service\
  -e MYSQL_ROOT_PASSWORD=<mysecretpassword> \
  --volumes-from mysql_data \
  -d mysql:5.5
````

## Credits

This project was created by Jakub Piasecki <jakub@piaseccy.pl>

[![nodesource/node](http://dockeri.co/image/zaporylie/drupal)](https://registry.hub.docker.com/u/zaporylie/drupal/)
