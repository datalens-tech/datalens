resource "yandex_logging_group" "logging" {
  for_each = toset(local.k8s_logging ? ["main"] : [])

  name             = "${local.service}-k8s-app-logging-group"
  folder_id        = local.folder_id
  retention_period = "240h"
}

resource "helm_release" "logging" {
  for_each = toset(local.k8s_logging ? ["main"] : [])

  name = "yc-logging-controller"

  chart = "fluent-bit"

  version    = "2.1.7-3"
  repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/fluent-bit"

  namespace        = "logging"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    yamlencode({
      loggingGroupId = yandex_logging_group.logging["main"].id
      loggingFilter  = yandex_kubernetes_cluster.this.id

      auth = {
        json = jsonencode({
          id                 = yandex_iam_service_account_key.this["logging"].id
          service_account_id = yandex_iam_service_account.this["logging"].id
          created_at         = yandex_iam_service_account_key.this["logging"].created_at
          key_algorithm      = "RSA_4096"
          public_key         = yandex_iam_service_account_key.this["logging"].public_key
          private_key        = yandex_iam_service_account_key.this["logging"].private_key
        })
      }
    })
  ]

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
}

