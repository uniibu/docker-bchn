#!/usr/bin/env bash

VERSION=$1

if [ ! -z "$BCH_VERSION" ]; then
  echo "Missing version"
  exit;
fi

TEMPLATE=docker.template
rm -rf $VERSION
mkdir -p $VERSION
DOCKERFILE=$VERSION/Dockerfile
eval "echo \"$(cat "${TEMPLATE}")\"" > $DOCKERFILE

docker build -f ./$VERSION/Dockerfile -t bitsler/docker-bitcoincash:latest -t bitsler/docker-bitcoincash:$VERSION .

docker push bitsler/docker-bitcoincash:latest
docker push bitsler/docker-bitcoincash:$VERSION