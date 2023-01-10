#!/usr/bin/bash

CONTAINER_NAME='rival-politics-core-proxy'

CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then
  echo "[rival-politics-core] [debug] Container doen't ${CONTAINER_NAME} exist"
  mkdir -p ../home/service-expluatator
  git clone https://github.com/rival-politics/rival-politic ../home/service-expluatator
  mv ../home/service-expluatator/rival-politic/service-hub ../home/service-expluatator/buffer-service-hub
  rm -rf ../home/service-expluatator/rival-politic
  mkdir -p ../home/service-expluatator/service-hub
  yes | cp -rf ../home/service-expluatator/buffer-service-hub/* ../home/service-expluatator/service-hub
  docker-compose up -d -f ../home/service-expluatator/service-hub/docker-compose.yml
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