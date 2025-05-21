resource "kubernetes_deployment" "ui-api" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "ui-api"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-ui-api"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-ui-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-ui-api"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-ui:${local.ui_version}"
          name  = "app-ui-api"

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8080
            }

            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 10

            success_threshold = 1
            failure_threshold = 3
          }

          resources {
            limits = {
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.25"
              memory = "256Mi"
            }
          }

          env {
            name  = "APP_INSTALLATION"
            value = "opensource"
          }
          env {
            name  = "APP_ENV"
            value = "production"
          }
          env {
            name  = "APP_MODE"
            value = "api"
          }
          env {
            name  = "AUTH_POLICY"
            value = "disabled"
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8080"
          }
          env {
            name  = "BI_API_ENDPOINT"
            value = "http://control-api-cip:8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ui-api_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "ui-api-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-ui-api"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
