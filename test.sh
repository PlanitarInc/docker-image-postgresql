#!/bin/sh

set -ex

docker run -d --name test-postgres planitar/postgres
test_done() { docker rm -f test-postgres; exit ${1:-0}; }

sleep 3s

docker exec -t test-postgres psql -U postgres -c '
  SELECT 1+1;
' || test_done $?

docker run -t --rm --link test-postgres:postgres planitar/postgres bash -c '
  psql -h $POSTGRES_PORT_5432_TCP_ADDR -U postgres -c "SELECT 1+1";
' || test_done $?

test_done
