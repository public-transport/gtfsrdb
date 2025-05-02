#!/bin/bash

source .env

# Start from the directory where the script is located
PROJECT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

# Search for README.md by moving up the directory tree
while [ ! -f "$PROJECT_DIR/README.md" ] && [ "$PROJECT_DIR" != "/" ]; do
    PROJECT_DIR="$(dirname "$PROJECT_DIR")"
done

# If we reach the root without finding README.md, set PROJECT_DIR to the original directory
if [ "$PROJECT_DIR" = "/" ]; then
    PROJECT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
fi

if [ $# -eq 0 ]; then
    >&2 echo "Arguments: [agency] [[-t <trip feed url>] [-p <vehicle/position feed url>] [-a <alerts feed url>]] | \
    [-I <path to txt file with gtfs feeds, one per line>]] [optional arguments for gtfsrdb]"
    exit 1
fi

DB_NAME="$1"
shift

if [[ "$1" == "-I" ]]; then
  gtfsrdb_args=$(cat "$2")
  shift 2
  optional_args=$*
else
  gtfsrdb_args=$*
  optional_args=''
fi

echo "select 'create database $DB_NAME' where not exists (select from pg_database where datname = '$DB_NAME')\gexec" | \
  psql -d "$DB" -h "$DB_HOST" -U "$DB_USER"

if ! [ $? -eq 0 ]; then
  >&2 echo "PostgreSQL command failed. Check values in env.sh for accuracy and ensure that PostgreSQL server is \
  running and accepting connections."
  exit 2
fi

# Uncomment to debug commands sent to gtfsrdb.py.
# set -x
cd "$PROJECT_DIR" || exit 3
gtfsrdb -d postgresql+psycopg2://"$DB_USER":"$DB_PASS"@"$DB_HOST"/"$DB_NAME" -c $gtfsrdb_args $optional_args