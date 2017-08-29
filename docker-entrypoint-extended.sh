#!/usr/bin/env bash

echo $GDATA_CREDENTIALS > /credentials.json

exec /docker-entrypoint.sh "$@"
