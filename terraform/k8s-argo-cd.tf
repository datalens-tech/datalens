resource "helm_release" "argo-cd" {
  for_each = toset(local.k8s_argo_cd ? ["main"] : [])

  name = "argo-cd"

  chart = "argo-cd"

  version    = "7.3.11-2"
  repository = "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart"

  namespace        = kubernetes_namespace.this.metadata[0].name
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    yamlencode({
      server = {
        service = {
          type          = "NodePort"
          nodePortHttp  = 30070
          nodePortHttps = 30743
        }
      }
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
}

