# DataLens &middot; [![Release](https://img.shields.io/github/v/release/datalens-tech/datalens?logo=github&color=orange)](https://github.com/datalens-tech/datalens/releases) [![last commit](https://img.shields.io/github/last-commit/datalens-tech/datalens?logo=github)](https://github.com/datalens-tech/datalens/commits/main)

[![datalens-ui](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fdatalens-tech%2Fdatalens%2Fraw%2Fmain%2Fversions-config.json&query=%24.uiVersion&label=ui%20version)](https://github.com/datalens-tech/datalens-ui)
[![datalens-us](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fdatalens-tech%2Fdatalens%2Fraw%2Fmain%2Fversions-config.json&query=%24.usVersion&label=us%20version)](https://github.com/datalens-tech/datalens-us)
[![datalens-backend](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fdatalens-tech%2Fdatalens%2Fraw%2Fmain%2Fversions-config.json&query=%24.backendVersion&label=backend%20version)](https://github.com/datalens-tech/datalens-backend)
[![datalens-auth](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fdatalens-tech%2Fdatalens%2Fraw%2Fmain%2Fversions-config.json&query=%24.authVersion&label=auth%20version)](https://github.com/datalens-tech/datalens-auth)
[![datalens-meta-manager](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Fdatalens-tech%2Fdatalens%2Fraw%2Fmain%2Fversions-config.json&query=%24.metaManagerVersion&label=meta-manager%20version)](https://github.com/datalens-tech/datalens-meta-manager)



[**DataLens**](https://datalens.tech) is a modern business intelligence and data visualization system. It was developed and extensively used as a primary BI tool in Yandex and is also available as a part of [Yandex Cloud](https://datalens.yandex.com) platform. See also [our roadmap](https://github.com/orgs/datalens-tech/projects/1), [releases notes](https://github.com/datalens-tech/datalens/releases) and [community in telegram](https://t.me/YandexDataLens).

## Getting started

### Installing Docker

DataLens requires Docker to be installed. Follow these instructions depending on the platform you use:

- [macOS](https://docs.docker.com/desktop/install/mac-install/)
- [Linux](https://docs.docker.com/engine/install/)
- [Windows](https://docs.docker.com/desktop/install/windows-install/)

**Note about Docker Compose:**

- The new Docker Compose plugin is available as the `docker-compose-v2` package on Ubuntu 20.04/22.04/24.04 from the base APT repository.

- The minimal supported version of the legacy docker-compose utility (as a separate package) is `1.29.0`. It is included in the base APT repository as the `docker-compose` package only on Ubuntu 22.04.

### Running containers

Clone repository:

```bash
git clone https://github.com/datalens-tech/datalens && cd datalens
```

For the quick start use the following command to start DataLens containers:

```bash
HC=1 docker compose up
```

This command will launch all containers required to run DataLens, and the UI will be available on http://localhost:8080 (default user and password is `admin`, `admin`).

<details>
      <summary>Using different port for UI</summary>
If you want to use a different port (e.g. `8081`), you can set it using the `UI_PORT` env variable:
      
```bash
UI_PORT=8081 docker compose up
```
</details>

However, for production usage we recommend generating a compose file with random secrets:

```bash
# generate random secrets with openssl, store it to .env file and prepare production compose template
./init.sh --hc

# and then run production compose
docker compose -f ./docker-compose.production.yaml up -d

# you can also generate and run production compose file with one command
./init.sh --hc --up
```

Randomly generated admin password will be stored in the `.env` file and printed to terminal.

**Note:** You can find all script arguments by running the `./init.sh --help` command

<details>
      <summary>Notice on Highcharts usage</summary>

      Highcharts is a proprietary commercial product. If you enable Highcharts in your DataLens instance (with `HC=1` variable), you should comply with Highcharts license (https://github.com/highcharts/highcharts/blob/master/license.txt).

      When Highcharts is disabled in DataLens, we use D3.js instead. However, currently only a few visualization types are compatible with D3.js. We are actively working on adding D3 support to additional visualizations and are going to completely replace Highcharts with D3 in DataLens.

</details>

<details>
            <summary>How to enable Yandex Maps</summary>

Available since [release v1.11.0](https://github.com/datalens-tech/datalens/releases/tag/v1.11.0)

Use the following container parameters for launch:

| Parameter            | Description                                                     | Values        |
| -------------------- | --------------------------------------------------------------- | ------------- |
| `YANDEX_MAP_ENABLED` | Enable usage of Yandex Maps visualization                       | `1` or `true` |
| `YANDEX_MAP_TOKEN`   | Yandex Maps [API key](https://yandex.ru/dev/jsapi-v2-1/doc/en/) | `<string>`    |

```bash
YANDEX_MAP_ENABLED=1 YANDEX_MAP_TOKEN=XXXXXXXXX docker compose up

# or if you use init.sh script
./init.sh --yandex-map --yandex-map-token XXXXXXXXX --up
```
</details>

## How to update

To update DataLens to the latest version, simply pull git repository and restart the containers:

```bash
git pull

# if you use base compose file
docker compose up

# if you use init.sh script
./init.sh --up
```

All your user settings, connections, and created objects will be preserved as they are stored in the `db-postgres` docker volume. The update process does not affect your data.

## Deploy with Helm chart in k8s cluster

For deployment in a Kubernetes cluster, you can use Helm chart from an OCI-compatible package registry

First install Helm release:

```bash
# generating rsa keys for auth service and temporal
AUTH_TOKEN_PRIVATE_KEY=$(openssl genpkey -algorithm RSA -pkeyopt "rsa_keygen_bits:4096" 2>/dev/null)
AUTH_TOKEN_PUBLIC_KEY=$(echo "${AUTH_TOKEN_PRIVATE_KEY}" | openssl rsa -pubout 2>/dev/null)
TEMPORAL_AUTH_PRIVATE_KEY=$(openssl genpkey -algorithm RSA -pkeyopt "rsa_keygen_bits:4096" 2>/dev/null)
TEMPORAL_AUTH_PUBLIC_KEY=$(echo "${TEMPORAL_AUTH_PRIVATE_KEY}" | openssl rsa -pubout 2>/dev/null)

helm upgrade --install datalens oci://ghcr.io/datalens-tech/helm/datalens \
--namespace datalens --create-namespace \
--set "secrets.AUTH_TOKEN_PRIVATE_KEY=${AUTH_TOKEN_PRIVATE_KEY}" \
--set "secrets.AUTH_TOKEN_PUBLIC_KEY=${AUTH_TOKEN_PUBLIC_KEY}" \
--set "secrets.TEMPORAL_AUTH_PRIVATE_KEY=${TEMPORAL_AUTH_PRIVATE_KEY}" \
--set "secrets.TEMPORAL_AUTH_PUBLIC_KEY=${TEMPORAL_AUTH_PUBLIC_KEY}"
```

**Note:** Helm template engine does not provide built-in functions for creating private and public RSA keys.

Update Helm release:

```bash
helm upgrade datalens oci://ghcr.io/datalens-tech/helm/datalens --namespace datalens
```

Admin login and password will be stored in `datalens-secrets` Kubernetes secret resource

## Parts of the project

DataLens consists of three main parts:

- [**UI**](https://github.com/datalens-tech/datalens-ui) is a SPA application with corresponding Node.js part. It provides user interface, proxies requests from users to backend services, and also applies some light data postprocessing for charts.
- [**Backend**](https://github.com/datalens-tech/datalens-backend) is a set of Python applications and libraries. It is responsible for connecting to data sources, generating queries for them, and post-processing the data (including formula calculations). The result of this work is an abstract dataset that can be used in UI for charts data request.
- [**UnitedStorage (US)**](https://github.com/datalens-tech/datalens-us) is a Node.js service that uses PostgreSQL to store metadata and configuration of all DataLens objects.
- [**Auth**](https://github.com/datalens-tech/datalens-auth) is a Node.js service that provides authentication/authorization layer for DataLens.
- [**MetaManager**](https://github.com/datalens-tech/datalens-meta-manager) is a Node.js service that provides workflow workers for export/import workbooks.

## What's already available

We are releasing DataLens with a minimal set of available connectors (ClickHouse, ClickHouse over YTsaurus, and PostgreSQL) as well as other core functionality such as data processing engine, user interface, and minimal auth layer. We are planning to add missing features based on our understanding of community priorities and your feedback.

## Cloud Providers
Below is a list of cloud providers offering DataLens as a service:
1. [Yandex Cloud](https://datalens.yandex.cloud) platform

## Authentication
DataLens supports native authentication which is enabled by default.

Use the following command to start DataLens with authentication and auto-generated secrets for production:

```bash
./init.sh --up
```

**Notice:** the updated `.env` file after initialization: it contains auth access keys and admin password. Keep that file safe and do not share its contents.

After that you can login to DataLens on http://localhost:8080 using the user credentials:

| Username | Password                               |
| -------- | -------------------------------------- |
| `admin`  | `<AUTH_ADMIN_PASSWORD from .env file>` |

You can use the same credentials to add new users using admin control panel at http://localhost:8080/.

By default in DataLens with authentication enabled, all users have a `datalens.viewer` role. This allows them to use all collections and workbooks in read-only mode. They are not allowed to create or modify any objects with this role. To be able to create or edit objects, they need to have a `datalens.editor` or `datalens.admin` role. To grant these roles, open DataLens at http://localhost:8080, then find the user to whom you want to grant a new role, click on the user, and select the new role.

DataLens supports the following roles:

- `datalens.viewer`: allows viewing all collections and workbooks, but does not allow creating or editing any object.
- `datalens.editor`: includes the `datalens.viewer` role and allows creating, editing and deleting any object.
- `datalens.admin`: currently equal to `datalens.editor`. In the future releases, users with this role will be able to manage system-wide settings and perform administrative functions.

## FAQ

#### Where does DataLens store its metadata?

We use the `db-postgres` docker volume to store PostgreSQL data. If you want to start over, you can delete this volume: it will be recreated with demo objects on the next start of the `datalens` compose.

#### How can I use a custom domain or IP address for the UI container endpoint?

If you use reverse proxy with HTTPS and custom domain, you can generate docker compose file with these arguments:

`./init.sh --domain <domain> --https`

If you use IP address as endpoint, you can generate docker compose file with this argument:

`./init.sh --ip <ip>`

#### How can I specify external PostgreSQL database?

You can check a production deployment example with high availability in a Kubernetes cluster using Tofu (Terraform) in the `terraform/` directory.

If you want to use external PostgreSQL database with Docker, you can specify its connection string in environment variables:

```bash
# .env file example

POSTGRES_HOST=
POSTGRES_PORT=6432
POSTGRES_USER=pg-user
POSTGRES_PASSWORD=
```

If you want to override default database names, you can specify it in environment variables:

```bash
# .env file example

POSTGRES_DB_COMPENG='pg-compeng-db'
POSTGRES_DB_AUTH='pg-auth-db'
POSTGRES_DB_US='pg-us-db'
POSTGRES_DB_META_MANAGER='pg-meta-manager-db'
POSTGRES_DB_TEMPORAL='pg-temporal-db'
POSTGRES_DB_TEMPORAL_VISIBILITY='pg-temporal-visibility-db'
POSTGRES_DB_DEMO='pg-demo-db'
```

After that, you can start DataLens with the following command:

```bash
./init.sh --postgres-external --up
```

It generates a `docker-compose.production.yaml` compose file without postgres container.

#### How can I specify custom certificate for connecting to database?

You can add additional certificates with special argument `--postgres-cert` for `./init.sh` script. This certificate will be mounted to all containers and will be used to connect to the database.

```bash
./init.sh --postgres-external --postgres-ssl --postgres-cert ./cert.pem --up
```

If containers do not start even though you provided correct certificates, try to change `POSTGRES_ARGS` variable for connection in `.env` file to `?sslmode=prefer`.

#### I use external PostgreSQL database and the app doesn't start. What could be the reason?

We use some PostgresSQL extensions for the metadata database. Check your database user's rights for installing extensions or install them manually:

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

By default, automatic extensions installation is disabled with the variable `SKIP_INSTALL_DB_EXTENSIONS=1`. You can enable automatic installation by setting the variable `SKIP_INSTALL_DB_EXTENSIONS=0` in the `.env` file. Applications check for these extensions at startup and try to install them if they haven't been already installed.

If this attempt is unsuccessful, try to install dependencies by database admin.

If you're using a managed database, it's also possible that extensions for your database cluster are controlled by an external system and could be changed only using its UI or API. In such a case, consult the documentation for the managed database service you're using.

#### Why do I see two compose files: docker-compose.yaml & docker-compose.dev.yaml?

File `docker-compose.dev.yaml` is a special compose file that is needed only for development purposes. When you run DataLens in production mode, you always need to use `docker-compose.yaml` file or `./init.sh` script.

#### How can I disable authentication?

If you need to run DataLens without authentication (for development or testing purposes), you can use the `--disable-auth` flag with the init script:

```bash
./init.sh --disable-auth --up
```

This will generate a compose file without the authentication service, allowing direct access to DataLens without login credentials.

#### How can I disable workbook export?

If you want to disable the workbook export feature to save resources or simplify your deployment, use the `--disable-workbook-export` flag:

```bash
./init.sh --disable-workbook-export --up
```

This will disable the workbook export to JSON feature and remove the meta-manager and ui-api services from the deployment.

#### How can I disable Temporal service for limited resources systems?

For systems with limited resources, you can disable the Temporal workflow service using the `--disable-temporal` flag:

```bash
./init.sh --disable-temporal --up
```

This will remove the Temporal service from the deployment, which significantly reduces resource usage. Note that disabling Temporal will also automatically disable the workbook export feature, as it depends on Temporal workflows.

#### What are the minimum system requirements?

* datalens-ui - 512 MB RAM

* datalens-data-api - 1 GB RAM

* datalens-control-api - 512 MB RAM

* datalens-us - 512 MB RAM

* datalens-postgres - 512 MB RAM

Minimal configuration:

* RAM - 4 GB

* CPU - 2 CORES

These are the minimal basic system requirements for OpenSource DataLens installation. Actual resource consumption depends on the complexity of requests, connection types, number of users, and processing speed at the source level.
