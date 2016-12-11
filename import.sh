#!/bin/bash

set -eou pipefail

dc up -d db

mkdir -p targets/sql
mkdir -p targets/kml

for table in harris_county voting_precincts tirz; do
  shp=/data/"$table"/data.shp

  dc run --rm shp2pgsql -d $shp $table > targets/sql/"$table".sql
  cat targets/sql/"$table".sql | dc run --rm psql

  dc run --rm --entrypoint sh shptokml
  dc run --rm shptokml /data/targets/kml/"$table".kml $shp

  #dc un --rm psql "\\COPY (
done


