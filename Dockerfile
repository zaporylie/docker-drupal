FROM    php:5.5-apache
MAINTAINER Jakub Piasecki <jakub@nymedia.no>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y wget unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# Prepare volumes
VOLUME ['/application']
VOLUME ['/application/public']
VOLUME ['/application/private']

# apache2 config
COPY ./environment/apache/drupal.conf /etc/apache2/sites-available/
RUN a2enmod rewrite \
 && a2ensite drupal \
 && a2dissite 000-default

# Add composer and drush
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer && ln -s /usr/local/bin/composer /usr/bin/composer \
  && wget https://github.com/drush-ops/drush/archive/6.x.zip && unzip 6.x.zip && mv drush-6.x /usr/local/src/drush \
  && cd /usr/local/src/drush && composer install \
  && ln -s /usr/local/src/drush/drush /usr/bin/drush

COPY ./environment/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]
