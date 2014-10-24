.PHONY: test

test: test-default-values
	make -C simple test
	make -C override-all test

test-default-values:
	docker run -ti --rm planitar/postgresql /bin/bash -lc ' \
	  set -ex; \
	  grep -q "^#listen_addresses = '"'"'localhost'"'"'" \
	    /etc/postgresql/9.3/main/postgresql.conf; \
	  ! grep -q "^host .* 0.0.0.0/0" /etc/postgresql/9.3/main/pg_hba.conf; \
	  ls -l /src/default-config.yml /src/apply_config.py; \
	'
