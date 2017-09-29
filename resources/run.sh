#!/bin/bash

set -e
(nohup cron -f &) &
/etc/init.d/mysql start
exec apachectl -DFOREGROUND 
