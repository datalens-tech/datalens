resource "kubernetes_deployment" "meta-manager" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "meta-manager"
    namespace = kubernetes_namespace.this.metadata[0].name
    labels = {
      app = "app-meta-manager"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "app-meta-manager"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-meta-manager"
        }
      }
      spec {
        container {
          image = "ghcr.io/datalens-tech/datalens-meta-manager:${local.meta_manager_version}"
          name  = "app-meta-manager"

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
            name = "US_MASTER_TOKEN"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "US_MASTER_TOKEN"
              }
            }
          }
          env {
            name = "EXPORT_DATA_VERIFICATION_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "EXPORT_DATA_VERIFICATION_KEY"
              }
            }
          }
          env {
            name = "POSTGRES_DSN_LIST"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "POSTGRES_DSN_LIST_META_MANAGER"
              }
            }
          }
          env {
            name  = "US_ENDPOINT"
            value = "http://us-cip:8080"
          }
          env {
            name  = "UI_API_ENDPOINT"
            value = "http://ui-api-cip:8080"
          }
          env {
            name  = "TEMPORAL_ENDPOINT"
            value = "temporal-cip:7233"
          }
          env {
            name  = "TEMPORAL_AUTH_ENABLED"
            value = "true"
          }
          env {
            name = "TEMPORAL_AUTH_PRIVATE_KEY"
            value_from {
              secret_key_ref {
                name = "k8s-lockbox-secret"
                key  = "TEMPORAL_AUTH_PRIVATE_KEY"
              }
            }
          }
          env {
            name  = "AUTH_ENABLED"
            value = "true"
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
        }
      }
    }
  }
}

resource "kubernetes_service" "meta-manager_service" {
  for_each = toset(local.k8s_cluster_ready ? ["main"] : [])

  metadata {
    name      = "meta-manager-cip"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  spec {
    selector = {
      app = "app-meta-manager"
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
