#!/bin/bash

source .env

if [ $# -eq 0 ]; then
    >&2 echo "Arguments: [agency database to remove]"
    exit 1
fi

psql -d "$DB" -h "$DB_HOST" -U ott -c "drop database $1;"
