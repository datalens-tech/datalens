#!/bin/bash
# ================================================================
# DataLens Monolith Bootstrap
#
# First run:
#   1. Initialise PostgreSQL (initdb)
#   2. Create monolith_secrets table
#   3. Generate all secrets and RSA keys → INSERT into table
#   4. Create application superuser, run DB init scripts
# Every run:
#   5. Load secrets from table → export into environment
#   6. exec supervisord (inherits full env with all secrets)
# ================================================================

set -euo pipefail

exit 1

# PGDATA=/data/pgdata
# PGBIN=/usr/lib/postgresql/16/bin

log() { echo "[bootstrap] $*"; }

gen_token() { openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c "$1"; }
gen_crypto_key() { openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32 | openssl enc -base64 -A; }
gen_rsa_pair() {
    local bits=${1:-4096}
    local priv pub
    priv=$(openssl genpkey -algorithm RSA -pkeyopt "rsa_keygen_bits:${bits}" 2>/dev/null)
    pub=$(echo "$priv" | openssl rsa -pubout 2>/dev/null)
    PRIV_KEY=$(echo "$priv" | awk '{printf "%s\\n", $0}')
    PUB_KEY=$(echo "$pub" | awk '{printf "%s\\n", $0}')
}

psql_su() { gosu postgres psql "$@"; }
pg_ctl() { gosu postgres "${PGBIN}/pg_ctl" -D "${PGDATA}" "$@"; }

# ----------------------------------------------------------------
# PostgreSQL first-run initialisation
# ----------------------------------------------------------------
if [ ! -f "${PGDATA}/PG_VERSION" ]; then
    log "Initialising PostgreSQL data directory..."
    chown -R postgres:postgres "$PGDATA"
    chmod 700 "$PGDATA"

    gosu postgres "${PGBIN}/initdb" \
        -D "$PGDATA" -E UTF8 --locale=C.UTF-8 \
        --auth-host=md5 --auth-local=trust -U postgres \
        2>&1 | sed 's/^/[initdb] /'

    # Allow TCP from localhost (used by services); UNIX socket uses trust (initdb default)
    echo "host all all 127.0.0.1/32 md5" >>"${PGDATA}/pg_hba.conf"
    echo "host all all ::1/128 md5" >>"${PGDATA}/pg_hba.conf"
    sed -i "s|#listen_addresses = 'localhost'|listen_addresses = 'localhost'|" \
        "${PGDATA}/postgresql.conf"
fi

# Start postgres for secret management
chown -R postgres:postgres "$PGDATA" /run/postgresql
chmod 700 "$PGDATA"
pg_ctl start -l /tmp/pg_bootstrap.log -w -t 60 2>&1 | sed 's/^/[pg_ctl] /'

