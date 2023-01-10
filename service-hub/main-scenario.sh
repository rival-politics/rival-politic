#!/usr/bin/bash

set -e

CONTAINER_NAME='rival-politics-core-proxy'
ST='..'
WORKDIR='/home/service-expluatator'

CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then

  if [[ -d "${ST}${WORKDIR}" ]]
  then
    echo "[rival-politics-core] [debug] Workdir ${WORKDIR} already exist, we made delete this."
    rm -rf ../home/service-expluatator/
  fi

  echo "[rival-politics-core] [debug] Container doen't ${CONTAINER_NAME} exist"
  mkdir -p $ST$WORKDIR
  mkdir -p $ST$WORKDIR/buffer-service-hub
  echo "[rival-politics-core] [debug] Additional files have been created"
  git clone https://github.com/rival-politics/rival-politic $ST$WORKDIR/buffer-service-hub/
  echo "[rival-politics-core] [debug] Repository has been clonned success"
  echo "[rival-politics-core] [debug] Create buffer folder..."
  mkdir -p $ST$WORKDIR/service-hub
  cp -rf $ST$WORKDIR/buffer-service-hub/* $ST$WORKDIR/service-hub/
  echo "[rival-politics-core] [debug] Starting a docker-compose..."
  docker-compose -f $WORKDIR/service-hub/service-hub/docker-compose.yml up -d --force-recreate
  echo "[rival-politics-core] [debug] Job has been completed"
else
  echo "[rival-politics-core] [debug] Container ${CONTAINER_NAME} exist"
  docker stop $CONTAINER_NAME
  git -c $ST$WORKDIR/buffer-service-hub/ pull origin main
  echo "[rival-politics-core] [debug] Pull buffer repository has been completed"
  cp -rf $ST$WORKDIR/buffer-service-hub/* $ST$WORKDIR/service-hub/
  echo "[rival-politics-core] [debug] Copy to work directory has been completed"
  echo "[rival-politics-core] [debug] Starting a docker-compose..."
  docker-compose -f $WORKDIR/service-hub/service-hub/docker-compose.yml up -d --force-recreate
  echo "[rival-politics-core] [debug] Job has been completed"
fi