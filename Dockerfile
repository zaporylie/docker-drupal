FROM ubuntu:14.04
MAINTAINER Jakub Piasecki <jakub@piaseccy.pl>

RUN DEBIAN_FRONTEND=noninteractive apt-get update &&  apt-get -y install wget unzip curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-intl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# Prepare volumes
VOLUME ["/application", "/application/public", "/application/private"]

# apache2 config
COPY ./conf/drupal.conf /etc/apache2/sites-available/
RUN a2enmod rewrite \
 && a2ensite drupal \
 && a2dissite 000-default

# Add composer and drush
RUN cd /home \
  && curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer \
  && composer global require drush/drush:dev-master \
  && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

ENV DRUPAL_DB drupal
ENV DRUPAL_USER drupal
ENV DRUPAL_PASSWORD drupal
ENV DRUPAL_PROFILE minimal
ENV DRUPAL_SUBDIR default
ENV DRUPAL_MAJOR_VERSION 7
ENV METHOD auto
ENV SYNC_SOURCE staging
ENV MYSQL_HOST_NAME mysql

COPY ./conf/install-fresh-drupal.sh /root/install-fresh-drupal.sh
COPY ./conf/install-existing-drupal.sh /root/install-existing-drupal.sh
COPY ./conf/drupal-download.sh /root/drupal-download.sh
COPY ./conf/drupal-install.sh /root/drupal-install.sh
COPY ./conf/db-create.sh /root/db-create.sh
COPY ./conf/db-create-user.sh /root/db-create-user.sh
COPY ./conf/db-grant-permission.sh /root/db-grant-permission.sh
COPY ./conf/start.sh /root/start.sh
RUN chmod u+x /root/install-fresh-drupal.sh \
  && chmod u+x /root/install-existing-drupal.sh \
  && chmod u+x /root/drupal-download.sh \
  && chmod u+x /root/drupal-install.sh \
  && chmod u+x /root/db-create.sh \
  && chmod u+x /root/db-create-user.sh \
  && chmod u+x /root/db-grant-permission.sh \
  && chmod u+x /root/start.sh
RUN mkdir /root/.drush && ln -s /application/drush/drushrc.php /root/.drush/drushrc.php
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80

CMD ["/bin/bash", "/root/start.sh"]
