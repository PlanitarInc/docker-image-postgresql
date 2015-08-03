FROM planitar/base

# Based on https://github.com/docker-library/postgres

ENV PG_MAJOR 9.4

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
      apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' $PG_MAJOR \
      >/etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y libkrb5-3 --reinstall && \
    apt-get install -y postgresql-common && \
    sed -ri 's/#(create_main_cluster) .*$/\1 = false/' \
      /etc/postgresql-common/createcluster.conf && \
    apt-get install -y postgresql-$PG_MAJOR \
      postgresql-contrib-$PG_MAJOR \
      postgresql-$PG_MAJOR-plv8 && \
    apt-get clean

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /dbdata/postgres

COPY entry.sh /opt/docker-entrypoint/entry.sh

ENTRYPOINT ["/opt/docker-entrypoint/entry.sh"]

EXPOSE 5432
CMD ["postgres"]
