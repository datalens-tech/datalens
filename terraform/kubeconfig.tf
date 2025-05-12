locals {
  cluster_endpoint   = local.k8s_cluster_endpoint
  cluster_trusted_ca = base64encode(local.k8s_cluster_ca_certificate)

  cli_command      = "yc"
  cli_command_args = ["--no-browser", "k8s", "create-token", "--profile=${local.profile}"]

  kubeconfig_path = "${path.module}/kubeconfig.conf"
}

locals {
  kubeconfig = yamlencode({
    apiVersion = "v1"
    clusters = [{
      name = "cluster"
      cluster = {
        "server"                     = local.cluster_endpoint
        "certificate-authority-data" = local.cluster_trusted_ca
      }
    }]
    users = [{
      name = "user"
      user = {
        exec = {
          apiVersion         = "client.authentication.k8s.io/v1beta1",
          command            = local.cli_command,
          args               = local.cli_command_args,
          provideClusterInfo = false
          env                = null
        }
      }
    }]
    contexts = [{
      name = upper(local.service),
      context = {
        cluster = "cluster",
        user    = "user",
      }
    }],
    apiVersion  = "v1",
    kind        = "Config",
    preferences = {},
  })
}

resource "local_file" "kubeconfig" {
  for_each = toset(local.k8s_kubeconfig ? ["main"] : [])

  content         = local.kubeconfig
  filename        = local.kubeconfig_path
  file_permission = "0600"
}
