resource "yandex_logging_group" "logging" {
  name      = "${local.service}-k8s-app-logging-group"
  folder_id = local.folder_id
}

resource "helm_release" "logging" {
  name = "yc-logging-controller"

  chart = "fluent-bit"

  version    = "2.1.7-3"
  repository = "oci://${local.cr_endpoint}/yc-marketplace/yandex-cloud/fluent-bit"

  namespace        = "logging"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "loggingGroupId"
    value = yandex_logging_group.logging.id
  }

  set {
    name  = "loggingFilter"
    value = yandex_kubernetes_cluster.this.id
  }

  set {
    name = "auth.json"
    value = replace(replace(replace(replace(jsonencode({
      id                 = yandex_iam_service_account_key.this["logging"].id
      service_account_id = yandex_iam_service_account.this["logging"].id
      created_at         = yandex_iam_service_account_key.this["logging"].created_at
      key_algorithm      = "RSA_4096"
      public_key         = yandex_iam_service_account_key.this["logging"].public_key
      private_key        = yandex_iam_service_account_key.this["logging"].private_key
      # fix helm chart error with missed escaping json
    }), ",", "\\,"), "\\n", "\\\\n"), "{", "\\{"), "}", "\\}")
  }

  depends_on = [
    data.shell_script.kubeconfig,
  ]
}
