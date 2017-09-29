#!/bin/bash -x

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/srv/backup"
# MYSQL_USER="backup" 
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
GZIP=/bin/gzip
GREP=/bin/grep
SHA1SUM=/usr/bin/sha1sum
SHA1SUMS="SHA1SUMS"
#MYSQL_PWARGS='--defaults-extra-file=/root/.my.cnf.backupusr'
MYSQL_PWARGS='--defaults-extra-file=/root/my.cnf.backupusr'
 
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`$MYSQL $MYSQL_PWARGS -e "SHOW DATABASES;" | $GREP -Ev "(Database|information_schema|performance_schema)"`
 
for db in $databases; do
  $MYSQLDUMP $MYSQL_PWARGS --single-transaction  --force --opt --databases $db | $GZIP > "$BACKUP_DIR/mysql/$db.gz"
  (cd "$BACKUP_DIR/mysql" && echo  "# date:${TIMESTAMP}" >> "$BACKUP_DIR/mysql/$SHA1SUMS" && $SHA1SUM -b "$db.gz" >> "$BACKUP_DIR/mysql/$SHA1SUMS")
done
