#!/usr/bin/env bash

cat > /tmp/test-plv8.sql <<EOF
CREATE FUNCTION sq(a int) RETURNS int AS \$$
  return a * a;
\$$ LANGUAGE plv8;
SELECT sq(2);
EOF

# Accessing through loopback interface requires a password, hence...
WAN_ADDR=$(ifconfig eth0 | sed -n 's/^ *inet addr:\([0-9.]*\).*$/\1/p')

psql -d exts -U exts_role -h $WAN_ADDR -f /tmp/test-plv8.sql
