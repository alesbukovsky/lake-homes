#!/bin/sh
source ./_lib.sh

export OUT="$(pwd)/data/data.json"
rm -f $OUT

_sql -c "\copy (SELECT JSON_BUILD_OBJECT('asOf', (SELECT value FROM metas WHERE key = 'last_update'), 'homes', (SELECT ARRAY_AGG(h) FROM (SELECT * FROM homes ORDER BY price ASC) as h))) to '$OUT'"

scp $OUT $PI_USER@$PI_HOST:$PI_WWW
cp $OUT ./src/main/web