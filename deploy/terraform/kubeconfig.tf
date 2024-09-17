provider "shell" {
  interpreter = ["/usr/bin/env", "bash", "-c"]
}

locals {
  cluster_endpoint   = local.k8s_cluster_endpoint
  cluster_trusted_ca = base64encode(local.k8s_cluster_ca_certificate)

  cli_command      = "yc"
  cli_command_args = ["k8s", "create-token", "--profile=${local.profile}"]

  kubeconfig_path = "${path.module}/kubeconfig.conf"
}

locals {
  kubeconfig = {
    apiVersion = "v1",
    kind       = "Config"
    clusters = [
      {
        name = "yc-managed-k8s-${yandex_kubernetes_cluster.this.id}",
        cluster = {
          certificate-authority-data = local.cluster_trusted_ca
          server                     = local.cluster_endpoint
        }
      }
    ],
    contexts = [
      {
        name = "yc-managed-k8s-backends",
        context = {
          cluster = "yc-managed-k8s-${yandex_kubernetes_cluster.this.id}",
          user    = "yc-managed-k8s-${yandex_kubernetes_cluster.this.id}",
        }
      }
    ],
    current-context = "yc-managed-k8s-backends",
    preferences     = {},
    users = [
      {
        name = "yc-managed-k8s-${yandex_kubernetes_cluster.this.id}",
        user = {
          exec = {
            apiVersion         = "client.authentication.k8s.io/v1beta1",
            command            = local.cli_command,
            args               = local.cli_command_args,
            provideClusterInfo = false
          }
        }
      }
    ]
  }
}

data "shell_script" "kubeconfig" {
  depends_on = [
    yandex_vpc_security_group.this
  ]

  lifecycle_commands {
    read = <<-CMD
    set -euo pipefail
    echo "$KUBECONFIG_DATA" > "$KUBECONFIG_FILE"
    echo "{\"path\": \"${local.kubeconfig_path}\"}"
    CMD
  }
  environment = {
    KUBECONFIG_DATA = yamlencode(local.kubeconfig)
    KUBECONFIG_FILE = local.kubeconfig_path
  }
}
