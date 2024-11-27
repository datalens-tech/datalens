locals {
  ingress_postgresql = [
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
  ]
  egress_postgresql = [
    { proto = "ANY", target = "self_security_group", from_port = 0, to_port = 65535, desc = "self" },
    { proto = "ANY", cidr_v4 = local.v4_subnets_cidr_blocks, from_port = 0, to_port = 65535, desc = "subnets" },
  ]
}

resource "yandex_vpc_security_group" "postgresql" {
  name       = "${local.service}-postgresql-sg"
  network_id = yandex_vpc_network.this.id

  dynamic "ingress" {
    for_each = local.ingress_postgresql

    content {
      protocol          = ingress.value.proto
      v4_cidr_blocks    = try(ingress.value.cidr_v4, [])
      predefined_target = try(ingress.value.target, null)
      port              = try(ingress.value.port, null)
      from_port         = try(ingress.value.from_port, null)
      to_port           = try(ingress.value.to_port, null)
      description       = try(ingress.value.desc, null)

    }
  }

  dynamic "egress" {
    for_each = local.egress_postgresql

    content {
      protocol          = egress.value.proto
      v4_cidr_blocks    = try(egress.value.cidr_v4, [])
      predefined_target = try(egress.value.target, null)
      port              = try(egress.value.port, null)
      from_port         = try(egress.value.from_port, null)
      to_port           = try(egress.value.to_port, null)
      description       = try(egress.value.desc, null)
    }
  }
}

resource "yandex_mdb_postgresql_cluster" "this" {
  name        = "${local.service}-postgresql"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.this.id

  security_group_ids = [yandex_vpc_security_group.postgresql.id]

  config {
    version = 16

    resources {
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 20
    }

    postgresql_config = {
      max_connections = 400
    }

    access {
      data_lens     = true
      data_transfer = false
      web_sql       = true
    }

    performance_diagnostics {
      enabled                      = true
      sessions_sampling_interval   = 1
      statements_sampling_interval = 60
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "MON"
    hour = 4
  }

  dynamic "host" {
    for_each = local.zones

    content {
      name      = "pg-host-${host.value}"
      zone      = host.value
      subnet_id = yandex_vpc_subnet.this[host.value].id
    }
  }

  timeouts {
    create = "60m"
    update = "60m"
  }
}

locals {
  pg_us_user      = "pg-us-user"
  pg_compeng_user = "pg-compeng-user"
  pg_zitadel_user = "pg-zitadel-user"
  pg_demo_user    = "pg-demo-user"

  pg_users = concat(
    [
      local.pg_us_user, local.pg_compeng_user
    ],
    local.is_zitadel_enabled ? [local.pg_zitadel_user] : [],
    local.is_create_demo_db ? [local.pg_demo_user] : []
  )

  pg_db_extension = [
    "pg_trgm",
    "btree_gin",
    "btree_gist",
    "uuid-ossp",
  ]
}

resource "random_password" "pg_password" {
  for_each = toset(local.pg_users)

  length  = 32
  special = false

  lifecycle {
    ignore_changes = [
      special,
      length,
    ]
  }
}

resource "yandex_mdb_postgresql_user" "this" {
  for_each = toset(local.pg_users)

  cluster_id = yandex_mdb_postgresql_cluster.this.id
  name       = each.key
  password   = random_password.pg_password[each.key].result

  conn_limit = 80
}

resource "yandex_mdb_postgresql_database" "this" {
  for_each = toset(local.pg_users)

  name = replace(each.key, "-user", "-db")

  cluster_id = yandex_mdb_postgresql_cluster.this.id
  owner      = yandex_mdb_postgresql_user.this[each.key].name

  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"

  dynamic "extension" {
    for_each = local.pg_db_extension

    content {
      name = extension.value
    }
  }
}

resource "kubernetes_job" "postgresql_demo_data" {
  for_each = toset(local.is_create_demo_db && local.is_install_demo_data ? ["main"] : [])

  metadata {
    name = "demo-data-job"
  }
  spec {
    template {
      metadata {
        name = "demo-data-job-job"
      }
      spec {
        container {
          name  = "demo-data-job-job"
          image = "ghcr.io/datalens-tech/datalens:1.16.0-demo-data"

          env {
            name  = "POSTGRES_PORT"
            value = "6432"
          }

          env {
            name  = "POSTGRES_USER"
            value = local.pg_demo_user
          }

          env {
            name  = "POSTGRES_DB"
            value = replace(local.pg_demo_user, "-user", "-db")
          }

          env {
            name = "POSTGRES_HOST"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "PG_HOST_DEMO"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "PG_PASSWORD_DEMO"
              }
            }
          }
        }
        restart_policy = "OnFailure"
      }
    }

    backoff_limit           = 5
    active_deadline_seconds = 600
  }
}
