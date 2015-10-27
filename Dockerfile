#
# VERSION 0.1

FROM    ubuntu
MAINTAINER MrRpah_ "mrraph_@techan.fr"

RUN mkdir -p /var/www/html/owncloud /var/www/html/z-push /var/www/html/mail
RUN locale-gen fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
RUN apt-get update && apt-get --yes install \
    wget \
    git \
    cron \
    unzip \
    software-properties-common
RUN add-apt-repository -y ppa:ondrej/php5
RUN apt-get update && apt-get --yes --force-yes install \
    php5 \
    libapache2-mod-php5 \
    php5-gd \
    php5-json \ 
    php5-curl \
    php5-intl \
    php5-mcrypt \
    php5-imagick \
    php-soap \
    php5-imap \
    libawl-php \
    php5-xsl \
    php5-mysql \
    php5-sqlite
RUN apt-get --yes clean
RUN wget https://download.owncloud.org/community/owncloud-8.2.0.tar.bz2 -O /tmp/owncloud-8.2.0.tar.bz2
RUN tar -C /var/www/html/ --extract --file /tmp/owncloud-8.2.0.tar.bz2
RUN mv /var/www/html/owncloud /var/www/html/cloud
RUN php5enmod imap
RUN git clone https://github.com/fmbiete/Z-Push-contrib /var/www/html/z-push
RUN cd /var/www/html/z-push && git checkout -q d0cd5a47c53afac5c3b287006dc8a48a1c4ffcd5
RUN ln -s /var/www/html/z-push/z-push-admin.php /usr/sbin/z-push-admin
RUN ln -s /var/www/html/z-push/z-push-top.php /usr/sbin/z-push-top
RUN sed -i "s^define('TIMEZONE', .*^define('TIMEZONE', 'Europe/Paris');^" /var/www/html/z-push/config.php
RUN sed -i "s/define('BACKEND_PROVIDER', .*/define('BACKEND_PROVIDER', 'BackendCombined');/" /var/www/html/z-push/config.php
RUN sed -i "s/define('USE_FULLEMAIL_FOR_LOGIN', .*/define('USE_FULLEMAIL_FOR_LOGIN', true);/" /var/www/html/z-push/config.php
RUN mv /var/www/html/z-push/backend/combined/config.php /var/www/html/z-push/backend/combined/config.php.ori
RUN mv /var/www/html/z-push/backend/imap/config.php /var/www/html/z-push/backend/imap/config.php.ori
RUN mv /var/www/html/z-push/backend/carddav/config.php /var/www/html/z-push/backend/carddav/config.php.ori
RUN mv /var/www/html/z-push/backend/caldav/config.php /var/www/html/z-push/backend/caldav/config.php.ori
RUN mv /var/www/html/z-push/autodiscover/config.php /var/www/html/z-push/autodiscover/config.php.ori
ADD z-push/backend_combined.php /data/conf/z-push
ADD z-push/backend_imap.php /data/conf/z-push
ADD z-push/backend_carddav.php /data/conf/z-push
ADD z-push/backend_caldav.php /data/conf/z-push
ADD z-push/autodiscover_config.php /data/conf/z-push
RUN ln -s /data/conf/z-push/backend_combined.php /var/www/html/z-push/backend/combined/config.php
RUN ln -s /data/conf/z-push/backend_imap.php /var/www/html/z-push/backend/imap/config.php
RUN ln -s /data/conf/z-push/backend_carddav.php /var/www/html/z-push/backend/carddav/config.php
RUN ln -s /data/conf/z-push/backend_caldav.php /var/www/html/z-push/backend/caldav/config.php
RUN ln -s /data/conf/z-push/autodiscover_config.php /var/www/html/z-push/autodiscover/config.php
RUN chown -h www-data:www-data /var/www/html/z-push/backend/combined/config.php
RUN chown -h www-data:www-data /var/www/html/z-push/backend/imap/config.php
RUN chown -h www-data:www-data /var/www/html/z-push/backend/imap/config.php
RUN chown -h www-data:www-data /var/www/html/z-push/backend/caldav/config.php
RUN chown -h www-data:www-data /var/www/html/z-push/autodiscover/config.php
RUN mkdir -p /data/cloud /data/conf/cloud
ADD owncloud/config.php /data/conf/cloud
RUN mv /var/www/html/mail/data /data/rainloop
RUN ln -s /data/rainloop /var/www/html/mail/data
RUN ln -s /data/conf/cloud/config.php /var/www/html/cloud/config
RUN chown -h www-data:www-data /var/www/html/mail/data
RUN chown -h www-data:www-data /var/www/html/cloud/config/config.php
RUN mkdir -p /var/log/z-push
RUN mkdir -p /var/lib/z-push
RUN chmod 750 /var/log/z-push
RUN chmod 750 /var/lib/z-push
RUN chown www-data:www-data /var/log/z-push
RUN chown www-data:www-data /var/lib/z-push
RUN wget http://repository.rainloop.net/v2/webmail/rainloop-community-latest.zip -O /tmp/rainloop-community-latest.zip
RUN cd /var/www/html/mail && unzip /tmp/rainloop-community-latest.zip
RUN chown -R www-data:www-data /var/www
RUN chown -R www-data:www-data /data
RUN for mod in $(ls /etc/apache2/mods-available); do /usr/sbin/a2enmod $(echo $mod | awk -F'.' '{print $1}') ; done
RUN mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.ori
ADD apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD start.sh /opt
RUN touch /data/.installed
RUN cp -rp /data /data.ori
EXPOSE 80
CMD ["/bin/bash", "-c", "cd /opt; ./start.sh"]
