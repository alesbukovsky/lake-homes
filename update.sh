#!/bin/sh
if [ -z "$1" ]; then
    echo "ERROR: file to process not specified"
    exit 1
fi

source ./_lib.sh

DT="${1#*-}"
DT="${DT%%.*}"
DT="20${DT:0:2}-${DT:2:2}-${DT:4:2}"  

_sql -c "INSERT INTO metas (key, value) VALUES ('last_update', '$DT') ON CONFLICT(key) DO UPDATE SET value = EXCLUDED.value"
_sql -c 'TRUNCATE uploads'
_sql -c "\copy uploads(mls, address, price, status, link, thumbnail) from '$1' delimiter '|' CSV"
_sql -f ./src/main/sql/update.sql
_sql -f ./src/main/sql/stats.sql
