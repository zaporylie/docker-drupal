Drupal Docker Image
=============================
[![nodesource/node](http://dockeri.co/image/zaporylie/drupal)](https://registry.hub.docker.com/u/zaporylie/drupal/)

## dependencies:
````
docker run \
  --name mysql_data \
  --entrypoint /bin/echo \
  mysql:5.5 \
  MYSQL data-only container
````

````
docker run \
  --name mysql_service\
  -e MYSQL_ROOT_PASSWORD=<mysecretpassword> \
  --volumes-from mysql_data \
  -d mysql:5.5
````

## How to run it?
````
docker run \
  --name drupal \
  --link <mysql_container_name_or_id>:mysql \
  -d \
  -P \ 
  -e DRUPAL_USER=drupal \
  -e DRUPAL_PASSWORD=drupal \
  -e DRUPAL_PROFILE=minimal \
  -e DRUPAL_SUBDIR=default \
  -e DRUPAL_DB=drupal \
  -e METHOD=auto \
  -e MYSQL_HOST_NAME=auto \
  zaporylie/drupal
````
