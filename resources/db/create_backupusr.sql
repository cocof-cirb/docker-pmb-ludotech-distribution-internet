CREATE USER `backupusr`@`localhost` IDENTIFIED BY 'backupusrpwd';
GRANT SHOW DATABASES, SELECT, SHOW VIEW, LOCK TABLES, RELOAD ON *.* TO `backupusr`@`localhost`;

FLUSH PRIVILEGES;
