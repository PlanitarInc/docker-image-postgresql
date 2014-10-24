FROM planitar/postgresql

ADD ./config.yml /src/original-config.yml
ADD ./expected-config.yml /src/expected-config.yml
ADD ./expected-config.sql /src/expected-config.sql
ADD ./test.sh /src/

CMD /src/test.sh
