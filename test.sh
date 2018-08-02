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

docker exec test-postgres psql -U postgres -c '
  SELECT version() AS v;
' 2>&1 | tr '\n' '@' | \
  grep -qEe '\s*v\s*@-+@\s*PostgreSQL 9\.4\.[0-9]+\s[^@]*@\(1 row\)@'

docker exec test-postgres psql -U postgres -c '
  SELECT 1+1 AS num;
' 2>&1 | tr '\n' '@' | \
  grep -qEe '\s*num\s*@-+@\s*2\s*@\(1 row\)@'

docker run --rm --link test-postgres:postgres planitar/postgres bash -c '
  psql -h $POSTGRES_PORT_5432_TCP_ADDR -U postgres -c "SELECT 1+1 AS res";
' 2>&1 | tr '\n' '@' | \
  grep -qEe '\s*res\s*@-+@\s*2\s*@\(1 row\)@'
