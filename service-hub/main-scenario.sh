#!/usr/bin/bash

CONTAINER_NAME='rival-politics-core-proxy'

cd ../home

CID=$(docker ps -q -f status=running -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; 
then
  echo "Container doesn't exist"
else
  echo "Container exist"
fi