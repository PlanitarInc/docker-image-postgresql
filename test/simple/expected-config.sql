CREATE ROLE simplerole WITH LOGIN;
CREATE DATABASE simple;
GRANT ALL PRIVILEGES ON DATABASE simple TO simplerole;
\c simple;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS plv8;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
