resource "kubernetes_deployment" "us" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "us"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-us"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-us"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-us"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-us:${local.us_version}"
          name  = "app-us"

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

          readiness_probe {
            http_get {
              path = "/ping-db"
              port = 8080
            }

            initial_delay_seconds = 5
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
              cpu    = "0.5"
              memory = "256Mi"
            }
          }

          env {
            name  = "APP_INSTALLATION"
            value = "opensource"
          }
          env {
            name  = "APP_ENV"
            value = "prod"
          }
          env {
            name  = "APP_PORT"
            value = "8080"
          }
          env {
            name = "MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          env {
            name = "POSTGRES_DSN_LIST"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_DSN_LIST_US"
              }
            }
          }
          env {
            name  = "SKIP_INSTALL_DB_EXTENSIONS"
            value = "1"
          }
          env {
            name  = "USE_DEMO_DATA"
            value = "0"
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
            name = "AUTH_TOKEN_PUBLIC_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_TOKEN_PUBLIC_KEY"
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

resource "kubernetes_service" "us_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "us-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-us"
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
