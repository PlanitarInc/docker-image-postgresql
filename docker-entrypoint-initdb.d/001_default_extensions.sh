#!/bin/bash

echo 'Creating default extensions'

gosu postgres postgres --single -jE <<EOSQL
  CREATE EXTENSION citext;
  CREATE EXTENSION pgcrypto;
  CREATE EXTENSION hstore;
  CREATE EXTENSION plv8;
  CREATE EXTENSION pg_stat_statements;
EOSQL
