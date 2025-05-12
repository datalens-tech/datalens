resource "helm_release" "monitoring" {
  for_each = toset(local.k8s_monitoring ? ["main"] : [])

  name = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "62.7.0"

  timeout          = 240
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true

  set {
    name  = "grafana.enabled"
    value = false
  }

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [
    yandex_kubernetes_cluster.this,
  ]
}
