#!/bin/sh
#
# Copyright 2016-2017 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This is a test script that runs a Hawkular Services server and a Prometheus Server
# both in docker.
# Thus this script is for anyone that wants to demo a simple Hawkular Services setup
# without having to build anything. You just need this script file and the prometeus.yml
# configuration file.

SCRIPT_BASEDIR=$(dirname $(readlink -f "$0"))

if [[ ! -d $HAWKULAR_DATA ]]; then
  HAWKULAR_DATA=/tmp/hawkular
fi
mkdir -p $HAWKULAR_DATA

docker run \
  --detach \
  --publish 8080:8080 \
  --volume ${HAWKULAR_DATA}:/var/hawkular \
  --net "host" \
  --env HAWKULAR_DATA=/var/hawkular \
  hawkular/hawkular-services:hawkular-1275

docker run \
  --detach \
  --publish 9090:9090 \
  --volume ${HAWKULAR_DATA}:/var/hawkular \
  --net "host" \
  --volume ${SCRIPT_BASEDIR}/prometheus.yml:/prometheus.yml \
  prom/prometheus:v2.0.0 \
    --config.file=/prometheus.yml
