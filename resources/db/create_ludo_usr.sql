--
-- Recreate ludo db

-- Default values
-- 
-- ENV DB_NAME=ludoDB
-- ENV DB_USER=ludo
-- ENV DB_PASS=ludo
-- ENV LUDO_NAME=ludo
-- ENV Z_LUDO_USER=z_ludotechuser
-- ENV Z_LUDO_PASS=z3950

CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY  '${DB_PASS}';
GRANT USAGE ON *.* TO  '${DB_USER}'@'localhost' IDENTIFIED BY  '${DB_PASS}' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;
GRANT ALL PRIVILEGES ON  ${DB_NAME} . * TO  '${DB_USER}'@'localhost';

-- Creation of the z_ludo user...
CREATE USER '${Z_LUDO_USER}'@'localhost' IDENTIFIED BY  '${Z_LUDO_PASS}';
GRANT SELECT ON *.* TO  '${Z_LUDO_USER}'@'localhost';
