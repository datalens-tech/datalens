# ================================================================
# DataLens Monolith Image
# All DataLens services in a single container managed by supervisord
#
# Services and internal ports:
#   PostgreSQL    : 5432
#   Temporal      : 7233
#   control-api   : 8001  (Python/uWSGI)
#   data-api      : 8002  (Python/Gunicorn+aiohttp)
#   us            : 8003  (Node.js)
#   auth          : 8004  (Node.js)
#   meta-manager  : 8005  (Node.js)
#   ui-api        : 8006  (Node.js, APP_MODE=api)
#   ui node       : 3030  (Node.js, APP_MODE=full)
#   nginx (ui)    : 8080  -> exposed externally
# ================================================================
ARG REGISTRY=ghcr.io/datalens-tech

ARG POSTGRES_VERSION=16
ARG TEMPORAL_VERSION=1.27.2

ARG UI_VERSION=0.0.0
ARG US_VERSION=0.0.0
ARG BACKEND_VERSION=0.0.0
ARG AUTH_VERSION=0.0.0
ARG META_MANAGER_VERSION=0.0.0

# ----------------------------------------------------------------
# Source stages — pull each service image for COPY access
# ----------------------------------------------------------------
FROM ${REGISTRY}/datalens-temporal:${TEMPORAL_VERSION}           AS temporal-src

FROM ${REGISTRY}/datalens-control-api:${BACKEND_VERSION}         AS control-api-src
FROM ${REGISTRY}/datalens-data-api:${BACKEND_VERSION}            AS data-api-src
FROM ${REGISTRY}/datalens-us:${US_VERSION}                       AS us-src
FROM ${REGISTRY}/datalens-auth:${AUTH_VERSION}                   AS auth-src
FROM ${REGISTRY}/datalens-meta-manager:${META_MANAGER_VERSION}   AS meta-manager-src
FROM ${REGISTRY}/datalens-ui:${UI_VERSION}                       AS ui-src

# ----------------------------------------------------------------
# Main monolith image
# NOTE: must stay ubuntu:24.04 — Python 3.10 (required by control-api
# and data-api venvs) is only available on Ubuntu via deadsnakes PPA.
# datalens-postgres:16 is Debian trixie (Python 3.13) and cannot be
# used as the base for this reason.
# ----------------------------------------------------------------
FROM ${REGISTRY}/datalens-postgres:${POSTGRES_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# timezone
ENV TZ=Etc/UTC
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    openssl \
    supervisor \
    nginx \
    gosu \
    locales \
    # python deps
    libpcre2-8-0 \
    libpq5 \
    unixodbc \
    libtcmalloc-minimal4 \
    # other
    procps \
    psmisc

# locales
RUN apt-get install -y locales && locale-gen en_US.UTF-8

# mssql libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    libct4 libsybdb5 tdsodbc

# RUN add-apt-repository ppa:deadsnakes/ppa && \
#     apt-get update && apt-get install -y --no-install-recommends \
#     python3.10 \
#     python3.10-dev \
#     python3.10-distutils \
#     && rm -rf /var/lib/apt/lists/*

# System python3 with cryptography (needed by /init/crypto.py used during DB seeding)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-cryptography

# python3.10 for venvs; system python3 for scripts that call `python`
# RUN update-alternatives --install /usr/bin/python3.10 python3.10 /usr/bin/python3.10 1 2>/dev/null || true && \
#     ln -sf /usr/bin/python3 /usr/bin/python

# Node.js 22
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] \
    https://deb.nodesource.com/node_24.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Configure ODBC for MSSQL
RUN if [ -f /usr/share/tdsodbc/odbcinst.ini ]; then \
    cat /usr/share/tdsodbc/odbcinst.ini >> /etc/odbcinst.ini; \
    fi

# ================================================================
# Static non-secret environment variables
# Shared across all services — secrets are generated at first run
# and stored in the monolith_secrets PostgreSQL table.
# ================================================================
ENV PGDATA='/data'

