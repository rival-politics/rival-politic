#!/usr/bin/bash

set -e

CONTAINER_NAME='rival-politics-core-proxy'
ST='..'
WORKDIR='/home/service-expluatator'

CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then
  echo "[rival-politics-core] [debug] Container doen't ${CONTAINER_NAME} exist"
  mkdir -p $ST$WORKDIR
  mkdir -p $ST$WORKDIR/rival-politic
  echo "[rival-politics-core] [debug] Additional files have been created"
  git clone https://github.com/rival-politics/rival-politic $ST$WORKDIR/rival-politic/
  echo "[rival-politics-core] [debug] Repository has been clonned success"
  mkdir -p $ST$WORKDIR/buffer-service-hub
  cp -rf $ST$WORKDIR/rival-politic/service-hub/* $ST$WORKDIR/buffer-service-hub/
  echo "[rival-politics-core] [debug] Create buffer folder..."
  rm -rf $ST$WORKDIR/rival-politic
  mkdir -p $ST$WORKDIR/service-hub
  cp -rf $ST$WORKDIR/buffer-service-hub/* $ST$WORKDIR/service-hub/
  echo "[rival-politics-core] [debug] Starting a docker-compose..."
  docker-compose -f $WORKDIR/service-hub/docker-compose.yml up -d --force-recreate
  echo "[rival-politics-core] [debug] Job has been completed"
else
  echo "[rival-politics-core] [debug] Container ${CONTAINER_NAME} exist"
  docker stop $CONTAINER_NAME
  cd service-expluatator
  cd buffer-service-hub
  git pull origin main
  cd ..
  yes | cp -rf buffer-service-hub/* service-hub
  cd service-hub
  docker-compose up -d
fi