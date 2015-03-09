FROM ubuntu:14.04
MAINTAINER Jakub Piasecki <jakub@nymedia.no>

RUN DEBIAN_FRONTEND=noninteractive apt-get update &&  apt-get -y install wget unzip curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-intl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-imap
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5
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

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git

# RUN cd /home && git clone https://github.com/drush-ops/drush.git drush && cd drush && composer install && echo 'export PS1=$PATH:/home/drush/' >> ~/.bashrc

ENV DRUPAL_DB drupal
ENV DRUPAL_NAME drupal
ENV DRUPAL_PASSWORD drupal

COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./conf/install-drupal.sh /root/install-drupal.sh

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]
