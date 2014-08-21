FROM planitar/base

RUN apt-get install -y postgresql postgresql-contrib && apt-get clean

# Default values are OK, thus keep them as is.

USER postgres

CMD ["/usr/lib/postgresql/9.3/bin/postgres", \
    "-D", "/var/lib/postgresql/9.3/main", \
    "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
