resource "kubernetes_deployment" "auth" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "auth"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-auth"
    }
  }

  spec {
    replicas = 3
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 3
        max_unavailable = 0
      }
    }
    selector {
      match_labels = {
        app = "app-auth"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-auth"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-auth:${local.auth_version}"
          name  = "app-auth"

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
              path = "/ping"
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
            name = "MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_MASTER_TOKEN"
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
            name = "POSTGRES_DSN_LIST"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_DSN_LIST_AUTH"
              }
            }
          }
          env {
            name  = "SKIP_INSTALL_DB_EXTENSIONS"
            value = "1"
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8080"
          }
          env {
            name  = "UI_APP_ENDPOINT"
            value = "https://${local.domain}"
          }
          env {
            name = "AUTH_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_ADMIN_PASSWORD"
              }
            }
          }
          env {
            name = "TOKEN_PRIVATE_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_TOKEN_PRIVATE_KEY"
              }
            }
          }
          env {
            name = "TOKEN_PUBLIC_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "AUTH_TOKEN_PUBLIC_KEY"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "auth_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "auth-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-auth"
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
