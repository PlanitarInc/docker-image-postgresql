FROM planitar/base

RUN apt-get install -y postgresql postgresql-contrib postgresql-9.3-plv8 && \
    apt-get -y clean

ADD default-config.yml /src/default-config.yml
ADD apply_config.py /src/apply_config.py

# Any "child" image should provide a `config.yml` file
ONBUILD ADD ./config.yml /src/image-config.yml
ONBUILD RUN /src/apply_config.py /src/default-config.yml /src/image-config.yml
ONBUILD RUN chown postgres:postgres /src/config.yml /src/config.sql
ONBUILD RUN service postgresql start && \
	    su postgres -c "psql -f /src/config.sql" && \
	    service postgresql stop
ONBUILD USER postgres

EXPOSE 5432

CMD ["/usr/lib/postgresql/9.3/bin/postgres", \
    "-D", "/var/lib/postgresql/9.3/main", \
    "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
