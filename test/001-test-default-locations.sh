#!/bin/sh

set -e

docker run -d --name postgres-default-ext planitar/postgres
test_done() { docker rm -f postgres-default-ext; exit ${1:-0}; }

sleep 3s

# Check `citext` extension availability
docker exec -t postgres-default-ext psql -U postgres -c '
  CREATE TABLE verify_citext_is_available (a citext);
' || test_done $?

# Check `hstore` extension availability
docker exec -t postgres-default-ext psql -U postgres -c '
  CREATE TABLE verify_hstore_is_available (a hstore);
' || test_done $?

# Check `plv8` extension availability
docker exec -t postgres-default-ext psql -U postgres -c '
  CREATE FUNCTION sq(a int) RETURNS int AS $$
    return a * a;
  $$ LANGUAGE plv8;
  SELECT sq(2);
' || test_done $?

test_done
