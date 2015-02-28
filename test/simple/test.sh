#!/usr/bin/env bash

set -ex

grep -q "^listen_addresses = '*'" /etc/postgresql/9.3/main/postgresql.conf

tail -1 /etc/postgresql/9.3/main/pg_hba.conf | \
  grep -q "^host simple simplerole 0.0.0.0/0 trust$"

diff -u <(sort /src/expected-config.yml) <(sort /src/config.yml)
diff -u <(sort /src/expected-config.sql) <(sort /src/config.sql)
