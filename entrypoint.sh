#!/usr/bin/env bash

if [ -e tmp/pids/server.pid ]; then
   rm tmp/pids/server.pid
fi

exec "$@"
