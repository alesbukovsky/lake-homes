#!/bin/sh
set -e

docker-compose up -d

./scrape.sh
./update.sh
./publish.sh
