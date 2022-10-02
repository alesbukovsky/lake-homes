#!/bin/sh
if [ -z "$1" ]
then
    echo "ERROR: file to process not specified"
    exit 1
fi

source ./env.sh

DT="${1#*-}"
DT="${DT%%.*}"
DT="20${DT:0:2}-${DT:2:2}-${DT:4:2}"  

psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -c "INSERT INTO metas (key, value) VALUES ('last_update', '$DT') ON CONFLICT(key) DO UPDATE SET value = EXCLUDED.value"
psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -c 'TRUNCATE uploads'
psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -c "\copy uploads(mls, address, price, status, link, thumbnail) from '$1' delimiter '|' CSV"
psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -f ./src/main/sql/update.sql
psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER -f ./src/main/sql/stats.sql
