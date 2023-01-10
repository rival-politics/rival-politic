#!/usr/bin/bash

CONTAINER_NAME='rival-politics-core-proxy'

cd ../home

CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then
  echo "[rival-politics-core] [debug] Container doen't ${CONTAINER_NAME} exist"
  git clone https://github.com/rival-politics/rival-politic
  mv rival-politic/buffer-service-hub buffer-service-hub
  rm -rf rival-politic
  mkdir service-hub
  yes | cp -rf buffer-service-hub/* service-hub
  cd service-hub
  docker-compose up -d
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