ENV POSTGRES_HOST='localhost'
ENV POSTGRES_PORT='5432'

ENV POSTGRES_USER_COMPENG='pg-compeng-user'
ENV POSTGRES_USER_US='pg-us-user'
ENV POSTGRES_USER_AUTH='pg-auth-user'
ENV POSTGRES_USER_META_MANAGER='pg-meta-manager-user'
ENV POSTGRES_USER_TEMPORAL='pg-temporal-user'
ENV POSTGRES_USER_DEMO='pg-demo-user'

ENV TEMPORAL_PORT=7233
ENV DB=postgres12
ENV NUM_HISTORY_SHARDS=512
ENV DEFAULT_NAMESPACE_RETENTION=24h
ENV NAMESPACES=meta-manager
ENV RELEASE_VERSION=2.7.0
ENV APP_INSTALLATION=opensource

# ================================================================
# Python services
# ================================================================

# --- control-api ---
COPY --from=control-api-src /venv /opt/services/control-api/venv
COPY --from=control-api-src /code /opt/services/control-api/code
COPY --from=control-api-src /etc/backend-configs /opt/services/control-api/etc/backend-configs

RUN grep -rl '^#!/venv/' /opt/services/control-api/venv/bin/ 2>/dev/null \
    | xargs -r sed -i 's|^#!/venv/|#!/opt/services/control-api/venv/|g' && \
    sed -i 's|^home = .*|home = /usr/bin|' \
    /opt/services/control-api/venv/pyvenv.cfg 2>/dev/null || true

# --- data-api ---
COPY --from=data-api-src /venv /opt/services/data-api/venv
COPY --from=data-api-src /code /opt/services/data-api/code
COPY --from=data-api-src /etc/backend-configs /opt/services/data-api/etc/backend-configs

RUN grep -rl '^#!/venv/' /opt/services/data-api/venv/bin/ 2>/dev/null \
    | xargs -r sed -i 's|^#!/venv/|#!/opt/services/data-api/venv/|g' && \
    sed -i 's|^home = .*|home = /usr/bin|' \
    /opt/services/data-api/venv/pyvenv.cfg 2>/dev/null || true

# ================================================================
# Node.js services
# ================================================================
COPY --from=us-src           /opt/app /opt/services/us
COPY --from=auth-src         /opt/app /opt/services/auth
COPY --from=meta-manager-src /opt/app /opt/services/meta-manager
COPY --from=ui-src           /opt/app /opt/services/ui

# ================================================================
# nginx — config from UI service, root patched to monolith path
# ================================================================
COPY --from=ui-src /etc/nginx /etc/nginx

RUN sed -i 's|root /opt/app/dist/public|root /opt/services/ui/dist/public|' \
    /etc/nginx/nginx.conf 2>/dev/null || true && \
    rm -f /etc/nginx/sites-enabled/default /etc/nginx/conf.d/default.conf 2>/dev/null || true

# ================================================================
# Temporal — all files from datalens-temporal image
# (Alpine static Go binaries run fine on Ubuntu)
# ================================================================
COPY --from=temporal-src /etc/temporal                       /etc/temporal
COPY --from=temporal-src /usr/local/bin/temporal-server      /usr/local/bin/temporal-server
COPY --from=temporal-src /usr/local/bin/temporal-sql-tool    /usr/local/bin/temporal-sql-tool
COPY --from=temporal-src /usr/local/bin/dockerize            /usr/local/bin/dockerize

# ================================================================
# Entry point
# ================================================================
COPY bootstrap.sh     /bootstrap.sh
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chmod +x /bootstrap.sh && \
    rm -f /etc/supervisor/conf.d/*.conf 2>/dev/null || true

EXPOSE 8080

VOLUME ["/data"]

ENTRYPOINT ["/bootstrap.sh"]
