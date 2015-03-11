FROM tutum/apache-php
MAINTAINER Jakub Piasecki <jakub@piaseccy.pl>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install openssh-server supervisor php5-mysql mysql-client git

COPY ./conf/drupal-download.sh /root/drupal-download.sh
COPY ./conf/drupal-install.sh /root/drupal-install.sh
COPY ./conf/db-create.sh /root/db-create.sh
COPY ./conf/db-create-user.sh /root/db-create-user.sh
COPY ./conf/db-grant-permission.sh /root/db-grant-permission.sh
COPY ./conf/start.sh /root/start.sh
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./conf/drupal.conf /etc/apache2/sites-available/

RUN rm -rf /app

# Prepare volumes
VOLUME ["/app"]

# apache2 config
RUN a2enmod rewrite \
 && rm -fr /var/www/html \
 && ln -s /app/drupal /var/www/html \
 && cd /home \
 && composer global require drush/drush:dev-master \
 && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc \
 && mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor \
 && chmod u+x /root/drupal-download.sh \
 && chmod u+x /root/drupal-install.sh \
 && chmod u+x /root/db-create.sh \
 && chmod u+x /root/db-create-user.sh \
 && chmod u+x /root/db-grant-permission.sh \
 && chmod u+x /root/start.sh \
 && a2ensite drupal \
 && a2dissite 000-default

ENV DRUPAL_DB drupal
ENV DRUPAL_DB_USER drupal
ENV DRUPAL_DB_PASSWORD drupal
ENV DRUPAL_PROFILE minimal
ENV DRUPAL_SUBDIR default
ENV DRUPAL_MAJOR_VERSION 7
ENV DRUPAL_DOWNLOAD_METHOD drush
ENV METHOD auto
ENV MYSQL_HOST_NAME mysql

EXPOSE 22 80

CMD ["/bin/bash", "/root/start.sh"]
