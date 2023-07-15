#!/bin/bash

#https://www.jfrog.com/confluence/display/JFROG/MySQL

DBHOST=jfrog-artifactory-db-cluster.us-east-2.rds.amazonaws.com
DBPORT=3306
DBMASTERUSER=admin
DBMASTERPASS=devops-rv

DBNAME=jfrog
DBUSER=artifactory
DBPASS=devops-rv

mysql -h ${DBHOST} -P ${DBPORT} -u ${DBMASTERUSER} -p <<EOF
CREATE DATABASE IF NOT EXISTS ${DBNAME};
SHOW DATABASES;
ALTER DATABASE ${DBNAME} CHARACTER SET utf8 COLLATE utf8_bin;
CREATE USER IF NOT EXISTS '${DBUSER}'@'%' IDENTIFIED BY '${DBPASS}';
GRANT ALL ON ${DBNAME}.* TO '${DBUSER}'@'%';
SHOW GRANTS FOR ${DBUSER}@'%';
FLUSH PRIVILEGES;
COMMIT;
EOF