# ----------------------------------------------------------------
# Secrets table (idempotent)
# ----------------------------------------------------------------
psql_su -d postgres -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE IF NOT EXISTS public.monolith_secrets (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
REVOKE ALL ON public.monolith_secrets FROM PUBLIC;
SQL

# ----------------------------------------------------------------
# First run: generate secrets, create users, init databases
# ----------------------------------------------------------------
SECRETS_COUNT=$(psql_su -d postgres -tAc \
    "SELECT COUNT(*) FROM public.monolith_secrets")

if [ "${SECRETS_COUNT:-0}" -eq 0 ]; then
    log "First run — generating secrets..."

    _PG_PASS="${POSTGRES_PASSWORD:-$(gen_token 32)}"
    _PG_PASS_COMPENG=$(gen_token 32)
    _PG_PASS_US=$(gen_token 32)
    _PG_PASS_AUTH=$(gen_token 32)
    _PG_PASS_META=$(gen_token 32)
    _PG_PASS_TEMPORAL=$(gen_token 32)
    _PG_PASS_DEMO=$(gen_token 32)
    _ADMIN_PASS="${AUTH_ADMIN_PASSWORD:-admin}"
    _US_TOKEN=$(gen_token 32)
    _AUTH_TOKEN=$(gen_token 32)
    _CRYPTO_KEY=$(gen_crypto_key)
    _EXPORT_KEY=$(gen_token 32)

    log "  Generating RSA key pair (4096-bit)..."
    gen_rsa_pair 4096
    _AUTH_PRIV="$PRIV_KEY"
    _AUTH_PUB="$PUB_KEY"

    psql_su -d postgres -v ON_ERROR_STOP=1 <<ENDSQL
INSERT INTO public.monolith_secrets (key, value) VALUES
    ('POSTGRES_PASSWORD',              '${_PG_PASS}'),
    ('POSTGRES_PASSWORD_COMPENG',      '${_PG_PASS_COMPENG}'),
    ('POSTGRES_PASSWORD_US',           '${_PG_PASS_US}'),
    ('POSTGRES_PASSWORD_AUTH',         '${_PG_PASS_AUTH}'),
    ('POSTGRES_PASSWORD_META_MANAGER', '${_PG_PASS_META}'),
    ('POSTGRES_PASSWORD_TEMPORAL',     '${_PG_PASS_TEMPORAL}'),
    ('POSTGRES_PASSWORD_DEMO',         '${_PG_PASS_DEMO}'),
    ('AUTH_ADMIN_PASSWORD',            '${_ADMIN_PASS}'),
    ('US_MASTER_TOKEN',                '${_US_TOKEN}'),
    ('AUTH_MASTER_TOKEN',              '${_AUTH_TOKEN}'),
    ('CONTROL_API_CRYPTO_KEY',         '${_CRYPTO_KEY}'),
    ('EXPORT_DATA_VERIFICATION_KEY',   '${_EXPORT_KEY}'),
    ('AUTH_TOKEN_PRIVATE_KEY',         '${_AUTH_PRIV}'),
    ('AUTH_TOKEN_PUBLIC_KEY',          '${_AUTH_PUB}');
ENDSQL

    # Export for use by the init scripts below
    export POSTGRES_PASSWORD="${_PG_PASS}"
    export POSTGRES_PASSWORD_COMPENG="${_PG_PASS_COMPENG}"
    export POSTGRES_PASSWORD_US="${_PG_PASS_US}"
    export POSTGRES_PASSWORD_AUTH="${_PG_PASS_AUTH}"
    export POSTGRES_PASSWORD_META_MANAGER="${_PG_PASS_META}"
    export POSTGRES_PASSWORD_TEMPORAL="${_PG_PASS_TEMPORAL}"
    export POSTGRES_PASSWORD_DEMO="${_PG_PASS_DEMO}"
    export AUTH_ADMIN_PASSWORD="${_ADMIN_PASS}"
    export US_MASTER_TOKEN="${_US_TOKEN}"
    export CONTROL_API_CRYPTO_KEY="${_CRYPTO_KEY}"

    # Create the application superuser
    psql_su -d postgres -v ON_ERROR_STOP=1 <<ENDSQL
CREATE USER "${POSTGRES_USER}" WITH PASSWORD '${POSTGRES_PASSWORD}' SUPERUSER CREATEDB CREATEROLE;
ENDSQL

    # Initialise all databases via the master init script
    log "Initialising databases..."
    export INIT_DB_AUTH=1
    export INIT_DB_META_MANAGER=1
    export INIT_DB_TEMPORAL=1
    export INIT_DB_DEMO=1
    export INIT_DEMO_DATA=1
    export DEMO_DATA_SLEEP=0
    export DEMO_DATA_NAME="Demo Data"
    export US_ENDPOINT="http://localhost:8003"
    bash /init/init-postgres.sh 2>&1 | sed 's/^/[init-postgres] /' ||
        log "Warning: init-postgres.sh exited non-zero (some steps may have failed)"

    log ""
    log "==========================================="
    log " DataLens first-run credentials:"
    log "   login   : admin"
    log "   password: ${_ADMIN_PASS}"
    log "==========================================="
    log ""
fi

# ----------------------------------------------------------------
# Load all secrets from table → export for supervisord to inherit
# ----------------------------------------------------------------
log "Loading secrets from database..."
while IFS='=' read -r key value; do
    export "${key}=${value}"
done < <(psql_su -d postgres -tA \
    -c "SELECT key || '=' || value FROM public.monolith_secrets ORDER BY key")

# ----------------------------------------------------------------
# Stop bootstrap postgres — supervisord manages it from here on
# ----------------------------------------------------------------
pg_ctl stop -m fast -w 2>&1 | sed 's/^/[pg_ctl] /' || true

# Ensure correct ownership for the supervisord postgres program
chown -R postgres:postgres "$PGDATA" /run/postgresql
chmod 700 "$PGDATA"

# ----------------------------------------------------------------
# Hand off to supervisord (inherits full env including all secrets)
# ----------------------------------------------------------------
log "Starting all services via supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
