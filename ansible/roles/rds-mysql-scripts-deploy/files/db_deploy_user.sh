#!/bin/bash

#prereq :
    #- mysql client should  present
    #- Run ./db_deploy_user.sh <RDS HOST>
    #- Enter the  admin Password

DBHOST=$1
DBPORT=3306
DBMASTERUSER=admin #default
IAMUSER=deployUser 

mysql -h ${DBHOST} -P ${DBPORT} -u ${DBMASTERUSER} -p <<EOF
CREATE USER IF NOT EXISTS '${IAMUSER}' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
GRANT USAGE ON *.* TO '${IAMUSER}'@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,DROP,RELOAD,ALTER,CREATE,INDEX,REFERENCES,RELOAD,SHOW DATABASES,SHOW VIEW,TRIGGER,USAGE,ALTER ROUTINE,CREATE ROUTINE,GRANT OPTION,CREATE TEMPORARY TABLES,EVENT,CREATE USER,CREATE VIEW,PROCESS ON *.* TO '${IAMUSER}'@'%';
SELECT * from mysql.user where user='${IAMUSER}'\G
SHOW GRANTS FOR ${IAMUSER}@'%';
FLUSH PRIVILEGES;
COMMIT;
SELECT User, Host, CONCAT(User, '@', Host) AS Username FROM mysql.user;
EOF