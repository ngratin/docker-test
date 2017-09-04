#!/usr/bin/env bash
set -e

cd `dirname $0`

echo "FROM ci/base" >> Dockerfile
echo "ADD code /srv/code" >> Dockerfile

docker build -t ci/base -f ../Dockerfile ../
docker build -t ci/test -f Dockerfile .

CID=`docker run -d -p 80:80 ci/test`

# wait for start of apache
sleep 15
curl -vf localhost

docker stop $CID
