#!/bin/bash
set -e
cat meteo/injection_template.json | sed "s#APATHTOSUB#$PWD#g" > meteo/injection.json
curl -X 'POST' -H 'Content-Type:application/json' -d @$PWD/meteo/injection.json localhost:8090/druid/indexer/v1/task
rm meteo/injection.json
