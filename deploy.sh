#!/bin/sh
source ./_lib.sh

export SRC="$(pwd)/src/main/web"

scp $SRC/*.css $PI_USER@$PI_HOST:$PI_WWW
scp $SRC/*.html $PI_USER@$PI_HOST:$PI_WWW
