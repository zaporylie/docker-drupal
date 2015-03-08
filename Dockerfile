FROM    php:5.5
MAINTAINER Jakub Piasecki <jakub@nymedia.no>

RUN DEBIAN_FRONTEND=noninteractive apt-get update &&  apt-get -y install wget unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-intl
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-imap
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# Prepare volumes
VOLUME ['/application']
VOLUME ['/application/public']
VOLUME ['/application/private']

# apache2 config
COPY ./conf/drupal.conf /etc/apache2/sites-available/
RUN a2enmod rewrite \
 && a2ensite drupal \
 && a2dissite 000-default

# Add composer and drush
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer && ln -s /usr/local/bin/composer /usr/bin/composer \
  && wget https://github.com/drush-ops/drush/archive/6.x.zip && unzip 6.x.zip && mv drush-6.x /usr/local/src/drush \
  && cd /usr/local/src/drush && composer install \
  && ln -s /usr/local/src/drush/drush /usr/bin/drush

COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.php
#RUN mv /etc/apache2/apache2.conf.dist /etc/apache2/apache2.conf
#RUN mv /etc/apache2/mods-available/php5.load /etc/apache2/mods-available/php5.load.bak
#RUN a2enmod php5

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]
