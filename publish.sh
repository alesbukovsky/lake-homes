#!/bin/sh
source ./env.sh

export OUT="$(pwd)/data/data.json"
rm -f $OUT

psql -h $DB_HOST -p $DB_PORT -d $DB_SCHEMA -U $DB_USER \
    -c "\copy (SELECT JSON_BUILD_OBJECT('asOf', (SELECT value FROM metas WHERE key = 'last_update'), 'houses', (SELECT ARRAY_AGG(h) FROM (SELECT * FROM houses ORDER BY price ASC) as h))) to '$OUT'"

scp $OUT $PI_USER@$PI_HOST:$PI_WWW
