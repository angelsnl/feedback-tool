#!/bin/sh
set -e

DATA="$(cd "$(dirname "$0")" && pwd)/data"

if [ ! -d "$DATA" ]; then
    mkdir -p "$DATA"
    initdb -D "$DATA" --no-locale --encoding=UTF8 --username=postgres
fi

exec postgres -D "$DATA"
