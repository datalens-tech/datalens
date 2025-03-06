#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

echo "Prepare database..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_COMPENG}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_AUTH}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
  CREATE DATABASE "${POSTGRES_DB_US}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

if [ "${INIT_DEMO_DATA}" == "1" ] || [ "${INIT_DEMO_DATA}" == "true" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE "${POSTGRES_DB_DEMO}" WITH OWNER "${POSTGRES_USER}" ENCODING 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
EOSQL

  psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_DEMO}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
fi

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_COMPENG}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_AUTH}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL

psql -v ON_ERROR_STOP=1 -d "${POSTGRES_DB_US}" --username "${POSTGRES_USER}" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS btree_gin;
  CREATE EXTENSION IF NOT EXISTS btree_gist;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL
