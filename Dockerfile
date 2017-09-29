FROM ubuntu

### Caution, the following must be match with the settings in PHP files pmb/includes/db_param.inc.php
ENV MYSQL_PASS=ludo

ENV DB_NAME=ludoDB
ENV DB_USER=ludo
ENV DB_PASS=ludo
ENV LUDO_NAME=ludo


# Variables ysed for interchange between ludos, if you have more than one ludo hosted on the same server
# Caution: the following must be match with the settings in the http interface in PMB Menu at:
#     Administration > Paramètres > Z3950 > Serveurs
# If you have only 1 ludo of if you don't care about exchanging notices between ludos, then you can safely
# ignore/randomize these two values.
ENV Z_LUDO_USER=z_ludotechuser                                                                                                                                                                                  
ENV Z_LUDO_PASS=z3950                                                                                                                                                                                           


RUN apt-get update \
   && apt-get install -y gettext-base apache2 php5 mysql-server libapache2-mod-php5 php5-mysql php5-curl php5-gd php5-xsl imagemagick rsync git \
   && apt-get clean && rm -rf /var/lib/apt/lists/*
 
# NB: You don't need to run this line
#   apt-get install -y libyaz4 libyaz4-dev libyazpp4
# because it's not used by ludo. Instead we use a pure-sql approach. Exchange is currently possible only
# if the databases are hosted on the same mysql server.

##############################################################################################################
# Setup apache2 and php config 
#
# The original ludo server is hosted in CentOS. Its default http document root is configured in /srv/data/html
# As this path (/srv/data) is referred in the configuration file, in the various backup procedures and in the
# ludo database itself (Administration > Documents numériques > Répertoires d'upload) , I've chosen to keep 
# this setup for this Ubuntu docker
##############################################################################################################

ENV HTML_D=/srv/data/html

# Adapt Apache config to use the CentOS-style documentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /srv/data/html|g' /etc/apache2/sites-enabled/000-default.conf
RUN sed -i 's|<Directory /var/www/>|<Directory /srv/data/html>|g' /etc/apache2/apache2.conf

# Fine tune php.ini to upload bigger pdf files
RUN sed -i 's/^upload_max_filesize.*/upload_max_filesize = 30M/g' /etc/php5/apache2/php.ini



##############################################################################################################
# Deploy the PMB LudoTech code
##############################################################################################################
### Work from github with detached HEAD for the tag 'PMB_LUDO_4.2'
RUN mkdir -p ${HTML_D} \
    && git clone --branch 'PMB_LUDO_4.2' https://github.com/cocof-cirb/pmb_ludoTech/ ${HTML_D}/ \
    ## Remove built-in documentation (lighter docker image)
    && rm -fr ${HTML_D}/pmb/doc \
    && chown -R www-data:www-data ${HTML_D}

# Add sample notices (docnotices) and thumbnails (docvignette)
ADD resources/attachments ${HTML_D}/

# Overwrite the Brussels banner (TODO: should be done in git)
ADD resources/images/banner.jpg ${HTML_D}/pmb/opac_css/styles/cocof/images/banner.jpg

# Ensure proper access rights
RUN mkdir -p ${HTML_D}/pmb/temp/ \
   && chmod -R 755 ${HTML_D}/ \
   && chown -R www-data.www-data ${HTML_D}/ \
   && chmod -R a+rwx ${HTML_D}/pmb/temp/ 


##############################################################################################################
# Setup Database
#
# TODO: avoid fat temporary SQL file
##############################################################################################################

ADD resources/db/ /tmp/

# Restore DB dump + bootstrap ludo db user creation and backupusr
RUN /etc/init.d/mysql start \
   && sleep 25 \
   && envsubst < /tmp/create_ludo_usr.sql | mysql -u root && echo "OK created ludo db user" \
   && envsubst < /tmp/create_backupusr.sql | mysql -u root && echo "OK created backupusr db user" \
   && echo 'create database ludoDB;' | mysql -u root && echo "OK Created emtpy ludoDB" \
   && mysql -u root ludoDB < /tmp/dump/ludoDB.sql && echo "OK restore dump" \
   && /etc/init.d/mysql stop


##############################################################################################################
# Setup daily backup procedure
##############################################################################################################

# Setup Backup source and target
RUN mkdir -p /srv/backup/files/srv/data \
   && mkdir -p /srv/backup/mysql \

   # Don't forget to do that or you will lose some hairs :-)
   && touch /etc/cron.d/ludo-backups 

ADD resources/sh/etc/cron.d/ludo-backups /etc/cron.d/
ADD resources/sh/etc/cron_scripts/mysql-backup.sh /etc/cron_scripts/
ADD resources/sh/etc/cron_scripts/backup-vignettes-docnotices.sh /etc/cron_scripts/
ADD resources/sh/my.cnf.backupusr /root/

WORKDIR ${HTML_D}/pmb

EXPOSE 80 3306

ADD resources/run.sh /
CMD ["/run.sh"]

