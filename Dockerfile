FROM tutum/apache-php
MAINTAINER Jakub Piasecki <jakub@piaseccy.pl>

# /app was user by tutum/apache-php image
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install openssh-server supervisor php5-mysql mysql-client git \
  && rm -rf /app

COPY ./conf/* /root/

# Prepare volumes
VOLUME ["/app"]

# apache2 config
RUN a2enmod rewrite \
 && rm -fr /var/www/html \
 && ln -s /app/drupal /var/www/html \
 && cd /home \
 && composer global require drush/drush:dev-master \
 && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc \
 && sed -ri 's/^expose_php\s*=\s*On/expose_php = Off/g' /etc/php5/apache2/php.ini \
 && sed -ri 's/^expose_php\s*=\s*On/expose_php = Off/g' /etc/php5/cli/php.ini \
 && sed -ri 's/^allow_url_fopen\s*=\s*On/allow_url_fopen = Off/g' /etc/php5/apache2/php.ini \
 && sed -ri 's/^upload_max_filesize\s*=\s*2M/upload_max_filesize = 64M/g' /etc/php5/apache2/php.ini \
 && sed -ri 's/^upload_max_filesize\s*=\s*2M/upload_max_filesize = 64M/g' /etc/php5/cli/php.ini \
 && mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor \
 && chmod u+x /root/drupal-download.sh \
 && chmod u+x /root/drupal-install.sh \
 && chmod u+x /root/db-create.sh \
 && chmod u+x /root/db-wait.sh \
 && chmod u+x /root/db-create-user.sh \
 && chmod u+x /root/db-grant-permission.sh \
 && chmod u+x /root/start.sh \
 && cp /root/drupal.conf /etc/apache2/sites-available/ \
 && cp /root/supervisord.conf /etc/supervisor/conf.d/supervisord.conf \
 && a2ensite drupal \
 && a2dissite 000-default

ENV DRUPAL_DB=drupal \
 DRUPAL_DB_USER=drupal \
 DRUPAL_DB_PASSWORD=drupal \
 DRUPAL_PROFILE=minimal \
 DRUPAL_SUBDIR=default \
 DRUPAL_MAJOR_VERSION=7 \
 DRUPAL_DOWNLOAD_METHOD=drush \
 DRUPAL_GIT_BRANCH=7.x \
 DRUPAL_GIT_DEPTH=1 \
 METHOD=auto \
 MYSQL_HOST_NAME=mysql

EXPOSE 22 80

ENTRYPOINT ["/bin/bash"]

CMD ["/root/start.sh"]
