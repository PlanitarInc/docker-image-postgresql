#!/usr/bin/env bash

set -ex

grep -q "^listen_addresses = '127.0.0.1'" /etc/postgresql/9.3/main/postgresql.conf

tail -1 /etc/postgresql/9.3/main/pg_hba.conf | \
  grep -q "^host overrideall overriderole 0.0.0.0/0 trust$"

diff -u /src/original-config.yml /src/original-config.yml
diff -u <(sort /src/expected-config.yml) <(sort /src/config.yml)
diff -u /src/expected-config.sql /src/config.sql
