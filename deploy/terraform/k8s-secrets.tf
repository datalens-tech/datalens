resource "helm_release" "secrets" {
  name = "external-secrets-controller"

  chart = "external-secrets"

  namespace        = "external-secrets"
  create_namespace = true
  cleanup_on_fail  = true

  version    = "0.9.20"
  repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/external-secrets/chart"
}

resource "kubernetes_secret" "secrets" {
  metadata {
    name      = "yc-auth"
    namespace = "external-secrets"
  }

  data = {
    authorized-key = jsonencode({
      id                 = yandex_iam_service_account_key.this["eso"].id
      service_account_id = yandex_iam_service_account.this["eso"].id
      created_at         = yandex_iam_service_account_key.this["eso"].created_at
      key_algorithm      = "RSA_4096"
      public_key         = yandex_iam_service_account_key.this["eso"].public_key
      private_key        = yandex_iam_service_account_key.this["eso"].private_key
    })
  }

  type = "kubernetes.io/generic"

  depends_on = [
    helm_release.secrets,
  ]
}

resource "kubernetes_manifest" "secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "cluster-secrets-store"
    }
    spec = {
      provider = {
        yandexlockbox = {
          auth = {
            authorizedKeySecretRef = {
              name      = "yc-auth"
              key       = "authorized-key"
              namespace = "external-secrets"
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.secrets,
    kubernetes_secret.secrets,
  ]
}

locals {
  secrets = concat(
    [
      { key = "US_MASTER_TOKEN", length = 32 },
      { key = "CONTROL_API_CRYPTO_KEY", length = 32, type = "base64" },
    ],
    local.is_zitadel_enabled ? [
      { key = "ZITADEL_MASTERKEY", length = 32 },
      { key = "ZITADEL_ROOT_PASSWORD", length = 32, type = "special" },
      { key = "ZITADEL_COOKIE_SECRET", length = 32 },
  ] : [])
}

resource "random_password" "secrets" {
  for_each = { for s in local.secrets : s.key => s }

  length           = each.value.length
  special          = try(each.value.type, null) == "special"
  override_special = "_"
  min_special      = 1

  lifecycle {
    ignore_changes = [
      special,
      length,
    ]
  }
}

resource "yandex_lockbox_secret" "this" {
  name = "${local.service}-k8s-secrets"
}

locals {
  pg_hosts = [for key, host in yandex_mdb_postgresql_cluster.this.host : host.fqdn]
}

resource "yandex_lockbox_secret_version" "this" {
  secret_id = yandex_lockbox_secret.this.id

  dynamic "entries" {
    for_each = local.secrets

    content {
      key        = entries.value.key
      text_value = try(entries.value.type, null) == "base64" ? base64encode(random_password.secrets[entries.value.key].result) : random_password.secrets[entries.value.key].result
    }
  }

  dynamic "entries" {
    for_each = local.pg_users

    content {
      key        = "PG_DSN_CLUSTER_${upper(replace(replace(entries.value, "pg-", ""), "-user", ""))}"
      text_value = "postgres://${entries.value}:${random_password.pg_password[entries.value].result}@c-${yandex_mdb_postgresql_cluster.this.id}.rw.mdb.yandexcloud.net:6432/${yandex_mdb_postgresql_database.this[entries.value].name}"
    }
  }

  dynamic "entries" {
    for_each = local.pg_users

    content {
      key        = "PG_DSN_LIST_${upper(replace(replace(entries.value, "pg-", ""), "-user", ""))}"
      text_value = join(",", [for host in local.pg_hosts : "postgres://${entries.value}:${random_password.pg_password[entries.value].result}@${host}:6432/${yandex_mdb_postgresql_database.this[entries.value].name}"])
    }
  }

  dynamic "entries" {
    for_each = local.pg_users

    content {
      key        = "PG_PASSWORD_${upper(replace(replace(entries.value, "pg-", ""), "-user", ""))}"
      text_value = random_password.pg_password[entries.value].result
    }
  }

  dynamic "entries" {
    for_each = local.pg_users

    content {
      key        = "PG_HOST_${upper(replace(replace(entries.value, "pg-", ""), "-user", ""))}"
      text_value = "c-${yandex_mdb_postgresql_cluster.this.id}.rw.mdb.yandexcloud.net"
    }
  }
}

resource "kubernetes_manifest" "lockbox" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"

    metadata = {
      name      = "external-secret-lockbox"
      namespace = "default"
    }

    spec = {
      refreshInterval = "5m"

      secretStoreRef = {
        name = "cluster-secrets-store"
        kind = "ClusterSecretStore"
      }

      target = {
        name = "k8s-lockbox-secret"
      }

      dataFrom = [{
        extract = {
          key = yandex_lockbox_secret.this.id
        }
      }]
    }
  }

  depends_on = [
    helm_release.secrets,
    kubernetes_secret.secrets,
  ]
}

resource "yandex_lockbox_secret" "zitadel" {
  for_each = toset(local.is_zitadel_enabled ? ["main"] : [])

  name = "${local.service}-k8s-zitadel-secrets"
}

resource "kubernetes_manifest" "lockbox-zitadel" {
  for_each = toset(local.is_zitadel_enabled ? ["main"] : [])

  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"

    metadata = {
      name      = "external-secret-lockbox-zitadel"
      namespace = "default"
    }

    spec = {
      refreshInterval = "5m"

      secretStoreRef = {
        name = "cluster-secrets-store"
        kind = "ClusterSecretStore"
      }

      target = {
        name = "k8s-lockbox-zitadel-secret"
      }

      dataFrom = [{
        extract = {
          key = yandex_lockbox_secret.zitadel["main"].id
        }
      }]
    }
  }

  depends_on = [
    helm_release.secrets,
    kubernetes_secret.secrets,
  ]
}


