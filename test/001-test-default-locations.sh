#!/bin/sh

docker run -d --name postgres-default-ext planitar/postgres

sleep 3s

docker exec -t postgres-default-ext psql -U postgres -c '
  CREATE FUNCTION sq(a int) RETURNS int AS $$
    return a * a;
  $$ LANGUAGE plv8;
  SELECT sq(2);
'
res=$?

docker rm -f postgres-default-ext

test "$res" -eq 0
