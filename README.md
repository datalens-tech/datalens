# DataLens

**DataLens** is a modern business intelligence and data visualization system. It was developed and extensively used as a primary BI tool in Yandex and is also available as a part of Yandex Cloud platform.

Now it is available as an Open Source project.

## Getting started

### Installing Docker

DataLens requires Docker to be installed. Follow these instructions depending on the platform you use:

- [macOS](https://docs.docker.com/desktop/install/mac-install/)
- [Linux](https://docs.docker.com/engine/install/)
- [Windows](https://docs.docker.com/desktop/install/windows-install/)

### Running containers

Use the following command to start DataLens containers:

```bash
git clone https://github.com/datalens-tech/datalens && cd datalens

# with demo database
HC=1 docker compose up

# with external database
US_POSTGRES_DSN_LIST="postgres://{user}:{password}@{host}:{port}/{database}?ssl=true" HC=1 docker compose up
```

This command will launch all containers required to run DataLens and UI will be available on http://localhost:8080

<details>
      <summary>Notice on Highcharts usage</summary>

      Highcharts is a proprietary commercial product. If you enable highcharts in your DataLens instance (with `HC=1`` variable), you should comply with Highcharts license (https://github.com/highcharts/highcharts/blob/master/license.txt).

      When Highcharts is disabled in DataLens, we use D3.js instead. However, currently only few visualization types are compatible with D3.js. We are actively working on adding D3 support to additional visualizations and are going to completely replace Highcharts with D3 in DataLens.

</details>

## Parts of the project

DataLens consists of the three main parts:

- [**UI**](https://github.com/datalens-tech/datalens-ui) is a SPA application with corresponding Node.js part. It provides user interface, proxies requests from users to backend services and also applies some light data postprocessing for charts.
- [**Backend**](https://github.com/datalens-tech/datalens-backend) is a set of Python applications and libraries. It is responsible for connecting to data sources, generating queries for them and post-processing the data (including formula calculations). The result of this work is an abstract dataset that can be used in UI for charts data request.
- [**UnitedStorage (US)**](https://github.com/datalens-tech/datalens-us) is a Node.js service that uses PostgreSQL to store metadata and configuration of all DataLens objects.

## What's already available

We are releasing DataLens with first minimal set of available connectors (clickhouse, clickhouse over ytsaurus and postgresql) as well as other core functionality such as data processing engine and user interface. However, to kick off this project in a reasonable timeframe we chose to drop some of the features out of the first release: this version does not contain middleware and components for user sessions, object ACLs and multitenancy (although code contains entry-points for such extensions). We are planning to add missing features based on our understanding of community priorities and your feedback.

## FAQ

**Where can I find persistent application data storage?**

We use the `us-data` folder to store PostgreSQL data. If you want to start over, you can delete this folder: it will be recreated with demo objects on the next start of the `datalens-us` container.

**I use external database and `datalens-us` container does not start.**

This may be caused because of external database user doesn't have permission to install extensions. Use the additional parameter `US_SKIP_INSTALL_DB_EXTENSIONS=1` to skip this step, but in this case you should manually install extensions before launching the app:

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

**My PostgresSQL cluster has multiple hosts, how can I specify them in `METADATA_POSTGRES_DSN_LIST` param?**

Yes, you can write all cluster hosts separated by commas:

`US_POSTGRES_DSN_LIST="postgres://{user}:{password}@{host_1}:{port}/{database}?ssl=true,postgres://{user}:{password}@{host_2}:{port}/{database}?ssl=true,postgres://{user}:{password}@{host_3}:{port}/{database}?ssl=true" ...`

**How can I specify custom certificate for connecting to metadata database?**

You can add additional certificates for database to `./us-extra-certs/root.crt`, they will be used for connecting to database from the `datalens-us` container.