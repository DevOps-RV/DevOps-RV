#!/bin/bash

set -e
#MYSQLSH="/usr/bin/mysql"
#MYSQLSH="mysql"

MYSQLOUT="mysql.out"

[ -f r_history.out ] && rm r_history.out
[ -f sqlfile.txt ] && rm sqlfile.txt
[ -f $MYSQLOUT ] && rm $MYSQLOUT
[ -f rds-combined-ca-bundle.pem ] || wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -O rds-combined-ca-bundle.pem

RDS=${1}
REGION=${2}
PORT=3306

#RDS="dev-cluster.us-east-2.rds.amazonaws.com"
#REGION="us-east-2"

IAMUSER="deployUser"

# Make sure you have the right region for the token!!
#export LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN=1
# export AWS_ACCESS_KEY_ID=${3}
# export AWS_SECRET_ACCESS_KEY=${4}
# export AWS_SESSION_TOKEN=${5}
BUILD_ENGINEER=${3}

#TOKEN="$(aws rds generate-db-auth-token --hostname $RDS --port 3306 --profile $PROFILE --username $IAMUSER --region=$REGION)"
TOKEN=$(aws rds generate-db-auth-token \
   --hostname ${RDS} \
   --port ${PORT} \
   --region ${REGION} \
   --username ${IAMUSER})
#   --profile ${PROFILE})

MYSQL_COMMAND="mysql \
    --host=${RDS} \
    --port=${PORT} \
    --ssl-ca=rds-combined-ca-bundle.pem \
    --user=${IAMUSER} \
    --password=${TOKEN}"

#$MYSQL_COMMAND < ../scripts/release_history.sql

#Prereq
$MYSQL_COMMAND -e "CREATE SCHEMA IF NOT EXISTS cicd_release;"
$MYSQL_COMMAND -e "CREATE TABLE IF NOT EXISTS cicd_release.release_history(script_name varchar(100),release_dt datetime,build_engineer varchar(20));"
# $MYSQL_COMMAND -e "ALTER TABLE `cicd_release.release_history` MODIFY COLUMN `script_name` VARCHAR(100);"
$MYSQL_COMMAND -e "SELECT * FROM cicd_release.release_history;" > r_history.out

function release () {
  local mysqlFile=${1}
  if grep -q ${mysqlFile} r_history.out; then
    echo "    Skip ${mysqlFile}"
    touch sqlfile.txt
  else
    echo "    Running: ${mysqlFile}"
    echo "${mysqlFile}" >> sqlfile.txt
    $MYSQL_COMMAND < ${mysqlFile} > $MYSQLOUT 2>&1 || true

    if grep 'ERROR' $MYSQLOUT; then
      cat $MYSQLOUT
      exit 1
    elif grep 'Invalid' $MYSQLOUT; then
      cat $MYSQLOUT
      exit 1
    elif grep 'Incomplete statement' $MYSQLOUT; then
      cat $MYSQLOUT
      exit 1
    else
      $MYSQL_COMMAND -e "insert into cicd_release.release_history (script_name,  release_dt, build_engineer) values ('${mysqlFile}',now(),'${BUILD_ENGINEER}')"
      echo "    Completed release: ${mysqlFile}"
    fi
  fi
}

for filename in `cat masterfile.txt`; do
  word_count=$(echo -n "$filename" | wc -c)
  # echo "$filename word_count : $word_count"
  if (( $word_count <= 100 )); then
    release ${filename};
  else
    echo "$filename file name string exceeds 100 characters. Can't process"
  fi
done

echo "Completed!"