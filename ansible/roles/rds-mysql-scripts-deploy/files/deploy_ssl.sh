#!/bin/bash

set -euo pipefail

MYSQLOUT=$(mktemp)
RDS=${1:-}
REGION=${2:-}
BUILD_ENGINEER=${3:-}
PORT=3306
IAMUSER="deployUser"

if [[ -z "$RDS" || -z "$REGION" || -z "$BUILD_ENGINEER" ]]; then
  echo "Usage: $0 <RDS_HOST> <REGION> <BUILD_ENGINEER>"
  exit 1
fi

[ -f rds-combined-ca-bundle.pem ] || wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -O rds-combined-ca-bundle.pem

TOKEN=$(aws rds generate-db-auth-token --hostname "$RDS" --port "$PORT" --region "$REGION" --username "$IAMUSER")

MYSQL_COMMAND="mysql --host=$RDS --port=$PORT --ssl-ca=rds-combined-ca-bundle.pem --user=$IAMUSER --password=$TOKEN"

$MYSQL_COMMAND -e "CREATE SCHEMA IF NOT EXISTS cicd_release;"
$MYSQL_COMMAND -e "CREATE TABLE IF NOT EXISTS cicd_release.release_history(script_name VARCHAR(100), release_dt DATETIME, build_engineer VARCHAR(20));"

function release() {
  local mysqlFile=$1
  if grep -q "$mysqlFile" r_history.out; then
    echo "Skipping $mysqlFile"
  else
    echo "Running: $mysqlFile"
    $MYSQL_COMMAND < "$mysqlFile" > "$MYSQLOUT" 2>&1 || true
    if grep -qE 'ERROR|Invalid|Incomplete statement' "$MYSQLOUT"; then
      cat "$MYSQLOUT"
      exit 1
    else
      $MYSQL_COMMAND -e "INSERT INTO cicd_release.release_history (script_name, release_dt, build_engineer) VALUES ('$mysqlFile', NOW(), '$BUILD_ENGINEER');"
      echo "Completed: $mysqlFile"
    fi
  fi
}

while read -r filename; do
  if [[ ${#filename} -le 100 ]]; then
    release "$filename"
  else
    echo "Filename $filename exceeds 100 characters. Skipping."
  fi
done < masterfile.txt

echo "Deployment completed!"