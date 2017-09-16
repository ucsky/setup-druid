#!/bin/bash
set -e
cat digital/injection_template.json | sed "s#APATHTOSUB#$PWD#g" > digital/injection.json
curl -X 'POST' -H 'Content-Type:application/json' -d @$PWD/digital/injection.json localhost:8090/druid/indexer/v1/task
rm digital/injection.json
