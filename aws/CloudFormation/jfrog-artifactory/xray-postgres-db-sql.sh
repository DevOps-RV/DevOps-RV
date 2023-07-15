#!/bin/bash

#https://www.jfrog.com/confluence/display/JFROG/MySQL

DBHOST=jfrog-artifactory-db-cluster.us-east-2.rds.amazonaws.com
DBPORT=5432
DBMASTERUSER=artifactory
DBMASTERPASS=devops-rv

DBNAME=xraydb
DBUSER=xray
DBPASS=devops-rv

CREATE DATABASE xraydb WITH OWNER=xray ENCODING='UTF8';
CREATE USER xray WITH PASSWORD 'devops-rv';
GRANT ALL PRIVILEGES ON DATABASE xraydb TO xray;


