#!/usr/bin/env bash

set -e

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/ngratin/docker-test/trigger/${DOCKER_BUILD_TOKEN}/
