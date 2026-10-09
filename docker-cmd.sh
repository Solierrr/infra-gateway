#!/bin/sh
set -eu

listen="0.0.0.0:8000"
port="${PORT:-10000}"
if [ "$port" != "8000" ]; then
  listen="$listen, 0.0.0.0:$port"
fi

KONG_PROXY_LISTEN="$listen"
export KONG_PROXY_LISTEN
exec /docker-entrypoint.sh kong docker-start
