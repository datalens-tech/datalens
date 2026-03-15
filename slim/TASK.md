# DataLens Monolith — Task Specification

## What needs to be rebuilt (all 4 files in ./monolith/)

---

## Discovered facts

### Base image decision
`ghcr.io/datalens-tech/datalens-postgres:16` is **Debian trixie** (Python 3.13).
control-api and data-api venvs require **Python 3.10** (installed via deadsnakes PPA, Ubuntu-only).
Therefore `ubuntu:24.04` remains the runtime base.
`datalens-postgres:16` is used as a build stage only — to copy `/init/*.sh` and `init-postgres.sh`.
Already has: bash, curl, postgresql-client, python3, crypto.py, all /init/*.sh scripts.

### Temporal (./temporal/dockerfile)
```
FROM temporalio/auto-setup:1.27.2 AS temporal-setup
FROM temporalio/server:1.27.2          ← Alpine base
```
- Alpine: `apk add postgresql-client openssl`
- Binary: `/usr/local/bin/temporal-server` (from temporalio/server)
- Also needs: `/usr/local/bin/temporal-sql-tool` (from temporalio/auto-setup)
- Also needs: `dockerize` (from temporalio/server)
- Schemas: `/etc/temporal/schema/temporal/` and `/etc/temporal/schema/visibility/`
- Entrypoint: `/etc/temporal/init-temporal.sh`
- Local scripts in ./temporal/:
  - init-temporal.sh      ← main entrypoint
  - setup-temporal.sh     ← runs temporal-sql-tool to setup DB schema
  - setup-auth-jwks.sh    ← builds JWKS JSON from RSA public key, serves it via nc on :8080
  - init-namespaces.sh    ← creates temporal namespaces
  - healthcheck.sh        ← checks pg + temporal cluster health

Key env vars temporal needs:
```
POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD
POSTGRES_DB=pg-temporal-db
POSTGRES_DB_VISIBILITY=pg-temporal-visibility-db
POSTGRES_TLS_ENABLED=false
TEMPORAL_AUTH_ENABLED=true
TEMPORAL_AUTH_PUBLIC_KEY=...  (RSA public, \n-escaped)
TEMPORAL_AUTH_PRIVATE_KEY=... (RSA private, \n-escaped)
NAMESPACES=meta-manager
DB=postgres12
NUM_HISTORY_SHARDS=512
DEFAULT_NAMESPACE_RETENTION=24h
TEMPORAL_PORT=7233
```
init-temporal.sh internally sets: POSTGRES_SEEDS, DB_PORT, DBNAME, VISIBILITY_DBNAME,
POSTGRES_PWD, SQL_PLUGIN, SQL_HOST/PORT/USER/PASSWORD, BIND_ON_IP, TEMPORAL_ADDRESS.
It runs: setup-temporal.sh → start-temporal.sh (background) → init-namespaces.sh → kill temp server
Then (if auth enabled): setup-auth-jwks.sh → nc loop on :8080 (serves JWKS)
Then re-templates config and exec start-temporal.sh.
IMPORTANT: nc serves JWKS on port 8080 inside the monolith — must NOT conflict with nginx:8080.
Solution: temporal should use a different JWKS port, e.g. 18080. Override TEMPORAL_JWT_KEY_SOURCE1.

### Postgres init scripts (./postgres/)
`/docker-entrypoint-initdb.d/init-postgres.sh` calls in order:
1. Creates pg-compeng-db (owner: POSTGRES_USER_COMPENG)
2. Creates pg-us-db (owner: POSTGRES_USER_US)
3. Calls /init/init-db-auth.sh      → creates pg-auth-db
4. Calls /init/init-db-meta-manager.sh → creates pg-meta-manager-db
5. Calls /init/init-db-temporal.sh  → creates pg-temporal-db + pg-temporal-visibility-db
6. Calls /init/init-db-demo.sh      → creates pg-demo-db
7. Calls /init/seed-demo-data.sh &  (background, waits for US endpoint)

Per-service user/password env vars supported by init scripts:
```
POSTGRES_USER_COMPENG    / POSTGRES_PASSWORD_COMPENG
POSTGRES_USER_US         / POSTGRES_PASSWORD_US
POSTGRES_USER_AUTH       / POSTGRES_PASSWORD_AUTH
POSTGRES_USER_META_MANAGER / POSTGRES_PASSWORD_META_MANAGER
POSTGRES_USER_TEMPORAL   / POSTGRES_PASSWORD_TEMPORAL
POSTGRES_USER_DEMO       / POSTGRES_PASSWORD_DEMO
```
Each init script: if POSTGRES_USER_X != POSTGRES_USER → CREATE USER X WITH PASSWORD '...'
then CREATE DATABASE X WITH OWNER X.

### Secrets storage — PostgreSQL table
Instead of /data/secrets.env, store secrets in a table only readable by postgres superuser:
```sql
CREATE TABLE IF NOT EXISTS public.monolith_secrets (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
REVOKE ALL ON public.monolith_secrets FROM PUBLIC;
```
On first run: generate secrets → INSERT into table.
On subsequent runs: SELECT from table → export as env vars.
Access via: `psql -U postgres -d postgres -t -A -c "SELECT value FROM monolith_secrets WHERE key='X'"`

### Internal port mapping
```
PostgreSQL        5432   (managed by supervisord, process: postgres)
Temporal          7233   (process: temporal)
Temporal JWKS     18080  (nc loop inside temporal process, overriding default 8080)
control-api       8001   (Python uWSGI)
data-api          8002   (Python Gunicorn+aiohttp)
us                8003   (Node.js)
auth              8004   (Node.js)
meta-manager      8005   (Node.js)
ui-api            8006   (Node.js, APP_MODE=api)
ui node           3030   (Node.js, APP_MODE=full)
nginx             8080   (exposed externally → proxies to :3030)
```

### Python service details
Base runtime: Ubuntu 24.04, Python 3.10 (from deadsnakes).
control-api:
  - venv at /venv in source image → COPY to /opt/services/control-api/venv
  - code at /code → COPY to /opt/services/control-api/code
  - config at /etc/backend-configs → COPY to /opt/services/control-api/etc/backend-configs
  - start: uwsgi --ini /opt/services/control-api/code/app/uwsgi/uwsgi-dl-api.ini (with overrides)
  - env: HTTP_BIND_PORT=8001, BI_API_UWSGI_WORKERS_COUNT=4, CONFIG_PATH=...
data-api:
  - same layout, port 8002
  - start: python -m gunicorn dl_data_api.app:create_gunicorn_app --bind 0.0.0.0:8002

### Node.js service details
All use: /opt/app in source image → COPY to /opt/services/{name}
Entrypoint in source images: /opt/app/scripts/preflight.sh (waits for DB, runs migrations, exec node dist/run)
In monolith, run: cd /opt/services/{name} && ./scripts/preflight.sh
APP_PORT must be set per-service to override default 8080.

nginx config from ui-src:
  - root /opt/app/dist/public → patch to /opt/services/ui/dist/public
  - proxies to localhost:3030 (ui node)
  - No routing to backend services (that's done by node process via env vars)

---

## What to change vs current files

### Dockerfile changes
1. Base image: `FROM ghcr.io/datalens-tech/datalens-postgres:16` (not ubuntu)
2. Temporal: build FROM the local ./temporal/dockerfile approach:
   - FROM temporalio/auto-setup:1.27.2 AS temporal-setup-src
   - FROM temporalio/server:1.27.2 AS temporal-src  (Alpine-based)
   - COPY binaries + schemas into main image
   - COPY local ./temporal/*.sh to /etc/temporal/
3. No need to copy postgres init scripts — they're already in the base image
4. All non-secret ENV constants go into Dockerfile
5. Temporal JWKS port: override TEMPORAL_JWT_KEY_SOURCE1 to use port 18080

Non-secret ENV constants for Dockerfile:
```
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=pg-user
POSTGRES_DB_COMPENG=pg-compeng-db
POSTGRES_DB_AUTH=pg-auth-db
POSTGRES_DB_US=pg-us-db
POSTGRES_DB_DEMO=pg-demo-db
POSTGRES_DB_META_MANAGER=pg-meta-manager-db
POSTGRES_DB_TEMPORAL=pg-temporal-db
POSTGRES_DB_TEMPORAL_VISIBILITY=pg-temporal-visibility-db
POSTGRES_USER_COMPENG=pg-compeng-user
POSTGRES_USER_US=pg-us-user
POSTGRES_USER_AUTH=pg-auth-user
POSTGRES_USER_META_MANAGER=pg-meta-manager-user
POSTGRES_USER_TEMPORAL=pg-temporal-user
POSTGRES_USER_DEMO=pg-demo-user
TEMPORAL_PORT=7233
DB=postgres12
NUM_HISTORY_SHARDS=512
DEFAULT_NAMESPACE_RETENTION=24h
NAMESPACES=meta-manager
TEMPORAL_JWT_KEY_SOURCE1=http://localhost:18080/.well-known/jwks.json
RELEASE_VERSION=2.7.0
APP_INSTALLATION=opensource
```

Non-secret ENV constants for supervisord.conf (environment= per program):
- control-api: DL_CRY_ACTUAL_KEY_ID=KEY, RQE_FORCE_OFF=1, BI_API_UWSGI_WORKERS_COUNT=4, AUTH__TYPE=NATIVE, AUTH__JWT_ALGORITHM=PS256, CONNECTOR_AVAILABILITY_VISIBLE=...
- data-api: same DL_CRY, RQE, GUNICORN_WORKERS_COUNT=5, CACHES_ON=0, MUTATIONS_CACHES_ON=0, BI_COMPENG_PG_ON=1, AUTH__TYPE, AUTH__JWT_ALGORITHM
- us: APP_PORT=8003, APP_ENV=prod, SKIP_INSTALL_DB_EXTENSIONS=1, USE_DEMO_DATA=0, AUTH_ENABLED=true
- auth: APP_PORT=8004, APP_ENV=prod, SKIP_INSTALL_DB_EXTENSIONS=1, DISABLE_WILDCARD_COOKIE=true
- meta-manager: APP_PORT=8005, APP_ENV=prod, TEMPORAL_AUTH_ENABLED=true, TEMPORAL_ENDPOINT=localhost:7233
- ui-api: APP_PORT=8006, APP_MODE=api, APP_ENV=production
- ui: APP_PORT=3030, APP_MODE=full, APP_ENV=production, AUTH_POLICY=disabled, HC=0, YANDEX_MAP_ENABLED=0, EXPORT_WORKBOOK_ENABLED=true, AUTH_ENABLED=true, AUTH_SIGNUP_DISABLED=false

### bootstrap.sh changes
Goal: minimal and clean.
1. Wait for postgres to be ready
2. Check if secrets table exists → first run if not
3. First run only:
   a. POSTGRES_PASSWORD: from env or generate
   b. AUTH_ADMIN_PASSWORD: from env or "admin"
   c. Generate all other secrets
   d. INSERT all into monolith_secrets table
4. Load all secrets: export $(psql ... SELECT key || '=' || value FROM monolith_secrets)
5. exec supervisord
No wrapper script generation — move that logic to supervisord environment= directives.

### supervisord.conf changes
- Use `environment=` in each [program:] to pass non-secret static vars
- Secret vars injected by bootstrap.sh via export before exec supervisord (supervisord inherits env)
- postgres program must run as postgres user: `user=postgres`
- temporal program needs BIND_ON_IP=127.0.0.1 to stay on localhost

---

## Secrets to generate (all go into monolith_secrets table)

```
POSTGRES_PASSWORD           (from external env or generate 32-char)
POSTGRES_PASSWORD_COMPENG   (generate 32-char)
POSTGRES_PASSWORD_US        (generate 32-char)
POSTGRES_PASSWORD_AUTH      (generate 32-char)
POSTGRES_PASSWORD_META_MANAGER (generate 32-char)
POSTGRES_PASSWORD_TEMPORAL  (generate 32-char)
POSTGRES_PASSWORD_DEMO      (generate 32-char)
AUTH_ADMIN_PASSWORD         (from external env or "admin")
US_MASTER_TOKEN             (generate 32-char)
AUTH_MASTER_TOKEN           (generate 32-char)
CONTROL_API_CRYPTO_KEY      (generate base64 32-char then base64-encode)
EXPORT_DATA_VERIFICATION_KEY (generate 32-char)
TEMPORAL_AUTH_PRIVATE_KEY   (RSA 4096, \n-escaped)
TEMPORAL_AUTH_PUBLIC_KEY    (RSA 4096, \n-escaped)
AUTH_TOKEN_PRIVATE_KEY      (RSA 4096, \n-escaped)
AUTH_TOKEN_PUBLIC_KEY       (RSA 4096, \n-escaped)
```

---

## Service dependency env vars (all use localhost)

```
control-api:
  US_HOST=http://localhost:8003
  DL_CRY_KEY_VAL_ID_KEY=<CONTROL_API_CRYPTO_KEY>
  AUTH__JWT_KEY=<AUTH_TOKEN_PUBLIC_KEY>

data-api:
  US_HOST=http://localhost:8003
  BI_COMPENG_PG_URL=postgres://pg-compeng-user:<PW>@localhost:5432/pg-compeng-db
  DL_CRY_KEY_VAL_ID_KEY=<CONTROL_API_CRYPTO_KEY>
  AUTH__JWT_KEY=<AUTH_TOKEN_PUBLIC_KEY>

us:
  MASTER_TOKEN=<US_MASTER_TOKEN>
  AUTH_MASTER_TOKEN=<AUTH_MASTER_TOKEN>
  AUTH_ENDPOINT=http://localhost:8004
  POSTGRES_DSN_LIST=postgres://pg-us-user:<PW>@localhost:5432/pg-us-db
  AUTH_TOKEN_PUBLIC_KEY=<AUTH_TOKEN_PUBLIC_KEY>

auth:
  MASTER_TOKEN=<AUTH_MASTER_TOKEN>
  US_MASTER_TOKEN=<US_MASTER_TOKEN>
  POSTGRES_DSN_LIST=postgres://pg-auth-user:<PW>@localhost:5432/pg-auth-db
  TOKEN_PRIVATE_KEY=<AUTH_TOKEN_PRIVATE_KEY>
  TOKEN_PUBLIC_KEY=<AUTH_TOKEN_PUBLIC_KEY>
  AUTH_ADMIN_PASSWORD=<AUTH_ADMIN_PASSWORD>

meta-manager:
  US_MASTER_TOKEN=<US_MASTER_TOKEN>
  EXPORT_DATA_VERIFICATION_KEY=<EXPORT_DATA_VERIFICATION_KEY>
  POSTGRES_DSN_LIST=postgres://pg-meta-manager-user:<PW>@localhost:5432/pg-meta-manager-db
  US_ENDPOINT=http://localhost:8003
  UI_API_ENDPOINT=http://localhost:8006
  TEMPORAL_AUTH_PRIVATE_KEY=<TEMPORAL_AUTH_PRIVATE_KEY>
  AUTH_TOKEN_PUBLIC_KEY=<AUTH_TOKEN_PUBLIC_KEY>

ui-api:
  US_ENDPOINT=http://localhost:8003
  BI_API_ENDPOINT=http://localhost:8001
  US_MASTER_TOKEN=<US_MASTER_TOKEN>

ui:
  US_ENDPOINT=http://localhost:8003
  AUTH_ENDPOINT=http://localhost:8004
  BI_API_ENDPOINT=http://localhost:8001
  BI_DATA_ENDPOINT=http://localhost:8002
  META_MANAGER_ENDPOINT=http://localhost:8005
  US_MASTER_TOKEN=<US_MASTER_TOKEN>
  AUTH_MASTER_TOKEN=<AUTH_MASTER_TOKEN>
  AUTH_TOKEN_PUBLIC_KEY=<AUTH_TOKEN_PUBLIC_KEY>
  RELEASE_VERSION=2.7.0

temporal:
  POSTGRES_PASSWORD=<POSTGRES_PASSWORD>   (or per-service POSTGRES_PASSWORD_TEMPORAL)
  TEMPORAL_AUTH_PUBLIC_KEY=<TEMPORAL_AUTH_PUBLIC_KEY>
  TEMPORAL_AUTH_PRIVATE_KEY=<TEMPORAL_AUTH_PRIVATE_KEY>
```
