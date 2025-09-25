resource "kubernetes_deployment" "ui" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "ui"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-ui"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-ui"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-ui:${local.ui_version}"
          name  = "app-ui"

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
            value = "full"
          }
          env {
            name  = "AUTH_POLICY"
            value = "disabled"
          }
          env {
            name  = "RELEASE_VERSION"
            value = local.release_version
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8080"
          }
          env {
            name  = "BI_API_ENDPOINT"
            value = "http://control-api-cip:8080"
          }
          env {
            name  = "BI_DATA_ENDPOINT"
            value = "http://data-api-cip:8080"
          }
          env {
            name  = "META_MANAGER_ENDPOINT"
            value = "http://meta-manager-cip:8080"
          }
          env {
            name  = "EXPORT_WORKBOOK_ENABLED"
            value = "true"
          }
          env {
            name  = "AUTH_ENABLED"
            value = "true"
          }
          env {
            name  = "AUTH_ENDPOINT"
            value = "http://auth-cip:8080"
          }
          env {
            name  = "AUTH_SIGNUP_DISABLED"
            value = local.is_signup_disabled ? "true" : "false"
          }
          env {
            name = "AUTH_TOKEN_PUBLIC_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_TOKEN_PUBLIC_KEY"
              }
            }
          }
          env {
            name = "US_MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          env {
            name = "AUTH_MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_MASTER_TOKEN"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ui_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "ui-np"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-ui"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      node_port   = 30080
    }
    type = "NodePort"
  }
}
