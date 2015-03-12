Drupal Docker Image
=============================
[![nodesource/node](http://dockeri.co/image/zaporylie/drupal)](https://registry.hub.docker.com/u/zaporylie/drupal/)

## How to run this container
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
| METHOD | auto |
| MYSQL_HOST_NAME | mysql |

## Dependencies:

You need to have mysql in separate container(s):

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
