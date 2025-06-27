resource "helm_release" "secrets" {
  name = "external-secrets-controller"

  chart = "external-secrets"

  namespace        = "external-secrets"
  create_namespace = true
  cleanup_on_fail  = true

  version    = "0.9.20"
  repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/external-secrets/chart"

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
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
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

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
  secrets = [
    { key = "US_MASTER_TOKEN", length = 32 },
    { key = "AUTH_MASTER_TOKEN", length = 32 },
    { key = "AUTH_ADMIN_PASSWORD", length = 32 },
    { key = "EXPORT_DATA_VERIFICATION_KEY", length = 32 },
    { key = "CONTROL_API_CRYPTO_KEY", length = 32, type = "base64" },
    { key = "AUTH_TOKEN", length = 4096, type = "rsa" },
    { key = "TEMPORAL_AUTH", length = 4096, type = "rsa" },
  ]
}

resource "random_password" "secrets" {
  for_each = { for s in [for ss in local.secrets : ss if try(ss.type, null) != "rsa"] : s.key => s }

  length  = each.value.length
  special = false

  lifecycle {
    ignore_changes = [
      min_special,
      override_special,
      special,
      length,
    ]
  }
}

resource "tls_private_key" "secrets" {
  for_each = { for s in [for ss in local.secrets : ss if try(ss.type, null) == "rsa"] : s.key => s }

  algorithm = "RSA"
  rsa_bits  = each.value.length
}

locals {
  secrets_data = flatten(concat(
    [for s in local.secrets : {
      key = s.key, value = try(s.type, null) == "base64" ? base64encode(random_password.secrets[s.key].result) : random_password.secrets[s.key].result
    } if try(s.type, null) != "rsa"],
    [for s in local.secrets : [
      { key = "${s.key}_PRIVATE_KEY", value = tls_private_key.secrets[s.key].private_key_pem },
      { key = "${s.key}_PUBLIC_KEY", value = tls_private_key.secrets[s.key].public_key_pem }
    ] if try(s.type, null) == "rsa"]
  ))
}

resource "yandex_lockbox_secret" "this" {
  name = "${local.service}-k8s-secrets"
}

locals {
  pg_hosts        = [for key, host in yandex_mdb_postgresql_cluster.this.host : host.fqdn]
  pg_cluster_host = "c-${yandex_mdb_postgresql_cluster.this.id}.rw.mdb.yandexcloud.net"
  pg_cluster_port = "6432"
}

resource "yandex_lockbox_secret_version" "this" {
  secret_id = yandex_lockbox_secret.this.id

  dynamic "entries" {
    for_each = local.secrets_data

    content {
      key        = entries.value.key
      text_value = entries.value.value
    }
  }

  dynamic "entries" {
    for_each = local.pg_databases

    content {
      key        = "POSTGRES_DSN_CLUSTER_${upper(replace(replace(replace(entries.key, "pg-", ""), "-db", ""), "-", "_"))}"
      text_value = "postgres://${entries.value.user}:${random_password.pg_password[entries.value.user].result}@${local.pg_cluster_host}:${local.pg_cluster_port}/${yandex_mdb_postgresql_database.this[entries.key].name}?sslmode=verify-full"
    }
  }

  dynamic "entries" {
    for_each = local.pg_databases

    content {
      key        = "POSTGRES_DSN_LIST_${upper(replace(replace(replace(entries.key, "pg-", ""), "-db", ""), "-", "_"))}"
      text_value = join(",", [for host in local.pg_hosts : "postgres://${entries.value.user}:${random_password.pg_password[entries.value.user].result}@${host}:${local.pg_cluster_port}/${yandex_mdb_postgresql_database.this[entries.key].name}?sslmode=verify-full"])
    }
  }

  dynamic "entries" {
    for_each = local.pg_users

    content {
      key        = "POSTGRES_PASSWORD_${upper(replace(replace(replace(entries.value, "pg-", ""), "-user", ""), "-", "_"))}"
      text_value = random_password.pg_password[entries.value].result
    }
  }
}

resource "kubernetes_manifest" "lockbox" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"

    metadata = {
      name      = "external-secret-lockbox"
      namespace = kubernetes_namespace.this.metadata[0].name
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
