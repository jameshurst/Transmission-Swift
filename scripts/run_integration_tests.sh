#!/bin/bash

set -ex

ROOT='scripts/.integration-test'

docker container stop TransmissionIntegrationTests 2>/dev/null || true
docker container rm TransmissionIntegrationTests 2>/dev/null || true

rm -rf $ROOT
mkdir -p $ROOT/{config,downloads}

docker run \
    -d \
    --name=TransmissionIntegrationTests \
    -p 9091:9091 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v "$(pwd)/$ROOT/config:/config" \
    -v "$(pwd)/$ROOT/downloads:/downloads" \
    linuxserver/transmission

sleep 5

swift test --filter TransmissionIntegrationTests && RC=$? || RC=$?

docker container stop TransmissionIntegrationTests
docker container rm TransmissionIntegrationTests

exit $RC
