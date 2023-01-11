#!/usr/bin/bash

set -e

CONTAINER_NAME='rival-politics-core-proxy'
ST='..'
WORKDIR='/home/service-expluatator'
NAMEWORKDIR='service-hub'
GITHUB_REPO='https://github.com/rival-politics/rival-politic'


CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then

  if [[ -d "${ST}${WORKDIR}" ]]
  then
    echo "[${CONTAINER_NAME}] [debug] Workdir ${WORKDIR} already exist, we made delete this."
    rm -rf $ST$WORKDIR/$NAMEWORKDIR/
  fi

  echo "[${CONTAINER_NAME}] [debug] Container doen't ${CONTAINER_NAME} exist"
  mkdir -p $ST$WORKDIR
  mkdir -p $ST$WORKDIR/buffer-$NAMEWORKDIR
  echo "[${CONTAINER_NAME}] [debug] Additional files have been created"
  git clone $GITHUB_REPO $ST$WORKDIR/buffer-$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Repository has been clonned success"
  echo "[${CONTAINER_NAME}] [debug] Create buffer folder..."
  mkdir -p $ST$WORKDIR/$NAMEWORKDIR
  cp -rf $ST$WORKDIR/buffer-$NAMEWORKDIR/* $ST$WORKDIR/$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Starting a docker-compose..."
  echo "[${CONTAINER_NAME}] [debug] #1 Create global docker network"
  docker network create rival-politics-core-network
  docker-compose -f $WORKDIR/$NAMEWORKDIR/service-hub/docker-compose.yml up -d --force-recreate
  echo "[${CONTAINER_NAME}] [debug] Job has been completed"
else
  echo "[${CONTAINER_NAME}] [debug] Container ${CONTAINER_NAME} exist"
  docker stop $CONTAINER_NAME
  git -C $ST$WORKDIR/buffer-$NAMEWORKDIR pull origin main
  echo "[${CONTAINER_NAME}] [debug] Pull buffer repository has been completed"
  cp -rf $ST$WORKDIR/buffer-$NAMEWORKDIR/* $ST$WORKDIR/$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Copy to work directory has been completed"
  echo "[${CONTAINER_NAME}] [debug] Starting a docker-compose..."
  docker-compose -f $WORKDIR/$NAMEWORKDIR/service-hub/docker-compose.yml up -d --force-recreate
  echo "[${CONTAINER_NAME}] [debug] Job has been completed"
fi