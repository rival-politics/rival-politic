#!/usr/bin/bash

set -e

CONTAINER_NAME='rival-politics-core-proxy'
ST='..'
WORKDIR='/home/service-expluatator'
NAMEWORKDIR='service-hub'
GITHUB_REPO='https://github.com/rival-politics/rival-politic'

NETWORK_NAME='rival-politics-core-network'


CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then
  
  if [[ -d "${ST}${WORKDIR}" ]]
  then
    echo "[${CONTAINER_NAME}] [debug] Workdir ${WORKDIR} already exist, we made delete ${ST}${PWORKDIR}/${NAMEWORKDIR}/ and ${ST}${WORKDIR}/bufffer-${NAMEWORKDIR}/."
    rm -rf $WORKDIR/$NAMEWORKDIR
    rm -rf $WORKDIR/buffer-$NAMEWORKDIR
  fi

  echo "[${CONTAINER_NAME}] [debug] Container doen't ${CONTAINER_NAME} exist"
  mkdir -p $ST$WORKDIR
  mkdir -p $ST$WORKDIR/buffer-$NAMEWORKDIR
  echo "[${CONTAINER_NAME}] [debug] Additional files have been created"
  git clone $GITHUB_REPO $ST$WORKDIR/buffer-$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Repository has been clonned success"
  echo "[${CONTAINER_NAME}] [debug] Create buffer folder..."
  mkdir -p $ST$WORKDIR/$NAMEWORKDIR
  rsync -av $ST$WORKDIR/buffer-$NAMEWORKDIR/* $ST$WORKDIR/$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Starting a docker-compose..."

  if [[ "$(docker network ls | grep "${NETWORK_NAME}")" == "" ]] ; then
    echo "[${CONTAINER_NAME}] [debug] #1 Create global docker network"
    docker network create $NETWORK_NAME 
  else 
    echo "[${CONTAINER_NAME}] [debug] #1 Network create skipping..."
  fi

  docker-compose -f $WORKDIR/$NAMEWORKDIR/service-hub/docker-compose.yml up -d --force-recreate
  echo "[${CONTAINER_NAME}] [debug] Job has been completed"
else
  echo "[${CONTAINER_NAME}] [debug] Container ${CONTAINER_NAME} exist"
  docker stop $CONTAINER_NAME
  git -C $ST$WORKDIR/buffer-$NAMEWORKDIR pull origin main
  echo "[${CONTAINER_NAME}] [debug] Pull buffer repository has been completed"
  rsync -av $ST$WORKDIR/buffer-$NAMEWORKDIR/* $ST$WORKDIR/$NAMEWORKDIR/
  echo "[${CONTAINER_NAME}] [debug] Copy to work directory has been completed"
  echo "[${CONTAINER_NAME}] [debug] Starting a docker-compose..."
  docker-compose -f $WORKDIR/$NAMEWORKDIR/service-hub/docker-compose.yml up -d --force-recreate
  echo "[${CONTAINER_NAME}] [debug] Job has been completed"
fi