#!/bin/sh

set -e

cleanup() {
  docker rm -f test-postgres
}
report() {
  docker logs test-postgres
  echo "Test failed..."
}
trap report ERR
trap cleanup EXIT


docker run -d --name test-postgres -v /dbdata/postgres planitar/postgres

sleep 3s

docker exec -t test-postgres psql -U postgres -c '
  SELECT 1+1;
'

docker run -t --rm --link test-postgres:postgres planitar/postgres bash -c '
  psql -h $POSTGRES_PORT_5432_TCP_ADDR -U postgres -c "SELECT 1+1";
'
